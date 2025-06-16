//
//  File.swift
//  KasaMacro
//
//  Created by reji on 5/14/25.
//

import Foundation
import KasaMacroShared


@attached(memberAttribute)
public macro CompositionAction(_ actions: [ActionOptionSet] = []) = #externalMacro(module: "Implementations", type: "CompositionActionMacro")

/// Action에 `case refresh` 를 자동으로 추가합니다.
@attached(member, names: named(refresh))
public macro RefreshAction() = #externalMacro(module: "Implementations", type: "RefreshActionMacro")
/// Action에 `case initialize` 를 자동으로 추가합니다.
@attached(member, names: named(initialize))
public macro InitializeAction() = #externalMacro(module: "Implementations", type: "InitializeActionMacro")

/// 매크로로 선언된 상태값들을 처리하기 위함.
public enum MacroAction {
    case refresh
    case initialize
}
