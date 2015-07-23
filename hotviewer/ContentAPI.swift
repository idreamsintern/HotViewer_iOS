//
//  ContentAPI.swift
//  hotviewer
//
//  Created by 傑瑞 on 2015/7/18.
//  Copyright (c) 2015年 傑瑞. All rights reserved.
//

import Foundation
class ContentAPI: API {
    static let instance = ContentAPI()
    init() {
        super.init(apiUrl: "http://contentparty.org/api/", tokenUrl: "get_token", tokenParams: ["user_code":"0a556cd13e85397f623f2a3adef54cf4"])
    }
    func searchArticleId(#limit: Int, page: Int, sort: ContentSortType, keyword: String? = nil, tag: String? = nil, onLoad: (articles:[ContentArticle]?) -> ()) {
        
        self.ensureValidToken() {
            self.post([
                    "limit": String(limit),
                    "page": String(page),
                    "sort": sort.rawValue,
                    "keyword": keyword,
                    "tag": tag
                ], url: "search_article_id", postCompleted: {
                succeeded, msg, result in
                var articles = [ContentArticle]()
                if succeeded, let articleArray = result.array {
                    for articleJSON in articleArray {
                        articles.append(ContentArticle(articleJSON: articleJSON))
                    }
                }
                dispatch_async(dispatch_get_main_queue()) {
                    onLoad(articles: articles)
                }
            })
        }
    }
}