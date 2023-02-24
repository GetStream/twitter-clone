//
//  BlueCustomThemes.swift
//  Profile
//
//  Created by amos.gyamfi@getstream.io on 20.2.2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI

public struct BlueCustomThemes: View {
    public init() {}
    
    public var body: some View {
        NavigationStack {
            VStack {
                Text("Choose a theme color for your Twitter experience that can only be seen by you.")
                    .font(.caption)
                
                VStack {
                    HStack {
                        VStack{
                            Button {
                                //
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 17)
                                        .frame(width: 80, height: 34)
                                        .foregroundColor(Color(.systemBlue))
                                    Text("Blue")
                                        .foregroundColor(.white)
                                }
                                .padding(.bottom, 8)
                            }
                            .buttonStyle(.plain)
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color(.systemGreen))
                        }
                        
                        VStack{
                            Button {
                                //
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 17)
                                        .frame(width: 80, height: 34)
                                        .foregroundColor(Color(.systemYellow))
                                    Text("Yellow")
                                        .foregroundColor(.white)
                                }
                                .padding(.bottom, 8)
                            }
                            .buttonStyle(.plain)
                            Image(systemName: "circle")
                                .foregroundColor(Color(.systemGray))
                        }
                        
                        VStack{
                            Button {
                                //
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 17)
                                        .frame(width: 80, height: 34)
                                        .foregroundColor(Color(.systemRed))
                                    Text("Red")
                                        .foregroundColor(.white)
                                }
                                .padding(.bottom, 8)
                            }
                            .buttonStyle(.plain)
                            Image(systemName: "circle")
                                .foregroundColor(Color(.systemGray))
                        }
                    }
                    
                    HStack {
                        VStack{
                            Button {
                                //
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 17)
                                        .frame(width: 80, height: 34)
                                        .foregroundColor(Color(.systemPurple))
                                    Text("Purple")
                                        .foregroundColor(.white)
                                }
                                .padding(.bottom, 8)
                            }
                            .buttonStyle(.plain)
                            Image(systemName: "circle")
                                .foregroundColor(Color(.systemGray))
                        }
                        
                        VStack {
                            Button {
                                //
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 17)
                                        .frame(width: 80, height: 34)
                                        .foregroundColor(Color(.systemOrange))
                                    Text("Orange")
                                        .foregroundColor(.white)
                                }
                                .padding(.bottom, 8)
                            }
                            .buttonStyle(.plain)
                            Image(systemName: "circle")
                                .foregroundColor(Color(.systemGray))
                        }
                        
                        VStack{
                            Button {
                                //
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 17)
                                        .frame(width: 80, height: 34)
                                        .foregroundColor(Color(.systemGreen))
                                    Text("Green")
                                        .foregroundColor(.white)
                                }
                                .padding(.bottom, 8)
                            }
                            .buttonStyle(.plain)
                            Image(systemName: "circle")
                                .foregroundColor(Color(.systemGray))
                        }
                    }
                    .padding(.top)
                }
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Theme")
                            .font(.title3)
                            .bold()
                        Text("@stefanjblos")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}

struct BlueCustomThemes_Previews: PreviewProvider {
    static var previews: some View {
        BlueCustomThemes()
    }
}
