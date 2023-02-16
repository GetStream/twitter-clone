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
    @Environment(\.colorScheme) var colorScheme
    
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
                    .font(.subheadline)
                Text(" * 3k going")
                    .font(.subheadline)
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.white)
                }
            }
            .foregroundColor(.white)
            .padding()
            
            Text("Become an iOS Developer 👨🏾‍💻")
                .font(.title3)
                .bold()
                .foregroundColor(.white)
                .padding(.horizontal)
            
            ZStack { // For the sake of bottom padding
                Button {
                    
                } label: {
                    Text("Set reminder")
                        .bold()
                        .padding(EdgeInsets(top: 8, leading: 50, bottom: 8, trailing: 50))
                        .background(.white)
                        .cornerRadius(20)
                }
            }.padding(.bottom)
            
            HStack {
                Image("profile10")
                    .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 4))
                Text("Akua Serwaa")
                    .font(.footnote)
                Image(systemName: "checkmark.seal.fill")
                Text("Host")
                    .font(.footnote)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(.streamBlue)
                    .cornerRadius(4)
                
                Spacer()
            }
            .foregroundColor(.white)
            .background(colorScheme == .light ? .lowerBarLight : .lowerBarDark)
        }
        .background(LinearGradient(gradient: Gradient(colors: [colorScheme == .light ? .streamLightStart : .streamDarkStart, colorScheme == .light ? .streamLightEnd : .streamDarkEnd]), startPoint: .top, endPoint: .bottom))
        .cornerRadius(12)
    }
}

struct SpacesScheduledView_Previews: PreviewProvider {
    static var previews: some View {
        SpacesScheduledView()
    }
}
