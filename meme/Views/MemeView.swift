import SwiftUI

struct MemeView: View {
    @State private var isShowingModal = false
    @State private var backgroundImage: UIImage? = nil
    @State private var imageScale: CGFloat = 1.0
    @State private var imageOffset: CGSize = .zero

    var body: some View {
        VStack {
            // Header with + button
            HStack {
                Spacer()
                Button(action: {
                    isShowingModal = true
                }) {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 30))
                        .padding()
                }
            }
            .background(Color.white)
            
            // Canvas Container
            GeometryReader { geometry in
                ZStack {
                    Color.gray.opacity(0.1) // Background of the canvas

                    if let backgroundImage = backgroundImage {
                        Image(uiImage: backgroundImage)
                            .resizable()
                            .scaledToFit()
                            .scaleEffect(imageScale)
                            .offset(imageOffset)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        imageOffset = value.translation
                                    }
                                    .onEnded { _ in }
                                    .simultaneously(
                                        with: MagnificationGesture()
                                            .onChanged { scale in
                                                imageScale = scale
                                            }
                                            .onEnded { _ in }
                                    )
                            )
                    } else {
                        Text("Your Meme Canvas")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 0.8)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
            }
            .padding()
        }
        .sheet(isPresented: $isShowingModal) {
            MemeOptionsModal(backgroundImage: $backgroundImage, isShowingModal: $isShowingModal)
        }
    }
}

#Preview {
    MemeView()
}
