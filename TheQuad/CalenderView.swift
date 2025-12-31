import SwiftUI
import SwiftData

struct CalendarView: View {
    @Binding var selectedDate: Date
    let entries: [LifeEntry]
    
    // Calendar Setup
    private let calendar = Calendar.current
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    // Date Formatter for Month Header
    private var monthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
    
    var body: some View {
        VStack(spacing: 15) {
            // Month Navigation
            HStack {
                Text(monthFormatter.string(from: selectedDate))
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                HStack(spacing: 20) {
                    Button(action: { changeMonth(by: -1) }) {
                        Image(systemName: "chevron.left")
                    }
                    Button(action: { changeMonth(by: 1) }) {
                        Image(systemName: "chevron.right")
                    }
                }
                .font(.title3)
                .foregroundStyle(.white)
            }
            .padding(.horizontal)
            
            // Days of Week Header
            HStack {
                ForEach(["S", "M", "T", "W", "T", "F", "S"], id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.gray)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // The Day Grid
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(daysInMonth(), id: \.self) { date in
                    if let date = date {
                        DayCell(date: date, selectedDate: selectedDate, entries: entries)
                            .onTapGesture {
                                selectedDate = date
                            }
                    } else {
                        // Empty space for offset
                        Text("")
                    }
                }
            }
        }
        .padding()
        .background(Color(uiColor: .systemGray6).opacity(0.3))
        .cornerRadius(20)
    }
    
    // Helpers
    func changeMonth(by value: Int) {
        if let newDate = calendar.date(byAdding: .month, value: value, to: selectedDate) {
            selectedDate = newDate
        }
    }
    
    func daysInMonth() -> [Date?] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: selectedDate) else { return [] }
        let monthFirstDay = monthInterval.start
        
        // Calculate empty slots at start of month
        let weekday = calendar.component(.weekday, from: monthFirstDay)
        let offset = weekday - 1
        
        var days: [Date?] = Array(repeating: nil, count: offset)
        
        // Add actual days
        if let range = calendar.range(of: .day, in: .month, for: selectedDate) {
            for day in range {
                if let date = calendar.date(byAdding: .day, value: day - 1, to: monthFirstDay) {
                    days.append(date)
                }
            }
        }
        
        return days
    }
}

struct DayCell: View {
    let date: Date
    let selectedDate: Date
    let entries: [LifeEntry]
    
    private let calendar = Calendar.current
    
    var isSelected: Bool {
        calendar.isDate(date, inSameDayAs: selectedDate)
    }
    
    var isToday: Bool {
        calendar.isDateInToday(date)
    }
    
    // Find quadrants completed on this specific day
    var dailyDots: [LifeQuadrant] {
        entries
            .filter { calendar.isDate($0.date, inSameDayAs: date) }
            .map { $0.quadrant }
            // Remove duplicates so we only show one dot per quadrant type
            .reduce(into: []) { (result, quad) in
                if !result.contains(quad) { result.append(quad) }
            }
    }
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(calendar.component(.day, from: date))")
                .font(.system(size: 16, weight: isSelected ? .bold : .regular))
                .foregroundStyle(isSelected ? .black : (isToday ? .blue : .white))
                .frame(width: 30, height: 30)
                .background(isSelected ? Color.white : Color.clear)
                .clipShape(Circle())
            
            // The Colored Dots
            HStack(spacing: 3) {
                ForEach(dailyDots) { quad in
                    Circle()
                        .fill(quad.color)
                        .frame(width: 4, height: 4)
                }
            }
            .frame(height: 4)
        }
    }
}
