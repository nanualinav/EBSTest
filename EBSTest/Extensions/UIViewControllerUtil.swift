//
//  UIViewControllerUtil.swift
//  EBSTest
//
//  Created by Alina Nanu on 18.01.2021.
//

import Foundation
import UIKit

extension UIViewController {
    typealias actionHandler = ((UIAlertAction) -> Void)
    
    func show(message: String?, title: String?, handler: actionHandler? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: handler)
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}
