//
//  GameCard.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 01/11/24.
//

import Foundation
import UIKit
import Combine

class GameCard: ObservableObject {
    let id: String
    let image: UIImage
    @Published var isFlipped: Bool
    // Logo cards are used to create a game grid that is as square as possible
    let isLogoCard: Bool
    static private let logoCardId: String = "logo_card"
    static private var logoCardCounter: Int = 0
    
    init(id: String, image: UIImage, isFlipped: Bool = false, isLogoCard: Bool = false) {
        self.id = id
        self.image = image
        self.isFlipped = isFlipped
        self.isLogoCard = isLogoCard
    }
    
    func makeDuplicate() -> GameCard {
        .init(
            id: id + "_2",
            image: image,
            isFlipped: isFlipped,
            isLogoCard: isLogoCard
        )
    }
    
    static func makeLogoCard() -> GameCard {
        logoCardCounter += 1
        return .init(
            id: logoCardId + "_\(logoCardCounter)",
            image: .icon_logoCard,
            isLogoCard: true
        )
    }
    
}
