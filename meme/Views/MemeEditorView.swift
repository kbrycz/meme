import SwiftUI

struct MemeEditorView: View {
    @State private var baseImage: UIImage?
    @State private var overlayImages: [ImageItem] = []
    @State private var overlayTexts: [TextItem] = []
    @State private var isLoadingImage = false
    @State private var showDeleteConfirmation = false
    @State private var showImageOptions = false
    @State private var isShowingImagePicker = false
    @State private var isAddingBackgroundImage = false
    @State private var isShowingTextModal = false

    var body: some View {
        VStack {
            // Header
            HeaderView(showDeleteConfirmation: $showDeleteConfirmation, showImageOptions: $showImageOptions, baseImage: baseImage)

            // Meme Canvas
            GeometryReader { geometry in
                ZStack {
                    // Placeholder Text and Button
                    if baseImage == nil {
                        PlaceholderView(isAddingBackgroundImage: $isAddingBackgroundImage, isShowingImagePicker: $isShowingImagePicker)
                    }

                    // Base Image (fills canvas)
                    if let baseImage = baseImage {
                        BaseImageView(baseImage: baseImage, geometry: geometry)
                    }

                    // Overlay Images
                    ForEach(overlayImages) { imageItem in
                        overlayImageView(for: imageItem)
                    }
                    
                    // Overlay Texts
                    ForEach(overlayTexts) { textItem in
                        overlayTextView(for: textItem, geometry: geometry)
                    }

                    // Activity Indicator
                    if isLoadingImage {
                        ActivityIndicatorView(isAnimating: $isLoadingImage, style: .large)
                            .frame(width: calculateCanvasSize(for: baseImage, in: geometry.size).width, height: calculateCanvasSize(for: baseImage, in: geometry.size).height)
                    }
                }
                .frame(width: calculateCanvasSize(for: baseImage, in: geometry.size).width, height: calculateCanvasSize(for: baseImage, in: geometry.size).height)
                .background(Color(UIColor.secondarySystemBackground))
                .clipped()
            }
        }
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(selectedImage: $baseImage, isShowingPicker: $isShowingImagePicker, overlayImages: $overlayImages, isAddingBackgroundImage: $isAddingBackgroundImage, isLoadingImage: $isLoadingImage, calculateCanvasSize: calculateCanvasSize)
        }
        .sheet(isPresented: $isShowingTextModal) {
            TextOptionsView(overlayTexts: $overlayTexts, isShowingTextModal: $isShowingTextModal, canvasSize: calculateCanvasSize(for: baseImage, in: UIScreen.main.bounds.size))
        }
        .confirmationDialog("Are you sure you want to delete this project?", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                baseImage = nil
                overlayImages = []
                overlayTexts = []
            }
            Button("Cancel", role: .cancel) { }
        }
        .confirmationDialog("Select an Option", isPresented: $showImageOptions, titleVisibility: .visible) {
            ImageOptionsView(baseImage: baseImage, isAddingBackgroundImage: $isAddingBackgroundImage, isShowingImagePicker: $isShowingImagePicker, isShowingTextModal: $isShowingTextModal)
        }
    }

    @ViewBuilder
    private func overlayImageView(for imageItem: ImageItem) -> some View {
        if let image = imageItem.image { // Unwrap the optional UIImage
            Image(uiImage: image) // Use the unwrapped image
                .resizable()
                .scaledToFit()
                .frame(width: imageItem.width, height: imageItem.height)
                .scaleEffect(imageItem.scale)
                .rotationEffect(imageItem.rotation)
                .offset(imageItem.offset)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            if let index = overlayImages.firstIndex(where: { $0.id == imageItem.id }) {
                                // Calculate offset based on initialOffset and translation
                                let newOffsetX = imageItem.initialOffset.width + gesture.translation.width
                                let newOffsetY = imageItem.initialOffset.height + gesture.translation.height
                                overlayImages[index].offset = CGSize(width: newOffsetX, height: newOffsetY)
                            }
                        }
                        .onEnded { gesture in
                            if let index = overlayImages.firstIndex(where: { $0.id == imageItem.id }) {
                                // Update initialOffset for the next drag
                                overlayImages[index].initialOffset = overlayImages[index].offset
                            }
                        }
                        .simultaneously(with: RotationGesture()
                            .onChanged { angle in
                                if let index = overlayImages.firstIndex(where: { $0.id == imageItem.id }) {
                                    overlayImages[index].rotation = angle
                                }
                            }
                        )
                        .simultaneously(with: MagnificationGesture()
                            .onChanged { scale in
                                if let index = overlayImages.firstIndex(where: { $0.id == imageItem.id }) {
                                    overlayImages[index].scale = scale
                                }
                            }
                            .onEnded { scale in
                                if let index = overlayImages.firstIndex(where: { $0.id == imageItem.id }) {
                                    // Update width and height based on scale
                                    overlayImages[index].width = overlayImages[index].width * scale
                                    overlayImages[index].height = overlayImages[index].height * scale
                                    overlayImages[index].scale = 1.0
                                }
                            }
                        )
                )
        } else {
            // Optionally, display a placeholder or handle the case where the image is nil
            EmptyView()
        }
    }
    
    @ViewBuilder
    private func overlayTextView(for textItem: TextItem, geometry: GeometryProxy) -> some View {
        Text(textItem.text)
            .font(textItem.font)
            .foregroundColor(textItem.color)
            .frame(width: textItem.width, height: textItem.height)
            .scaleEffect(textItem.scale)
            .rotationEffect(textItem.rotation)
            .offset(textItem.offset)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        if let index = overlayTexts.firstIndex(where: { $0.id == textItem.id }) {
                            let newOffsetX = textItem.initialOffset.width + gesture.translation.width
                            let newOffsetY = textItem.initialOffset.height + gesture.translation.height
                            overlayTexts[index].offset = CGSize(width: newOffsetX, height: newOffsetY)
                        }
                    }
                    .onEnded { _ in
                        if let index = overlayTexts.firstIndex(where: { $0.id == textItem.id }) {
                            overlayTexts[index].initialOffset = overlayTexts[index].offset
                        }
                    }
                    .simultaneously(with: RotationGesture()
                        .onChanged { angle in
                            if let index = overlayTexts.firstIndex(where: { $0.id == textItem.id }) {
                                overlayTexts[index].rotation = angle
                            }
                        }
                    )
                    .simultaneously(with: MagnificationGesture()
                        .onChanged { scale in
                            if let index = overlayTexts.firstIndex(where: { $0.id == textItem.id }) {
                                overlayTexts[index].scale = scale
                            }
                        }
                        .onEnded { scale in
                            if let index = overlayTexts.firstIndex(where: { $0.id == textItem.id }) {
                                // Correctly calculate new size based on original width/height and scale
                                let newWidth = textItem.originalWidth * scale
                                let newHeight = textItem.originalHeight * scale
                                overlayTexts[index].width = newWidth
                                overlayTexts[index].height = newHeight
                                overlayTexts[index].scale = 1.0
                            }
                        }
                    )
            )
            .onAppear {
                if textItem.initialOffset == .zero {
                    if let index = overlayTexts.firstIndex(where: { $0.id == textItem.id }) {
                        let canvasSize = calculateCanvasSize(for: baseImage, in: geometry.size)
                        overlayTexts[index].initialOffset = CGSize(width: (canvasSize.width / 2) - (textItem.width / 2), height: (canvasSize.height / 2) - (textItem.height / 2))
                        overlayTexts[index].offset = overlayTexts[index].initialOffset
                    }
                }
            }
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
