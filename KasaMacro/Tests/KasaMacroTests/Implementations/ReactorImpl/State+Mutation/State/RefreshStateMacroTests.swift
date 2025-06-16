//
//  RefreshStateMacroTests.swift
//  KasaMacro
//
//  Created by reji on 5/28/25.
//

import XCTest
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import Implementations
@testable import KasaMacro

final class RefreshStateMacroTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        RefreshStateMacro.macroName : RefreshStateMacro.self
    ]
    
    func test_expandsCorrectly() {
        assertMacroExpansion(
            """
            @RefreshState
            struct State {}
            """,
            expandedSource: """
            struct State {

                var isRefreshing: Bool = false
            }
            """,
            macros: testMacros
        )
    }
    
    func test_fails_when_is_invalid_state() {
        assertMacroExpansion(
            """
            @RefreshState
            struct InvalideState {}
            """,
            expandedSource: """
            struct InvalideState {}
            """,
            diagnostics: [
                DiagnosticSpec(
                    message: MacroError.invalidNameForState(macro: RefreshStateMacro.macroName).message,
                    line: 1,
                    column: 1
                )
            ],
            macros: testMacros
        )
    }
}
