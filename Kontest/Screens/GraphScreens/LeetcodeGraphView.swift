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
//    let leetcodeGraphQLViewModel = LeetCodeGraphQLViewModel(username: "neal_wu")
//    let leetcodeGraphQLViewModel = LeetCodeGraphQLViewModel(username: "ayushs_2k4")
    let leetcodeGraphQLViewModel = Dependencies.instance.leetCodeGraphQLViewModel

    @State private var attendedContests: [LeetCodeUserRankingHistoryGraphQLAPIModel]
    @State private var showAnnotations: Bool = true

    init() {
        self._attendedContests = State(initialValue: [])
    }

    var body: some View {
        Text("\(leetcodeGraphQLViewModel.userContestRankingHistory?.count ?? -1)")
            .onChange(of: leetcodeGraphQLViewModel.userContestRankingHistory) { _, newValue in
                if let newValue {
                    for item in newValue {
                        if let item, item.attended ?? true {
                            self.attendedContests.append(item)
                        }
                    }
                }
            }

        if leetcodeGraphQLViewModel.isLoading {
            ProgressView()
        } else {
            ScrollView {
                Button("Get") {
                    if self.attendedContests.isEmpty {
                        if let history = leetcodeGraphQLViewModel.userContestRankingHistory {
                            for item in history {
                                print("item: \(item)")
                                if let item, item.attended ?? true {
                                    self.attendedContests.append(item)
                                }
                            }
                        }
                    }

                    print("Done")
                }
                .onAppear(perform: {
                    self.attendedContests.removeAll()
                    
                    if let history = leetcodeGraphQLViewModel.userContestRankingHistory {
                        for item in history {
                            print("item: \(item)")
                            if let item, item.attended ?? true {
                                self.attendedContests.append(item)
                            }
                        }
                    }
                })

                Text("\(attendedContests.count)")

                Toggle("Show Annotations?", isOn: $showAnnotations)
                    .padding(.horizontal)

                VStack {
                    ForEach(attendedContests, id: \.contest?.title) { item in
                        Text(item.contest?.title ?? "No name")
                    }
                }
            }

            Chart {
                ForEach(attendedContests, id: \.contest?.title) { item in
                    let timestamp = TimeInterval(Int(item.contest?.startTime ?? "-1") ?? -1)
                    let date = Date(timeIntervalSince1970: timestamp)

                    PointMark(x: .value("Time", date, unit: .day), y: .value("Ratings", item.rating ?? -1))
                        .annotation(position: .top) {
                            if showAnnotations {
                                Text("\(Int(item.rating ?? -1))")
                            }
                        }
                        .annotation(position: .bottom) {
                            if showAnnotations {
                                Text("\(date.formatted(date: .numeric, time: .shortened))")
                            }
                        }

                    LineMark(x: .value("Time", date), y: .value("Ratings", item.rating ?? -1))
                }
            }
            .chartScrollableAxes(.horizontal)
            .chartXVisibleDomain(length: 3600*24*30)
        }
    }
}

#Preview {
    LeetcodeGraphView()
        .frame(width: 500, height: 300)
}
