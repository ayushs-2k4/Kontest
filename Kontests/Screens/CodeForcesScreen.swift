//
//  CodeForcesScreen.swift
//  Kontests
//
//  Created by Ayush Singhal on 16/08/23.
//

import SwiftUI

struct CodeForcesScreen: View {
    let username: String
    let codeForcesViewModel: CodeForcesViewModel
    let bgColor: Color

    init(username: String, bgColor: Color) {
        self.username = username
        self.codeForcesViewModel = CodeForcesViewModel(username: username)
        self.bgColor = bgColor
    }

    var body: some View {
        CodeForcesView(codeForcesProfile: codeForcesViewModel.codeForcesProfile, username: username, bgColor: bgColor, isLoading: codeForcesViewModel.isLoading, error: codeForcesViewModel.error)
    }
}

struct CodeForcesView: View {
    let codeForcesProfile: CodeForcesAPIModel?
    let username: String
    let bgColor: Color
    let isLoading: Bool
    let error: Error?

    @Environment(\.openURL) private var openURL

    var body: some View {
        ZStack {
            bgColor
            if isLoading && error == nil {
                ProgressView()
            }
            else {
                HStack {
                    Image(.codeForcesLogo)
                        .resizable()
                        .frame(width: 25, height: 25)

                    Text("CodeForces")
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

                Text(username)
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)

                if let codeForcesProfile {
                    if codeForcesProfile.result.isEmpty {
                        Text("LastRank 0")
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)

                        Text("U N R A T E D")
                            .fontDesign(.monospaced)
                            .bold()
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    }
                    else {
                        let latestResult = codeForcesProfile.result[codeForcesProfile.result.count - 1]

                        Text("Current Rating: \("\(latestResult.newRating)")")
                            .fontDesign(.monospaced)
                            .bold()
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

                        Text("LastRank \(latestResult.rank)")
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                    }
                }
                else {
                    Text("LastRank 0")
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)

                    VStack {
                        Text("INVALID USERNAME")
                            .fontDesign(.monospaced)
                            .bold()

                        Text("please update your username in the settings")
                            .font(.caption)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
            }
        }
        .onTapGesture {
            if codeForcesProfile != nil {
                guard let url = URL(string: "https://codeforces.com/profile/\(username)") else { return }
                openURL(url)
            }
        }
        .multilineTextAlignment(.center)
        .foregroundStyle(.white)
    }
}

#Preview {
    VStack {
        CodeForcesScreen(username: "Fefer_Ivan", bgColor: .red)
        CodeForcesScreen(username: "ayushsinghals", bgColor: .red)
        CodeForcesScreen(username: "ayushsinghals02", bgColor: .red)
    }
}
