//
//  VirtualCurrencyRepositoryProtocol.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/03.
//

import Foundation

protocol VirtualCurrencyRepositoryProtocol {
    func getVirtualCurrencys() async throws -> [VirtualCurrency]
}
