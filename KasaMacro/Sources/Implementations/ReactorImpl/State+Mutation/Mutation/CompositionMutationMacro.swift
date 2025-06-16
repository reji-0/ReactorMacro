//
//  CompositionMutationMacro.swift
//  KasaMacro
//
//  Created by reji on 6/16/25.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation
import SwiftDiagnostics

public struct CompositionMutationMacro: @preconcurrency MemberAttributeMacro {
    @MainActor public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        attachedTo declaration: some SwiftSyntax.DeclGroupSyntax,
        providingAttributesFor member: some SwiftSyntax.DeclSyntaxProtocol,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.AttributeSyntax] {
        guard let _ = declaration.validateReactorClass(macroName: self.macroName, node: node, context: context) else {
            return []
        }
        
        let params = extractStateOptionSet(node)
        var attributes = [AttributeSyntax]()
        
        if let enumDecl = member.as(EnumDeclSyntax.self),
           enumDecl.name.text == "Mutation" {
            
            if params.contains(.loading) {
                attributes.append(AttributeSyntax(attributeName: IdentifierTypeSyntax(name: .identifier("LoadingMutation"))))
            }
            
            if params.contains(.refresh) {
                attributes.append(AttributeSyntax(attributeName: IdentifierTypeSyntax(name: .identifier("RefreshMutation"))))
            }
            
            if params.contains(.error) {
                attributes.append(AttributeSyntax(attributeName: IdentifierTypeSyntax(name: .identifier("ErrorMutation"))))
            }
            
            return attributes
        }
        
        return []
    }
}
