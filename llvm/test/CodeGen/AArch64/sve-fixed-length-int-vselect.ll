; RUN: llc -aarch64-sve-vector-bits-min=128  < %s | FileCheck %s -D#VBYTES=16 -check-prefix=NO_SVE
; RUN: llc -aarch64-sve-vector-bits-min=256  < %s | FileCheck %s -D#VBYTES=32
; RUN: llc -aarch64-sve-vector-bits-min=384  < %s | FileCheck %s -D#VBYTES=32
; RUN: llc -aarch64-sve-vector-bits-min=512  < %s | FileCheck %s -D#VBYTES=64 -check-prefixes=CHECK,VBITS_GE_512
; RUN: llc -aarch64-sve-vector-bits-min=640  < %s | FileCheck %s -D#VBYTES=64 -check-prefixes=CHECK,VBITS_GE_512
; RUN: llc -aarch64-sve-vector-bits-min=768  < %s | FileCheck %s -D#VBYTES=64 -check-prefixes=CHECK,VBITS_GE_512
; RUN: llc -aarch64-sve-vector-bits-min=896  < %s | FileCheck %s -D#VBYTES=64 -check-prefixes=CHECK,VBITS_GE_512
; RUN: llc -aarch64-sve-vector-bits-min=1024 < %s | FileCheck %s -D#VBYTES=128 -check-prefixes=CHECK,VBITS_GE_512,VBITS_GE_1024
; RUN: llc -aarch64-sve-vector-bits-min=1152 < %s | FileCheck %s -D#VBYTES=128 -check-prefixes=CHECK,VBITS_GE_512,VBITS_GE_1024
; RUN: llc -aarch64-sve-vector-bits-min=1280 < %s | FileCheck %s -D#VBYTES=128 -check-prefixes=CHECK,VBITS_GE_512,VBITS_GE_1024
; RUN: llc -aarch64-sve-vector-bits-min=1408 < %s | FileCheck %s -D#VBYTES=128 -check-prefixes=CHECK,VBITS_GE_512,VBITS_GE_1024
; RUN: llc -aarch64-sve-vector-bits-min=1536 < %s | FileCheck %s -D#VBYTES=128 -check-prefixes=CHECK,VBITS_GE_512,VBITS_GE_1024
; RUN: llc -aarch64-sve-vector-bits-min=1664 < %s | FileCheck %s -D#VBYTES=128 -check-prefixes=CHECK,VBITS_GE_512,VBITS_GE_1024
; RUN: llc -aarch64-sve-vector-bits-min=1792 < %s | FileCheck %s -D#VBYTES=128 -check-prefixes=CHECK,VBITS_GE_512,VBITS_GE_1024
; RUN: llc -aarch64-sve-vector-bits-min=1920 < %s | FileCheck %s -D#VBYTES=128 -check-prefixes=CHECK,VBITS_GE_512,VBITS_GE_1024
; RUN: llc -aarch64-sve-vector-bits-min=2048 < %s | FileCheck %s -D#VBYTES=256 -check-prefixes=CHECK,VBITS_GE_512,VBITS_GE_1024,VBITS_GE_2048

target triple = "aarch64-unknown-linux-gnu"

; Don't use SVE when its registers are no bigger than NEON.
; NO_SVE-NOT: ptrue

; Don't use SVE for 64-bit vectors.
define <8 x i8> @select_v8i8(<8 x i8> %op1, <8 x i8> %op2, <8 x i1> %mask) #0 {
; CHECK-LABEL: select_v8i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    shl v2.8b, v2.8b, #7
; CHECK-NEXT:    sshr v2.8b, v2.8b, #7
; CHECK-NEXT:    bif v0.8b, v1.8b, v2.8b
; CHECK-NEXT:    ret
  %sel = select <8 x i1> %mask, <8 x i8> %op1, <8 x i8> %op2
  ret <8 x i8> %sel
}

; Don't use SVE for 128-bit vectors.
define <16 x i8> @select_v16i8(<16 x i8> %op1, <16 x i8> %op2, <16 x i1> %mask) #0 {
; CHECK-LABEL: select_v16i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    shl v2.16b, v2.16b, #7
; CHECK-NEXT:    sshr v2.16b, v2.16b, #7
; CHECK-NEXT:    bif v0.16b, v1.16b, v2.16b
; CHECK-NEXT:    ret
  %sel = select <16 x i1> %mask, <16 x i8> %op1, <16 x i8> %op2
  ret <16 x i8> %sel
}

