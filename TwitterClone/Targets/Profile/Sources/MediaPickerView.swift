//
//  MediaPickerView.swift
//  Profile
//
//  Created by amos.gyamfi@getstream.io on 31.1.2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI
import PhotosUI

public struct MediaPickerView: View {
    @State var selectedItems: [PhotosPickerItem] = []
    // Store information about the selected photo that might be there or missing
    @State var data: [Data] = []
    
    public init() {}
    
    public var body: some View {
        VStack {
            if let data = data.first, let uiimage = UIImage(data: data) {
                Image(uiImage: uiimage)
                    .resizable()
            }
            
            PhotosPicker(
                selection: $selectedItems,
                maxSelectionCount: 1,
                matching: .images
            ) {
                Image(systemName: "photo.on.rectangle.angled")
                    .accessibilityLabel("Photo picker")
                    .accessibilityAddTraits(.isButton)
            }
            .onChange(of: selectedItems) { newItems in
                data.removeAll()
                for newItem in newItems {
                    Task {
                        if let data = try? await newItem.loadTransferable(type: Data.self) {
                            self.data.append(data)
                        }
                    }
                }
            }
        }
    }
}

struct MediaPickerView_Previews: PreviewProvider {
    static var previews: some View {
        MediaPickerView()
    }
}
