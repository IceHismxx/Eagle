//
//  TweetTableViewCell.swift
//  Eagle
//
//  Created by Kyle Leung on 2/27/17.
//  Copyright © 2017 Kyle Leung. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var screenname: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoriteCount: UILabel!
    @IBOutlet weak var replyCount: UILabel!
    var retweets: Int?
    var favorites: Int?
    var hasRetweeted = false
    var hasFavorited = false
    var tweetID: String?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        pictureView.layer.cornerRadius = 4
        pictureView.clipsToBounds  = true
        
        name.preferredMaxLayoutWidth = name.frame.size.width
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        name.preferredMaxLayoutWidth = name.frame.size.width
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func onFavoriteButton(_ sender: Any) {
        if(hasFavorited == false){
            twitterClient.favorite(id: (self.tweetID)!, success: {
                let favoriteImage = UIImage(named: "favor-icon-red")
                self.favoriteButton.setImage(favoriteImage, for: UIControlState.normal)
                let increment = Int(self.favoriteCount.text!)
                self.favoriteCount.text = "\(increment! + 1)"
                self.hasFavorited = true
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
            
        }
        
    }
    
    @IBAction func onRetweetButton(_ sender: Any) {
        if(hasRetweeted == false){
            twitterClient.retweet(id: (self.tweetID)!, callBack: { (tweet, error) in
            })
            let retweetImage = UIImage(named: "retweet-icon-green")
            retweetButton.setImage(retweetImage, for: UIControlState.normal)
            let increment = Int(retweetCount.text!)
            self.retweetCount.text = "\(increment! + 1)"
            self.hasRetweeted = true
            
        }
    }


}
