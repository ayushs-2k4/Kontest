//
//  SettingsScreen.swift
//  Kontest
//
//  Created by Ayush Singhal on 16/08/23.
//

import SwiftUI

struct SettingsScreen: View {
    var body: some View {
        #if os(macOS)
        VStack {
            AllSettingsButtonsView()
                .buttonStyle(MyButtonStyle())
        }
        .navigationTitle("Settings")
        #else
        List {
            AllSettingsButtonsView()
        }
        .navigationTitle("Settings")
        #endif
    }
}

private struct AllSettingsButtonsView: View {
    @Environment(Router.self) private var router

    var body: some View {
        Button("Change Usernames") {
            router.appendScreen(screen: Screen.SettingsScreenType(.ChangeUserNamesScreen))
        }

        Button("Filter Websites") {
            router.appendScreen(screen: Screen.SettingsScreenType(.FilterWebsitesScreen))
        }

        Button("About Me!") {
            router.appendScreen(screen: Screen.SettingsScreenType(.RotatingMapScreen))
        }
    }
}

struct SingleSettingsTileView: View {
    let title: String
    let backgroundColor: Color = .yellow
    let onTapGesture: () -> ()

    var body: some View {
        ZStack {
            Text(title)
        }
        .onTapGesture {
            onTapGesture()
        }
    }
}

#Preview {
    NavigationStack {
        SettingsScreen()
    }
    .environment(Dependencies.instance.changeUsernameViewModel)
    .environment(Router.instance)
}

#Preview("SingleSettingsTileView") {
    SingleSettingsTileView(title: "Change Usernames", onTapGesture: {})
}

struct MyButtonStyle: ButtonStyle {
    let color: Color = .black
    @Environment(\.colorScheme) private var colorScheme
    @State private var isHovering = false
    @State private var isPressed = false

    func makeBody(configuration: Configuration) -> some View {
//        configuration.label
//            .padding(5)
        ////            .background(configuration.isPressed ? color.opacity(0.10) : color.opacity(1))
//            .background(getBackgroundColor())
//            .foregroundStyle(color)
//            .containerShape(RoundedRectangle(cornerRadius: 6.0))
//            .cornerRadius(6.0)
//            .onHover(perform: { hovering in
//                isHovering = hovering
//            })
//            .animation(.easeInOut, value: isHovering)
//            .onChange(of: configuration.isPressed) {oldValue, newValue in
//                self.isPressed = newValue
//            }

        configuration.label
            .padding()
            .contentShape(RoundedRectangle(cornerRadius: 10))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(colorScheme == .light ? Color.black : Color.white)
                    .padding(1)
            }
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut, value: configuration.isPressed)

//        configuration.label
//            .padding()
//            .background(.blue)
//            .foregroundStyle(.white)
//            .clipShape(Capsule())
//            .scaleEffect(configuration.isPressed ? 1.2 : 1)
//            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }

    private func getBackgroundColor() -> Color {
        return if isPressed {
            Color.gray.opacity(0.5)
        } else
        if isHovering {
            Color.gray.opacity(0.25)
        } else {
            Color.clear
        }
    }
}
