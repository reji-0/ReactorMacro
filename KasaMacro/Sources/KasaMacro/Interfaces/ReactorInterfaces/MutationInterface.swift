//
//  File.swift
//  KasaMacro
//
//  Created by reji on 5/14/25.
//

import KasaMacroShared

@attached(memberAttribute)
public macro CompositionMutation(_ mutations: [StateOptionSet] = []) = #externalMacro(module: "Implementations", type: "CompositionMutationMacro")

/// Mutation에 `setIsLoading(Bool)` case를 자동으로 추가합니다.
@attached(member, names: named(setIsLoading))
public macro LoadingMutation() = #externalMacro(module: "Implementations", type: "LoadingMutationMacro")

/// Mutation에 `setError(error)` case를 자동으로 추가합니다.
@attached(member, names: named(setError))
public macro ErrorMutation() = #externalMacro(module: "Implementations", type: "ErrorMutationMacro")

/// Mutation에 `setIsRefreshing(isRefreshing)` case를 자동으로 추가합니다.
@attached(member, names: named(setIsRefreshing))
public macro RefreshMutation() = #externalMacro(module: "Implementations", type: "RefreshMutationMacro")
