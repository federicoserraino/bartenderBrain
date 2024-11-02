//
//  PopupView.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 02/11/24.
//

import SwiftUI

struct PopupView: View {
    let items: [PopupItem]
    var bottomButton: (text: String, action: () -> Void)?
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea(.all)
            
            ZStack(alignment: .bottom) {
                ScrollSideBasedView {
                    VStack {
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
            .size(.init(width: 300, height: 300))
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
    case text(text: String, font: Font, topPadding: CGFloat)
    case iconWithText(icon: UIImage, text: String, topPadding: CGFloat, action: () -> Void)

    @ViewBuilder
    func view() -> some View {
        switch self {
        case .text(let text, let font, let topPadding):
            Text(text)
                .font(font)
                .padding(.top, topPadding)

        case .iconWithText(let icon, let text, let topPadding, let action):
            HStack(spacing: 5) {
                Image(uiImage: icon)
                    .resizable()
                    .scaledToFit()
                    .size(.init(width: 30, height: 30))
                
                Text(text)
                    .font(.system(size: 14))
            }
            .padding(.top, topPadding)
            .onTapGesture(perform: action)
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
