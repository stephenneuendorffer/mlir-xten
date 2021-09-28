//===- aten_maxpool2d.mlir -------------------------------------*- MLIR -*-===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// (c) Copyright 2019 Xilinx Inc.
//
//===----------------------------------------------------------------------===//

// RUN: aten-opt %s -aten-op-report | FileCheck %s
//   CHECK-LABEL:  "{{.*}}": {
//   CHECK-NEXT:    "activation_in": 8192,
//   CHECK-NEXT:    "activation_out": 2048,
//   CHECK-NEXT:    "ops:>": 16384,
//   CHECK-NEXT:    "reads": 8192,
//   CHECK-NEXT:    "writes": 2048

// RUN: aten-opt %s -aten-lowering | FileCheck %s --check-prefix=ATEN
// NOTE: Assertions have been autogenerated by utils/generate-test-checks.py
// ATEN:       module {

// ATEN-LABEL:   func @graph(
// ATEN-SAME:                %[[VAL_0:.*]]: memref<1x32x16x16xf32>) -> memref<1x32x8x8xf32> {
// ATEN:           %[[VAL_1:.*]] = constant 3 : i32
// ATEN:           %[[VAL_2:.*]] = constant 2 : i32
// ATEN:           %[[VAL_3:.*]] = constant 1 : i32
// ATEN:           %[[VAL_4:.*]] = call @max_pool2d_AtenAcapOp_M1x32x8x8xF32_M1x32x16x16xF32_I32_I32_I32(%[[VAL_0]], %[[VAL_1]], %[[VAL_2]], %[[VAL_3]]) : (memref<1x32x16x16xf32>, i32, i32, i32) -> memref<1x32x8x8xf32>
// ATEN:           return %[[VAL_4]] : memref<1x32x8x8xf32>
// ATEN:         }

// ATEN-LABEL:   func private @max_pool2d_AtenAcapOp_M1x32x8x8xF32_M1x32x16x16xF32_I32_I32_I32(memref<1x32x16x16xf32>, i32, i32, i32) -> memref<1x32x8x8xf32>
// ATEN:       }

module {
  func @graph(%arg0: tensor<1x32x16x16xf32>) -> tensor<1x32x8x8xf32> {
    %0 = "aten.constant"() {type = "List[i32]", value = dense<3> : vector<2xi64>} : () -> !aten.list<i32>
    %1 = "aten.constant"() {type = "List[i32]", value = dense<2> : vector<2xi64>} : () -> !aten.list<i32>
    %2 = "aten.constant"() {type = "List[i32]", value = dense<1> : vector<2xi64>} : () -> !aten.list<i32>
    %3 = "aten.constant"() {type = "List[i32]", value = dense<1> : vector<2xi64>} : () -> !aten.list<i32>
    %4 = "aten.constant"() {type = "bool", value = 0 : i1} : () -> i1
    %5 = "aten.max_pool2d"(%arg0, %0, %1, %2, %3, %4) : (tensor<1x32x16x16xf32>, !aten.list<i32>, !aten.list<i32>, !aten.list<i32>, !aten.list<i32>, i1) -> tensor<1x32x8x8xf32>
    "std.return"(%5) : (tensor<1x32x8x8xf32>) -> ()
  }
}
