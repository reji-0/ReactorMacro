//
//  File.swift
//  KasaMacro
//
//  Created by reji on 6/16/25.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

import KasaMacroShared

@MainActor
func extractStateOptionSet(_ node: AttributeSyntax) -> StateOptionSet {
    guard let arguments = node.arguments?.as(LabeledExprListSyntax.self),
          let firstArg = arguments.first?.expression.as(ArrayExprSyntax.self) else {
        return []
    }
    var optionSet: StateOptionSet = []
    
    for element in firstArg.elements {
        let memberAccess = element.expression.as(MemberAccessExprSyntax.self)
        let name = memberAccess?.declName.baseName.text
        switch name {
        case "loading":
            optionSet.insert(.loading)
        case "refresh":
            optionSet.insert(.refresh)
        case "error":
            optionSet.insert(.error)
        default:
            break
        }
        
    }
    
    return optionSet
}


@MainActor
func extractActionSet(_ node: AttributeSyntax) -> [ActionOptionSet] {
    guard let arguments = node.arguments?.as(LabeledExprListSyntax.self),
          let firstArg = arguments.first?.expression.as(ArrayExprSyntax.self) else {
        return []
    }
    var optionSet: [ActionOptionSet] = []
    
    for element in firstArg.elements {
        let memberAccess = element.expression.as(MemberAccessExprSyntax.self)
        let name = memberAccess?.declName.baseName.text
        switch name {
        case "initialize":
            optionSet.insert(.initialize, at: 0)
        case "refresh":
            optionSet.insert(.refresh, at: 0)
        default:
            break
        }
        
    }
    
    return optionSet
}
