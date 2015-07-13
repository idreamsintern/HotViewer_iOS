//
//  ImageFromURL.swift
//  hotviewer
//
//  Created by 傑瑞 on 2015/7/14.
//  Copyright (c) 2015年 傑瑞. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    public func imageFromUrl(urlString: String) {
        if let url = NSURL(string: urlString) {
            println(urlString)
            let request = NSURLRequest(URL: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in

                self.image = UIImage(data: data!)
            }
        }
    }
}
