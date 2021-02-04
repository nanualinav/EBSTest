//
//  EBSError.swift
//  EBSTest
//
//  Created by Alina Nanu on 18.01.2021.
//

import Foundation

public class EBSError {
    
    // properties
    var code: Int
    var message: String?
    var statusCode: Int?
    var userInfo: [String:Any]?
    
    init(dictionary dict: [String: Any]) {
        self.code = EBSError.Code.serverError
        
        self.message = dict["message"] as? String
    }
    
    init(code: Int, message: String?, statusCode: Int? = nil, userInfo: [String:Any]? = nil) {
        self.code = code
        self.message = message
        self.statusCode = statusCode
        self.userInfo = userInfo
    }
    
    struct Code {
        static let unknown = 50001
        static let serverError = 50002
        static let encodeError = 50003
        static let badResponse = 50004
    }
}


