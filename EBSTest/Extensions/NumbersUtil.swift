//
//  NumbersUtil.swift
//  EBSTest
//
//  Created by Alina Nanu on 18.01.2021.
//

import Foundation

extension Double {
    
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1.0) != 0 ? String(format: "%.2f", self) : String(self)
    }
}

struct NotificationKey {
    static let productListsShouldRefresh = "ProductListsShouldRefresh"
}
