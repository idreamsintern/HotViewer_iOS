//
//  AllMethods.swift
//  hotviewer
//
//  Created by 傑瑞 on 2015/7/15.
//  Copyright (c) 2015年 傑瑞. All rights reserved.
//

import Foundation
import CoreData


func searchArticleId(params: [String: String?], onLoad: (articles:[ContentParty]?) -> ()) {
    contentAPI.post(params, url: "search_article_id", postCompleted: {
        succeeded, msg, result in
        
        var articles = [ContentParty]()
        
        if let articleArray = result.array {
            for articleJSON in articleArray {
                articles.append(ContentParty(articleJSON: articleJSON))
            }
        }
        onLoad(articles: articles)
    })
}

