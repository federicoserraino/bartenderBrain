//
//  View.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 01/11/24.
//

import SwiftUI

extension View {
    func scrollable(if condition: Bool) -> some View {
        Group {
            if condition {
                ScrollView { self }
            } else {
                self
            }
        }
    }
}
