//
//  BaseSwiftUIViewController.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 30/10/24.
//

import Foundation
import UIKit
import SwiftUI

class BaseSwiftUIViewController<ViewModel, ContentView: BaseSwiftUIView>: UIHostingController<ContentView> where ContentView.ViewModel == ViewModel {
    
    var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(rootView: ContentView.init(viewModel: viewModel))
    }
    
    @MainActor
    required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

