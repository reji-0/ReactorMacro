//
//  CompositionSupportMacro.swift
//  KasaMacro
//
//  Created by reji on 5/28/25.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation
import SwiftDiagnostics

public struct CompositionSupportMacro: MemberAttributeMacro {
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        attachedTo declaration: some SwiftSyntax.DeclGroupSyntax,
        providingAttributesFor member: some SwiftSyntax.DeclSyntaxProtocol,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.AttributeSyntax] {
        guard let _ = declaration.validateReactorClass(macroName: self.macroName, node: node, context: context) else {
            return []
        }
        
        let params = extractParameters(node)
        var attributes = [AttributeSyntax]()
        
        if let structDecl = member.as(StructDeclSyntax.self),
           structDecl.name.text == "State" {
            if params.contains("loading") {
                attributes.append(AttributeSyntax(attributeName: IdentifierTypeSyntax(name: .identifier("LoadingState"))))
            }
            
            if params.contains("refresh") {
                attributes.append(AttributeSyntax(attributeName: IdentifierTypeSyntax(name: .identifier("RefreshState"))))
            }
            
            if params.contains("error") {
                attributes.append(AttributeSyntax(attributeName: IdentifierTypeSyntax(name: .identifier("ErrorState"))))
            }
            
            return attributes
        }
        
        if let enumDecl = member.as(EnumDeclSyntax.self),
           enumDecl.name.text == "Mutation" {
            
            if params.contains("loading") {
                attributes.append(AttributeSyntax(attributeName: IdentifierTypeSyntax(name: .identifier("LoadingMutation"))))
            }
            
            if params.contains("refresh") {
                attributes.append(AttributeSyntax(attributeName: IdentifierTypeSyntax(name: .identifier("RefreshMutation"))))
            }
            
            if params.contains("error") {
                attributes.append(AttributeSyntax(attributeName: IdentifierTypeSyntax(name: .identifier("ErrorMutation"))))
            }
            
            return attributes
        }
        
        return []
    }
}
