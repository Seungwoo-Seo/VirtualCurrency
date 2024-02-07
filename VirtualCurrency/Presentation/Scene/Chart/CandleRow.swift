//
//  CandleRow.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/07.
//

import Charts
import SwiftUI

struct CandleRow: ChartContent {
    var items: [DayCandle]
    var item: DayCandle

    var body: some ChartContent {
        RectangleMark(
            x: .value("Day", item.kstTime.formatStringDateToYMDString()),
            yStart: .value("Low Price", item.lowPrice),
            yEnd: .value("High Price", item.highPrice),
            width: 1
        )
        .foregroundStyle(item.openPrice < item.closePrice ? Color.red : Color.blue)

        RectangleMark(
            x: .value("Day", item.kstTime.formatStringDateToYMDString()),
            yStart: .value("Open Price", item.openPrice),
            yEnd: .value("Close Price", item.closePrice),
            width: 20
        )
        .foregroundStyle(item.openPrice < item.closePrice ? Color.red : Color.blue)
        .annotation(position: .top, alignment: .top, spacing: nil) {
            if items.last?.id == item.id {
                Text(item.closePrice.formatToString)
                    .foregroundColor(Color.white)
                    .font(.system(size: 12))
            }
        }

        if let average5 = item.average5 {
            LineMark(
                x: .value("Day", item.kstTime.formatStringDateToYMDString()),
                y: .value("5일 이평선", average5),
                series: .value("5day", "A")
            )
            .foregroundStyle(Color.orange)
        }

        if let average10 = item.average10 {
            LineMark(
                x: .value("Day", item.kstTime.formatStringDateToYMDString()),
                y: .value("10일 이평선", average10),
                series: .value("10day", "B")
            )
            .foregroundStyle(Color.pink)
        }

        if let average20 = item.average20 {
            LineMark(
                x: .value("Day", item.kstTime.formatStringDateToYMDString()),
                y: .value("20일 이평선", average20),
                series: .value("15day", "C")
            )
            .foregroundStyle(Color.green)
        }

        if let average60 = item.average60 {
            LineMark(
                x: .value("Day", item.kstTime.formatStringDateToYMDString()),
                y: .value("60일 이평선", average60),
                series: .value("60day", "D")
            )
            .foregroundStyle(Color.gray)
        }

        if let average120 = item.average120 {
            LineMark(
                x: .value("Day", item.kstTime.formatStringDateToYMDString()),
                y: .value("120일 이평선", average120),
                series: .value("120day", "E")
            )
            .foregroundStyle(Color.white)
        }
    }

}
