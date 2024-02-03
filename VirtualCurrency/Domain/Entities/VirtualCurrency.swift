//
//  VirtualCurrency.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/03.
//

import Foundation
import SwiftUI

/// 가상화폐
struct VirtualCurrency: Hashable, Identifiable {
    let id = UUID()
    /// 이름
    let name: String
    /// 코드
    let code: String
    /// 가격 상태
    var priceState: PriceState
    /// 현재가
    var currentPrice: Double
    /// 부호가 있는 변화율
    var changeRate: Double
    /// 부호가 있는 변화액
    var changeAmount: Double
    /// 24시간 거래 대금
    var transactionAmount24: Double

    var color: Color {
        switch priceState {
        case .even: return .white
        case .rise: return .red
        case .fall: return .blue
        }
    }
}

