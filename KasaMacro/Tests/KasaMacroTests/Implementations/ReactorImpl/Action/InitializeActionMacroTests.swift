//
//  File.swift
//  KasaMacro
//
//  Created by reji on 5/28/25.
//

import XCTest
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import Implementations
@testable import KasaMacro

final class InitializeActionMacroTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        InitializeActionMacro.macroName : InitializeActionMacro.self
    ]
    
    func test_expands_correctly() {
        assertMacroExpansion(
            """
            @InitializeAction
            enum Action {}
            """,
            expandedSource: """
            enum Action {

                case initialize
            }
            """,
            macros: testMacros
        )
    }
    
    func test_fails_when_is_invalid_state() {
        assertMacroExpansion(
            """
            @InitializeAction
            enum InvalideMutation {}
            """,
            expandedSource: """
            enum InvalideMutation {}
            """,
            diagnostics: [
                DiagnosticSpec(
                    message: MacroError.invalidNameForAction(macro: InitializeActionMacro.macroName).message,
                    line: 1,
                    column: 1
                )
            ],
            macros: testMacros
        )
    }
}
