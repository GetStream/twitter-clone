//
//  SpacesStartListeningView.swift
//  Spaces
//
//  Created by amos.gyamfi@getstream.io on 9.2.2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI

public struct SpacesStartListeningView: View {
    let spacesProfileImage = ["zoey", "jeroen", "nash", "amos", "stefan", "martin", "profile10", "carla", "fra", "thierry", "profile2", "profile3", "cooper", "profile4", "george"]
    let spacesRole = ["🔉 Host", "🔇 Co-host", "🔇 Speaker", "Listener", "Listener", "Listener", "🔇 Speaker", "Listener", "🔇 Speaker", "🔇 Speaker", "Listener", "Listener", "Listener", "Listener", "Listener"]
    let spacesParticipant = ["@zoey", "Jeroen", "@nash", "@amos", "stefan", "Martin", "profile10", "Carla", "Fra", "Thierry", "profile2", "@Profile3", "@cooper", "profile4", "george"]
    
    let gridColumns = [GridItem(.adaptive(minimum: 80))]
    var vSpacing: CGFloat = 24.0
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            
            VStack {
                HStack{
                    VStack(alignment: .leading) {
                        Text("Swift and Coffee")
                            .font(.headline)
                            .bold()
                        Text("#Swift💞")
                            .font(.headline)
                            .bold()
                            .foregroundColor(.streamBlue)
                    }
                    
                    Spacer()
                }
                
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
                
                
                VStack {
                    Button {
                        
                    } label: {
                        Text("190 other listeners")
                            .padding(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(.systemGray), lineWidth: 2)
                            )
                        
                    }
                    .buttonStyle(.plain)
                    
                    Text("Your mic will be off to start")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                
                Button {
                    //
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24)
                            .frame(width: 300, height: 48)
                            .cornerRadius(24)
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(
                                        colors: [.spacesBlue, .spacesViolet]), startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                        Text("Start listening")
                            .foregroundColor(.white)
                    }
                }
                
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }
            }
        }
    }
}

struct SpacesStartListeningView_Previews: PreviewProvider {
    static var previews: some View {
        SpacesStartListeningView()
    }
}
