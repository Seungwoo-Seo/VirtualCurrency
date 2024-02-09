//
//  TradeViewModel.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/09.
//

import Combine
import Foundation

final class TradeViewModel: ViewModelable {
    enum Action {
        case contentViewOnAppear
        case pagination
    }
    
    enum State {
        case trade([Trade])
        case none
    }

    @Published var state: State

    private var cancellable = Set<AnyCancellable>()

    // MARK: - UseCase
    private let tradesUseCase: TradesUseCase
    private let realtimeTradeInteractor: WebSocketUseCase?

    // 초기값
    private var trades: [Trade] = []

    let virtualCurrency: VirtualCurrency

    init(virtualCurrency: VirtualCurrency, tradesUseCase: TradesUseCase, realtimeTradeInteractor: WebSocketUseCase?) {
        self.state = .none
        self.virtualCurrency = virtualCurrency
        self.tradesUseCase = tradesUseCase
        self.realtimeTradeInteractor = realtimeTradeInteractor
    }

    func action(_ action: Action) {
        switch action {
        case .contentViewOnAppear:
            tradesUseCase.execute(code: virtualCurrency.code, count: 5, cursor: nil)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        print(error.localizedDescription)
                    case .finished:
                        print("finished")
                    }
                } receiveValue: { [weak self] (trades) in
                    guard let self else {return}
                    self.trades = trades
                    self.updateState()

                    self.realtimeTradeInteractor?.execute(type: .trade, codes: [self.virtualCurrency.code])
                }
                .store(in: &cancellable)

            realtimeTradeInteractor?.realtimeDataSbj
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        print(error.localizedDescription)
                    case .finished:
                        print("finished")
                    }
                } receiveValue: { [weak self] (data) in
                    guard let self else {return}

                    do {
                        let realtimeTradeDTO = try JSONDecoder().decode(RealtimeTradeDTO.self, from: data)
                        let trade = realtimeTradeDTO.toDomain()

                        self.trades.insert(trade, at: 0)
                        self.updateState()
                        
                    } catch {
                        print("❌")
                    }
                }
                .store(in: &cancellable)
            
        case .pagination:
            let cursor = trades.last?.cursor
            tradesUseCase.execute(code: virtualCurrency.code, count: 5, cursor: cursor)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        print(error.localizedDescription)
                    case .finished:
                        print("finished")
                    }
                } receiveValue: { [weak self] (trades) in
                    guard let self else {return}
                    self.trades += trades
                    self.updateState()
                }
                .store(in: &cancellable)
        }
    }

    func updateState() {
        state = .trade(trades)
    }
}
