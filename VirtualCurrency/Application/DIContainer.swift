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

    static func chartInject(virtualCurrency: VirtualCurrency) -> ChartViewModel {
        let httpManager = HTTPManager.shared
        let candleDataSource = CandleDataSource(httpManager: httpManager)
        let candleRepository = CandleRepository(candleDataSource: candleDataSource)
        let candleUseCase = CandleInteractor(repository: candleRepository)
        let realtimeTickerInteractor = RealtimeTickerInteractor()

        return ChartViewModel(
            virtualCurrency: virtualCurrency,
            candleUseCase: candleUseCase,
            realtimeTickerInteractor: realtimeTickerInteractor
        )
    }
}
