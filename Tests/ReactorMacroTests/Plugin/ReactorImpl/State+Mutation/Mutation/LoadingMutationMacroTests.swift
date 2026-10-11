//
//  File.swift
//  ReactorMacro
//
//  Created by reji on 5/28/25.
//

import XCTest
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import ReactorMacroPlugin

final class LoadingMutationMacroTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        LoadingMutationMacro.macroName : LoadingMutationMacro.self
    ]
    
    func test_expands_correctly() {
        assertMacroExpansion(
            """
            @LoadingMutation
            enum Mutation {}
            """,
            expandedSource: """
            enum Mutation {

                case setIsLoading(Bool)
            }
            """,
            macros: testMacros
        )
    }
    
    func test_fails_when_is_invalid_state() {
        assertMacroExpansion(
            """
            @LoadingMutation
            enum InvalideMutation {}
            """,
            expandedSource: """
            enum InvalideMutation {}
            """,
            diagnostics: [
                DiagnosticSpec(
                    message: MacroError.invalidNameForMutation(macro: LoadingMutationMacro.macroName).message,
                    line: 1,
                    column: 1
                )
            ],
            macros: testMacros
        )
    }
}
