//
//  ReverseHorizontalScrollView.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/06.
//

import SwiftUI

struct ReverseHorizontalScrollView<Content: View>: View {
    var content: () -> Content
    var onOffsetChange: (CGFloat) -> Void

    init(
        @ViewBuilder content: @escaping () -> Content,
        onOffsetChange: @escaping (CGFloat) -> Void
    ) {
        self.content = content
        self.onOffsetChange = onOffsetChange
    }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                offsetReader
                content()
                    .id("chart")
                    .onAppear {
                        proxy.scrollTo("chart", anchor: .trailing)
                    }
            }
            .coordinateSpace(name: "frameLayer")
            .onPreferenceChange(OffsetPreferenceKey.self, perform: onOffsetChange)
        }
    }

    var offsetReader: some View {
        GeometryReader { proxy in
            Color.clear
                .preference(
                    key: OffsetPreferenceKey.self,
                    value: proxy.frame(in: .named("frameLayer")).minX
                )
        }
        .frame(height: 0) 
    }
}

private struct OffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}
