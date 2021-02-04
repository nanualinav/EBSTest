//
//  GeneralNavigationController.swift
//  EBSTest
//
//  Created by Alina Nanu on 18.01.2021.
//

import Foundation
import UIKit

class GeneralNavigationController: UINavigationController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        self.navigationBar.isTranslucent = false
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationBar.tintColor = UIColor.white
        
        self.navigationBar.barTintColor = UIColor(red: 24/255.0, green: 40/255.0, blue: 103/255.0, alpha: 1)
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
