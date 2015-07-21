//
//  FBFanpage.swift
//  hotviewer
//
//  Created by 傑瑞 on 2015/7/21.
//  Copyright (c) 2015年 傑瑞. All rights reserved.
//

import Foundation

enum FBFanpageSort: String {
    case ID = "id"
    case Name = "name"
    case Fans = "fans"
    case PTA = "pta"
}

class FBFanpage {
    var id: String?
    var name: String?
    var url: NSURL?
    var fanCount: String?
    var talkingCount: String?
    var about: String?
    init(fanpageJSON: JSON) {
        /*
            id：粉絲頁ID
            name：粉絲頁名稱
            link：粉絲頁網址
            category：粉絲頁分類
            fan_count：粉絲數
            talking_about_count：討論數
            mission：粉絲頁目的
            about：關於粉絲頁
            description：粉絲頁內文描述
            founded：粉絲頁成立時間
            website：連結網址
            picture：粉絲頁圖片網址
        */
        self.id = fanpageJSON["id"].string
        self.name = fanpageJSON["name"].string
        self.url = NSURL(string: fanpageJSON["link"].stringValue)
        self.fanCount = fanpageJSON["fan_count"].string
        self.talkingCount = fanpageJSON["talking_about_count"].string
        self.about = fanpageJSON["about"].string
    }
}