//
//  OrderbookView.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/11.
//

import SwiftUI

struct OrderbookView: View {
    @StateObject var viewModel: OrderbookViewModel

    init(viewModel: OrderbookViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        contentView
            .navigationTitle("\(viewModel.virtualCurrency.name) \(viewModel.virtualCurrency.code)")
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: BackButton())
            .toolbarBackground(Color.init("AppColor"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .onAppear { viewModel.action(.contentViewOnAppear) }
            .onDisappear { viewModel.action(.contentViewOnDisappear) }
    }

    @ViewBuilder
    private var contentView: some View {
        switch viewModel.state {
        case .orderbook(let orderbook, let trades, let ticker):
            ScrollView {
                LazyVStack(spacing: 1) {
                    askView(orderbook: orderbook, ticker: ticker)
                    bidView(orderbook: orderbook, trades: trades, ticker: ticker)
                }
            }
            .foregroundColor(Color.white)
            .background(Color.init("AppColor"))
            .font(.system(size: 15, weight: .regular, design: .default))

        case .none:
            ProgressView()
        }
    }

    @ViewBuilder // 매도
    private func askView(orderbook: Orderbook, ticker: Ticker) -> some View {
        // 매도
        HStack(alignment: .bottom, spacing: 1) {
            LazyVStack(spacing: 1) {
                ForEach(orderbook.orderbookUnits.sorted(by: {$0.askPrice > $1.askPrice})) { item in
                    ZStack(alignment: .trailing) {
                        Text("\(item.askSize.toString(seat: 3))")
                            .padding()
                            .frame(width: 130, alignment: .trailing)
                        Rectangle()
                            .foregroundStyle(Color.blue.opacity(0.1))
                            .frame(
                                maxWidth: orderbook.askSizeColor(width: 130, askSize: item.askSize),
                                alignment: .trailing
                            )
                    }
                }
                .background(Color.init("AskBgColor"))
            } // 매도량

            LazyVStack(spacing: 1) {
                ForEach(orderbook.orderbookUnits.sorted(by: {$0.askPrice > $1.askPrice})) { item in
                    Text("\(item.askPrice.formatToString)")
                        .foregroundColor(ticker.color)
                        .padding()
                        .frame(width: 130, alignment: .center)
                }
                .background(Color.init("AskBgColor"))
            } // 매도가

            LazyVStack(alignment: .leading) {
                VStack {
                    HStack {
                        Text("거래량")
                        Spacer()
                        Text(ticker.tradeVolume24.formatToString)
                    }

                    Spacer()

                    HStack {
                        Text("거래금")
                        Spacer()
                        Text(ticker.transactionAmount24.convertToMillionFormat)
                    }

                    HStack {
                        Spacer()
                        Text("(최근 24시간)")
                            .foregroundColor(Color.gray)
                    }
                }

                Divider()

                VStack {
                    HStack {
                        Text("52주최고")
                        Spacer()
                        Text(ticker.highest52WeekPrice.formatToString)
                            .foregroundColor(Color.red)
                    }

                    HStack {
                        Spacer()
                        Text("(\(ticker.highest52WeekDate))")
                            .foregroundColor(Color.gray)
                    }

                    Spacer()

                    HStack {
                        Text("52주최저")
                        Spacer()
                        Text(ticker.lowest52WeekPrice.formatToString)
                            .foregroundColor(Color.blue)
                    }

                    HStack {
                        Spacer()
                        Text("(\(ticker.lowest52WeekDate))")
                            .foregroundColor(Color.gray)
                    }
                }

                Divider()

                VStack {
                    HStack {
                        Text("전일종가")
                        Spacer()
                        Text(ticker.prevClosingPrice.formatToString)
                    }
                    Spacer()
                    HStack {
                        Text("당일고가")
                        Spacer()
                        Text(ticker.highPrice.formatToString)
                            .foregroundColor(Color.red)
                    }
                    Spacer()
                    HStack {
                        Text("당일저가")
                        Spacer()
                        Text(ticker.lowPrice.formatToString)
                            .foregroundColor(Color.blue)
                    }
                    Spacer()
                }
            } // 현재가
            .font(.system(size: 12, weight: .regular, design: .default))
            .padding([.leading, .trailing], 3)
        } // HStack
    }

    @ViewBuilder // 매수
    private func bidView(orderbook: Orderbook, trades: [Trade], ticker: Ticker) -> some View {
        // 매수
        HStack(alignment: .top, spacing: 1) {
            LazyVStack {
                HStack {
                    Text("체결가")
                    Spacer()
                    Text("체결량")
                }
                .padding(.bottom, 2)

                ForEach(trades) { trade in
                    HStack {
                        Text(trade.tradePrice.formatToString)
                            .foregroundColor(trade.priceStateColor)
                        Spacer()
                        Text(trade.tradeVolume.toString(seat: 3))
                            .foregroundColor(trade.tradeVolumeColor)
                    }
                    .padding(.bottom, 1)
                }
            } // 체결
            .font(.system(size: 12, weight: .regular, design: .default))
            .padding([.leading, .trailing], 3)

            LazyVStack(spacing: 1) {
                ForEach(orderbook.orderbookUnits.sorted(by: {$0.bidPrice > $1.bidPrice})) { item in
                    Text("\(item.bidPrice.formatToString)")
                        .foregroundColor(ticker.color)
                        .padding()
                        .frame(width: 130, alignment: .center)
                }
                .background(Color.init("BidBgColor"))
            } // 매수가

            LazyVStack(spacing: 1) {
                ForEach(orderbook.orderbookUnits.sorted(by: {$0.bidPrice > $1.bidPrice})) { item in
                    ZStack(alignment: .leading) {
                        Text("\(item.bidSize.toString(seat: 3))")
                            .padding()
                            .frame(width: 130, alignment: .leading)
                        Rectangle()
                            .foregroundStyle(Color.red.opacity(0.1))
                            .frame(
                                maxWidth: orderbook.bidSizeColor(width: 130, bidSize: item.bidSize),
                                alignment: .leading
                            )
                    }
                }
                .background(Color.init("BidBgColor"))
            } // 매수량
        } // HStack
    }

}
