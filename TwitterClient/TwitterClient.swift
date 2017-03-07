//
//  TwitterClient.swift
//  TwitterClient
//
//  Created by Kyle Leung on 2/27/17.
//  Copyright © 2017 Kyle Leung. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {

    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com") as URL!, consumerKey: 	"siLWPfCehEcAK90HjlWLIJAiD", consumerSecret: "z5OrWJYjznDjAyXFakwdnc8Ts44IvbbwAsVY2YSMEGfLg4zGNv")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    
    
    func homeTimeLine(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> () ) {
        // Get tweets on home timeline
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            
            
            success(tweets)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("error: \(error.localizedDescription)")
            failure(error)
        })

    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            print("account: \(response)")
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("error: \(error.localizedDescription)")
            failure(error)
        })
    }
    
    func favorite(id: String, success: @escaping (String) -> (), failure: @escaping (Error) -> ()){
        post("1.1/favorites/create.json?id=\(id)", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionary = response as? NSDictionary
            let count = "\(dictionary!["favorite_count"] ?? 0)"
            success(count)
        }) { (task: URLSessionDataTask?, error: Error) in
            print("error: \(error.localizedDescription)")
            failure(error)
        }
    }
    
    func retweet(id: String, success: @escaping (String) -> (), failure: @escaping (Error) -> ()){
        post("1.1/statuses/retweet/\(id).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let dictionary = response as? NSDictionary
            
            let count = "\(dictionary!["retweet_count"]!)"
            
            success(count)
        }) { (task: URLSessionDataTask?, error: Error) in
            print("error: \(error.localizedDescription)")
            failure(error)
        }
    }
    

    func tweet(status: String, success: @escaping (String) -> (), failure: @escaping (Error) -> ()){
        var tweetText = status.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        post("1.1/statuses/update.json?status=\(tweetText))", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            
            success("Done")
        }) { (task: URLSessionDataTask?, error: Error) in
            print("error: \(error.localizedDescription)")
            failure(error)
        }
    }
    
    
    func login(success: @escaping ()->(), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance? .fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitterClient://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\((requestToken?.token)!)")!
            UIApplication.shared.open(url as URL, options: [:], completionHandler: { (Bool) in
                // do nothing
            })
            
        }, failure: { (error: Error?) in
            print(error!.localizedDescription)
            self.loginFailure?(error!)
        })
    }

    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (requestToken: BDBOAuth1Credential?) in
            print("got access token")
            self.currentAccount(success: { (user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
            }, failure:
                { (error:Error) -> () in
                    self.loginFailure?(error)
            })
            
            self.loginSuccess?()
            
        }, failure: { (error: Error?) in
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        })
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil, userInfo: [:])
        
    }

}
