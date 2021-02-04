//
//  ProductItem.swift
//  EBSTest
//
//  Created by Alina Nanu on 19.01.2021.
//

import Foundation
import RealmSwift

class ProductItem: Object {
    @objc dynamic var ID = 0
    @objc dynamic var title = ""
    @objc dynamic var desc = ""
    @objc dynamic var image = ""
    @objc dynamic var price = 0.0
    @objc dynamic var salePercent = 0.0
    @objc dynamic var details = ""
}
