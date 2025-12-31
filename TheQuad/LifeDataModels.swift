import Foundation
import SwiftData
import SwiftUI

// 1. Define the 4 Quadrants
enum LifeQuadrant: String, Codable, CaseIterable, Identifiable {
    case career = "Career"
    case iron = "Iron"
    case temple = "Temple"
    case life = "Life"
    
    var id: String { self.rawValue }
    
    var color: Color {
        switch self {
        case .career: return .blue
        case .iron: return .red
        case .temple: return .purple
        case .life: return .green
        }
    }
    
    var icon: String {
        switch self {
        case .career: return "briefcase.fill"
        case .iron: return "dumbbell.fill"
        case .temple: return "laurel.leading"
        case .life: return "figure.socialdance"
        }
    }
}

// 2. Define the Main Database Entry
@Model
class LifeEntry {
    var id: UUID
    var date: Date
    var quadrantRaw: String
    var note: String
    var mediaFilename: String?
    var isVideo: Bool = false // NEW: Track if it is a video
    
    // Iron Specifics
    var weightLifted: Double?
    var reps: Int?
    
    // Life/Cookbook Specifics
    var isRecipe: Bool
    var recipeRating: Int?
    
    init(date: Date, quadrant: LifeQuadrant, note: String = "") {
        self.id = UUID()
        self.date = date
        self.quadrantRaw = quadrant.rawValue
        self.note = note
        self.isRecipe = false
        self.isVideo = false
    }
    
    var quadrant: LifeQuadrant {
        return LifeQuadrant(rawValue: quadrantRaw) ?? .life
    }
}
