//
//  LoaderManager.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 03/11/24.
//

import Foundation
import UIKit

@MainActor
protocol LoaderManager: AnyObject {
    func showLoader()
    func hideLoader()
}

final class AppLoaderManager: LoaderManager {
    static let shared: LoaderManager = AppLoaderManager()
    private init() {}
    private var loaderView: UIView?
    
    func showLoader() {
        guard loaderView == nil,
              let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first
        else { return }
        // Create Background
        let loaderBackgroundView = UIView(frame: window.bounds)
        loaderBackgroundView.backgroundColor = .black.withAlphaComponent(0.6)
        // Create Loader
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.center = loaderBackgroundView.center
        activityIndicator.startAnimating()
        // Show Loader
        loaderBackgroundView.addSubview(activityIndicator)
        window.addSubview(loaderBackgroundView)
        loaderView = loaderBackgroundView
    }
    
    func hideLoader() {
        loaderView?.removeFromSuperview()
        loaderView = nil
    }
    
}
