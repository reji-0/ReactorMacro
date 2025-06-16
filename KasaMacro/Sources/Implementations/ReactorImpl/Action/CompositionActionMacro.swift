//
//  CompositionActionMacro.swift
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

public struct CompositionActionMacro: @preconcurrency MemberAttributeMacro {
    @MainActor public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        attachedTo declaration: some SwiftSyntax.DeclGroupSyntax,
        providingAttributesFor member: some SwiftSyntax.DeclSyntaxProtocol,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.AttributeSyntax] {
        guard let _ = declaration.validateReactorClass(macroName: self.macroName, node: node, context: context) else {
            return []
        }
        
        let params = extractActionSet(node)
        var attributes = [AttributeSyntax]()
        
        if let enumDecl = member.as(EnumDeclSyntax.self),
           enumDecl.name.text == "Action" {
            
            if params.contains(.refresh) {
                attributes.append(AttributeSyntax(attributeName: IdentifierTypeSyntax(name: .identifier("RefreshAction"))))
            }
            
            if params.contains(.initialize) {
                attributes.append(AttributeSyntax(attributeName: IdentifierTypeSyntax(name: .identifier("InitializeAction"))))
            }
            
            return attributes
        }
        
        return []
    }
}
