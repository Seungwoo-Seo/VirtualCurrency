//
//  RealtimeOrderbookDTO+Mapping.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/10.
//

import Foundation

struct RealtimeOrderbookDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case totalAskSize = "total_ask_size"
        case totalBidSize = "total_bid_size"
        case orderbookUnits = "orderbook_units"
    }
    /// 호가 매도 총 잔량
    let totalAskSize: Double?
    /// 호가 매수 총 잔량
    let totalBidSize: Double?
    /// 호가
    let orderbookUnits: [AskBidDTO]?
}

extension RealtimeOrderbookDTO {
    func toDomain() -> Orderbook {
        return Orderbook(
            totalAskSize: totalAskSize ?? 0,
            totalBidSize: totalBidSize ?? 0,
            orderbookUnits: orderbookUnits?.map { $0.toDomain() } ?? []
        )
    }
}
