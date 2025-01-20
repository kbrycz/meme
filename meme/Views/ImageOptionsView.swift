import SwiftUI

struct ImageOptionsView: View {
    var baseImage: UIImage?
    @Binding var isAddingBackgroundImage: Bool
    @Binding var isShowingImagePicker: Bool
    @Binding var isShowingTextModal: Bool

    var body: some View {
        Group {
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
            if baseImage != nil {
                Button("Add Text") {
                    isShowingTextModal = true
                }
            }
            Button("Cancel", role: .cancel) { }
        }
    }
}
