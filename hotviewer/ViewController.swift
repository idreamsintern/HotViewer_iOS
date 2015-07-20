//
//  ViewController.swift
//  Facebook-Login
//
//  Created by PJ Vea on 6/11/15.
//  Copyright (c) 2015 Vea Software. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if (FBSDKAccessToken.currentAccessToken() == nil)
        {
            println("Not logged in...")
        }
        else
        {
            println("Logged in...")
        }
        
        var loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.center = self.view.center
        loginButton.delegate = self
        self.view.addSubview(loginButton)
        
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
            let tab = self.storyboard?.instantiateViewControllerWithIdentifier("tabController") as! UITabBarController
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

