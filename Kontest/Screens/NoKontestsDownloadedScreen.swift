//
//  NoKontestsScreen.swift
//  Kontest
//
//  Created by Ayush Singhal on 14/08/23.
//

import SwiftUI

struct NoKontestsDownloadedScreen: View {
    @Environment(AllKontestsViewModel.self) private var allKontestsViewModel
    
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
            
            Button{
                allKontestsViewModel.fetchAllKontests()
            }label: {
                Text("Retry")
            }
        }
        .multilineTextAlignment(.center)
    }
}

#Preview {
    NoKontestsDownloadedScreen()
        .environment(Dependencies.instance.allKontestsViewModel)
}
