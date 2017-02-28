//
//  twitterClient.swift
//  Eagle
//
//  Created by Kyle Leung on 2/26/17.
//  Copyright © 2017 Kyle Leung. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class twitterClient: BDBOAuth1SessionManager {
    static let oAuthBaseUrl = "https://api.twitter.com"
    static let sendTweetEndPoint = twitterClient.oAuthBaseUrl + "/1.1/statuses/update.json?status="
    static let retweetEndpoint = twitterClient.oAuthBaseUrl + "/1.1/statuses/retweet/"
    static let favoriteEndpoint = "https://api.twitter.com/1.1/favorites/create.json?id="
    static let userTimelineEndpoint = "https://api.twitter.com/1.1/statuses/user_timeline.json"
    static let sharedInstance = twitterClient(baseURL: NSURL(string: "https://api.twitter.com")! as URL!, consumerKey: "siLWPfCehEcAK90HjlWLIJAiD", consumerSecret: "z5OrWJYjznDjAyXFakwdnc8Ts44IvbbwAsVY2YSMEGfLg4zGNv")
    func userCredential(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let userDict = response as! NSDictionary
            let user = User(dictionary: userDict)
            success(user)
            print("User: \(userDict)")
            print("Name: \(user.name!)")
            print("Screen Name: \(user.screenname!)")
            print("profile URL: \(user.profileURL!)")
            print("Description: \(user.userDescription!)")
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })

    }
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> () ) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            success(tweets)

        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })

    }
    var loginSuccess: (() -> ())?
    
    var loginFailure: ((Error) -> ())?
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        self.loginSuccess = success
        self.loginFailure = failure
        deauthorize()
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: NSURL(string: "eagle://oauth") as URL! , scope: nil, success: { (requestToken: BDBOAuth1Credential?) -> Void in
            print("Got request token")
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\((requestToken?.token)!)")
            UIApplication.shared.open(url as! URL, options: [:], completionHandler: nil)
        }, failure: { (error: Error?) -> Void in
            print("Error: \(error?.localizedDescription)" )
            self.loginFailure?((error)!)
        })

    }
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidLogout"), object: nil)
    }
    class func favorite(id: String, success: @escaping () -> (), failure: @escaping (Error) -> () ){
        let favoriteEndPoint = self.favoriteEndpoint  + id
        twitterClient.sharedInstance?.post(favoriteEndPoint, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response:Any?) in
            success()
            print("favorite success")
        }, failure: { (task: URLSessionDataTask?, error:Error) in
            failure(error)
        })
    }
    class func retweet(id: String, callBack: @escaping (_ response: Tweet?, _ error: Error?) -> Void){
        let retweetEndpoint = self.retweetEndpoint + id + ".json"
        twitterClient.sharedInstance?.post(retweetEndpoint, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            if let tweetDict = response as? [String: Any]{
                var tweet: Tweet?
                if let originalTweetDict = tweetDict["retweeted_status"] as? [String: Any]{
                    tweet = Tweet(dictionary: originalTweetDict as NSDictionary)
                }
                
                callBack(tweet, nil)
            } else {
                callBack(nil, nil)
            }
            
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print(error.localizedDescription)
            callBack(nil, error)
            
        })
    }
    
    func handleOpenURL (url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) -> Void in
            self.loginSuccess?()
            
        }, failure: { (error: Error?) -> Void in
            self.loginFailure?(error!)
            print("Error: \(error?.localizedDescription)")
        })

    }
    
}
