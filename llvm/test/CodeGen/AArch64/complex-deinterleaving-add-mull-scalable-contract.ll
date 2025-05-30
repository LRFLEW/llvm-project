; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s --mattr=+sve -o - | FileCheck %s

target triple = "aarch64-unknown-linux-gnu"

; a * b + c
define <vscale x 4 x double> @mull_add(<vscale x 4 x double> %a, <vscale x 4 x double> %b, <vscale x 4 x double> %c) {
; CHECK-LABEL: mull_add:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    uzp2 z6.d, z0.d, z1.d
; CHECK-NEXT:    uzp1 z0.d, z0.d, z1.d
; CHECK-NEXT:    uzp2 z1.d, z2.d, z3.d
; CHECK-NEXT:    uzp1 z2.d, z2.d, z3.d
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    fmul z7.d, z0.d, z1.d
; CHECK-NEXT:    fmul z1.d, z6.d, z1.d
; CHECK-NEXT:    movprfx z3, z7
; CHECK-NEXT:    fmla z3.d, p0/m, z6.d, z2.d
; CHECK-NEXT:    fnmsb z0.d, p0/m, z2.d, z1.d
; CHECK-NEXT:    uzp2 z1.d, z4.d, z5.d
; CHECK-NEXT:    uzp1 z2.d, z4.d, z5.d
; CHECK-NEXT:    fadd z2.d, z2.d, z0.d
; CHECK-NEXT:    fadd z1.d, z3.d, z1.d
; CHECK-NEXT:    zip1 z0.d, z2.d, z1.d
; CHECK-NEXT:    zip2 z1.d, z2.d, z1.d
; CHECK-NEXT:    ret
entry:
  %strided.vec = tail call { <vscale x 2 x double>, <vscale x 2 x double> } @llvm.vector.deinterleave2.nxv4f64(<vscale x 4 x double> %a)
  %0 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec, 0
  %1 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec, 1
  %strided.vec29 = tail call { <vscale x 2 x double>, <vscale x 2 x double> } @llvm.vector.deinterleave2.nxv4f64(<vscale x 4 x double> %b)
  %2 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec29, 0
  %3 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec29, 1
  %4 = fmul contract <vscale x 2 x double> %0, %3
  %5 = fmul contract <vscale x 2 x double> %1, %2
  %6 = fadd contract <vscale x 2 x double> %5, %4
  %7 = fmul contract <vscale x 2 x double> %0, %2
  %8 = fmul contract <vscale x 2 x double> %1, %3
  %9 = fsub contract <vscale x 2 x double> %7, %8
  %strided.vec31 = tail call { <vscale x 2 x double>, <vscale x 2 x double> } @llvm.vector.deinterleave2.nxv4f64(<vscale x 4 x double> %c)
  %10 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec31, 0
  %11 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec31, 1
  %12 = fadd contract <vscale x 2 x double> %10, %9
  %13 = fadd contract <vscale x 2 x double> %6, %11
  %interleaved.vec = tail call <vscale x 4 x double> @llvm.vector.interleave2.nxv4f64(<vscale x 2 x double> %12, <vscale x 2 x double> %13)
  ret <vscale x 4 x double> %interleaved.vec
}

