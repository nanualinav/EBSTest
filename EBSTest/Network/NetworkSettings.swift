//
//  NetworkSettings.swift
//  EBSTest
//
//  Created by Alina Nanu on 18.01.2021.
//

import Foundation

struct NetworkSettings {
    
    static let baseUrl = "http://mobile-test.devebs.net:5000"
    
    static func endpointUrl(_ end: Endpoint) -> String {
        return String(format: "%@/%@", baseUrl, end.rawValue)
    }
}

enum Endpoint: String {
    case products = "products"
    case product = "product"
}
