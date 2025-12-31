import SwiftUI
import SwiftData
import UniformTypeIdentifiers
import AVKit

struct ExportView: View {
    @Query var entries: [LifeEntry]
    
    @State private var startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
    @State private var endDate = Date()
    @State private var isProcessing = false
    @State private var generatedVideoURL: URL?
    @State private var showShareSheet = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Date Range") {
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                }
                
                Section("Reel Generator") {
                    Button(action: generateReel) {
                        if isProcessing {
                            HStack { Text("Stitching Videos..."); ProgressView() }
                        } else {
                            Label("Create Monthly Reel", systemImage: "film")
                        }
                    }
                    .disabled(isProcessing)
                    
                    if let url = generatedVideoURL {
                        ShareLink(item: url) {
                            Label("Save Reel to Photos", systemImage: "square.and.arrow.up")
                        }
                    }
                }
                
                Section("Info") {
                    Text("The Reel Generator stitches VIDEO clips only. Photos will be skipped in this version.")
                        .font(.caption).foregroundStyle(.gray)
                }
            }
            .navigationTitle("Content Studio")
        }
    }
    
    func generateReel() {
        isProcessing = true
        generatedVideoURL = nil
        
        // Use the calendar extension safely
        let start = Calendar.current.startOfDay(for: startDate)
        let end = Calendar.current.endOfDay(for: endDate)
        
        let filtered = entries.filter {
            $0.date >= start &&
            $0.date <= end &&
            $0.isVideo
        }
        
        if filtered.isEmpty {
            isProcessing = false
            return
        }
        
        // Call the service
        ReelService.shared.generateReel(from: filtered) { url in
            DispatchQueue.main.async {
                self.isProcessing = false
                self.generatedVideoURL = url
            }
        }
    }
}

// --- THIS WAS MISSING IN YOUR PREVIOUS STEP ---
extension Calendar {
    func endOfDay(for date: Date) -> Date {
        return self.date(bySettingHour: 23, minute: 59, second: 59, of: date) ?? date
    }
}
