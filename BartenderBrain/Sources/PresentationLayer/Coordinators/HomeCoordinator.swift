//
//  HomeCoordinator.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 30/10/24.
//

import Foundation
import UIKit

final class HomeCoordinator: Coordinator {
    var rootViewController: UIViewController!
    var parent: Coordinator?
    var child: Coordinator?
    
    func start(from window: UIWindow) {
        let vc = BaseSwiftUIViewController<HomePageViewModel, HomePageView>(viewModel: .init())
        self.rootViewController = vc
        window.rootViewController = vc
        window.makeKeyAndVisible()
    }
    
}
