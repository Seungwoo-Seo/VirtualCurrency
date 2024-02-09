//
//  TradeRow.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/09.
//

import SwiftUI

struct TradeRow: View {
    var trade: Trade

    var body: some View {
        ZStack {
            HStack(alignment: .center) {
                Text(trade.tradeTime)
                    .foregroundColor(Color.white)
                    .frame(width: 90)

                Divider()
                    .overlay(Color.gray)
                Spacer()

                Text("\(trade.tradePrice.formatToString)")
                    .foregroundColor(trade.priceStateColor)

                Spacer()
                Divider()
                    .overlay(Color.gray)

                Text("\(trade.tradeVolume)")
                    .foregroundColor(trade.tradeVolumeColor)
                    .frame(width: 90)
            }
            .font(.system(size: 12, weight: .regular, design: .default))
        }
    }
}
