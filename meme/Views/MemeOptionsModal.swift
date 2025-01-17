import SwiftUI

struct MemeOptionsModal: View {
    @Binding var backgroundImage: UIImage?
    @Binding var isShowingModal: Bool
    @State private var isPhotoPickerPresented = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Button(action: {
                    isPhotoPickerPresented = true
                }) {
                    Text("Import Starter Image")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .sheet(isPresented: $isPhotoPickerPresented) {
                    PhotoPicker(selectedImage: $backgroundImage, isShowingModal: $isShowingModal)
                }
                
                Button(action: {
                    print("Add Text tapped")
                }) {
                    Text("Add Text")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    print("Overlay Additional Image tapped")
                }) {
                    Text("Overlay Additional Image")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Add to Meme")
        }
    }
}

#Preview {
    MemeOptionsModal(backgroundImage: .constant(nil), isShowingModal: .constant(true))
}
