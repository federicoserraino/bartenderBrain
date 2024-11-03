//
//  GamePageView.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 01/11/24.
//

import Foundation
import SwiftUI

struct GamePageView: BaseSwiftUIView {
    @ObservedObject var viewModel: GamePageViewModel
    @State var animateScore: Bool = false
    
    init(viewModel: GamePageViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            GameGridView(
                items: viewModel.cardsDeck,
                didTapOnItem: viewModel.didTapOnCard
            )
            .scrollable(
                if: false,
                scrollTopPadding: 60,
                scrollBottomPadding: 40
            )
            
            VStack(spacing: 0) {
                // Timer View
                Text("⏳ " + viewModel.timerValueDescription)
                    .padding(.vertical, 10)
                    .frame(width: 115)
                    .foregroundColor(.white)
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(20)
                    .padding(.top, 5)
                
                Spacer()
                
                // Bottom View
                VStack(spacing: 0) {
                    Text("\(viewModel.score)")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .scaleEffect(animateScore ? 1.3 : 1)
                        .onChange(of: viewModel.score) { _ in
                            withAnimation(.easeInOut(duration: 0.1)) {
                                animateScore = true
                            }
                            // Adddd delay to enhance UX
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation(.easeInOut(duration: 0.1)) {
                                    animateScore = false
                                }
                            }
                        }
                    
                    Text("SCORE")
                        .font(.system(size: 10))
                        .foregroundColor(.white)
                }
                .padding(.vertical, 5)
                .background(Color.black.opacity(0.6))
                .overlay {
                    HStack() {
                        VStack(spacing: 3) {
                            Image(systemName: "line.horizontal.3")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 10, height: 12)
                                .foregroundColor(.white)
                            
                            Text("Menu")
                                .font(.system(size: 10))
                                .foregroundColor(.white)
                            
                        }
                        .padding(.leading, 15)
                        .onTapGesture(perform: viewModel.didtapOnMenu)
                        
                        Spacer()
                    }
                }
            }
            .padding(.bottom, 20)
            .edgesIgnoringSafeArea(.bottom)
        }
        .background(
            Image(uiImage: .background_game)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        )
        .onAppear(perform: viewModel.prepareAndStartGame)
        .onDisappear(perform: viewModel.endGame)
    }
    
}
