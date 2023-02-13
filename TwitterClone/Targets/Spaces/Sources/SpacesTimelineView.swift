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
    public init() {}
    @State private var searchSpaces = "Search spaces"
    @State private var isShowingSpacesWelcome = false
    @State private var isShowingSpacesStartListening = false
    
    public var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Happening Now")
                            .font(.title2)
                            .bold()
                        Text("Spaces going on right now")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Button {
                            isShowingSpacesStartListening.toggle()
                        } label: {
                            SpacesLiveView()
                        }
                        .buttonStyle(.plain)
                        .sheet(isPresented: $isShowingSpacesStartListening) {
                            SpacesStartListeningView()
                                .presentationDetents([.fraction(0.9)])
                        }
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading) {
                        Text("Get these in your calendar")
                            .font(.title2)
                            .bold()
                        Text("People you follow will be tuning in")
                            .font(.subheadline)
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
                            .font(.subheadline)
                            .bold()
                        SpacesLiveView()
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
                
                HStack {
                    Spacer()
                    SpacesCircularButton()
                        .padding(.horizontal, 12)
                }
                
//                SpacesTabBarView()
//                    .frame(height: 48)
            }
        }
    }
}

//struct SpacesTimelineView_Previews: PreviewProvider {
//    static var previews: some View {
//        SpacesTimelineView()
//    }
//}
