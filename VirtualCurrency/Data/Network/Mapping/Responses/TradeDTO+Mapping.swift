//
//  TradeDTO+Mapping.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/08.
//

import Foundation

struct TradeDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case code
        case tradeTime = "trade_time_utc"
        case tradePrice = "trade_price"
        case tradeVolume = "trade_volume"
        case askBid = "ask_bid"
        case cursor = "sequential_id"

    }
    /// 마켓 코드 (ex. KRW-BTC)
    let code: String?
    /// 체결 시각(UTC 기준), 포맷: HH:mm:ss
    let tradeTime: String?
    /// 체결 가격
    let tradePrice: Double?
    /// 체결량
    let tradeVolume: Double?
    /// 매수/매도 구분
    let askBid: AskBidType?
    /// 커서
    let cursor: CLong?
}

extension TradeDTO {
    func toDomain() -> Trade {
        return Trade(
            code: code ?? "시간없음",
            tradePrice: tradePrice ?? 0 ,
            tradeVolume: tradeVolume ?? 0,
            askBid: askBid ?? .bid,
            priceState: nil,
            tradeTime: tradeTime ?? "시간없음",
            cursor: cursor ?? 0
        )
    }
}

enum AskBidType: String, Decodable {
    case ask = "ASK"
    case bid = "BID"
}
