//
//  SpaceState.swift
//  Spaces
//
//  Created by Stefan Blos on 16.02.23.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import Foundation

enum SpaceState: String {
    case planned = "Planned", running = "Running", finished = "Finished"
    
    var cardString: String {
        switch self {
        case .planned:
            return "Planned"
        case .running:
            return "Live"
        case .finished:
            return "Ended"
        }
    }
}

extension SpaceState {
    
    static func from(_ string: String) -> SpaceState? {
        return SpaceState(rawValue: string)
    }
    
}
