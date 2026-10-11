//
//  ActionOptionSet.swift
//  ReactorMacro
//
//  Created by reji on 6/16/25.
//

import Foundation

public struct ActionOptionSet: OptionSet, Sendable {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let refresh = ActionOptionSet(rawValue: 1 << 0)
    public static let initialize = ActionOptionSet(rawValue: 1 << 1)
}
