//
//  OrderbookRepositoryProtocol.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/11.
//

import Foundation

protocol OrderbookRepositoryProtocol {
    func fetchOrderbooks(request: OrderbookRequest) async throws -> [Orderbook]
}
