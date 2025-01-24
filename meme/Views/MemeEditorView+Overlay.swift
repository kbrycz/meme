import SwiftUI

extension MemeEditorView {
    @ViewBuilder
    func canvasWithOverlays(baseImage: UIImage, geometry: GeometryProxy) -> some View {
        ZStack {
            // Base image
            Image(uiImage: baseImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: canvasSize.width, height: canvasSize.height)
                .clipped()
            
            // Overlay images
            ForEach(overlayImages.indices, id: \.self) { i in
                let item = overlayImages[i]
                overlayImageView(item, index: i)
            }
            
            // Overlay texts
            ForEach(overlayTexts.indices, id: \.self) { i in
                let txt = overlayTexts[i]
                overlayTextView(txt, index: i)
            }
        }
    }
    
    var placeholderCanvas: some View {
        VStack {
            Text("Add a background image to create your meme")
                .font(.headline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding()
            
            Button("Add Background Image") {
                isAddingBackgroundImage = true
                isShowingImagePicker = true
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    // MARK: - Images
    @ViewBuilder
    func overlayImageView(_ imageItem: ImageItem, index: Int) -> some View {
        OverlayImageView(
            imageItem: imageItem,
            onUpdate: { updated in
                overlayImages[index] = updated
            },
            canvasSize: canvasSize
        )
    }
    
    // MARK: - Text
    @ViewBuilder
    func overlayTextView(_ textItem: TextItem, index: Int) -> some View {
        OverlayTextView(
            textItem: textItem,
            onUpdate: { updated in
                overlayTexts[index] = updated
            },
            canvasSize: canvasSize
        )
    }
}
