//
//  Item.swift
//  EBSTest
//
//  Created by Alina Nanu on 18.01.2021.
//

import Foundation

struct ItemKey {
    static let ID = "id"
    static let title = "title"
    static let description = "short_description"
    static let image = "image"
    static let price = "price"
    static let salePrecent = "sale_precent"
    static let details = "details"
}

class Item: JSONModel {
    var ID: Int?
    var title: String?
    var description: String?
    var image: String?
    var price: Double?
    var salePercent: Double?
    var details: String?
    
    required init(dictionary dict: [String : Any]) {
        
        self.ID = dict[ItemKey.ID] as? Int
        self.title = dict[ItemKey.title] as? String
        self.description = dict[ItemKey.description] as? String
        self.image = dict[ItemKey.image] as? String
        self.price = dict[ItemKey.price] as? Double
        self.salePercent = dict[ItemKey.salePrecent] as? Double
        self.details = dict[ItemKey.details] as? String
    }
    
    static func collectionFromArray(array: [[String : Any]]?) -> [Item] {
        var output = [Item]()
        
        if let arr = array {
            for dict in arr {
                let obj = Item(dictionary: dict)
                output.append(obj)
            }
        }
        
        return output
    }
}
