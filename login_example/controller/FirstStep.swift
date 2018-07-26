//
//  ViewController.swift
//  login_example
//
//  Created by ahmedxiio on 7/26/18.
//  Copyright © 2018 ahmedxiio. All rights reserved.
//

import UIKit
import GoogleSignIn
//#import <linkedin-sdk/LISDK.h>

class FirstStep: UIViewController {

    @IBOutlet weak var signInButton: GIDSignInButton!
    
    //viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        googleSignIn()
    }
    
    //google SignIn
    func googleSignIn() {
        //adding the delegates
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        //getting the signin button and adding it to view
        let googleSignInButton = GIDSignInButton()
        googleSignInButton.style = .iconOnly
        googleSignInButton.colorScheme = .light
        signInButton.addSubview(googleSignInButton)
        
    }
    
}

//GIDSignInUIDelegate
extension FirstStep:GIDSignInUIDelegate, GIDSignInDelegate {
    
    //when the signin complets
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
                if let error = error {
                    print("\(error.localizedDescription)")
                } else {
                    // Perform any operations on signed in user here.
                    let userId = user.userID                  // For client-side use only!
//                    let idToken = user.authentication.idToken // Safe to send to the server
                    let fullName = user.profile.name
                    let givenName = user.profile.givenName
                    let familyName = user.profile.familyName
                    let email = user.profile.email
                    
                    let userINFO = "\(String(describing: userId!))\r\n\(String(describing: fullName!))\r\n\r\n\(String(describing: givenName!))\r\n\(String(describing: familyName!))\r\n\(String(describing: email!))"
                    
                    performSegue(withIdentifier: "GoogleVC", sender: userINFO)

                }
        

    }
    
    //
        func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
                  withError error: Error!) {
            // Perform any operations when the user disconnects from app here.
            // ...
        }
}

// prepare Segue
extension FirstStep {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "GoogleVC" {
            if let vc = segue.destination as? GoogleVC {
                vc.type = sender as? String
            }
        }
    }
}
