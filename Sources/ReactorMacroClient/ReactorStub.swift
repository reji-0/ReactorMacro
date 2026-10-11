//
//  File.swift
//  ReactorMacro
//
//  Created by reji on 5/28/25.
//

import Foundation


class Reactor { }

@propertyWrapper
public struct Pulse<Value> {
    public var wrappedValue: Value?
    public init(wrappedValue value: Value?) {
        self.wrappedValue = value
    }
}
