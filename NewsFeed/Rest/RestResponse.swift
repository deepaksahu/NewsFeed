//
//  RestResponse.swift
//  NewsFeed
//
//  Created by Deepak Sahu on 07/08/18.
//  Copyright © 2018 Deepak Sahu. All rights reserved.
//

import UIKit

class RestResponse: NSObject {
    var status:String = ""
    var copyright:String = ""
    var results:Array<Article>? = nil
    var num_results: Int?
    
    convenience init(dictionary responseData: Any?) {
        self.init()
        let dicResponse = responseData as! Dictionary<String, AnyObject>
        
        self.status = (dicResponse["status"] as? String)!
        self.copyright = (dicResponse["copyright"] as? String)!
        
        self.num_results = dicResponse["num_results"] as? Int
        //self.results = (dicResponse["results"] as? Array<Any>)!
        let dataArray = (dicResponse["results"] as? Array<Any>)!
        self.results = Array<Article>()
        for dict in dataArray {
            self.results?.append(Article.init(dictionary: dict))
        }
    }
}
