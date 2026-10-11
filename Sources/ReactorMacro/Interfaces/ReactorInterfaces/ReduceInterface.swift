//
//  File.swift
//  ReactorMacro
//
//  Created by reji on 5/15/25.
//
import Foundation
import ReactorMacroShared

/// Reduce함수 생성: 코드로 작성된 State들을 읽어 자동 생성합니다. (주의: 매크로로 생성된 State값은 파라미터로 넘겨주어야한다.)
@attached(member, names: named(reduce))
public macro GenerateReduce(_ states: StateOptionSet = []) = #externalMacro(module: "ReactorMacroPlugin", type: "GenerateReduceMacro")

