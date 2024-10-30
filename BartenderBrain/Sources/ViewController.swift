//
//  ViewController.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 28/10/24.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var pic: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(pic)
        NSLayoutConstraint.activate([
            pic.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pic.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            pic.heightAnchor.constraint(equalToConstant: 200),
            pic.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        Task {
            let pro = AppNetworkProvier.shared
            let drink = try await pro.getRandomCocktail()
            print("drinkID: \(drink.id)")
            let drinkImg = try await pro.getCocktailImageData(from: drink.thumbUrl)
            guard let thumb = UIImage(data: drinkImg) else { return }
            await MainActor.run {
                pic.image = thumb
            }
        }
    }


}

