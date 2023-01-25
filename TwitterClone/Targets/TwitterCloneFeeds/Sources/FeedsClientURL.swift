//
//  FeedsClientURL.swift
//  TwitterCloneFeeds
//
//  Created by Jeroen Leenarts on 25/01/2023.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import Foundation
import SwiftUI

import TwitterCloneAuth

internal enum FeedsClientURL {
    case images
    case followers(userId: String)
    case follows(userId: String)
    case user(userId: String? = nil)
    case userFeed(userId: String)
    case timelineFeed(userId: String)
    case follow(userId: String)
    case unfollow(userId: String, target: String)

}

public enum Region: String {
    case usEast = "https://us-east-api.stream-io-api.com/api/v1.0/"
    case euWest = "https://eu-west-api.stream-io-api.com/api/v1.0/"
    case singapore = "https://singapore-api.stream-io-api.com/api/v1.0/"
}

internal class URLFactory {
    let baseUrl: URL
    
    @EnvironmentObject var auth: TwitterCloneAuth
    
    internal init(baseUrl: URL) {
        self.baseUrl = baseUrl
    }
    
    internal func url(forPath: FeedsClientURL) -> URL {
        var newURL = baseUrl
        
        switch forPath {
        case .images:
            newURL.append(component: "images")
        case .followers(let userId):
            newURL.append(component: "feed/user")
           newURL.append(path: userId)
           newURL.append(path: "followers")
        case .follows(let userId):
            newURL.append(component: "feed/timeline")
           newURL.append(path: userId)
           newURL.append(path: "follows")
        case .user(let userId):
            newURL.append(component: "user")
            if let userId {
                newURL.append(path: userId)
            }
        case .userFeed(let userId):
            newURL.append(component: "feed/user")
            newURL.append(path: userId)
        case .timelineFeed(let userId):
            newURL.append(component: "feed/timeline")
            newURL.append(path: userId)
        case .follow(userId: let userId):
            newURL.append(component: "feed/timeline")
            newURL.append(path: userId)
            newURL.append(path: "follows")
        case .unfollow(userId: let userId, target: let target):
            newURL.append(component: "feed/timeline")
            newURL.append(path: userId)
            newURL.append(path: "unfollow")
            newURL.append(path: target)
        }
        newURL.appendApiKey()
        return newURL
    }
}

private extension URL {
    mutating func appendApiKey() {
        append(queryItems: [URLQueryItem(name: "api_key", value: "dn4mpr346fns")])
    }
    
    func appendingApiKey() -> URL {
        return appending(queryItems: [URLQueryItem(name: "api_key", value: "dn4mpr346fns")])
    }
}
