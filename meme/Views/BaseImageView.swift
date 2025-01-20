import SwiftUI

struct BaseImageView: View {
    var baseImage: UIImage
    var geometry: GeometryProxy

    var body: some View {
        Image(uiImage: baseImage)
            .resizable()
            .scaledToFit()
            .frame(width: calculateCanvasSize(for: baseImage, in: geometry.size).width, height: calculateCanvasSize(for: baseImage, in: geometry.size).height)
    }
    
    private func calculateCanvasSize(for image: UIImage?, in availableSpace: CGSize) -> CGSize {
        guard let image = image else { return availableSpace }

        let imageAspectRatio = image.size.width / image.size.height
        let availableAspectRatio = availableSpace.width / availableSpace.height

        var canvasWidth = availableSpace.width
        var canvasHeight = availableSpace.height

        if imageAspectRatio > availableAspectRatio {
            // Image is wider than available space
            canvasHeight = availableSpace.width / imageAspectRatio
        } else {
            // Image is taller than available space
            canvasWidth = availableSpace.height * imageAspectRatio
        }

        return CGSize(width: canvasWidth, height: canvasHeight)
    }
}
