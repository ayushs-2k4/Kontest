//
//  NoKontestsScreen.swift
//  Kontests
//
//  Created by Ayush Singhal on 14/08/23.
//

import SwiftUI

struct NoKontestsScreen: View {
    var body: some View {
        VStack {
            Text("Currently there are no ongoing or upcoming contests")
                .font(.title2)
                .bold()
                .padding()

            Text("Check back later")
                .font(.title2)
                .bold()
                .padding()
        }
        .multilineTextAlignment(.center)
    }
}

#Preview {
    NoKontestsScreen()
}
