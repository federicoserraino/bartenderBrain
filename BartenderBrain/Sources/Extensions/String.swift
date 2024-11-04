//
//  String.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 04/11/24.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "Retrieve localized string")
    }
}
