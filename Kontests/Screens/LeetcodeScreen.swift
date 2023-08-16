//
//  LeetcodeScreen.swift
//  Kontests
//
//  Created by Ayush Singhal on 16/08/23.
//

import SwiftUI

struct LeetcodeScreen: View {
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

                    Text("Ranking \(leetcodeProfile.ranking)")
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                } else {
                    Text("LastRank 0")
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                    
                    VStack {
                        
                        Text("I N V A L I D   U S E R N A M E")
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
        .multilineTextAlignment(.center)
        .foregroundStyle(.white)
    }
}


#Preview {
    VStack {
        LeetcodeScreen(username: "ayushs_2k4")
        LeetcodeScreen(username: "ayushs  _2k4")
    }
}
