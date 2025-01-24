import SwiftUI

struct Meme: Identifiable, Codable {
    let id: UUID
    var title: String
    var imageData: Data
    var overlayImages: [ImageItem]
    var overlayTexts: [TextItem]
    
    /// A flattened (base + overlays) thumbnail for the list screen
    var compositedImageData: Data?

    init(
        id: UUID = UUID(),
        title: String,
        imageData: Data,
        overlayImages: [ImageItem] = [],
        overlayTexts: [TextItem] = [],
        compositedImageData: Data? = nil
    ) {
        self.id = id
        self.title = title
        self.imageData = imageData
        self.overlayImages = overlayImages
        self.overlayTexts = overlayTexts
        self.compositedImageData = compositedImageData
    }
}
