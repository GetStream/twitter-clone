//
//  SpacesListeningNowView.swift
//  Spaces
//
//  Created by amos.gyamfi@getstream.io on 11.2.2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI
import TwitterCloneUI

public struct SpacesListeningNowView: View {
    public init() {}
    @Environment(\.colorScheme) var colorScheme
    
    let spacesProfileImage = ["zoey", "jeroen", "nash", "amos", "stefan", "martin", "profile10", "carla", "fra", "thierry", "profile2", "profile3", "cooper", "profile4", "george"]
    let spacesRole = ["🔉 Host", "🔇 Co-host", "🔇 Speaker", "Listener", "Listener", "Listener", "🔇 Speaker", "Listener", "🔇 Speaker", "🔇 Speaker", "Listener", "Listener", "Listener", "Listener", "Listener"]
    let spacesParticipant = ["@zoey", "Jeroen", "@nash", "@amos", "stefan", "Martin", "profile10", "Carla", "Fra", "Thierry", "profile2", "@Profile3", "@cooper", "profile4", "george"]
    
    let gridColumns = [GridItem(.adaptive(minimum: 80))]
    var vSpacing: CGFloat = 24.0
    
    let heartPlus = UIImage(named: "heart_plus")
    
    @State private var isShowingReactionsMenu = false
    
    public var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("LIVE").font(.caption).foregroundColor(.spacesViolet) + Text(" * 177 listening").font(.caption)
                Text("While we wait for more content 🥰")
                    .font(.headline)
                    .bold()
                
                ZStack {
                    LazyVGrid(columns: gridColumns, spacing: vSpacing) {
                        ForEach(0..<spacesProfileImage.count, id: \.self) { index in
                            VStack {
                                Image(spacesProfileImage[index])
                                    .resizable()
                                    .clipShape(Circle())
                                    .scaledToFit()
                                    .frame(width: 54, height: 54)
                                
                                Text(spacesParticipant[index])
                                    .font(.caption)
                                    .bold()
                                
                                Text(spacesRole[index])
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    // Show reaction animation
                    SpacesReactionAnimation()
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 146, trailing: 102))
                }
                
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(role: .destructive) {
                        // Dismiss sheet to browse
                    } label: {
                        Image(systemName: "chevron.down")
                            .bold()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            // Invite via DM
                        } label: {
                            Text("Invite via DM")
                            Image(systemName: "paperplane")
                        }
                        
                        Button {
                            // Copy link
                        } label: {
                            Text("Copy link")
                            Image(systemName: "link")
                        }
                        
                        Button {
                            // Invite via DM
                        } label: {
                            Text("Share via...")
                            Image(systemName: "square.and.arrow.up")
                        }
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .bold()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            // About Spaces
                        } label: {
                            Text("About Spaces")
                            Image(systemName: "waveform.and.mic")
                        }
                        
                        Button {
                            // Adjust settings
                        } label: {
                            Text("Adjust settings")
                            Image(systemName: "gearshape")
                        }
                        
                        Button {
                            // Share feedback
                        } label: {
                            Text("Share feedback")
                            Image(systemName: "ellipsis.bubble")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .bold()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(role: .destructive) {
                        // Leave the joined Spaces
                    } label: {
                        Text("Leave")
                            .foregroundColor(Color(.systemRed))
                    }
                    .buttonStyle(.plain)
                }
                
                ToolbarItemGroup(placement: .bottomBar) {
                    Button {
                        // Request to speak
                    } label: {
                        VStack {
                            ZStack {
                                Image(systemName: "circle")
                                    .font(.largeTitle)
                                    .foregroundColor(Color(.systemGray))
                                Text("🎙️")
                            }
                            Text("Request")
                        }
                    }
                    
                    Button {
                        //
                    } label: {
                        Image(systemName: "person.2")
                            .bold()
                    }
                    
                    Button {
                        isShowingReactionsMenu.toggle()
                    } label: {
                        Image("heartPlusIcon")
                    }
                    .sheet(isPresented: $isShowingReactionsMenu) {
                        SpacesReactionsMenu()
                            .presentationDetents([.fraction(0.25)])
                            .clearModalBackground()
                    }
                    
                    Spacer()
                    
                    Button {
                        // Leave the joined Spaces
                    } label: {
                        Image(systemName: "bubble.left")
                        Text("6")
                    }
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6))
                    .background(LinearGradient(gradient: Gradient(colors: [colorScheme == .light ? .streamLightStart : .streamDarkStart, colorScheme == .light ? .streamLightEnd : .streamDarkEnd]), startPoint: .top, endPoint: .bottom))
                    .cornerRadius(16)
                }
            }.padding()
        }
    }
}

struct SpacesListeningNowView_Previews: PreviewProvider {
    static var previews: some View {
        SpacesListeningNowView()
    }
}
