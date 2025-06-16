//
//  ErrorStateMacroTests.swift
//  KasaMacro
//
//  Created by reji on 5/28/25.
//

import XCTest
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import Implementations
@testable import KasaMacro

final class ErrorStateMacroTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        ErrorStateMacro.macroName : ErrorStateMacro.self
    ]
    
    func test_expands_correctly() {
        assertMacroExpansion(
            """
            @ErrorState
            struct State {}
            """,
            expandedSource: """
            struct State {

                @Pulse var error: Error?
            }
            """,
            macros: testMacros
        )
    }
    
    func test_fails_when_is_invalid_state() {
        assertMacroExpansion(
            """
            @ErrorState
            struct MyState {}
            """,
            expandedSource: """
            struct MyState {}
            """,
            diagnostics: [
                DiagnosticSpec(
                    message: MacroError.invalidNameForState(macro: ErrorStateMacro.macroName).message,
                    line: 1,
                    column: 1
                )
            ],
            macros: testMacros
        )
    }
}
