//
//  FbLoginViewController.swift
//  hotviewer
//
//  Created by 傑夫 on 2015/7/18.
//  Copyright (c) 2015年 傑瑞. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

class FbLoginViewController: UIViewController , FBSDKLoginButtonDelegate{
    var loginButton = FBSDKLoginButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.center = self.view.center
        loginButton.delegate = self
        
        FBSDKProfile.enableUpdatesOnAccessTokenChange(true)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onProfileUpdated", name:FBSDKProfileDidChangeNotification, object: nil)
    }
    
    func onProfileUpdated()
    {
        let name = FBSDKProfile.currentProfile().name
        let userId = FBSDKProfile.currentProfile().userID
        let thumbnailURL = NSURL(string: "https://graph.facebook.com/\(userId)/picture")!
        println("userId: " + userId)
        let defaults = NSUserDefaults.standardUserDefaults()
        let firstTime = !defaults.boolForKey("hasViewedWalkthrough")
        let viewCtrl = self.storyboard?.instantiateViewControllerWithIdentifier(firstTime ? "PageViewController" : "tabController") as! UIViewController
        self.presentViewController(viewCtrl, animated: true, completion: {
            SimpleCache.sharedInstance.getImage(thumbnailURL) { image, error in
                if let err = error {
                    println(err)
                } else if let fullImage = image {
                    viewCtrl.view.makeToast(message: "Welcome \(name)", duration: 2, position: HRToastPositionTop, title: "Have a nice day!", image: fullImage)
                }
            }
        })
    }

    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
       
        if (FBSDKAccessToken.currentAccessToken() == nil)
        {
            println("Not logged in...")
            self.view.addSubview(loginButton)
        }
        else
        {
            println("Logged in...")
            self.onProfileUpdated()
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Facebook Login
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
    {
        if error == nil
        {
            println("Login complete.")
            //self.performSegueWithIdentifier("showNew", sender: self)

        }
        else
        {
            println(error.localizedDescription)
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!)
    {
        println("User logged out...")
    }
    

}
