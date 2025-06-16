//
//  File.swift
//  KasaMacro
//
//  Created by reji on 5/28/25.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

public extension Macro {
    static var macroName: String {
        String(describing: Self.self).replacingOccurrences(of: "Macro", with: "")
    }
}

