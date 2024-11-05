//
//  File.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 03/11/24.
//

import Foundation
import Combine

class SubjectSender<T> {
    let subject = PassthroughSubject<T, Never>()
    
    func sendValue(_ value: T) {
        subject.send(value)
    }
}
