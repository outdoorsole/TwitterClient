//
//  TwitterAPICaller.swift
//  TwitterClient
//
//  Created by CodePath (Dan Ndombe and Tim Lee)
//  Modified by Maribel Montejano on 4/1/19.
//  Copyright © 2019 Maribel Montejano. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterAPICaller: BDBOAuth1SessionManager {
    // singleton
    // Initialize a new BDBOAuth1SessionManager instance with the given baseURL, consumer key, and consumer secret.
    static let client = TwitterAPICaller(baseURL: URL(string: "https://api.twitter.com"), consumerKey: consumerKey, consumerSecret: consumerSecret)
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func handleOpenUrl(url: URL) {
        // request token comes from url
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        TwitterAPICaller.client?.fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) in
            print("Got the access token")
            self.loginSuccess?()
        }, failure: { (error: Error!) in
            print("Error receiving token")
            self.loginFailure?(error)
        })
    }
    
    func login(url: String, success: @escaping () -> (), failure: @escaping (Error) -> ()){
        loginSuccess = success
        loginFailure = failure
        
        // Remove the access token from the keychain before initiating the process again (in case the token is cached)
        TwitterAPICaller.client?.deauthorize()
        
        // 1) Get the request token
        // Request token gives permission to send the user to the authentication page
        TwitterAPICaller.client?.fetchRequestToken(withPath: url, method: "GET", callbackURL: URL(string: "alamoTwitter://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) in
            // authentication URL, with request OAuth token added (authorization to send user to URL)
            print("Got the request token")
            
            // Build the authentication URL, send in oauth request token
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token!)")!
            // open the URL (mobile Safari page)
            UIApplication.shared.open(url)
        }, failure: { (error: Error!) in
            print("Error: \(error.localizedDescription)")
        })
    }
}
