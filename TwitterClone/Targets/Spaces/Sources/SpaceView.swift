//
//  SpaceView.swift
//  Spaces
//
//  Created by Stefan Blos on 16.02.23.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI

struct SpaceView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var viewModel: SpacesViewModel
    
    var space: Space
    
    init(viewModel: SpacesViewModel) {
        guard let space = viewModel.selectedSpace else {
            // TODO: more gracious error handling
            fatalError("SpaceView didn't receive a space!")
        }
        self.space = space
        self.viewModel = viewModel
    }
    
    var buttonText: String {
        switch space.state {
        case .running:
            if viewModel.isInSpace {
                if viewModel.isHost {
                    return "End space"
                } else {
                    return "Leave space quietly"
                }
            } else {
                return "Join space"
            }
        case .planned:
            if viewModel.isHost {
                return "Start space"
            } else {
                return "Waiting for space to start"
            }
        case .finished:
            return "This space finished already"
        }
    }
    
    var buttonDisabled: Bool {
        if space.state == .finished {
            return true
        } else if space.state == .planned && !viewModel.isHost {
            return true
        }
        
        return false
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text(space.description)
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                Text("\(space.listeners.count) total listeners")
                    .padding(.vertical, 4)
                    .padding(.horizontal, 12)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(.gray, lineWidth: 2)
                    }
                
                if !viewModel.isInSpace {
                    Text("Your mic will be off to start")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Button {
                    if viewModel.isInSpace {
                        if viewModel.isHost {
                            viewModel.endSpace(with: space.id)
                        } else {
                            viewModel.leaveSpace(id: space.id)
                        }
                    } else {
                        if viewModel.isHost {
                            Task {
                                await viewModel.startSpace(id: space.id)
                            }
                        } else {
                            Task {
                                await viewModel.joinSpace(id: space.id)
                            }
                        }
                    }
                } label: {
                    Text(buttonText)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .background(
                            LinearGradient.spaceish,
                            in: Capsule()
                        )
                }
                .padding(.horizontal)
                .disabled(buttonDisabled)
                .opacity(buttonDisabled ? 0.4 : 1)
            }
            .padding()
            .navigationTitle(space.name)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        // TODO: disconnect from space
                        
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }
}

struct SpaceView_Previews: PreviewProvider {
    static var previews: some View {
        SpaceView(viewModel: .preview)
    }
}
