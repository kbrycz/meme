import SwiftUI

extension MemeEditorView {
    func loadExistingMeme() {
        guard let editingMeme = memeToEdit else { return }
        memeTitle = editingMeme.title
        if let image = UIImage(data: editingMeme.imageData) {
            baseImage = image
        }
        overlayImages = editingMeme.overlayImages
        overlayTexts = editingMeme.overlayTexts
    }
    
    func clearMeme() {
        baseImage = nil
        overlayImages = []
        overlayTexts = []
        memeTitle = ""
    }
    
    func actuallySaveMeme() {
        guard let base = baseImage else {
            isLoadingImage = false
            return
        }
        
        // Flatten everything into one image for the list thumbnail
        let flattened = flattenMemeToUIImage(baseImage: base)
        let flattenedData = flattened?.pngData()
        
        // If the user didn’t type a name, default “Untitled”
        if memeTitle.isEmpty {
            memeTitle = "Untitled"
        }
        
        // Use PNG data to preserve alpha
        let baseData = base.pngData() ?? Data()
        
        let newMeme = Meme(
            id: memeToEdit?.id ?? UUID(),
            title: memeTitle,
            imageData: baseData,
            overlayImages: overlayImages,
            overlayTexts: overlayTexts,
            compositedImageData: flattenedData
        )
        
        // Call callback
        onSave(newMeme)
        
        // Done saving
        isLoadingImage = false
    }
    
    /// Renders the base + overlays at full size for the thumbnail
    func flattenMemeToUIImage(baseImage: UIImage) -> UIImage? {
        let baseSize = baseImage.size
        // figure out scale from our canvas to the real base image size
        let scaleX = baseSize.width / max(canvasSize.width, 1)
        let scaleY = baseSize.height / max(canvasSize.height, 1)
        
        UIGraphicsBeginImageContextWithOptions(baseSize, false, 1.0)
        defer { UIGraphicsEndImageContext() }
        
        // Draw base
        baseImage.draw(in: CGRect(origin: .zero, size: baseSize))
        
        // Overlays
        for item in overlayImages {
            if let uiImage = item.image {
                let x = item.offset.width * scaleX
                let y = item.offset.height * scaleY
                let w = item.width * scaleX
                let h = item.height * scaleY
                let centerX = x + (w / 2)
                let centerY = y + (h / 2)
                
                let ctx = UIGraphicsGetCurrentContext()
                ctx?.saveGState()
                ctx?.translateBy(x: centerX, y: centerY)
                ctx?.rotate(by: CGFloat(item.rotation.radians))
                
                uiImage.draw(in: CGRect(x: -w/2, y: -h/2, width: w, height: h))
                ctx?.restoreGState()
            }
        }
        
        // Text overlays
        for txt in overlayTexts {
            let x = txt.offset.width * scaleX
            let y = txt.offset.height * scaleY
            let w = txt.width * scaleX
            let h = txt.height * scaleY
            let centerX = x + (w / 2)
            let centerY = y + (h / 2)
            
            let ctx = UIGraphicsGetCurrentContext()
            ctx?.saveGState()
            ctx?.translateBy(x: centerX, y: centerY)
            ctx?.rotate(by: CGFloat(txt.rotation.radians))
            
            let textRect = CGRect(x: -w/2, y: -h/2, width: w, height: h)
            
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .center
            
            // Convert SwiftUI font to UIFont
            let uiFont = UIFont(name: txt.fontName, size: txt.fontSize * scaleX)
                ?? UIFont.systemFont(ofSize: txt.fontSize * scaleX)
            let uiColor = UIColor(txt.color)
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: uiFont,
                .foregroundColor: uiColor,
                .paragraphStyle: paragraph
            ]
            let attributed = NSAttributedString(string: txt.text, attributes: attrs)
            attributed.draw(in: textRect)
            
            ctx?.restoreGState()
        }
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
