//
//  tweetsViewController.swift
//  Eagle
//
//  Created by Kyle Leung on 2/26/17.
//  Copyright © 2017 Kyle Leung. All rights reserved.
//

import UIKit

class tweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var thisTable: UITableView!
    var tweets: [Tweet]!
    override func viewDidLoad() {
        super.viewDidLoad()
        thisTable.delegate = self
        thisTable.dataSource = self
        twitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.thisTable.reloadData()
            
        }, failure: { (error: (Error) )  in
            print("Error: \(error.localizedDescription)")
        })
        thisTable.rowHeight = UITableViewAutomaticDimension
        thisTable.estimatedRowHeight = 140
        // Do any additional setup after loading the view.
    }

    @IBAction func onLogoutButton(_ sender: Any) {
        twitterClient.sharedInstance?.logout()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets!.count
        }
        else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        //deselect of the gray cell
        tableView.deselectRow(at: indexPath, animated:true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = thisTable.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetTableViewCell
        let tweet = tweets[indexPath.row]
        cell.pictureView.setImageWith((tweet.person?.profileURL)! as URL)
        cell.name.text = tweet.person?.name as String?
        cell.screenname.text = "@\((tweet.person?.screenname)!)"
        cell.tweetText.text = tweet.text as String?
        cell.timeStamp.text = tweet.timestamp?.description
        cell.favoriteCount.text = "\(tweet.favoritesCount)"
        cell.retweetCount.text = "\(tweet.retweetCount)"
        cell.tweetID = tweet.tweetID
        return cell
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
