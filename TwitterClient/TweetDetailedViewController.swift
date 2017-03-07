//
//  TweetDetailedViewController.swift
//  Eagle
//
//  Created by Kyle Leung on 2/28/17.
//  Copyright © 2017 Kyle Leung. All rights reserved.
//

import UIKit

class TweetDetailedViewController: UIViewController {
   
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var handle: UILabel!
    @IBOutlet weak var detailedText: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var faveCount: UILabel!
    
    var tweet: Tweet!
    override func viewDidLoad() {
        super.viewDidLoad()

        name.text = tweet.username
        handle.text = tweet.handle
        detailedText.text = tweet.text
        retweetCount.text = "\(tweet.retweetCount)"
        faveCount.text = "\(tweet.favorites_count)"
        profilePic.setImageWith((tweet!.profileUrl!))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    @IBAction func favorite(_ sender: Any) {
        TwitterClient.sharedInstance?.favorite(id: tweet.id!, success: { (count: String) in
            self.faveCount.text = "\(count)"
            self.faveCount.setNeedsDisplay()
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
