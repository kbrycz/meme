import SwiftUI

struct TextOptionsView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var overlayTexts: [TextItem]
    @Binding var isShowingTextModal: Bool
    
    @State private var textInput: String = ""
    @State private var textColor: Color = .black
    @State private var selectedFontIndex: Int = 0
    var canvasSize: CGSize

    private let fontNames = [
        "Arial", "Times New Roman", "Courier New", "Helvetica",
        "Verdana", "Georgia", "Futura", "Gill Sans",
        "Baskerville", "Palatino"
    ]

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                HStack {
                    Text("Text Options")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Spacer()
                    Button {
                        isShowingTextModal = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                }
                .padding([.top, .horizontal])
                
                let tfColor = (colorScheme == .dark) ? Color.white : Color.black
                
                // Our auto-focus text field, occupying ~80% of the screen width
                AutoFocusTextField(
                    text: $textInput,
                    placeholder: "Enter text"
                )
                .foregroundColor(tfColor)
                .padding()
                .frame(maxWidth: .infinity) // fill horizontally
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
                .padding(.horizontal, 20)
                
                ColorPicker("Text Color", selection: $textColor)
                    .padding(.horizontal, 20)
                
                Picker("Font", selection: $selectedFontIndex) {
                    ForEach(0..<fontNames.count, id: \.self) { i in
                        Text(fontNames[i])
                            .font(getFont(size: 20, forIndex: i))
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .padding(.horizontal, 20)
                
                Button {
                    addTextToOverlay()
                } label: {
                    Text("Add Text")
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .padding(.top)
            .navigationBarHidden(true)
        }
    }

    private func addTextToOverlay() {
        let finalText = textInput.isEmpty ? "Sample" : textInput
        let newTextItem = TextItem(
            text: finalText,
            color: textColor,
            font: getFont(size: 20),
            offset: .zero,
            scale: 1.0,
            rotation: .zero,
            width: 200,
            height: 50,
            originalWidth: 200,
            originalHeight: 50,
            originalFontSize: 20
        )
        overlayTexts.append(newTextItem)
        isShowingTextModal = false
    }

    private func getFont(size: CGFloat, forIndex index: Int? = nil) -> Font {
        let fontName = fontNames[index ?? selectedFontIndex]
        return Font.custom(fontName, size: size)
    }
}
