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
    
    
    /*************Self Created Var*************/
//    let loginManager = FBSDKLoginManager()
    var fbData = [String: AnyObject]()
    var twiData = [String: AnyObject]()
    var lnData = [String: AnyObject]()
    var gData = [String: AnyObject]()
    var image: String?
    var name: String?
    var email: String?
    
    /*************LinkedIN*************/
    
    
    //viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        googleDelegates()
    }
    

    @IBAction func googleBtnTaped(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()

    }
    
    @IBAction func linkedinBtnTaped(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()

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
            
            performSegue(withIdentifier: "DetailVC", sender: userINFO)
            
        }
        
        
    }
}


//linkedin signin extension

extension FirstStep{
    //linkedin signin func
    func linkedinSI()  {
        let linkedinHelper = LinkedinSwiftHelper(configuration: LinkedinSwiftConfiguration(clientId: "86lumo1mbw18oj", clientSecret: "cs9xt7Wr2SwqUJGh", state: "linkedin\(Int(Date().timeIntervalSince1970))", permissions: ["r_basicprofile", "r_emailaddress"], redirectUrl: "https://devlives.com"))

        linkedinHelper.authorizeSuccess({(lsToken) -> Void in
            
            print("Login success lsToken: \(lsToken)")
            
            linkedinHelper.requestURL("https://api.linkedin.com/v1/people/~:(id,first-name,last-name,email-address,picture-url,picture-urls::(original),positions,date-of-birth,phone-numbers,location)?format=json", requestType: LinkedinSwiftRequestGet, success: { (response) -> Void in
                
                print("Request success with response: \(response)")
                let a = response.jsonObject
                //                    jsonObject: [AnyHashable : Any]
                //                    let data = response["LSResponse - data"]
                
                self.lnData.updateValue(a?["emailAddress"] as AnyObject, forKey: "email")
                let name = "\(a?["firstName"] as AnyObject) \(a?["lastName"] as AnyObject)"
                self.lnData.updateValue(name as AnyObject, forKey: "name")
                self.lnData.updateValue(a?["pictureUrl"] as AnyObject, forKey: "image")
                print(self.lnData)
                self.performSegue(withIdentifier: "DetailVC", sender: name)
                
            }) {(error) -> Void in
                
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
        
        if segue.identifier == "DetailVC" {
            if let vc = segue.destination as? DetailVC {
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
