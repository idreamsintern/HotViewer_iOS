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
        if succeeded, let articleArray = result.array {
            for articleJSON in articleArray {
                articles.append(ContentParty(articleJSON: articleJSON))
            }
        }
        dispatch_async(dispatch_get_main_queue()) {
            onLoad(articles: articles)
        }
    })
}

func searchFBCheckin(params: [String: String?], onLoad: (checkins:[FBCheckin]?) -> ()) {
    serAPI.post(params, url: "fb_checkin_search", postCompleted: {
        succeeded, msg, result in
        var checkins = [FBCheckin]()
        if succeeded, let checkinsArr = result.array {
            for checkin in checkinsArr {
                checkins.append(FBCheckin(checkinJSON: checkin))
            }
        }
        dispatch_async(dispatch_get_main_queue()) {
            onLoad(checkins: checkins)
        }
    })
}

