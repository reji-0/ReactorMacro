//
//  File.swift
//  KasaMacro
//
//  Created by reji on 5/14/25.
//

import Foundation
import KasaMacroShared


/// 파라미터를 받아 여러개의 `Action` case를 작성해줍니다.
@attached(memberAttribute)
public macro CompositionAction(_ actions: [ActionOptionSet] = []) = #externalMacro(module: "Implementations", type: "CompositionActionMacro")

/// Action에 `case refresh` 를 자동으로 추가합니다.
@attached(member, names: named(refresh))
public macro RefreshAction() = #externalMacro(module: "Implementations", type: "RefreshActionMacro")

/// Action에 `case initialize` 를 자동으로 추가합니다.
@attached(member, names: named(initialize))
public macro InitializeAction() = #externalMacro(module: "Implementations", type: "InitializeActionMacro")
