//
//  Trade.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/08.
//

import Foundation
import SwiftUI

/// 체결
struct Trade: Identifiable {
    let id = UUID()
    /// 마켓 코드 (ex. KRW-BTC)
    let code: String
    /// 체결 가격
    let tradePrice: Double
    /// 체결량
    let tradeVolume: Double
    /// 매수/매도 구분
    let askBid: AskBidType
    /// 전일 대비
    let priceState: PriceState?
    /// 체결 시각(UTC 기준), 포맷: HH:mm:ss
    let tradeTime: String
    /// 커서
    let cursor: CLong

    /// 전일 대비 컬러
    var priceStateColor: Color {
        switch priceState {
        case .even: return .white
        case .rise: return .red
        case .fall: return .blue
        case .none: return .white
        }
    }

    /// 체결량 컬러
    var tradeVolumeColor: Color {
        switch askBid {
        case .ask: return .red
        case .bid: return .blue
        }
    }
}
