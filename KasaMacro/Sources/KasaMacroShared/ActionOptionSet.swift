//
//  ActionOptionSet.swift
//  KasaMacro
//
//  Created by reji on 6/16/25.
//

import Foundation

public struct ActionOptionSet: OptionSet {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    @MainActor public static let refresh = ActionOptionSet(rawValue: 1 << 0)
    @MainActor public static let initialize = ActionOptionSet(rawValue: 1 << 1)
}
