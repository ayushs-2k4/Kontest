//
//  LeetcodeView.swift
//  Kontest
//
//  Created by Ayush Singhal on 16/08/23.
//

import SwiftUI

struct LeetcodeView: View {
    let username: String
    let leetcodeViewModel: LeetcodeViewModel
    let bgColor: Color

    init(username: String, bgColor: Color = .red) {
        self.bgColor = bgColor
        self.username = username
        self.leetcodeViewModel = LeetcodeViewModel(username: username)
    }

    var body: some View {
        let leetcodeProfile = leetcodeViewModel.leetcodeProfile

        LeetcodeProfileView(leetcodeProfile: leetcodeProfile, username: username, bgColor: bgColor, isLoading: leetcodeViewModel.isLoading, status: leetcodeViewModel.status, error: leetcodeViewModel.error)
    }
}

struct LeetcodeProfileView: View {
    let leetcodeProfile: LeetcodeAPIModel?
    let username: String
    let bgColor: Color
    let isLoading: Bool
    let status: String?
    let error: Error?

    @Environment(\.openURL) private var openURL
    @Environment(Router.self) private var router

    var body: some View {
        ZStack {
            bgColor
            if isLoading {
                ProgressView()
            } else {
                HStack {
                    Image(.leetCodeDarkLogo)
                        .resizable()
                        .frame(width: 25, height: 25)

                    Text("LeetCode")
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

                Text(username)
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)

                if status != nil, status != "error", let leetcodeProfile {
                    VStack {
                        Text("Total Solved: \(leetcodeProfile.totalSolved)")
                            .bold()
                        Text("Total Easy: \(leetcodeProfile.easySolved)")
                        Text("Total Medium: \(leetcodeProfile.mediumSolved)")
                        Text("Total Hard: \(leetcodeProfile.hardSolved)")
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

                    Text("Ranking \(leetcodeProfile.ranking)")
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                } else {
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
            if status != nil, status != "error" {
                guard let url = URL(string: "https://leetcode.com/ayushs_2k4") else { return }
                openURL(url)
            } else {
                router.path.append(Screens.SettingsScreen)
            }
        }
        .multilineTextAlignment(.center)
        .foregroundStyle(.white)
    }
}

#Preview {
    VStack {
        LeetcodeView(username: "ayushs_2k4")
        LeetcodeView(username: "ayushs  _2k4")
    }
    .environment(Router.instance)
}