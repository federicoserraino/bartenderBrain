//
//  BaseSwiftUIView.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 30/10/24.
//

import Foundation
import SwiftUI

protocol BaseSwiftUIView: View {
    associatedtype ViewModel: BaseViewModel
    
    var viewModel: ViewModel { get set }
    init(viewModel: ViewModel)
}
