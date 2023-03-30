import Foundation
import os.log

import Keychain
import NetworkKit

internal extension OSLog {
    // swiftlint:disable:next force_unwrapping
    private static var subsystem = Bundle.main.bundleIdentifier!

    /// Logs the view cycles like viewDidLoad.
    static let clientLog = OSLog(subsystem: subsystem, category: "auth")
}

private enum AuthKeychainKey: String {
    case feedToken
    case chatToken
    case username
    case userId
}

public struct MuxUploadResponse: Decodable {
    public let upload_id: String
    public let upload_url: String
}

public struct MuxAssetUploadStatusResponse: Decodable {
    public let asset_id: String
    public let status: String
}

public struct MuxPlaybackResponse: Decodable {
    public let ids: [MuxPlaybackId]
    
    enum CodingKeys: String, CodingKey {
        case ids = "playback_ids"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)        
        ids = try container.decode([MuxPlaybackId].self, forKey: .ids)
    }
    
}

public struct MuxPlaybackId: Decodable {
    public let id: String
    public let policy: String
}

public struct UserReference: Decodable, Identifiable {
    public var id: String {
        return userId
    }
    
    public let userId: String
    public let username: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "id"
        case username
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.username = try container.decode(String.self, forKey: .username)
    }
}

public struct AuthUser: Decodable {
    public let feedToken: String
    public let chatToken: String
    public let username: String
    public let userId: String

    public func persist() {
        os_log("Persist user credentials")
        KeyChainHelper.shared.setString(feedToken, forKey: AuthKeychainKey.feedToken.rawValue, requireUserpresence: false)
        KeyChainHelper.shared.setString(chatToken, forKey: AuthKeychainKey.chatToken.rawValue, requireUserpresence: false)
        KeyChainHelper.shared.setString(username, forKey: AuthKeychainKey.username.rawValue, requireUserpresence: false)
        KeyChainHelper.shared.setString(userId, forKey: AuthKeychainKey.userId.rawValue, requireUserpresence: false)
    }
    
    public static func previewUser() -> AuthUser {
        return AuthUser(feedToken: "123_fake", chatToken: "123_fake", username: "preview", userId: "password")
    }
}

private struct LoginCredential: Encodable {
    let username: String
    let password: String
}

private struct ChangeCredential: Encodable {
    let username: String
    let password: String
    let newPassword: String
}

public enum AuthError: Error {
    case noStoredAuthUser
    case noLoadedAuthUser
    case urlInvalid
}

@MainActor
public final class TwitterCloneAuth: ObservableObject {
    let signupUrl: URL
    let changePasswordUrl: URL
    let loginUrl: URL
    let usersUrl: URL
    let muxUploadUrl: URL
    let muxPlaybackUrl: URL
    let muxAssetUrl: URL

    @Published
    public var authUser: AuthUser?
    
    public func logout() {
        os_log("Logout triggered")
        KeyChainHelper.shared.removeKey(AuthKeychainKey.feedToken.rawValue)
        KeyChainHelper.shared.removeKey(AuthKeychainKey.chatToken.rawValue)
        KeyChainHelper.shared.removeKey(AuthKeychainKey.username.rawValue)
        KeyChainHelper.shared.removeKey(AuthKeychainKey.userId.rawValue)
        authUser = nil
    }

    public init(baseUrl baseUrlString: String) throws {
        os_log("Init auth")
        guard let baseUrl = URL(string: baseUrlString) else {
            throw AuthError.urlInvalid
        }
        let authUrl = baseUrl.appending(path: "auth")
        signupUrl = authUrl.appending(path: "signup")
        changePasswordUrl = authUrl.appending(path: "chpasswd")
        loginUrl = authUrl.appending(path: "login")
        usersUrl = authUrl.appending(path: "users")
        muxUploadUrl = authUrl.appending(path: "mux-upload")
        muxPlaybackUrl = authUrl.appending(path: "mux-playback")
        muxAssetUrl = authUrl.appending(path: "mux-asset")
        authUser = try? storedAuthUser()
//        logout()
    }

    public func storedAuthUser() throws -> AuthUser {
        os_log("Load credentials from keychain")
        guard let feedToken = KeyChainHelper.shared.string(forKey: AuthKeychainKey.feedToken.rawValue, requireUserpresence: false) else { throw AuthError.noStoredAuthUser }
        guard let chatToken = KeyChainHelper.shared.string(forKey: AuthKeychainKey.chatToken.rawValue, requireUserpresence: false) else { throw AuthError.noStoredAuthUser }
        guard let username = KeyChainHelper.shared.string(forKey: AuthKeychainKey.username.rawValue, requireUserpresence: false) else { throw AuthError.noStoredAuthUser }
        guard let userId = KeyChainHelper.shared.string(forKey: AuthKeychainKey.userId.rawValue, requireUserpresence: false) else { throw AuthError.noStoredAuthUser }

        return AuthUser(feedToken: feedToken, chatToken: chatToken, username: username, userId: userId)
    }

    public func signup(username: String, password: String) async throws -> AuthUser {
        os_log("User signup @", username)
        let credential = LoginCredential(username: username, password: password)

        var loginRequest = URLRequest(url: signupUrl)
        loginRequest.httpMethod = "POST"
        loginRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        loginRequest.httpBody = try TwitterCloneNetworkKit.jsonEncoder.encode(credential)

        let (data, response) = try await URLSession.shared.data(for: loginRequest)
        let statusCode = (response as? HTTPURLResponse)?.statusCode

        if OSLog.networkPayloadLog.isEnabled(type: .debug) {
            os_log("signup response: %{public}@", log: OSLog.clientLog, type: .debug, String(data: data, encoding: .utf8) ?? "")
        }
        
        try TwitterCloneNetworkKit.checkStatusCode(statusCode: statusCode)

        let authUser = try TwitterCloneNetworkKit.jsonDecoder.decode(AuthUser.self, from: data)
        authUser.persist()
        self.authUser = authUser

        return authUser
    }
    
