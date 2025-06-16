//
//  ErrorMacroTests.swift
//  KasaMacro
//
//  Created by reji on 5/28/25.
//

import XCTest
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import Implementations
@testable import KasaMacro

final class LoadingStateMacroTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        LoadingStateMacro.macroName : LoadingStateMacro.self
    ]
    
    func test_expandsCorrectly() {
        assertMacroExpansion(
            """
            @LoadingState
            struct State {}
            """,
            expandedSource: """
            struct State {

                var isLoading: Bool = false
            }
            """,
            macros: testMacros
        )
    }
    
    func test_fails_when_is_invalid_state() {
        assertMacroExpansion(
            """
            @LoadingState
            struct InvalideState {}
            """,
            expandedSource: """
            struct InvalideState {}
            """,
            diagnostics: [
                DiagnosticSpec(
                    message: MacroError.invalidNameForState(macro: LoadingStateMacro.macroName).message,
                    line: 1,
                    column: 1
                )
            ],
            macros: testMacros
        )
    }
}
