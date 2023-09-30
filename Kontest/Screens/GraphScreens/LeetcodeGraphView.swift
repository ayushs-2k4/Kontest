//
//  LeetcodeGraphView.swift
//  Kontest
//
//  Created by Ayush Singhal on 30/09/23.
//

import SwiftUI

import Charts
import SwiftUI

struct LeetcodeGraphView: View {
    let leetcodeGraphQLViewModel: LeetCodeGraphQLViewModel = Dependencies.instance.leetCodeGraphQLViewModel

    @State private var attendedContests: [LeetCodeUserRankingHistoryGraphQLAPIModel]
    @State private var showAnnotations: Bool = true

    init() {
        self._attendedContests = State(initialValue: [])
    }

    var body: some View {
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

                Toggle("Show Annotations?", isOn: $showAnnotations)
                    .toggleStyle(.switch)
                    .padding(.horizontal)

                Chart {
                    ForEach(attendedContests, id: \.contest?.title) { attendedContest in
                        let timestamp = TimeInterval(Int(attendedContest.contest?.startTime ?? "-1") ?? -1)
                        let date = Date(timeIntervalSince1970: timestamp)

                        PointMark(x: .value("Time", date, unit: .day), y: .value("Ratings", attendedContest.rating ?? -1))
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

                        LineMark(x: .value("Time", date, unit: .day), y: .value("Ratings", attendedContest.rating ?? -1))
                    }
                }
                .chartScrollableAxes(.horizontal)
                .chartXVisibleDomain(length: 3600*24*30) // 30 days
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    LeetcodeGraphView()
        .frame(width: 500, height: 300)
}
