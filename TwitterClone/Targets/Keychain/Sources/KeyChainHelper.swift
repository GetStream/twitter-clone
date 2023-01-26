import Foundation

public protocol KeyChainHelperProtocol: AnyObject {
    func string(forKey key: String, requireUserpresence: Bool) -> String?
    func data(forKey key: String, requireUserpresence: Bool) -> Data?
    func setString(_ string: String?, forKey key: String, requireUserpresence: Bool)
    func setData(_ data: Data?, forKey key: String, requireUserpresence: Bool)
    func removeKey(_ key: String)
    func allItems() -> [Any]?
}

public final class KeyChainHelper: KeyChainHelperProtocol {
    private let store = SwiftKeyChainStore(service: Bundle.main.bundleIdentifier)

    public static let shared = KeyChainHelper()

    public func string(forKey key: String, requireUserpresence: Bool) -> String? {
        try? store.string(forKey: key, requireUserpresence: requireUserpresence)
    }

    public func data(forKey key: String, requireUserpresence: Bool) -> Data? {
        try? store.data(forKey: key, requireUserpresence: requireUserpresence)
    }

    public func setString(_ string: String?, forKey key: String, requireUserpresence: Bool) {
        try? store.setString(string, forKey: key, requireUserpresence: requireUserpresence)
    }

    public func setData(_ data: Data?, forKey key: String, requireUserpresence: Bool) {
        try? store.setData(data, forKey: key, requireUserpresence: requireUserpresence)
    }

    public func removeKey(_ key: String) {
        try? store.removeItem(forKey: key)
    }

    public func allItems() -> [Any]? {
        return store.allItems
    }

    public func exists(_ key: String) -> Bool {
        return store.exists(forKey: key)
    }
}
