//
//  ReduceMacro.swift
//  ReactorMacro
//
//  Created by reji on 5/14/25.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation
import SwiftDiagnostics

import ReactorMacroShared

/*
 ReactorKit의 reduce 함수를 자동 생성하는 매크로
 
 @Reduce([.loading, .error...]) 형태로 사용하여 상태 변경 케이스들을 자동으로 생성합니다.
*/

public struct GenerateReduceMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        
        /// Reactor 클래스 유효성 검증
        guard let _ = declaration.validateReactorClass(
            macroName: self.macroName,
            node: node,
            context: context
        ) else {
            return []
        }

        let stateOptionSet = extractStateOptionSet(node)

        guard let stateDecl = declaration.memberBlock.members
            .compactMap({ $0.decl.as(StructDeclSyntax.self) })
            .first(where: { $0.name.text == "State" })
        else {
            return []
        }

        let stateProperties = extractProperties(from: stateDecl)
        
        let reduceFunc = generateReduceFunction(
            stateProperties: stateProperties,
            stateOptionSet: stateOptionSet
        )

        return [reduceFunc]
    }
    
    /// State 구조체에서 프로퍼티들을 추출하는 함수 (개발자가 작성해 놓은 코드를 읽어 reduce 함수로 만들기 위함)
    /// - Parameter stateDecl: State 구조체 선언
    /// - Returns: (프로퍼티명, 타입) 튜플 배열
    private static func extractProperties(from stateDecl: StructDeclSyntax) -> [(name: String, type: String)] {
        stateDecl.memberBlock.members.compactMap { member in
            guard let varDecl = member.decl.as(VariableDeclSyntax.self),
                  let binding = varDecl.bindings.first,
                  let identifier = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text,
                  let typeAnnotation = binding.typeAnnotation?.type else {
                return nil
            }
            return (name: identifier, type: typeAnnotation.description)
        }
    }
    
    /// reduce 함수를 작성하는 함수
    /// - Parameters:
    ///   - stateProperties: 코드로 작성된 State의 프로퍼티들
    ///   - stateOptionSet: 매크로 파라미터로 전달된 State 옵션들
    /// - Returns: 완성된 reduce 함수 구문
    private static func generateReduceFunction(
        stateProperties: [(name: String, type: String)],
        stateOptionSet: StateOptionSet
    ) -> DeclSyntax {
        let propCases = stateProperties.map { prop in
            let mutation = "set" + prop.name.prefix(1).uppercased() + prop.name.dropFirst()
            return """
            case let .\(mutation)(\(prop.name)):
                        newState.\(prop.name) = \(prop.name)
            """
        }
        var stateOptions = [String]()
        
        if stateOptionSet.contains(.loading) {
            stateOptions.append(
            """
            case let .setIsLoading(isLoading):
                        newState.isLoading = isLoading
            """
            )
        }
        
        if stateOptionSet.contains(.error) {
            stateOptions.append(
            """
            case let .setError(error):
                        newState.error = error
            """
            )
        }
        
        if stateOptionSet.contains(.refresh) {
            stateOptions.append(
            """
            case let .setIsRefreshing(isRefreshing):
                        newState.isRefreshing = isRefreshing
            """
            )
        }

        let switchBody = (propCases + stateOptions).joined(
            separator: "\n\n" + tabIndent + tabIndent
        )

        return """
        func reduce(state: State, mutation: Mutation) -> State {
            var newState = state

            switch mutation {
                \(raw: switchBody)
            }

            return newState
        }
        """ as DeclSyntax
    }
}
