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

public class FeedsClient {
    let baseUrl: URL
    
    let auth = TwitterCloneAuth()
    
    private func userFeedURL(userId: String)-> URL {
        
        var newURL = baseUrl.appending(component: "feed/user")
        newURL.append(path: userId)
        newURL.append(queryItems: [URLQueryItem(name: "api_key", value: "dn4mpr346fns")])
        
        return newURL
    }
    
    static func productionClient(region: Region) -> FeedsClient {
        return FeedsClient(urlString: region.rawValue)
    }
    
    private init(urlString: String) {
        baseUrl = URL(string: urlString)!
    }
    
    public func getActivities() async throws -> [Activity] {
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
        
        return try TwitterCloneNetworkKit.jsonDecoder.decode([Activity].self, from: data)
    }
}
