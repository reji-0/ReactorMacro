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

final class RefreshMutationMacroTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        RefreshMutationMacro.macroName : RefreshMutationMacro.self
    ]
    
    func test_expands_correctly() {
        assertMacroExpansion(
            """
            @RefreshMutation
            enum Mutation {}
            """,
            expandedSource: """
            enum Mutation {

                case setIsRefreshing(Bool)
            }
            """,
            macros: testMacros
        )
    }
    
    func test_fails_when_is_invalid_state() {
        assertMacroExpansion(
            """
            @RefreshMutation
            enum InvalideMutation {}
            """,
            expandedSource: """
            enum InvalideMutation {}
            """,
            diagnostics: [
                DiagnosticSpec(
                    message: MacroError.invalidNameForMutation(macro: RefreshMutationMacro.macroName).message,
                    line: 1,
                    column: 1
                )
            ],
            macros: testMacros
        )
    }
}
