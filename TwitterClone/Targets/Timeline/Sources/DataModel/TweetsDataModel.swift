//
//  TweetsDataModel.swift
//  TTwin
//

import Foundation
import Feeds

// Data structure
struct ForYouTweetsStructure: Identifiable {
    var id = UUID()
    var userProfilePhoto: String
    var userName: String
    var userHandle: String
    var tweetSentAt: String
    var actionsMenuIcon: String
    var tweetSummary: String
    var tweetPhoto: String
    var numberOfComments: String
    var numberOfLikes: String
}

// TODO add sample data
public let ForYouTweetData = [PostActivity]()

let ForYouTweetDataOld = [
    ForYouTweetsStructure(
        userProfilePhoto: "https://picsum.photos/id/219/200",
        userName: "Happy Thoughts",
        userHandle: "@HappyThoughts",
        tweetSentAt: "2h",
        actionsMenuIcon: "ellipsis.circle",
        tweetSummary: "Starting the day with a positive attitude is key to a happy life 🥰",
        tweetPhoto: "https://picsum.photos/id/220/350/200",
        numberOfComments: "1",
        numberOfLikes: "2"),
    
    ForYouTweetsStructure(
        userProfilePhoto: "https://picsum.photos/id/25/200",
        userName: "Book Worm",
        userHandle: "@bookworm",
        tweetSentAt: "3h",
        actionsMenuIcon: "ellipsis.circle",
        tweetSummary: "Just finished reading the latest bestseller and I am blown away by the author's storytelling skills",
        tweetPhoto: "https://picsum.photos/id/81/350/200",
        numberOfComments: "5",
        numberOfLikes: "10"),
    
    ForYouTweetsStructure(
        userProfilePhoto: "https://picsum.photos/id/3/200",
        userName: "Pet Parent",
        userHandle: "@petParent",
        tweetSentAt: "5h",
        actionsMenuIcon: "ellipsis.circle",
        tweetSummary: "Spending the afternoon playing with my furry best friend 🐇 🐈",
        tweetPhoto: "https://picsum.photos/id/120/350/200",
        numberOfComments: "42",
        numberOfLikes: "458"),
    
    ForYouTweetsStructure(
        userProfilePhoto: "https://picsum.photos/id/4/200",
        userName: "Foodie Fiesta",
        userHandle: "@foodie",
        tweetSentAt: "10h",
        actionsMenuIcon: "ellipsis.circle",
        tweetSummary: "Trying out a new Mexican restaurant and loving the flavors 🥗",
        tweetPhoto: "https://picsum.photos/id/62/350/200",
        numberOfComments: "1",
        numberOfLikes: "3"),
    
    ForYouTweetsStructure(
        userProfilePhoto: "https://picsum.photos/id/15/200",
        userName: "Awo Yaa",
        userHandle: "@awoyaa",
        tweetSentAt: "15h",
        actionsMenuIcon: "ellipsis.circle",
        tweetSummary: "What is $0 in Swift? 👩‍💻",
        tweetPhoto: "https://picsum.photos/id/18/350/200",
        numberOfComments: "70",
        numberOfLikes: "123")
]
