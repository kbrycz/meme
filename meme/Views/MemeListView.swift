import SwiftUI

struct MemeListView: View {
    @State var memes: [Meme] = []
    @State var navigateToNewMeme = false

    var body: some View {
        VStack {
            if memes.isEmpty {
                // No memes yet
                VStack {
                    Text("Create your first meme!")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()

                    Button("Create Meme") {
                        navigateToNewMeme = true
                    }
                    .buttonStyle(.borderedProminent)
                }
            } else {
                // Meme list with swipe-to-delete
                List {
                    ForEach(memes.indices, id: \.self) { i in
                        let meme = memes[i]
                        NavigationLink(
                            destination: MemeEditorView(
                                memeToEdit: meme,
                                onSave: { updatedMeme in
                                    memes[i] = updatedMeme
                                    saveMemes()
                                }
                            )
                        ) {
                            HStack(spacing: 12) {
                                // If we have a composited thumbnail, show that
                                if let thumbData = meme.compositedImageData,
                                   let thumbImg = UIImage(data: thumbData) {
                                    Image(uiImage: thumbImg)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                } else {
                                    // fallback to base image
                                    if let image = UIImage(data: meme.imageData) {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 50, height: 50)
                                            .clipShape(RoundedRectangle(cornerRadius: 5))
                                    } else {
                                        Rectangle()
                                            .fill(Color.gray)
                                            .frame(width: 50, height: 50)
                                            .cornerRadius(5)
                                    }
                                }
                                
                                Text(meme.title)
                                    .font(.headline)
                                Spacer()
                            }
                        }
                    }
                    .onDelete(perform: removeMemes)
                }
            }
        }
        .navigationTitle("Memes")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    navigateToNewMeme = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        // Hidden NavLink triggers on navigateToNewMeme = true
        .background(
            NavigationLink(
                destination: MemeEditorView(
                    memeToEdit: nil,
                    onSave: { newMeme in
                        var titledMeme = newMeme
                        // If user gave no title, use "Untitled N"
                        if titledMeme.title.isEmpty {
                            titledMeme.title = "Untitled \(memes.count + 1)"
                        }
                        memes.append(titledMeme)
                        saveMemes()
                    }
                ),
                isActive: $navigateToNewMeme
            ) { EmptyView() }
            .hidden()
        )
        .onAppear {
            loadMemes()
        }
    }
    
    // MARK: - Delete
    func removeMemes(at offsets: IndexSet) {
        memes.remove(atOffsets: offsets)
        saveMemes()
    }

    // MARK: - Load / Save
    func loadMemes() {
        if let data = UserDefaults.standard.data(forKey: "memes"),
           let decodedMemes = try? JSONDecoder().decode([Meme].self, from: data) {
            memes = decodedMemes
        }
    }

    func saveMemes() {
        if let encoded = try? JSONEncoder().encode(memes) {
            UserDefaults.standard.set(encoded, forKey: "memes")
        }
    }
}
