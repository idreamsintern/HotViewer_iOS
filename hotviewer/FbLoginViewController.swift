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
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
       
        if (FBSDKAccessToken.currentAccessToken() == nil)
        {
            self.view.addSubview(loginButton)
            println("Not logged in...")
        }
        else
        {
            
            let tab = self.storyboard?.instantiateViewControllerWithIdentifier("tabController") as! UIViewController
            self.presentViewController(tab, animated: true, completion: nil)
            println("Logged in...")
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
            let tab = self.storyboard?.instantiateViewControllerWithIdentifier("tabController") as! UIViewController
            self.presentViewController(tab, animated: true, completion: nil)
            
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
