//
//  ErrorSupportMacro.swift
//  ReactorMacro
//
//  Created by reji on 5/27/25.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation
import SwiftDiagnostics

/*
 @ErrorState
 
 Reactor Class의 위에 붙여 사용합니다.
 @ErrorState, @ErrorMutation을 한번에 작성해줍니다.
 */

public struct ErrorSupportMacro: MemberAttributeMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingAttributesFor member: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AttributeSyntax] {
        guard let _ = declaration.validateReactorClass(macroName: self.macroName, node: node, context: context) else {
            return []
        }
        
        if let structDecl = member.as(StructDeclSyntax.self),
           structDecl.name.text == "State" {
            return [AttributeSyntax(attributeName: IdentifierTypeSyntax(name: .identifier("ErrorState")))]
        }
        
        if let enumDecl = member.as(EnumDeclSyntax.self),
           enumDecl.name.text == "Mutation" {
            return [AttributeSyntax(attributeName: IdentifierTypeSyntax(name: .identifier("ErrorMutation")))]
        }
        
        return []
    }
}
