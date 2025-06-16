//
//  RefreshMutationMacro.swift
//  KasaMacro
//
//  Created by reji on 5/28/25.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics
import Foundation

public struct RefreshMutationMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let _ = declaration.validateMutationEnum(macroName: self.macroName, node: node, context: context) else {
            return []
        }
        return [
            """
            case setIsRefreshing(Bool)
            """
        ]
    }
}

