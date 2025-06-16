//
//  File.swift
//  KasaMacro
//
//  Created by reji on 5/27/25.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

extension DeclGroupSyntax {
    
    public func validateStateStruct(
        macroName: String,
        node: AttributeSyntax,
        context: some MacroExpansionContext
    ) -> StructDeclSyntax? {
        guard let structDecl = self.as(StructDeclSyntax.self) else {
            context.diagnose(Diagnostic(node: Syntax(node), message: MacroError.notStruct(macro: macroName)))
            return nil
        }

        guard structDecl.name.text == "State" else {
            context.diagnose(Diagnostic(node: Syntax(node), message: MacroError.invalidNameForState(macro: macroName)))
            return nil
        }

        return structDecl
    }

    public func validateMutationEnum(
        macroName: String,
        node: AttributeSyntax,
        context: some MacroExpansionContext
    ) -> EnumDeclSyntax? {
        guard let enumDecl = self.as(EnumDeclSyntax.self) else {
            context.diagnose(Diagnostic(node: Syntax(node), message: MacroError.notEnum(macro: macroName)))
            return nil
        }

        guard enumDecl.name.text == "Mutation" else {
            context.diagnose(Diagnostic(node: Syntax(node), message: MacroError.invalidNameForMutation(macro: macroName)))
            return nil
        }

        return enumDecl
    }

    public func validateActionEnum(
        macroName: String,
        node: AttributeSyntax,
        context: some MacroExpansionContext
    ) -> EnumDeclSyntax? {
        guard let enumDecl = self.as(EnumDeclSyntax.self) else {
            context.diagnose(Diagnostic(node: Syntax(node), message: MacroError.notEnum(macro: macroName)))
            return nil
        }

        guard enumDecl.name.text == "Action" else {
            context.diagnose(Diagnostic(node: Syntax(node), message: MacroError.invalidNameForAction(macro: macroName)))
            return nil
        }

        return enumDecl
    }

    func validateReactorClass(
        macroName: String,
        node: AttributeSyntax,
        context: some MacroExpansionContext
    ) -> ClassDeclSyntax? {
        guard let classDecl = self.as(ClassDeclSyntax.self) else {
            context.diagnose(Diagnostic(node: Syntax(node), message: MacroError.notClass(macro: macroName)))
            return nil
        }

        let inheritsReactor = classDecl.inheritanceClause?.inheritedTypes.contains {
            $0.type.as(IdentifierTypeSyntax.self)?.name.text == "Reactor"
        } ?? false

        guard inheritsReactor else {
            context.diagnose(Diagnostic(node: Syntax(node), message: MacroError.notInheritingReactor(macro: macroName)))
            return nil
        }

        return classDecl
    }
}
