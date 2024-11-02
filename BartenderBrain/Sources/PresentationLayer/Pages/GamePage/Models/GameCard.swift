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
    
    func copyWith(
        id: String? = nil,
        image: UIImage? = nil,
        isFlipped: Bool? = nil,
        isLogoCard: Bool? = nil
    ) -> GameCard {
        .init(
            id: id ?? self.id,
            image: image ?? self.image,
            isFlipped: isFlipped ?? self.isFlipped,
            isLogoCard: isLogoCard ?? self.isLogoCard
        )
    }
    
    /*
    
    static func makeLogoCard() -> GameCard {
        CocktailCard(
            id: logoId,
            image: UIImage(),
            isLogoCard: true
        )
    }
     */
    
}
