//
//  DIContainer.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/04.
//

import Foundation

final class DIContainer {

    static func exChangeInject() -> ExchangeViewModel {
        let httpManager = HTTPManager.shared
        let marketDataSource = MarketDataSource(httpManager: httpManager)
        let tickerDataSource = TickerDataSource(httpManager: httpManager)

        let virtualCurrencyRepository = VirtualCurrencyRepository(
            marketDataSource: marketDataSource,
            tickerDataSource: tickerDataSource
        )

        let fetch = VirtualCurrencyInteractor(repository: virtualCurrencyRepository)
        let realtimeOrderbookInteractor = RealtimeOrderbookInteractor()

        return ExchangeViewModel(
            fetchKRWVirtualCurrency: fetch,
            realtimeOrderbookInteractor: realtimeOrderbookInteractor
        )
    }

}
