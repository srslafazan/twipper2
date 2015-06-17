//
//  ViewController.swift
//  Twipper2
//
//  Created by Shain Lafazan on 6/15/15.
//  Copyright (c) 2015 Shain Lafazan. All rights reserved.
//

import UIKit
import Foundation
import Social
import Accounts

class ViewController: UITableViewController {

    var tweets = [Tweet]()
    
    func requestTweets() {
        let accountStore = ACAccountStore()
        let twitterAccountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccountsWithType(twitterAccountType,
            options: nil,
            completion: {
                (granted: Bool, error: NSError!) -> Void in
                if (!granted) {
                    println ("Access to Twitter Account denied")
                } else {
                    println("DBG requestTweets else1:")
                    let twitterAccounts = accountStore.accountsWithAccountType(twitterAccountType)
                    if twitterAccounts.count == 0 {
                        println ("No Twitter Accounts available")
                        return
                    } else {
                        println("DBG requestTweets else2:")

                        let twitterParams = [
                            "count" : "150"
                        ]
                        let twitterAPIURL = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
                        let request = SLRequest(forServiceType: SLServiceTypeTwitter,
                            requestMethod: SLRequestMethod.GET,
                            URL: twitterAPIURL,
                            parameters: twitterParams)
                        request.account = twitterAccounts.first as! ACAccount
                        request.performRequestWithHandler ( {
                            (data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!) -> Void in
                            self.handleTweetsResponse(data, urlResponse: urlResponse, error: error)
                        })
                    }
                }
        })
    }
    
    func handleTweetsResponse(data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!) {
        if let dataValue = data {
            var parseError : NSError? = nil
            let jsonObject : AnyObject? =
            NSJSONSerialization.JSONObjectWithData(dataValue,
                options: NSJSONReadingOptions(0),
                error: &parseError)
            if parseError != nil {
                return
            }
            if let jsonArray = jsonObject as? [[String: AnyObject]] {
                self.tweets.removeAll(keepCapacity: true)
                for tweetDict in jsonArray {
                    let tweetText = tweetDict["text"] as! String
                    let df = NSDateFormatter()
                    // this is the format that we are getting from Twitter API
                    df.dateFormat = "EEE MMM d HH:mm:ss Z y"
                    let createdAtLong = tweetDict["created_at"] as! String
                    // convert a string into NSDate using our date formatter
                    let createdAtShort = df.dateFromString(createdAtLong)
                    // configure our date formatter to have a shorter format
                    df.dateFormat = "EEE MMM d"
                    // use our newly configured date formatter to convert string to NSDate
                    let createdAt = df.stringFromDate(createdAtShort!)
                    let userDict = tweetDict["user"] as! NSDictionary
                    let userName = userDict["name"] as! String
                    let pictureURL = userDict["profile_image_url"] as! String
                    let tweet = Tweet(tweetText: tweetText, userName: userName, createdAt: createdAt, pictureURL: NSURL(string: pictureURL))
                    self.tweets.append(tweet)
                }
                self.tableView.reloadData()
            }
        } else {
            println ("handleTwitterData received no data")
        }
    }
    
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
        requestTweets()
        // Do any additional setup after loading the view, typically from a nib.
//        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Display customization
    

}