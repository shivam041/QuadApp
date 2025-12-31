import SwiftUI
import SwiftData

@main
struct TheQuadApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                DashboardView()
                    .tabItem {
                        Label("Dashboard", systemImage: "square.grid.2x2")
                    }
                
                AnalyticsView()
                    .tabItem {
                        Label("Stats", systemImage: "chart.pie.fill")
                    }
                
                ExportView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
            .preferredColorScheme(.dark)
        }
        .modelContainer(for: LifeEntry.self)
    }
}