; a * b + c * d
define <vscale x 4 x double> @mul_add_mull(<vscale x 4 x double> %a, <vscale x 4 x double> %b, <vscale x 4 x double> %c, <vscale x 4 x double> %d) {
; CHECK-LABEL: mul_add_mull:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    movi v24.2d, #0000000000000000
; CHECK-NEXT:    movi v25.2d, #0000000000000000
; CHECK-NEXT:    movi v26.2d, #0000000000000000
; CHECK-NEXT:    movi v27.2d, #0000000000000000
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    fcmla z24.d, p0/m, z2.d, z0.d, #0
; CHECK-NEXT:    fcmla z25.d, p0/m, z3.d, z1.d, #0
; CHECK-NEXT:    fcmla z27.d, p0/m, z6.d, z4.d, #0
; CHECK-NEXT:    fcmla z26.d, p0/m, z7.d, z5.d, #0
; CHECK-NEXT:    fcmla z24.d, p0/m, z2.d, z0.d, #90
; CHECK-NEXT:    fcmla z25.d, p0/m, z3.d, z1.d, #90
; CHECK-NEXT:    fcmla z27.d, p0/m, z6.d, z4.d, #90
; CHECK-NEXT:    fcmla z26.d, p0/m, z7.d, z5.d, #90
; CHECK-NEXT:    fadd z0.d, z24.d, z27.d
; CHECK-NEXT:    fadd z1.d, z25.d, z26.d
; CHECK-NEXT:    ret
entry:
  %strided.vec = tail call { <vscale x 2 x double>, <vscale x 2 x double> } @llvm.vector.deinterleave2.nxv4f64(<vscale x 4 x double> %a)
  %0 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec, 0
  %1 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec, 1
  %strided.vec52 = tail call { <vscale x 2 x double>, <vscale x 2 x double> } @llvm.vector.deinterleave2.nxv4f64(<vscale x 4 x double> %b)
  %2 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec52, 0
  %3 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec52, 1
  %4 = fmul contract <vscale x 2 x double> %0, %3
  %5 = fmul contract <vscale x 2 x double> %1, %2
  %6 = fadd contract <vscale x 2 x double> %5, %4
  %7 = fmul contract <vscale x 2 x double> %0, %2
  %8 = fmul contract <vscale x 2 x double> %1, %3
  %9 = fsub contract <vscale x 2 x double> %7, %8
  %strided.vec54 = tail call { <vscale x 2 x double>, <vscale x 2 x double> } @llvm.vector.deinterleave2.nxv4f64(<vscale x 4 x double> %c)
  %10 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec54, 0
  %11 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec54, 1
  %strided.vec56 = tail call { <vscale x 2 x double>, <vscale x 2 x double> } @llvm.vector.deinterleave2.nxv4f64(<vscale x 4 x double> %d)
  %12 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec56, 0
  %13 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec56, 1
  %14 = fmul contract <vscale x 2 x double> %10, %13
  %15 = fmul contract <vscale x 2 x double> %11, %12
  %16 = fadd contract <vscale x 2 x double> %15, %14
  %17 = fmul contract <vscale x 2 x double> %10, %12
  %18 = fmul contract <vscale x 2 x double> %11, %13
  %19 = fsub contract <vscale x 2 x double> %17, %18
  %20 = fadd contract <vscale x 2 x double> %9, %19
  %21 = fadd contract <vscale x 2 x double> %6, %16
  %interleaved.vec = tail call <vscale x 4 x double> @llvm.vector.interleave2.nxv4f64(<vscale x 2 x double> %20, <vscale x 2 x double> %21)
  ret <vscale x 4 x double> %interleaved.vec
}

