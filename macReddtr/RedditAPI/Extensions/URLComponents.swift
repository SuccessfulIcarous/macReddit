//
//  URLComponents.swift
//  macReddtr
//
//  Created by Brata on 25/07/21.
//

import Foundation

public extension URLComponents {
    mutating func setQueryItems(with: [String: Any]) {
        var queryItems: [URLQueryItem] = []
        for param in with {
            queryItems.append(URLQueryItem(name: param.key, value: "\(param.value)"))
        }
        self.queryItems = queryItems
    }
}
