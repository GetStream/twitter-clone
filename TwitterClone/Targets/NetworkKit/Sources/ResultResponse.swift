//
//  ResultResponse.swift
//  NetworkKit
//
//  Created by Jeroen Leenarts on 26/01/2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import Foundation

public struct ResultResponse<ResultsType: Decodable>: Decodable {
    enum CodingKeys: String, CodingKey {
        case results
        case next
        case duration
    }

    public let results: ResultsType
    public let next: String
    public let duration: String

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        results = try container.decode(ResultsType.self, forKey: .results)
        next = try container.decode(String.self, forKey: .next)
        duration = try container.decode(String.self, forKey: .duration)
    }
}
