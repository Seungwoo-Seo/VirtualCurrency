//
//  WebSocketManager.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/01/31.
//

import Combine
import Foundation

extension NetworkError {
    enum WebSocketError: Error {
        case invaildUrl
        case invaildSend
        case invaildParsing

        var description: String {
            switch self {
            case .invaildUrl: return "유효하지 않은 URL"
            case .invaildSend: return "유효하지 않은 send"
            case .invaildParsing: return "잘못된 파싱"
            }
        }
    }
}

final class WebSocketManger: NSObject {

    var task: URLSessionWebSocketTask?
    private var timer: Timer?
    var isOpen = false

    var realtimeDataSbj: PassthroughSubject<Data, Error>

    init(realtimeDataSbj: PassthroughSubject<Data, Error>) {
        self.realtimeDataSbj = realtimeDataSbj
        super.init()
    }

    func openWebSocket() {
        if let url = URL(string: NetworkBase.webSocketBaseURL), !isOpen {
            let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
            task = session.webSocketTask(with: url)
            task?.resume()
            ping()
        }
    }

    func send(string: String) {
        task?.send(.string(string), completionHandler: { [weak self] (error) in
            if let error {
                self?.closeWebSocket()
                self?.realtimeDataSbj.send(completion: .failure(error))
            }
        })
    }

    func receive() {
        if isOpen {
            task?.receive(completionHandler: { [weak self] (result) in
                guard let self else {return}
                switch result {
                case .success(let success):
                    switch success {
                    case .data(let data):
                        self.realtimeDataSbj.send(data)
                        self.receive()
                        
                    case .string(_):
                        self.closeWebSocket()
                        self.realtimeDataSbj.send(completion: .failure(NetworkError.WebSocketError.invaildSend))

                    @unknown default:
                        self.closeWebSocket()
                        self.realtimeDataSbj.send(completion: .failure(NetworkError.WebSocketError.invaildSend))
                    }
                case .failure(let error):
                    self.closeWebSocket()
                    self.realtimeDataSbj.send(completion: .failure(error))
                }
            })
        }
    }

    func closeWebSocket() {
        task?.cancel(with: .goingAway, reason: nil)
        task = nil
        timer?.invalidate()
        timer = nil
        isOpen = false
    }

    private func ping() {
        timer = Timer(timeInterval: 5.0, repeats: true, block: { [weak self] (timer) in
            self?.task?.sendPing(pongReceiveHandler: { error in
                if let error {
                    self?.closeWebSocket()
                    self?.realtimeDataSbj.send(completion: .failure(error))
                }
            })
        })
    }

    deinit {
        closeWebSocket()
    }

}

extension WebSocketManger: URLSessionWebSocketDelegate {

    func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didOpenWithProtocol protocol: String?
    ) {
        isOpen = true
        receive()
    }

    func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
        reason: Data?
    ) {
        isOpen = false
    }

}

