//
//  InfoMessageView.swift
//  Spaces
//
//  Created by Stefan Blos on 01.03.23.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI

struct InfoMessageView: View {
    
    var infoMessage: InfoMessage
    
    var iconName: String {
        switch infoMessage.type {
        case .information:
            return "info.circle"
        case .error:
            return "xmark.circle"
        }
    }
    
    var iconColor: Color {
        switch infoMessage.type {
        case .information:
            return .secondary
        case .error:
            return .red.opacity(0.5)
        }
    }
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .resizable()
                .frame(width: 32, height: 32)
                .foregroundColor(iconColor)
            
            Text(infoMessage.text)
                .frame(maxWidth: .infinity)
        }
        .padding()
    }
}

struct InfoMessageView_Previews: PreviewProvider {
    static var previews: some View {
        InfoMessageView(infoMessage: InfoMessage(text: "You were just re-connected to the space, nothing to do here."))
        
        InfoMessageView(infoMessage: InfoMessage(text: "An error occurred: Please try again later.", type: .error))
    }
}
