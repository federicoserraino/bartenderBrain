//
//  Coordinator.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 30/10/24.
//

import Foundation
import UIKit

public protocol Coordinator: AnyObject {
    var rootViewController: UIViewController! { get }
    var parent: Coordinator? { get set }
    var child: Coordinator? { get set }
}
