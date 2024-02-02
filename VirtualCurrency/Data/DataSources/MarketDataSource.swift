//
//  MarketDataSource.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/02.
//

import Foundation

protocol MarketDataSourceProtocol {
    func fetchMarkets() async throws
    func getAllMarkets() -> [MarketDTO]
    func getKRWMarkets() -> [MarketDTO]
    func getBTCMarkets() -> [MarketDTO]
    func getUSDTMarkets() -> [MarketDTO]
}

final class MarketDataSource: MarketDataSourceProtocol {
    private var markets: [MarketDTO]

    let httpManager: HTTPManager

    init(markets: [MarketDTO] = [], httpManager: HTTPManager) {
        self.markets = markets
        self.httpManager = httpManager
    }

    // MARK: - fetch

    func fetchMarkets() async throws {
        do {
            markets = try await httpManager.request(
                type: [MarketDTO].self,
                target: QuotationRouter.marketCode
            )
        } catch {
            throw error
        }
    }

    // MARK: - get

    func getAllMarkets() -> [MarketDTO] {
        return markets
    }

    func getKRWMarkets() -> [MarketDTO] {
        return markets.filter { $0.code?.contains("KRW") == true }
    }

    func getBTCMarkets() -> [MarketDTO] {
        return markets.filter { $0.code?.contains("BTC") == true }
    }

    func getUSDTMarkets() -> [MarketDTO] {
        return markets.filter { $0.code?.contains("USDT") == true }
    }
}
