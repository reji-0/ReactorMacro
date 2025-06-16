//
//  File.swift
//  KasaMacro
//
//  Created by reji on 5/14/25.
//

import KasaMacroShared

///파라미터로 받아 해당하는 `Mutation` 과 `State`를 자동으로 추가합니다.
@attached(memberAttribute)
public macro CompositionSupport(_ support: [StateOptionSet]) = #externalMacro(module: "Implementations", type: "CompositionSupportMacro")

/// `@RefreshState` + `@RefreshMutation`을 자동으로 추가합니다.
@attached(memberAttribute)
public macro RefreshSupport() = #externalMacro(module: "Implementations", type: "RefreshSupportMacro")

/// `@ErrorState` + `@ErrorMutation`을 자동으로 추가합니다.
@attached(memberAttribute)
public macro ErrorSupport() = #externalMacro(module: "Implementations", type: "ErrorSupportMacro")

/// `@LoadingState` + `@LoadingMutation`을 자동으로 추가합니다.
@attached(memberAttribute)
public macro LoadingSupport() = #externalMacro(module: "Implementations", type: "LoadingSupportMacro")

