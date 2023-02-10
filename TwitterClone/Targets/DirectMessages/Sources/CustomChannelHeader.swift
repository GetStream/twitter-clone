//
// Copyright © 2023 Stream.io Inc. All rights reserved.
//

import NukeUI
import StreamChat
import StreamChatSwiftUI
import SwiftUI

public struct CustomChannelHeader: ToolbarContent {

    @Injected(\.fonts) var fonts
    @Injected(\.images) var images
    @Injected(\.colors) var colors

    var title: String
    var currentUserController: CurrentChatUserController
    @Binding var isNewChatShown: Bool

    @MainActor
    public var body: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text(title)
                .font(fonts.bodyBold)
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                isNewChatShown = true
                notifyHideTabBar()
            } label: {
                Image(uiImage: images.messageActionEdit)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color.white)
                    .padding(.all, 8)
                    .background(colors.tintColor)
                    .clipShape(Circle())
            }
        }
    }
}

struct CustomChannelModifier: ChannelListHeaderViewModifier {

    @Injected(\.chatClient) var chatClient

    var title: String

    @State var isNewChatShown = false

    func body(content: Content) -> some View {
        ZStack {
            content.toolbar {
                CustomChannelHeader(
                    title: title,
                    currentUserController: chatClient.currentUserController(),
                    isNewChatShown: $isNewChatShown
                )
            }

            NavigationLink(isActive: $isNewChatShown) {
                NewChatView(isNewChatShown: $isNewChatShown)
            } label: {
                EmptyView()
            }
            .isDetailLink(false)
        }
    }
}
