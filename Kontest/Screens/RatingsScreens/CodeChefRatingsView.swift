//
//  CodeChefRatingsView.swift
//  Kontest
//
//  Created by Ayush Singhal on 27/08/23.
//

import SwiftUI

struct CodeChefRatingsView: View {
    let username: String
    let codeChefViewModel: CodeChefViewModel
    let bgColor: Color
    @State var isHovering = false
    let hoveringScaleValue: CGFloat
    
    init(username: String, bgColor: Color, hoveringScaleValue: CGFloat) {
        self.username = username
        self.bgColor = bgColor
        self.codeChefViewModel = Dependencies.instance.codeChefViewModel
        self.hoveringScaleValue = hoveringScaleValue
    }
    
    var body: some View {
        CodeChefProfileView(codeChefProfile: codeChefViewModel.codeChefProfile, username: username, bgColor: bgColor, isLoading: codeChefViewModel.isLoading, error: codeChefViewModel.error)
            .onHover(perform: { hovering in
                withAnimation {
                    isHovering = hovering
                }
            })
            .scaleEffect(isHovering && !codeChefViewModel.username.isEmpty && !codeChefViewModel.isLoading && codeChefViewModel.error == nil ? hoveringScaleValue : 1)
    }
}

struct CodeChefProfileView: View {
    let codeChefProfile: CodeChefAPIModel?
    let username: String
    let bgColor: Color
    let isLoading: Bool
    let error: (any Error)?
    
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
                .font(FontUtility.getCardCornerSideFont())
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                
                Text(username)
                    .font(FontUtility.getCardCornerSideFont())
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                
                if error == nil, let codeChefProfile {
                    VStack {
                        Text("Current Rating \(codeChefProfile.currentRating)")
                        let numberOfStars = Int(codeChefProfile.stars.dropLast())
                                                
                        if let numberOfStars {
                            HStack {
                                ForEach(0 ..< numberOfStars, id: \.self) { _ in
                                    Text("★")
                                }
                            }
                        } else {
                            Text(codeChefProfile.stars)
                        }
                    }
                    #if os(iOS)
                    .font(.footnote)
                    #endif
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    
                    Text("Max Rating: \(codeChefProfile.highestRating)")
                        .font(FontUtility.getCardCornerSideFont())
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
                                AsyncImage(url: imageURL) { phase in
                                    if let image = phase.image {
                                        image
                                            .resizable()
                                            .frame(width: 17.68, height: 14)
                                    } else if phase.error != nil {
                                        // Error
                                        Image(.placeholderFlag)
                                            .resizable()
                                            .frame(width: 17.68, height: 14)
                                    } else {
                                        // PlaceHolder
                                        Image(.placeholderFlag)
                                            .resizable()
                                            .frame(width: 17.68, height: 14)
                                    }
                                }
                            } else {
                                Text("Country Rank")
                            }
                            
                            Text("\(codeChefProfile.countryRank)")
                        }
                    }
                    .font(FontUtility.getCardCornerSideFont())
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
                if !username.isEmpty && error == nil {
                    guard let url = URL(string: "https://www.codechef.com/users/\(username)") else { return }
                    openURL(url)
                } else {
                    router.appendScreen(screen: .SettingsScreenType(.ChangeUserNamesScreen))
                }
            }
        }
        .multilineTextAlignment(.center)
        .foregroundStyle(.white)
    }
}

#Preview {
    VStack {
        CodeChefRatingsView(username: "ayushs_2k4", bgColor: .brown, hoveringScaleValue: 1.05)
        CodeChefRatingsView(username: "ayush_2k4", bgColor: Color(red: 90/255, green: 55/255, blue: 31/255), hoveringScaleValue: 1.05)
    }
    .environment(Router.instance)
}
