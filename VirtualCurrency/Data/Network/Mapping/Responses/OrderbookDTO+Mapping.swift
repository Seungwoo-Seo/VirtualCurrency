//
//  OrderbookDTO+Mapping.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/10.
//

import Foundation

struct OrderbookDTO: Decodable {
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

extension OrderbookDTO {
    func toDomain() -> Orderbook {
        return Orderbook(
            totalAskSize: totalAskSize ?? 0,
            totalBidSize: totalBidSize ?? 0,
            orderbookUnits: orderbookUnits?.map { $0.toDomain() } ?? []
        )
    }
}

/// 매도/매수
struct AskBidDTO: Decodable {
    enum CodingKeys: String, CodingKey {
        case askPrice = "ask_price"
        case bidPrice = "bid_price"
        case askSize = "ask_size"
        case bidSize = "bid_size"
    }
    /// 매도호가
    let askPrice: Double?
    /// 매수호가
    let bidPrice: Double?
    /// 매도 잔량
    let askSize: Double?
    /// 매수 잔량
    let bidSize: Double?
}

extension AskBidDTO {
    func toDomain() -> AskBid {
        return AskBid(
            askPrice: askPrice ?? 0,
            bidPrice: bidPrice ?? 0,
            askSize: askSize ?? 0,
            bidSize: bidSize ?? 0
        )
    }
}
