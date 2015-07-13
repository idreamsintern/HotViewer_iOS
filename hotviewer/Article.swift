//
//  Article.swift
//  hotviewer
//
//  Created by 傑瑞 on 2015/7/14.
//  Copyright (c) 2015年 傑瑞. All rights reserved.
//

import Foundation
import UIKit

enum ArticleType {
    case PTT, Forum, Facebook
}

class Article: NSObject {
    var type: ArticleType
    var title: String
    var url: String
    var time: String
    
    init(post: JSON, type: ArticleType) {
        self.type = type
        self.title = post["title"].stringValue
        self.url = post["url"].stringValue
        self.time = post["time"].stringValue
    }
}

class PTTPost: Article {
    var push: Int
    init(post: JSON) {
        self.push = post["push"].intValue
        super.init(post: post, type: ArticleType.PTT)
    }
}

class FBPost: Article {
    var like: Int
    var share: Int
    var comment: Int
    static var imageCache = [String, UIImage]()
    var thumbnailUrl: String!
    var pageId: String!
    var pageName: String!
    
    init(post: JSON) {
        self.like = post["likes"].intValue
        self.share = post["shares"].intValue
        self.comment = post["comments"].intValue
        
        
        var error: NSError?
        var regex = NSRegularExpression(pattern: "(\\d+)\\s(.+)", options: NSRegularExpressionOptions.DotMatchesLineSeparators, error: &error)
        var pageIdName = post["page_id_name"].stringValue
        
        if(error == nil) {
            self.pageId = regex?.stringByReplacingMatchesInString(pageIdName, options: nil, range: NSRange(location:0, length:count(pageIdName)), withTemplate: "$1")
            self.pageName = regex?.stringByReplacingMatchesInString(pageIdName, options: nil, range: NSRange(location:0, length:count(pageIdName)), withTemplate: "$2")
            self.thumbnailUrl = "https://graph.facebook.com/v2.4/\(self.pageId)/picture/?type=large"
        }

        super.init(post: post, type: ArticleType.Facebook)
    }
}

class ForumPost: Article {
    var reply: Int
    init(post: JSON) {
        self.reply = post["reply"].intValue
        super.init(post: post, type: ArticleType.Forum)
    }
}
