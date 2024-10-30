//
//  HomeCoordinator.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 30/10/24.
//

import Foundation
import UIKit

final class HomeCoordinator {
    
    func start(from window: UIWindow) {
        let vc = ViewController()
        window.rootViewController = vc
        window.makeKeyAndVisible()
    }
    
}
