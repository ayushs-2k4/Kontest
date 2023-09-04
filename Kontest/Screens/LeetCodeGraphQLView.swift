//
//  LeetCodeGraphQLView.swift
//  Kontest
//
//  Created by Ayush Singhal on 04/09/23.
//

import SwiftUI

struct LeetCodeGraphQLView: View {
    let username: String
    let leetCodeGraphQLViewModel: LeetCodeGraphQLViewModel
    let bgColor: Color
    @State var isHovering = false
    let hoveringScaleValue: CGFloat

    init(username: String, bgColor: Color = .cyan, hoveringScaleValue: CGFloat) {
        self.bgColor = bgColor
        self.username = username
        self.leetCodeGraphQLViewModel = LeetCodeGraphQLViewModel(username: username)
        self.hoveringScaleValue = hoveringScaleValue
    }

    var body: some View {
        LeetcodeProfileGraphQLView(leetCodeUserProfileGraphQLAPIModel: leetCodeGraphQLViewModel.leetCodeUserProfileGraphQLAPIModel, userContestRanking: leetCodeGraphQLViewModel.userContestRanking, userContestRankingHistory: leetCodeGraphQLViewModel.userContestRankingHistory, username: username, bgColor: .cyan, isLoading: leetCodeGraphQLViewModel.isLoading, error: leetCodeGraphQLViewModel.error)
            .onHover(perform: { hovering in
                withAnimation {
                    isHovering = hovering
                }
            })
            .scaleEffect(isHovering && !leetCodeGraphQLViewModel.isLoading && leetCodeGraphQLViewModel.error == nil ? hoveringScaleValue : 1)
    }
}

struct LeetcodeProfileGraphQLView: View {
    let leetCodeUserProfileGraphQLAPIModel: LeetCodeUserProfileGraphQLAPIModel?
    let userContestRanking: LeetCodeUserRankingGraphQLAPIModel?
    let userContestRankingHistory: [LeetCodeUserRankingHistoryGraphQLAPIModel?]?
    let username: String
    let bgColor: Color
    let isLoading: Bool
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

                if let leetCodeUserProfileGraphQLAPIModel {
                    VStack {
                        let acSubmissionNums = leetCodeUserProfileGraphQLAPIModel.submitStatsGlobal?.acSubmissionNums
                        if let acSubmissionNums {
                            let totalSolved = acSubmissionNums[0]?.count
                            let easySolved = acSubmissionNums[1]?.count
                            let mediumSolved = acSubmissionNums[2]?.count
                            let hardSolved = acSubmissionNums[3]?.count

                            Text("Total Solved: \(totalSolved ?? -1)")
                                .bold()
                            Text("Total Easy: \(easySolved ?? -1)")
                            Text("Total Medium: \(mediumSolved ?? -1)")
                            Text("Total Hard: \(hardSolved ?? -1)")
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

                    VStack {
                        Text("Rating: \(Int(userContestRanking?.rating ?? -1))")
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)

                    VStack {
                        Text("Ranking: \(leetCodeUserProfileGraphQLAPIModel.profileModel?.ranking ?? -1)")
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
                if error == nil {
                    guard let url = URL(string: "https://leetcode.com/\(username)") else { return }
                    openURL(url)
                } else {
                    router.appendScreen(screen: .SettingsScreen)
                }
            }
        }
        .multilineTextAlignment(.center)
        .foregroundStyle(.white)
    }
}

#Preview {
    LeetCodeGraphQLView(username: "ayushs_2k4", hoveringScaleValue: 1.05)
}
