//
//  SERAPI.swift
//  hotviewer
//
//  Created by 傑瑞 on 2015/7/18.
//  Copyright (c) 2015年 傑瑞. All rights reserved.
//

import Foundation
import MapKit

class SERAPI: API {
    static let instance = SERAPI()
    init() {
        super.init(apiUrl: "http://api.ser.ideas.iii.org.tw/api/", tokenUrl: "user/get_token", tokenParams: ["id":"f96b19549299c4aac64d6f05507a4f2a", "secret_key":"dcf0810b6fd371cba78d01ba3db325f8"])
    }
    func searchFBCheckin(#coordinate: CLLocationCoordinate2D, radius: Float, keyword: String? = nil, category: String? = nil, limit: Int? = 10, period: FBCheckinPeriod, sort: FBCheckinSortType, onLoad: (checkins:[FBCheckin]?) -> ()) {
        self.ensureValidToken() {
            self.post([
                    "coordinates":"\(coordinate.latitude),\(coordinate.longitude)",
                    "radius": "\(radius)",
                    "keyword": keyword,
                    "category": category,
                    "limit": String(limit!),
                    "period": period.rawValue,
                    "sort": sort.rawValue
                ], url: "fb_checkin_search", postCompleted: {
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
    }
    func searchPTTTopArticle(#period: Int, board: String? = nil, category: String? = nil, limit: Int? = 10, onLoad: (pttArticles: [PTTArticle]? ) -> ()) {
        self.ensureValidToken() {
            self.post([
                    "period": String(period),
                    "board": board,
                    "category": category,
                    "limit": String(limit!)
                ], url: "top_article/ptt", postCompleted: {
                succeeded, msg, result in
                var pttArticles = [PTTArticle]()
                
                if succeeded, let pttArr = result.array {
                    for pttArticle in pttArr {
                        pttArticles.append(PTTArticle(pttJSON: pttArticle))
                    }
                }
                dispatch_async(dispatch_get_main_queue()) {
                    onLoad(pttArticles: pttArticles)
                }
            })
        }
    }
    func searchPTTTopArticleByKeyword(type:String,keyword: String?  = nil,limit: Int,sort:String, onLoad: (pttArticles: [PTTArticle]? ) -> ()) {
        self.ensureValidToken() {
            self.post([
                "type" : type,
                "limit" : String(limit),
                "keyword": keyword,
                "sort":sort
                ], url: "keyword_search/ptt", postCompleted: {
                    succeeded, msg, result in
                    var pttArticles = [PTTArticle]()
                    
                    if succeeded, let pttArr = result.array {
                        for pttArticle in pttArr {
                            pttArticles.append(PTTArticle(pttJSON: pttArticle))
                        }
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        onLoad(pttArticles: pttArticles)
                    }
            })
        }
    }
    func searchFBFanpage(keyword:String? = nil, category: String? = nil, sortBy: FBFanpageSort, onLoad: (fbFanpage: [FBFanpage]?) -> ()) {
        self.ensureValidToken() {
            self.post(
                [
                    "category": category,
                    "sort": sortBy.rawValue,
                    "limit": "100",
                    "keyword": keyword ?? " "
                ], url: "fb_fanpage_search", postCompleted: {
                succeeded, msg, result in
                var fbFanpages = [FBFanpage]()
                
                if succeeded, let fbArr = result.array {
                    for fbFanpage in fbArr {
                        let page = FBFanpage(fanpageJSON: fbFanpage)
                        if page.about != nil {
                            fbFanpages.append(page)
                        }
                    }
                }
                dispatch_async(dispatch_get_main_queue()) {
                    onLoad(fbFanpage: fbFanpages)
                }
            })
        }
    }
}