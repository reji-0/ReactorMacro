//
//  StateOptionSet.swift
//  ReactorMacro
//
//  Created by reji on 6/16/25.
//

import Foundation

public struct StateOptionSet: OptionSet, Sendable {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let loading = StateOptionSet(rawValue: 1 << 0)
    public static let refresh = StateOptionSet(rawValue: 1 << 1)
    public static let error = StateOptionSet(rawValue: 1 << 2)
}
