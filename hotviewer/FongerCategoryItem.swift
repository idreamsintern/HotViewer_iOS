//
//  FongerCategoryItem.swift
//  hotviewer
//
//  Created by 傑瑞 on 2015/7/20.
//  Copyright (c) 2015年 傑瑞. All rights reserved.
//

import Foundation

struct FongerCategoryItem {
    var text: String
    var imageNamed: String
    var tag: String = ""
    var selected: Bool = false
    
    init(text: String, imageNamed: String) {
        self.text = text
        self.imageNamed = imageNamed
    }
    
    init(text: String, imageNamed: String, tag: String) {
        self.text = text
        self.imageNamed = imageNamed
        self.tag = tag
    }
    
    init(text: String, imageNamed: String, selected: Bool) {
        self.text = text
        self.imageNamed = imageNamed
        self.selected = selected
    }
}