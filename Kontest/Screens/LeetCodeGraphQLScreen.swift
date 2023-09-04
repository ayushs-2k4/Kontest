//
//  LeetCodeGraphQLScreen.swift
//  Kontest
//
//  Created by Ayush Singhal on 04/09/23.
//

import SwiftUI

struct LeetCodeGraphQLScreen: View {
    let leetCodeGraphQLViewModel = LeetCodeGraphQLViewModel(username: "ayushs_2k4")
    var body: some View {
        Text(leetCodeGraphQLViewModel.leetCodeUserProfileGraphQLAPIModel?.githubUrl ?? "NO GITHUB")

        LeetcodeProfileViewGraphQL(leetCodeUserProfileGraphQLAPIModel: leetCodeGraphQLViewModel.leetCodeUserProfileGraphQLAPIModel, userContestRanking: leetCodeGraphQLViewModel.userContestRanking, userContestRankingHistory: leetCodeGraphQLViewModel.userContestRankingHistory, username: "ayushs_2k4", bgColor: .cyan, isLoading: leetCodeGraphQLViewModel.isLoading)
    }
}

struct LeetcodeProfileViewGraphQL: View {
    let leetCodeUserProfileGraphQLAPIModel: LeetCodeUserProfileGraphQLAPIModel?
    let userContestRanking: LeetCodeUserRankingGraphQLAPIModel?
    let userContestRankingHistory: [LeetCodeUserRankingHistoryGraphQLAPIModel?]?
    let username: String
    let bgColor: Color
    let isLoading: Bool

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

                if let leetCodeUserProfileGraphQLAPIModel {
                    VStack {
//                        Text("Total Solved: \(leetcodeProfile.totalSolved)")
//                            .bold()
//                        Text("Total Easy: \(leetcodeProfile.easySolved)")
//                        Text("Total Medium: \(leetcodeProfile.mediumSolved)")
//                        Text("Total Hard: \(leetcodeProfile.hardSolved)")
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

                    VStack {
                        Text("Ranking \(leetCodeUserProfileGraphQLAPIModel.profileModel?.ranking ?? -1)")
                        Text("daan: \(userContestRanking?.rating ?? -1)")
                        Text("daan2: \(leetCodeUserProfileGraphQLAPIModel.profileModel?.solutionCount ?? -1)")
                        let p = leetCodeUserProfileGraphQLAPIModel.submitStatsGlobal?.acSubmissionNum
                        if let p {
                            ForEach(p, id: \.self) { k in
                                Text((k?.difficulty)!)
                                let o = k?.count
                                Text("\(o ?? -1)")
                            }
                        }
                    }
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
            if !isLoading {
//                if status != nil, status != "error" {
                guard let url = URL(string: "https://leetcode.com/ayushs_2k4") else { return }
                openURL(url)
//                } else {
//                    router.appendScreen(screen: .SettingsScreen)
//                }
            }
        }
        .multilineTextAlignment(.center)
        .foregroundStyle(.white)
    }
}

#Preview {
    LeetCodeGraphQLScreen()
}
