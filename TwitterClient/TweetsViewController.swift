//
//  TweetsViewController.swift
//  Eagle
//
//  Created by Kyle Leung on 2/27/17.
//  Copyright © 2017 Kyle Leung. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var tweets: [Tweet]?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Table View Setup
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 125
        
        // Do any additional setup after loading the view.
        TwitterClient.sharedInstance?.homeTimeLine(success: { (tweets: [Tweet]) -> () in
            self.tweets = tweets
            
            self.tableView.reloadData()
            
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        

    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        User.currentUser = nil
        TwitterClient.sharedInstance?.logout()
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCell
        cell.tweet = tweets![indexPath.row]
        cell.selectionStyle = .none
        return cell 
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toDetail") {
            let cell = sender as! TweetCell
            let indexPath = tableView.indexPath(for: cell)
            let tweet = tweets![(indexPath!.row)]
            
            let detailedViewController = segue.destination as! TweetDetailedViewController
            detailedViewController.tweet = tweet
        }
        else if (segue.identifier == "profile") {
            let cellButton = sender as! UIButton
            let cell = cellButton.superview?.superview as! TweetCell
            let indexPath = tableView.indexPath(for: cell)
            let tweet = tweets![(indexPath!.row)]
            
            let navController = segue.destination as! UINavigationController
            let profileViewController = navController.viewControllers[0] as! ProfileViewController
            profileViewController.tweet = tweet
        }
    }

}
