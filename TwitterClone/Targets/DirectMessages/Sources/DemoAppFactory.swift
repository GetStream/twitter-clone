//
// Copyright © 2023 Stream.io Inc. All rights reserved.
//

import StreamChat
import StreamChatSwiftUI
import SwiftUI

public class DemoAppFactory: ViewFactory {

    @Injected(\.chatClient) public var chatClient

    private init() {}

    public static let shared = DemoAppFactory()

    public func makeChannelListHeaderViewModifier(title: String) -> some ChannelListHeaderViewModifier {
        CustomChannelModifier(title: title)
    }
}

struct CustomChannelDestination: View {

    var channel: ChatChannel

    var body: some View {
        VStack {
            Text("This is the channel \(channel.name ?? "")")
        }
    }
}

