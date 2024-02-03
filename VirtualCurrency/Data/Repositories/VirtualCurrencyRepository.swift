//
//  VirtualCurrencyRepository.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/03.
//

import Foundation

final class VirtualCurrencyRepository: VirtualCurrencyRepositoryProtocol {
    private let marketDataSource: MarketDataSourceProtocol
    private let tickerDataSource: TickerDataSourceProtocol

    init(marketDataSource: MarketDataSourceProtocol, tickerDataSource: TickerDataSourceProtocol) {
        self.marketDataSource = marketDataSource
        self.tickerDataSource = tickerDataSource
    }

    // MARK: - get

    func getVirtualCurrencys() async throws -> [VirtualCurrency] {
        do {
            try await marketDataSource.fetchMarkets()
        } catch {
            throw error
        }

        let krwMarketDTOs = marketDataSource.getKRWMarkets()
        let krwCodes = krwMarketDTOs.compactMap { $0.code }

        do {
            try await tickerDataSource.fetchTickers(request: TickerRequest(marketCodes: krwCodes))
        } catch {
            throw error
        }

        let tickerDTOs = tickerDataSource.getTickers()

        let markets = krwMarketDTOs.map { $0.toDomain() }
        let tickers = tickerDTOs.map { $0.toDomain() }

        // 두 개를 합쳐서 VirtualCurrency로 만들어야함
        var results: [VirtualCurrency] = []

        for market in markets {
            for ticker in tickers {
                if ticker.code == market.market {
                    let virtualCurrency = VirtualCurrency(
                        name: market.krName,
                        code: market.market,
                        priceState: ticker.priceState,
                        currentPrice: ticker.currentPrice,
                        changeRate: ticker.changeRate,
                        changeAmount: ticker.changeAmount,
                        transactionAmount24: ticker.transactionAmount24
                    )

                    results.append(virtualCurrency)
                }
            }
        }

        return results
    }


    
}
