//
//  TradeVolumeRow.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/11.
//

import Charts
import SwiftUI

struct TradeVolumeRow: ChartContent {
    var items: [DayCandle]
    var item: DayCandle

    var body: some ChartContent {
        BarMark(
            x: .value("Time", item.kstTime.formatStringDateToYMDString()),
            y: .value("Trade Volume", item.tradeVolume)
        )
        .foregroundStyle(item.openPrice < item.closePrice ? Color.red : Color.blue)
        .annotation(position: .top, alignment: .top, spacing: nil) {
            if items.last?.id == item.id {
                Text(item.tradeVolume.formatToString)
                    .foregroundColor(Color.white)
                    .font(.system(size: 12))
            }
        }

        if let tradeVolumeAverage5 = item.tradeVolumeAverage5 {
            LineMark(
                x: .value("Day", item.kstTime.formatStringDateToYMDString()),
                y: .value("5일 이평선", tradeVolumeAverage5),
                series: .value("5day", "A")
            )
            .foregroundStyle(Color.purple)
        }

        if let tradeVolumeAverage10 = item.tradeVolumeAverage10 {
            LineMark(
                x: .value("Day", item.kstTime.formatStringDateToYMDString()),
                y: .value("10일 이평선", tradeVolumeAverage10),
                series: .value("10day", "B")
            )
            .foregroundStyle(Color.indigo)
        }

        if let tradeVolumeAverage20 = item.tradeVolumeAverage20 {
            LineMark(
                x: .value("Day", item.kstTime.formatStringDateToYMDString()),
                y: .value("20일 이평선", tradeVolumeAverage20),
                series: .value("15day", "C")
            )
            .foregroundStyle(Color.yellow)
        }
    }

}
