import SwiftUI

struct OverlayImageView: View {
    @State var imageItem: ImageItem
    let onUpdate: (ImageItem) -> Void
    let canvasSize: CGSize
    
    // Local state to detect dragging/pinching
    @State private var isInteracting = false
    
    var body: some View {
        Group {
            if let uiImage = imageItem.image {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: imageItem.width, height: imageItem.height)
                    .rotationEffect(imageItem.rotation)
                    .offset(x: imageItem.offset.width, y: imageItem.offset.height)
                    .zIndex(20)
                    .gesture(
                        SimultaneousGesture(
                            // Drag
                            DragGesture()
                                .onChanged { gesture in
                                    isInteracting = true
                                    var updated = imageItem
                                    updated.offset = CGSize(
                                        width: imageItem.initialOffset.width + gesture.translation.width,
                                        height: imageItem.initialOffset.height + gesture.translation.height
                                    )
                                    self.imageItem = updated
                                }
                                .onEnded { _ in
                                    var updated = imageItem
                                    updated.initialOffset = updated.offset
                                    self.imageItem = updated
                                    onUpdate(updated)
                                    isInteracting = false
                                },
                            
                            // Rotation + Pinch
                            SimultaneousGesture(
                                RotationGesture()
                                    .onChanged { angle in
                                        isInteracting = true
                                        var updated = imageItem
                                        updated.rotation = angle
                                        self.imageItem = updated
                                    }
                                    .onEnded { _ in
                                        onUpdate(imageItem)
                                        isInteracting = false
                                    },
                                MagnificationGesture()
                                    .onChanged { scale in
                                        isInteracting = true
                                        var updated = imageItem
                                        let newW = updated.originalWidth * scale
                                        let newH = updated.originalHeight * scale
                                        updated.width = newW
                                        updated.height = newH
                                        self.imageItem = updated
                                    }
                                    .onEnded { _ in
                                        var updated = imageItem
                                        updated.originalWidth = updated.width
                                        updated.originalHeight = updated.height
                                        self.imageItem = updated
                                        onUpdate(updated)
                                        isInteracting = false
                                    }
                            )
                        )
                    )
                    .onAppear {
                        // Center on the canvas if offset is zero
                        if imageItem.initialOffset == .zero {
                            var updated = imageItem
                            let centerX = canvasSize.width / 2
                            let centerY = canvasSize.height / 2
                            let halfW = updated.width / 2
                            let halfH = updated.height / 2
                            updated.offset = CGSize(width: centerX - halfW,
                                                    height: centerY - halfH)
                            updated.initialOffset = updated.offset
                            self.imageItem = updated
                            onUpdate(updated)
                        }
                    }
            }
        }
    }
}
