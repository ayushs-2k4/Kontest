//
//  BlinkingDotView.swift
//  Kontests
//
//  Created by Ayush Singhal on 14/08/23.
//

import SwiftUI

struct BlinkingDotView: View {
    let color: Color

    @State private var isFaded = false

    var body: some View {
        Circle()
            .foregroundStyle(color)
            .opacity(isFaded ? 0.2 : 1)
            .scaleEffect(isFaded ? 0.4 : 1)
            .animation(Animation.linear(duration: 1).repeatForever(), value: isFaded)
            .onAppear {
                isFaded = true
            }
    }
}

#Preview {
    BlinkingDotView(color: .green)
}
