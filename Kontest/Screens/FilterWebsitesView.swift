//
//  FilterWebsiteView.swift
//  Kontest
//
//  Created by Ayush Singhal on 09/09/23.
//

import SwiftUI

struct FilterWebsitesView: View {
    let siteLogo: Image
    let siteName: String
    let borderColor: Color
    @Binding var isSelected: Bool

    var body: some View {
        VStack {
            siteLogo
                .resizable()
                .aspectRatio(1, contentMode: .fit)

            Text(siteName)
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(2, contentMode: .fit)
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 10) // Adjust the cornerRadius as needed
                .stroke(isSelected ? borderColor : borderColor.opacity(0), lineWidth: 2)
        )
        .padding(1)
        .onTapGesture {
            isSelected.toggle()
        }
    }
}

#Preview {
    @State var isSelected: Bool = true

    return FilterWebsitesView(siteLogo: Image(.hackerRankLogo), siteName: "Hacker Rank", borderColor: KontestModel.getColorForIdentifier(site: "HackerRank"), isSelected: $isSelected)
}