; a * b - c * d
define <vscale x 4 x double> @mul_sub_mull(<vscale x 4 x double> %a, <vscale x 4 x double> %b, <vscale x 4 x double> %c, <vscale x 4 x double> %d) {
; CHECK-LABEL: mul_sub_mull:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    movi v24.2d, #0000000000000000
; CHECK-NEXT:    movi v25.2d, #0000000000000000
; CHECK-NEXT:    movi v26.2d, #0000000000000000
; CHECK-NEXT:    movi v27.2d, #0000000000000000
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    fcmla z24.d, p0/m, z2.d, z0.d, #0
; CHECK-NEXT:    fcmla z25.d, p0/m, z3.d, z1.d, #0
; CHECK-NEXT:    fcmla z27.d, p0/m, z6.d, z4.d, #0
; CHECK-NEXT:    fcmla z26.d, p0/m, z7.d, z5.d, #0
; CHECK-NEXT:    fcmla z24.d, p0/m, z2.d, z0.d, #90
; CHECK-NEXT:    fcmla z25.d, p0/m, z3.d, z1.d, #90
; CHECK-NEXT:    fcmla z27.d, p0/m, z6.d, z4.d, #90
; CHECK-NEXT:    fcmla z26.d, p0/m, z7.d, z5.d, #90
; CHECK-NEXT:    fsub z0.d, z24.d, z27.d
; CHECK-NEXT:    fsub z1.d, z25.d, z26.d
; CHECK-NEXT:    ret
entry:
  %strided.vec = tail call { <vscale x 2 x double>, <vscale x 2 x double> } @llvm.vector.deinterleave2.nxv4f64(<vscale x 4 x double> %a)
  %0 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec, 0
  %1 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec, 1
  %strided.vec52 = tail call { <vscale x 2 x double>, <vscale x 2 x double> } @llvm.vector.deinterleave2.nxv4f64(<vscale x 4 x double> %b)
  %2 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec52, 0
  %3 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec52, 1
  %4 = fmul contract <vscale x 2 x double> %0, %3
  %5 = fmul contract <vscale x 2 x double> %1, %2
  %6 = fadd contract <vscale x 2 x double> %5, %4
  %7 = fmul contract <vscale x 2 x double> %0, %2
  %8 = fmul contract <vscale x 2 x double> %1, %3
  %9 = fsub contract <vscale x 2 x double> %7, %8
  %strided.vec54 = tail call { <vscale x 2 x double>, <vscale x 2 x double> } @llvm.vector.deinterleave2.nxv4f64(<vscale x 4 x double> %c)
  %10 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec54, 0
  %11 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec54, 1
  %strided.vec56 = tail call { <vscale x 2 x double>, <vscale x 2 x double> } @llvm.vector.deinterleave2.nxv4f64(<vscale x 4 x double> %d)
  %12 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec56, 0
  %13 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec56, 1
  %14 = fmul contract <vscale x 2 x double> %10, %13
  %15 = fmul contract <vscale x 2 x double> %11, %12
  %16 = fadd contract <vscale x 2 x double> %15, %14
  %17 = fmul contract <vscale x 2 x double> %10, %12
  %18 = fmul contract <vscale x 2 x double> %11, %13
  %19 = fsub contract <vscale x 2 x double> %17, %18
  %20 = fsub contract <vscale x 2 x double> %9, %19
  %21 = fsub contract <vscale x 2 x double> %6, %16
  %interleaved.vec = tail call <vscale x 4 x double> @llvm.vector.interleave2.nxv4f64(<vscale x 2 x double> %20, <vscale x 2 x double> %21)
  ret <vscale x 4 x double> %interleaved.vec
}

