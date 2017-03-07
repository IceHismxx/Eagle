//
//  TweetCell.swift
//  Eagle
//
//  Created by Kyle Leung on 2/27/17.
//  Copyright © 2017 Kyle Leung. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    @IBOutlet weak var profilePic: UIImageView!

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var favCount: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var screenname: UILabel!
    var tweet: Tweet! {
        didSet {
            tweetText.text = tweet.text!
            username.text = tweet.username!
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d H:mm a"
            let formattedTimeStamp = formatter.string(from: tweet.timestamp!)
            time.text = formattedTimeStamp
            profilePic.setImageWith((tweet!.profileUrl!))
            favCount.text = "\(tweet.favorites_count)"
            retweetCount.text = "\(tweet.retweetCount)"
            screenname.text = "\((tweet.handle)!)"
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func fav(_ sender: Any) {
        TwitterClient.sharedInstance?.favorite(id: tweet.id!, success: { (count: String) in
            self.favCount.text = "\(count)"
            self.favCount.setNeedsDisplay()
        }, failure: { (error: Error) in
            print(error.localizedDescription)
            
        })
    }
    
    @IBAction func retweet(_ sender: Any) {
        TwitterClient.sharedInstance?.retweet(id: tweet.id!, success: { (count: String) in
            self.retweetCount.text = "\(count)"
            self.retweetCount.setNeedsDisplay()
        }, failure: { (error: Error) in
            print(error.localizedDescription)
            
        })
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
