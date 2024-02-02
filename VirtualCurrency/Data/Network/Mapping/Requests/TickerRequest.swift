//
//  TickerRequest.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/02.
//

import Foundation

struct TickerRequest {
    private let marketCodes: [String]

    init(marketCodes: [String]) {
        self.marketCodes = marketCodes
    }

    var markets: String {
        return marketCodes.joined(separator: ", ")
    }
}

extension TickerRequest {
    func toQueryParameters() -> [String: Any] {
        let parameters: [String: Any] = ["markets": markets]

        return parameters
    }
}
