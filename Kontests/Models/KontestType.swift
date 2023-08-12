//
//  KontestType.swift
//  Kontests
//
//  Created by Ayush Singhal on 13/08/23.
//

import Foundation
import SwiftUI

enum KontestType: String {
    case CodeForces
    case CodeForcesGym = "CodeForces::Gym"
    case AtCoder
    case CSAcademy = "CS Academy"
    case CodeChef
    case HackerRank
    case HackerEarth
    case LeetCode
    case Toph

    static func getKontestType(name: String) -> KontestType? {
        return KontestType(rawValue: name)
    }
}

protocol KontestProperties {
    var logoURL: String { get }
    var logo: ImageResource { get }
    var prominentColor: Color { get }
}

struct CodeForcesProperties: KontestProperties {
    var logoURL: String = "https://cdn.iconscout.com/icon/free/png-512/free-code-forces-3628695-3029920.png?f=avif&w=512"
    var logo: ImageResource = .codeForcesLogo

    var prominentColor: Color = .red
}

struct CodeForcesGymProperties: KontestProperties {
    var logoURL: String = "https://cdn.iconscout.com/icon/free/png-512/free-code-forces-3628695-3029920.png?f=avif&w=512"
    var logo: ImageResource = .codeForcesLogo

    var prominentColor: Color = .red
}

struct AtCoderProperties: KontestProperties {
    var logoURL: String = "https://img.atcoder.jp/assets/logo.png"
    var logo: ImageResource = .atCoderLogo

    var prominentColor: Color = .brown
}

struct CSAcademyProperties: KontestProperties {
    var logoURL: String = "https://play-lh.googleusercontent.com/mNLWhhjA3m3fNMxW8cK9l-PgCkUkvghvnYvdob5Eze4gOeod7FdH38huer7ulzTeWV8x=w480-h960-rw"
    var logo: ImageResource = .csAcademyLogo

    var prominentColor: Color = .red
}

struct CodeChefProperties: KontestProperties {
    var logoURL: String = "https://avatars.githubusercontent.com/u/11960354?v=4"
    var logo: ImageResource = .codeChefLogo

    var prominentColor: Color = .brown
}

struct HackerRankProperties: KontestProperties {
    var logoURL: String = "https://cdn4.iconfinder.com/data/icons/logos-and-brands/512/160_Hackerrank_logo_logos-1024.png"
    var logo: ImageResource = .hackerRankLogo

    var prominentColor: Color = .green
}

struct HackerEarthProperties: KontestProperties {
    var logoURL: String = "https://upload.wikimedia.org/wikipedia/commons/e/e8/HackerEarth_logo.png"
    var logo: ImageResource = .hackerEarthLogo

    var prominentColor: Color = .init(red: 40, green: 44, blue: 67)
}

struct LeetCodeProperties: KontestProperties {
    var logoURL: String = "https://upload.wikimedia.org/wikipedia/commons/1/19/LeetCode_logo_black.png"
    var logo: ImageResource = .leetCodeLogo

    var prominentColor: Color = .yellow
}

struct TophProperties: KontestProperties {
    var logoURL: String = "https://static.toph.co/images/emblem_512p.png?_=d5d517cf95abe4d22253494019b418fc5f3ce386"
    var logo: ImageResource = .tophLogo

    var prominentColor: Color = .blue
}

struct DefaultProperties: KontestProperties {
    var logoURL: String = "https://cdn.iconscout.com/icon/free/png-512/free-code-forces-3628695-3029920.png?f=avif&w=512"
    var logo: ImageResource = .codeForcesLogo

    var prominentColor: Color = .red
}

func getKontestProperties(for kontestType: KontestType?) -> KontestProperties {
    switch kontestType {
    case .CodeForces:
        CodeForcesProperties()
    case .CodeForcesGym:
        CodeForcesGymProperties()
    case .AtCoder:
        AtCoderProperties()
    case .CSAcademy:
        CSAcademyProperties()
    case .CodeChef:
        CodeChefProperties()
    case .HackerRank:
        HackerRankProperties()
    case .HackerEarth:
        HackerRankProperties()
    case .LeetCode:
        LeetCodeProperties()
    case .Toph:
        TophProperties()
    case .none:
        DefaultProperties()
    }
}
