//
//  LoadingStateMacro.swift
//  ReactorMacro
//
//  Created by reji on 5/14/25.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics
import Foundation

public struct LoadingStateMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let _ = declaration.validateStateStruct(macroName: self.macroName, node: node, context: context) else {
            return []
        }
        return [
            """
            var isLoading: Bool = false
            """
        ]
    }
}

