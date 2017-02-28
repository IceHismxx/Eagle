//
//  Tweet.swift
//  Eagle
//
//  Created by Kyle Leung on 2/26/17.
//  Copyright © 2017 Kyle Leung. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var text: String?
    var timestamp: Date?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var person: User?
    var tweetID: String?
    
    init (dictionary: NSDictionary) {
        self.text = dictionary["text"] as? String
        self.retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        self.favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        let timestampString = dictionary["created_at"] as? String
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            self.timestamp = formatter.date(from: timestampString) as Date?
        }
        self.person = User(dictionary: (dictionary["user"] as? NSDictionary)!)
        self.tweetID = dictionary["id_str"] as? String
        print(tweetID!)

    }
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
}
