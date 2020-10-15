//
//  UIImage+Extensions.swift
//  SwiftReceipts
//
//  Created by Elder Santos on 14/10/20.
//

import UIKit

extension UIImage {
    
    func toString() -> String? {
        let data: Data? = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
}
