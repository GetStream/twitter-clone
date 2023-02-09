import Foundation
import XCTest
import Auth

final class TwitterCloneAuthTests: XCTestCase {

    func test_auth_integration() async throws {

    }

    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        // swiftlint:disable:next force_unwrapping
      return String((0..<length).map { _ in letters.randomElement()! })
    }
}
