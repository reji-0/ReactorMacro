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
            features.insert(.loading)
        case "refresh":
            features.insert(.refresh)
        case "error":
            features.insert(.error)
        default:
            break
        }
        
    }
    
    return features
}


@MainActor
func extractActionSet(_ node: AttributeSyntax) -> ActionOptionSet {
    guard let arguments = node.arguments?.as(LabeledExprListSyntax.self),
          let firstArg = arguments.first?.expression.as(ArrayExprSyntax.self) else {
        return []
    }
    var optionSet: ActionOptionSet = []
    
    for element in firstArg.elements {
        let memberAccess = element.expression.as(MemberAccessExprSyntax.self)
        let name = memberAccess?.declName.baseName.text
        switch name {
        case "initialize":
            features.insert(.initialize)
        case "refresh":
            features.insert(.refresh)
        default:
            break
        }
        
    }
    
    return features
}
