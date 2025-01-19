import SwiftUI

struct MemeEditorView: View {
    @State private var baseImage: UIImage?
    @State private var overlayImages: [ImageItem] = []
    @State private var isLoadingImage = false
    @State private var showDeleteConfirmation = false
    @State private var showImageOptions = false
    @State private var isShowingImagePicker = false
    @State private var isAddingBackgroundImage = false

    private let minPadding: CGFloat = 20 // Minimum padding around the canvas

    var body: some View {
        VStack {
            // Header
            HStack {
                Button(action: {
                    showDeleteConfirmation = true
                }) {
                    Image(systemName: "trash.circle.fill")
                        .font(.title)
                        .foregroundColor(.red)
                }
                .confirmationDialog("Are you sure you want to delete this project?", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
                    Button("Delete", role: .destructive) {
                        baseImage = nil
                        overlayImages = []
                    }
                    Button("Cancel", role: .cancel) { }
                }

                Spacer()

                Button(action: {
                    showImageOptions = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .foregroundColor(.accentColor)
                }
                .confirmationDialog("Select an Option", isPresented: $showImageOptions, titleVisibility: .visible) {
                    if baseImage == nil {
                        Button("Add Background Image") {
                            isAddingBackgroundImage = true
                            isShowingImagePicker = true
                        }
                    } else {
                        Button("Change Background Image") {
                            isAddingBackgroundImage = true
                            isShowingImagePicker = true
                        }
                        Button("Add Overlay Image") {
                            isAddingBackgroundImage = false
                            isShowingImagePicker = true
                        }
                    }
                    Button("Cancel", role: .cancel) { }
                }
            }
            .padding([.horizontal, .top])
            .padding(.bottom, 8)
            .background(Color(UIColor.systemBackground))

            // Meme Canvas
            GeometryReader { geometry in
                ZStack {
                    // Placeholder Text and Button
                    if baseImage == nil {
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

                    // Base Image (fills canvas)
                    if let baseImage = baseImage {
                        Image(uiImage: baseImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: calculateCanvasSize(for: baseImage, in: geometry.size).width, height: calculateCanvasSize(for: baseImage, in: geometry.size).height)
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2) // Center the image
                    }

                    // Overlay Images
                    ForEach(overlayImages) { imageItem in
                        overlayImageView(for: imageItem)
                    }

                    // Activity Indicator
                    if isLoadingImage {
                        ActivityIndicatorView(isAnimating: $isLoadingImage, style: .large)
                            .frame(width: calculateCanvasSize(for: baseImage, in: geometry.size).width, height: calculateCanvasSize(for: baseImage, in: geometry.size).height)
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2) // Center the indicator
                    }
                }
                .frame(width: calculateCanvasSize(for: baseImage, in: geometry.size).width, height: calculateCanvasSize(for: baseImage, in: geometry.size).height)
                .background(Color(UIColor.secondarySystemBackground))
                .clipped()
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2) // Center the canvas
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1)
                        .opacity(0.5)
                )
            }
            .padding(minPadding) // Apply minimum padding around the canvas
        }
        .sheet(isPresented: $isShowingImagePicker) {
            // Pass a reference to the calculateCanvasSize function
            ImagePicker(selectedImage: $baseImage, isShowingPicker: $isShowingImagePicker, overlayImages: $overlayImages, isAddingBackground: $isAddingBackgroundImage, isLoadingImage: $isLoadingImage, calculateCanvasSize: calculateCanvasSize)
        }
    }

    // View builder for overlay images
    @ViewBuilder
    private func overlayImageView(for imageItem: ImageItem) -> some View {
        Image(uiImage: imageItem.image)
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
                                let newWidth = overlayImages[index].width * scale
                                let newHeight = overlayImages[index].height * scale
                                overlayImages[index].width = newWidth
                                overlayImages[index].height = newHeight
                                overlayImages[index].scale = 1.0
                            }
                        }
                    )
            )
    }

    func calculateCanvasSize(for image: UIImage?, in availableSpace: CGSize) -> CGSize {
        guard let image = image else { return availableSpace }

        let imageAspectRatio = image.size.width / image.size.height
        let availableWidth = availableSpace.width - minPadding * 2
        let availableHeight = availableSpace.height - minPadding * 2

        var canvasWidth = availableWidth
        var canvasHeight = availableHeight

        if imageAspectRatio > availableWidth / availableHeight {
            // Image is wider than available space
            canvasHeight = availableWidth / imageAspectRatio
        } else {
            // Image is taller than available space
            canvasWidth = availableHeight * imageAspectRatio
        }

        return CGSize(width: canvasWidth, height: canvasHeight)
    }
}
