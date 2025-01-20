import SwiftUI

struct ImageItem: Identifiable, Codable {
    let id: UUID
    var imageData: Data // Store image data instead of UIImage
    var offset: CGSize
    var initialOffset: CGSize
    var scale: CGFloat
    var rotationDegrees: Double // Store rotation as degrees (Double)
    var width: CGFloat
    var height: CGFloat

    // Computed property to get UIImage from imageData
    var image: UIImage? {
        UIImage(data: imageData)
    }

    // Computed property to get/set rotation as Angle
    var rotation: Angle {
        get { Angle(degrees: rotationDegrees) }
        set { rotationDegrees = newValue.degrees }
    }

    // Custom initializer to create an ImageItem from a UIImage
    init(id: UUID = UUID(), image: UIImage, offset: CGSize = .zero, initialOffset: CGSize = .zero, scale: CGFloat = 1.0, rotation: Angle = .zero, width: CGFloat, height: CGFloat) {
        self.id = id
        // Convert UIImage to Data
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            self.imageData = imageData
        } else {
            // Handle the case where image data is nil, maybe with a default image
            self.imageData = Data() // You can replace this with data for a default image
        }
        self.offset = offset
        self.initialOffset = initialOffset
        self.scale = scale
        self.rotationDegrees = rotation.degrees
        self.width = width
        self.height = height
    }

    // Encoding and Decoding methods
    enum CodingKeys: String, CodingKey {
        case id, imageData, offset, initialOffset, scale, rotationDegrees, width, height
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
    }
}
