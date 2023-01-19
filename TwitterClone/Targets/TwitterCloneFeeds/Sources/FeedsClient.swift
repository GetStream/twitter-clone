//
//  FeedsClient.swift
//  TwitterCloneFeeds
//
//  Created by Jeroen Leenarts on 18/01/2023.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import Foundation
import TwitterCloneAuth
import TwitterCloneNetworkKit

enum Region: String {
    case usEast = "https://us-east-api.stream-io-api.com/api/v1.0/"
    case euWest = "https://eu-west-api.stream-io-api.com/api/v1.0/"
    case singapore = "https://singapore-api.stream-io-api.com/api/v1.0/"
}

private struct FollowParamModel: Encodable {
    let target: String
    let activity_copy_limit: Int
}

private struct UnfollowParamModel: Encodable {
    let keep_history: Bool
}

public struct PagingModel: Encodable {
    let limit: Int
    let offset: Int
}

public class FeedsClient {
    let baseUrl: URL
    
    let auth = TwitterCloneAuth()
    
    private func userFeedURL(userId: String)-> URL {
        
        var newURL = baseUrl.appending(component: "feed/user")
        newURL.append(path: userId)
        newURL.append(queryItems: [URLQueryItem(name: "api_key", value: "dn4mpr346fns")])
        
        return newURL
    }
    
    private func timelineFeedFollowsURL(userId: String)-> URL {
        
        var newURL = baseUrl.appending(component: "feed/timeline")
        newURL.append(path: userId)
        newURL.append(path: "follows")
        newURL.append(queryItems: [URLQueryItem(name: "api_key", value: "dn4mpr346fns")])
        
        return newURL
    }
    
    private func timelineFeedUnfollowURL(userId: String, target: String)-> URL {
        
        var newURL = baseUrl.appending(component: "feed/timeline")
        newURL.append(path: userId)
        newURL.append(path: "unfollow")
        newURL.append(path: target)
        newURL.append(queryItems: [URLQueryItem(name: "api_key", value: "dn4mpr346fns")])
        
        return newURL
    }
    
    
    private func feedFollowersURL(userId: String)-> URL {
        
        var newURL = baseUrl.appending(component: "feed/user")
        newURL.append(path: userId)
        newURL.append(path: "followers")
        newURL.append(queryItems: [URLQueryItem(name: "api_key", value: "dn4mpr346fns")])
        
        return newURL
    }
    
    
    static func productionClient(region: Region) -> FeedsClient {
        return FeedsClient(urlString: region.rawValue)
    }
    
    private init(urlString: String) {
        baseUrl = URL(string: urlString)!
    }
    
    public func follow(feedId: String, target: String, activityCopyLimit: Int) async throws {
        let session = TwitterCloneNetworkKit.restSession
        
        let authUser = try auth.storedAuthUser()

        let userId = authUser.userId
        let feedToken = authUser.feedToken
        var request = URLRequest(url: timelineFeedFollowsURL(userId: userId))
        request.httpMethod = "POST"
        request.httpBody = try TwitterCloneNetworkKit.jsonEncoder.encode(FollowParamModel(target: target, activity_copy_limit: activityCopyLimit))
        
        // Headers
        request.addValue("jwt", forHTTPHeaderField: "Stream-Auth-Type")
        request.addValue(feedToken, forHTTPHeaderField: "Authorization")

        let (_, response) = try await session.data(for: request)
        
        let statusCode = (response as? HTTPURLResponse)?.statusCode
        
        try TwitterCloneNetworkKit.checkStatusCode(statusCode: statusCode)
    }
    
    public func unfollow(feedId: String, target: String, keepHistory: Bool) async throws {
        let session = TwitterCloneNetworkKit.restSession
        
        let authUser = try auth.storedAuthUser()

        let userId = authUser.userId
        let feedToken = authUser.feedToken
        var request = URLRequest(url: timelineFeedUnfollowURL(userId: userId, target: target))
        request.httpMethod = "DELETE"
        
        request.httpBody = try TwitterCloneNetworkKit.jsonEncoder.encode(UnfollowParamModel(keep_history:keepHistory))

        // Headers
        request.addValue("jwt", forHTTPHeaderField: "Stream-Auth-Type")
        request.addValue(feedToken, forHTTPHeaderField: "Authorization")

        let (_, response) = try await session.data(for: request)
        
        let statusCode = (response as? HTTPURLResponse)?.statusCode
        
        try TwitterCloneNetworkKit.checkStatusCode(statusCode: statusCode)
    }
    
