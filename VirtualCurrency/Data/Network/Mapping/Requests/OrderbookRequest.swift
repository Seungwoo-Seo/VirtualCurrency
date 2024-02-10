//
//  OrderbookRequest.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/10.
//

import Foundation

struct OrderbookRequest {
    let markets: String
    let level: Double?
}

extension OrderbookRequest {
    func toQueryParameters() -> [String: Any] {
        var parameters: [String: Any] = ["markets": markets]

        if let level {
            parameters.updateValue(level, forKey: "level")
        }

        return parameters
    }
}
