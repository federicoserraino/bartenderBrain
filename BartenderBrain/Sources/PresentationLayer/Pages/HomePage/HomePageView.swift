//
//  HomePageView.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 30/10/24.
//

import SwiftUI

struct HomePageView: BaseSwiftUIView {
    @ObservedObject var viewModel: HomePageViewModel
    
    init(viewModel: HomePageViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollSideBasedView {
                VStack(alignment: .leading, spacing: 0) {
                    
                    Text("Nome gioco")
                        .padding(.top, 50)
                        .frame(maxWidth: .infinity)
                    
                    Text("Coppie cocktail da trovare")
                        .padding(.top, 20)
                        .frame(maxWidth: .infinity)
                    
                    VStack(alignment: .center, spacing: 10) {
                        Image("icon_cards")
                            .resizable()
                            .scaledToFill()
                            .size(.init(width: 220, height: 200))
                        
                        Text(String(viewModel.cocktailPairsNum.toInt()))
                            .font(.system(size: 30))
                    }
                    .padding(.top, 30)
                    .frame(maxWidth: .infinity)
                    
                    HStack(spacing: 15) {
                        Text(String(HomePageViewModel.minCocktailPairs.toInt()))
                        Slider(value: $viewModel.cocktailPairsNum, in: HomePageViewModel.minCocktailPairs...15)
                            .padding()
                        Text(String(HomePageViewModel.maxCocktailPairs.toInt()))
                    }
                    
                    Text("Challenge mode: \(viewModel.challengeMode.emoji) \(viewModel.challengeMode.description)")
                }
                .padding(.horizontal, 20)
            }
            .padding(.bottom, 50)
            
            FloatingButtonView(text: "start game", action: viewModel.didTapStartButton)
        }
    }
}

