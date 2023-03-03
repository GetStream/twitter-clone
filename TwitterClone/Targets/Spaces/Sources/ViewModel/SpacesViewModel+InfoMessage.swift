//
//  SpacesViewModel+InfoMessage.swift
//  Spaces
//
//  Created by Stefan Blos on 01.03.23.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI

extension SpacesViewModel {
    
    func setInfoMessage(text: String, type: InfoMessageType) {
        withAnimation(.easeOut) {
            infoMessage = InfoMessage(text: text, type: type)
        }
    }
    
    func resetInfoMessage() {
        withAnimation(.easeIn) {
            infoMessage = nil
        }
    }
    
}
