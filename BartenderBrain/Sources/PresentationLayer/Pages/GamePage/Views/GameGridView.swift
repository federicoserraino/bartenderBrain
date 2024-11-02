//
//  GameGridView.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 01/11/24.
//

import SwiftUI

struct GameGridView: View {
    let items: [GameCard]
    let didTapOnItem: (GameCard) -> Void

    var body: some View {
        let columnsCount = Int(sqrt(Double(items.count)).rounded())
        let columns = Array(repeating: GridItem(.flexible()), count: columnsCount)
        let itemSize = GridItemSize(columnsCount: columnsCount).size
        
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(items, id: \.id) { item in
                GameCardView(
                    item: item,
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
            case .L: .init(width: 80, height: 120)
            case .M: .init(width: 60, height: 90)
            case .S: .init(width: 50, height: 75)
            }
        }
    }
}

