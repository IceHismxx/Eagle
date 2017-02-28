//
//  User.swift
//  Eagle
//
//  Created by Kyle Leung on 2/26/17.
//  Copyright © 2017 Kyle Leung. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String?
    var screenname: String?
    var profileURL: NSURL?
    var userDescription: String?
    var dictionary: NSDictionary?
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        self.name = dictionary["name"] as? String
        self.screenname = dictionary["screen_name"] as? String
        let temp = dictionary["profile_image_url_https"] as? String
        if let profileURL = temp {
            self.profileURL = NSURL(string: temp!) as NSURL?
        }
        self.userDescription = dictionary["description"] as? String
    }
    static var _currentUser: User?
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUserData") as? NSData
                
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData as Data, options: [])
                    _currentUser = User(dictionary: dictionary as! NSDictionary)
                }
            }
            
            return _currentUser
        }
        set(user) {
            let defaults = UserDefaults.standard
            
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.set(nil, forKey: "currentUserData")
            }
            
            defaults.synchronize()
        }
    }

}
