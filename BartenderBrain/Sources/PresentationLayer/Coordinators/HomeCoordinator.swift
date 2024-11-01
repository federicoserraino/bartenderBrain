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
        let vm: HomePageViewModel = .init()
        vm.delegate = self
        let vc = BaseSwiftUIViewController<HomePageViewModel, HomePageView>(viewModel: vm)
        self.rootViewController = vc
        window.rootViewController = vc
        window.makeKeyAndVisible()
    }
    
}

extension HomeCoordinator: HomePageViewModelDelegate {
    func startGame(with cocktailPairsNum: Int) {
        //TODO
        print("startGame")
    }
}
