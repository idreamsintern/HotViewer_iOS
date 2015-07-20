//
//  PTTArticle.swift
//  hotviewer
//
//  Created by 傑瑞 on 2015/7/20.
//  Copyright (c) 2015年 傑瑞. All rights reserved.
//

import Foundation

class PTTArticle {
    var url: NSURL?
    var title: String?
    var board: String?
    var push: String?
    var time: String?
    init(pttJSON: JSON) {
        self.url = NSURL(string: pttJSON["url"].stringValue)
        self.title = pttJSON["title"].string
        self.board = pttJSON["board"].string
        self.push = pttJSON["push"].string
        self.time = pttJSON["time"].string
    }
}