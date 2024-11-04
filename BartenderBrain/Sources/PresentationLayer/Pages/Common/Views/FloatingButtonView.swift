//
//  FloatingButtonView.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 02/11/24.
//

import SwiftUI

struct FloatingButtonView: View {
    var text: String
    var backgroundColor: Color
    var foregroundColor: Color
    var cornerRadius: CGFloat
    var fontSize: CGFloat
    var fontWeight: Font.Weight
    var elementSize: CGSize
    var action: () -> Void
    
    init(
        text: String,
        backgroundColor: Color = .accentColor,
        foregroundColor: Color = .accentColorSecondary,
        cornerRadius: CGFloat = 30,
        fontSize: CGFloat = 14,
        fontWeight: Font.Weight = .bold,
        elementSize: CGSize = .init(width: 100, height: 40),
        action: @escaping () -> Void
    ) {
        self.text = text
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.cornerRadius = cornerRadius
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.elementSize = elementSize
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(text.uppercased())
                .font(.system(size: fontSize, weight: fontWeight))
                .size(elementSize)
                .background(backgroundColor)
                .foregroundColor(foregroundColor)
                .cornerRadius(cornerRadius)
        }
    }
}