    public func followers(feedId: String, pagingModel: PagingModel? = nil) async throws {
        let session = TwitterCloneNetworkKit.restSession
        
        let authUser = try auth.storedAuthUser()

        let userId = authUser.userId
        let feedToken = authUser.feedToken
        var request = URLRequest(url: feedFollowersURL(userId: userId))
        request.httpMethod = "GET"
        
        //TODO add paging modeltorequest
        
        // Headers
        request.addValue("jwt", forHTTPHeaderField: "Stream-Auth-Type")
        request.addValue(feedToken, forHTTPHeaderField: "Authorization")

        let (data, response) = try await session.data(for: request)
        
        //TODO parse data:
//        {"results":[{"feed_id":"timeline:6240378a0cb3a15b1ca56a4dfe4a3f07","target_id":"user:47b2d8af2716fee6303a1a036309d892","created_at":"2023-01-19T15:06:39.173830389Z","updated_at":"2023-01-19T15:06:39.173830389Z"}],"duration":"2.46ms"}
        
        let statusCode = (response as? HTTPURLResponse)?.statusCode
        
        try TwitterCloneNetworkKit.checkStatusCode(statusCode: statusCode)
        
    }
    
    public func following(feedId: String, pagingModel: PagingModel? = nil) async throws {
        let session = TwitterCloneNetworkKit.restSession
        
        let authUser = try auth.storedAuthUser()

        let userId = authUser.userId
        let feedToken = authUser.feedToken
        var request = URLRequest(url: timelineFeedFollowsURL(userId: userId))
        request.httpMethod = "GET"
        
        //TODO add paging modeltorequest

        // Headers
        request.addValue("jwt", forHTTPHeaderField: "Stream-Auth-Type")
        request.addValue(feedToken, forHTTPHeaderField: "Authorization")

        let (data, response) = try await session.data(for: request)
        
        //TODO Parse data
        //{"results":[{"feed_id":"timeline:6240378a0cb3a15b1ca56a4dfe4a3f07","target_id":"user:47b2d8af2716fee6303a1a036309d892","created_at":"2023-01-19T15:06:39.173830389Z","updated_at":"2023-01-19T15:06:39.173830389Z"}],"duration":"1.90ms"}
        
        let statusCode = (response as? HTTPURLResponse)?.statusCode
        
        try TwitterCloneNetworkKit.checkStatusCode(statusCode: statusCode)
    }
    
    public func getActivities() async throws -> [PostActivity] {
        let session = TwitterCloneNetworkKit.restSession
        
        let authUser = try auth.storedAuthUser()

        let userId = authUser.userId
        let feedToken = authUser.feedToken
        var request = URLRequest(url: userFeedURL(userId: userId))
        request.httpMethod = "GET"

        // Headers
        request.addValue("jwt", forHTTPHeaderField: "Stream-Auth-Type")
        request.addValue(feedToken, forHTTPHeaderField: "Authorization")

        let (data, response) = try await session.data(for: request)
        
        let statusCode = (response as? HTTPURLResponse)?.statusCode
        
        try TwitterCloneNetworkKit.checkStatusCode(statusCode: statusCode)
        
        return try TwitterCloneNetworkKit.jsonDecoder.decode([PostActivity].self, from: data)
    }
    
    public func addActivity() async throws -> PostActivityResponse {
        let session = TwitterCloneNetworkKit.restSession
        
        let authUser = try auth.storedAuthUser()

        let userId = authUser.userId
        let feedToken = authUser.feedToken
        var request = URLRequest(url: userFeedURL(userId: userId))
        request.httpMethod = "POST"
        
        // Headers
        request.addValue("jwt", forHTTPHeaderField: "Stream-Auth-Type")
        request.addValue(feedToken, forHTTPHeaderField: "Authorization")

        let (data, response) = try await session.data(for: request)
        
        let statusCode = (response as? HTTPURLResponse)?.statusCode
        
        try TwitterCloneNetworkKit.checkStatusCode(statusCode: statusCode)
        
        return try TwitterCloneNetworkKit.jsonDecoder.decode(PostActivityResponse.self, from: data)
    }
}
