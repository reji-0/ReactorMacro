//
//  File.swift
//  ReactorMacro
//
//  Created by reji on 6/16/25.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

import ReactorMacroShared

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
            optionSet.insert(.initialize)
            
        case "refresh":
            optionSet.insert(.refresh)
            
        default:
            break
        }
    }
    
    return optionSet
}

let tabIndent = "    "
