import SwiftUI

struct Meme: Identifiable, Codable {
    let id: UUID
    var title: String
    var imageData: Data
    var overlayImages: [ImageItem]
    var overlayTexts: [TextItem]

    // Initializer
    init(id: UUID = UUID(), title: String, imageData: Data, overlayImages: [ImageItem] = [], overlayTexts: [TextItem] = []) {
        self.id = id
        self.title = title
        self.imageData = imageData
        self.overlayImages = overlayImages
        self.overlayTexts = overlayTexts
    }
}
