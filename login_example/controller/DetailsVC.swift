//
//  GoogleVC.swift
//  login_example
//
//  Created by ahmedxiio on 7/26/18.
//  Copyright © 2018 ahmedxiio. All rights reserved.
//

//655850931174-k9cd5otbep2jp8kaq25ruesg89kqlt8c.apps.googleusercontent.com

import UIKit
import GoogleSignIn

class DetailsVC: UIViewController {

    var type: String?

    @IBOutlet weak var userInfo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userInfo.text = type!
    }
    
    @IBAction func didTapSignOut(_ sender: AnyObject) {
       signOut()
    }

    //signOut
    func signOut() {
        let FirstStep = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstStep") as! FirstStep
        present(FirstStep, animated: true) {
            GIDSignIn.sharedInstance().signOut()
            
        }
    }

}
