//
//  MacroError.swift
//  KasaMacro
//
//  Created by reji on 5/14/25.
//

import SwiftDiagnostics
import Foundation

public enum MacroError: DiagnosticMessage {
    case notStruct(macro: String)
    case invalidNameForState(macro: String)
    case notEnum(macro: String)
    case invalidNameForAction(macro: String)
    case invalidNameForMutation(macro: String)
    case notClass(macro: String)
    case notInheritingReactor(macro: String)

    public var message: String {
        switch self {
            
        case .notStruct(let macro):
            return "@\(macro) can only be applied to structs."
        
        case .invalidNameForState(let macro):
            return "@\(macro) can only be applied to structs named 'State'."
        
        case .notEnum(let macro):
            return "@\(macro) can only be applied to enums."
        
        case .invalidNameForAction(let macro):
            return "@\(macro) can only be applied to enums named 'Action'."
            
        case .invalidNameForMutation(let macro):
            return "@\(macro) can only be applied to enums named 'Mutation'."
        
        case .notClass(let macro):
            return "@\(macro) can only be applied to classes."
            
        case .notInheritingReactor(let macro):
            return "@\(macro) can only be applied to classes that inherit from Reactor."
        }
    }

    public var severity: DiagnosticSeverity { .error }

    public var diagnosticID: MessageID {
        MessageID(domain: "KasaMacro", id: String(describing: self))
    }
}
