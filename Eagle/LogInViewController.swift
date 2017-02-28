//
//  LogInViewController.swift
//  Eagle
//
//  Created by Kyle Leung on 2/26/17.
//  Copyright © 2017 Kyle Leung. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LogInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onLoginButton(_ sender: Any) {
        let client = twitterClient.sharedInstance
        client?.login(success: { 
            print("I logged in")
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }, failure: { (error: Error?) in
            print("Error: \(error?.localizedDescription)")
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
