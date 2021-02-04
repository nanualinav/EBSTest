//
//  JSONModel.swift
//  EBSTest
//
//  Created by Alina Nanu on 18.01.2021.
//

import Foundation

protocol JSONModel {
    init(dictionary dict: [String: Any])
    func forJSON() -> [String : Any]
}

extension JSONModel {
    public func forJSON() -> [String : Any] {
        // optional method
        return [String : Any]()
    }
}

extension Dictionary where Key == String {
    var jsonString: String? {
        get {
            if let theJSONData = try? JSONSerialization.data(withJSONObject: self, options: []) {
                return String(data: theJSONData, encoding: .utf8)
            }

            return nil
        }
        set{}
    }
}
