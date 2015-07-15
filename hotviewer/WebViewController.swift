//
//  WebViewController.swift
//  hotviewer
//
//  Created by 傑瑞 on 2015/7/15.
//  Copyright (c) 2015年 傑瑞. All rights reserved.
//

import Foundation
import UIKit

class WebViewController : UIViewController {
    @IBOutlet weak var webView: UIWebView!
    var url: String?
    
    override func viewWillAppear(animated: Bool) {
        if let url = NSURL(string: url!) {
            let request = NSURLRequest(URL: url)
            webView.loadRequest(request)
        }
    }
}