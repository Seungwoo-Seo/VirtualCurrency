//
//  ExchangeViewModel.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/04.
//

import Combine
import Foundation

final class ExchangeViewModel: ViewModelable {
    enum Action {
        case contentViewOnAppear
    }

    enum State {
        case none
        case virtualCurrencys([VirtualCurrency])
    }

    @Published var state: State

    @Published var diffItem: Ticker?

    private var virtualCurrencys: [VirtualCurrency] = []

    private var cancellable = Set<AnyCancellable>()

    let fetchKRWVirtualCurrency: VirtualCurrencyUseCase
    let realtimeOrderbookInteractor: WebSocketUseCase

    init(
        fetchKRWVirtualCurrency: VirtualCurrencyUseCase,
        realtimeOrderbookInteractor: WebSocketUseCase
    ) {
        self.state = .none
        self.fetchKRWVirtualCurrency = fetchKRWVirtualCurrency
        self.realtimeOrderbookInteractor = realtimeOrderbookInteractor
    }

    func action(_ action: Action) {
        switch action {
        case .contentViewOnAppear:
            fetchKRWVirtualCurrency.execute()
                .receive(on: DispatchQueue.main)
                .sink { error in
                    switch error {
                    case .failure(let error):
                        print(error.localizedDescription)
                    case .finished:
                        print("finished")
                    }
                } receiveValue: { [weak self] (items) in
                    guard let self else {return}
                    self.virtualCurrencys = items
                    self.updateState()

                    let codes = items.map { $0.code }
                    self.realtimeOrderbookInteractor.execute(type: .ticker, codes: codes)
                }
                .store(in: &cancellable)

            realtimeOrderbookInteractor.realtimeDataSbj
                .receive(on: DispatchQueue.main)
                .sink { error in
                    switch error {
                    case .failure(let error):
                        print(error.localizedDescription)
                    case .finished:
                        print("finished")
                    }
                } receiveValue: { [weak self] (data) in
                    guard let self else {return}

                    do {
                        let tickerDTO = try JSONDecoder().decode(RealtimeTickerDTO.self, from: data)
                        let ticker = tickerDTO.toDomain()

                        if let index = self.virtualCurrencys.firstIndex(where: { $0.code == ticker.code }) {
                            self.virtualCurrencys[index].priceState = ticker.priceState
                            self.virtualCurrencys[index].currentPrice = ticker.currentPrice
                            self.virtualCurrencys[index].changeRate = ticker.changeRate
                            self.virtualCurrencys[index].changeAmount = ticker.changeAmount
                            self.virtualCurrencys[index].transactionAmount24 = ticker.transactionAmount24
                            self.updateState()
                            self.diffItem = ticker
                        }
                    } catch {
                        print("❌")
                    }
                }
                .store(in: &cancellable)
        }
    }

    func updateState() {
        state = .virtualCurrencys(virtualCurrencys)
    }

}
