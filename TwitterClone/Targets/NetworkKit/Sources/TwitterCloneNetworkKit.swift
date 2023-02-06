import Foundation
import os.log

public enum StatusCodeError: Error {
case badResponse
case serverError
case unauthorized

case unhandled

case noStatus
}

public extension OSLog {
    // swiftlint:disable:next force_unwrapping
    private static var subsystem = Bundle.main.bundleIdentifier!

    /// Logs the view cycles like viewDidLoad.
    static let networkPayloadLog = ProcessInfo.processInfo.arguments.contains("NETWORK_PAYLOAD_LOGGING_ENABLED") ? OSLog(subsystem: subsystem, category: "payload") : .disabled
}

public final class TwitterCloneNetworkKit {
    /// Checks the status code for errors
    /// - Parameter statusCode: The response status code to check. If it does not throw it is an acceptable status.
    public static func checkStatusCode(statusCode: Int?) throws {
        guard let statusCode = statusCode else {
            throw StatusCodeError.noStatus
        }

        switch statusCode {
        case 500:
            throw StatusCodeError.badResponse
        case 400:
            throw StatusCodeError.unauthorized
        case 200, 201:
            return
        default:
            throw StatusCodeError.unhandled
        }
    }

    public static var jsonEncoder: JSONEncoder {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        return jsonEncoder
    }

    public static var jsonDecoder: JSONDecoder {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601WithFractionalSeconds
        return jsonDecoder
    }

    public static var cachingRestSession: URLSession = {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.urlCache = URLCache(memoryCapacity: 50_000_000, diskCapacity: 300_000_000)
        return URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
    }()

    public static var restSession: URLSession = {
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
    }()
}

extension Formatter {
   static var customDateFormatter: DateFormatter = {
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
       dateFormatter.timeZone = .gmt
       return dateFormatter
   }()

    static var customISO8601DateFormatter: ISO8601DateFormatter = {
      let formatter = ISO8601DateFormatter()
      formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
      return formatter
   }()

}

extension JSONDecoder.DateDecodingStrategy {
   static var iso8601WithFractionalSeconds = custom { decoder in
      let dateStr = try decoder.singleValueContainer().decode(String.self)
      let customDateFormatter = Formatter.customDateFormatter
      if let date = customDateFormatter.date(from: dateStr) {
         return date
      } else if let date = Formatter.customISO8601DateFormatter.date(from: dateStr) {
          return date
      }
      throw DecodingError.dataCorrupted(
               DecodingError.Context(codingPath: decoder.codingPath,
                                     debugDescription: "Invalid date"))
   }
}
