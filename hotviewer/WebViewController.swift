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
    
    override func viewWillAppear(animated: Bool) {
        if let url = self.url {
            let request = NSURLRequest(URL: url)
            webView.loadRequest(request)
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