//
//  OrderbookRepository.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/11.
//

import Foundation

final class OrderbookRepository: OrderbookRepositoryProtocol {
    private let orderbookDataSource: OrderbookDataSourceProtocol

    init(orderbookDataSource: OrderbookDataSourceProtocol) {
        self.orderbookDataSource = orderbookDataSource
    }

    // MARK: - fetch

    func fetchOrderbooks(request: OrderbookRequest) async throws -> [Orderbook] {
        do {
            try await orderbookDataSource.fetchOrderbookDTOs(request: request)
        } catch {
            throw error
        }

        let orderbookDTOs = orderbookDataSource.getOrderbookDTOs()
        let orderbooks = orderbookDTOs.map { $0.toDomain() }

        return orderbooks
    }
}
