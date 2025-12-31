import UIKit

class MediaManager {
    static let shared = MediaManager()
    
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    // Save Photo
    func saveImage(image: UIImage) -> String? {
        let filename = UUID().uuidString + ".jpg"
        let fileURL = getDocumentsDirectory().appendingPathComponent(filename)
        
        if let data = image.jpegData(compressionQuality: 0.8) {
            try? data.write(to: fileURL)
            return filename
        }
        return nil
    }
    
    // NEW: Save Video
    func saveVideo(from sourceURL: URL) -> String? {
        let filename = UUID().uuidString + ".mp4"
        let destinationURL = getDocumentsDirectory().appendingPathComponent(filename)
        
        do {
            if FileManager.default.fileExists(atPath: destinationURL.path) {
                try FileManager.default.removeItem(at: destinationURL)
            }
            try FileManager.default.copyItem(at: sourceURL, to: destinationURL)
            return filename
        } catch {
            print("Video save error: \(error)")
            return nil
        }
    }
    
    // Load Photo
    func loadImage(filename: String) -> UIImage? {
        let fileURL = getDocumentsDirectory().appendingPathComponent(filename)
        do {
            let data = try Data(contentsOf: fileURL)
            return UIImage(data: data)
        } catch {
            return nil
        }
    }
    
    // NEW: Get Video URL
    func getVideoURL(filename: String) -> URL {
        return getDocumentsDirectory().appendingPathComponent(filename)
    }
}
