import Foundation
import LocalAuthentication

enum KeyChainError: Error {
    case conversionError
    case securityError(status: OSStatus)
    case unexpectedError
}

final class SwiftKeyChainStore {

    private(set) var service: String?
    private(set) var accessGroup: String?

    // Localize
    var authenticationPrompt = "Please authenticate to access your credentials."

    var allItems: [AnyObject] {

        var query = baseQuery()

        query[kSecMatchLimit as String] = kSecMatchLimitAll
        query[kSecReturnAttributes as String] = true
        query[kSecReturnData as String] = true

        var resultRef: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &resultRef)

        guard status == errSecSuccess else {
            return []
        }

        guard let items = resultRef as? [AnyObject] else {
            return []
        }

        return items
    }

    init(service: String?, accessGroup: String? = nil) {
        self.service = service
        self.accessGroup = accessGroup
    }

    func exists(forKey key: String) -> Bool {
        let status = existsStatus(forKey: key)

        switch status {
        case errSecSuccess:
            return true
        case errSecInteractionNotAllowed:
            // item exists
            return true
        case errSecAuthFailed:
            // item exists but someone removed the touch id or passcode or too many failed attempts
            return true
        case errSecItemNotFound:
            // it does not exist
            return false
        default:
            // another OSStatus
            return false

        }
    }

    private func existsStatus(forKey key: String) -> OSStatus {
        var query = baseQuery()
        query[kSecAttrAccount as String] = key
        let context = LAContext()
        context.interactionNotAllowed = true
        query[kSecUseAuthenticationContext as String] = context

        var dataRef: CFTypeRef?
        return SecItemCopyMatching(query as CFDictionary, &dataRef)
    }

    func setString(_ string: String?, forKey key: String, requireUserpresence: Bool = false) throws {
        guard let string = string else {
            try removeItem(forKey: key)
            return
        }

        guard let data = string.data(using: .utf8) else {
            throw KeyChainError.conversionError
        }

        try setData(data, forKey: key, requireUserpresence: requireUserpresence)
    }

    func string(forKey key: String, requireUserpresence: Bool) throws -> String? {
        guard let data = try data(forKey: key, requireUserpresence: requireUserpresence) else { return nil }

        guard let string = String(data: data, encoding: .utf8) else {
            throw KeyChainError.conversionError
        }
        return string
    }

    func setData(_ data: Data?, forKey key: String, requireUserpresence: Bool = false) throws {
        guard let data = data else {
            try removeItem(forKey: key)
            return
        }

        let status = existsStatus(forKey: key)
        if status == errSecSuccess || status == errSecInteractionNotAllowed {
            // Removing instead of updating prevents user presence checks from showing.
            try removeItem(forKey: key)
        }
        if status == errSecItemNotFound || status == errSecSuccess || status == errSecInteractionNotAllowed {
            var attributes = baseQuery()
            attributes[kSecAttrAccount as String] = key
            attributes[kSecValueData as String] = data

            if requireUserpresence {
                if let accessControl = SecAccessControlCreateWithFlags(
                  nil,
                  kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
                  .biometryCurrentSet,
                    nil) {
                    attributes[kSecAttrAccessControl as String] = accessControl
                }
            } else {
                attributes[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
            }

            let status = SecItemAdd(attributes as CFDictionary, nil)
            guard status == errSecSuccess else {
                throw KeyChainError.securityError(status: status)
            }
        } else {
            throw KeyChainError.securityError(status: status)
        }
    }

    func data(forKey key: String, requireUserpresence: Bool) throws -> Data? {
        var query = baseQuery()

        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnData as String] = true

        query[kSecAttrAccount as String] = key
        if requireUserpresence {
            let context = LAContext()
            context.localizedReason = authenticationPrompt
            query[kSecUseAuthenticationContext as String] = LAContext()
        }

        var dataRef: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &dataRef)

        if status == errSecItemNotFound {
            return nil
        }

        guard status == errSecSuccess else {
            throw KeyChainError.securityError(status: status)
        }
        guard let data = dataRef as? Data else {
            throw KeyChainError.unexpectedError
        }
        return data
    }

    func removeItem(forKey key: String) throws {
        var query = baseQuery()
        query[kSecAttrAccount as String] = key

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeyChainError.securityError(status: status)
        }
    }

    func removeAllItems() throws {
        let query = baseQuery()
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeyChainError.securityError(status: status)
        }
    }

    private func baseQuery() -> [String: Any] {
        var query: [String: Any] = [:]

        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrSynchronizable as String] = kSecAttrSynchronizableAny
        query[kSecAttrService as String] = service
        #if !targetEnvironment(simulator)
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup
        }
        #endif

        return query
    }
}
