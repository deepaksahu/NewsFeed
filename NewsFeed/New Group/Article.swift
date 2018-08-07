//
//  Article.swift
//  NewsFeed
//
//  Created by Deepak Sahu on 07/08/18.
//  Copyright © 2018 Deepak Sahu. All rights reserved.
//

import UIKit

class Article: NSObject {
    var abstract:String?
    var adx_keywords:String?
    
    var asset_id:Int?
    
    var byline:String?
    var column:String?
    
    var id:Int?
    
    var published_date:String?
    var section:String?
    var source:String?
    
    var title:String?
    var type:String?
    var url:String?
    
    var des_facet:Array<Any>? = nil
    var org_facet:Array<Any>? = nil
    var per_facet:Array<Any>? = nil
    var media:Array<Any>? = nil
    
    var views: Int?

    
    convenience init(dictionary responseData: Any?) {
        self.init()
        let dicResponse = responseData as! Dictionary<String, AnyObject>
        self.abstract = (dicResponse["abstract"] as? String)
        self.adx_keywords = (dicResponse["adx_keywords"] as? String)
        
        self.asset_id = dicResponse["asset_id"] as? Int
        
        self.byline = (dicResponse["byline"] as? String)
        self.column = (dicResponse["column"] as? String)
        
        self.id = dicResponse["id"] as? Int
        
        self.published_date = (dicResponse["published_date"] as? String)
        self.section = (dicResponse["section"] as? String)
        self.source = (dicResponse["source"] as? String)
        
        self.title = (dicResponse["title"] as? String)
        self.type = (dicResponse["type"] as? String)
        self.url = (dicResponse["url"] as? String)
        
        self.des_facet = (dicResponse["des_facet"] as? Array<Any>)
        self.org_facet = (dicResponse["org_facet"] as? Array<Any>)
        self.per_facet = (dicResponse["per_facet"] as? Array<Any>)
        self.media = (dicResponse["media"] as? Array<Any>)
        
        self.views = dicResponse["views"] as? Int
    }
}
