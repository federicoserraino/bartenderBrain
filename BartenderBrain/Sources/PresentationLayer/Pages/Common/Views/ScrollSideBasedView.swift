//
//  ScrollSideBasedView.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 30/10/24.
//

import SwiftUI

struct ScrollSideBasedView<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            content
        }
        .scrollBounceBehavior(.basedOnSize)
    }
}
