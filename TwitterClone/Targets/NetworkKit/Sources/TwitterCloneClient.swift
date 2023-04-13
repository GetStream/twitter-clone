//
//  TwitterCloneClient.swift
//  NetworkKit
//
//  Created by Andrew Erickson on 2023-04-13.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import Foundation
import os.log

@MainActor
open class TwitterCloneClient {

    private let baseUrl: URL
    private let encoder = TwitterCloneNetworkKit.jsonEncoder
    private let decoder = TwitterCloneNetworkKit.jsonDecoder

    public init(baseUrl baseUrlString: String) throws {
        guard let baseUrl = URL(string: baseUrlString) else {
            throw ClientError.urlInvalid
        }
        self.baseUrl = baseUrl
    }

    public func post<Request: Encodable, Response: Decodable>(route: Route, request: Request) async throws -> Response {
        let requestData = try encoder.encode(request)
        let request = createPostRequest(url: baseUrl.appending(path: route.path), httpBody: requestData)

        let responseData = try await send(request)

        return try decoder.decode(Response.self, from: responseData)
    }

    /// send a POST request without returning a response
    public func post<Request: Encodable>(route: Route, request: Request) async throws {
        let requestData = try encoder.encode(request)
        let request = createPostRequest(url: baseUrl.appending(path: route.path), httpBody: requestData)

        try await send(request)
    }

    private func createPostRequest(url: URL, httpBody: Data? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody

        return request
    }

    @discardableResult
    private func send(_ request: URLRequest) async throws -> Data {
        let (responseData, response) = try await URLSession.shared.data(for: request)
        if OSLog.networkPayloadLog.isEnabled(type: .debug) {
            os_log(.debug, "Response: %{public}@", String(data: responseData, encoding: .utf8) ?? "")
        }
        let statusCode = (response as? HTTPURLResponse)?.statusCode

        try TwitterCloneNetworkKit.checkStatusCode(statusCode: statusCode)

        return responseData
    }
}

public enum ClientError: Error {
    case urlInvalid
}

public protocol Route {
    var path: String { get }
}

public enum Routes: String, Route {
    case auth
    case signup = "auth/signup"
    case changePassword = "auth/chpasswd"
    case login = "auth/login"
    case users = "auth/users"
    case muxUpload = "auth/mux-upload"
    case muxPlayback = "auth/mux-playback"
    case muxAsset = "auth/mux-asset"

    public var path: String {
        rawValue
    }
}
