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

var x: Int?


class FirstStep: UIViewController {
    
    
    /*************LinkedIN*************/
    let linkedinHelper = LinkedinSwiftHelper(configuration: LinkedinSwiftConfiguration(clientId: "86lumo1mbw18oj", clientSecret: "iqkDGYpWdhf7WKzA", state: "linkedin\(Int(Date().timeIntervalSince1970))", permissions: ["r_basicprofile", "r_emailaddress"], redirectUrl: "http://localhost:8080/login_example/auth/linkedin"))

    
    //viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        googleDelegates()
    }
    

    @IBAction func googleBtnTaped(_ sender: Any) {
        x = 2
        GIDSignIn.sharedInstance().signIn()

    }
    
    @IBAction func linkedinBtnTaped(_ sender: Any) {
        linkedinSI()
    }
    
    //google googleDelegates
    func googleDelegates() {
        //adding the delegates
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
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
            
            performSegue(withIdentifier: "DetailsVC", sender: userINFO)
            
        }
        
        
    }
}


//linkedin signin extension

extension FirstStep{
    //linkedin signin func
    func linkedinSI()  {
        
        linkedinHelper.authorizeSuccess({(lsToken) -> Void in
            
            print("Login success lsToken: \(lsToken)")
            
            
            self.linkedinHelper.requestURL("https://api.linkedin.com/v1/people/~:(id,first-name,last-name,email-address,picture-url,picture-urls::(original),positions,date-of-birth,phone-numbers,location)?format=json", requestType: LinkedinSwiftRequestGet, success: { (response) -> Void in
                
                print("Request success with response: \(response)")
                
                // Perform any operations on signed in user here.
                let user = response.jsonObject
                
                // let idToken = user.authentication.idToken // Safe to send to the server
                let name = "\(user?["firstName"] as AnyObject) \(user?["lastName"] as AnyObject)"
                let email = "\(user?["emailAddress"] as AnyObject)"
                
                let userINFO = "\(String(describing: name))\r\n\r\n\(String(describing: email))"
                
                self.performSegue(withIdentifier: "DetailsVC", sender: userINFO)
                
            })
            {(error) -> Void in
                
                print("Encounter error: \(error.localizedDescription)")
            }
            
        }, error: {(error) -> Void in
            
            print("Encounter error: \(error.localizedDescription)")
        }, cancel: {() -> Void in
            
            print("User Cancelled")
        })
        
    }
}

// prepare Segue
extension FirstStep {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DetailsVC" {
            if let vc = segue.destination as? DetailsVC {
                vc.type = sender as? String
            }
        }
    }
}


extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error as Any)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }}
