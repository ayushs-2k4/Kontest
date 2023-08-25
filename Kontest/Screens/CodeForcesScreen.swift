//
//  CodeForcesScreen.swift
//  Kontest
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
        CodeForcesView(codeForcesViewModel: codeForcesViewModel, username: username, bgColor: bgColor, isLoading: codeForcesViewModel.isLoading, error: codeForcesViewModel.error)
    }
}

struct CodeForcesView: View {
    let codeForcesViewModel: CodeForcesViewModel
    let username: String
    let bgColor: Color
    let isLoading: Bool
    let error: Error?

    init(codeForcesViewModel: CodeForcesViewModel, username: String, bgColor: Color, isLoading: Bool, error: Error?) {
        self.codeForcesViewModel = codeForcesViewModel
        self.username = username
        self.bgColor = bgColor
        self.isLoading = isLoading
        self.error = error
    }

    @Environment(\.openURL) private var openURL
    @Environment(Router.self) private var router

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

                if let codeForcesProfile = codeForcesViewModel.codeForcesProfile {
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

                        let rating = codeForcesViewModel.getRatingsTitle()
                        VStack(spacing: 0) {
                            Text(rating.title)
                                .fontDesign(.monospaced)
                                .bold()

                            Text("with a current rating of \(latestResult.newRating) [\((latestResult.newRating - latestResult.oldRating) >= 0 ? "+" : "")\(latestResult.newRating - latestResult.oldRating)]")
                                .font(.caption)
                        }
                        .foregroundStyle(rating.color)
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
            if codeForcesViewModel.codeForcesProfile != nil {
                guard let url = URL(string: "https://codeforces.com/profile/\(username)") else { return }
                openURL(url)
            }
            else {
                router.path.append(Screens.SettingsScreen)
            }
        }
        .multilineTextAlignment(.center)
        .foregroundStyle(.white)
    }
}

#Preview {
    VStack {
        CodeForcesScreen(username: "Fefer_Ivan", bgColor: .green)
        CodeForcesScreen(username: "ayushsinghals", bgColor: .green)
        CodeForcesScreen(username: "ayushsinghals02", bgColor: .green)
        CodeForcesScreen(username: "yermak0v", bgColor: .green)
    }
    .environment(Router.instance)
}
