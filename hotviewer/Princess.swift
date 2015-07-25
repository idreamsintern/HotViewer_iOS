//123123
//  Princess.swift
//  hotviewer
//

import Foundation
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

let firebase = Firebase(url: "https://toolman.firebaseio.com/princess")
class Princess {
    var userId: String!
    var requestMessage: String?
    var toolmen = [ToolMan]()
    var thumbnailURL: NSURL?
    
    init(userId: String, toolManUpdate: (() -> ())) {
        self.userId = userId

        firebase.childByAppendingPath(userId + "/toolman").observeEventType(.ChildAdded, withBlock: { snapshot in
            self.toolmen.append(ToolMan(userId: snapshot.key))
            
            toolManUpdate()
            
            }, withCancelBlock: { error in
                println(error.description)
        })

    }
    init(userId: String, requestMessage: String) {
        self.userId = userId
        self.requestMessage = requestMessage
        self.thumbnailURL = NSURL(string: "https://graph.facebook.com/v2.4/\(userId)/picture?type=large")
    }
    func updateRequestMessage(message: String) {
        firebase.childByAppendingPath(userId).setValue(["request": message])
    }
    
/*
    myRootRef.observeEventType(.Value, withBlock: {
    snapshot in
    println("\(snapshot.key) -> \(snapshot.value)")
    })
*/

}