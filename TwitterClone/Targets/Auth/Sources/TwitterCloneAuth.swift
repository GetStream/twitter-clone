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
}

private struct LoginCredential: Encodable {
    let username: String
    let password: String
}

public enum AuthError: Error {
    case noStoredAuthUser
    case noLoadedAuthUser
    case urlInvalid
}

public final class TwitterCloneAuth: ObservableObject {
    let signupUrl: URL
    let loginUrl: URL
    let usersUrl: URL

    @Published
    public private(set) var authUser: AuthUser?

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
        loginUrl = authUrl.appending(path: "login")
        usersUrl = authUrl.appending(path: "users")
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
        DispatchQueue.main.async { [weak self] in
            self?.authUser = authUser
        }

        return authUser
    }

    public func login(username: String, password: String) async throws -> AuthUser {
        os_log("User login @", username)
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
        DispatchQueue.main.async { [weak self] in
            self?.authUser = authUser
        }
        return authUser
    }
    
    public func users(matching searchTerm: String) async throws -> [UserReference] {
        os_log("Search users  %{public}@", searchTerm)
        
        let postDict = ["searchTerm": searchTerm]
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
}
