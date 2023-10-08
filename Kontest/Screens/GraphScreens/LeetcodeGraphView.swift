//
//  LeetcodeGraphView.swift
//  Kontest
//
//  Created by Ayush Singhal on 30/09/23.
//

import Charts
import OSLog
import SwiftUI

struct LeetcodeGraphView: View {
    private let logger = Logger(subsystem: "com.ayushsinghal.Kontest", category: "LeetcodeGraphView")

    let leetcodeGraphQLViewModel: LeetCodeGraphQLViewModel = Dependencies.instance.leetCodeGraphQLViewModel

    @State private var attendedContests: [LeetCodeUserRankingHistoryGraphQLAPIModel]

    init() {
        _attendedContests = State(initialValue: [])
    }

    var body: some View {
        VStack {
            if leetcodeGraphQLViewModel.isLoading {
                ProgressView()
            } else {
                if let error = leetcodeGraphQLViewModel.error {
                    Text("Error: \(error.localizedDescription)")

                } else {
                    Text(leetcodeGraphQLViewModel.username)
                        .onAppear {
                            if let ratings = leetcodeGraphQLViewModel.userContestRankingHistory {
                                attendedContests.removeAll(keepingCapacity: true)

                                for rating in ratings {
                                    if let rating, rating.attended ?? false == true {
                                        attendedContests.append(rating)
                                    }
                                }
                            }
                        }

                    Text("Total Kontests attended: \(attendedContests.count)")

                    MyChart()
                }
            }
        }
        .navigationTitle("Leetcode Rankings")
    }
}

struct MyChart: View {
    private let logger = Logger(subsystem: "com.ayushsinghal.Kontest", category: "MyChart")

    @State private var attendedContests: [LeetCodeUserRankingHistoryGraphQLAPIModel]

    let leetcodeGraphQLViewModel: LeetCodeGraphQLViewModel = Dependencies.instance.leetCodeGraphQLViewModel

    @State private var showAnnotations: Bool = true

    @State private var rawSelectedDate: Date?

    @State private var sortedDates: [Date] = []

    var selectedDate: Date? {
        guard let rawSelectedDate else { return nil }

        let selectedDay = Calendar.current.startOfDay(for: rawSelectedDate)

        if let matchingDate = sortedDates.first(where: { Calendar.current.startOfDay(for: $0) == selectedDay }) {
            logger.info("matchingDate: \(matchingDate.formatted())")
            return matchingDate
        }

        return nil
    }

    init() {
        _attendedContests = State(initialValue: [])
    }

    var body: some View {
        Chart {
            let _ = Self._printChanges()

            ForEach(attendedContests) { attendedContest in

                let timestamp = TimeInterval(Int(attendedContest.contest?.startTime ?? "-1") ?? -1)
                let date = Date(timeIntervalSince1970: timestamp)

                PointMark(x: .value("Time", date, unit: .day), y: .value("Ratings", attendedContest.rating ?? -1))
                    .opacity(0)
                    .annotation(position: .top) {
                        if showAnnotations {
                            Text("\(Int(attendedContest.rating ?? -1))")
                        }
                    }
                    .annotation(position: .bottom) {
                        if showAnnotations {
                            VStack {
                                Text("\(date.formatted(date: .numeric, time: .shortened))")

                                #if os(macOS)
                                    Text(attendedContest.contest?.title ?? "")
                                #endif
                            }
                        }
                    }

                if let selectedDate {
                    let kontest = getKontestFromDate(date: selectedDate)

                    RuleMark(x: .value("selectedDate", selectedDate, unit: .day))
                        .zIndex(-1)
                        .annotation(position: .leading, spacing: 0, overflowResolution: .init(
                            x: .fit(to: .chart),
                            y: .disabled
                        )) {
                            if let kontest {
                                VStack(spacing: 10) {
                                    Text(kontest.contest?.title ?? "")

                                    Text("\(selectedDate.formatted())")

                                    if let problemsSolved = kontest.problemsSolved {
                                        Text("Total problems solved: \(problemsSolved)")
                                    }

                                    if let ranking = kontest.ranking {
                                        Text("Ranking: \(ranking)")
                                    }

                                    if let rating = kontest.rating {
                                        Text("rating: \(rating)")
                                    }
                                }
                                .padding()
                            }
                        }

                    if let rating = kontest?.rating {
                        PointMark(x: .value("selectedDate", selectedDate, unit: .day), y: .value("", rating))
                    }
                }

                LineMark(x: .value("Time", date, unit: .day), y: .value("Ratings", attendedContest.rating ?? -1))
                    .interpolationMethod(.catmullRom)
                    .symbol(Circle().strokeBorder(lineWidth: 2))
            }
        }
        .onAppear {
            if let ratings = leetcodeGraphQLViewModel.userContestRankingHistory {
                attendedContests.removeAll(keepingCapacity: true)

                for rating in ratings {
                    if let rating, rating.attended ?? false == true {
                        attendedContests.append(rating)
                    }
                }

                sortedDates = attendedContests.map { ele in
                    let timestamp = ele.contest?.startTime ?? "-1"
                    return Date(timeIntervalSince1970: TimeInterval(timestamp) ?? -1)
                }

                let firstDate = sortedDates.first
            }
        }
        .chartScrollableAxes(.horizontal)
        .chartXVisibleDomain(length: 3600*24*30) // 30 days
        .padding(.horizontal)
        .chartXSelection(value: $rawSelectedDate)
    }

    private func getKontestFromDate(date: Date) -> LeetCodeUserRankingHistoryGraphQLAPIModel? {
        return attendedContests.first { leetCodeUserRankingHistoryGraphQLAPIModel in
            let timestamp = TimeInterval(Int(leetCodeUserRankingHistoryGraphQLAPIModel.contest?.startTime ?? "-1") ?? -1)

            return date == Date(timeIntervalSince1970: timestamp)
        }
    }
}

#Preview {
    LeetcodeGraphView()
        .frame(width: 500, height: 300)
}
