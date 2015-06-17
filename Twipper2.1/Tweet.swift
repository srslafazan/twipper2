//
//  Tweet.swift
//  Twipper2.1
//
//  Created by Shain Lafazan on 6/16/15.
//  Copyright (c) 2015 Shain Lafazan. All rights reserved.
//

import Foundation
import UIKit

class Tweet {
    var tweetText: String?
    var userName: String?
    var createdAt: String?
    var pictureURL: NSURL?
    init (tweetText: String?, userName: String?, createdAt: String?, pictureURL : NSURL?) {
        self.tweetText = tweetText
        self.userName = userName
        self.createdAt = createdAt
        self.pictureURL = pictureURL
    }
}