//
//  FBCheckin.swift
//  hotviewer
//
//  Created by 傑瑞 on 2015/7/17.
//  Copyright (c) 2015年 傑瑞. All rights reserved.
//

import Foundation

let serAPI = API(apiUrl: "http://api.ser.ideas.iii.org.tw/api/", token: "api_doc_token")

class FBCheckin {
    var id: String?
    var name: String?
    var category: String?
    var longitude: Double?
    var latitude: Double?
    var checkinsUpcount: Int?
    var checkins: Int?
    var startDate: String?
    var thumbnailURL: NSURL?
    
    init(checkinJSON : JSON) {
        self.id = checkinJSON["id"].string
        self.name = checkinJSON["name"].string
        self.longitude = NSString(string: checkinJSON["longitude"].stringValue).doubleValue
        self.latitude = NSString(string: checkinJSON["latitude"].stringValue).doubleValue
        self.checkins = checkinJSON["checkins"].string?.toInt()
        self.checkinsUpcount = checkinJSON["checkins_upcount"].string?.toInt()
        self.startDate = checkinJSON["startdate"].string
        if let id = self.id {
            self.thumbnailURL = NSURL(string: "https://graph.facebook.com/v2.4/\(id)/picture/?type=large")
        }
    }
}

enum FBCheckinPeriod: String {
    case Week = "week"
    case Month = "month"
}
enum FBCheckinSortType: String {
    case Total = "total"
    case UpCount = "upcount"
}