//
//  MediaPickerView.swift
//  Profile
//
//  Created by amos.gyamfi@getstream.io on 31.1.2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI
import PhotosUI

public class MediaPickerViewModel: ObservableObject {
    @Published public var mimetype: String?
    @Published public var imageData: Data?
}

public struct MediaPickerView: View {
    @ObservedObject
    private var viewModel: MediaPickerViewModel
    
    @State var selectedItem: PhotosPickerItem?
    // Store information about the selected photo that might be there or missing
    @State var data: Data?
    
    public init(viewModel: MediaPickerViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack {
            if let data = data, let uiimage = UIImage(data: data) {
                Image(uiImage: uiimage)
                    .resizable()
            }
            
            PhotosPicker(
                selection: $selectedItem,
                matching: .images
            ) {
                Image(systemName: "photo.on.rectangle.angled")
                    .accessibilityLabel("Photo picker")
                    .accessibilityAddTraits(.isButton)
            }
            .onChange(of: selectedItem) { newItem in
                Task {
                    viewModel.imageData = try? await newItem?.loadTransferable(type: Data.self)
                    viewModel.mimetype = newItem?.supportedContentTypes.first?.preferredMIMEType
                }
            }
        }
    }
}

//struct MediaPickerView_Previews: PreviewProvider {
//    static var previews: some View {
//        MediaPickerView()
//    }
//}
