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
import Foundation
import SwiftDiagnostics

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
