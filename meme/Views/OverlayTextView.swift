import SwiftUI

struct OverlayTextView: View {
    @State var textItem: TextItem
    let onUpdate: (TextItem) -> Void
    let canvasSize: CGSize
    
    @State private var isInteracting = false
    
    var body: some View {
        Text(textItem.text)
            .font(.custom(textItem.fontName, size: textItem.fontSize))
            .foregroundColor(textItem.color)
            .shadow(color: .black.opacity(0.8), radius: 1, x: 0, y: 0)
            .frame(width: textItem.width, height: textItem.height)
            // Dotted bounding box while user interacts
            .overlay(
                RoundedRectangle(cornerRadius: 1)
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [6]))
                    .foregroundColor(Color.white.opacity(0.6))
                    .opacity(isInteracting ? 1 : 0)
            )
            .rotationEffect(textItem.rotation)
            .offset(x: textItem.offset.width, y: textItem.offset.height)
            .zIndex(30)
            .gesture(
                SimultaneousGesture(
                    // Drag
                    DragGesture()
                        .onChanged { gesture in
                            isInteracting = true
                            var updated = textItem
                            updated.offset = CGSize(
                                width: textItem.initialOffset.width + gesture.translation.width,
                                height: textItem.initialOffset.height + gesture.translation.height
                            )
                            self.textItem = updated
                        }
                        .onEnded { _ in
                            var updated = textItem
                            updated.initialOffset = updated.offset
                            self.textItem = updated
                            onUpdate(updated)
                            isInteracting = false
                        },
                    
                    // Rotation + Pinch
                    SimultaneousGesture(
                        RotationGesture()
                            .onChanged { angle in
                                isInteracting = true
                                var updated = textItem
                                updated.rotation = angle
                                self.textItem = updated
                            }
                            .onEnded { _ in
                                onUpdate(textItem)
                                isInteracting = false
                            },
                        MagnificationGesture()
                            .onChanged { scale in
                                isInteracting = true
                                var updated = textItem
                                // Scale actual font size
                                updated.fontSize = updated.originalFontSize * scale
                                // Update bounding box
                                updated.width = updated.originalWidth * scale
                                updated.height = updated.originalHeight * scale
                                self.textItem = updated
                            }
                            .onEnded { _ in
                                var updated = textItem
                                updated.originalFontSize = updated.fontSize
                                updated.originalWidth = updated.width
                                updated.originalHeight = updated.height
                                self.textItem = updated
                                onUpdate(updated)
                                isInteracting = false
                            }
                    )
                )
            )
            .onAppear {
                if textItem.initialOffset == .zero {
                    var updated = textItem
                    let centerX = canvasSize.width / 2
                    let centerY = canvasSize.height / 2
                    let halfW = updated.width / 2
                    let halfH = updated.height / 2
                    updated.offset = CGSize(width: centerX - halfW,
                                            height: centerY - halfH)
                    updated.initialOffset = updated.offset
                    self.textItem = updated
                    onUpdate(updated)
                }
            }
    }
}
