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
    private var toolmanPath: String!
    init(userId: String, toolManUpdate: (() -> ())) {
        self.userId = userId
        self.toolmanPath = userId + "/toolman"
        firebase.childByAppendingPath(toolmanPath).observeEventType(.ChildAdded, withBlock: { snapshot in
            self.toolmen.append(ToolMan(userId: snapshot.key))
            
            toolManUpdate()
            
            }, withCancelBlock: { error in
                println(error.description)
        })

    }
    init(userId: String, requestMessage: String) {
        self.userId = userId
        self.toolmanPath = userId + "/toolman"
        self.requestMessage = requestMessage
        self.thumbnailURL = NSURL(string: "https://graph.facebook.com/v2.4/\(userId)/picture?width=600&height=600")
    }
    func updateRequestMessage(message: String) {
        firebase.childByAppendingPath(userId).setValue(["request": message])
    }
    func addToolMan(toolManId: String) {
        firebase.childByAppendingPath(toolmanPath).childByAppendingPath(toolManId).setValue(false)
    }
    func removeSelf() {
        firebase.childByAppendingPath(self.userId).removeValue()
    }
}