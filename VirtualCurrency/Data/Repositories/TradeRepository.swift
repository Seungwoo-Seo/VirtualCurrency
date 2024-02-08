//
//  TradeRepository.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/08.
//

import Foundation

final class TradeRepository: TradeRepositoryProtocol {
    private let tradeDataSource: TradeDataSourceProtocol

    init(tradeDataSource: TradeDataSourceProtocol) {
        self.tradeDataSource = tradeDataSource
    }

    // MARK: - fetch

    func fetchTrades(request: TradeRequest) async throws -> [Trade] {
        do {
            try await tradeDataSource.fetchTrades(request: request)
        } catch {
            throw error
        }

        let tradeDTOs = tradeDataSource.getTrades()
        let trades = tradeDTOs.map { $0.toDomain() }

        return trades
    }
}
