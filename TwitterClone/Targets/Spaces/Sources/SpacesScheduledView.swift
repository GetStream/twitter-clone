//
//  SpacesLiveView.swift
//  Spaces
//
//  Created by amos.gyamfi@getstream.io on 8.2.2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI
import TwitterCloneUI

public struct SpacesScheduledView: View {
    public init() {}
    
    func getTomorrowDate() -> String {
        let today = Date()
        guard let future = Calendar.current.date(byAdding: .day, value: 25, to: today) else {
            return "-"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: future)
    }
    
    public var body: some View {
        VStack {
            HStack {
                Image(systemName: "calendar")
                Text(getTomorrowDate())
                Text(" * 3k going")
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                }
            }
            .padding()
            
            Text("Become an iOS Developer 👨🏾‍💻")
                .font(.title2)
                .bold()
                .padding(.horizontal)
            
            ZStack { // For the sake of bottom padding
                Button {
                    
                } label: {
                    Text("Set reminder")
                        .bold()
                        .padding(EdgeInsets(top: 16, leading: 100, bottom: 16, trailing: 100))
                        .background(.white)
                        .cornerRadius(24)
                }
            }.padding(.bottom)
            
            HStack {
                Image("profile10")
                    .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 4))
                Text("Akua Serwaa")
                Image(systemName: "checkmark.seal.fill")
                Text("Host")
                    .padding(.horizontal, 8)
                    .background(.streamBlue)
                    .cornerRadius(4)
                
                Spacer()
            }
            .background(.streamBlue.opacity(0.5))
        }
        .background(.streamBlue.opacity(0.5))
        .cornerRadius(12)
    }
}

struct SpacesScheduledView_Previews: PreviewProvider {
    static var previews: some View {
        SpacesScheduledView()
    }
}
