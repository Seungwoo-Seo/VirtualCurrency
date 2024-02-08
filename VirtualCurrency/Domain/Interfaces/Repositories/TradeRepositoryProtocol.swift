//
//  TradeRepositoryProtocol.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/08.
//

import Foundation

protocol TradeRepositoryProtocol {
    func fetchTrades(request: TradeRequest) async throws -> [Trade]
}
