//
//  Coordinator.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 30/10/24.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var rootViewController: UIViewController! { get set }
    var parent: Coordinator? { get set }
    var child: Coordinator? { get set }
    func removeChild()
    func dismissCoordinator()
}

extension Coordinator {
    func removeChild() {
        child = nil
    }
    
    func dismissCoordinator() {
        parent?.removeChild()
        parent = nil
        child = nil
        rootViewController.dismiss(animated: true) { [weak self] in
            self?.rootViewController = nil
        }
    }
}
