import Foundation

import TwitterCloneKeychain
import TwitterCloneNetworkKit

private enum AuthKeychainKey: String {
    case feedToken
    case chatToken
    case username
    case userId
}

public struct AuthUser: Decodable {
    public let feedToken: String
    public let chatToken: String
    public let username: String
    public let userId: String
    
    public func persist() {
        KeyChainHelper.shared.setString(feedToken, forKey: AuthKeychainKey.feedToken.rawValue, requireUserpresence: false)
        KeyChainHelper.shared.setString(chatToken, forKey: AuthKeychainKey.chatToken.rawValue, requireUserpresence: false)
        KeyChainHelper.shared.setString(username, forKey: AuthKeychainKey.username.rawValue, requireUserpresence: false)
        KeyChainHelper.shared.setString(userId, forKey: AuthKeychainKey.userId.rawValue, requireUserpresence: false)
    }
    
    // TODO need an interface to load all things back for use.
}

private struct LoginCredential: Encodable {
    let username: String
    let password: String
}

public enum AuthError: Error {
    case noStoredAuthUser
}

public final class TwitterCloneAuth {
    let signupUrl: URL
    let loginUrl: URL
    
    public init() {
        // TODO: Make baseUrl dynamic
        signupUrl = URL(string: "http://localhost:8080/auth/signup")!
        loginUrl = URL(string: "http://localhost:8080/auth/login")!
    }
    
    public var feedToken: String? {
        return KeyChainHelper.shared.string(forKey: AuthKeychainKey.feedToken.rawValue, requireUserpresence: false)
    }
    
    public var chatToken: String? {
        return KeyChainHelper.shared.string(forKey: AuthKeychainKey.chatToken.rawValue, requireUserpresence: false)
    }
    
    public var username: String? {
        return KeyChainHelper.shared.string(forKey: AuthKeychainKey.username.rawValue, requireUserpresence: false)
    }
    
    public var userId: String? {
        return KeyChainHelper.shared.string(forKey: AuthKeychainKey.userId.rawValue, requireUserpresence: false)
    }
    
    public func storedAuthUser() throws-> AuthUser {
        
        guard let feedToken = KeyChainHelper.shared.string(forKey: AuthKeychainKey.feedToken.rawValue, requireUserpresence: false) else { throw AuthError.noStoredAuthUser }
        guard let chatToken = KeyChainHelper.shared.string(forKey: AuthKeychainKey.chatToken.rawValue, requireUserpresence: false) else { throw AuthError.noStoredAuthUser }
        guard let username = KeyChainHelper.shared.string(forKey: AuthKeychainKey.username.rawValue, requireUserpresence: false) else { throw AuthError.noStoredAuthUser }
        guard let userId = KeyChainHelper.shared.string(forKey: AuthKeychainKey.userId.rawValue, requireUserpresence: false) else { throw AuthError.noStoredAuthUser }
        
        return AuthUser(feedToken: feedToken, chatToken: chatToken, username: username, userId: userId)
    }
    
    public func signup(username: String, password: String) async throws -> AuthUser {
        let credential = LoginCredential(username: username, password: password)
        
        var loginRequest = URLRequest(url: signupUrl)
        loginRequest.httpMethod = "POST"
        loginRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        loginRequest.httpBody = try TwitterCloneNetworkKit.jsonEncoder.encode(credential)

        let (data, response) = try await URLSession.shared.data(for: loginRequest)
        let statusCode = (response as? HTTPURLResponse)?.statusCode
        
        try TwitterCloneNetworkKit.checkStatusCode(statusCode: statusCode)
        
        return try TwitterCloneNetworkKit.jsonDecoder.decode(AuthUser.self, from: data)
    }
    
    public func login(username: String, password: String) async throws -> AuthUser {
        let credential = LoginCredential(username: username, password: password)
        let postData = try TwitterCloneNetworkKit.jsonEncoder.encode(credential)
        
        var loginRequest = URLRequest(url: loginUrl)
        loginRequest.httpMethod = "POST"
        loginRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        loginRequest.httpBody = postData
        
        let (data, response) = try await URLSession.shared.data(for: loginRequest)
        let statusCode = (response as? HTTPURLResponse)?.statusCode
        
        try TwitterCloneNetworkKit.checkStatusCode(statusCode: statusCode)
        
        return try TwitterCloneNetworkKit.jsonDecoder.decode(AuthUser.self, from: data)
    }
}
