//
//  SERAPI.swift
//  hotviewer
//
//  Created by 傑瑞 on 2015/7/13.
//  Copyright (c) 2015年 傑瑞. All rights reserved.
//

import Foundation


typealias ServiceResponse = (JSON, NSError?) -> Void

class SERAPI {
    static private let baseUrl = "http://api.ser.ideas.iii.org.tw/api/"
    static func post(params : Dictionary<String, String?>, url : String, postCompleted : (succeeded: Bool, msg: String, result: JSON) -> ()) {
        var request = NSMutableURLRequest(URL: NSURL(string: baseUrl + url)!)

        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        request.setBodyContent(params)
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            var msg = "No message"
            
            if let err = error {
                println("Error during request DATA: '\(err.localizedDescription)'")
                postCompleted(succeeded: false, msg: err.localizedDescription, result: nil)
            }
            else {
                // The JSONObjectWithData constructor didn't return an error. But, we should still
                // check and make sure that json has a value using optional binding.
                let json:JSON = JSON(data: data)

                if let message = json["message"].string {
                    postCompleted(succeeded: message == "success", msg: message, result: json["result"])
                } else {
                    let rawStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error could not parse JSON: \(rawStr)")
                    postCompleted(succeeded: false, msg: "cound not parse JSON", result: nil)
                }
            }
        })
        
        task.resume()
    }
}

