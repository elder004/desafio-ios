//
//  Encodable+Extensions.swift
//  SwiftReceipts
//
//  Created by Elder Santos on 14/10/20.
//

import Foundation

extension Encodable {
        
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
          throw NSError()
        }
        return dictionary
    }
        
}
