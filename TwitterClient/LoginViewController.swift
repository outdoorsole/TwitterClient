//
//  LoginViewController.swift
//  TwitterClient
//
//  Created by Maribel Montejano on 4/1/19.
//  Copyright © 2019 Maribel Montejano. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onLoginButton(_ sender: UIButton) {
        let myURL = "https://api.twitter.com/oauth/request_token"
        
        // singleton Twitter Client
        TwitterAPICaller.client?.login(url: myURL, success: {
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }, failure: { (Error) in
            print("Could not log in!")
        })
    }
}
