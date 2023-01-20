import Foundation

public enum StatusCodeError: Error {
case badResponse
case serverError
case unauthorized

case unhandled

case noStatus
}

public final class TwitterCloneNetworkKit {
    public static func hello() {
        print("Hello, from your Kit framework")
    }
    
    /// Checks the status code for errors
    /// - Parameter statusCode: The response status code to check. If it does not throw it is an acceptable status.
    static public func checkStatusCode(statusCode: Int?) throws {
        guard let statusCode = statusCode else {
            throw StatusCodeError.noStatus
        }
        
        switch statusCode {
        case 500:
            throw StatusCodeError.badResponse
        case 400:
            throw StatusCodeError.unauthorized
        case 200:
            return
        default:
            throw StatusCodeError.unhandled
        }
    }
    
    
    static public var jsonEncoder: JSONEncoder {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        return jsonEncoder
    }
    
    static public var jsonDecoder: JSONDecoder {
        return JSONDecoder()
    }
    
    static public var restSession: URLSession {
        /* Configure session, choose between:
         * defaultSessionConfiguration
         * ephemeralSessionConfiguration
         * backgroundSessionConfigurationWithIdentifier:
         And set session-wide properties, such as: HTTPAdditionalHeaders,
         HTTPCookieAcceptPolicy, requestCachePolicy or timeoutIntervalForRequest.
         */
        let sessionConfig = URLSessionConfiguration.ephemeral
        
        /* Create session, and optionally set a URLSessionDelegate. */
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        return session
    }
}
