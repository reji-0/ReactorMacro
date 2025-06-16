//
//  CompositionStateMacroTests.swift
//  KasaMacro
//
//  Created by reji on 6/16/25.
//

import XCTest
import SwiftSyntax
import SwiftParser
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import Implementations

final class CompositionStateMacroTests: XCTestCase {
    
    let testMacros: [String: Macro.Type] = [
        "CompositionState": CompositionStateMacro.self,
    ]
    
    // MARK: - 성공 케이스
    
    func test_loading_파라미터가_있을때_LoadingState_속성_추가() {
        assertMacroExpansion(
            """
            @CompositionState(["loading"])
            class TestReactor: Reactor {
                struct State {
                    var data: String = ""
                }
            }
            """,
            expandedSource: """
            class TestReactor: Reactor {
                @LoadingState
                struct State {
                    var data: String = ""
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func test_refresh_파라미터가_있을때_RefreshState_속성_추가() {
        assertMacroExpansion(
            """
            @CompositionState(["refresh"])
            class TestReactor: Reactor {
                struct State {
                    var data: String = ""
                }
            }
            """,
            expandedSource: """
            class TestReactor: Reactor {
                @RefreshState
                struct State {
                    var data: String = ""
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func test_error_파라미터가_있을때_ErrorState_속성_추가() {
        assertMacroExpansion(
            """
            @CompositionState(["error"])
            class TestReactor: Reactor {
                struct State {
                    var data: String = ""
                }
            }
            """,
            expandedSource: """
            class TestReactor: Reactor {
                @ErrorState
                struct State {
                    var data: String = ""
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func test_모든_파라미터가_있을때_모든_속성_추가() {
        assertMacroExpansion(
            """
            @CompositionState(["loading", "refresh", "error"])
            class TestReactor: Reactor {
                struct State {
                    var data: String = ""
                }
            }
            """,
            expandedSource: """
            class TestReactor: Reactor {
                @LoadingState @RefreshState @ErrorState
                struct State {
                    var data: String = ""
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func test_파라미터가_없을때_속성_추가_안함() {
        assertMacroExpansion(
            """
            @CompositionState([])
            class TestReactor: Reactor {
                struct State {
                    var data: String = ""
                }
            }
            """,
            expandedSource: """
            class TestReactor: Reactor {
                struct State {
                    var data: String = ""
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func test_State가_아닌_struct에는_속성_추가_안함() {
        assertMacroExpansion(
            """
            @CompositionState(["loading"])
            class TestReactor: Reactor {
                struct CustomStruct {
                    var data: String = ""
                }
                struct State {
                    var data: String = ""
                }
            }
            """,
            expandedSource: """
            class TestReactor: Reactor {
                struct CustomStruct {
                    var data: String = ""
                }
                @LoadingState
                struct State {
                    var data: String = ""
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func test_지원하지_않는_파라미터는_무시() {
        assertMacroExpansion(
            """
            @CompositionState(["loading", "unknown", "refresh"])
            class TestReactor: Reactor {
                struct State {
                    var data: String = ""
                }
            }
            """,
            expandedSource: """
            class TestReactor: Reactor {
                @LoadingState @RefreshState
                struct State {
                    var data: String = ""
                }
            }
            """,
            macros: testMacros
        )
    }
    
    // MARK: - 실패 케이스
    
    func test_Reactor가_아닌_클래스에_적용시_에러() {
        assertMacroExpansion(
            """
            @CompositionState(["loading"])
            class TestClass: NSObject {
                struct State {
                    var data: String = ""
                }
            }
            """,
            expandedSource: """
            class TestClass: NSObject {
                struct State {
                    var data: String = ""
                }
            }
            """,
            diagnostics: [
                DiagnosticSpec(message: MacroError.notInheritingReactor(macro: "CompositionState").message, line: 1, column: 1)
            ],
            macros: testMacros
        )
    }
    
    func test_struct에_적용시_처리() {
        assertMacroExpansion(
            """
            @CompositionState(["loading"])
            struct TestReactor: Reactor {
                struct State {
                    var data: String = ""
                }
            }
            """,
            expandedSource: """
            struct TestReactor: Reactor {
                struct State {
                    var data: String = ""
                }
            }
            """,
            diagnostics: [
                DiagnosticSpec(message: MacroError.notClass(macro: "CompositionState").message, line: 1, column: 1)
            ],
            macros: testMacros
        )
    }
}
