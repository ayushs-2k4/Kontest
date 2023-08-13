//
//  AllKontestsScreen.swift
//  Kontests
//
//  Created by Ayush Singhal on 12/08/23.
//

import SwiftUI

struct AllKontestsScreen: View {
    let allKontestsViewModel = AllKontestsViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                if allKontestsViewModel.allKontests.isEmpty {
                    ProgressView()
                }
                else {
                    List {
                        ForEach(allKontestsViewModel.allKontests) { kontest in
                            let contestDuration = getFormattedDuration(fromSeconds: kontest.duration)
                            if !contestDuration.isEmpty {
                                Link(destination: URL(string: kontest.url)!, label: {
                                    SingleKontentView(kontest: kontest)
                                })
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Kontests")
        }
    }
}

struct BlinkingDot: View {
    let color: Color

    @State private var isFaded = false

    var body: some View {
        Circle()
            .foregroundStyle(color)
            .opacity(isFaded ? 0.2 : 1)
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                    isFaded = true
                }
            }
    }
}

struct SingleKontentView: View {
    let kontest: Kontest

    // DateFormatter for the first format: "2024-07-30T18:30:00.000Z"
    private func getFormattedDate1(date: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")

        let currentDate = formatter.date(from: date)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"

        return currentDate
    }

    // DateFormatter for the second format: "2022-10-10 06:30:00 UTC"
    private func getFormattedDate2(date: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz" // 2023-08-30 14:30:00 UTC
        formatter.locale = Locale(identifier: "en_US_POSIX")

        let currentDate = formatter.date(from: date)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"

        return currentDate
    }

    var body: some View {
        let kontestType = KontestType.getKontestType(name: kontest.site)
        let kontestProperties = getKontestProperties(for: kontestType)

        HStack(alignment: .center) {
            VStack {
                Image(kontestProperties.logo)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: getLogoSize())

                if kontest.status == "CODING" {
                    BlinkingDot(color: .green)
                        .frame(width: 10, height: 10)
                }
                else {
                    EmptyView()
                }
            }

            VStack(alignment: .leading) {
                Text(kontest.site.uppercased())
                    .foregroundStyle(kontestProperties.prominentColor)
                    .bold()

                Text(kontest.name)
            }

            Spacer()

            VStack {
                if let startDate = getFormattedDate1(date: kontest.start_time),
                   let endDate = getFormattedDate1(date: kontest.end_time)
                {
                    Text("\(startDate.formatted(date: .omitted, time: .shortened)) - \(endDate.formatted(date: .omitted, time: .shortened))")
                        .foregroundStyle(kontestProperties.prominentColor)
                        .font(.custom("timeFont", fixedSize: getTimeFontSize()))
                        .bold()

                    HStack {
                        Image(systemName: "clock")

                        Text(getFormattedDuration(fromSeconds: kontest.duration))
                    }
                    .font(.custom("dateFont", fixedSize: getDateFontSize()))
                    .padding(.vertical, 5)

                    Text("\(startDate.formatted(date: .abbreviated, time: .omitted)) - \(endDate.formatted(date: .abbreviated, time: .omitted))")
                        .font(.custom("dateFont", fixedSize: getDateFontSize()))
                }
                else if let startDate = getFormattedDate2(date: kontest.start_time),
                        let endDate = getFormattedDate2(date: kontest.end_time)
                {
                    Text("\(startDate.formatted(date: .omitted, time: .shortened)) - \(endDate.formatted(date: .omitted, time: .shortened))")
                        .foregroundStyle(kontestProperties.prominentColor)
                        .font(.custom("timeFont", fixedSize: getTimeFontSize()))
                        .bold()

                    HStack {
                        Image(systemName: "clock")

                        Text(getFormattedDuration(fromSeconds: kontest.duration))
                    }
                    .font(.custom("dateFont", fixedSize: getDateFontSize()))
                    .padding(.vertical, 5)

                    Text("\(startDate.formatted(date: .abbreviated, time: .omitted)) - \(endDate.formatted(date: .abbreviated, time: .omitted))")
                        .font(.custom("dateFont", fixedSize: getDateFontSize()))
                }
                else {
                    Text("No date provided")
                }
            }
            .font(.footnote)

            Image(systemName: "chevron.right")
        }
        .padding()
    }

    private func getLogoSize() -> CGFloat {
        #if os(iOS)
            return 25
        #else
            return 40
        #endif
    }

    private func getTimeFontSize() -> CGFloat {
        #if os(iOS)
            return 15
        #else
            return 25
        #endif
    }

    private func getDateFontSize() -> CGFloat {
        #if os(iOS)
            return 12
        #else
            return 17
        #endif
    }
}

func getFormattedDuration(fromSeconds seconds: String) -> String {
    guard let totalSecondsInDouble = Double(seconds) else {
        return "Invalid Duration"
    }

    let totalSeconds = Int(totalSecondsInDouble)

    let hours = totalSeconds / 3600
    let minutes = (totalSeconds % 3600) / 60

    let formatter = DateComponentsFormatter()
    #if os(iOS)
        formatter.unitsStyle = .abbreviated
    #else
        formatter.unitsStyle = .full
    #endif

    formatter.allowedUnits = [.hour, .minute, .second]

    let dateComponents = DateComponents(hour: hours, minute: minutes)

    let ans = dateComponents.hour ?? 1 <= 10 ? (formatter.string(from: dateComponents) ?? "") : ""
    return ans
}

#Preview {
    AllKontestsScreen()
}

#Preview("SingleKontentView") {
    List {
        SingleKontentView(kontest: Kontest(name: "ProjectEuler+", url: "https://hackerrank.com/contests/projecteuler", start_time: "2014-07-07T15:38:00.000Z", end_time: "2024-07-30T18:30:00.000Z", duration: "317616720.0", site: "HackerRank", in_24_hours: "No", status: "No"))

        SingleKontentView(kontest: Kontest(name: "1v1 Games by CodeChef", url: "https://www.codechef.com/GAMES", start_time: "2022-10-10 06:30:00 UTC", end_time: "2032-10-10 06:30:00 UTC", duration: "315619200.0", site: "CodeChef", in_24_hours: "No", status: "CODING"))

        SingleKontentView(kontest: Kontest(name: "Weekly Contest 358", url: "https://leetcode.com/contest/weekly-contest-358", start_time: "2023-08-13T02:30:00.000Z", end_time: "2023-08-13T04:00:00.000Z", duration: "5400", site: "LeetCode", in_24_hours: "Yes", status: "BEFORE"))

        SingleKontentView(kontest: Kontest(name: "Test Contest", url: "https://leetcode.com/contest/weekly-contest-358", start_time: "2023-08-13T02:30:00.000Z", end_time: "2023-08-13T04:00:00.000Z", duration: "1800", site: "LeetCode", in_24_hours: "Yes", status: "BEFORE"))

        SingleKontentView(kontest: Kontest(name: "Starters 100 (Date to be decided)", url: "https://www.codechef.com/START100", start_time: "2023-08-30 14:30:00 UTC", end_time: "2023-08-30 16:30:00 UTC", duration: "7200", site: "CodeChef", in_24_hours: "No", status: "BEFORE"))
    }
}

#Preview("BlinkingDot") {
    BlinkingDot(color: .green)
}
