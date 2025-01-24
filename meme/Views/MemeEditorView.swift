import SwiftUI

struct MemeEditorView: View {
    /// If non-nil, we’re editing an existing meme; if nil, we’re creating a new one
    let memeToEdit: Meme?
    /// Callback when user completes saving
    let onSave: (Meme) -> Void
    
    @State var baseImage: UIImage?
    @State var overlayImages: [ImageItem] = []
    @State var overlayTexts: [TextItem] = []
    
    @State var isLoadingImage = false
    @State var showExitConfirmation = false
    @State var showImageOptions = false
    @State var isShowingImagePicker = false
    @State var isAddingBackgroundImage = false
    @State var isShowingTextModal = false
    
    /// For new memes only: we ask them to name it
    @State var showNamingSheet = false
    @State var draftName: String = ""
    
    @State var memeTitle: String = ""
    
    /// Track final “canvas” size
    @State var canvasSize: CGSize = .zero
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Stationary background
                Color(UIColor.systemBackground)
                    .edgesIgnoringSafeArea(.all)
                
                // The "canvas" area, centered vertically & horizontally
                VStack {
                    Spacer()
                    
                    ZStack {
                        if let baseImg = baseImage {
                            canvasWithOverlays(baseImage: baseImg, geometry: geometry)
                        } else {
                            placeholderCanvas
                        }
                    }
                    // Use 0.8 width, 0.5 height for more obvious vertical centering
                    .frame(width: geometry.size.width * 0.8,
                           height: geometry.size.height * 0.5)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                    .shadow(radius: 6)
                    .onAppear {
                        // compute the actual canvas size
                        let w = geometry.size.width * 0.8
                        let h = geometry.size.height * 0.5
                        canvasSize = CGSize(width: max(w, 1), height: max(h, 1))
                        
                        print("Canvas size: \(canvasSize)")
                    }
                    
                    Spacer()
                }
                
                // Spinner while saving/picking images
                if isLoadingImage {
                    ActivityIndicatorView(isAnimating: $isLoadingImage, style: .large)
                }
            }
            .navigationBarTitle("Meme Editor", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                // Left: Exit
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Exit") {
                        // If there's no base image, we just go back with no dialog
                        if baseImage == nil {
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            showExitConfirmation = true
                        }
                    }
                }
                // Right: +
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showImageOptions = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            // Confirmation for "Exit" only if there's a base image
            .confirmationDialog(
                "Exit Options",
                isPresented: $showExitConfirmation,
                actions: {
                    if baseImage != nil {
                        Button("Save Meme & Leave") {
                            if memeToEdit != nil {
                                // If editing existing, no rename needed – just save & dismiss
                                isLoadingImage = true
                                actuallySaveMeme()
                                presentationMode.wrappedValue.dismiss()
                            } else {
                                // If new, show naming sheet
                                showNamingSheet = true
                            }
                        }
                        Button("Clear Meme & Stay", role: .destructive) {
                            clearMeme()
                        }
                        // "Leave Without Saving"
                        Button("Leave Without Saving", role: .destructive) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    Button("Cancel", role: .cancel) {}
                }
            )
            // Confirmation for the plus menu
            .confirmationDialog(
                "Select an Option",
                isPresented: $showImageOptions,
                titleVisibility: .visible
            ) {
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
                    Button("Add Text") {
                        isShowingTextModal = true
                    }
                }
                Button("Cancel", role: .cancel) { }
            }
            // Image picker
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(
                    selectedImage: $baseImage,
                    isShowingPicker: $isShowingImagePicker,
                    overlayImages: $overlayImages,
                    isAddingBackgroundImage: $isAddingBackgroundImage,
                    isLoadingImage: $isLoadingImage,
                    calculateCanvasSize: { _,_ in .zero }
                )
            }
            // Text options
            .sheet(isPresented: $isShowingTextModal) {
                TextOptionsView(
                    overlayTexts: $overlayTexts,
                    isShowingTextModal: $isShowingTextModal,
                    canvasSize: canvasSize
                )
            }
            // Name prompt, only used if it's a new meme
            .sheet(isPresented: $showNamingSheet) {
                namingSheet
            }
            .onAppear {
                loadExistingMeme()
            }
        }
    }
}

// MARK: - Name Prompt
extension MemeEditorView {
    var namingSheet: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Name Your Meme")
                    .font(.title2)
                    .padding(.top, 20)
                
                // Our AutoFocusTextField with a smaller frame
                AutoFocusTextField(
                    text: $draftName,
                    placeholder: "Enter Meme Title"
                )
                .frame(width: 250, height: 40) // force smaller
                .padding(.horizontal)
                
                if isLoadingImage {
                    ActivityIndicatorView(isAnimating: $isLoadingImage, style: .medium)
                }
                
                HStack {
                    Button("Cancel") {
                        showNamingSheet = false
                    }
                    .padding()
                    
                    Spacer()
                    
                    Button("Save") {
                        isLoadingImage = true
                        let finalTitle = draftName.trimmingCharacters(in: .whitespacesAndNewlines)
                        memeTitle = finalTitle.isEmpty ? "Untitled" : finalTitle
                        
                        actuallySaveMeme()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .padding()
                    .disabled(draftName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationBarTitle("", displayMode: .inline)
        }
        .presentationDetents([.medium])
    }
}
