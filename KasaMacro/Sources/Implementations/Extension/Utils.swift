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

func extractParameters(_ node: AttributeSyntax) -> [String] {
   var parameters: [String] = []
   
   if let args = node.arguments?.as(LabeledExprListSyntax.self),
      let firstArg = args.first?.expression {
       if let arrayExpr = firstArg.as(ArrayExprSyntax.self) {
           for element in arrayExpr.elements {
               if let stringLiteral = element.expression.as(StringLiteralExprSyntax.self) {
                   let stringValue = stringLiteral.segments.compactMap { segment in
                       segment.as(StringSegmentSyntax.self)?.content.text
                   }.joined()
                   parameters.append(stringValue)
               }
           }
       }
   }
   return parameters
}

@MainActor
func extractStateOptionSet(_ node: AttributeSyntax) -> StateOptionSet {
    guard let arguments = node.arguments?.as(LabeledExprListSyntax.self),
          let firstArg = arguments.first?.expression.as(ArrayExprSyntax.self) else {
        return []
    }
    var features: StateOptionSet = []
    
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
    var features: ActionOptionSet = []
    
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
