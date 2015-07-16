//
//  ContentParty.swift
//  hotviewer
//
//  Created by 傑瑞 on 2015/7/15.
//  Copyright (c) 2015年 傑瑞. All rights reserved.
//

import Foundation
import UIKit
import CoreData

let contentAPI = API(apiUrl: "http://contentparty.org/api/", token: "api_doc_token")

class ContentParty {
    var dataId: String?
    var title: String?
    var author: String?
    var siteName: String?
    var time: String?
    
    /* The following properties get loaded after calling
       getArticle and callback as onLoad() */
    var loaded: Bool = false
    var content: String?
    var tag: String?
    var url: NSURL?
    var thumbnailURL: NSURL?

    init(articleJSON: JSON) {
        self.dataId = articleJSON["data_id"].string
        self.title = articleJSON["title"].string
        self.author = articleJSON["author"].string
        self.siteName = articleJSON["sitename"].string
        self.time = articleJSON["time"].string
    }
    
    func getArticle(onLoad: () -> ()) {
        contentAPI.post([ "data_id": self.dataId, "lang": "zh-tw" ], url: "get_article") {
            succeeded, msg, result in
            var rawContent = result["content"].string
            if var rawContent = rawContent {
                rawContent = rawContent.stringByReplacingOccurrencesOfString(" ", withString: "")
                
                self.tag = result["tag"].string
                self.url = NSURL(string: result["source_url"].stringValue)
                
                if let imgUrl = matchRegex(".+imgsrc=(.+)alt.+", text: rawContent, template: "$1") {
                    self.thumbnailURL = NSURL(string: imgUrl)
                }
                
                self.content = matchRegex("<divid=\\\"lucy_box\\\"><img.+>(.+)<\\/div>.+", text: rawContent, template: "$1")
                self.loaded = true
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                onLoad()
            }
        }
    }
}

enum ContentSortType: String {
    case Time = "time"
    case Click = "clicks"
    case Title = "title"
    case Author = "author"
}

func matchRegex(regex: String!, #text: String!, #template: String) -> String? {
    var error: NSError?
    var regex = NSRegularExpression(pattern: regex, options: NSRegularExpressionOptions.UseUnixLineSeparators, error: &error)
    
    if(error == nil) {
        return regex?.stringByReplacingMatchesInString(text, options: nil, range: NSRange(location:0, length:count(text)), withTemplate: template)
    } else {
        return nil
    }
}
