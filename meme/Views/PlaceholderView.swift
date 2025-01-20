import SwiftUI

struct PlaceholderView: View {
    @Binding var isAddingBackgroundImage: Bool
    @Binding var isShowingImagePicker: Bool

    var body: some View {
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
}