; a * b + conj(c) * d
define <vscale x 4 x double> @mul_conj_mull(<vscale x 4 x double> %a, <vscale x 4 x double> %b, <vscale x 4 x double> %c, <vscale x 4 x double> %d) {
; CHECK-LABEL: mul_conj_mull:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    movi v24.2d, #0000000000000000
; CHECK-NEXT:    movi v25.2d, #0000000000000000
; CHECK-NEXT:    movi v26.2d, #0000000000000000
; CHECK-NEXT:    movi v27.2d, #0000000000000000
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    fcmla z24.d, p0/m, z2.d, z0.d, #0
; CHECK-NEXT:    fcmla z25.d, p0/m, z3.d, z1.d, #0
; CHECK-NEXT:    fcmla z27.d, p0/m, z4.d, z6.d, #0
; CHECK-NEXT:    fcmla z26.d, p0/m, z5.d, z7.d, #0
; CHECK-NEXT:    fcmla z24.d, p0/m, z2.d, z0.d, #90
; CHECK-NEXT:    fcmla z25.d, p0/m, z3.d, z1.d, #90
; CHECK-NEXT:    fcmla z27.d, p0/m, z4.d, z6.d, #270
; CHECK-NEXT:    fcmla z26.d, p0/m, z5.d, z7.d, #270
; CHECK-NEXT:    fadd z0.d, z24.d, z27.d
; CHECK-NEXT:    fadd z1.d, z25.d, z26.d
; CHECK-NEXT:    ret
entry:
  %strided.vec = tail call { <vscale x 2 x double>, <vscale x 2 x double> } @llvm.vector.deinterleave2.nxv4f64(<vscale x 4 x double> %a)
  %0 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec, 0
  %1 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec, 1
  %strided.vec60 = tail call { <vscale x 2 x double>, <vscale x 2 x double> } @llvm.vector.deinterleave2.nxv4f64(<vscale x 4 x double> %b)
  %2 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec60, 0
  %3 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec60, 1
  %4 = fmul contract <vscale x 2 x double> %0, %3
  %5 = fmul contract <vscale x 2 x double> %1, %2
  %6 = fadd contract <vscale x 2 x double> %5, %4
  %7 = fmul contract <vscale x 2 x double> %0, %2
  %8 = fmul contract <vscale x 2 x double> %1, %3
  %9 = fsub contract <vscale x 2 x double> %7, %8
  %strided.vec62 = tail call { <vscale x 2 x double>, <vscale x 2 x double> } @llvm.vector.deinterleave2.nxv4f64(<vscale x 4 x double> %c)
  %10 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec62, 0
  %11 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec62, 1
  %strided.vec64 = tail call { <vscale x 2 x double>, <vscale x 2 x double> } @llvm.vector.deinterleave2.nxv4f64(<vscale x 4 x double> %d)
  %12 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec64, 0
  %13 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec64, 1
  %14 = fmul contract <vscale x 2 x double> %10, %13
  %15 = fmul contract <vscale x 2 x double> %11, %12
  %16 = fsub contract <vscale x 2 x double> %14, %15
  %17 = fmul contract <vscale x 2 x double> %10, %12
  %18 = fmul contract <vscale x 2 x double> %11, %13
  %19 = fadd contract <vscale x 2 x double> %17, %18
  %20 = fadd contract <vscale x 2 x double> %9, %19
  %21 = fadd contract <vscale x 2 x double> %6, %16
  %interleaved.vec = tail call <vscale x 4 x double> @llvm.vector.interleave2.nxv4f64(<vscale x 2 x double> %20, <vscale x 2 x double> %21)
  ret <vscale x 4 x double> %interleaved.vec
}

