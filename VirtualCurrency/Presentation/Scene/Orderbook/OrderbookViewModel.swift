//
//  OrderbookViewModel.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/11.
//

import Combine
import Foundation

final class OrderbookViewModel: ViewModelable {
    enum Action {
        case contentViewOnAppear
        case contentViewOnDisappear
    }

    enum State {
        case none
        case orderbook(Orderbook, [Trade], Ticker)
    }

    @Published var state: State

    private var cancellable = Set<AnyCancellable>() // dispose

    // MARK: - UseCase
    private let orderbookUseCase: OrderbookUseCase
    private let tradesUseCase: TradesUseCase

    // 소켓 UseCase
    private var realtimeOrderbookInteractor: WebSocketUseCase?
    private var realtimeTradeInteractor: WebSocketUseCase?
    private var realtimeTickerInteractor: WebSocketUseCase?

    // 초기값
    private var orderbook: Orderbook = Orderbook(totalAskSize: 0, totalBidSize: 0, orderbookUnits: [])
    private var trades: [Trade] = []
    private var ticker: Ticker = Ticker(code: "", openPrice: 0, highPrice: 0, lowPrice: 0, currentPrice: 0, priceState: .even, changeRate: 0, tradeVolume: 0, changeAmount: 0, transactionAmount24: 0, tradeVolume24: 0, highest52WeekPrice: 0, highest52WeekDate: "", lowest52WeekPrice: 0, lowest52WeekDate: "", prevClosingPrice: 0, timestamp: 0)

    let virtualCurrency: VirtualCurrency

    init(virtualCurrency: VirtualCurrency, orderbookUseCase: OrderbookUseCase, tradesUseCase: TradesUseCase, realtimeOrderbookInteractor: WebSocketUseCase?, realtimeTradeInteractor: WebSocketUseCase?, realtimeTickerInteractor: WebSocketUseCase?) {
        self.state = .none
        self.virtualCurrency = virtualCurrency
        self.orderbookUseCase = orderbookUseCase
        self.tradesUseCase = tradesUseCase
        self.realtimeOrderbookInteractor = realtimeOrderbookInteractor
        self.realtimeTradeInteractor = realtimeTradeInteractor
        self.realtimeTickerInteractor = realtimeTickerInteractor
    }

    deinit {
        print(#function, "OrderbookViewModel")
    }

    func action(_ action: Action) {
        switch action {
        case .contentViewOnDisappear:
            realtimeOrderbookInteractor = nil

        case .contentViewOnAppear:
            // 호가
            orderbookUseCase.execute(code: virtualCurrency.code)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        print(error.localizedDescription)
                    case .finished:
                        print("finished")
                    }
                } receiveValue: { [weak self] (orderbook) in
                    guard let self,
                            let webSocketInteractor = self.realtimeOrderbookInteractor,
                            let realtimeTickerInteractor = self.realtimeTickerInteractor else {
                        return
                    }

                    self.orderbook = orderbook
                    self.updateState()

                    webSocketInteractor.execute(type: .orderbook, codes: [self.virtualCurrency.code])
                    realtimeTickerInteractor.execute(type: .ticker, codes: [self.virtualCurrency.code])
                }
                .store(in: &cancellable)

            // 체결
            tradesUseCase.execute(code: virtualCurrency.code, count: 15, cursor: nil)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        print(error.localizedDescription)
                    case .finished:
                        print("finished")
                    }
                } receiveValue: { [weak self] (trades) in
                    guard let self,
                          let realtimeTradeInteractor = self.realtimeTradeInteractor else {
                        return
                    }

                    self.trades = trades
                    self.updateState()

                    realtimeTradeInteractor.execute(type: .trade, codes: [self.virtualCurrency.code])
                }
                .store(in: &cancellable)

            // 실시간 호가
            realtimeOrderbookInteractor?.realtimeDataSbj
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
                        let realtimeOrderbookDTO = try JSONDecoder().decode(RealtimeOrderbookDTO.self, from: data)
                        let orderbook = realtimeOrderbookDTO.toDomain()

                        self.orderbook = orderbook
                        self.updateState()

                        print("🥊🥊🥊🥊🥊")
                    } catch {
                        print("❌")
                    }
                }
                .store(in: &cancellable)

            // 실시간 체결
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

                    let string = String(data: data, encoding: .utf8)
                    do {
                        let realtimeTradeDTO = try JSONDecoder().decode(RealtimeTradeDTO.self, from: data)
                        let trade = realtimeTradeDTO.toDomain()

                        self.trades.insert(trade, at: 0)
                        self.trades.removeLast()
                        self.updateState()

                        print("💻💻💻💻💻💻")
                    } catch {
                        print("❌")
                    }
                }
                .store(in: &cancellable)

            // 실시간 현재가
            realtimeTickerInteractor?.realtimeDataSbj
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
                        let realtimeTickerDTO = try JSONDecoder().decode(RealtimeTickerDTO.self, from: data)
                        let ticker = realtimeTickerDTO.toDomain()
                        self.ticker = ticker
                        self.updateState()

                        print("🤪🤪🤪🤪🤪")
                    } catch {
                        print("❌")
                    }
                }
                .store(in: &cancellable)
        }
    }

    func updateState() {
        state = .orderbook(orderbook, trades, ticker)
    }
}
