//
//  RequestHandler.swift
//  EBSTest
//
//  Created by Alina Nanu on 18.01.2021.
//

import Foundation
import Alamofire

public typealias failBlock = (EBSError) -> Void

class RequestHandler {
    
    static let shared = RequestHandler()
    
    static func getItems(with offset: Int, limit: Int, success: @escaping ([Item]) -> Void, fail: @escaping failBlock) {
        let url = String(format: "%@?offset=\(offset)&limit=\(limit)", NetworkSettings.endpointUrl(.products), offset, limit)
        
        RequestManager.shared.request(.get, url: url, success: { (response) in
            if let results = response as? [[String:Any]] {
                success(Item.collectionFromArray(array: results))
            } else {
                fail(EBSError(code: EBSError.Code.badResponse, message: "Unexpected Respomse"))
            }
        }) { (error) in
            fail(error)
        }
    }
    
    static func getDetails(for itemId: Int, success: @escaping (Item) -> Void, fail: @escaping failBlock) {
        let url = String(format: "%@?id=\(itemId)", NetworkSettings.endpointUrl(.product), itemId)
        
        RequestManager.shared.request(.get, url: url, success: { (response) in
            if let result = response as? [String:Any] {
                success(Item(dictionary: result))
            } else {
                fail(EBSError(code: EBSError.Code.badResponse, message: "Unexpected Respomse"))
            }
        }) { (error) in
            fail(error)
        }
    }
}
