//
//  WebSocketUseCase.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/03.
//

import Combine
import Foundation

protocol WebSocketUseCase {
    var realtimeDataSbj: PassthroughSubject<Data, Error> {get}
    func execute(type: WebSocketType, codes: [String])
}

enum WebSocketType: String {
    case trade
    case ticker
    case orderbook
}