    public func changePassword(password: String, newPassword: String) async throws {
        guard let authUser = self.authUser else {
            throw AuthError.noLoadedAuthUser
        }

        let userId = authUser.userId
        
        let credential = ChangeCredential(username: userId, password: password, newPassword: newPassword)
        
        var changePasswordRequest = URLRequest(url: changePasswordUrl)
        changePasswordRequest.httpMethod = "POST"
        changePasswordRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        changePasswordRequest.httpBody = try TwitterCloneNetworkKit.jsonEncoder.encode(credential)
        
        let (_, response) = try await URLSession.shared.data(for: changePasswordRequest)
        let statusCode = (response as? HTTPURLResponse)?.statusCode
        
        try TwitterCloneNetworkKit.checkStatusCode(statusCode: statusCode)
    }

    public func login(username: String, password: String) async throws {
        os_log("User login %@", username)
        let credential = LoginCredential(username: username, password: password)
        let postData = try TwitterCloneNetworkKit.jsonEncoder.encode(credential)

        var loginRequest = URLRequest(url: loginUrl)
        loginRequest.httpMethod = "POST"
        loginRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        loginRequest.httpBody = postData

        let (data, response) = try await URLSession.shared.data(for: loginRequest)
        if OSLog.networkPayloadLog.isEnabled(type: .debug) {
            os_log(.debug, "login response: %{public}@", String(data: data, encoding: .utf8) ?? "")
        }
        let statusCode = (response as? HTTPURLResponse)?.statusCode

        try TwitterCloneNetworkKit.checkStatusCode(statusCode: statusCode)

        let authUser = try TwitterCloneNetworkKit.jsonDecoder.decode(AuthUser.self, from: data)
        authUser.persist()
        self.authUser = authUser
    }
    
    public func users(matching searchTerm: String) async throws -> [UserReference] {
        os_log("Search users  %{public}@", searchTerm)

        guard let authUser = self.authUser else {
            throw AuthError.noLoadedAuthUser
        }

        let userId = authUser.userId
        
        let postDict = ["searchTerm": searchTerm, "selfUserId": userId]
        let postData = try TwitterCloneNetworkKit.jsonEncoder.encode(postDict)
        
        var searchUsersRequest = URLRequest(url: usersUrl)
        searchUsersRequest.httpMethod = "POST"
        searchUsersRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        searchUsersRequest.httpBody = postData

        let (data, response) = try await URLSession.shared.data(for: searchUsersRequest)
        if OSLog.networkPayloadLog.isEnabled(type: .debug) {
            os_log(.debug, "search users response: %{public}@", String(data: data, encoding: .utf8) ?? "")
        }
        let statusCode = (response as? HTTPURLResponse)?.statusCode

        try TwitterCloneNetworkKit.checkStatusCode(statusCode: statusCode)

        return try TwitterCloneNetworkKit.jsonDecoder.decode(ResultResponse<[UserReference]>.self, from: data).results
    }
    
    public func muxUploadUrl() async throws -> MuxUploadResponse {
        
        var muxUploadUrlRequest = URLRequest(url: muxUploadUrl)
        muxUploadUrlRequest.httpMethod = "POST"
        muxUploadUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, response) = try await URLSession.shared.data(for: muxUploadUrlRequest)
        
        let statusCode = (response as? HTTPURLResponse)?.statusCode
        try TwitterCloneNetworkKit.checkStatusCode(statusCode: statusCode)
        
        let muxUploadResponse = try TwitterCloneNetworkKit.jsonDecoder.decode(MuxUploadResponse.self, from: data)
        
        return muxUploadResponse
    }
    
    public func muxAssetId(uploadId: String) async throws -> MuxAssetUploadStatusResponse {
        var muxAssetUrlRequest = URLRequest(url: muxAssetUrl)
        muxAssetUrlRequest.httpMethod = "POST"
        muxAssetUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let postDict = ["upload_id": uploadId]
        let postData = try TwitterCloneNetworkKit.jsonEncoder.encode(postDict)
        muxAssetUrlRequest.httpBody = postData
        
        let (data, response) = try await URLSession.shared.data(for: muxAssetUrlRequest)
        
        let statusCode = (response as? HTTPURLResponse)?.statusCode
        try TwitterCloneNetworkKit.checkStatusCode(statusCode: statusCode)
        
        let muxAssetResponse = try TwitterCloneNetworkKit.jsonDecoder.decode(MuxAssetUploadStatusResponse.self, from: data)
        
        return muxAssetResponse
    }
    
    public func muxPlaybackUrl(assetId: String) async throws -> MuxPlaybackResponse {
        
        var muxPlaybackUrlRequest = URLRequest(url: muxPlaybackUrl)
        muxPlaybackUrlRequest.httpMethod = "POST"
        muxPlaybackUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let postDict = ["asset_id": assetId]
        let postData = try TwitterCloneNetworkKit.jsonEncoder.encode(postDict)
        muxPlaybackUrlRequest.httpBody = postData
        
        let (data, response) = try await URLSession.shared.data(for: muxPlaybackUrlRequest)
        
        let statusCode = (response as? HTTPURLResponse)?.statusCode
        try TwitterCloneNetworkKit.checkStatusCode(statusCode: statusCode)
        
        let muxPlaybackresponse = try TwitterCloneNetworkKit.jsonDecoder.decode(MuxPlaybackResponse.self, from: data)
        
        return muxPlaybackresponse
    }
}
