//
//  CodeForcesGraphView.swift
//  Kontest
//
//  Created by Ayush Singhal on 30/09/23.
//

import Charts
import SwiftUI

struct CodeForcesGraphView: View {
    let codeForcesViewModel: CodeForcesViewModel = Dependencies.instance.codeForcesViewModel

    @State private var attendedContests: [CodeForcesuserRatingAPIResultModel]
    @State private var showAnnotations: Bool = true

    init() {
        self._attendedContests = State(initialValue: [])
    }

    var body: some View {
        VStack {
            if codeForcesViewModel.isLoading {
                ProgressView()
            } else {
                if let error = codeForcesViewModel.error {
                    Text("Error: \(error.localizedDescription)")
                } else {
                    Text(codeForcesViewModel.username)
                        .onAppear {
                            if let ratings = codeForcesViewModel.codeForcesRatings {
                                attendedContests.removeAll(keepingCapacity: true)

                                for result in ratings.result {
                                    attendedContests.append(result)
                                }
                            }
                        }

                    Text("Total kontests attended: \(attendedContests.count)")

                    Toggle("Show Annotations?", isOn: $showAnnotations)
                        .toggleStyle(.switch)
                        .padding(.horizontal)

                    Chart {
                        ForEach(attendedContests, id: \.contestId) { attendedContest in
                            let updateTime = attendedContest.ratingUpdateTimeSeconds
                            let updateDate = Date(timeIntervalSince1970: Double(updateTime))

                            let newRating = attendedContest.newRating

                            PointMark(x: .value("Time", updateDate, unit: .day), y: .value("Ratings", newRating))
                                .opacity(0)
                                .annotation(position: .top) {
                                    if showAnnotations {
                                        Text("\(newRating)")
                                    }
                                }
                                .annotation(position: .bottom) {
                                    if showAnnotations {
                                        VStack {
                                            Text("\(updateDate.formatted(date: .numeric, time: .shortened))")

                                            #if os(macOS)
                                            Text(attendedContest.contestName)
                                            #endif
                                        }
                                    }
                                }

                            LineMark(x: .value("Time", updateDate, unit: .day), y: .value("Ratings", newRating))
                                .interpolationMethod(.catmullRom)
                                .symbol(Circle().strokeBorder(lineWidth: 2))
                        }
                    }
                    .chartScrollableAxes(.horizontal)
                    .chartXVisibleDomain(length: 3600*24*15) // 15 days
                    .padding(.horizontal)
                    .animation(.default, value: showAnnotations)
                }
            }
        }
        .navigationTitle("CodeForces Rankings")
    }
}

#Preview {
    CodeForcesGraphView()
}
