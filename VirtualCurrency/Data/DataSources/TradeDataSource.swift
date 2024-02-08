//
//  TradeDataSource.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/08.
//

import Foundation

protocol TradeDataSourceProtocol {
    func fetchTrades(request: TradeRequest) async throws
    func getTrades() -> [TradeDTO]
}

final class TradeDataSource: TradeDataSourceProtocol {
    private var tradeDTOs: [TradeDTO]

    private let httpManager: HTTPManager

    init(tradeDTOs: [TradeDTO] = [], httpManager: HTTPManager) {
        self.tradeDTOs = tradeDTOs
        self.httpManager = httpManager
    }
    // MARK: - fetch

    func fetchTrades(request: TradeRequest) async throws {
        do {
            tradeDTOs = try await httpManager.request(
                type: [TradeDTO].self,
                target: QuotationRouter.trade(request)
            )
        } catch {
            throw error
        }
    }

    // MARK: - get

    func getTrades() -> [TradeDTO] {
        return tradeDTOs
    }
}
