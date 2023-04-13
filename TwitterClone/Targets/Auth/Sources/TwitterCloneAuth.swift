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
    public let id: String
    public let username: String
    
    public var userId: String {
        id
    }
}

public struct AuthUser: Decodable {
    public let feedToken: String
    public let chatToken: String
    public let username: String
    public let userId: String
    
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
    case noLoadedAuthUser
}

@MainActor
public final class TwitterCloneAuth: TwitterCloneClient, ObservableObject {

    @Published
    public var authUser: AuthUser?

    private var storedAuthUser: AuthUser? {
        os_log("Load credentials from keychain")
        guard
            let feedToken = keychainHelper.string(for: .feedToken),
            let chatToken = keychainHelper.string(for: .chatToken),
            let username = keychainHelper.string(for: .username),
            let userId = keychainHelper.string(for: .userId)
        else {
            return nil
        }

        return AuthUser(feedToken: feedToken, chatToken: chatToken, username: username, userId: userId)
    }

    private let keychainHelper = KeyChainHelper.shared

    public override init(baseUrl baseUrlString: String) throws {
        os_log("Init auth")
        try super.init(baseUrl: baseUrlString)
        authUser = storedAuthUser
    }

    public func logout() {
        os_log("Logout triggered")
        keychainHelper.removeKey(.feedToken)
        keychainHelper.removeKey(.chatToken)
        keychainHelper.removeKey(.username)
        keychainHelper.removeKey(.userId)
        authUser = nil
    }

    public func signup(username: String, password: String) async throws -> AuthUser {
        os_log("User signup @", username)
        let credential = LoginCredential(username: username, password: password)
        let authUser: AuthUser = try await post(route: Routes.signup, request: credential)

        persist(authUser)
        self.authUser = authUser

        return authUser
    }
    
    public func changePassword(password: String, newPassword: String) async throws {
        guard let authUser = self.authUser else {
            throw AuthError.noLoadedAuthUser
        }

        let credential = ChangeCredential(username: authUser.userId, password: password, newPassword: newPassword)
        try await post(route: Routes.changePassword, request: credential)
    }

    public func login(username: String, password: String) async throws {
        os_log("User login %@", username)
        let credential = LoginCredential(username: username, password: password)
        let authUser: AuthUser = try await post(route: Routes.login, request: credential)

        persist(authUser)
        self.authUser = authUser
    }
    
    public func users(matching searchTerm: String) async throws -> [UserReference] {
        os_log("Search users  %{public}@", searchTerm)

        guard let authUser = self.authUser else {
            throw AuthError.noLoadedAuthUser
        }

        let request = ["searchTerm": searchTerm, "selfUserId": authUser.userId]
        let response: ResultResponse<[UserReference]> = try await post(route: Routes.users, request: request)

        return response.results
    }
    
    public func muxUpload() async throws -> MuxUploadResponse {
        // TODO: provide request data
        let response: MuxUploadResponse = try await post(route: Routes.muxUpload, request: ["":""])
        return response
    }
    
    public func muxAssetId(uploadId: String) async throws -> MuxAssetUploadStatusResponse {
        let request = ["upload_id": uploadId]
        let response: MuxAssetUploadStatusResponse = try await post(route: Routes.muxAsset, request: request)
        return response
    }
    
    public func muxPlaybackId(assetId: String) async throws -> MuxPlaybackResponse {
        let request = ["asset_id": assetId]
        let response: MuxPlaybackResponse = try await post(route: Routes.muxPlayback, request: request)
        return response
    }

    private func persist(_ authUser: AuthUser) {
        os_log("Persist user credentials")
        keychainHelper.setString(authUser.feedToken, for: .feedToken)
        keychainHelper.setString(authUser.chatToken, for: .chatToken)
        keychainHelper.setString(authUser.username, for: .username)
        keychainHelper.setString(authUser.userId, for: .userId)
    }
}

extension KeyChainHelper {
    fileprivate func string(for authKey: AuthKeychainKey) -> String? {
        string(forKey: authKey.rawValue, requireUserpresence: false)
    }

    fileprivate func setString(_ string: String, for authKey: AuthKeychainKey) {
        setString(string, forKey: authKey.rawValue, requireUserpresence: false)
    }

    fileprivate func removeKey(_ authKey: AuthKeychainKey) {
        removeKey(authKey.rawValue)
    }
}
