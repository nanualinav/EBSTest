//
//  RequestManager.swift
//  EBSTest
//
//  Created by Alina Nanu on 18.01.2021.
//

import Foundation
import Alamofire

class RequestManager {
    
    // MARK: - Private Properties
    fileprivate var requestManager: Alamofire.Session
    
    // MARK: - Public Properties
    
    static let shared = RequestManager()
    
    // MARK: - Private
    
    fileprivate init() {
        self.requestManager = RequestManager.initRequestManager()
    }
    
    static func initRequestManager() -> Alamofire.Session {
        let man = Alamofire.Session()
    
        return man
    }
    
    fileprivate func request(_ method: HTTPMethod, url: String, success: @escaping ((_ response: [String : Any]) -> Void), fail: @escaping ((Error) -> Void)) {
        self.requestManager.request(url, method: method, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let body = value as? [String : AnyObject] {
                        success(body)
                    } else {
                        fail(NSError(domain: "", code: EBSError.Code.unknown, userInfo: [NSLocalizedDescriptionKey: "Unexpected response."]))
                    }
                case .failure(_):
                    fail(NSError(domain: "", code: EBSError.Code.unknown, userInfo: [NSLocalizedDescriptionKey: "Unexpected response."]))
                }
        }
    }
    
    // MARK: - Public
    
    func request(_ method: HTTPMethod, url: String, encoding: ParameterEncoding = JSONEncoding.default, headers: [String:String]? = nil, success: @escaping ((Any?) -> Void), fail: @escaping ((EBSError) -> Void)) {
        
        // set propper encoding
        var enc = encoding
        if method == .get || method == .delete {
            enc = URLEncoding.default
        }
        
        // create request
        var encodedRequest: URLRequest?
        let escapedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        do {
            let originalRequest = try URLRequest(url: escapedUrl, method: method)
            encodedRequest = try enc.encode(originalRequest, with: nil)
            
            if encodedRequest == nil {
                fail(EBSError(code: EBSError.Code.encodeError, message: "There was an error while creating request."))
            }
        } catch {
            fail(EBSError(code: (error as NSError).code, message: error.localizedDescription, userInfo: (error as NSError).userInfo))
        }
            // send request
            self.requestManager.request(encodedRequest!)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    
                    switch response.result {
                    case .success (let value):
                        
                        let body = value
                        
                        success(body)
                        
                    case .failure(let err):
                        
                    // error
                    do {
                        // try to parse error response from the server
                        if let errorJson = try JSONSerialization.jsonObject(with: response.data ?? Data(), options: .allowFragments) as? [String : AnyObject] {
                            let error = EBSError(dictionary: errorJson)
                            error.code = EBSError.Code.serverError
                            error.statusCode = response.response?.statusCode
                            fail(error)
                        }
                    } catch {
                        fail(EBSError(code: (err as NSError).code, message: err.localizedDescription, statusCode: response.response?.statusCode, userInfo: (err as NSError).userInfo))
                    }
            }
        }
    }
    
//
//    fileprivate func request(_ method: HTTPMethod, url: String, success: @escaping ((_ response: [String : AnyObject]) -> Void), fail: @escaping ((Error) -> Void)) {
//        self.requestManager.request(url, method: method, encoding: JSONEncoding.default)
//            .validate(statusCode: 200..<300)
//            .responseJSON { response in
//                switch response.result {
//                case .success(let value) :
//                    if let body = value as? [String : AnyObject] {
//                        success(body)
//                    } else {
//                        print("Unexpected response.")
//                    }
//
//                case .failure( _):
//                    do {
//                        if (try JSONSerialization.jsonObject(with: response.data ?? Data(), options: .allowFragments) as? [String : AnyObject]) != nil {
//                            print("Error parsing object")
//                        } else {
//                            print("Unexpected error response.")
//                        }
//
//                    } catch {
//                        print("Unexpected error response.")
//                    }
//                }
//            }
//        }
    
    // MARK: - Public
    
}



