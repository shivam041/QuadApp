import SwiftUI

struct QuadrantCard: View {
    let quadrant: LifeQuadrant
    let isDone: Bool
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: quadrant.icon)
                    .font(.title2)
                Spacer()
                if isDone {
                    Text("DONE")
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(4)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(4)
                }
            }
            Spacer()
            Text(quadrant.rawValue)
                .font(.title3)
                .fontWeight(.heavy)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .frame(height: 140)
        .background(isDone ? quadrant.color : Color(uiColor: .systemGray6))
        .foregroundColor(isDone ? .black : .gray)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(quadrant.color, lineWidth: isDone ? 0 : 2)
        )
    }
}
