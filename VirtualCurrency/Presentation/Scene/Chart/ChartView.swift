//
//  ChartView.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/07.
//

import Charts
import SwiftUI

struct ChartView: View {
    @StateObject var viewModel: ChartViewModel

    @State private var showing = false

    init(viewModel: ChartViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        contentView
            .onAppear { viewModel.action(.contentViewOnAppear) }
    }

    @ViewBuilder
    private var contentView: some View {
        switch viewModel.state {
        case .dayCandles(let items):
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Spacer()

                    HStack {
                        Text("단순 MA")
                            .foregroundColor(.white)
                        HStack {
                            Rectangle()
                                .foregroundColor(Color.orange)
                                .frame(width: 5)
                            Text("5")
                                .foregroundColor(.white)
                        }
                        HStack {
                            Rectangle()
                                .foregroundColor(Color.pink)
                                .frame(width: 5)
                            Text("10")
                                .foregroundColor(.white)
                        }
                        HStack {
                            Rectangle()
                                .foregroundColor(Color.green)
                                .frame(width: 5)
                            Text("20")
                                .foregroundColor(.white)
                        }
                        HStack {
                            Rectangle()
                                .foregroundColor(Color.gray)
                                .frame(width: 5)
                            Text("60")
                                .foregroundColor(.white)
                        }
                        HStack {
                            Rectangle()
                                .foregroundColor(Color.white)
                                .frame(width: 5)
                            Text("120")
                                .foregroundColor(.white)
                        }
                        Spacer()
                    }
                    .font(.system(size: 14, weight: .regular, design: .default))
                    .frame(height: 14, alignment: .leading)
                    .padding([.top, .leading], 16)
                    .padding(.bottom, 8)

                    candleChartView(items)

                    Spacer()

                    HStack {
                        Text("거래량 단순 MA")
                            .foregroundColor(.white)
                        HStack {
                            Rectangle()
                                .foregroundColor(Color.purple)
                                .frame(width: 5)
                            Text("5")
                                .foregroundColor(.white)
                        }
                        HStack {
                            Rectangle()
                                .foregroundColor(Color.indigo)
                                .frame(width: 5)
                            Text("10")
                                .foregroundColor(.white)
                        }
                        HStack {
                            Rectangle()
                                .foregroundColor(Color.yellow)
                                .frame(width: 5)
                            Text("20")
                                .foregroundColor(.white)
                        }
                        Spacer()
                    }
                    .font(.system(size: 14, weight: .regular, design: .default))
                    .frame(height: 14, alignment: .leading)
                    .padding([.top, .leading], 16)
                    .padding(.bottom, 8)

                    tradeVolumeChartView(items)
                }
            }
            .background(Color.init("AppColor"))
            .navigationTitle("\(viewModel.virtualCurrency.name) \(viewModel.virtualCurrency.code)")
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: BackButton())
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        NavigationLink {
                            TradeView(viewModel: DIContainer.tradeInject(virtualCurrency: viewModel.virtualCurrency))
                        } label: {
                            Text("체결")
                        }
                        NavigationLink {
                            OrderbookView(viewModel: DIContainer.orderbookInject(virtualCurrency: viewModel.virtualCurrency))
                        } label: {
                            Text("호가")
                        }
                    }
                }
            } // toolbar
            .toolbarBackground(Color.init("AppColor"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)

        case .error(let errorString):
            Button("Error") {
                showing.toggle()
            }
            .alert(errorString, isPresented: $showing) {
                Button("확인", role: .cancel) {
                    
                }
            }

        case .none:
            ProgressView()
        }
    }

    @State private var isFirstRun: Bool = true

    @ViewBuilder
    private func candleChartView(_ items: [DayCandle]) -> some View {
        ReverseHorizontalScrollView {
            Chart {
                ForEach(items.reversed()) { item in
                    CandleRow(items: items.reversed(), item: item)
                }
            }
            .chartPlotStyle { content in
                content.frame(width: 20 * CGFloat(items.count), height: 300)
            }
            .chartXScale(domain: .automatic(includesZero: false))
            .chartXAxis {
                AxisMarks { value in
                    if value.index % 10 == 0 {
                        AxisGridLine()
                            .foregroundStyle(Color.gray)
                        AxisValueLabel()
                            .font(.system(size: 9))
                            .foregroundStyle(Color.gray)
                    }
                }
            }
            .chartYScale(domain: viewModel.findMinMaxPrices())
            .chartYAxis {
                AxisMarks { value in
                    AxisGridLine()
                        .foregroundStyle(Color.gray)
                    AxisValueLabel()
                        .font(.system(size: 9))
                        .foregroundStyle(Color.gray)
                }
            }
        } onOffsetChange: { minX in
            if isFirstRun {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    isFirstRun = false
                }
            } else {
                if minX == 0 {
                    viewModel.action(.candlePagination)
                }
            }

            print("New ScrollView minX: \(minX) + \(items.count)")
        }
    }

    @ViewBuilder
    private func tradeVolumeChartView(_ items: [DayCandle]) -> some View {
        ReverseHorizontalScrollView {
            Chart {
                ForEach(items.reversed()) { item in
                    TradeVolumeRow(items: items.reversed(), item: item)
                }
            }
            .chartPlotStyle { content in
                content.frame(width: 20 * CGFloat(items.count), height: 300)
            }
            .chartXScale(domain: .automatic(includesZero: false))
            .chartXAxis {
                AxisMarks { value in
                    if value.index % 10 == 0 {
                        AxisGridLine()
                            .foregroundStyle(Color.gray)
                        AxisValueLabel()
                            .font(.system(size: 9))
                            .foregroundStyle(Color.gray)
                    }
                }
            }
//            .chartYScale(domain: viewModel.findMinMaxTradeVolume())
            .chartYScale(domain: .automatic(includesZero: false))
            .chartYAxis {
                AxisMarks { value in
                    AxisGridLine()
                        .foregroundStyle(Color.gray)
                    AxisValueLabel()
                        .font(.system(size: 9))
                        .foregroundStyle(Color.gray)
                }
            }
        } onOffsetChange: { minX in
            if isFirstRun {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    isFirstRun = false
                }
            } else {
                if minX == 0 {
//                    viewModel.action(.candlePagination)
                }
            }
//            print("New ScrollView rect: \(rect)")
        }
    }
    
}
