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
}

public final class TwitterCloneAuth: ObservableObject {
    let signupUrl: URL
    let loginUrl: URL

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

    public init() {
        // TODO: Make baseUrl dynamic
        os_log("Init auth")
        // swiftlint:disable:next force_unwrapping
        signupUrl = URL(string: "http://localhost:8080/auth/signup")!
        // swiftlint:disable:next force_unwrapping
        loginUrl = URL(string: "http://localhost:8080/auth/login")!
        do {
            authUser = try storedAuthUser()
        } catch {
            os_log(.error, "Load credentials from keychain failed: {public}@", error.localizedDescription)
        }
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

        try TwitterCloneNetworkKit.checkStatusCode(statusCode: statusCode)

        let authUser = try TwitterCloneNetworkKit.jsonDecoder.decode(AuthUser.self, from: data)
        authUser.persist()
        DispatchQueue.main.async { [weak self] in
            self?.authUser = authUser
        }

        return authUser
    }

    public func login(username: String, password: String) async throws {
        os_log("User login @", username)
        let credential = LoginCredential(username: username, password: password)
        let postData = try TwitterCloneNetworkKit.jsonEncoder.encode(credential)

        var loginRequest = URLRequest(url: loginUrl)
        loginRequest.httpMethod = "POST"
        loginRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        loginRequest.httpBody = postData

        let (data, response) = try await URLSession.shared.data(for: loginRequest)
        let statusCode = (response as? HTTPURLResponse)?.statusCode

        try TwitterCloneNetworkKit.checkStatusCode(statusCode: statusCode)

        let authUser = try TwitterCloneNetworkKit.jsonDecoder.decode(AuthUser.self, from: data)
        authUser.persist()
        DispatchQueue.main.async { [weak self] in
            self?.authUser = authUser
        }
    }
}
