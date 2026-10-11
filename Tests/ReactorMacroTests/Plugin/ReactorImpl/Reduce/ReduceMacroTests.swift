//
//  File.swift
//  ReactorMacro
//
//  Created by reji on 6/17/25.
//

import XCTest
import SwiftSyntax
import SwiftParser
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import ReactorMacroPlugin
import ReactorMacroShared

final class ReduceMacroTests: XCTestCase {
    
    private let testMacros: [String: Macro.Type] = [
        GenerateReduceMacro.macroName : GenerateReduceMacro.self
    ]
    
    func test_파라미터2개_상태값_있을때() throws {
        assertMacroExpansion(
            """
            @GenerateReduce([.loading, .error])
            class TestReactor: Reactor {
                struct State {
                    var userName: String
                    var age: Int
                    var isVisible: Bool
                }
            }
            """,
            expandedSource: """
            class TestReactor: Reactor {
                struct State {
                    var userName: String
                    var age: Int
                    var isVisible: Bool
                }

                func reduce(state: State, mutation: Mutation) -> State {
                    var newState = state

                    switch mutation {
                        case let .setUserName(userName):
                            newState.userName = userName

                        case let .setAge(age):
                            newState.age = age

                        case let .setIsVisible(isVisible):
                            newState.isVisible = isVisible

                        case let .setIsLoading(isLoading):
                            newState.isLoading = isLoading

                        case let .setError(error):
                            newState.error = error
                    }

                    return newState
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func test_파라미터3개_상태값_있을때() throws {
        assertMacroExpansion(
            """
            @GenerateReduce([.loading, .error, .refresh])
            class UserReactor: Reactor {
                struct State {
                    var name: String
                }
            }
            """,
            expandedSource: """
            class UserReactor: Reactor {
                struct State {
                    var name: String
                }

                func reduce(state: State, mutation: Mutation) -> State {
                    var newState = state
            
                    switch mutation {
                        case let .setName(name):
                            newState.name = name
            
                        case let .setIsLoading(isLoading):
                            newState.isLoading = isLoading
            
                        case let .setError(error):
                            newState.error = error
            
                        case let .setIsRefreshing(isRefreshing):
                            newState.isRefreshing = isRefreshing
                    }
            
                    return newState
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func test_파라미터없고_상태값_있을때() throws {
        assertMacroExpansion(
            """
            @GenerateReduce([])
            class MinimalReactor: Reactor {
                struct State {
                    var count: Int
                    var message: String
                }
            }
            """,
            expandedSource: """
            class MinimalReactor: Reactor {
                struct State {
                    var count: Int
                    var message: String
                }

                func reduce(state: State, mutation: Mutation) -> State {
                    var newState = state
            
                    switch mutation {
                        case let .setCount(count):
                            newState.count = count
            
                        case let .setMessage(message):
                            newState.message = message
                    }

                    return newState
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func test_상태값의_타입이_복잡할때() throws {
        assertMacroExpansion(
            """
            @GenerateReduce([.loading])
            class ComplexReactor: Reactor {
                struct State {
                    var users: [User]
                    var config: AppConfig?
                    var settings: Dictionary<String, Any>
                }
            }
            """,
            expandedSource: """
            class ComplexReactor: Reactor {
                struct State {
                    var users: [User]
                    var config: AppConfig?
                    var settings: Dictionary<String, Any>
                }

                func reduce(state: State, mutation: Mutation) -> State {
                    var newState = state

                    switch mutation {
                        case let .setUsers(users):
                            newState.users = users
            
                        case let .setConfig(config):
                            newState.config = config
            
                        case let .setSettings(settings):
                            newState.settings = settings
            
                        case let .setIsLoading(isLoading):
                            newState.isLoading = isLoading
                    }

                    return newState
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_state_구조체가_없을때() throws {
        assertMacroExpansion(
            """
            @GenerateReduce([.loading])
            class ReactorWithoutState: Reactor {
                var someProperty: String = ""
            }
            """,
            expandedSource: """
            class ReactorWithoutState: Reactor {
                var someProperty: String = ""
            }
            """,
            macros: testMacros
        )
    }
    
    func test_파라미터_괄호도_없을때() throws {
        assertMacroExpansion(
            """
            @GenerateReduce
            class InvalidReactor: Reactor {
                struct State {
                    var value: Int
                }
            }
            """,
            expandedSource: """
            class InvalidReactor: Reactor {
                struct State {
                    var value: Int
                }

                func reduce(state: State, mutation: Mutation) -> State {
                    var newState = state

                    switch mutation {
                        case let .setValue(value):
                            newState.value = value
                    }

                    return newState
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func test_state_구조체가_비어있을때() throws {
        assertMacroExpansion(
            """
            @GenerateReduce([.error])
            class EmptyStateReactor: Reactor {
                struct State {
                }
            }
            """,
            expandedSource: """
            class EmptyStateReactor: Reactor {
                struct State {
                }

                func reduce(state: State, mutation: Mutation) -> State {
                    var newState = state
            
                    switch mutation {
                        case let .setError(error):
                            newState.error = error
                    }

                    return newState
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func test_ReactorKit_모듈명을_붙여_채택했을때() throws {
        assertMacroExpansion(
            """
            @GenerateReduce
            final class QualifiedReactor: ReactorKit.Reactor {
                struct State {
                    var value: Int
                }
            }
            """,
            expandedSource: """
            final class QualifiedReactor: ReactorKit.Reactor {
                struct State {
                    var value: Int
                }

                func reduce(state: State, mutation: Mutation) -> State {
                    var newState = state

                    switch mutation {
                        case let .setValue(value):
                            newState.value = value
                    }

                    return newState
                }
            }
            """,
            macros: testMacros
        )
    }
}
