//
//  ViewController.swift
//  Twipper2
//
//  Created by Shain Lafazan on 6/15/15.
//  Copyright (c) 2015 Shain Lafazan. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UITableViewController {

    var tweets = [
        Tweet(tweetText: "tweet one", userName: "userOne", createdAt: "Wed May 06", pictureURL: NSURL(string:"http://lorempixel.com/200/200/")),
        Tweet(tweetText: "tweet two", userName: "userTwo", createdAt: "Wed May 06", pictureURL: NSURL(string: "http://lorempixel.com/201/201/")),
        Tweet(tweetText: "tweet three", userName: "userTwo", createdAt: "Wed May 06", pictureURL: NSURL(string: "http://lorempixel.com/202/202/")),
        Tweet(tweetText: "tweet four", userName: "userThree", createdAt: "Wed May 06", pictureURL: NSURL(string: "http://lorempixel.com/203/203/"))
    ]
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let dequeued: AnyObject = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath)
        
        let cell = dequeued as! TweetCell
        let tweet = tweets[indexPath.row]
        
        cell.tweetTextLabel.text = tweet.tweetText
        cell.userNameLabel.text = tweet.userName
        cell.createdAtLabel.text = tweet.createdAt
        
        if tweet.pictureURL != nil {
            if let imageData = NSData(contentsOfURL: tweet.pictureURL!) {
                cell.pictureImageView.image = UIImage(data: imageData)
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Display customization
    

}