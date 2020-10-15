//
//  Decodable+Extensions.swift
//  SwiftReceipts
//
//  Created by Elder Santos on 14/10/20.
//

import Foundation

extension Decodable {
    
    init(from: Any) throws {
        let data = try JSONSerialization.data(withJSONObject: from, options: .prettyPrinted)
        let decoder = JSONDecoder()
        self = try decoder.decode(Self.self, from: data)
    }
}
