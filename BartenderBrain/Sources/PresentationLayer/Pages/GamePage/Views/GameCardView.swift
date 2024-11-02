//
//  CardView.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 01/11/24.
//

import SwiftUI

struct GameCardView: View {
    @ObservedObject var item: GameCard
    let didTapOnItem: (GameCard) -> Void
    
    var body: some View {
        ZStack {
            // Flipped card
            CardView(color: .blue, text: nil)
                .opacity(item.isFlipped ? 1 : 0)
                .rotation3DEffect(
                    .degrees(item.isFlipped ? 0 : -180),
                    axis: (x: 0, y: 1, z: 0)
                )
                .animation(.easeInOut(duration: 0.5), value: item.isFlipped)
            
            // Upright card
            CardView(color: .red, text: item.id)
                .opacity(item.isFlipped ? 0 : 1)
                .rotation3DEffect(
                    .degrees(item.isFlipped ? 180 : 0),
                    axis: (x: 0, y: 1, z: 0)
                )
                .animation(.easeInOut(duration: 0.5), value: item.isFlipped)
        }
        .onTapGesture { didTapOnItem(item) }
    }
}

private struct CardView: View {
    let color: Color
    let text: String?
    
    var body: some View {
        Rectangle()
            .fill(color)
            .border(Color.black.opacity(0.8), width: 2)
            .overlay {
                if let text {
                    Text(text)
                }
            }
    }
}
