//
//  GameGridView.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 01/11/24.
//

import SwiftUI

struct GameGridView: View {
    let items: [GameCard]
    let columnsCount: Int
    let didTapOnItem: (GameCard) -> Void

    var body: some View {
        let columns = Array(repeating: GridItem(.flexible()), count: columnsCount)
        let itemSize = GridItemSize(columnsCount: columnsCount).size
        
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(items, id: \.id) { item in
                GameCardView(
                    item: item,
                    itemSize: itemSize,
                    didTapOnItem: didTapOnItem
                )
                .size(itemSize)
                .padding(.bottom, 15)
            }
        }
    }
    
    enum GridItemSize {
        case L
        case M
        case S
        
        init(columnsCount: Int) {
            switch columnsCount {
            case 0...3:
                self = .L
            case 4:
                self = .M
            default:
                self = .S
            }
        }
        
        var size: CGSize {
            switch self {
            case .L: .init(width: 90, height: 135)
            case .M: .init(width: 70, height: 105)
            case .S: .init(width: 55, height: 82.5)
            }
        }
    }
}
