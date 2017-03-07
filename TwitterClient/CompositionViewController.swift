//
//  CompositionViewController.swift
//  Eagle
//
//  Created by Kyle Leung on 3/6/17.
//  Copyright © 2017 Kyle Leung. All rights reserved.
//

import UIKit

class CompositionViewController: UIViewController {
    @IBOutlet weak var tweetMessage: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func sendTweet(_ sender: Any) {
        TwitterClient.sharedInstance?.tweet(status: tweetMessage.text, success: { (String) in
            print("tweeted")
            self.dismiss(animated: true, completion: nil)
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
