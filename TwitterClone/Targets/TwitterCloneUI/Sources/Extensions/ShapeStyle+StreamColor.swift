import Foundation
import SwiftUI

// Color extensions
public extension ShapeStyle where Self == Color {
    static var streamBlue: Color {
        Color(red: 0.00, green: 0.37, blue: 1.00)
    }
    
    static var streamGreen: Color {
        Color(red: 0.125, green: 0.88, blue: 0.439)
    }
    
    static var spacesViolet: Color {
        Color(red: 0.125, green: 0.88, blue: 0.439)
    }
    
    static var spacesBlue: Color {
        Color(red: 0.00, green: 0.37, blue: 1.00)
    }
    
    static var streamLightStart: Color {
        Color(red: 1 / 255, green: 157 / 255, blue: 255 / 255)
    }
    
    static var streamLightEnd: Color {
        Color(red: 1 / 255, green: 104 / 255, blue: 255 / 255)
    }
    
    static var streamDarkStart: Color {
        Color(red: 1 / 255, green: 157 / 255, blue: 255 / 255, opacity: 0.5)
    }
    
    static var streamDarkEnd: Color {
        Color(red: 1 / 255, green: 104 / 255, blue: 255 / 255, opacity: 0.5)
    }
    
    static var lowerBarLight: Color {
        Color(red: 0.0627, green: 0.3765, blue: 0.8588)
    }
    
    static var lowerBarDark: Color {
        Color(red: 0.0, green: 95 / 255, blue: 1.0, opacity: 0.6)
    }
}

// Sheet background remover
public struct ClearBackgroundView: UIViewRepresentable {
    public func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }
    public func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}

public struct ClearBackgroundViewModifier: ViewModifier {
    
    public func body(content: Content) -> some View {
        content
            .background(ClearBackgroundView())
    }
}

public extension View {
    func clearModalBackground() -> some View {
        self.modifier(ClearBackgroundViewModifier())
    }
}

