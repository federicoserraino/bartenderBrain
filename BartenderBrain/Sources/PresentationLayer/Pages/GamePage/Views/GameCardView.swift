//
//  CardView.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 01/11/24.
//

import SwiftUI

struct GameCardView: View {
    @ObservedObject var item: GameCard
    let itemSize: CGSize
    let didTapOnItem: (GameCard) -> Void
    
    var body: some View {
        ZStack {
            // Flipped card
            CardView(
                image: .icon_cardBack,
                size: itemSize
            )
            .opacity(item.isFlipped ? 1 : 0)
            .rotation3DEffect(
                .degrees(item.isFlipped ? 0 : -180),
                axis: (x: 0, y: 1, z: 0)
            )
            .animation(.easeInOut(duration: 0.5), value: item.isFlipped)
            
            // Upright card
            CardView(
                image: item.image,
                size: itemSize
            )
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
    let image: UIImage
    let size: CGSize
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .size(size)
            .cornerRadius(8)
            .clipped()
    }
}
