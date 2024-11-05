//
//  BaseViewModel.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 30/10/24.
//

import Foundation
import Combine

class BaseViewModel: ObservableObject {
    var cancellables: Set<AnyCancellable>
    
    init() {
        cancellables = Set()
        bindingProperties()
        bindingActions()
    }
    
    func bindingProperties() {}
    func bindingActions() {}
    
}

