//
//  SpacesLiveView.swift
//  Spaces

import SwiftUI
import TwitterCloneUI

public struct SpacesLiveView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var viewModel: SpacesViewModel
    
    @State private var isShowingSpacesStartListening = false
    
    public init(spacesViewModel: SpacesViewModel) {
        self.viewModel = spacesViewModel
    }
    
    public var body: some View {
        Button {
            isShowingSpacesStartListening.toggle()
        } label: {
            VStack(alignment: .leading) {
                HStack(spacing: 0) {
                    SoundIndicatorView()
                        .scaleEffect(0.3)
                    Text("LIVE")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.title3)
                            .bold()
                            .foregroundColor(.white)
                    }
                }
                .padding()
                
                Text("The iOS Talk Show 👩‍💻")
                    .font(.title3)
                    .bold()
                    .padding(.horizontal)
                    .foregroundColor(.white)
                
                HStack {
                    HStack(spacing: -20) {
                        Image("thierry")
                            .resizable()
                            .clipShape(Circle())
                            .scaledToFit()
                            .frame(width: 42, height: 42)
                            .zIndex(3)
                        Image("zoey")
                            .resizable()
                            .clipShape(Circle())
                            .scaledToFit()
                            .frame(width: 42, height: 42)
                            .zIndex(2)
                        Image("nash")
                            .resizable()
                            .clipShape(Circle())
                            .scaledToFit()
                            .frame(width: 42, height: 42)
                            .zIndex(1)
                    }
                    Text("89 listening")
                        .font(.caption)
                        .foregroundColor(.white)
                }.padding(.horizontal)
                
                HStack {
                    Image("profile5")
                        .padding()
                    Text("Jeroen Lenarts")
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
        .buttonStyle(.plain)
        .sheet(isPresented: $isShowingSpacesStartListening) {
            SpacesStartListeningView(viewModel: viewModel)
                .presentationDetents([.fraction(0.9)])
        }
        .cornerRadius(12)
    }
}

struct SpacesLiveView_Previews: PreviewProvider {
    static var previews: some View {
        SpacesLiveView(spacesViewModel: .preview)
    }
}
