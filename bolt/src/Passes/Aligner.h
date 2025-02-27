//===--------- Passes/Aligner.h -------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_TOOLS_LLVM_BOLT_PASSES_ALIGNER_H
#define LLVM_TOOLS_LLVM_BOLT_PASSES_ALIGNER_H

#include "BinaryPasses.h"

namespace llvm {
namespace bolt {

class AlignerPass : public BinaryFunctionPass {
private:
  /// Stats for usage of max bytes for basic block alignment.
  std::vector<uint32_t> AlignHistogram;
  std::shared_timed_mutex AlignHistogramMtx;

  /// Stats: execution count of blocks that were aligned.
  std::atomic<uint64_t> AlignedBlocksCount{0};

  /// Assign alignment to basic blocks based on profile.
  void alignBlocks(BinaryFunction &Function, const MCCodeEmitter *Emitter);

public:
  explicit AlignerPass() : BinaryFunctionPass(false) {}

  const char *getName() const override {
    return "aligner";
  }

  /// Pass entry point
  void runOnFunctions(BinaryContext &BC) override;
};

} // namespace bolt
} // namespace llvm


#endif
