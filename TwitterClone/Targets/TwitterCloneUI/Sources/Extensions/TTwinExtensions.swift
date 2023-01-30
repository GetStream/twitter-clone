
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
}

// Variable corner radius extension
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
