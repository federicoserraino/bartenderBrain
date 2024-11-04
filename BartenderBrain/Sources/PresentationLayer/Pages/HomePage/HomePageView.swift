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
                VStack(spacing: 0) {
                    Text("HOME_PAGE.TITLE".localized)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.accentColor)
                        .padding(.top, 30)
                    
                    Image(uiImage: .icon_cards)
                        .resizable()
                        .scaledToFill()
                        .size(.init(width: 220, height: 200))
                        .padding(.top, 40)
                    
                    Text(viewModel.cocktailsNumValue)
                        .font(.system(size: 26, weight: .semibold))
                        .foregroundColor(.accentColorSecondary)
                        .background(
                            Circle()
                                .fill(Color.accentColor)
                                .size(.init(width: 40, height: 40))
                        )
                        .padding(.top, 20)
                    
                    HStack(spacing: 15) {
                        VStack(spacing: 0) {
                            Text(String(HomePageViewModel.minCocktailPairs.toInt()))
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.accentColor)
                            Text("HOME_PAGE.MIN".localized)
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.accentColor)
                        }
                        
                        Slider(
                            value: $viewModel.cocktailPairsNum,
                            in: HomePageViewModel.minCocktailPairs...15
                        )
                        .tint(.accentColor)
                        .padding()
                        
                        VStack(spacing: 0) {
                            Text(String(HomePageViewModel.maxCocktailPairs.toInt()))
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.accentColor)
                            Text("HOME_PAGE.MAX".localized)
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.accentColor)
                        }
                    }
                    .padding(.top, 5)
                    
                    Text("HOME_PAGE.CHALLENGE_MODE".localized)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.accentColor)
                        .padding(.top, 15)
                    
                    Text(viewModel.challengeMode.emoji)
                        .font(.system(size: 40))
                        .padding(.top, 15)
                    
                    Text(viewModel.challengeMode.description)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.accentColor)
                        .padding(.top, 5)
                }
                .padding(.horizontal, 20)
            }
            .padding(.bottom, 50)
            
            VStack(spacing: 8) {
                if let topScore = viewModel.topScore {
                    Text("HOME_PAGE.TOP_SCORE".localized + " \(topScore)")
                        .font(.system(size: 12, weight: .bold))
                }
                
                FloatingButtonView(
                    text: "START_BUTTON".localized,
                    fontSize: 16,
                    elementSize: .init(width: 150, height: 50),
                    action: viewModel.didTapStartButton
                )
                .padding(.bottom, 10)
            }
        }
        .background(
            Image(uiImage: .background)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        )
    }
}

