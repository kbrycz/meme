import SwiftUI

struct ImageItem: Identifiable {
    let id = UUID()
    var image: UIImage
    var offset: CGSize
    var initialOffset: CGSize = .zero // Store initial offset for dragging
    var scale: CGFloat
    var rotation: Angle
    var width: CGFloat
    var height: CGFloat
}
