//
//  PopupView.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 02/11/24.
//

import SwiftUI

struct PopupView: View {
    let items: [PopupItem]
    var estimatedSize: CGSize = .init(width: 300, height: 300)
    var bottomButton: (text: String, action: () -> Void)?
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea(.all)
            
            ZStack(alignment: .bottom) {
                ScrollSideBasedView {
                    VStack(spacing: 0) {
                        ForEach(items.indices, id: \.self) { index in
                            items[index].view()
                        }
                    }
                }
                .padding(.bottom, 40)
                
                if let bottomButton {
                    FloatingButtonView(text: bottomButton.text, action: bottomButton.action)
                    .padding(.bottom, 15)
                }
            }
            .size(estimatedSize)
            .background(.white)
            .cornerRadius(10)
        }
    }
    
    var viewControllerEmbedded: UIViewController {
        let vc = UIHostingController(rootView: self)
        vc.view.backgroundColor = .clear
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        return vc
    }
}

enum PopupItem {
    case title(text: String, topPadding: CGFloat = 30)
    case text(text: String, font: Font, alignment: TextAlignment = .center, topPadding: CGFloat = 15, horizzontalPadding: CGFloat = 20)
    case iconWithText(icon: UIImage, text: String, topPadding: CGFloat = 15, action: () -> Void)
    case divider(topPadding: CGFloat = 15)

    @ViewBuilder
    func view() -> some View {
        switch self {
        case .title(let text, let topPadding):
            Text(text)
                .font(.system(size: 24, weight: .bold))
                .padding(.top, topPadding)
        case .text(let text, let font, let alignment, let topPadding, let horizontalPadding):
            HStack {
                if alignment == .trailing {
                    Spacer()
                }
                Text(text)
                    .font(font)
                    .multilineTextAlignment(alignment)
                    .padding(.top, topPadding)
                    .padding(.horizontal, horizontalPadding)
                if alignment == .leading {
                    Spacer()
                }
            }
            
        case .iconWithText(let icon, let text, let topPadding, let action):
            VStack(spacing: 5) {
                Image(uiImage: icon)
                    .resizable()
                    .scaledToFit()
                    .size(.init(width: 30, height: 30))
                
                Text(text)
                    .font(.system(size: 14))
            }
            .padding(.top, topPadding)
            .onTapGesture(perform: action)
            
        case .divider(let topPadding):
            Divider()
                .frame(height: 1)
                .background(Color.black.opacity(0.8))
                .padding(.horizontal, 15)
                .padding(.top, topPadding)
        }
    }
}

#Preview {
    PopupView(items: [
        .text(text: "prova", font: .system(size: 12), topPadding: 10),
        .text(text: "prova", font: .system(size: 12), topPadding: 10),
        .text(text: "prova", font: .system(size: 12), topPadding: 10),
        .text(text: "prova", font: .system(size: 12), topPadding: 10),
        .text(text: "prova", font: .system(size: 12), topPadding: 10),
        .text(text: "prova", font: .system(size: 12), topPadding: 10)
    ],
          bottomButton: (text: "prova", action: {})
    )
}
