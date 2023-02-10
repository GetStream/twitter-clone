//
//  DirectMessagesView.swift
//  DirectMessages
//
//  Created by Jeroen Leenarts on 10/02/2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI
import StreamChatSwiftUI

public struct DirectMessagesView: View {
    
    public init() {}
    
    public var body: some View {
        ChatChannelListView(viewFactory: DemoAppFactory.shared)
    }
}

struct DirectMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        DirectMessagesView()
    }
}
