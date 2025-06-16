//
//  File.swift
//  KasaMacro
//
//  Created by reji on 5/15/25.
//
import Foundation
import KasaMacroShared
/// Reduce함수 생성: State내의 값들을 자동 생성하고, 매크로로 생성된 State값은 파라미터로 넘겨주어야한다.
@attached(member, names: named(reduce))
public macro GenerateReduce(_ states: [StateOptionSet] = []) = #externalMacro(module: "Implementations", type: "ReduceMacro")

