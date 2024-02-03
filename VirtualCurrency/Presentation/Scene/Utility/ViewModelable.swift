//
//  ViewModelable.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/03.
//

import SwiftUI

protocol ViewModelable: ObservableObject {
    associatedtype Action
    associatedtype State

    var state: State { get }

    func action(_ action: Action)

    func updateState()
}
