#  Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
#  See https://llvm.org/LICENSE.txt for license information.
#  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

try:
  from typing import Optional, Sequence

  import inspect

  from ..ir import *
except ImportError as e:
  raise RuntimeError("Error loading imports from extension module") from e

ARGUMENT_ATTRIBUTE_NAME = "arg_attrs"
RESULT_ATTRIBUTE_NAME = "res_attrs"

class ModuleOp:
  """Specialization for the module op class."""

  def __init__(self, *, loc=None, ip=None):
    super().__init__(self.build_generic(results=[], operands=[], loc=loc,
                                        ip=ip))
    body = self.regions[0].blocks.append()

  @property
  def body(self):
    return self.regions[0].blocks[0]


class FuncOp:
  """Specialization for the func op class."""

  def __init__(self,
               name,
               type,
               *,
               visibility=None,
               body_builder=None,
               loc=None,
               ip=None):
    """
    Create a FuncOp with the provided `name`, `type`, and `visibility`.
    - `name` is a string representing the function name.
    - `type` is either a FunctionType or a pair of list describing inputs and
      results.
    - `visibility` is a string matching `public`, `private`, or `nested`. None
      implies private visibility.
    - `body_builder` is an optional callback, when provided a new entry block
      is created and the callback is invoked with the new op as argument within
      an InsertionPoint context already set for the block. The callback is
      expected to insert a terminator in the block.
    """
    sym_name = StringAttr.get(str(name))

    # If the type is passed as a tuple, build a FunctionType on the fly.
    if isinstance(type, tuple):
      type = FunctionType.get(inputs=type[0], results=type[1])

    type = TypeAttr.get(type)
    sym_visibility = StringAttr.get(
        str(visibility)) if visibility is not None else None
    super().__init__(sym_name, type, sym_visibility, loc=loc, ip=ip)
    if body_builder:
      entry_block = self.add_entry_block()
      with InsertionPoint(entry_block):
        body_builder(self)

  @property
  def is_external(self):
    return len(self.regions[0].blocks) == 0

  @property
  def body(self):
    return self.regions[0]

  @property
  def type(self):
    return FunctionType(TypeAttr(self.attributes["type"]).value)

  @property
  def visibility(self):
    return self.attributes["sym_visibility"]

  @property
  def name(self):
    return self.attributes["sym_name"]

  @property
  def entry_block(self):
    if self.is_external:
      raise IndexError('External function does not have a body')
    return self.regions[0].blocks[0]

  def add_entry_block(self):
    """
    Add an entry block to the function body using the function signature to
    infer block arguments.
    Returns the newly created block
    """
    if not self.is_external:
      raise IndexError('The function already has an entry block!')
    self.body.blocks.append(*self.type.inputs)
    return self.body.blocks[0]

  @property
  def arg_attrs(self):
    return self.attributes[ARGUMENT_ATTRIBUTE_NAME]

  @arg_attrs.setter
  def arg_attrs(self, attribute: ArrayAttr):
    self.attributes[ARGUMENT_ATTRIBUTE_NAME] = attribute

  @property
  def arguments(self):
    return self.entry_block.arguments

  @property
  def result_attrs(self):
    return self.attributes[RESULT_ATTRIBUTE_NAME]

  @result_attrs.setter
  def result_attrs(self, attribute: ArrayAttr):
    self.attributes[RESULT_ATTRIBUTE_NAME] = attribute

  @classmethod
  def from_py_func(FuncOp,
                   *inputs: Type,
                   results: Optional[Sequence[Type]] = None,
                   name: Optional[str] = None):
    """Decorator to define an MLIR FuncOp specified as a python function.

    Requires that an `mlir.ir.InsertionPoint` and `mlir.ir.Location` are
    active for the current thread (i.e. established in a `with` block).

    When applied as a decorator to a Python function, an entry block will
    be constructed for the FuncOp with types as specified in `*inputs`. The
    block arguments will be passed positionally to the Python function. In
    addition, if the Python function accepts keyword arguments generally or
    has a corresponding keyword argument, the following will be passed:
      * `func_op`: The `func` op being defined.

    By default, the function name will be the Python function `__name__`. This
    can be overriden by passing the `name` argument to the decorator.

    If `results` is not specified, then the decorator will implicitly
    insert a `ReturnOp` with the `Value`'s returned from the decorated
    function. It will also set the `FuncOp` type with the actual return
    value types. If `results` is specified, then the decorated function
    must return `None` and no implicit `ReturnOp` is added (nor are the result
    types updated). The implicit behavior is intended for simple, single-block
    cases, and users should specify result types explicitly for any complicated
    cases.

    The decorated function can further be called from Python and will insert
    a `CallOp` at the then-current insertion point, returning either None (
    if no return values), a unary Value (for one result), or a list of Values).
    This mechanism cannot be used to emit recursive calls (by construction).
    """

    def decorator(f):
      from . import std
      # Introspect the callable for optional features.
      sig = inspect.signature(f)
      has_arg_func_op = False
      for param in sig.parameters.values():
        if param.kind == param.VAR_KEYWORD:
          has_arg_func_op = True
        if param.name == "func_op" and (param.kind
                                        == param.POSITIONAL_OR_KEYWORD or
                                        param.kind == param.KEYWORD_ONLY):
          has_arg_func_op = True

      # Emit the FuncOp.
      implicit_return = results is None
      symbol_name = name or f.__name__
      function_type = FunctionType.get(
          inputs=inputs, results=[] if implicit_return else results)
      func_op = FuncOp(name=symbol_name, type=function_type)
      with InsertionPoint(func_op.add_entry_block()):
        func_args = func_op.entry_block.arguments
        func_kwargs = {}
        if has_arg_func_op:
          func_kwargs["func_op"] = func_op
        return_values = f(*func_args, **func_kwargs)
        if not implicit_return:
          return_types = list(results)
          assert return_values is None, (
              "Capturing a python function with explicit `results=` "
              "requires that the wrapped function returns None.")
        else:
          # Coerce return values, add ReturnOp and rewrite func type.
          if return_values is None:
            return_values = []
          elif isinstance(return_values, Value):
            return_values = [return_values]
          else:
            return_values = list(return_values)
          std.ReturnOp(return_values)
          # Recompute the function type.
          return_types = [v.type for v in return_values]
          function_type = FunctionType.get(inputs=inputs, results=return_types)
          func_op.attributes["type"] = TypeAttr.get(function_type)

      def emit_call_op(*call_args):
        call_op = std.CallOp(return_types, FlatSymbolRefAttr.get(symbol_name),
                             call_args)
        if return_types is None:
          return None
        elif len(return_types) == 1:
          return call_op.result
        else:
          return call_op.results

      wrapped = emit_call_op
      wrapped.__name__ = f.__name__
      wrapped.func_op = func_op
      return wrapped

    return decorator
