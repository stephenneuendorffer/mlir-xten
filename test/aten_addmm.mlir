//===- aten_addmm.mlir -----------------------------------------*- MLIR -*-===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// (c) Copyright 2019 Xilinx Inc.
//
//===----------------------------------------------------------------------===//

// RUN: aten-opt %s -aten-op-report | FileCheck %s
//   CHECK-LABEL:     "unknown-layer-2": {
//   CHECK-NEXT:        "activation_in": 1024,
//   CHECK-NEXT:        "activation_out": 16,
//   CHECK-NEXT:        "ops:+": 16,
//   CHECK-NEXT:        "ops:MAC": 16384,
//   CHECK-NEXT:        "parameters_in": 16400,
//   CHECK-NEXT:        "reads": 17424,
//   CHECK-NEXT:        "writes": 16
//
// RUN: aten-opt %s -aten-lowering -cse | FileCheck %s --check-prefix=ATEN
// NOTE: Assertions have been autogenerated by utils/generate-test-checks.py
// ATEN:       module {

// ATEN-LABEL:   func @graph(
// ATEN-SAME:                %[[VAL_0:.*]]: memref<1x1024xf32>, %[[VAL_1:.*]]: memref<16x1024xf32>, %[[VAL_2:.*]]: memref<16xf32>) -> memref<1x16xf32> {
// ATEN:           %[[VAL_3:.*]] = call @t_AtenAcapOp_M1024x16xF32_M16x1024xF32(%[[VAL_1]]) : (memref<16x1024xf32>) -> memref<1024x16xf32>
// ATEN:           %[[VAL_4:.*]] = constant 1 : i32
// ATEN:           %[[VAL_5:.*]] = call @addmm_AtenAcapOp_M1x16xF32_M16xF32_M1x1024xF32_M1024x16xF32_I32_I32(%[[VAL_2]], %[[VAL_0]], %[[VAL_3]], %[[VAL_4]], %[[VAL_4]]) : (memref<16xf32>, memref<1x1024xf32>, memref<1024x16xf32>, i32, i32) -> memref<1x16xf32>
// ATEN:           return %[[VAL_5]] : memref<1x16xf32>
// ATEN:         }

// ATEN-LABEL:   func private @t_AtenAcapOp_M1024x16xF32_M16x1024xF32(memref<16x1024xf32>) -> memref<1024x16xf32>

// ATEN-LABEL:   func private @addmm_AtenAcapOp_M1x16xF32_M16xF32_M1x1024xF32_M1024x16xF32_I32_I32(memref<16xf32>, memref<1x1024xf32>, memref<1024x16xf32>, i32, i32) -> memref<1x16xf32>
// ATEN:       }

module {
  func @graph(%arg0: tensor<1x1024xf32>, %arg1: tensor<16x1024xf32>, %arg2: tensor<16xf32>) -> tensor<1x16xf32> {
    %0 = "aten.t"(%arg1) : (tensor<16x1024xf32>) -> tensor<1024x16xf32>
    %1 = constant 1 : i64
    %3 = "aten.addmm"(%arg2, %arg0, %0, %1, %1) : (tensor<16xf32>, tensor<1x1024xf32>, tensor<1024x16xf32>, i64, i64) -> tensor<1x16xf32>
    "std.return"(%3) : (tensor<1x16xf32>) -> ()
  }
}
