//
//  SpacesCreateStartNow.swift
//  Spaces
//
//  Created by amos.gyamfi@getstream.io on 17.2.2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI

public struct SpacesCreateStartNow: View {
    @State private var isShowingNameField = ""
    @State private var recordSpaceOn = false
    @State private var selectedTopic = "Technology"
    @State private var isSchedulingSpace = false
    @Environment(\.dismiss) var dismiss
    
    let topics = ["Technology", "Politics", "Design", "Life", "Sports", "Travel", "Outdoor", "Gaming", "Science"]
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            Form {
                Section{
                    TextField("What do you want to talk about?", text: $isShowingNameField, axis: .vertical)
                    
                } header: {
                    Text("Name your space")
                }
                
                Picker("Add topic", selection: $selectedTopic) {
                    ForEach(topics, id: \.self) {
                        Text($0)
                    }
                    .pickerStyle(.navigationLink)
                }
                Toggle("Record Space", isOn: $recordSpaceOn)
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        // Dismiss sheet
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Create Space")
                        .font(.subheadline)
                }
                
                ToolbarItemGroup(placement: .keyboard){
                    Button {
                        //
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 19)
                                .frame(width: 200, height: 38)
                                .cornerRadius(24)
                                .foregroundStyle(
                                    LinearGradient(
                                        gradient: Gradient(
                                            colors: [.spacesBlue, .spacesViolet]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                            Text("Start now")
                                .foregroundColor(.white)
                        }
                        .padding()
                    }
                    
                    Button {
                        // Add schedule Space action
                        isSchedulingSpace.toggle()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 19)
                                .stroke(lineWidth: 2)
                                .frame(width: 64, height: 38)
                                .foregroundStyle(
                                    LinearGradient(
                                        gradient: Gradient(
                                            colors: [.spacesBlue, .spacesViolet]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                           Image(systemName: "calendar.badge.plus")
                        }
                    }
                    .buttonStyle(.plain)
                    .sheet(isPresented: $isSchedulingSpace) {
                        SpacesCreateSchedule()
                            .presentationDetents([.fraction(0.6)])
                    }
                    
                }
            }
        }
    }
}

struct SpacesCreateStartNow_Previews: PreviewProvider {
    static var previews: some View {
        SpacesCreateStartNow()
    }
}
