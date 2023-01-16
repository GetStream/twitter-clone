import Foundation
import XCTest
import TwitterCloneAuth

final class TwitterCloneAuthTests: XCTestCase {
    
    func test_auth_integration() async throws {
        let auth = TwitterCloneAuth()
        let username = "test_" + randomString(length: 8)
        _ = try await auth.signup(username: username, password: "password")
        let authUser = try await auth.login(username: username, password: "password")
        
        XCTAssertEqual(authUser.username, username)
    }
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
