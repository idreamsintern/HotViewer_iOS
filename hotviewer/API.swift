//
//  SERAPI.swift
//  hotviewer
//
//  Created by 傑瑞 on 2015/7/13.
//  Copyright (c) 2015年 傑瑞. All rights reserved.
//

import Foundation
typealias ServiceResponse = (JSON, NSError?) -> Void

class API {
    private var baseUrl: String
    private var tokenUrl: String
    private var tokenParams: [String:String?]
    private var token: String = "api_doc_token"
    private var tokenExpireDate: NSDate?
    
    init(apiUrl: String, tokenUrl: String, tokenParams: [String:String?]) {
        self.baseUrl = apiUrl
        self.tokenUrl = tokenUrl
        self.tokenParams = tokenParams
    }
    func ensureValidToken(onCompleted: () -> ()) {
        // Check if the token had expired with current time
        // to prevent time shift between server and client,
        // we substract current time by 3 minutes (180 seconds)
        if tokenExpireDate == nil || tokenExpireDate?.compare(NSDate().dateByAddingTimeInterval(-180)) != NSComparisonResult.OrderedDescending {
            self.post(tokenParams, url: tokenUrl) { (succeeded, msg, result) -> () in
                if let token = result["token"].string {
                    self.token = token
                    println("Token updated: \(token) for \(self.baseUrl)")
                } else {
                    println("Fail to get token: \(msg) for \(self.baseUrl)")
                }
                
                if let expireDateString = result["token_expire"].string {
                    let dateStringFormatter = NSDateFormatter()
                    dateStringFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
                    self.tokenExpireDate = dateStringFormatter.dateFromString(expireDateString)
                }
                
                onCompleted()
            }
        } else {
            onCompleted()
        }
    }
    func post(params : [String : String?], url : String, postCompleted : (succeeded: Bool, msg: String, result: JSON) -> ()) {
        var request = NSMutableURLRequest(URL: NSURL(string: self.baseUrl + url)!)        
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        request.setAPIBodyContent(params, token: self.token)
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            var msg = "No message"
            
            if let err = error {
                println("Error during request DATA: '\(err.localizedDescription)'")
                postCompleted(succeeded: false, msg: err.localizedDescription, result: nil)
            } else {
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


