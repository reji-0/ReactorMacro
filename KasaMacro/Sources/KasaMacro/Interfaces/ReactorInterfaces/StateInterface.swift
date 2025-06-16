//
//  File.swift
//  KasaMacro
//
//  Created by reji on 5/14/25.
//

import KasaMacroShared

/// 파라미터로 받아 여러개의 `State`값을 자동으로 추가합니다.
@attached(memberAttribute)
public macro CompositionState(_ states: StateOptionSet = []) = #externalMacro(module: "Implementations", type: "CompositionStateMacro")

/// State에 `@Pulse var error: Error?` 를 자동으로 추가합니다.
@attached(member, names: named(error))
public macro ErrorState() = #externalMacro(module: "Implementations", type: "ErrorStateMacro")

/// State에 `var isRefreshing: Bool = false` 를 자동으로 추가합니다.
@attached(member, names: named(isRefreshing))
public macro RefreshState() = #externalMacro(module: "Implementations", type: "RefreshStateMacro")

/// State에 `var isLoading: Bool = false` 를 자동으로 추가합니다.
@attached(member, names: named(isLoading))
public macro LoadingState() = #externalMacro(module: "Implementations", type: "LoadingStateMacro")







