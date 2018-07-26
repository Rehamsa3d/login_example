//
//  linkedinVC.swift
//  login_example
//
//  Created by ahmedxiio on 7/26/18.
//  Copyright © 2018 ahmedxiio. All rights reserved.
//

import UIKit

class LinkedinVC: UIViewController {

    //Mark : properities
    
    @IBOutlet weak var webView: UIWebView!
    
    
    let linkedInKey = "86lumo1mbw18oj"
    let linkedInSecret = "cs9xt7Wr2SwqUJGh"
    let authorizationEndPoint = "https://www.linkedin.com/uas/oauth2/authorization"
    let accessTokenEndPoint = "https://www.linkedin.com/uas/oauth2/accessToken"
    
    // Specify the response type which should always be "code".
    let responseType = "code"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startAuthorization()
        
    }
//    override func viewWillAppear(_ animated: Bool) {
//        checkForExistingAccessToken()
//    }
    
//    func checkForExistingAccessToken() {
//        if UserDefaults.standard.object(forKey: "LIAccessToken") != nil {
////           startAuthorization()
//        }
//    }

    
    func startAuthorization(){
        
        // Specify the response type which should always be "code".
        let responseType = "code"
        
        // Set the redirect URL which you have specify at time of creating application in LinkedIn Developer’s website. Adding the percent escape characthers is necessary.
        let redirectURL = "https://com.test.linkedin/oauth”.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.alphanumericCharacterSet())!"
        
        // Create a random string based on the time interval (it will be in the form linkedin12345679).
        let state = "linkedin\(Int(NSDate().timeIntervalSince1970))"
        
        // Set preferred scope.
        let scope = "r_basicprofile, r_emailaddress"
        
        // Create the authorization URL string.
        var authorizationURL = "\(authorizationEndPoint)?"
        authorizationURL += "response_type=\(responseType)&amp;"
        authorizationURL += "client_id=\(linkedInKey)&amp;"
        authorizationURL += "redirect_uri=\(redirectURL)&amp;"
        authorizationURL += "state=\(state)&amp;"
        authorizationURL += "scope=\(scope)"
        print(authorizationURL)
        
        // Create a URL request and load it in the web view.
//        let request = NSURLRequest(URL: NSURL(string: authorizationURL)!)
        let request = NSURLRequest(url: NSURL(string: authorizationURL)! as URL)
        webView.loadRequest(request as URLRequest)
    }

    func requestForAccessToken(authorizationCode: String){
        
        let grantType = "authorization_code"

        let redirectURL = "https://com.appcoda.linkedin.oauth/oauth".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.alphanumerics)!
        // Set the POST parameters.
        var postParams = "grant_type=\(grantType)&amp;"
        postParams += "code=\(authorizationCode)&amp;"
        postParams += "redirect_uri=\(redirectURL)&amp;"
        postParams += "client_id=\(linkedInKey)&amp;"
        postParams += "client_secret=\(linkedInSecret)"
        
        // Convert the POST parameters into a NSData object.
        let postData = postParams.data(using: String.Encoding.utf8)
        
        // Initialize a mutable URL request object using the access token endpoint URL string.
        let request = NSMutableURLRequest(url: NSURL(string: accessTokenEndPoint)! as URL)
        
        // Indicate that we’re about to make a POST request.
        request.httpMethod = "POST"
        
        // Set the HTTP body using the postData object created above.
        request.httpBody = postData
        
        // Add the required HTTP header field.
        request.addValue("application/x-www-form-urlencoded;", forHTTPHeaderField: "Content-Type")
        
        // Initialize a NSURLSession object.
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        // Make the request.
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            // Get the HTTP status code of the request.
            let statusCode = (response as! HTTPURLResponse).statusCode
            
            if statusCode == 200 {
                // Convert the received JSON data into a dictionary.
                do {
                    let dataDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
//                    let accessToken = dataDictionary
                    
                    UserDefaults.standard.set(dataDictionary, forKey: "LIAccessToken")
                    UserDefaults.standard.synchronize()
                    
//                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                        self.dismiss(animated: true, completion: nil)
//                    })
                }
                catch {
                    print("Could not convert JSON data into a dictionary.")
                }
            }
        }
        
        task.resume()
    }
    

        
    }


