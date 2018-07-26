//
//  ViewController.swift
//  login_example
//
//  Created by ahmedxiio on 7/26/18.
//  Copyright © 2018 ahmedxiio. All rights reserved.
//

import UIKit
import GoogleSignIn
import LinkedinSwift
class FirstStep: UIViewController {
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    
    //viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        googleSignIn()
    }
    
    @IBAction func linkedinBtnTaped(_ sender: Any) {
        linkedinSI()
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
    
    //linkedin signin func
    func linkedinSI()  {
        // You still need to set appId and URLScheme in Info.plist, follow this instruction: https://developer.linkedin.com/docs/ios-sdk
        let linkedinHelper = LinkedinSwiftHelper(configuration: LinkedinSwiftConfiguration(clientId: "86lumo1mbw18oj", clientSecret: "iqkDGYpWdhf7WKzA", state: "DLKDJF46ikMMZADfdfds", permissions: ["r_basicprofile", "r_emailaddress"], redirectUrl: "https://github.com"))
        linkedinHelper.authorizeSuccess({ (token) in
            
            print(token)
            //This token is useful for fetching profile info from LinkedIn server
        }, error: { (error) in
            
            print(error.localizedDescription)
            //show respective error
        }) {
            //show sign in cancelled event
        }
        
        //requestURL
        linkedinHelper.requestURL("https://api.linkedin.com/v1/people/~:(id,first-name,last-name,email-address,picture-url,picture-urls::(original),positions,date-of-birth,phone-numbers,location)?format=json", requestType: LinkedinSwiftRequestGet, success: { (response) -> Void in
            
            print(response)
            //parse this response which is in the JSON format
        }) {(error) -> Void in
            
            print(error.localizedDescription)
            //handle the error
        }
        
    }
}

//GIDSignInUIDelegate      //google SignIn

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
