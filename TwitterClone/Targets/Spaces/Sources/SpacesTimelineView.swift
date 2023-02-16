//
//  SpacesTimelineView.swift
//  Spaces
//
//  Created by amos.gyamfi@getstream.io on 7.2.2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI
import TwitterCloneUI

public struct SpacesTimelineView: View {
    
    @StateObject var spacesViewModel = SpacesViewModel()
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var searchSpaces = "Search spaces"
    @State private var isShowingSpacesWelcome = false
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Real spaces")
                            .font(.title3)
                            .bold()
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(spacesViewModel.spaces) { space in
                                    VStack {
                                        SpaceCard(space: space)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading) {
                        Text("Happening Now")
                            .font(.title3)
                            .bold()
                        Text("Spaces going on right now")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        SpacesLiveView(spacesViewModel: spacesViewModel)
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading) {
                        Text("Get these in your calendar")
                            .font(.title3)
                            .bold()
                        Text("People you follow will be tuning in")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Button {
                            isShowingSpacesWelcome.toggle()
                        } label: {
                            SpacesScheduledView()
                        }
                        .buttonStyle(.plain)
                        .sheet(isPresented: $isShowingSpacesWelcome) {
                            SpacesWelcomeView()
                                .presentationDetents([.fraction(0.6)])
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    VStack(alignment: .leading) {
                        Text("Trending")
                            .font(.title3)
                            .bold()
                        SpacesLiveView(spacesViewModel: spacesViewModel)
                    }
                    .padding()
                    
                    SpacesScheduledView()
                        .padding()
                }
                .searchable(text: $searchSpaces)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        ProfileImage(imageUrl: "https://picsum.photos/id/550/200/200", action: {})
                            .scaleEffect(0.7)
                    }
                    
                    ToolbarItem(placement: .principal) {
                        Text("Spaces")
                            .font(.title3)
                            .bold()
                    }
                }

                SpacesCircularButton(spacesViewModel: spacesViewModel)
                    .shadow(radius: 10)
                    .padding()
                
//                SpacesTabBarView()
//                    .frame(height: 48)
            }
        }
    }
}

struct SpacesTimelineView_Previews: PreviewProvider {
    static var previews: some View {
        SpacesTimelineView()
    }
}