; a + b + 1i * c * d
define <vscale x 4 x double> @mul_add_rot_mull(<vscale x 4 x double> %a, <vscale x 4 x double> %b, <vscale x 4 x double> %c, <vscale x 4 x double> %d) {
; CHECK-LABEL: mul_add_rot_mull:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    uzp2 z24.d, z4.d, z5.d
; CHECK-NEXT:    movi v25.2d, #0000000000000000
; CHECK-NEXT:    uzp1 z4.d, z4.d, z5.d
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    mov z26.d, z24.d
; CHECK-NEXT:    and z25.d, z25.d, #0x7fffffffffffffff
; CHECK-NEXT:    and z26.d, z26.d, #0x8000000000000000
; CHECK-NEXT:    orr z5.d, z25.d, z26.d
; CHECK-NEXT:    fadd z5.d, z4.d, z5.d
; CHECK-NEXT:    and z4.d, z4.d, #0x8000000000000000
; CHECK-NEXT:    orr z4.d, z25.d, z4.d
; CHECK-NEXT:    uzp2 z25.d, z0.d, z1.d
; CHECK-NEXT:    uzp1 z0.d, z0.d, z1.d
; CHECK-NEXT:    uzp2 z1.d, z2.d, z3.d
; CHECK-NEXT:    uzp1 z2.d, z2.d, z3.d
; CHECK-NEXT:    fsub z4.d, z4.d, z24.d
; CHECK-NEXT:    uzp2 z24.d, z6.d, z7.d
; CHECK-NEXT:    uzp1 z6.d, z6.d, z7.d
; CHECK-NEXT:    fmul z26.d, z0.d, z1.d
; CHECK-NEXT:    fmul z1.d, z25.d, z1.d
; CHECK-NEXT:    fmul z3.d, z4.d, z24.d
; CHECK-NEXT:    fmul z24.d, z5.d, z24.d
; CHECK-NEXT:    movprfx z7, z26
; CHECK-NEXT:    fmla z7.d, p0/m, z25.d, z2.d
; CHECK-NEXT:    fnmsb z0.d, p0/m, z2.d, z1.d
; CHECK-NEXT:    movprfx z1, z3
; CHECK-NEXT:    fmla z1.d, p0/m, z6.d, z5.d
; CHECK-NEXT:    movprfx z2, z24
; CHECK-NEXT:    fnmls z2.d, p0/m, z4.d, z6.d
; CHECK-NEXT:    fadd z2.d, z0.d, z2.d
; CHECK-NEXT:    fadd z1.d, z7.d, z1.d
; CHECK-NEXT:    zip1 z0.d, z2.d, z1.d
; CHECK-NEXT:    zip2 z1.d, z2.d, z1.d
; CHECK-NEXT:    ret
entry:
  %strided.vec = tail call { <vscale x 2 x double>, <vscale x 2 x double> } @llvm.vector.deinterleave2.nxv4f64(<vscale x 4 x double> %a)
  %0 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec, 0
  %1 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec, 1
  %strided.vec78 = tail call { <vscale x 2 x double>, <vscale x 2 x double> } @llvm.vector.deinterleave2.nxv4f64(<vscale x 4 x double> %b)
  %2 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec78, 0
  %3 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec78, 1
  %4 = fmul contract <vscale x 2 x double> %0, %3
  %5 = fmul contract <vscale x 2 x double> %1, %2
  %6 = fadd contract <vscale x 2 x double> %5, %4
  %7 = fmul contract <vscale x 2 x double> %0, %2
  %8 = fmul contract <vscale x 2 x double> %1, %3
  %9 = fsub contract <vscale x 2 x double> %7, %8
  %strided.vec80 = tail call { <vscale x 2 x double>, <vscale x 2 x double> } @llvm.vector.deinterleave2.nxv4f64(<vscale x 4 x double> %c)
  %10 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec80, 0
  %11 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec80, 1
  %12 = tail call contract <vscale x 2 x double> @llvm.copysign.nxv2f64(<vscale x 2 x double> zeroinitializer, <vscale x 2 x double> %11)
  %13 = fadd contract <vscale x 2 x double> %10, %12
  %14 = tail call contract <vscale x 2 x double> @llvm.copysign.nxv2f64(<vscale x 2 x double> zeroinitializer, <vscale x 2 x double> %10)
  %15 = fsub contract <vscale x 2 x double> %14, %11
  %strided.vec82 = tail call { <vscale x 2 x double>, <vscale x 2 x double> } @llvm.vector.deinterleave2.nxv4f64(<vscale x 4 x double> %d)
  %16 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec82, 0
  %17 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec82, 1
  %18 = fmul contract <vscale x 2 x double> %15, %17
  %19 = fmul contract <vscale x 2 x double> %16, %13
  %20 = fadd contract <vscale x 2 x double> %19, %18
  %21 = fmul contract <vscale x 2 x double> %15, %16
  %22 = fmul contract <vscale x 2 x double> %13, %17
  %23 = fsub contract <vscale x 2 x double> %21, %22
  %24 = fadd contract <vscale x 2 x double> %9, %23
  %25 = fadd contract <vscale x 2 x double> %6, %20
  %interleaved.vec = tail call <vscale x 4 x double> @llvm.vector.interleave2.nxv4f64(<vscale x 2 x double> %24, <vscale x 2 x double> %25)
  ret <vscale x 4 x double> %interleaved.vec
}

declare { <vscale x 2 x double>, <vscale x 2 x double> } @llvm.vector.deinterleave2.nxv4f64(<vscale x 4 x double>)
declare <vscale x 4 x double> @llvm.vector.interleave2.nxv4f64(<vscale x 2 x double>, <vscale x 2 x double>)
declare <vscale x 2 x double> @llvm.copysign.nxv2f64(<vscale x 2 x double>, <vscale x 2 x double>)
