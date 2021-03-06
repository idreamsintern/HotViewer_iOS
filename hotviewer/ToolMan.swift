//
//  Toolman.swift
//  hotviewer
//
//  Created by  Hsu Ching Feng on 7/25/15.
//  Copyright (c) 2015 傑瑞. All rights reserved.
//

import Foundation

class ToolMan {
    var userId: String
    var princesses = [Princess]()
    var thumbnailURL: NSURL?
    
    init(userId: String) {
        self.userId = userId
        self.thumbnailURL = NSURL(string: "https://graph.facebook.com/v2.4/\(userId)/picture?width=600&height=600")
    }
    init(userId: String, princessUpdate: () -> ()) {
        self.userId = userId
        firebase.observeEventType(.ChildAdded, withBlock: { snapshot in
            let msg = snapshot.value["request"] as? String ?? "對方無提供資料"
            var princess = Princess(userId: snapshot.key, requestMessage: msg)
            
            self.princesses.append(princess)

            princessUpdate()

            }, withCancelBlock: { error in
                println(error.description)
        })

        firebase.observeEventType(.ChildRemoved, withBlock: { snapshot in
            let princessId: String = snapshot.key
            var princessIndex: Int!;
            
            for var i = 0; i < self.princesses.count; i++ {
                if self.princesses[i].userId == princessId {
                    princessIndex = i
                    break
                }
            }
            
            if princessIndex != nil {
                self.princesses.removeAtIndex(princessIndex)
                princessUpdate()
            }
            
            }, withCancelBlock: { error in
                println(error.description)
        })
    }
    
}