//
//  InfoMessage.swift
//  Spaces
//
//  Created by Stefan Blos on 01.03.23.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import Foundation

enum InfoMessageType {
    case information, error
}

struct InfoMessage: Identifiable {
    var id = UUID()
    var text: String
    var type: InfoMessageType = .information
}
