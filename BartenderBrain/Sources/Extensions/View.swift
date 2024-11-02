//
//  View.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 01/11/24.
//

import SwiftUI

extension View {
    func scrollable(if condition: Bool, scrollTopPadding: Double = 0, scrollBottomPadding: Double = 0) -> some View {
        Group {
            if condition {
                ScrollSideBasedView {
                    Spacer()
                        .frame(height: scrollTopPadding)
                    self
                    Spacer()
                        .frame(height: scrollBottomPadding)
                }
            } else {
                self
            }
        }
    }
    
    func size(_ size: CGSize) -> some View {
          self.frame(width: size.width, height: size.height)
      }
}
