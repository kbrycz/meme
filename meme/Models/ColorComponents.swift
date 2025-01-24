import SwiftUI

struct ColorComponents: Codable {
    var red: Double
    var green: Double
    var blue: Double
    var opacity: Double

    init(_ color: Color) {
        if let components = UIColor(color).cgColor.components, components.count >= 3 {
            red = Double(components[0])
            green = Double(components[1])
            blue = Double(components[2])
            opacity = (components.count > 3) ? Double(components[3]) : 1.0
        } else {
            red = 0
            green = 0
            blue = 0
            opacity = 1
        }
    }
    
    var color: Color {
        Color(red: red, green: green, blue: blue, opacity: opacity)
    }
}
