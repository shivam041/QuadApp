import SwiftUI
import SwiftData
import Charts

struct AnalyticsView: View {
    @Query var entries: [LifeEntry]
    
    var body: some View {
        NavigationStack {
            List {
                Section("Life Balance Breakdown") {
                    if entries.isEmpty {
                        Text("Log data to see analytics")
                            .foregroundStyle(.gray)
                    } else {
                        Chart(entries) { entry in
                            SectorMark(
                                angle: .value("Count", 1),
                                innerRadius: .ratio(0.5),
                                angularInset: 1.5
                            )
                            .foregroundStyle(entry.quadrant.color)
                        }
                        .frame(height: 200)
                    }
                }
                
                Section("Media Bin (Local Storage)") {
                    if entries.filter({ $0.mediaFilename != nil }).isEmpty {
                         Text("No photos uploaded yet.")
                    }
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                        ForEach(entries.filter { $0.mediaFilename != nil }) { entry in
                            if let filename = entry.mediaFilename,
                               let image = MediaManager.shared.loadImage(filename: filename) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipped()
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Analytics")
        }
    }
}
