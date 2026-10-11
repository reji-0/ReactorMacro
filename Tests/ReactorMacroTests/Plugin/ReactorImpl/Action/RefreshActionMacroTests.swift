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

final class RefreshActionMacroTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        RefreshActionMacro.macroName : RefreshActionMacro.self
    ]
    
    func test_expands_correctly() {
        assertMacroExpansion(
            """
            @RefreshAction
            enum Action {}
            """,
            expandedSource: """
            enum Action {

                case refresh
            }
            """,
            macros: testMacros
        )
    }
    
    func test_fails_when_is_invalid_state() {
        assertMacroExpansion(
            """
            @RefreshAction
            enum InvalideMutation {}
            """,
            expandedSource: """
            enum InvalideMutation {}
            """,
            diagnostics: [
                DiagnosticSpec(
                    message: MacroError.invalidNameForAction(macro: RefreshActionMacro.macroName).message,
                    line: 1,
                    column: 1
                )
            ],
            macros: testMacros
        )
    }
}
