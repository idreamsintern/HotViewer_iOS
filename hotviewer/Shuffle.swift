//
//  Shuffle.swift
//  hotviewer
//
//  Created by 傑瑞 on 2015/7/14.
//  Copyright (c) 2015年 傑瑞. All rights reserved.
//

import Foundation

extension Array {
    mutating func shuffle() {
        if count < 2 { return }
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            swap(&self[i], &self[j])
        }
    }
}

