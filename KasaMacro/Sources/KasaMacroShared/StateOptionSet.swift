//
//  StateOptionSet.swift
//  KasaMacro
//
//  Created by reji on 6/16/25.
//

import Foundation

public struct StateOptionSet: OptionSet {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    @MainActor public static let loading = StateOptionSet(rawValue: 1 << 0)
    @MainActor public static let refresh = StateOptionSet(rawValue: 1 << 1)
    @MainActor public static let error = StateOptionSet(rawValue: 1 << 2)
}
