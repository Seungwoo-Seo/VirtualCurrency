//
//  ExchangeRow.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/04.
//

import SwiftUI

struct ExchangeRow: View {
    var virtualCurrency: VirtualCurrency
    var diffItem: Ticker?

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(virtualCurrency.name)
                    Text(virtualCurrency.code)
                }

                Spacer()

                if let diffItem, diffItem.code == virtualCurrency.code {
                    Text("\(virtualCurrency.currentPrice.formatToString)")
                        .foregroundColor(virtualCurrency.color)
                        .padding(4)
                        .border(virtualCurrency.color)
                } else {
                    Text("\(virtualCurrency.currentPrice.formatToString)")
                        .foregroundColor(virtualCurrency.color)
                }

                VStack(alignment: .trailing) {
                    Text("\(virtualCurrency.changeRate.multiplyBy100AndAddPercentage)")
                    Text("\(virtualCurrency.changeAmount.formatToString)")
                }
                .foregroundColor(virtualCurrency.color)
                .frame(width: 60, alignment: .trailing)

                Text("\(virtualCurrency.transactionAmount24.convertToMillionFormat)")
                    .frame(width: 70, alignment: .trailing)
            }
            .font(.system(size: 12, weight: .regular, design: .default))
        }
    }
}
