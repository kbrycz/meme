import SwiftUI

struct TextOptionsView: View {
    @Binding var overlayTexts: [TextItem]
    @Binding var isShowingTextModal: Bool
    @State private var textInput: String = ""
    @State private var textColor: Color = .black
    @State private var selectedFontIndex: Int = 0
    var canvasSize: CGSize

    private let fontNames = ["Arial", "Times New Roman", "Courier New", "Helvetica", "Verdana", "Georgia", "Futura", "Gill Sans", "Baskerville", "Palatino"]

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                HStack {
                    Text("Text Options")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Spacer()
                    Button(action: {
                        isShowingTextModal = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                }
                .padding([.top, .horizontal])

                TextField("Enter text", text: $textInput)
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                    .font(getFont(size: 20))
                    .foregroundColor(textColor)
                    .submitLabel(.done)
                    .onSubmit {
                        addTextToOverlay(canvasSize: canvasSize)
                    }
                    .padding(.horizontal)

                ColorPicker("Text Color", selection: $textColor)
                    .padding(.horizontal)

                Picker("Font", selection: $selectedFontIndex) {
                    ForEach(0..<fontNames.count, id: \.self) { index in
                        Text(fontNames[index]).font(getFont(size: 20, forIndex: index))
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .padding(.horizontal)

                Button(action: {
                    addTextToOverlay(canvasSize: canvasSize)
                }) {
                    Text("Add Text")
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding(.top)
            .background(Color(UIColor.systemBackground))
            .navigationBarHidden(true)
        }
    }

    // Helper method to add text item
    private func addTextToOverlay(canvasSize: CGSize) {
        let newTextItem = TextItem(text: textInput, color: textColor, font: getFont(size: 20), offset: .zero, scale: 1.0, rotation: .zero, width: 200, height: 50, originalWidth: 200, originalHeight: 50)
        
        // Set initial offset to center the text item
        let initialOffsetX = (canvasSize.width / 2) - (newTextItem.width / 2)
        let initialOffsetY = (canvasSize.height / 2) - (newTextItem.height / 2)
        
        overlayTexts.append(newTextItem)
        if let index = overlayTexts.firstIndex(where: { $0.id == newTextItem.id }) {
            overlayTexts[index].initialOffset = CGSize(width: initialOffsetX, height: initialOffsetY)
            overlayTexts[index].offset = overlayTexts[index].initialOffset
        }
        
        isShowingTextModal = false
    }

    // Helper method to get font
    private func getFont(size: CGFloat, forIndex index: Int? = nil) -> Font {
        let fontName = fontNames[index ?? selectedFontIndex]
        return Font.custom(fontName, size: size)
    }
}
