//
//  RestManager.swift
//  NewsFeed
//
//  Created by Deepak Sahu on 07/08/18.
//  Copyright © 2018 Deepak Sahu. All rights reserved.
//

import UIKit

enum RestManagerStatusCode : Int {
    case sucess = 200
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case unknownError = -999
}

private let RestManagerErrorDomain = "RestManagerDomainError"
fileprivate let REST_MANAGER_LOG_ENABLED = true

class RestManager: NSObject {
    
    class func parseKeyPath(_ keyPath: String?, responseData data: Data?, reponse response: URLResponse?, error: Error?, completionHandler: @escaping (_ data: Any?, _ error: Error?) -> Void) {
        
        if error != nil {
            completionHandler(nil, error)
        } else {
            var statusCode: Int = -1
        
            statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            
            if statusCode == (RestManagerStatusCode.sucess).rawValue {
                var parseJsonError: Error? = nil
                var json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                #if REST_MANAGER_LOG_ENABLED
                
                var logText = "RestManager:[\(keyPath)]\nStatusCode[\(Int(statusCode))]"
                if json == nil {
                    var restLog = String(data: data, encoding: .ascii)
                    RMLog("%@\nParseJsonError[%@]\nResponse Data\n%@", logText, parseJsonError.localizedDescription, restLog)
                } else {
                    RMLog("%@\nResponse\n%@", logText, json)
                }
                
                #endif
                completionHandler(json as Any, parseJsonError)
            } else {
                
                #if REST_MANAGER_LOG_ENABLED
                RMLog("RestManager:[%@]\nStatus Code = %ld\nError Description = %@\nResponse Json:\n%@", keyPath, statusCode, errorText, json)
                #endif
                    completionHandler(nil, NSError(domain: RestManagerErrorDomain, code: statusCode, userInfo: [NSLocalizedDescriptionKey : "Unexpected Error"]))
            }
        }
    }

    
    class func restRequestServerURL(_ url: URL?, method: String?, headers: [AnyHashable : Any]?, from bodyData: Data?, completionHandler: @escaping (_ data: Any?, _ error: Error?) -> Void) {
        var request: NSMutableURLRequest? = nil
        if let anUrl = url {
            request = NSMutableURLRequest(url: anUrl)
        }
        request?.httpMethod = method ?? ""
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = headers
        let session = URLSession(configuration: config)
        if REST_MANAGER_LOG_ENABLED {
            if (bodyData?.count ?? 0) > 2000000 {
                print("RestManager:[\(String(describing: url?.path))]\nRequest URL = \(String(describing: url?.absoluteString))\nMethod = \(String(describing: method))\nHeaders\n\(String(describing: headers))\nBody\nBody data length more than 2 MB")
            } else {
                var body: String? = nil
                if let aData = bodyData {
                    body = String(data: aData, encoding: .ascii)
                }
                print("RestManager:[\(String(describing: url?.path))]\nRequest URL = \(String(describing: url?.absoluteString))\nMethod = \(String(describing: method))\nHeaders\n\(String(describing: headers))\nBody\n\(String(describing: body))")
            }
        }
        
        if bodyData != nil && ((method == APIHandler.Method.POST) || (method == APIHandler.Method.PUT) || (method == APIHandler.Method.DELETE)) {
            let uploadTask: URLSessionUploadTask? = session.uploadTask(with: request! as URLRequest, from: bodyData, completionHandler: { data, response, error in
                RestManager.parseKeyPath(url?.path, responseData: data, reponse: response, error: error, completionHandler: completionHandler)
            })
            uploadTask?.resume()
        } else if (method == APIHandler.Method.POST) || (method == APIHandler.Method.PUT) || (method == APIHandler.Method.GET) || (method == APIHandler.Method.DELETE) {
            let dataTask: URLSessionDataTask? = session.dataTask(with: request! as URLRequest, completionHandler: { data, response, error in
                RestManager.parseKeyPath(url?.path, responseData: data, reponse: response, error: error, completionHandler: completionHandler)
            })
            dataTask?.resume()
        } else {
            completionHandler(nil, NSError(domain: RestManagerErrorDomain, code: Int(-4000), userInfo: [NSLocalizedDescriptionKey : "Not Implemented"]))
        }
    }

    class func restRequestPath(_ keyPath: String?, method: String?, urlParams: [AnyHashable : Any]?, additionalHeaders: [AnyHashable : Any]?, from bodyData: Data?, completionHandler: @escaping (_ data: Any?, _ error: Error?) -> Void) {
        let components = URLComponents(string: "\(APIHandler.RequestURL)/\(APIHandler.Path.MostViewed )")
//        if urlParams != nil {
//            var queryParams: [AnyHashable] = []
//            for key: String? in urlParams?.keys ?? [String?]() {
//                let value = urlParams?[key] as? String
//                let queryParam = URLQueryItem(name: key ?? "", value: value)
//                queryParams.append(queryParam)
//            }
//            components?.queryItems = queryParams as? [URLQueryItem]
//        }
        let headers = ["Content-Type": "application/json"]
//        if additionalHeaders != nil {
//            for (k, v) in additionalHeaders { headers[k] = v }
//        }
        RestManager.restRequestServerURL(components?.url, method: method, headers: headers, from: bodyData, completionHandler: completionHandler)
    }
    
    class func request(withPath path: String?, method: String?, urlParams: [AnyHashable : Any]?, additionalHeaders: [AnyHashable : Any]?, from bodyData: Data?, onSuccess: @escaping (_ response: RestResponse?) -> Void, onFailure: @escaping (_ error: Error?) -> Void) {
        
        RestManager.restRequestPath(path, method: method, urlParams: urlParams, additionalHeaders: additionalHeaders, from: bodyData, completionHandler: { response, error in
            if response != nil {
                let rr:RestResponse = RestResponse(dictionary: response)
                DispatchQueue.main.async(execute: {
                    onSuccess(rr)
                })
            }
            else{
                DispatchQueue.main.async(execute: {
                    onFailure(error)
                })
            }
        })
    }
}
