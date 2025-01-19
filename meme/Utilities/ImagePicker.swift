import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var isShowingPicker: Bool
    @Binding var overlayImages: [ImageItem]
    @Binding var isAddingBackground: Bool
    @Binding var isLoadingImage: Bool

    // Add a closure to calculate canvas size
    var calculateCanvasSize: (UIImage?, CGSize) -> CGSize

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.isShowingPicker = false
            guard let provider = results.first?.itemProvider else { return }

            if provider.canLoadObject(ofClass: UIImage.self) {
                DispatchQueue.main.async {
                    self.parent.isLoadingImage = true
                }

                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    DispatchQueue.main.async {
                        self.parent.isLoadingImage = false
                        if let image = image as? UIImage {
                            if self.parent.isAddingBackground {
                                // Adding background image
                                self.parent.selectedImage = image
                            } else {
                                // Adding overlay image
                                var newImageItem = ImageItem(image: image, offset: .zero, scale: 1.0, rotation: .zero, width: 80, height: 80)

                                // Calculate initial offset based on canvas size
                                let canvasSize = self.parent.calculateCanvasSize(self.parent.selectedImage, UIScreen.main.bounds.size)
                                let initialOffsetX = (canvasSize.width / 2) - (newImageItem.width / 2)
                                let initialOffsetY = (canvasSize.height / 2) - (newImageItem.height / 2)
                                newImageItem.initialOffset = CGSize(width: initialOffsetX, height: initialOffsetY)
                                newImageItem.offset = newImageItem.initialOffset

                                self.parent.overlayImages.append(newImageItem)
                            }
                        }
                    }
                }
            }
        }
    }
}
