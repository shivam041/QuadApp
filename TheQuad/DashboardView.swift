import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var entries: [LifeEntry]
    
    @State private var selectedDate: Date = Date()
    @State private var showingLogSheet: LifeQuadrant?
    
    // Filter entries for the specific selected day
    var dailyEntries: [LifeEntry] {
        let calendar = Calendar.current
        return entries.filter { calendar.isDate($0.date, inSameDayAs: selectedDate) }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // 1. The New Calendar Component
                    CalendarView(selectedDate: $selectedDate, entries: entries)
                        .padding(.horizontal)
                    
                    Text("Activity for \(selectedDate.formatted(date: .abbreviated, time: .omitted))")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .foregroundStyle(.gray)
                    
                    // 2. The 4 Quadrants Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(LifeQuadrant.allCases) { quadrant in
                            QuadrantCard(
                                quadrant: quadrant,
                                isDone: checkStatus(for: quadrant)
                            )
                            .onTapGesture {
                                showingLogSheet = quadrant
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .navigationTitle("Life OS")
            .sheet(item: $showingLogSheet) { quadrant in
                LogEntryView(quadrant: quadrant, date: selectedDate)
            }
        }
    }
    
    func checkStatus(for quad: LifeQuadrant) -> Bool {
        return dailyEntries.contains(where: { $0.quadrant == quad })
    }
}
