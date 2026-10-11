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

final class ErrorMutationMacroTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        ErrorMutationMacro.macroName : ErrorMutationMacro.self
    ]
    
    func test_expands_correctly() {
        assertMacroExpansion(
            """
            @ErrorMutation
            enum Mutation {}
            """,
            expandedSource: """
            enum Mutation {

                case setError(Error)
            }
            """,
            macros: testMacros
        )
    }
    
    func test_fails_when_is_invalid_state() {
        assertMacroExpansion(
            """
            @ErrorMutation
            enum InvalideMutation {}
            """,
            expandedSource: """
            enum InvalideMutation {}
            """,
            diagnostics: [
                DiagnosticSpec(
                    message: MacroError.invalidNameForMutation(macro: ErrorMutationMacro.macroName).message,
                    line: 1,
                    column: 1
                )
            ],
            macros: testMacros
        )
    }
}
