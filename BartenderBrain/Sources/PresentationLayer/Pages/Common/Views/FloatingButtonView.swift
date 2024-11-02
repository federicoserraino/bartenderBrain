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
    var verticalPadding: CGFloat
    var horizontalPadding: CGFloat
    var action: () -> Void
    
    init(
        text: String,
        backgroundColor: Color = .red,
        foregroundColor: Color = .white,
        cornerRadius: CGFloat = 30,
        fontSize: CGFloat = 14,
        fontWeight: Font.Weight = .bold,
        verticalPadding: CGFloat = 10,
        horizontalPadding: CGFloat = 20,
        action: @escaping () -> Void
    ) {
        self.text = text
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.cornerRadius = cornerRadius
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(text.uppercased())
                .font(.system(size: fontSize, weight: fontWeight))
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, verticalPadding)
                .background(backgroundColor)
                .foregroundColor(foregroundColor)
                .cornerRadius(cornerRadius)
        }
    }
}

#Preview {
    FloatingButtonView(text: "lorem ipsum", action: {})
}
