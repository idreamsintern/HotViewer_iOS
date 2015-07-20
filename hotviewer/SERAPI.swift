//
//  SERAPI.swift
//  hotviewer
//
//  Created by 傑瑞 on 2015/7/18.
//  Copyright (c) 2015年 傑瑞. All rights reserved.
//

import Foundation

class SERAPI: API {
    static let instance = SERAPI()
    init() {
        super.init(apiUrl: "http://api.ser.ideas.iii.org.tw/api/", tokenUrl: "user/get_token", tokenParams: ["id":"a1411f06f306e17dad9956dc6ba86cdb", "secret_key":"1369ac51fd6fc95db2e9dde7b74cc3b8"])
    }
    func searchFBCheckin(params: [String: String?], onLoad: (checkins:[FBCheckin]?) -> ()) {
        self.ensureValidToken() {
            self.post(params, url: "fb_checkin_search", postCompleted: {
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
    func searchPTTTopArticle(params: [String: String?], onLoad: (pttArticles: [PTTArticle]? ) -> ()) {
        self.ensureValidToken() {
            self.post(params, url: "top_article", postCompleted: {
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
}