import SwiftUI

struct TextItem: Identifiable, Codable {
    let id: UUID
    var text: String
    var colorComponents: ColorComponents // Store color components
    var fontName: String // Store font name
    var fontSize: CGFloat
    var offset: CGSize
    var initialOffset: CGSize
    var scale: CGFloat
    var rotationDegrees: Double // Store rotation as degrees (Double)
    var width: CGFloat
    var height: CGFloat
    var originalWidth: CGFloat
    var originalHeight: CGFloat

    // Computed properties for Color and Font
    var color: Color {
        get { colorComponents.color } // Now correctly uses the .color computed property
        set { colorComponents = ColorComponents(newValue) }
    }

    var font: Font {
        get { Font.custom(fontName, size: fontSize) }
        set {
            // Extract font name and size from the Font
            let uiFont = UIFont(name: fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
            let fontDescriptor = uiFont.fontDescriptor
            fontName = fontDescriptor.fontAttributes[.family] as? String ?? "Arial"
            fontSize = (fontDescriptor.fontAttributes[.size] as? CGFloat) ?? 20
        }
    }

    // Computed property to get/set rotation as Angle
    var rotation: Angle {
        get { Angle(degrees: rotationDegrees) }
        set { rotationDegrees = newValue.degrees }
    }

    // Initializer
    init(id: UUID = UUID(), text: String, color: Color, font: Font, offset: CGSize, initialOffset: CGSize = .zero, scale: CGFloat, rotation: Angle = .zero, width: CGFloat, height: CGFloat, originalWidth: CGFloat, originalHeight: CGFloat) {
        self.id = id
        self.text = text
        self.colorComponents = ColorComponents(color)
        self.fontName = ""
        self.fontSize = 20
        self.offset = offset
        self.initialOffset = initialOffset
        self.scale = scale
        self.rotationDegrees = rotation.degrees
        self.width = width
        self.height = height
        self.originalWidth = originalWidth
        self.originalHeight = originalHeight

        // Extract font name and size from the Font
        self.font = font // Set the font using the computed property setter
    }

    // CodingKeys enum
    enum CodingKeys: String, CodingKey {
        case id, text, colorComponents, fontName, fontSize, offset, initialOffset, scale, rotationDegrees, width, height, originalWidth, originalHeight
    }

    // Decoding method
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        text = try container.decode(String.self, forKey: .text)
        colorComponents = try container.decode(ColorComponents.self, forKey: .colorComponents)
        fontName = try container.decode(String.self, forKey: .fontName)
        fontSize = try container.decode(CGFloat.self, forKey: .fontSize)
        offset = try container.decode(CGSize.self, forKey: .offset)
        initialOffset = try container.decode(CGSize.self, forKey: .initialOffset)
        scale = try container.decode(CGFloat.self, forKey: .scale)
        rotationDegrees = try container.decode(Double.self, forKey: .rotationDegrees)
        width = try container.decode(CGFloat.self, forKey: .width)
        height = try container.decode(CGFloat.self, forKey: .height)
        originalWidth = try container.decode(CGFloat.self, forKey: .originalWidth)
        originalHeight = try container.decode(CGFloat.self, forKey: .originalHeight)
    }

    // Encoding method
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(text, forKey: .text)
        try container.encode(colorComponents, forKey: .colorComponents)
        try container.encode(fontName, forKey: .fontName)
        try container.encode(fontSize, forKey: .fontSize)
        try container.encode(offset, forKey: .offset)
        try container.encode(initialOffset, forKey: .initialOffset)
        try container.encode(scale, forKey: .scale)
        try container.encode(rotationDegrees, forKey: .rotationDegrees)
        try container.encode(width, forKey: .width)
        try container.encode(height, forKey: .height)
        try container.encode(originalWidth, forKey: .originalWidth)
        try container.encode(originalHeight, forKey: .originalHeight)
    }
}
