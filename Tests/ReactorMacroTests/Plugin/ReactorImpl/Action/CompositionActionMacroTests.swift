//
//  File.swift
//  ReactorMacro
//
//  Created by reji on 6/16/25.
//

import XCTest
import SwiftSyntax
import SwiftParser
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import ReactorMacroPlugin

final class CompositionActionMacroTests: XCTestCase {
    
    let testMacros: [String: Macro.Type] = [
        CompositionActionMacro.macroName: CompositionActionMacro.self,
    ]
    
    func test_refresh_파라미터가_있을때_RefreshAction_속성_추가() {
        assertMacroExpansion(
            """
            @CompositionAction([.refresh])
            class TestReactor: Reactor {
                enum Action {
                    case test
                }
            }
            """,
            expandedSource: """
            class TestReactor: Reactor {
                @RefreshAction
                enum Action {
                    case test
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func test_initialize_파라미터가_있을때_InitializeAction_속성_추가() {
        assertMacroExpansion(
            """
            @CompositionAction([.initialize])
            class TestReactor: Reactor {
                enum Action {
                    case test
                }
            }
            """,
            expandedSource: """
            class TestReactor: Reactor {
                @InitializeAction
                enum Action {
                    case test
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func test_refresh_initialize_모두_있을때_두_속성_모두_추가() {
        assertMacroExpansion(
            """
            @CompositionAction([.refresh, .initialize])
            class TestReactor: Reactor {
                enum Action {
                    case test
                }
            }
            """,
            expandedSource: """
            class TestReactor: Reactor {
                @RefreshAction @InitializeAction
                enum Action {
                    case test
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func test_파라미터가_없을때_속성_추가_안함() {
        assertMacroExpansion(
            """
            @CompositionAction([])
            class TestReactor: Reactor {
                enum Action {
                    case test
                }
            }
            """,
            expandedSource: """
            class TestReactor: Reactor {
                enum Action {
                    case test
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func test_Action이_아닌_enum에는_속성_추가_안함() {
        assertMacroExpansion(
            """
            @CompositionAction([.refresh])
            class TestReactor: Reactor {
                enum State {
                    case idle
                }
                enum Action {
                    case test
                }
            }
            """,
            expandedSource: """
            class TestReactor: Reactor {
                enum State {
                    case idle
                }
                @RefreshAction
                enum Action {
                    case test
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func test_Reactor가_아닌_클래스에_적용시_에러() {
        assertMacroExpansion(
            """
            @CompositionAction([.refresh])
            class TestClass: NSObject {
                enum Action {
                    case test
                }
            }
            """,
            expandedSource: """
            class TestClass: NSObject {
                enum Action {
                    case test
                }
            }
            """,
            diagnostics: [
                DiagnosticSpec(
                    message: MacroError.notInheritingReactor(macro: "CompositionAction").message,
                    line: 1,
                    column: 1
                )
            ],
            macros: testMacros
        )
    }
    
    func test_struct에_적용시_처리() {
        assertMacroExpansion(
            """
            @CompositionAction([.refresh])
            struct TestReactor: Reactor {
                enum Action {
                    case test
                }
            }
            """,
            expandedSource: """
            struct TestReactor: Reactor {
                enum Action {
                    case test
                }
            }
            """,
            diagnostics: [
                DiagnosticSpec(
                    message: MacroError.notClass(macro: "CompositionAction").message,
                    line: 1,
                    column: 1
                )
            ],
            macros: testMacros
        )
    }
}
