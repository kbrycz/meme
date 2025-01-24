import SwiftUI

struct ImageItem: Identifiable, Codable {
    let id: UUID
    var imageData: Data
    var offset: CGSize
    var initialOffset: CGSize
    var scale: CGFloat
    var rotationDegrees: Double
    var width: CGFloat
    var height: CGFloat
    
    // Needed for pinch gestures:
    var originalWidth: CGFloat
    var originalHeight: CGFloat

    var image: UIImage? {
        UIImage(data: imageData)
    }

    var rotation: Angle {
        get { Angle(degrees: rotationDegrees) }
        set { rotationDegrees = newValue.degrees }
    }

    init(
        id: UUID = UUID(),
        image: UIImage,
        offset: CGSize = .zero,
        initialOffset: CGSize = .zero,
        scale: CGFloat = 1.0,
        rotation: Angle = .zero,
        width: CGFloat,
        height: CGFloat
    ) {
        self.id = id
        // Use PNG data to preserve any transparency:
        if let data = image.pngData() {
            self.imageData = data
        } else {
            self.imageData = Data()
        }
        self.offset = offset
        self.initialOffset = initialOffset
        self.scale = scale
        self.rotationDegrees = rotation.degrees
        self.width = width
        self.height = height
        
        // Start them off the same
        self.originalWidth = width
        self.originalHeight = height
    }

    // Coding keys
    enum CodingKeys: String, CodingKey {
        case id, imageData, offset, initialOffset, scale, rotationDegrees,
             width, height, originalWidth, originalHeight
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        imageData = try container.decode(Data.self, forKey: .imageData)
        offset = try container.decode(CGSize.self, forKey: .offset)
        initialOffset = try container.decode(CGSize.self, forKey: .initialOffset)
        scale = try container.decode(CGFloat.self, forKey: .scale)
        rotationDegrees = try container.decode(Double.self, forKey: .rotationDegrees)
        width = try container.decode(CGFloat.self, forKey: .width)
        height = try container.decode(CGFloat.self, forKey: .height)
        originalWidth = try container.decode(CGFloat.self, forKey: .originalWidth)
        originalHeight = try container.decode(CGFloat.self, forKey: .originalHeight)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(imageData, forKey: .imageData)
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
