//
//  OrderbookDataSource.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/11.
//

import Foundation

protocol OrderbookDataSourceProtocol {
    func fetchOrderbookDTOs(request: OrderbookRequest) async throws
    func getOrderbookDTOs() -> [OrderbookDTO]
}

final class OrderbookDataSource: OrderbookDataSourceProtocol {
    private var orderbookDTOs: [OrderbookDTO] = []

    private let httpManager: HTTPManager

    init(orderbookDTOs: [OrderbookDTO] = [], httpManager: HTTPManager) {
        self.orderbookDTOs = orderbookDTOs
        self.httpManager = httpManager
    }

    // MARK: - fetch

    func fetchOrderbookDTOs(request: OrderbookRequest) async throws {
        do {
            orderbookDTOs = try await HTTPManager.shared.request(
                type: [OrderbookDTO].self,
                target: QuotationRouter.orderbook(request)
            )
        } catch {
            throw error
        }
    }

    // MARK: - get

    func getOrderbookDTOs() -> [OrderbookDTO] {
        return orderbookDTOs
    }
}
