//
//  CodeChefView.swift
//  Kontest
//
//  Created by Ayush Singhal on 27/08/23.
//

import SwiftUI

struct CodeChefView: View {
    let username: String
    let codeChefViewModel: CodeChefViewModel
    let bgColor: Color
    
    init(username: String, bgColor: Color) {
        self.username = username
        self.bgColor = bgColor
        self.codeChefViewModel = CodeChefViewModel(username: username)
    }
    
    var body: some View {
        CodeChefProfileView(codeChefProfile: codeChefViewModel.codeChefProfile, username: username, bgColor: bgColor, isLoading: codeChefViewModel.isLoading, error: codeChefViewModel.error)
    }
}

struct CodeChefProfileView: View {
    let codeChefProfile: CodeChefAPIModel?
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
                    Image(.codeChefLogo)
                        .resizable()
                        .frame(width: 25, height: 25)

                    Text("CodeChef")
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                
                Text(username)
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                
                if error == nil, let codeChefProfile {
                    VStack {
                        Text("Current Rating \(codeChefProfile.currentRating)")
                        Text(codeChefProfile.stars)
                    }
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    
                    Text("Max Rating: \(codeChefProfile.highestRating)")
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    
                    VStack(alignment: .leading) {
                        Text("Ranks:")
                        
                        HStack {
                            Image(systemName: "globe")
                            Text("\(codeChefProfile.globalRank)")
                        }
                        
                        HStack {
                            let imageURL = URL(string: codeChefProfile.countryFlag)
                            if let imageURL {
                                AsyncImage(url: imageURL)
                            } else {
                                Text("Country Rank")
                            }
                            
                            Text("\(codeChefProfile.countryRank)")
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                    
                } else {
                    VStack {
                        Text("INVALID USERNAME")
                            .fontDesign(.monospaced)
                            .bold()
                        
                        Text("please update your username in the settings")
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
            }
        }
        .onTapGesture {
            if !isLoading {
                if error == nil {
                    guard let url = URL(string: "https://www.codechef.com/users/\(username)") else { return }
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
    VStack {
        CodeChefView(username: "ayushs_2k4", bgColor: .red)
        CodeChefView(username: "ayush_2k4", bgColor: .red)
    }
    .environment(Router.instance)
}
