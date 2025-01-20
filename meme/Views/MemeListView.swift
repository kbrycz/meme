import SwiftUI

struct MemeListView: View {
    @State private var memes: [Meme] = [] // Use the Meme struct
    @State private var showMemeEditor = false

    var body: some View {
        NavigationView {
            VStack {
                if memes.isEmpty {
                    // No memes message and button
                    VStack {
                        Text("Create your first meme!")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding()

                        Button("Create Meme") {
                            showMemeEditor = true
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    // List of memes
                    List {
                        ForEach(memes) { meme in
                            HStack {
                                if let image = UIImage(data: meme.imageData) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(5)
                                }

                                Text(meme.title)
                                    .font(.headline)

                                Spacer()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Memes")
            .navigationBarItems(trailing:
                Button(action: {
                    showMemeEditor = true
                }) {
                    Image(systemName: "plus")
                        .font(.title2)
                }
            )
            .sheet(isPresented: $showMemeEditor) {
                MemeEditorView()
            }
        }
        .onAppear {
            loadMemes()
        }
    }

    // Load memes from local storage
    private func loadMemes() {
        if let data = UserDefaults.standard.data(forKey: "memes"),
           let decodedMemes = try? JSONDecoder().decode([Meme].self, from: data) {
            memes = decodedMemes
        }
    }
}
