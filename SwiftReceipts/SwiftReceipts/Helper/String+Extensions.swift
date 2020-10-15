//
//  String+Extensions.swift
//  SwiftReceipts
//
//  Created by Elder Santos on 14/10/20.
//

import UIKit

extension String {
    
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
}
