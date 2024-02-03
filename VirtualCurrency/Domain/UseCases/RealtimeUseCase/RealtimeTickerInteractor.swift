//
//  RealtimeTickerInteractor.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/03.
//

import Combine
import Foundation

final class RealtimeTickerInteractor: WebSocketUseCase {
    let realtimeDataSbj: PassthroughSubject<Data, Error>
    private let webSocket: WebSocketManger

    init() {
        self.realtimeDataSbj = PassthroughSubject<Data, Error>()
        self.webSocket = WebSocketManger(realtimeDataSbj: realtimeDataSbj)
    }

    deinit {
        webSocket.closeWebSocket()
        print(#function, "WebSocketInteractor")
    }

    func execute(type: WebSocketType, codes: [String]) {
        webSocket.openWebSocket()
        let string = """
        [
          {"ticket": "\(UUID())"},
          {"type": "\(type.rawValue)", "codes": \(codes)},
          {"format": "DEFAULT"}
        ]
        """

        webSocket.send(string: string)
    }

}
