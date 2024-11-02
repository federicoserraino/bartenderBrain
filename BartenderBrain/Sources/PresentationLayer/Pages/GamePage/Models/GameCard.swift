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
    static let logoId: String = "logo_card"
    
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
        .init(
            id: logoId,
            image: UIImage(),
            isLogoCard: true
        )
    }
    
}
