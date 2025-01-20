import SwiftUI

struct HeaderView: View {
    @Binding var showDeleteConfirmation: Bool
    @Binding var showImageOptions: Bool
    var baseImage: UIImage?

    var body: some View {
        HStack {
            Button(action: {
                showDeleteConfirmation = true
            }) {
                Image(systemName: "trash.circle.fill")
                    .font(.title)
                    .foregroundColor(.red)
            }

            Spacer()

            Button(action: {
                showImageOptions = true
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.title)
                    .foregroundColor(.accentColor)
            }
        }
        .padding([.horizontal, .top])
        .padding(.bottom, 8)
        .background(Color(UIColor.systemBackground))
    }
}
