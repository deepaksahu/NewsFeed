//
//  APIHandler.swift
//  Ways
//
//  Created by Vivan Raghuvanshi on 22/06/18.
//  Copyright © 2018 Vivan Raghuvanshi. All rights reserved.
//

import Foundation

struct APIHandler {
    
    static let RequestURL = URL.Domain.Stage + URL.ProjectPath
    
    struct Method {
        static let GET = "GET"
        static let POST = "POST"
        static let PUT = "PUT"
        static let DELETE = "DELETE"
    }
    
    private struct URL {
        struct Domain {
            static let Development = "http://api.nytimes.com/"
            static let Stage = "http://api.nytimes.com/"
            static let Production = "http://api.nytimes.com/"
        }
        static let ProjectPath = "svc/mostpopular/v2"
    }
    
    struct Path {
        static let MostViewed = "mostviewed/all-sections/7.json?api-key=f90924e9279443a78cf70a6bcdada8cf"
    }
    
    struct Param {
        static let APIKey = "api-key"
    }
    
    
}

