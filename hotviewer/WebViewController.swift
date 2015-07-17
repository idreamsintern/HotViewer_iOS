//
//  WebViewController.swift
//  hotviewer
//
//  Created by 傑瑞 on 2015/7/15.
//  Copyright (c) 2015年 傑瑞. All rights reserved.
//

import Foundation
import UIKit
import Social

class WebViewController : UIViewController {
    @IBOutlet weak var webView: UIWebView!
    var url: NSURL?
    var rawContent: String?
    
    override func viewWillAppear(animated: Bool) {
        if var rawContent = self.rawContent {
            // Hide the tag list and prettify hyper link
            rawContent += "<style>.lucy-detail p:nth-child(2){display:none;}img{width:100%}a{color:#337ab7;text-decoration:none}a:focus,a:hover{color:#23527c;text-decoration:underline}a:focus{outline:dotted thin;outline:-webkit-focus-ring-color auto 5px;outline-offset:-2px}</style>"
            webView.loadHTMLString(rawContent, baseURL: nil)
        }
        var shareBtn : UIBarButtonItem = UIBarButtonItem(title: "分享", style: UIBarButtonItemStyle.Plain, target: self, action: "shareClick:")
        self.navigationItem.rightBarButtonItem = shareBtn
    }
    func shareClick(sender: UIBarButtonItem) {
        if let webSite = self.url
        {
            let objectsToShare = [webSite]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
    }
}