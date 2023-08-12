//
//  AllKontestsScreen.swift
//  Kontests
//
//  Created by Ayush Singhal on 12/08/23.
//

import SwiftUI

struct AllContestsScreen: View {
    let allKontestsViewModel = AllKontestsViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                if allKontestsViewModel.allContests.isEmpty {
                    ProgressView()
                }
                else {
                    List {
                        ForEach(allKontestsViewModel.allContests) { kontest in
                            Link(destination: URL(string: kontest.url)!, label: {
                                SingleKontentView(kontest: kontest)
                            })
                            .buttonStyle(.plain)
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
    private let dateFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    // DateFormatter for the second format: "2022-10-10 06:30:00 UTC"
    private let dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    var body: some View {
        HStack {
            if kontest.status == "CODING" {
                BlinkingDot(color: .green)
                    .frame(width: 10, height: 10)
            }

            VStack(alignment: .leading) {
                Text(kontest.site.uppercased())
                    .bold()

                Text(kontest.name)
            }

            Spacer()

            VStack {
                if let startDate = dateFormatter1.date(from: kontest.start_time),
                   let endDate = dateFormatter1.date(from: kontest.end_time)
                {
                    Text("\(getFormattedDateOnly(from: startDate)) - \(getFormattedDateOnly(from: endDate))")
                        .bold()

                    Text(getFormattedDuration(fromSeconds: kontest.duration))

                    Text("\(getFormattedTimeOnly(from: startDate)) - \(getFormattedTimeOnly(from: endDate))")
                }
                else if let startDate = dateFormatter2.date(from: kontest.start_time),
                        let endDate = dateFormatter2.date(from: kontest.end_time)
                {
                    Text("\(getFormattedDateOnly(from: startDate)) - \(getFormattedDateOnly(from: endDate))")
                        .bold()

                    Text(getFormattedDuration(fromSeconds: kontest.duration))

                    Text("\(getFormattedTimeOnly(from: startDate)) - \(getFormattedTimeOnly(from: endDate))")
                }
                else {
                    Text("No date provided")
                }
            }
            .font(.footnote)
        }
    }

    private func getFormattedDateOnly(from date: Date) -> String {
        let outputFormatter = DateFormatter()
        outputFormatter.timeZone = .current
        outputFormatter.dateStyle = .none // Change this to .short, .medium, or .long
        outputFormatter.timeStyle = .short // Change this to .short, .medium, or .long
        return outputFormatter.string(from: date)
    }

    private func getFormattedTimeOnly(from date: Date) -> String {
        let outputFormatter = DateFormatter()
        outputFormatter.timeZone = .current
        outputFormatter.dateStyle = .medium // Change this to .short, .medium, or .long
        outputFormatter.timeStyle = .none // Change this to .short, .medium, or .long
        return outputFormatter.string(from: date)
    }

    private func getFormattedDuration(fromSeconds seconds: String) -> String {
        guard let totalSecondsInDouble = Double(seconds) else {
            return "Invalid Duration"
        }

        let totalSeconds = Int(totalSecondsInDouble)

        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let formattedDuration = "\(hours) hours \(minutes) minutes"

        return formattedDuration
    }
}

#Preview {
    AllContestsScreen()
}

#Preview("SingleKontentView") {
    List {
        SingleKontentView(kontest: Kontest(name: "ProjectEuler+", url: "https://hackerrank.com/contests/projecteuler", start_time: "2014-07-07T15:38:00.000Z", end_time: "2024-07-30T18:30:00.000Z", duration: "317616720.0", site: "HackerRank", in_24_hours: "No", status: "No"))

        SingleKontentView(kontest: Kontest(name: "1v1 Games by CodeChef", url: "https://www.codechef.com/GAMES", start_time: "2022-10-10 06:30:00 UTC", end_time: "2032-10-10 06:30:00 UTC", duration: "315619200.0", site: "CodeChef", in_24_hours: "No", status: "CODING"))

        SingleKontentView(kontest: Kontest(name: "Weekly Contest 358", url: "https://leetcode.com/contest/weekly-contest-358", start_time: "2023-08-13T02:30:00.000Z", end_time: "2023-08-13T04:00:00.000Z", duration: "5400", site: "LeetCode", in_24_hours: "Yes", status: "BEFORE"))
    }
}

#Preview("BlinkingDot") {
    BlinkingDot(color: .green)
}
