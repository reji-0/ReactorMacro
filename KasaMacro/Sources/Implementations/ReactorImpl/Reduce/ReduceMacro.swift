//
//  ReduceMacro.swift
//  KasaMacro
//
//  Created by reji on 5/14/25.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation
import SwiftDiagnostics

public struct ReduceMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {

        guard let _ = declaration.validateReactorClass(
            macroName: self.macroName,
            node: node,
            context: context
        ) else {
            return []
        }

        var reactorStyles: [String] = []
        if let args = node.arguments?.as(LabeledExprListSyntax.self),
           let firstArg = args.first?.expression,
           let arrayExpr = firstArg.as(ArrayExprSyntax.self) {
            reactorStyles = arrayExpr.elements.compactMap {
                $0.expression.as(MemberAccessExprSyntax.self)?.declName.baseName.text
            }
        }

        guard let stateDecl = declaration.memberBlock.members
            .compactMap({ $0.decl.as(StructDeclSyntax.self) })
            .first(where: { $0.name.text == "State" })
        else {
            return []
        }

        let stateProperties = extractProperties(from: stateDecl)
        let reduceFunc = generateReduceFunction(
            stateProperties: stateProperties,
            reactorStyles: reactorStyles
        )

        return [reduceFunc]
    }

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

    private static func generateReduceFunction(
        stateProperties: [(name: String, type: String)],
        reactorStyles: [String]
    ) -> DeclSyntax {
        let propCases = stateProperties.map { prop in
            let mutation = "set" + prop.name.prefix(1).uppercased() + prop.name.dropFirst()
            return """
                case let .\(mutation)(\(prop.name)):
                    newState.\(prop.name) = \(prop.name)
            """
        }

        let styleCases = reactorStyles.map { style in
            switch style {
            case "loading":
                return """
                    case let .setIsLoading(isLoading):
                        newState.isLoading = isLoading
                """
            case "error":
                return """
                    case let .setError(error):
                        newState.error = error
                """
            case "refresh":
                return """
                    case let .setIsRefreshing(isRefreshing):
                        newState.isRefreshing = isRefreshing
                """
            default:
                return ""
            }
        }

        let switchBody = (propCases + styleCases).joined(separator: "\n\n        ")

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
