//
//  File.swift
//  ReactorMacro
//
//  Created by reji on 5/14/25.
//

import ReactorMacroShared

/// 파라미터를 받아 여러개의 `Mutation` case를 자동으로 추가합니다.
@attached(memberAttribute)
public macro CompositionMutation(_ mutations: StateOptionSet = []) = #externalMacro(module: "ReactorMacroPlugin", type: "CompositionMutationMacro")

/// Mutation에 `setIsLoading(Bool)` case를 자동으로 추가합니다.
@attached(member, names: named(setIsLoading))
public macro LoadingMutation() = #externalMacro(module: "ReactorMacroPlugin", type: "LoadingMutationMacro")

/// Mutation에 `setError(error)` case를 자동으로 추가합니다.
@attached(member, names: named(setError))
public macro ErrorMutation() = #externalMacro(module: "ReactorMacroPlugin", type: "ErrorMutationMacro")

/// Mutation에 `setIsRefreshing(isRefreshing)` case를 자동으로 추가합니다.
@attached(member, names: named(setIsRefreshing))
public macro RefreshMutation() = #externalMacro(module: "ReactorMacroPlugin", type: "RefreshMutationMacro")
