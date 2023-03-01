//
//  CreateSpaceView.swift
//  Spaces
//
//  Created by Stefan Blos on 16.02.23.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI

struct CreateSpaceView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var spacesViewModel: SpacesViewModel
    
    @State private var title = ""
    @State private var description = ""
    @State private var date = Date()
    @State private var happeningNow = true
    
    var necessaryInfoAvailable: Bool {
        return !title.isEmpty && !description.isEmpty
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("What is your space about?") {
                    TextField("Name of your space", text: $title)
                    
                    TextField("Description of your space", text: $description)
                }
                
                Section("When is your space happening?") {
                    Toggle("Now", isOn: $happeningNow)
                    
                    if !happeningNow {
                        DatePicker("Schedule for:", selection: $date, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                    }
                }
                
                Button {
                    spacesViewModel.createChannelForSpace(
                        title: title,
                        description: description,
                        happeningNow: happeningNow,
                        date: date
                    )
                    dismiss()
                } label: {
                    Text(happeningNow ? "Start" : "Schedule")
                }
                .disabled(!necessaryInfoAvailable)
                
            }
            .navigationTitle("Create Space")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundStyle(LinearGradient.spaceish)
                    }

                }
            }
        }
        
    }
}

struct CreateSpaceView_Previews: PreviewProvider {
    static var previews: some View {
        CreateSpaceView(spacesViewModel: .preview)
    }
}
