//
//  TwitterCloneDateFormatter.swift
//  TimelineUI
//
//  Created by Jeroen Leenarts on 07/02/2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import Foundation

extension Formatter {
   public static var uiDateFormatter: DateFormatter = {
       let dateFormatter = DateFormatter()
       dateFormatter.dateStyle = .medium
       dateFormatter.timeStyle = .none
       return dateFormatter
   }()
}
