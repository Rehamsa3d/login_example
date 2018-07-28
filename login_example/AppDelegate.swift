//
//  AppDelegate.swift
//  login_example
//
//  Created by ahmedxiio on 7/26/18.
//  Copyright © 2018 ahmedxiio. All rights reserved.
//

import UIKit
import GoogleSignIn
import LinkedinSwift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Initialize sign-in
        GIDSignIn.sharedInstance().clientID = "354462999218-89oi8ajjmb93909qsqce2jk7rbnu7rvn.apps.googleusercontent.com"
        //        GIDSignIn.sharedInstance().delegate = self
        
        return true
    }
    // [START openurl]
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        // Linkedin sdk handle redirect
//        if LinkedinSwiftHelper.shouldHandle(url) {
//            return LinkedinSwiftHelper.application(application, open: url, sourceApplication: nil, annotation: nil)
//        }else{
//        return GIDSignIn.sharedInstance().handle(url,sourceApplication: sourceApplication,annotation: annotation)
//        }
        // Linkedin sdk handle redirect
        
        print(x as Any)
        if LinkedinSwiftHelper.shouldHandle(url) {
            return LinkedinSwiftHelper.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        }
       
        else if x == 2 {
            return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
        }
        
        
        return false
    }
    // [END openurl]
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    
    
}

