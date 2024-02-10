//
//  Orderbook.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/10.
//

import Foundation

/// 호가
struct Orderbook {
    let totalAskSize: Double
    let totalBidSize: Double
    let orderbookUnits: [AskBid]

    func askSizeColor(width: CGFloat, askSize: Double) -> Double {
        return (askSize / totalAskSize) * width
    }

    func bidSizeColor(width: CGFloat, bidSize: Double) -> Double {
        return (bidSize / totalBidSize) * width 
    }
}

/// 매도/매수
struct AskBid: Identifiable {
    let id = UUID()
    /// 매도호가
    let askPrice: Double
    /// 매수호가
    let bidPrice: Double
    /// 매도 잔량
    let askSize: Double
    /// 매수 잔량
    let bidSize: Double
}
