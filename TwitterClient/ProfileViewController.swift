//
//  ProfileViewController.swift
//  Eagle
//
//  Created by Kyle Leung on 3/6/17.
//  Copyright © 2017 Kyle Leung. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    var tweet: Tweet!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var numTweets: UILabel!
    @IBOutlet weak var numFollowing: UILabel!
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var numFollowers: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        profilePic.setImageWith(tweet!.profileUrl!)
        numTweets.text = "\(tweet.retweetCount)"
        numFollowers.text = "\(tweet.followersCount)"
        numFollowing.text = "\(tweet.followingCount)"
        username.text = "\(tweet.username!)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func goHome(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
