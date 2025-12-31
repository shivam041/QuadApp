import SwiftUI
import SwiftData
import PhotosUI

struct LogEntryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    let quadrant: LifeQuadrant
    let date: Date
    
    // Form Variables
    @State private var note: String = ""
    @State private var weight: Double? = nil
    @State private var reps: Int? = nil
    @State private var isRecipe: Bool = false
    @State private var rating: Int = 3
    
    // Media Variables
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var tempVideoURL: URL?
    @State private var isVideo: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Status") {
                    Text(quadrant.rawValue.uppercased())
                        .font(.headline)
                        .foregroundStyle(quadrant.color)
                }
                
                if quadrant == .iron {
                    Section("Strength Metrics") {
                        TextField("Weight (lbs)", value: $weight, format: .number)
                            .keyboardType(.decimalPad)
                        TextField("Reps", value: $reps, format: .number)
                            .keyboardType(.numberPad)
                    }
                }
                
                if quadrant == .life {
                    Section("Cookbook") {
                        Toggle("Is this a Recipe?", isOn: $isRecipe)
                        if isRecipe {
                            Picker("Rating", selection: $rating) {
                                ForEach(1...5, id: \.self) { star in
                                    Text("\(star) Stars").tag(star)
                                }
                            }
                        }
                    }
                }
                
                Section("Journal") {
                    TextEditor(text: $note)
                        .frame(height: 100)
                }
                
                Section("Media Evidence") {
                    PhotosPicker(selection: $selectedItem, matching: .any(of: [.images, .videos])) {
                        if isVideo {
                            ZStack {
                                Rectangle().fill(Color.gray.opacity(0.3)).frame(height: 200)
                                Image(systemName: "video.fill").font(.largeTitle)
                            }
                        } else if let selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable().scaledToFill()
                                .frame(height: 200).clipped().cornerRadius(8)
                        } else {
                            HStack {
                                Image(systemName: "camera")
                                Text("Upload Photo or Video")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Log Activity")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") { saveEntry() }.bold()
                }
            }
            .onChange(of: selectedItem) {
                Task {
                    // Check if Video
                    if let movie = try? await selectedItem?.loadTransferable(type: Movie.self) {
                        self.tempVideoURL = movie.url
                        self.isVideo = true
                        self.selectedImage = nil
                    }
                    // Check if Image
                    else if let data = try? await selectedItem?.loadTransferable(type: Data.self),
                            let uiImage = UIImage(data: data) {
                        self.selectedImage = uiImage
                        self.isVideo = false
                        self.tempVideoURL = nil
                    }
                }
            }
        }
    }
    
    func saveEntry() {
        let newEntry = LifeEntry(date: date, quadrant: quadrant, note: note)
        
        if quadrant == .iron {
            newEntry.weightLifted = weight
            newEntry.reps = reps
        }
        
        if quadrant == .life && isRecipe {
            newEntry.isRecipe = true
            newEntry.recipeRating = rating
        }
        
        // Save Media
        if isVideo, let url = tempVideoURL {
            newEntry.mediaFilename = MediaManager.shared.saveVideo(from: url)
            newEntry.isVideo = true
        } else if let img = selectedImage {
            newEntry.mediaFilename = MediaManager.shared.saveImage(image: img)
            newEntry.isVideo = false
        }
        
        modelContext.insert(newEntry)
        dismiss()
    }
}

// Helper to load Video from Picker
struct Movie: Transferable {
    let url: URL
    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(contentType: .movie) { movie in
            SentTransferredFile(movie.url)
        } importing: { received in
            let copy = FileManager.default.temporaryDirectory.appendingPathComponent(received.file.lastPathComponent)
            try FileManager.default.copyItem(at: received.file, to: copy)
            return Self.init(url: copy)
        }
    }
}