define void @select_v32i8(<32 x i8>* %a, <32 x i8>* %b, <32 x i1>* %c) #0 {
; CHECK-LABEL: select_v32i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    stp x29, x30, [sp, #-16]! // 16-byte Folded Spill
; CHECK-NEXT:    sub x9, sp, #48
; CHECK-NEXT:    mov x29, sp
; CHECK-NEXT:    and sp, x9, #0xffffffffffffffe0
; CHECK-NEXT:    .cfi_def_cfa w29, 16
; CHECK-NEXT:    .cfi_offset w30, -8
; CHECK-NEXT:    .cfi_offset w29, -16
; CHECK-NEXT:    ldr w8, [x2]
; CHECK-NEXT:    ptrue p0.b, vl32
; CHECK-NEXT:    ptrue p1.b
; CHECK-NEXT:    asr w9, w8, #31
; CHECK-NEXT:    strb w9, [sp, #31]
; CHECK-NEXT:    sbfx w9, w8, #30, #1
; CHECK-NEXT:    strb w9, [sp, #30]
; CHECK-NEXT:    sbfx w9, w8, #29, #1
; CHECK-NEXT:    strb w9, [sp, #29]
; CHECK-NEXT:    sbfx w9, w8, #28, #1
; CHECK-NEXT:    strb w9, [sp, #28]
; CHECK-NEXT:    sbfx w9, w8, #27, #1
; CHECK-NEXT:    strb w9, [sp, #27]
; CHECK-NEXT:    sbfx w9, w8, #26, #1
; CHECK-NEXT:    strb w9, [sp, #26]
; CHECK-NEXT:    sbfx w9, w8, #25, #1
; CHECK-NEXT:    strb w9, [sp, #25]
; CHECK-NEXT:    sbfx w9, w8, #24, #1
; CHECK-NEXT:    strb w9, [sp, #24]
; CHECK-NEXT:    sbfx w9, w8, #23, #1
; CHECK-NEXT:    strb w9, [sp, #23]
; CHECK-NEXT:    sbfx w9, w8, #22, #1
; CHECK-NEXT:    strb w9, [sp, #22]
; CHECK-NEXT:    sbfx w9, w8, #21, #1
; CHECK-NEXT:    strb w9, [sp, #21]
; CHECK-NEXT:    sbfx w9, w8, #20, #1
; CHECK-NEXT:    strb w9, [sp, #20]
; CHECK-NEXT:    sbfx w9, w8, #19, #1
; CHECK-NEXT:    strb w9, [sp, #19]
; CHECK-NEXT:    sbfx w9, w8, #18, #1
; CHECK-NEXT:    strb w9, [sp, #18]
; CHECK-NEXT:    sbfx w9, w8, #17, #1
; CHECK-NEXT:    strb w9, [sp, #17]
; CHECK-NEXT:    sbfx w9, w8, #16, #1
; CHECK-NEXT:    strb w9, [sp, #16]
; CHECK-NEXT:    sbfx w9, w8, #15, #1
; CHECK-NEXT:    strb w9, [sp, #15]
; CHECK-NEXT:    sbfx w9, w8, #14, #1
; CHECK-NEXT:    strb w9, [sp, #14]
; CHECK-NEXT:    sbfx w9, w8, #13, #1
; CHECK-NEXT:    strb w9, [sp, #13]
; CHECK-NEXT:    sbfx w9, w8, #12, #1
; CHECK-NEXT:    strb w9, [sp, #12]
; CHECK-NEXT:    sbfx w9, w8, #11, #1
; CHECK-NEXT:    strb w9, [sp, #11]
; CHECK-NEXT:    sbfx w9, w8, #10, #1
; CHECK-NEXT:    strb w9, [sp, #10]
; CHECK-NEXT:    sbfx w9, w8, #9, #1
; CHECK-NEXT:    strb w9, [sp, #9]
; CHECK-NEXT:    sbfx w9, w8, #8, #1
; CHECK-NEXT:    strb w9, [sp, #8]
; CHECK-NEXT:    sbfx w9, w8, #7, #1
; CHECK-NEXT:    strb w9, [sp, #7]
; CHECK-NEXT:    sbfx w9, w8, #6, #1
; CHECK-NEXT:    strb w9, [sp, #6]
; CHECK-NEXT:    sbfx w9, w8, #5, #1
; CHECK-NEXT:    strb w9, [sp, #5]
; CHECK-NEXT:    sbfx w9, w8, #4, #1
; CHECK-NEXT:    strb w9, [sp, #4]
; CHECK-NEXT:    sbfx w9, w8, #3, #1
; CHECK-NEXT:    strb w9, [sp, #3]
; CHECK-NEXT:    sbfx w9, w8, #2, #1
; CHECK-NEXT:    strb w9, [sp, #2]
; CHECK-NEXT:    sbfx w9, w8, #1, #1
; CHECK-NEXT:    sbfx w8, w8, #0, #1
; CHECK-NEXT:    strb w9, [sp, #1]
; CHECK-NEXT:    mov x9, sp
; CHECK-NEXT:    strb w8, [sp]
; CHECK-NEXT:    ld1b { z0.b }, p0/z, [x9]
; CHECK-NEXT:    ld1b { z1.b }, p0/z, [x0]
; CHECK-NEXT:    ld1b { z2.b }, p0/z, [x1]
; CHECK-NEXT:    and z0.b, z0.b, #0x1
; CHECK-NEXT:    cmpne p1.b, p1/z, z0.b, #0
; CHECK-NEXT:    sel z0.b, p1, z1.b, z2.b
; CHECK-NEXT:    st1b { z0.b }, p0, [x0]
; CHECK-NEXT:    mov sp, x29
; CHECK-NEXT:    ldp x29, x30, [sp], #16 // 16-byte Folded Reload
; CHECK-NEXT:    ret
  %mask = load <32 x i1>, <32 x i1>* %c
  %op1 = load <32 x i8>, <32 x i8>* %a
  %op2 = load <32 x i8>, <32 x i8>* %b
  %sel = select <32 x i1> %mask, <32 x i8> %op1, <32 x i8> %op2
  store <32 x i8> %sel, <32 x i8>* %a
  ret void
}

define void @select_v64i8(<64 x i8>* %a, <64 x i8>* %b, <64 x i1>* %c) #0 {
; VBITS_GE_512-LABEL: select_v64i8:
; VBITS_GE_512:       // %bb.0:
; VBITS_GE_512-NEXT:    stp x29, x30, [sp, #-16]! // 16-byte Folded Spill
; VBITS_GE_512-NEXT:    sub x9, sp, #112
; VBITS_GE_512-NEXT:    mov x29, sp
; VBITS_GE_512-NEXT:    and sp, x9, #0xffffffffffffffc0
; VBITS_GE_512-NEXT:    .cfi_def_cfa w29, 16
; VBITS_GE_512-NEXT:    .cfi_offset w30, -8
; VBITS_GE_512-NEXT:    .cfi_offset w29, -16
; VBITS_GE_512-NEXT:    ldr x8, [x2]
; VBITS_GE_512-NEXT:    ptrue p0.b, vl64
; VBITS_GE_512-NEXT:    ptrue p1.b
; VBITS_GE_512-NEXT:    asr x9, x8, #63
; VBITS_GE_512-NEXT:    strb w9, [sp, #63]
; VBITS_GE_512-NEXT:    sbfx x9, x8, #62, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #62]
; VBITS_GE_512-NEXT:    sbfx x9, x8, #61, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #61]
; VBITS_GE_512-NEXT:    sbfx x9, x8, #60, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #60]
; VBITS_GE_512-NEXT:    sbfx x9, x8, #59, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #59]
; VBITS_GE_512-NEXT:    sbfx x9, x8, #58, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #58]
; VBITS_GE_512-NEXT:    sbfx x9, x8, #57, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #57]
; VBITS_GE_512-NEXT:    sbfx x9, x8, #56, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #56]
; VBITS_GE_512-NEXT:    sbfx x9, x8, #55, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #55]
; VBITS_GE_512-NEXT:    sbfx x9, x8, #54, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #54]
; VBITS_GE_512-NEXT:    sbfx x9, x8, #53, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #53]
; VBITS_GE_512-NEXT:    sbfx x9, x8, #52, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #52]
; VBITS_GE_512-NEXT:    sbfx x9, x8, #51, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #51]
; VBITS_GE_512-NEXT:    sbfx x9, x8, #50, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #50]
; VBITS_GE_512-NEXT:    sbfx x9, x8, #49, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #49]
; VBITS_GE_512-NEXT:    sbfx x9, x8, #48, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #48]
; VBITS_GE_512-NEXT:    sbfx x9, x8, #47, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #47]
; VBITS_GE_512-NEXT:    sbfx x9, x8, #46, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #46]
; VBITS_GE_512-NEXT:    sbfx x9, x8, #45, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #45]
; VBITS_GE_512-NEXT:    sbfx x9, x8, #44, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #44]
; VBITS_GE_512-NEXT:    sbfx x9, x8, #43, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #43]
; VBITS_GE_512-NEXT:    sbfx x9, x8, #42, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #42]
; VBITS_GE_512-NEXT:    sbfx x9, x8, #41, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #41]
; VBITS_GE_512-NEXT:    sbfx x9, x8, #40, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #40]
; VBITS_GE_512-NEXT:    sbfx x9, x8, #39, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #39]
; VBITS_GE_512-NEXT:    sbfx x9, x8, #38, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #38]
; VBITS_GE_512-NEXT:    sbfx x9, x8, #37, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #37]
; VBITS_GE_512-NEXT:    sbfx x9, x8, #36, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #36]
; VBITS_GE_512-NEXT:    sbfx x9, x8, #35, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #35]
; VBITS_GE_512-NEXT:    sbfx x9, x8, #34, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #34]
; VBITS_GE_512-NEXT:    sbfx x9, x8, #33, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #33]
; VBITS_GE_512-NEXT:    sbfx x9, x8, #32, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #32]
; VBITS_GE_512-NEXT:    asr w9, w8, #31
; VBITS_GE_512-NEXT:    strb w9, [sp, #31]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #30, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #30]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #29, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #29]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #28, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #28]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #27, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #27]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #26, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #26]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #25, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #25]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #24, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #24]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #23, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #23]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #22, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #22]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #21, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #21]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #20, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #20]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #19, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #19]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #18, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #18]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #17, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #17]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #16, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #16]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #15, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #15]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #14, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #14]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #13, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #13]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #12, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #12]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #11, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #11]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #10, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #10]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #9, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #9]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #8, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #8]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #7, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #7]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #6, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #6]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #5, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #5]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #4, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #4]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #3, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #3]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #2, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #2]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #1, #1
; VBITS_GE_512-NEXT:    sbfx w8, w8, #0, #1
; VBITS_GE_512-NEXT:    strb w9, [sp, #1]
; VBITS_GE_512-NEXT:    mov x9, sp
; VBITS_GE_512-NEXT:    strb w8, [sp]
; VBITS_GE_512-NEXT:    ld1b { z0.b }, p0/z, [x9]
; VBITS_GE_512-NEXT:    ld1b { z1.b }, p0/z, [x0]
; VBITS_GE_512-NEXT:    ld1b { z2.b }, p0/z, [x1]
; VBITS_GE_512-NEXT:    and z0.b, z0.b, #0x1
; VBITS_GE_512-NEXT:    cmpne p1.b, p1/z, z0.b, #0
; VBITS_GE_512-NEXT:    sel z0.b, p1, z1.b, z2.b
; VBITS_GE_512-NEXT:    st1b { z0.b }, p0, [x0]
; VBITS_GE_512-NEXT:    mov sp, x29
; VBITS_GE_512-NEXT:    ldp x29, x30, [sp], #16 // 16-byte Folded Reload
; VBITS_GE_512-NEXT:    ret
  %mask = load <64 x i1>, <64 x i1>* %c
  %op1 = load <64 x i8>, <64 x i8>* %a
  %op2 = load <64 x i8>, <64 x i8>* %b
  %sel = select <64 x i1> %mask, <64 x i8> %op1, <64 x i8> %op2
  store <64 x i8> %sel, <64 x i8>* %a
  ret void
}

define void @select_v128i8(<128 x i8>* %a, <128 x i8>* %b, <128 x i1>* %c) #0 {
; VBITS_GE_1024-LABEL: select_v128i8:
; VBITS_GE_1024:       // %bb.0:
; VBITS_GE_1024-NEXT:    stp x29, x30, [sp, #-16]! // 16-byte Folded Spill
; VBITS_GE_1024-NEXT:    sub x9, sp, #240
; VBITS_GE_1024-NEXT:    mov x29, sp
; VBITS_GE_1024-NEXT:    and sp, x9, #0xffffffffffffff80
; VBITS_GE_1024-NEXT:    .cfi_def_cfa w29, 16
; VBITS_GE_1024-NEXT:    .cfi_offset w30, -8
; VBITS_GE_1024-NEXT:    .cfi_offset w29, -16
; VBITS_GE_1024-NEXT:    ldr x8, [x2, #8]
; VBITS_GE_1024-NEXT:    ptrue p0.b, vl128
; VBITS_GE_1024-NEXT:    ptrue p1.b
; VBITS_GE_1024-NEXT:    asr x9, x8, #63
; VBITS_GE_1024-NEXT:    strb w9, [sp, #127]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #62, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #126]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #61, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #125]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #60, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #124]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #59, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #123]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #58, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #122]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #57, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #121]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #56, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #120]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #55, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #119]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #54, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #118]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #53, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #117]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #52, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #116]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #51, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #115]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #50, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #114]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #49, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #113]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #48, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #112]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #47, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #111]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #46, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #110]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #45, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #109]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #44, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #108]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #43, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #107]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #42, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #106]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #41, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #105]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #40, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #104]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #39, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #103]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #38, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #102]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #37, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #101]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #36, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #100]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #35, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #99]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #34, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #98]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #33, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #97]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #32, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #96]
; VBITS_GE_1024-NEXT:    asr w9, w8, #31
; VBITS_GE_1024-NEXT:    strb w9, [sp, #95]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #30, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #94]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #29, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #93]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #28, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #92]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #27, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #91]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #26, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #90]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #25, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #89]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #24, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #88]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #23, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #87]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #22, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #86]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #21, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #85]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #20, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #84]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #19, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #83]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #18, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #82]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #17, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #81]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #16, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #80]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #15, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #79]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #14, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #78]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #13, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #77]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #12, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #76]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #11, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #75]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #10, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #74]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #9, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #73]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #8, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #72]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #7, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #71]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #6, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #70]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #5, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #69]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #4, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #68]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #3, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #67]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #2, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #66]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #1, #1
; VBITS_GE_1024-NEXT:    sbfx w8, w8, #0, #1
; VBITS_GE_1024-NEXT:    strb w9, [sp, #65]
; VBITS_GE_1024-NEXT:    strb w8, [sp, #64]
; VBITS_GE_1024-NEXT:    ldr x8, [x2]
; VBITS_GE_1024-NEXT:    mov x9, sp
; VBITS_GE_1024-NEXT:    asr x10, x8, #63
; VBITS_GE_1024-NEXT:    strb w10, [sp, #63]
; VBITS_GE_1024-NEXT:    sbfx x10, x8, #62, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #62]
; VBITS_GE_1024-NEXT:    sbfx x10, x8, #61, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #61]
; VBITS_GE_1024-NEXT:    sbfx x10, x8, #60, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #60]
; VBITS_GE_1024-NEXT:    sbfx x10, x8, #59, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #59]
; VBITS_GE_1024-NEXT:    sbfx x10, x8, #58, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #58]
; VBITS_GE_1024-NEXT:    sbfx x10, x8, #57, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #57]
; VBITS_GE_1024-NEXT:    sbfx x10, x8, #56, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #56]
; VBITS_GE_1024-NEXT:    sbfx x10, x8, #55, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #55]
; VBITS_GE_1024-NEXT:    sbfx x10, x8, #54, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #54]
; VBITS_GE_1024-NEXT:    sbfx x10, x8, #53, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #53]
; VBITS_GE_1024-NEXT:    sbfx x10, x8, #52, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #52]
; VBITS_GE_1024-NEXT:    sbfx x10, x8, #51, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #51]
; VBITS_GE_1024-NEXT:    sbfx x10, x8, #50, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #50]
; VBITS_GE_1024-NEXT:    sbfx x10, x8, #49, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #49]
; VBITS_GE_1024-NEXT:    sbfx x10, x8, #48, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #48]
; VBITS_GE_1024-NEXT:    sbfx x10, x8, #47, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #47]
; VBITS_GE_1024-NEXT:    sbfx x10, x8, #46, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #46]
; VBITS_GE_1024-NEXT:    sbfx x10, x8, #45, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #45]
; VBITS_GE_1024-NEXT:    sbfx x10, x8, #44, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #44]
; VBITS_GE_1024-NEXT:    sbfx x10, x8, #43, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #43]
; VBITS_GE_1024-NEXT:    sbfx x10, x8, #42, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #42]
; VBITS_GE_1024-NEXT:    sbfx x10, x8, #41, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #41]
; VBITS_GE_1024-NEXT:    sbfx x10, x8, #40, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #40]
; VBITS_GE_1024-NEXT:    sbfx x10, x8, #39, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #39]
; VBITS_GE_1024-NEXT:    sbfx x10, x8, #38, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #38]
; VBITS_GE_1024-NEXT:    sbfx x10, x8, #37, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #37]
; VBITS_GE_1024-NEXT:    sbfx x10, x8, #36, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #36]
; VBITS_GE_1024-NEXT:    sbfx x10, x8, #35, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #35]
; VBITS_GE_1024-NEXT:    sbfx x10, x8, #34, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #34]
; VBITS_GE_1024-NEXT:    sbfx x10, x8, #33, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #33]
; VBITS_GE_1024-NEXT:    sbfx x10, x8, #32, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #32]
; VBITS_GE_1024-NEXT:    asr w10, w8, #31
; VBITS_GE_1024-NEXT:    strb w10, [sp, #31]
; VBITS_GE_1024-NEXT:    sbfx w10, w8, #30, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #30]
; VBITS_GE_1024-NEXT:    sbfx w10, w8, #29, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #29]
; VBITS_GE_1024-NEXT:    sbfx w10, w8, #28, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #28]
; VBITS_GE_1024-NEXT:    sbfx w10, w8, #27, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #27]
; VBITS_GE_1024-NEXT:    sbfx w10, w8, #26, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #26]
; VBITS_GE_1024-NEXT:    sbfx w10, w8, #25, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #25]
; VBITS_GE_1024-NEXT:    sbfx w10, w8, #24, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #24]
; VBITS_GE_1024-NEXT:    sbfx w10, w8, #23, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #23]
; VBITS_GE_1024-NEXT:    sbfx w10, w8, #22, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #22]
; VBITS_GE_1024-NEXT:    sbfx w10, w8, #21, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #21]
; VBITS_GE_1024-NEXT:    sbfx w10, w8, #20, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #20]
; VBITS_GE_1024-NEXT:    sbfx w10, w8, #19, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #19]
; VBITS_GE_1024-NEXT:    sbfx w10, w8, #18, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #18]
; VBITS_GE_1024-NEXT:    sbfx w10, w8, #17, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #17]
; VBITS_GE_1024-NEXT:    sbfx w10, w8, #16, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #16]
; VBITS_GE_1024-NEXT:    sbfx w10, w8, #15, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #15]
; VBITS_GE_1024-NEXT:    sbfx w10, w8, #14, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #14]
; VBITS_GE_1024-NEXT:    sbfx w10, w8, #13, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #13]
; VBITS_GE_1024-NEXT:    sbfx w10, w8, #12, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #12]
; VBITS_GE_1024-NEXT:    sbfx w10, w8, #11, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #11]
; VBITS_GE_1024-NEXT:    sbfx w10, w8, #10, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #10]
; VBITS_GE_1024-NEXT:    sbfx w10, w8, #9, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #9]
; VBITS_GE_1024-NEXT:    sbfx w10, w8, #8, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #8]
; VBITS_GE_1024-NEXT:    sbfx w10, w8, #7, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #7]
; VBITS_GE_1024-NEXT:    sbfx w10, w8, #6, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #6]
; VBITS_GE_1024-NEXT:    sbfx w10, w8, #5, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #5]
; VBITS_GE_1024-NEXT:    sbfx w10, w8, #4, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #4]
; VBITS_GE_1024-NEXT:    sbfx w10, w8, #3, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #3]
; VBITS_GE_1024-NEXT:    sbfx w10, w8, #2, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #2]
; VBITS_GE_1024-NEXT:    sbfx w10, w8, #1, #1
; VBITS_GE_1024-NEXT:    sbfx w8, w8, #0, #1
; VBITS_GE_1024-NEXT:    strb w10, [sp, #1]
; VBITS_GE_1024-NEXT:    strb w8, [sp]
; VBITS_GE_1024-NEXT:    ld1b { z0.b }, p0/z, [x9]
; VBITS_GE_1024-NEXT:    ld1b { z1.b }, p0/z, [x0]
; VBITS_GE_1024-NEXT:    ld1b { z2.b }, p0/z, [x1]
; VBITS_GE_1024-NEXT:    and z0.b, z0.b, #0x1
; VBITS_GE_1024-NEXT:    cmpne p1.b, p1/z, z0.b, #0
; VBITS_GE_1024-NEXT:    sel z0.b, p1, z1.b, z2.b
; VBITS_GE_1024-NEXT:    st1b { z0.b }, p0, [x0]
; VBITS_GE_1024-NEXT:    mov sp, x29
; VBITS_GE_1024-NEXT:    ldp x29, x30, [sp], #16 // 16-byte Folded Reload
; VBITS_GE_1024-NEXT:    ret
  %mask = load <128 x i1>, <128 x i1>* %c
  %op1 = load <128 x i8>, <128 x i8>* %a
  %op2 = load <128 x i8>, <128 x i8>* %b
  %sel = select <128 x i1> %mask, <128 x i8> %op1, <128 x i8> %op2
  store <128 x i8> %sel, <128 x i8>* %a
  ret void
}

define void @select_v256i8(<256 x i8>* %a, <256 x i8>* %b, <256 x i1>* %c) #0 {
; VBITS_GE_2048-LABEL: select_v256i8:
; VBITS_GE_2048:       // %bb.0:
; VBITS_GE_2048-NEXT:    stp x29, x30, [sp, #-16]! // 16-byte Folded Spill
; VBITS_GE_2048-NEXT:    sub x9, sp, #496
; VBITS_GE_2048-NEXT:    mov x29, sp
; VBITS_GE_2048-NEXT:    and sp, x9, #0xffffffffffffff00
; VBITS_GE_2048-NEXT:    .cfi_def_cfa w29, 16
; VBITS_GE_2048-NEXT:    .cfi_offset w30, -8
; VBITS_GE_2048-NEXT:    .cfi_offset w29, -16
; VBITS_GE_2048-NEXT:    ldr x8, [x2, #24]
; VBITS_GE_2048-NEXT:    ptrue p0.b, vl256
; VBITS_GE_2048-NEXT:    ptrue p1.b
; VBITS_GE_2048-NEXT:    asr x9, x8, #63
; VBITS_GE_2048-NEXT:    strb w9, [sp, #255]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #62, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #254]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #61, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #253]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #60, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #252]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #59, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #251]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #58, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #250]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #57, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #249]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #56, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #248]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #55, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #247]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #54, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #246]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #53, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #245]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #52, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #244]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #51, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #243]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #50, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #242]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #49, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #241]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #48, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #240]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #47, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #239]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #46, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #238]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #45, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #237]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #44, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #236]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #43, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #235]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #42, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #234]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #41, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #233]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #40, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #232]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #39, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #231]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #38, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #230]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #37, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #229]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #36, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #228]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #35, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #227]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #34, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #226]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #33, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #225]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #32, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #224]
; VBITS_GE_2048-NEXT:    asr w9, w8, #31
; VBITS_GE_2048-NEXT:    strb w9, [sp, #223]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #30, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #222]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #29, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #221]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #28, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #220]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #27, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #219]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #26, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #218]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #25, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #217]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #24, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #216]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #23, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #215]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #22, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #214]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #21, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #213]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #20, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #212]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #19, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #211]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #18, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #210]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #17, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #209]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #16, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #208]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #15, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #207]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #14, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #206]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #13, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #205]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #12, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #204]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #11, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #203]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #10, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #202]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #9, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #201]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #8, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #200]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #7, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #199]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #6, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #198]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #5, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #197]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #4, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #196]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #3, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #195]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #2, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #194]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #1, #1
; VBITS_GE_2048-NEXT:    sbfx w8, w8, #0, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #193]
; VBITS_GE_2048-NEXT:    strb w8, [sp, #192]
; VBITS_GE_2048-NEXT:    ldr x8, [x2, #16]
; VBITS_GE_2048-NEXT:    asr x9, x8, #63
; VBITS_GE_2048-NEXT:    strb w9, [sp, #191]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #62, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #190]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #61, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #189]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #60, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #188]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #59, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #187]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #58, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #186]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #57, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #185]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #56, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #184]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #55, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #183]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #54, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #182]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #53, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #181]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #52, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #180]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #51, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #179]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #50, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #178]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #49, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #177]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #48, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #176]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #47, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #175]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #46, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #174]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #45, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #173]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #44, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #172]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #43, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #171]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #42, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #170]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #41, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #169]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #40, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #168]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #39, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #167]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #38, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #166]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #37, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #165]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #36, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #164]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #35, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #163]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #34, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #162]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #33, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #161]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #32, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #160]
; VBITS_GE_2048-NEXT:    asr w9, w8, #31
; VBITS_GE_2048-NEXT:    strb w9, [sp, #159]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #30, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #158]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #29, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #157]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #28, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #156]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #27, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #155]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #26, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #154]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #25, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #153]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #24, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #152]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #23, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #151]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #22, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #150]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #21, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #149]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #20, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #148]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #19, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #147]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #18, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #146]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #17, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #145]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #16, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #144]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #15, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #143]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #14, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #142]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #13, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #141]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #12, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #140]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #11, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #139]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #10, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #138]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #9, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #137]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #8, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #136]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #7, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #135]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #6, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #134]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #5, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #133]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #4, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #132]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #3, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #131]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #2, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #130]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #1, #1
; VBITS_GE_2048-NEXT:    sbfx w8, w8, #0, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #129]
; VBITS_GE_2048-NEXT:    strb w8, [sp, #128]
; VBITS_GE_2048-NEXT:    ldr x8, [x2, #8]
; VBITS_GE_2048-NEXT:    asr x9, x8, #63
; VBITS_GE_2048-NEXT:    strb w9, [sp, #127]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #62, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #126]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #61, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #125]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #60, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #124]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #59, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #123]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #58, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #122]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #57, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #121]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #56, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #120]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #55, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #119]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #54, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #118]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #53, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #117]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #52, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #116]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #51, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #115]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #50, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #114]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #49, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #113]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #48, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #112]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #47, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #111]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #46, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #110]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #45, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #109]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #44, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #108]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #43, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #107]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #42, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #106]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #41, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #105]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #40, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #104]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #39, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #103]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #38, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #102]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #37, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #101]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #36, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #100]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #35, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #99]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #34, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #98]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #33, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #97]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #32, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #96]
; VBITS_GE_2048-NEXT:    asr w9, w8, #31
; VBITS_GE_2048-NEXT:    strb w9, [sp, #95]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #30, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #94]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #29, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #93]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #28, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #92]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #27, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #91]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #26, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #90]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #25, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #89]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #24, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #88]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #23, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #87]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #22, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #86]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #21, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #85]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #20, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #84]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #19, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #83]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #18, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #82]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #17, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #81]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #16, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #80]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #15, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #79]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #14, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #78]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #13, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #77]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #12, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #76]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #11, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #75]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #10, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #74]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #9, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #73]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #8, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #72]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #7, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #71]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #6, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #70]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #5, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #69]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #4, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #68]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #3, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #67]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #2, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #66]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #1, #1
; VBITS_GE_2048-NEXT:    sbfx w8, w8, #0, #1
; VBITS_GE_2048-NEXT:    strb w9, [sp, #65]
; VBITS_GE_2048-NEXT:    strb w8, [sp, #64]
; VBITS_GE_2048-NEXT:    ldr x8, [x2]
; VBITS_GE_2048-NEXT:    mov x9, sp
; VBITS_GE_2048-NEXT:    asr x10, x8, #63
; VBITS_GE_2048-NEXT:    strb w10, [sp, #63]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #62, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #62]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #61, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #61]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #60, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #60]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #59, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #59]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #58, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #58]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #57, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #57]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #56, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #56]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #55, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #55]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #54, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #54]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #53, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #53]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #52, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #52]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #51, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #51]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #50, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #50]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #49, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #49]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #48, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #48]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #47, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #47]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #46, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #46]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #45, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #45]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #44, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #44]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #43, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #43]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #42, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #42]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #41, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #41]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #40, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #40]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #39, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #39]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #38, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #38]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #37, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #37]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #36, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #36]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #35, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #35]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #34, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #34]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #33, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #33]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #32, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #32]
; VBITS_GE_2048-NEXT:    asr w10, w8, #31
; VBITS_GE_2048-NEXT:    strb w10, [sp, #31]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #30, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #30]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #29, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #29]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #28, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #28]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #27, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #27]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #26, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #26]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #25, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #25]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #24, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #24]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #23, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #23]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #22, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #22]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #21, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #21]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #20, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #20]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #19, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #19]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #18, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #18]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #17, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #17]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #16, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #16]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #15, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #15]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #14, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #14]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #13, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #13]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #12, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #12]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #11, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #11]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #10, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #10]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #9, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #9]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #8, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #8]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #7, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #7]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #6, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #6]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #5, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #5]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #4, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #4]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #3, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #3]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #2, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #2]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #1, #1
; VBITS_GE_2048-NEXT:    sbfx w8, w8, #0, #1
; VBITS_GE_2048-NEXT:    strb w10, [sp, #1]
; VBITS_GE_2048-NEXT:    strb w8, [sp]
; VBITS_GE_2048-NEXT:    ld1b { z0.b }, p0/z, [x9]
; VBITS_GE_2048-NEXT:    ld1b { z1.b }, p0/z, [x0]
; VBITS_GE_2048-NEXT:    ld1b { z2.b }, p0/z, [x1]
; VBITS_GE_2048-NEXT:    and z0.b, z0.b, #0x1
; VBITS_GE_2048-NEXT:    cmpne p1.b, p1/z, z0.b, #0
; VBITS_GE_2048-NEXT:    sel z0.b, p1, z1.b, z2.b
; VBITS_GE_2048-NEXT:    st1b { z0.b }, p0, [x0]
; VBITS_GE_2048-NEXT:    mov sp, x29
; VBITS_GE_2048-NEXT:    ldp x29, x30, [sp], #16 // 16-byte Folded Reload
; VBITS_GE_2048-NEXT:    ret
  %mask = load <256 x i1>, <256 x i1>* %c
  %op1 = load <256 x i8>, <256 x i8>* %a
  %op2 = load <256 x i8>, <256 x i8>* %b
  %sel = select <256 x i1> %mask, <256 x i8> %op1, <256 x i8> %op2
  store <256 x i8> %sel, <256 x i8>* %a
  ret void
}

; Don't use SVE for 64-bit vectors.
define <4 x i16> @select_v4i16(<4 x i16> %op1, <4 x i16> %op2, <4 x i1> %mask) #0 {
; CHECK-LABEL: select_v4i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    shl v2.4h, v2.4h, #15
; CHECK-NEXT:    sshr v2.4h, v2.4h, #15
; CHECK-NEXT:    bif v0.8b, v1.8b, v2.8b
; CHECK-NEXT:    ret
  %sel = select <4 x i1> %mask, <4 x i16> %op1, <4 x i16> %op2
  ret <4 x i16> %sel
}

; Don't use SVE for 128-bit vectors.
define <8 x i16> @select_v8i16(<8 x i16> %op1, <8 x i16> %op2, <8 x i1> %mask) #0 {
; CHECK-LABEL: select_v8i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ushll v2.8h, v2.8b, #0
; CHECK-NEXT:    shl v2.8h, v2.8h, #15
; CHECK-NEXT:    sshr v2.8h, v2.8h, #15
; CHECK-NEXT:    bif v0.16b, v1.16b, v2.16b
; CHECK-NEXT:    ret
  %sel = select <8 x i1> %mask, <8 x i16> %op1, <8 x i16> %op2
  ret <8 x i16> %sel
}

define void @select_v16i16(<16 x i16>* %a, <16 x i16>* %b, <16 x i1>* %c) #0 {
; CHECK-LABEL: select_v16i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    stp x29, x30, [sp, #-16]! // 16-byte Folded Spill
; CHECK-NEXT:    sub x9, sp, #48
; CHECK-NEXT:    mov x29, sp
; CHECK-NEXT:    and sp, x9, #0xffffffffffffffe0
; CHECK-NEXT:    .cfi_def_cfa w29, 16
; CHECK-NEXT:    .cfi_offset w30, -8
; CHECK-NEXT:    .cfi_offset w29, -16
; CHECK-NEXT:    ldrh w8, [x2]
; CHECK-NEXT:    ptrue p0.h, vl16
; CHECK-NEXT:    ptrue p1.h
; CHECK-NEXT:    sbfx w9, w8, #15, #1
; CHECK-NEXT:    strh w9, [sp, #30]
; CHECK-NEXT:    sbfx w9, w8, #14, #1
; CHECK-NEXT:    strh w9, [sp, #28]
; CHECK-NEXT:    sbfx w9, w8, #13, #1
; CHECK-NEXT:    strh w9, [sp, #26]
; CHECK-NEXT:    sbfx w9, w8, #12, #1
; CHECK-NEXT:    strh w9, [sp, #24]
; CHECK-NEXT:    sbfx w9, w8, #11, #1
; CHECK-NEXT:    strh w9, [sp, #22]
; CHECK-NEXT:    sbfx w9, w8, #10, #1
; CHECK-NEXT:    strh w9, [sp, #20]
; CHECK-NEXT:    sbfx w9, w8, #9, #1
; CHECK-NEXT:    strh w9, [sp, #18]
; CHECK-NEXT:    sbfx w9, w8, #8, #1
; CHECK-NEXT:    strh w9, [sp, #16]
; CHECK-NEXT:    sbfx w9, w8, #7, #1
; CHECK-NEXT:    strh w9, [sp, #14]
; CHECK-NEXT:    sbfx w9, w8, #6, #1
; CHECK-NEXT:    strh w9, [sp, #12]
; CHECK-NEXT:    sbfx w9, w8, #5, #1
; CHECK-NEXT:    strh w9, [sp, #10]
; CHECK-NEXT:    sbfx w9, w8, #4, #1
; CHECK-NEXT:    strh w9, [sp, #8]
; CHECK-NEXT:    sbfx w9, w8, #3, #1
; CHECK-NEXT:    strh w9, [sp, #6]
; CHECK-NEXT:    sbfx w9, w8, #2, #1
; CHECK-NEXT:    strh w9, [sp, #4]
; CHECK-NEXT:    sbfx w9, w8, #1, #1
; CHECK-NEXT:    sbfx w8, w8, #0, #1
; CHECK-NEXT:    strh w9, [sp, #2]
; CHECK-NEXT:    mov x9, sp
; CHECK-NEXT:    strh w8, [sp]
; CHECK-NEXT:    ld1h { z0.h }, p0/z, [x9]
; CHECK-NEXT:    ld1h { z1.h }, p0/z, [x0]
; CHECK-NEXT:    ld1h { z2.h }, p0/z, [x1]
; CHECK-NEXT:    and z0.h, z0.h, #0x1
; CHECK-NEXT:    cmpne p1.h, p1/z, z0.h, #0
; CHECK-NEXT:    sel z0.h, p1, z1.h, z2.h
; CHECK-NEXT:    st1h { z0.h }, p0, [x0]
; CHECK-NEXT:    mov sp, x29
; CHECK-NEXT:    ldp x29, x30, [sp], #16 // 16-byte Folded Reload
; CHECK-NEXT:    ret
  %mask = load <16 x i1>, <16 x i1>* %c
  %op1 = load <16 x i16>, <16 x i16>* %a
  %op2 = load <16 x i16>, <16 x i16>* %b
  %sel = select <16 x i1> %mask, <16 x i16> %op1, <16 x i16> %op2
  store <16 x i16> %sel, <16 x i16>* %a
  ret void
}

define void @select_v32i16(<32 x i16>* %a, <32 x i16>* %b, <32 x i1>* %c) #0 {
; VBITS_GE_512-LABEL: select_v32i16:
; VBITS_GE_512:       // %bb.0:
; VBITS_GE_512-NEXT:    stp x29, x30, [sp, #-16]! // 16-byte Folded Spill
; VBITS_GE_512-NEXT:    sub x9, sp, #112
; VBITS_GE_512-NEXT:    mov x29, sp
; VBITS_GE_512-NEXT:    and sp, x9, #0xffffffffffffffc0
; VBITS_GE_512-NEXT:    .cfi_def_cfa w29, 16
; VBITS_GE_512-NEXT:    .cfi_offset w30, -8
; VBITS_GE_512-NEXT:    .cfi_offset w29, -16
; VBITS_GE_512-NEXT:    ldr w8, [x2]
; VBITS_GE_512-NEXT:    ptrue p0.h, vl32
; VBITS_GE_512-NEXT:    ptrue p1.h
; VBITS_GE_512-NEXT:    asr w9, w8, #31
; VBITS_GE_512-NEXT:    strh w9, [sp, #62]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #30, #1
; VBITS_GE_512-NEXT:    strh w9, [sp, #60]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #29, #1
; VBITS_GE_512-NEXT:    strh w9, [sp, #58]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #28, #1
; VBITS_GE_512-NEXT:    strh w9, [sp, #56]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #27, #1
; VBITS_GE_512-NEXT:    strh w9, [sp, #54]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #26, #1
; VBITS_GE_512-NEXT:    strh w9, [sp, #52]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #25, #1
; VBITS_GE_512-NEXT:    strh w9, [sp, #50]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #24, #1
; VBITS_GE_512-NEXT:    strh w9, [sp, #48]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #23, #1
; VBITS_GE_512-NEXT:    strh w9, [sp, #46]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #22, #1
; VBITS_GE_512-NEXT:    strh w9, [sp, #44]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #21, #1
; VBITS_GE_512-NEXT:    strh w9, [sp, #42]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #20, #1
; VBITS_GE_512-NEXT:    strh w9, [sp, #40]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #19, #1
; VBITS_GE_512-NEXT:    strh w9, [sp, #38]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #18, #1
; VBITS_GE_512-NEXT:    strh w9, [sp, #36]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #17, #1
; VBITS_GE_512-NEXT:    strh w9, [sp, #34]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #16, #1
; VBITS_GE_512-NEXT:    strh w9, [sp, #32]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #15, #1
; VBITS_GE_512-NEXT:    strh w9, [sp, #30]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #14, #1
; VBITS_GE_512-NEXT:    strh w9, [sp, #28]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #13, #1
; VBITS_GE_512-NEXT:    strh w9, [sp, #26]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #12, #1
; VBITS_GE_512-NEXT:    strh w9, [sp, #24]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #11, #1
; VBITS_GE_512-NEXT:    strh w9, [sp, #22]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #10, #1
; VBITS_GE_512-NEXT:    strh w9, [sp, #20]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #9, #1
; VBITS_GE_512-NEXT:    strh w9, [sp, #18]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #8, #1
; VBITS_GE_512-NEXT:    strh w9, [sp, #16]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #7, #1
; VBITS_GE_512-NEXT:    strh w9, [sp, #14]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #6, #1
; VBITS_GE_512-NEXT:    strh w9, [sp, #12]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #5, #1
; VBITS_GE_512-NEXT:    strh w9, [sp, #10]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #4, #1
; VBITS_GE_512-NEXT:    strh w9, [sp, #8]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #3, #1
; VBITS_GE_512-NEXT:    strh w9, [sp, #6]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #2, #1
; VBITS_GE_512-NEXT:    strh w9, [sp, #4]
; VBITS_GE_512-NEXT:    sbfx w9, w8, #1, #1
; VBITS_GE_512-NEXT:    sbfx w8, w8, #0, #1
; VBITS_GE_512-NEXT:    strh w9, [sp, #2]
; VBITS_GE_512-NEXT:    mov x9, sp
; VBITS_GE_512-NEXT:    strh w8, [sp]
; VBITS_GE_512-NEXT:    ld1h { z0.h }, p0/z, [x9]
; VBITS_GE_512-NEXT:    ld1h { z1.h }, p0/z, [x0]
; VBITS_GE_512-NEXT:    ld1h { z2.h }, p0/z, [x1]
; VBITS_GE_512-NEXT:    and z0.h, z0.h, #0x1
; VBITS_GE_512-NEXT:    cmpne p1.h, p1/z, z0.h, #0
; VBITS_GE_512-NEXT:    sel z0.h, p1, z1.h, z2.h
; VBITS_GE_512-NEXT:    st1h { z0.h }, p0, [x0]
; VBITS_GE_512-NEXT:    mov sp, x29
; VBITS_GE_512-NEXT:    ldp x29, x30, [sp], #16 // 16-byte Folded Reload
; VBITS_GE_512-NEXT:    ret
  %mask = load <32 x i1>, <32 x i1>* %c
  %op1 = load <32 x i16>, <32 x i16>* %a
  %op2 = load <32 x i16>, <32 x i16>* %b
  %sel = select <32 x i1> %mask, <32 x i16> %op1, <32 x i16> %op2
  store <32 x i16> %sel, <32 x i16>* %a
  ret void
}

define void @select_v64i16(<64 x i16>* %a, <64 x i16>* %b, <64 x i1>* %c) #0 {
; VBITS_GE_1024-LABEL: select_v64i16:
; VBITS_GE_1024:       // %bb.0:
; VBITS_GE_1024-NEXT:    stp x29, x30, [sp, #-16]! // 16-byte Folded Spill
; VBITS_GE_1024-NEXT:    sub x9, sp, #240
; VBITS_GE_1024-NEXT:    mov x29, sp
; VBITS_GE_1024-NEXT:    and sp, x9, #0xffffffffffffff80
; VBITS_GE_1024-NEXT:    .cfi_def_cfa w29, 16
; VBITS_GE_1024-NEXT:    .cfi_offset w30, -8
; VBITS_GE_1024-NEXT:    .cfi_offset w29, -16
; VBITS_GE_1024-NEXT:    ldr x8, [x2]
; VBITS_GE_1024-NEXT:    ptrue p0.h, vl64
; VBITS_GE_1024-NEXT:    ptrue p1.h
; VBITS_GE_1024-NEXT:    asr x9, x8, #63
; VBITS_GE_1024-NEXT:    strh w9, [sp, #126]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #62, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #124]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #61, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #122]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #60, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #120]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #59, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #118]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #58, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #116]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #57, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #114]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #56, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #112]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #55, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #110]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #54, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #108]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #53, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #106]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #52, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #104]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #51, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #102]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #50, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #100]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #49, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #98]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #48, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #96]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #47, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #94]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #46, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #92]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #45, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #90]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #44, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #88]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #43, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #86]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #42, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #84]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #41, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #82]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #40, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #80]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #39, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #78]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #38, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #76]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #37, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #74]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #36, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #72]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #35, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #70]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #34, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #68]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #33, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #66]
; VBITS_GE_1024-NEXT:    sbfx x9, x8, #32, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #64]
; VBITS_GE_1024-NEXT:    asr w9, w8, #31
; VBITS_GE_1024-NEXT:    strh w9, [sp, #62]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #30, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #60]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #29, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #58]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #28, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #56]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #27, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #54]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #26, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #52]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #25, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #50]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #24, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #48]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #23, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #46]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #22, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #44]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #21, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #42]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #20, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #40]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #19, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #38]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #18, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #36]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #17, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #34]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #16, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #32]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #15, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #30]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #14, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #28]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #13, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #26]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #12, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #24]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #11, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #22]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #10, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #20]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #9, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #18]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #8, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #16]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #7, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #14]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #6, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #12]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #5, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #10]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #4, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #8]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #3, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #6]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #2, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #4]
; VBITS_GE_1024-NEXT:    sbfx w9, w8, #1, #1
; VBITS_GE_1024-NEXT:    sbfx w8, w8, #0, #1
; VBITS_GE_1024-NEXT:    strh w9, [sp, #2]
; VBITS_GE_1024-NEXT:    mov x9, sp
; VBITS_GE_1024-NEXT:    strh w8, [sp]
; VBITS_GE_1024-NEXT:    ld1h { z0.h }, p0/z, [x9]
; VBITS_GE_1024-NEXT:    ld1h { z1.h }, p0/z, [x0]
; VBITS_GE_1024-NEXT:    ld1h { z2.h }, p0/z, [x1]
; VBITS_GE_1024-NEXT:    and z0.h, z0.h, #0x1
; VBITS_GE_1024-NEXT:    cmpne p1.h, p1/z, z0.h, #0
; VBITS_GE_1024-NEXT:    sel z0.h, p1, z1.h, z2.h
; VBITS_GE_1024-NEXT:    st1h { z0.h }, p0, [x0]
; VBITS_GE_1024-NEXT:    mov sp, x29
; VBITS_GE_1024-NEXT:    ldp x29, x30, [sp], #16 // 16-byte Folded Reload
; VBITS_GE_1024-NEXT:    ret
  %mask = load <64 x i1>, <64 x i1>* %c
  %op1 = load <64 x i16>, <64 x i16>* %a
  %op2 = load <64 x i16>, <64 x i16>* %b
  %sel = select <64 x i1> %mask, <64 x i16> %op1, <64 x i16> %op2
  store <64 x i16> %sel, <64 x i16>* %a
  ret void
}

define void @select_v128i16(<128 x i16>* %a, <128 x i16>* %b, <128 x i1>* %c) #0 {
; VBITS_GE_2048-LABEL: select_v128i16:
; VBITS_GE_2048:       // %bb.0:
; VBITS_GE_2048-NEXT:    stp x29, x30, [sp, #-16]! // 16-byte Folded Spill
; VBITS_GE_2048-NEXT:    sub x9, sp, #496
; VBITS_GE_2048-NEXT:    mov x29, sp
; VBITS_GE_2048-NEXT:    and sp, x9, #0xffffffffffffff00
; VBITS_GE_2048-NEXT:    .cfi_def_cfa w29, 16
; VBITS_GE_2048-NEXT:    .cfi_offset w30, -8
; VBITS_GE_2048-NEXT:    .cfi_offset w29, -16
; VBITS_GE_2048-NEXT:    ldr x8, [x2, #8]
; VBITS_GE_2048-NEXT:    ptrue p0.h, vl128
; VBITS_GE_2048-NEXT:    ptrue p1.h
; VBITS_GE_2048-NEXT:    asr x9, x8, #63
; VBITS_GE_2048-NEXT:    strh w9, [sp, #254]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #62, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #252]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #61, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #250]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #60, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #248]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #59, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #246]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #58, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #244]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #57, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #242]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #56, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #240]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #55, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #238]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #54, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #236]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #53, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #234]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #52, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #232]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #51, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #230]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #50, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #228]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #49, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #226]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #48, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #224]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #47, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #222]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #46, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #220]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #45, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #218]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #44, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #216]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #43, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #214]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #42, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #212]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #41, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #210]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #40, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #208]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #39, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #206]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #38, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #204]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #37, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #202]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #36, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #200]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #35, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #198]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #34, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #196]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #33, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #194]
; VBITS_GE_2048-NEXT:    sbfx x9, x8, #32, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #192]
; VBITS_GE_2048-NEXT:    asr w9, w8, #31
; VBITS_GE_2048-NEXT:    strh w9, [sp, #190]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #30, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #188]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #29, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #186]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #28, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #184]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #27, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #182]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #26, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #180]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #25, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #178]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #24, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #176]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #23, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #174]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #22, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #172]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #21, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #170]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #20, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #168]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #19, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #166]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #18, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #164]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #17, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #162]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #16, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #160]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #15, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #158]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #14, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #156]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #13, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #154]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #12, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #152]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #11, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #150]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #10, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #148]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #9, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #146]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #8, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #144]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #7, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #142]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #6, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #140]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #5, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #138]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #4, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #136]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #3, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #134]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #2, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #132]
; VBITS_GE_2048-NEXT:    sbfx w9, w8, #1, #1
; VBITS_GE_2048-NEXT:    sbfx w8, w8, #0, #1
; VBITS_GE_2048-NEXT:    strh w9, [sp, #130]
; VBITS_GE_2048-NEXT:    strh w8, [sp, #128]
; VBITS_GE_2048-NEXT:    ldr x8, [x2]
; VBITS_GE_2048-NEXT:    mov x9, sp
; VBITS_GE_2048-NEXT:    asr x10, x8, #63
; VBITS_GE_2048-NEXT:    strh w10, [sp, #126]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #62, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #124]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #61, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #122]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #60, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #120]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #59, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #118]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #58, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #116]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #57, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #114]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #56, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #112]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #55, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #110]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #54, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #108]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #53, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #106]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #52, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #104]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #51, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #102]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #50, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #100]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #49, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #98]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #48, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #96]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #47, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #94]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #46, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #92]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #45, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #90]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #44, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #88]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #43, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #86]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #42, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #84]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #41, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #82]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #40, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #80]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #39, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #78]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #38, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #76]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #37, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #74]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #36, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #72]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #35, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #70]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #34, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #68]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #33, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #66]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #32, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #64]
; VBITS_GE_2048-NEXT:    asr w10, w8, #31
; VBITS_GE_2048-NEXT:    strh w10, [sp, #62]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #30, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #60]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #29, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #58]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #28, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #56]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #27, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #54]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #26, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #52]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #25, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #50]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #24, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #48]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #23, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #46]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #22, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #44]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #21, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #42]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #20, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #40]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #19, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #38]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #18, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #36]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #17, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #34]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #16, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #32]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #15, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #30]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #14, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #28]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #13, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #26]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #12, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #24]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #11, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #22]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #10, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #20]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #9, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #18]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #8, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #16]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #7, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #14]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #6, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #12]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #5, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #10]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #4, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #8]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #3, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #6]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #2, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #4]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #1, #1
; VBITS_GE_2048-NEXT:    sbfx w8, w8, #0, #1
; VBITS_GE_2048-NEXT:    strh w10, [sp, #2]
; VBITS_GE_2048-NEXT:    strh w8, [sp]
; VBITS_GE_2048-NEXT:    ld1h { z0.h }, p0/z, [x9]
; VBITS_GE_2048-NEXT:    ld1h { z1.h }, p0/z, [x0]
; VBITS_GE_2048-NEXT:    ld1h { z2.h }, p0/z, [x1]
; VBITS_GE_2048-NEXT:    and z0.h, z0.h, #0x1
; VBITS_GE_2048-NEXT:    cmpne p1.h, p1/z, z0.h, #0
; VBITS_GE_2048-NEXT:    sel z0.h, p1, z1.h, z2.h
; VBITS_GE_2048-NEXT:    st1h { z0.h }, p0, [x0]
; VBITS_GE_2048-NEXT:    mov sp, x29
; VBITS_GE_2048-NEXT:    ldp x29, x30, [sp], #16 // 16-byte Folded Reload
; VBITS_GE_2048-NEXT:    ret
  %mask = load <128 x i1>, <128 x i1>* %c
  %op1 = load <128 x i16>, <128 x i16>* %a
  %op2 = load <128 x i16>, <128 x i16>* %b
  %sel = select <128 x i1> %mask, <128 x i16> %op1, <128 x i16> %op2
  store <128 x i16> %sel, <128 x i16>* %a
  ret void
}

; Don't use SVE for 64-bit vectors.
define <2 x i32> @select_v2i32(<2 x i32> %op1, <2 x i32> %op2, <2 x i1> %mask) #0 {
; CHECK-LABEL: select_v2i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    shl v2.2s, v2.2s, #31
; CHECK-NEXT:    sshr v2.2s, v2.2s, #31
; CHECK-NEXT:    bif v0.8b, v1.8b, v2.8b
; CHECK-NEXT:    ret
  %sel = select <2 x i1> %mask, <2 x i32> %op1, <2 x i32> %op2
  ret <2 x i32> %sel
}

; Don't use SVE for 128-bit vectors.
define <4 x i32> @select_v4i32(<4 x i32> %op1, <4 x i32> %op2, <4 x i1> %mask) #0 {
; CHECK-LABEL: select_v4i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ushll v2.4s, v2.4h, #0
; CHECK-NEXT:    shl v2.4s, v2.4s, #31
; CHECK-NEXT:    sshr v2.4s, v2.4s, #31
; CHECK-NEXT:    bif v0.16b, v1.16b, v2.16b
; CHECK-NEXT:    ret
  %sel = select <4 x i1> %mask, <4 x i32> %op1, <4 x i32> %op2
  ret <4 x i32> %sel
}

define void @select_v8i32(<8 x i32>* %a, <8 x i32>* %b, <8 x i1>* %c) #0 {
; CHECK-LABEL: select_v8i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    stp x29, x30, [sp, #-16]! // 16-byte Folded Spill
; CHECK-NEXT:    sub x9, sp, #48
; CHECK-NEXT:    mov x29, sp
; CHECK-NEXT:    and sp, x9, #0xffffffffffffffe0
; CHECK-NEXT:    .cfi_def_cfa w29, 16
; CHECK-NEXT:    .cfi_offset w30, -8
; CHECK-NEXT:    .cfi_offset w29, -16
; CHECK-NEXT:    ldrb w8, [x2]
; CHECK-NEXT:    ptrue p0.s, vl8
; CHECK-NEXT:    mov x9, sp
; CHECK-NEXT:    ptrue p1.s
; CHECK-NEXT:    sbfx w10, w8, #7, #1
; CHECK-NEXT:    sbfx w11, w8, #6, #1
; CHECK-NEXT:    stp w11, w10, [sp, #24]
; CHECK-NEXT:    sbfx w10, w8, #3, #1
; CHECK-NEXT:    sbfx w11, w8, #2, #1
; CHECK-NEXT:    sbfx w12, w8, #5, #1
; CHECK-NEXT:    sbfx w13, w8, #4, #1
; CHECK-NEXT:    stp w11, w10, [sp, #8]
; CHECK-NEXT:    sbfx w10, w8, #1, #1
; CHECK-NEXT:    sbfx w8, w8, #0, #1
; CHECK-NEXT:    stp w13, w12, [sp, #16]
; CHECK-NEXT:    stp w8, w10, [sp]
; CHECK-NEXT:    ld1w { z0.s }, p0/z, [x9]
; CHECK-NEXT:    ld1w { z1.s }, p0/z, [x0]
; CHECK-NEXT:    ld1w { z2.s }, p0/z, [x1]
; CHECK-NEXT:    and z0.s, z0.s, #0x1
; CHECK-NEXT:    cmpne p1.s, p1/z, z0.s, #0
; CHECK-NEXT:    sel z0.s, p1, z1.s, z2.s
; CHECK-NEXT:    st1w { z0.s }, p0, [x0]
; CHECK-NEXT:    mov sp, x29
; CHECK-NEXT:    ldp x29, x30, [sp], #16 // 16-byte Folded Reload
; CHECK-NEXT:    ret
  %mask = load <8 x i1>, <8 x i1>* %c
  %op1 = load <8 x i32>, <8 x i32>* %a
  %op2 = load <8 x i32>, <8 x i32>* %b
  %sel = select <8 x i1> %mask, <8 x i32> %op1, <8 x i32> %op2
  store <8 x i32> %sel, <8 x i32>* %a
  ret void
}

define void @select_v16i32(<16 x i32>* %a, <16 x i32>* %b, <16 x i1>* %c) #0 {
; VBITS_GE_512-LABEL: select_v16i32:
; VBITS_GE_512:       // %bb.0:
; VBITS_GE_512-NEXT:    stp x29, x30, [sp, #-16]! // 16-byte Folded Spill
; VBITS_GE_512-NEXT:    sub x9, sp, #112
; VBITS_GE_512-NEXT:    mov x29, sp
; VBITS_GE_512-NEXT:    and sp, x9, #0xffffffffffffffc0
; VBITS_GE_512-NEXT:    .cfi_def_cfa w29, 16
; VBITS_GE_512-NEXT:    .cfi_offset w30, -8
; VBITS_GE_512-NEXT:    .cfi_offset w29, -16
; VBITS_GE_512-NEXT:    ldrh w8, [x2]
; VBITS_GE_512-NEXT:    ptrue p0.s, vl16
; VBITS_GE_512-NEXT:    mov x9, sp
; VBITS_GE_512-NEXT:    ptrue p1.s
; VBITS_GE_512-NEXT:    sbfx w10, w8, #15, #1
; VBITS_GE_512-NEXT:    sbfx w11, w8, #14, #1
; VBITS_GE_512-NEXT:    stp w11, w10, [sp, #56]
; VBITS_GE_512-NEXT:    sbfx w10, w8, #7, #1
; VBITS_GE_512-NEXT:    sbfx w11, w8, #6, #1
; VBITS_GE_512-NEXT:    sbfx w12, w8, #13, #1
; VBITS_GE_512-NEXT:    sbfx w13, w8, #12, #1
; VBITS_GE_512-NEXT:    stp w11, w10, [sp, #24]
; VBITS_GE_512-NEXT:    sbfx w10, w8, #3, #1
; VBITS_GE_512-NEXT:    sbfx w11, w8, #2, #1
; VBITS_GE_512-NEXT:    sbfx w14, w8, #11, #1
; VBITS_GE_512-NEXT:    sbfx w15, w8, #10, #1
; VBITS_GE_512-NEXT:    sbfx w16, w8, #9, #1
; VBITS_GE_512-NEXT:    sbfx w17, w8, #8, #1
; VBITS_GE_512-NEXT:    stp w13, w12, [sp, #48]
; VBITS_GE_512-NEXT:    sbfx w12, w8, #5, #1
; VBITS_GE_512-NEXT:    sbfx w13, w8, #4, #1
; VBITS_GE_512-NEXT:    stp w11, w10, [sp, #8]
; VBITS_GE_512-NEXT:    sbfx w10, w8, #1, #1
; VBITS_GE_512-NEXT:    sbfx w8, w8, #0, #1
; VBITS_GE_512-NEXT:    stp w15, w14, [sp, #40]
; VBITS_GE_512-NEXT:    stp w17, w16, [sp, #32]
; VBITS_GE_512-NEXT:    stp w13, w12, [sp, #16]
; VBITS_GE_512-NEXT:    stp w8, w10, [sp]
; VBITS_GE_512-NEXT:    ld1w { z0.s }, p0/z, [x9]
; VBITS_GE_512-NEXT:    ld1w { z1.s }, p0/z, [x0]
; VBITS_GE_512-NEXT:    ld1w { z2.s }, p0/z, [x1]
; VBITS_GE_512-NEXT:    and z0.s, z0.s, #0x1
; VBITS_GE_512-NEXT:    cmpne p1.s, p1/z, z0.s, #0
; VBITS_GE_512-NEXT:    sel z0.s, p1, z1.s, z2.s
; VBITS_GE_512-NEXT:    st1w { z0.s }, p0, [x0]
; VBITS_GE_512-NEXT:    mov sp, x29
; VBITS_GE_512-NEXT:    ldp x29, x30, [sp], #16 // 16-byte Folded Reload
; VBITS_GE_512-NEXT:    ret
  %mask = load <16 x i1>, <16 x i1>* %c
  %op1 = load <16 x i32>, <16 x i32>* %a
  %op2 = load <16 x i32>, <16 x i32>* %b
  %sel = select <16 x i1> %mask, <16 x i32> %op1, <16 x i32> %op2
  store <16 x i32> %sel, <16 x i32>* %a
  ret void
}

define void @select_v32i32(<32 x i32>* %a, <32 x i32>* %b, <32 x i1>* %c) #0 {
; VBITS_GE_1024-LABEL: select_v32i32:
; VBITS_GE_1024:       // %bb.0:
; VBITS_GE_1024-NEXT:    stp x29, x30, [sp, #-32]! // 16-byte Folded Spill
; VBITS_GE_1024-NEXT:    sub x9, sp, #224
; VBITS_GE_1024-NEXT:    str x19, [sp, #16] // 8-byte Folded Spill
; VBITS_GE_1024-NEXT:    mov x29, sp
; VBITS_GE_1024-NEXT:    and sp, x9, #0xffffffffffffff80
; VBITS_GE_1024-NEXT:    .cfi_def_cfa w29, 32
; VBITS_GE_1024-NEXT:    .cfi_offset w19, -16
; VBITS_GE_1024-NEXT:    .cfi_offset w30, -24
; VBITS_GE_1024-NEXT:    .cfi_offset w29, -32
; VBITS_GE_1024-NEXT:    ldr w8, [x2]
; VBITS_GE_1024-NEXT:    ptrue p0.s, vl32
; VBITS_GE_1024-NEXT:    mov x9, sp
; VBITS_GE_1024-NEXT:    ptrue p1.s
; VBITS_GE_1024-NEXT:    asr w10, w8, #31
; VBITS_GE_1024-NEXT:    sbfx w11, w8, #30, #1
; VBITS_GE_1024-NEXT:    stp w11, w10, [sp, #120]
; VBITS_GE_1024-NEXT:    sbfx w10, w8, #15, #1
; VBITS_GE_1024-NEXT:    sbfx w11, w8, #14, #1
; VBITS_GE_1024-NEXT:    sbfx w12, w8, #29, #1
; VBITS_GE_1024-NEXT:    sbfx w13, w8, #28, #1
; VBITS_GE_1024-NEXT:    stp w11, w10, [sp, #56]
; VBITS_GE_1024-NEXT:    sbfx w10, w8, #7, #1
; VBITS_GE_1024-NEXT:    sbfx w11, w8, #6, #1
; VBITS_GE_1024-NEXT:    sbfx w14, w8, #27, #1
; VBITS_GE_1024-NEXT:    sbfx w15, w8, #26, #1
; VBITS_GE_1024-NEXT:    sbfx w16, w8, #25, #1
; VBITS_GE_1024-NEXT:    sbfx w17, w8, #24, #1
; VBITS_GE_1024-NEXT:    stp w13, w12, [sp, #112]
; VBITS_GE_1024-NEXT:    sbfx w12, w8, #13, #1
; VBITS_GE_1024-NEXT:    sbfx w13, w8, #12, #1
; VBITS_GE_1024-NEXT:    stp w11, w10, [sp, #24]
; VBITS_GE_1024-NEXT:    sbfx w10, w8, #3, #1
; VBITS_GE_1024-NEXT:    sbfx w11, w8, #2, #1
; VBITS_GE_1024-NEXT:    sbfx w18, w8, #23, #1
; VBITS_GE_1024-NEXT:    sbfx w2, w8, #22, #1
; VBITS_GE_1024-NEXT:    sbfx w3, w8, #21, #1
; VBITS_GE_1024-NEXT:    sbfx w4, w8, #20, #1
; VBITS_GE_1024-NEXT:    sbfx w5, w8, #19, #1
; VBITS_GE_1024-NEXT:    sbfx w6, w8, #18, #1
; VBITS_GE_1024-NEXT:    sbfx w7, w8, #17, #1
; VBITS_GE_1024-NEXT:    sbfx w19, w8, #16, #1
; VBITS_GE_1024-NEXT:    stp w15, w14, [sp, #104]
; VBITS_GE_1024-NEXT:    stp w17, w16, [sp, #96]
; VBITS_GE_1024-NEXT:    sbfx w14, w8, #11, #1
; VBITS_GE_1024-NEXT:    sbfx w15, w8, #10, #1
; VBITS_GE_1024-NEXT:    sbfx w16, w8, #9, #1
; VBITS_GE_1024-NEXT:    sbfx w17, w8, #8, #1
; VBITS_GE_1024-NEXT:    stp w13, w12, [sp, #48]
; VBITS_GE_1024-NEXT:    sbfx w12, w8, #5, #1
; VBITS_GE_1024-NEXT:    sbfx w13, w8, #4, #1
; VBITS_GE_1024-NEXT:    stp w11, w10, [sp, #8]
; VBITS_GE_1024-NEXT:    sbfx w10, w8, #1, #1
; VBITS_GE_1024-NEXT:    sbfx w8, w8, #0, #1
; VBITS_GE_1024-NEXT:    stp w2, w18, [sp, #88]
; VBITS_GE_1024-NEXT:    stp w4, w3, [sp, #80]
; VBITS_GE_1024-NEXT:    stp w6, w5, [sp, #72]
; VBITS_GE_1024-NEXT:    stp w19, w7, [sp, #64]
; VBITS_GE_1024-NEXT:    stp w15, w14, [sp, #40]
; VBITS_GE_1024-NEXT:    stp w17, w16, [sp, #32]
; VBITS_GE_1024-NEXT:    stp w13, w12, [sp, #16]
; VBITS_GE_1024-NEXT:    stp w8, w10, [sp]
; VBITS_GE_1024-NEXT:    ld1w { z0.s }, p0/z, [x9]
; VBITS_GE_1024-NEXT:    ld1w { z1.s }, p0/z, [x0]
; VBITS_GE_1024-NEXT:    ld1w { z2.s }, p0/z, [x1]
; VBITS_GE_1024-NEXT:    and z0.s, z0.s, #0x1
; VBITS_GE_1024-NEXT:    cmpne p1.s, p1/z, z0.s, #0
; VBITS_GE_1024-NEXT:    sel z0.s, p1, z1.s, z2.s
; VBITS_GE_1024-NEXT:    st1w { z0.s }, p0, [x0]
; VBITS_GE_1024-NEXT:    mov sp, x29
; VBITS_GE_1024-NEXT:    ldr x19, [sp, #16] // 8-byte Folded Reload
; VBITS_GE_1024-NEXT:    ldp x29, x30, [sp], #32 // 16-byte Folded Reload
; VBITS_GE_1024-NEXT:    ret
  %mask = load <32 x i1>, <32 x i1>* %c
  %op1 = load <32 x i32>, <32 x i32>* %a
  %op2 = load <32 x i32>, <32 x i32>* %b
  %sel = select <32 x i1> %mask, <32 x i32> %op1, <32 x i32> %op2
  store <32 x i32> %sel, <32 x i32>* %a
  ret void
}

define void @select_v64i32(<64 x i32>* %a, <64 x i32>* %b, <64 x i1>* %c) #0 {
; VBITS_GE_2048-LABEL: select_v64i32:
; VBITS_GE_2048:       // %bb.0:
; VBITS_GE_2048-NEXT:    stp x29, x30, [sp, #-96]! // 16-byte Folded Spill
; VBITS_GE_2048-NEXT:    sub x9, sp, #672
; VBITS_GE_2048-NEXT:    stp x28, x27, [sp, #16] // 16-byte Folded Spill
; VBITS_GE_2048-NEXT:    stp x26, x25, [sp, #32] // 16-byte Folded Spill
; VBITS_GE_2048-NEXT:    stp x24, x23, [sp, #48] // 16-byte Folded Spill
; VBITS_GE_2048-NEXT:    stp x22, x21, [sp, #64] // 16-byte Folded Spill
; VBITS_GE_2048-NEXT:    stp x20, x19, [sp, #80] // 16-byte Folded Spill
; VBITS_GE_2048-NEXT:    mov x29, sp
; VBITS_GE_2048-NEXT:    and sp, x9, #0xffffffffffffff00
; VBITS_GE_2048-NEXT:    .cfi_def_cfa w29, 96
; VBITS_GE_2048-NEXT:    .cfi_offset w19, -8
; VBITS_GE_2048-NEXT:    .cfi_offset w20, -16
; VBITS_GE_2048-NEXT:    .cfi_offset w21, -24
; VBITS_GE_2048-NEXT:    .cfi_offset w22, -32
; VBITS_GE_2048-NEXT:    .cfi_offset w23, -40
; VBITS_GE_2048-NEXT:    .cfi_offset w24, -48
; VBITS_GE_2048-NEXT:    .cfi_offset w25, -56
; VBITS_GE_2048-NEXT:    .cfi_offset w26, -64
; VBITS_GE_2048-NEXT:    .cfi_offset w27, -72
; VBITS_GE_2048-NEXT:    .cfi_offset w28, -80
; VBITS_GE_2048-NEXT:    .cfi_offset w30, -88
; VBITS_GE_2048-NEXT:    .cfi_offset w29, -96
; VBITS_GE_2048-NEXT:    ldr x8, [x2]
; VBITS_GE_2048-NEXT:    ptrue p0.s, vl64
; VBITS_GE_2048-NEXT:    add x9, sp, #256
; VBITS_GE_2048-NEXT:    ptrue p1.s
; VBITS_GE_2048-NEXT:    asr x10, x8, #63
; VBITS_GE_2048-NEXT:    str w10, [sp, #508]
; VBITS_GE_2048-NEXT:    sbfx x10, x8, #37, #1
; VBITS_GE_2048-NEXT:    sbfx x11, x8, #62, #1
; VBITS_GE_2048-NEXT:    str w10, [sp, #404]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #18, #1
; VBITS_GE_2048-NEXT:    sbfx x12, x8, #61, #1
; VBITS_GE_2048-NEXT:    sbfx x13, x8, #60, #1
; VBITS_GE_2048-NEXT:    sbfx x14, x8, #59, #1
; VBITS_GE_2048-NEXT:    str w11, [sp, #504]
; VBITS_GE_2048-NEXT:    sbfx x11, x8, #36, #1
; VBITS_GE_2048-NEXT:    str w10, [sp, #328]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #9, #1
; VBITS_GE_2048-NEXT:    sbfx x15, x8, #58, #1
; VBITS_GE_2048-NEXT:    sbfx x16, x8, #57, #1
; VBITS_GE_2048-NEXT:    sbfx x17, x8, #56, #1
; VBITS_GE_2048-NEXT:    sbfx x18, x8, #55, #1
; VBITS_GE_2048-NEXT:    str w12, [sp, #500]
; VBITS_GE_2048-NEXT:    sbfx x12, x8, #35, #1
; VBITS_GE_2048-NEXT:    str w13, [sp, #496]
; VBITS_GE_2048-NEXT:    sbfx x13, x8, #34, #1
; VBITS_GE_2048-NEXT:    str w14, [sp, #492]
; VBITS_GE_2048-NEXT:    sbfx x14, x8, #33, #1
; VBITS_GE_2048-NEXT:    str w11, [sp, #400]
; VBITS_GE_2048-NEXT:    sbfx w11, w8, #17, #1
; VBITS_GE_2048-NEXT:    str w10, [sp, #292]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #4, #1
; VBITS_GE_2048-NEXT:    sbfx x2, x8, #54, #1
; VBITS_GE_2048-NEXT:    sbfx x3, x8, #53, #1
; VBITS_GE_2048-NEXT:    sbfx x4, x8, #52, #1
; VBITS_GE_2048-NEXT:    sbfx x5, x8, #51, #1
; VBITS_GE_2048-NEXT:    sbfx x6, x8, #50, #1
; VBITS_GE_2048-NEXT:    sbfx x7, x8, #49, #1
; VBITS_GE_2048-NEXT:    sbfx x19, x8, #48, #1
; VBITS_GE_2048-NEXT:    sbfx x20, x8, #47, #1
; VBITS_GE_2048-NEXT:    sbfx x21, x8, #46, #1
; VBITS_GE_2048-NEXT:    sbfx x22, x8, #45, #1
; VBITS_GE_2048-NEXT:    str w15, [sp, #488]
; VBITS_GE_2048-NEXT:    sbfx x15, x8, #32, #1
; VBITS_GE_2048-NEXT:    str w16, [sp, #484]
; VBITS_GE_2048-NEXT:    asr w16, w8, #31
; VBITS_GE_2048-NEXT:    str w17, [sp, #480]
; VBITS_GE_2048-NEXT:    sbfx w17, w8, #30, #1
; VBITS_GE_2048-NEXT:    str w18, [sp, #476]
; VBITS_GE_2048-NEXT:    sbfx w18, w8, #29, #1
; VBITS_GE_2048-NEXT:    str w12, [sp, #396]
; VBITS_GE_2048-NEXT:    str w13, [sp, #392]
; VBITS_GE_2048-NEXT:    str w14, [sp, #388]
; VBITS_GE_2048-NEXT:    sbfx w12, w8, #16, #1
; VBITS_GE_2048-NEXT:    sbfx w13, w8, #15, #1
; VBITS_GE_2048-NEXT:    sbfx w14, w8, #14, #1
; VBITS_GE_2048-NEXT:    str w11, [sp, #324]
; VBITS_GE_2048-NEXT:    sbfx w11, w8, #8, #1
; VBITS_GE_2048-NEXT:    str w10, [sp, #272]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #2, #1
; VBITS_GE_2048-NEXT:    sbfx x23, x8, #44, #1
; VBITS_GE_2048-NEXT:    sbfx x24, x8, #43, #1
; VBITS_GE_2048-NEXT:    sbfx x25, x8, #42, #1
; VBITS_GE_2048-NEXT:    sbfx x26, x8, #41, #1
; VBITS_GE_2048-NEXT:    sbfx x27, x8, #40, #1
; VBITS_GE_2048-NEXT:    sbfx x28, x8, #39, #1
; VBITS_GE_2048-NEXT:    sbfx x30, x8, #38, #1
; VBITS_GE_2048-NEXT:    str w2, [sp, #472]
; VBITS_GE_2048-NEXT:    sbfx w2, w8, #28, #1
; VBITS_GE_2048-NEXT:    str w3, [sp, #468]
; VBITS_GE_2048-NEXT:    sbfx w3, w8, #27, #1
; VBITS_GE_2048-NEXT:    str w4, [sp, #464]
; VBITS_GE_2048-NEXT:    sbfx w4, w8, #26, #1
; VBITS_GE_2048-NEXT:    str w5, [sp, #460]
; VBITS_GE_2048-NEXT:    str w6, [sp, #456]
; VBITS_GE_2048-NEXT:    sbfx w5, w8, #25, #1
; VBITS_GE_2048-NEXT:    str w7, [sp, #452]
; VBITS_GE_2048-NEXT:    str w19, [sp, #448]
; VBITS_GE_2048-NEXT:    sbfx w6, w8, #24, #1
; VBITS_GE_2048-NEXT:    str w20, [sp, #444]
; VBITS_GE_2048-NEXT:    str w21, [sp, #440]
; VBITS_GE_2048-NEXT:    sbfx w7, w8, #23, #1
; VBITS_GE_2048-NEXT:    str w22, [sp, #436]
; VBITS_GE_2048-NEXT:    sbfx w19, w8, #22, #1
; VBITS_GE_2048-NEXT:    sbfx w20, w8, #21, #1
; VBITS_GE_2048-NEXT:    sbfx w21, w8, #20, #1
; VBITS_GE_2048-NEXT:    sbfx w22, w8, #19, #1
; VBITS_GE_2048-NEXT:    str w15, [sp, #384]
; VBITS_GE_2048-NEXT:    str w16, [sp, #380]
; VBITS_GE_2048-NEXT:    str w17, [sp, #376]
; VBITS_GE_2048-NEXT:    str w18, [sp, #372]
; VBITS_GE_2048-NEXT:    sbfx w15, w8, #13, #1
; VBITS_GE_2048-NEXT:    sbfx w16, w8, #12, #1
; VBITS_GE_2048-NEXT:    sbfx w17, w8, #11, #1
; VBITS_GE_2048-NEXT:    sbfx w18, w8, #10, #1
; VBITS_GE_2048-NEXT:    str w12, [sp, #320]
; VBITS_GE_2048-NEXT:    str w13, [sp, #316]
; VBITS_GE_2048-NEXT:    str w14, [sp, #312]
; VBITS_GE_2048-NEXT:    sbfx w12, w8, #7, #1
; VBITS_GE_2048-NEXT:    sbfx w13, w8, #6, #1
; VBITS_GE_2048-NEXT:    sbfx w14, w8, #5, #1
; VBITS_GE_2048-NEXT:    str w11, [sp, #288]
; VBITS_GE_2048-NEXT:    sbfx w11, w8, #3, #1
; VBITS_GE_2048-NEXT:    str w10, [sp, #264]
; VBITS_GE_2048-NEXT:    sbfx w10, w8, #1, #1
; VBITS_GE_2048-NEXT:    sbfx w8, w8, #0, #1
; VBITS_GE_2048-NEXT:    str w23, [sp, #432]
; VBITS_GE_2048-NEXT:    str w24, [sp, #428]
; VBITS_GE_2048-NEXT:    str w25, [sp, #424]
; VBITS_GE_2048-NEXT:    str w26, [sp, #420]
; VBITS_GE_2048-NEXT:    str w27, [sp, #416]
; VBITS_GE_2048-NEXT:    str w28, [sp, #412]
; VBITS_GE_2048-NEXT:    str w30, [sp, #408]
; VBITS_GE_2048-NEXT:    str w2, [sp, #368]
; VBITS_GE_2048-NEXT:    str w3, [sp, #364]
; VBITS_GE_2048-NEXT:    str w4, [sp, #360]
; VBITS_GE_2048-NEXT:    str w5, [sp, #356]
; VBITS_GE_2048-NEXT:    str w6, [sp, #352]
; VBITS_GE_2048-NEXT:    str w7, [sp, #348]
; VBITS_GE_2048-NEXT:    str w19, [sp, #344]
; VBITS_GE_2048-NEXT:    str w20, [sp, #340]
; VBITS_GE_2048-NEXT:    str w21, [sp, #336]
; VBITS_GE_2048-NEXT:    str w22, [sp, #332]
; VBITS_GE_2048-NEXT:    str w15, [sp, #308]
; VBITS_GE_2048-NEXT:    str w16, [sp, #304]
; VBITS_GE_2048-NEXT:    str w17, [sp, #300]
; VBITS_GE_2048-NEXT:    str w18, [sp, #296]
; VBITS_GE_2048-NEXT:    str w12, [sp, #284]
; VBITS_GE_2048-NEXT:    str w13, [sp, #280]
; VBITS_GE_2048-NEXT:    str w14, [sp, #276]
; VBITS_GE_2048-NEXT:    str w11, [sp, #268]
; VBITS_GE_2048-NEXT:    str w10, [sp, #260]
; VBITS_GE_2048-NEXT:    str w8, [sp, #256]
; VBITS_GE_2048-NEXT:    ld1w { z0.s }, p0/z, [x9]
; VBITS_GE_2048-NEXT:    ld1w { z1.s }, p0/z, [x0]
; VBITS_GE_2048-NEXT:    ld1w { z2.s }, p0/z, [x1]
; VBITS_GE_2048-NEXT:    and z0.s, z0.s, #0x1
; VBITS_GE_2048-NEXT:    cmpne p1.s, p1/z, z0.s, #0
; VBITS_GE_2048-NEXT:    sel z0.s, p1, z1.s, z2.s
; VBITS_GE_2048-NEXT:    st1w { z0.s }, p0, [x0]
; VBITS_GE_2048-NEXT:    mov sp, x29
; VBITS_GE_2048-NEXT:    ldp x20, x19, [sp, #80] // 16-byte Folded Reload
; VBITS_GE_2048-NEXT:    ldp x22, x21, [sp, #64] // 16-byte Folded Reload
; VBITS_GE_2048-NEXT:    ldp x24, x23, [sp, #48] // 16-byte Folded Reload
; VBITS_GE_2048-NEXT:    ldp x26, x25, [sp, #32] // 16-byte Folded Reload
; VBITS_GE_2048-NEXT:    ldp x28, x27, [sp, #16] // 16-byte Folded Reload
; VBITS_GE_2048-NEXT:    ldp x29, x30, [sp], #96 // 16-byte Folded Reload
; VBITS_GE_2048-NEXT:    ret
  %mask = load <64 x i1>, <64 x i1>* %c
  %op1 = load <64 x i32>, <64 x i32>* %a
  %op2 = load <64 x i32>, <64 x i32>* %b
  %sel = select <64 x i1> %mask, <64 x i32> %op1, <64 x i32> %op2
  store <64 x i32> %sel, <64 x i32>* %a
  ret void
}

; Don't use SVE for 64-bit vectors.
define <1 x i64> @select_v1i64(<1 x i64> %op1, <1 x i64> %op2, <1 x i1> %mask) #0 {
; CHECK-LABEL: select_v1i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    tst w0, #0x1
; CHECK-NEXT:    csetm x8, ne
; CHECK-NEXT:    fmov d2, x8
; CHECK-NEXT:    bif v0.8b, v1.8b, v2.8b
; CHECK-NEXT:    ret
  %sel = select <1 x i1> %mask, <1 x i64> %op1, <1 x i64> %op2
  ret <1 x i64> %sel
}

; Don't use SVE for 128-bit vectors.
define <2 x i64> @select_v2i64(<2 x i64> %op1, <2 x i64> %op2, <2 x i1> %mask) #0 {
; CHECK-LABEL: select_v2i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ushll v2.2d, v2.2s, #0
; CHECK-NEXT:    shl v2.2d, v2.2d, #63
; CHECK-NEXT:    sshr v2.2d, v2.2d, #63
; CHECK-NEXT:    bif v0.16b, v1.16b, v2.16b
; CHECK-NEXT:    ret
  %sel = select <2 x i1> %mask, <2 x i64> %op1, <2 x i64> %op2
  ret <2 x i64> %sel
}

define void @select_v4i64(<4 x i64>* %a, <4 x i64>* %b, <4 x i1>* %c) #0 {
; CHECK-LABEL: select_v4i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    stp x29, x30, [sp, #-16]! // 16-byte Folded Spill
; CHECK-NEXT:    sub x9, sp, #48
; CHECK-NEXT:    mov x29, sp
; CHECK-NEXT:    and sp, x9, #0xffffffffffffffe0
; CHECK-NEXT:    .cfi_def_cfa w29, 16
; CHECK-NEXT:    .cfi_offset w30, -8
; CHECK-NEXT:    .cfi_offset w29, -16
; CHECK-NEXT:    ldrb w8, [x2]
; CHECK-NEXT:    ptrue p0.d, vl4
; CHECK-NEXT:    mov x9, sp
; CHECK-NEXT:    ptrue p1.d
; CHECK-NEXT:    lsr w10, w8, #3
; CHECK-NEXT:    lsr w11, w8, #2
; CHECK-NEXT:    sbfx x10, x10, #0, #1
; CHECK-NEXT:    sbfx x11, x11, #0, #1
; CHECK-NEXT:    stp x11, x10, [sp, #16]
; CHECK-NEXT:    sbfx x10, x8, #0, #1
; CHECK-NEXT:    lsr w8, w8, #1
; CHECK-NEXT:    sbfx x8, x8, #0, #1
; CHECK-NEXT:    stp x10, x8, [sp]
; CHECK-NEXT:    ld1d { z0.d }, p0/z, [x9]
; CHECK-NEXT:    ld1d { z1.d }, p0/z, [x0]
; CHECK-NEXT:    ld1d { z2.d }, p0/z, [x1]
; CHECK-NEXT:    and z0.d, z0.d, #0x1
; CHECK-NEXT:    cmpne p1.d, p1/z, z0.d, #0
; CHECK-NEXT:    sel z0.d, p1, z1.d, z2.d
; CHECK-NEXT:    st1d { z0.d }, p0, [x0]
; CHECK-NEXT:    mov sp, x29
; CHECK-NEXT:    ldp x29, x30, [sp], #16 // 16-byte Folded Reload
; CHECK-NEXT:    ret
  %mask = load <4 x i1>, <4 x i1>* %c
  %op1 = load <4 x i64>, <4 x i64>* %a
  %op2 = load <4 x i64>, <4 x i64>* %b
  %sel = select <4 x i1> %mask, <4 x i64> %op1, <4 x i64> %op2
  store <4 x i64> %sel, <4 x i64>* %a
  ret void
}

define void @select_v8i64(<8 x i64>* %a, <8 x i64>* %b, <8 x i1>* %c) #0 {
; VBITS_GE_512-LABEL: select_v8i64:
; VBITS_GE_512:       // %bb.0:
; VBITS_GE_512-NEXT:    stp x29, x30, [sp, #-16]! // 16-byte Folded Spill
; VBITS_GE_512-NEXT:    sub x9, sp, #112
; VBITS_GE_512-NEXT:    mov x29, sp
; VBITS_GE_512-NEXT:    and sp, x9, #0xffffffffffffffc0
; VBITS_GE_512-NEXT:    .cfi_def_cfa w29, 16
; VBITS_GE_512-NEXT:    .cfi_offset w30, -8
; VBITS_GE_512-NEXT:    .cfi_offset w29, -16
; VBITS_GE_512-NEXT:    ldrb w8, [x2]
; VBITS_GE_512-NEXT:    ptrue p0.d, vl8
; VBITS_GE_512-NEXT:    mov x9, sp
; VBITS_GE_512-NEXT:    ptrue p1.d
; VBITS_GE_512-NEXT:    lsr w10, w8, #7
; VBITS_GE_512-NEXT:    lsr w11, w8, #6
; VBITS_GE_512-NEXT:    lsr w12, w8, #5
; VBITS_GE_512-NEXT:    lsr w13, w8, #4
; VBITS_GE_512-NEXT:    sbfx x10, x10, #0, #1
; VBITS_GE_512-NEXT:    sbfx x11, x11, #0, #1
; VBITS_GE_512-NEXT:    stp x11, x10, [sp, #48]
; VBITS_GE_512-NEXT:    sbfx x11, x12, #0, #1
; VBITS_GE_512-NEXT:    sbfx x12, x13, #0, #1
; VBITS_GE_512-NEXT:    lsr w10, w8, #3
; VBITS_GE_512-NEXT:    stp x12, x11, [sp, #32]
; VBITS_GE_512-NEXT:    lsr w11, w8, #2
; VBITS_GE_512-NEXT:    sbfx x10, x10, #0, #1
; VBITS_GE_512-NEXT:    sbfx x11, x11, #0, #1
; VBITS_GE_512-NEXT:    stp x11, x10, [sp, #16]
; VBITS_GE_512-NEXT:    sbfx x10, x8, #0, #1
; VBITS_GE_512-NEXT:    lsr w8, w8, #1
; VBITS_GE_512-NEXT:    sbfx x8, x8, #0, #1
; VBITS_GE_512-NEXT:    stp x10, x8, [sp]
; VBITS_GE_512-NEXT:    ld1d { z0.d }, p0/z, [x9]
; VBITS_GE_512-NEXT:    ld1d { z1.d }, p0/z, [x0]
; VBITS_GE_512-NEXT:    ld1d { z2.d }, p0/z, [x1]
; VBITS_GE_512-NEXT:    and z0.d, z0.d, #0x1
; VBITS_GE_512-NEXT:    cmpne p1.d, p1/z, z0.d, #0
; VBITS_GE_512-NEXT:    sel z0.d, p1, z1.d, z2.d
; VBITS_GE_512-NEXT:    st1d { z0.d }, p0, [x0]
; VBITS_GE_512-NEXT:    mov sp, x29
; VBITS_GE_512-NEXT:    ldp x29, x30, [sp], #16 // 16-byte Folded Reload
; VBITS_GE_512-NEXT:    ret
  %mask = load <8 x i1>, <8 x i1>* %c
  %op1 = load <8 x i64>, <8 x i64>* %a
  %op2 = load <8 x i64>, <8 x i64>* %b
  %sel = select <8 x i1> %mask, <8 x i64> %op1, <8 x i64> %op2
  store <8 x i64> %sel, <8 x i64>* %a
  ret void
}

define void @select_v16i64(<16 x i64>* %a, <16 x i64>* %b, <16 x i1>* %c) #0 {
; VBITS_GE_1024-LABEL: select_v16i64:
; VBITS_GE_1024:       // %bb.0:
; VBITS_GE_1024-NEXT:    stp x29, x30, [sp, #-16]! // 16-byte Folded Spill
; VBITS_GE_1024-NEXT:    sub x9, sp, #240
; VBITS_GE_1024-NEXT:    mov x29, sp
; VBITS_GE_1024-NEXT:    and sp, x9, #0xffffffffffffff80
; VBITS_GE_1024-NEXT:    .cfi_def_cfa w29, 16
; VBITS_GE_1024-NEXT:    .cfi_offset w30, -8
; VBITS_GE_1024-NEXT:    .cfi_offset w29, -16
; VBITS_GE_1024-NEXT:    ldrh w8, [x2]
; VBITS_GE_1024-NEXT:    ptrue p0.d, vl16
; VBITS_GE_1024-NEXT:    mov x9, sp
; VBITS_GE_1024-NEXT:    ptrue p1.d
; VBITS_GE_1024-NEXT:    lsr w10, w8, #15
; VBITS_GE_1024-NEXT:    lsr w11, w8, #14
; VBITS_GE_1024-NEXT:    lsr w12, w8, #13
; VBITS_GE_1024-NEXT:    lsr w13, w8, #12
; VBITS_GE_1024-NEXT:    sbfx x10, x10, #0, #1
; VBITS_GE_1024-NEXT:    sbfx x11, x11, #0, #1
; VBITS_GE_1024-NEXT:    lsr w14, w8, #11
; VBITS_GE_1024-NEXT:    lsr w15, w8, #10
; VBITS_GE_1024-NEXT:    stp x11, x10, [sp, #112]
; VBITS_GE_1024-NEXT:    sbfx x11, x12, #0, #1
; VBITS_GE_1024-NEXT:    sbfx x12, x13, #0, #1
; VBITS_GE_1024-NEXT:    lsr w16, w8, #9
; VBITS_GE_1024-NEXT:    lsr w17, w8, #8
; VBITS_GE_1024-NEXT:    stp x12, x11, [sp, #96]
; VBITS_GE_1024-NEXT:    sbfx x12, x14, #0, #1
; VBITS_GE_1024-NEXT:    sbfx x13, x15, #0, #1
; VBITS_GE_1024-NEXT:    lsr w10, w8, #7
; VBITS_GE_1024-NEXT:    lsr w11, w8, #6
; VBITS_GE_1024-NEXT:    stp x13, x12, [sp, #80]
; VBITS_GE_1024-NEXT:    sbfx x13, x16, #0, #1
; VBITS_GE_1024-NEXT:    sbfx x14, x17, #0, #1
; VBITS_GE_1024-NEXT:    lsr w12, w8, #5
; VBITS_GE_1024-NEXT:    stp x14, x13, [sp, #64]
; VBITS_GE_1024-NEXT:    lsr w13, w8, #4
; VBITS_GE_1024-NEXT:    sbfx x10, x10, #0, #1
; VBITS_GE_1024-NEXT:    sbfx x11, x11, #0, #1
; VBITS_GE_1024-NEXT:    stp x11, x10, [sp, #48]
; VBITS_GE_1024-NEXT:    sbfx x11, x12, #0, #1
; VBITS_GE_1024-NEXT:    sbfx x12, x13, #0, #1
; VBITS_GE_1024-NEXT:    lsr w10, w8, #3
; VBITS_GE_1024-NEXT:    stp x12, x11, [sp, #32]
; VBITS_GE_1024-NEXT:    lsr w11, w8, #2
; VBITS_GE_1024-NEXT:    sbfx x10, x10, #0, #1
; VBITS_GE_1024-NEXT:    sbfx x11, x11, #0, #1
; VBITS_GE_1024-NEXT:    stp x11, x10, [sp, #16]
; VBITS_GE_1024-NEXT:    sbfx x10, x8, #0, #1
; VBITS_GE_1024-NEXT:    lsr w8, w8, #1
; VBITS_GE_1024-NEXT:    sbfx x8, x8, #0, #1
; VBITS_GE_1024-NEXT:    stp x10, x8, [sp]
; VBITS_GE_1024-NEXT:    ld1d { z0.d }, p0/z, [x9]
; VBITS_GE_1024-NEXT:    ld1d { z1.d }, p0/z, [x0]
; VBITS_GE_1024-NEXT:    ld1d { z2.d }, p0/z, [x1]
; VBITS_GE_1024-NEXT:    and z0.d, z0.d, #0x1
; VBITS_GE_1024-NEXT:    cmpne p1.d, p1/z, z0.d, #0
; VBITS_GE_1024-NEXT:    sel z0.d, p1, z1.d, z2.d
; VBITS_GE_1024-NEXT:    st1d { z0.d }, p0, [x0]
; VBITS_GE_1024-NEXT:    mov sp, x29
; VBITS_GE_1024-NEXT:    ldp x29, x30, [sp], #16 // 16-byte Folded Reload
; VBITS_GE_1024-NEXT:    ret
  %mask = load <16 x i1>, <16 x i1>* %c
  %op1 = load <16 x i64>, <16 x i64>* %a
  %op2 = load <16 x i64>, <16 x i64>* %b
  %sel = select <16 x i1> %mask, <16 x i64> %op1, <16 x i64> %op2
  store <16 x i64> %sel, <16 x i64>* %a
  ret void
}

define void @select_v32i64(<32 x i64>* %a, <32 x i64>* %b, <32 x i1>* %c) #0 {
; VBITS_GE_2048-LABEL: select_v32i64:
; VBITS_GE_2048:       // %bb.0:
; VBITS_GE_2048-NEXT:    stp x29, x30, [sp, #-32]! // 16-byte Folded Spill
; VBITS_GE_2048-NEXT:    sub x9, sp, #480
; VBITS_GE_2048-NEXT:    str x19, [sp, #16] // 8-byte Folded Spill
; VBITS_GE_2048-NEXT:    mov x29, sp
; VBITS_GE_2048-NEXT:    and sp, x9, #0xffffffffffffff00
; VBITS_GE_2048-NEXT:    .cfi_def_cfa w29, 32
; VBITS_GE_2048-NEXT:    .cfi_offset w19, -16
; VBITS_GE_2048-NEXT:    .cfi_offset w30, -24
; VBITS_GE_2048-NEXT:    .cfi_offset w29, -32
; VBITS_GE_2048-NEXT:    ldr w8, [x2]
; VBITS_GE_2048-NEXT:    ptrue p0.d, vl32
; VBITS_GE_2048-NEXT:    mov x9, sp
; VBITS_GE_2048-NEXT:    ptrue p1.d
; VBITS_GE_2048-NEXT:    ubfx x10, x8, #31, #1
; VBITS_GE_2048-NEXT:    ubfx x11, x8, #30, #2
; VBITS_GE_2048-NEXT:    ubfx x12, x8, #29, #3
; VBITS_GE_2048-NEXT:    // kill: def $w10 killed $w10 killed $x10 def $x10
; VBITS_GE_2048-NEXT:    // kill: def $w11 killed $w11 killed $x11 def $x11
; VBITS_GE_2048-NEXT:    ubfx x13, x8, #28, #4
; VBITS_GE_2048-NEXT:    sbfx x10, x10, #0, #1
; VBITS_GE_2048-NEXT:    sbfx x11, x11, #0, #1
; VBITS_GE_2048-NEXT:    // kill: def $w12 killed $w12 killed $x12 def $x12
; VBITS_GE_2048-NEXT:    ubfx x14, x8, #27, #5
; VBITS_GE_2048-NEXT:    ubfx x15, x8, #26, #6
; VBITS_GE_2048-NEXT:    stp x11, x10, [sp, #240]
; VBITS_GE_2048-NEXT:    sbfx x11, x12, #0, #1
; VBITS_GE_2048-NEXT:    // kill: def $w13 killed $w13 killed $x13 def $x13
; VBITS_GE_2048-NEXT:    sbfx x12, x13, #0, #1
; VBITS_GE_2048-NEXT:    ubfx x16, x8, #25, #7
; VBITS_GE_2048-NEXT:    ubfx x17, x8, #24, #8
; VBITS_GE_2048-NEXT:    stp x12, x11, [sp, #224]
; VBITS_GE_2048-NEXT:    // kill: def $w14 killed $w14 killed $x14 def $x14
; VBITS_GE_2048-NEXT:    sbfx x12, x14, #0, #1
; VBITS_GE_2048-NEXT:    // kill: def $w15 killed $w15 killed $x15 def $x15
; VBITS_GE_2048-NEXT:    sbfx x13, x15, #0, #1
; VBITS_GE_2048-NEXT:    ubfx x18, x8, #23, #9
; VBITS_GE_2048-NEXT:    ubfx x2, x8, #22, #10
; VBITS_GE_2048-NEXT:    stp x13, x12, [sp, #208]
; VBITS_GE_2048-NEXT:    // kill: def $w16 killed $w16 killed $x16 def $x16
; VBITS_GE_2048-NEXT:    sbfx x13, x16, #0, #1
; VBITS_GE_2048-NEXT:    // kill: def $w17 killed $w17 killed $x17 def $x17
; VBITS_GE_2048-NEXT:    sbfx x14, x17, #0, #1
; VBITS_GE_2048-NEXT:    ubfx x3, x8, #21, #11
; VBITS_GE_2048-NEXT:    ubfx x4, x8, #20, #12
; VBITS_GE_2048-NEXT:    ubfx x10, x8, #15, #17
; VBITS_GE_2048-NEXT:    ubfx x11, x8, #14, #18
; VBITS_GE_2048-NEXT:    stp x14, x13, [sp, #192]
; VBITS_GE_2048-NEXT:    // kill: def $w18 killed $w18 killed $x18 def $x18
; VBITS_GE_2048-NEXT:    sbfx x14, x18, #0, #1
; VBITS_GE_2048-NEXT:    // kill: def $w2 killed $w2 killed $x2 def $x2
; VBITS_GE_2048-NEXT:    sbfx x15, x2, #0, #1
; VBITS_GE_2048-NEXT:    ubfx x5, x8, #19, #13
; VBITS_GE_2048-NEXT:    ubfx x6, x8, #18, #14
; VBITS_GE_2048-NEXT:    ubfx x12, x8, #13, #19
; VBITS_GE_2048-NEXT:    stp x15, x14, [sp, #176]
; VBITS_GE_2048-NEXT:    // kill: def $w3 killed $w3 killed $x3 def $x3
; VBITS_GE_2048-NEXT:    sbfx x15, x3, #0, #1
; VBITS_GE_2048-NEXT:    // kill: def $w4 killed $w4 killed $x4 def $x4
; VBITS_GE_2048-NEXT:    sbfx x16, x4, #0, #1
; VBITS_GE_2048-NEXT:    // kill: def $w10 killed $w10 killed $x10 def $x10
; VBITS_GE_2048-NEXT:    // kill: def $w11 killed $w11 killed $x11 def $x11
; VBITS_GE_2048-NEXT:    ubfx x7, x8, #17, #15
; VBITS_GE_2048-NEXT:    ubfx x19, x8, #16, #16
; VBITS_GE_2048-NEXT:    ubfx x13, x8, #12, #20
; VBITS_GE_2048-NEXT:    stp x16, x15, [sp, #160]
; VBITS_GE_2048-NEXT:    // kill: def $w5 killed $w5 killed $x5 def $x5
; VBITS_GE_2048-NEXT:    sbfx x16, x5, #0, #1
; VBITS_GE_2048-NEXT:    // kill: def $w6 killed $w6 killed $x6 def $x6
; VBITS_GE_2048-NEXT:    sbfx x17, x6, #0, #1
; VBITS_GE_2048-NEXT:    sbfx x10, x10, #0, #1
; VBITS_GE_2048-NEXT:    sbfx x11, x11, #0, #1
; VBITS_GE_2048-NEXT:    // kill: def $w12 killed $w12 killed $x12 def $x12
; VBITS_GE_2048-NEXT:    ubfx x14, x8, #11, #21
; VBITS_GE_2048-NEXT:    ubfx x15, x8, #10, #22
; VBITS_GE_2048-NEXT:    stp x17, x16, [sp, #144]
; VBITS_GE_2048-NEXT:    // kill: def $w7 killed $w7 killed $x7 def $x7
; VBITS_GE_2048-NEXT:    sbfx x17, x7, #0, #1
; VBITS_GE_2048-NEXT:    // kill: def $w19 killed $w19 killed $x19 def $x19
; VBITS_GE_2048-NEXT:    sbfx x18, x19, #0, #1
; VBITS_GE_2048-NEXT:    stp x11, x10, [sp, #112]
; VBITS_GE_2048-NEXT:    sbfx x11, x12, #0, #1
; VBITS_GE_2048-NEXT:    // kill: def $w13 killed $w13 killed $x13 def $x13
; VBITS_GE_2048-NEXT:    sbfx x12, x13, #0, #1
; VBITS_GE_2048-NEXT:    ubfx x16, x8, #9, #23
; VBITS_GE_2048-NEXT:    stp x18, x17, [sp, #128]
; VBITS_GE_2048-NEXT:    ubfx x17, x8, #8, #24
; VBITS_GE_2048-NEXT:    ubfx x10, x8, #7, #25
; VBITS_GE_2048-NEXT:    stp x12, x11, [sp, #96]
; VBITS_GE_2048-NEXT:    ubfx x11, x8, #6, #26
; VBITS_GE_2048-NEXT:    // kill: def $w14 killed $w14 killed $x14 def $x14
; VBITS_GE_2048-NEXT:    sbfx x12, x14, #0, #1
; VBITS_GE_2048-NEXT:    // kill: def $w15 killed $w15 killed $x15 def $x15
; VBITS_GE_2048-NEXT:    sbfx x13, x15, #0, #1
; VBITS_GE_2048-NEXT:    stp x13, x12, [sp, #80]
; VBITS_GE_2048-NEXT:    ubfx x12, x8, #5, #27
; VBITS_GE_2048-NEXT:    // kill: def $w16 killed $w16 killed $x16 def $x16
; VBITS_GE_2048-NEXT:    sbfx x13, x16, #0, #1
; VBITS_GE_2048-NEXT:    // kill: def $w17 killed $w17 killed $x17 def $x17
; VBITS_GE_2048-NEXT:    sbfx x14, x17, #0, #1
; VBITS_GE_2048-NEXT:    // kill: def $w10 killed $w10 killed $x10 def $x10
; VBITS_GE_2048-NEXT:    // kill: def $w11 killed $w11 killed $x11 def $x11
; VBITS_GE_2048-NEXT:    stp x14, x13, [sp, #64]
; VBITS_GE_2048-NEXT:    ubfx x13, x8, #4, #28
; VBITS_GE_2048-NEXT:    sbfx x10, x10, #0, #1
; VBITS_GE_2048-NEXT:    sbfx x11, x11, #0, #1
; VBITS_GE_2048-NEXT:    // kill: def $w12 killed $w12 killed $x12 def $x12
; VBITS_GE_2048-NEXT:    stp x11, x10, [sp, #48]
; VBITS_GE_2048-NEXT:    sbfx x11, x12, #0, #1
; VBITS_GE_2048-NEXT:    // kill: def $w13 killed $w13 killed $x13 def $x13
; VBITS_GE_2048-NEXT:    sbfx x12, x13, #0, #1
; VBITS_GE_2048-NEXT:    ubfx x10, x8, #3, #29
; VBITS_GE_2048-NEXT:    stp x12, x11, [sp, #32]
; VBITS_GE_2048-NEXT:    ubfx x11, x8, #2, #30
; VBITS_GE_2048-NEXT:    // kill: def $w10 killed $w10 killed $x10 def $x10
; VBITS_GE_2048-NEXT:    // kill: def $w11 killed $w11 killed $x11 def $x11
; VBITS_GE_2048-NEXT:    sbfx x10, x10, #0, #1
; VBITS_GE_2048-NEXT:    sbfx x11, x11, #0, #1
; VBITS_GE_2048-NEXT:    stp x11, x10, [sp, #16]
; VBITS_GE_2048-NEXT:    ubfx x10, x8, #1, #31
; VBITS_GE_2048-NEXT:    // kill: def $w10 killed $w10 killed $x10 def $x10
; VBITS_GE_2048-NEXT:    sbfx x8, x8, #0, #1
; VBITS_GE_2048-NEXT:    sbfx x10, x10, #0, #1
; VBITS_GE_2048-NEXT:    stp x8, x10, [sp]
; VBITS_GE_2048-NEXT:    ld1d { z0.d }, p0/z, [x9]
; VBITS_GE_2048-NEXT:    ld1d { z1.d }, p0/z, [x0]
; VBITS_GE_2048-NEXT:    ld1d { z2.d }, p0/z, [x1]
; VBITS_GE_2048-NEXT:    and z0.d, z0.d, #0x1
; VBITS_GE_2048-NEXT:    cmpne p1.d, p1/z, z0.d, #0
; VBITS_GE_2048-NEXT:    sel z0.d, p1, z1.d, z2.d
; VBITS_GE_2048-NEXT:    st1d { z0.d }, p0, [x0]
; VBITS_GE_2048-NEXT:    mov sp, x29
; VBITS_GE_2048-NEXT:    ldr x19, [sp, #16] // 8-byte Folded Reload
; VBITS_GE_2048-NEXT:    ldp x29, x30, [sp], #32 // 16-byte Folded Reload
; VBITS_GE_2048-NEXT:    ret
  %mask = load <32 x i1>, <32 x i1>* %c
  %op1 = load <32 x i64>, <32 x i64>* %a
  %op2 = load <32 x i64>, <32 x i64>* %b
  %sel = select <32 x i1> %mask, <32 x i64> %op1, <32 x i64> %op2
  store <32 x i64> %sel, <32 x i64>* %a
  ret void
}

attributes #0 = { "target-features"="+sve" }
