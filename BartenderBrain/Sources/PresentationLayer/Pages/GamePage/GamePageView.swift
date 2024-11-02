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
            Color.green
                .edgesIgnoringSafeArea(.all)
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
                Text("⏳ " + viewModel.timerValue)
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
                        .frame(maxWidth: .infinity)
                        .scaleEffect(animateScore ? 1.3 : 1)
                        .onChange(of: viewModel.score) { _ in
                            withAnimation(.easeInOut(duration: 0.2)) {
                                animateScore = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    animateScore = false
                                }
                            }
                        }
                    
                    Text("Score")
                        .foregroundColor(.white)
                    
                }
                .padding(.vertical, 5)
                .background(Color.black.opacity(0.6))
                .overlay {
                    HStack() {
                        VStack(spacing: -5) {
                            Image(systemName: "line.horizontal.3")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 25, height: 30)
                            Text("Menu")
                                .foregroundColor(.white)
                        }
                        .padding(.leading, 15)
                        
                        Spacer()
                    }
                }
            }
            .padding(.bottom, 20)
            .edgesIgnoringSafeArea(.bottom)
        }
        .onAppear(perform: viewModel.prepareGame)
    }
    
}

/*
#Preview{
    //GamePageView(viewModel: .init())
}
*/
