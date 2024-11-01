//
//  Base2.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 30/10/24.
//

import Foundation
import UIKit
import SwiftUI

class BaseSwiftUIViewController2<ViewModel, ContentView: BaseSwiftUIView>: UIViewController where ContentView.ViewModel == ViewModel {
    
    private var hostingVC: UIHostingController<ContentView>?
    var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupContentView() {
        let hostingVC = UIHostingController(rootView: ContentView.init(viewModel: self.viewModel))
        self.addChild(hostingVC)
        hostingVC.didMove(toParent: self)
        self.hostingVC = hostingVC
        addHostingViewToHierarchy(hostingVC.view)
    }
    
    private func addHostingViewToHierarchy(_ hostingView: UIView) {
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingView)
        
        NSLayoutConstraint.activate([
            hostingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        
    }
    
}

