//
//  File.swift
//  KasaMacro
//
//  Created by reji on 5/14/25.
//



/// "loading" , "refresh", "error" 를 파라미터로 받아 해당하는 `Mutation` 과 `State`를 추가합니다.
@attached(memberAttribute)
public macro CompositionSupport(_ support: [String]) = #externalMacro(module: "Implementations", type: "CompositionSupportMacro")

/// `@RefreshState` + `@RefreshMutation`을 추가합니다.
@attached(memberAttribute)
public macro RefreshSupport() = #externalMacro(module: "Implementations", type: "RefreshSupportMacro")

/// `@ErrorState` + `@ErrorMutation`을 추가합니다.
@attached(memberAttribute)
public macro ErrorSupport() = #externalMacro(module: "Implementations", type: "ErrorSupportMacro")

/// `@LoadingState` + `@LoadingMutation`을 추가합니다.
@attached(memberAttribute)
public macro LoadingSupport() = #externalMacro(module: "Implementations", type: "LoadingSupportMacro")

