//
//  UIViewController+Extension.swift
//  SwiftReceipts
//
//  Created by Elder Santos on 14/10/20.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String, completion: (() -> ())? = nil){
        
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "Ok", style: .default){
            (alert) in
            completion?()
        })
        
        self.present(alertViewController, animated: true, completion: nil)
    }
}
