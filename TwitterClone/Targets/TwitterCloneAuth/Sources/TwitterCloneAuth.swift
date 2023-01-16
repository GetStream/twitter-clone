import Foundation

import TwitterCloneKeychain

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
    case badResponse
    case serverError
    case unauthorized
    
    case unhandled
    
    case noStatus
}

public final class TwitterCloneAuth {
    let signupUrl: URL
    let loginUrl: URL
    let jsonEncoder: JSONEncoder
    let jsonDecoder: JSONDecoder

    public init() {
        // TODO: Make baseUrl dynamic
        signupUrl = URL(string: "http://localhost:8080/auth/signup")!
        loginUrl = URL(string: "http://localhost:8080/auth/login")!

        jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted

        jsonDecoder = JSONDecoder()
    }
    
    public func signup(username: String, password: String) async throws -> AuthUser {
        let credential = LoginCredential(username: username, password: password)
        
        var loginRequest = URLRequest(url: signupUrl)
        loginRequest.httpMethod = "POST"
        loginRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        loginRequest.httpBody = try jsonEncoder.encode(credential)

        let (data, response) = try await URLSession.shared.data(for: loginRequest)
        let statusCode = (response as? HTTPURLResponse)?.statusCode
        
        try checkStatusCode(statusCode: statusCode)
        
        let jsonDecoder = jsonDecoder
        return try jsonDecoder.decode(AuthUser.self, from: data)
    }
    
    public func login(username: String, password: String) async throws -> AuthUser {
        let credential = LoginCredential(username: username, password: password)
        let postData = try jsonEncoder.encode(credential)
        
        var loginRequest = URLRequest(url: loginUrl)
        loginRequest.httpMethod = "POST"
        loginRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        loginRequest.httpBody = postData
        
        let (data, response) = try await URLSession.shared.data(for: loginRequest)
        let statusCode = (response as? HTTPURLResponse)?.statusCode
        
        try checkStatusCode(statusCode: statusCode)
        
        let jsonDecoder = jsonDecoder
        return try jsonDecoder.decode(AuthUser.self, from: data)
    }
    
    /// Checks the status code for errors
    /// - Parameter statusCode: The response status code to check. If it does not throw it is an acceptable status.
    private func checkStatusCode(statusCode: Int?) throws {
        guard let statusCode = statusCode else {
            throw AuthError.noStatus
        }
        
        switch statusCode {
        case 500:
            throw AuthError.badResponse
        case 400:
            throw AuthError.unauthorized
        case 200:
            return
        default:
            throw AuthError.unhandled
        }
    }
    
}
