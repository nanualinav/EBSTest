//
//  ViewControllersManager.swift
//  EBSTest
//
//  Created by Alina Nanu on 18.01.2021.
//

import Foundation
import UIKit

class ViewControllersManager: NSObject {
    static let shared = ViewControllersManager()
    
    var navController: GeneralNavigationController!
    
    func rootViewController() -> UIViewController {
        let vc = ItemsViewController()
        
        self.navController = GeneralNavigationController(rootViewController: vc)
        
        return self.navController
    }
}
