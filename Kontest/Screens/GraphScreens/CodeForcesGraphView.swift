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

    let curGradient = LinearGradient(
        gradient: Gradient(
            colors: [
                Color(.systemYellow).opacity(0.8),
                Color(.systemYellow).opacity(0.5),
                Color(.systemYellow).opacity(0.35),
                Color(.systemYellow).opacity(0.3),
                Color(.systemYellow).opacity(0.2),
                Color(.systemYellow).opacity(0.15),
                Color(.systemYellow).opacity(0.1),
                Color(.systemYellow).opacity(0.05),
                Color(.systemYellow).opacity(0.03),
                Color(.systemYellow).opacity(0.01),
                Color(.systemYellow).opacity(0)
            ]
        ),
        startPoint: .top,
        endPoint: .bottom
    )

    var body: some View {
        #if os(macOS)
            EmptyView()
                .hidden()
                .onChange(of: codeForcesViewModel.selectedDate) { _, selectedDate in
                    if selectedDate != nil {
                        HapticFeedbackUtility.performHapticFeedback()
                    }
                }
        #endif

        VStack {
            if codeForcesViewModel.username.isEmpty {
                Text("Please update your username in the settings")
            } else if codeForcesViewModel.isLoading {
                ProgressView()
            } else if codeForcesViewModel.error is AppError {
                let appError = codeForcesViewModel.error as! AppError

                Text(appError.title)
                    .bold()

                Text(appError.description)
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

                            AreaMark(x: .value("Time", updateDate, unit: .day), y: .value("Ratings", newRating))
                                .interpolationMethod(.catmullRom)
                                .foregroundStyle(curGradient)
                        }

                        if let selectedDate = codeForcesViewModel.selectedDate, let kontest = getKontestFromDate(date: selectedDate) {
                            RuleMark(x: .value("selectedDate", selectedDate, unit: .day))
                                .zIndex(-1)
                                .annotation(position: .leading, spacing: 0, overflowResolution: .init(
                                    x: .fit(to: .chart),
                                    y: .disabled
                                )) {
                                    VStack(spacing: 10) {
                                        if showAnnotations {
                                            Text("Old Rating: \(kontest.oldRating)")
                                                .bold()

                                            Text("New Rating: \(kontest.newRating)")
                                                .bold()
                                        } else {
                                            Text(kontest.contestName)
                                                .bold()

                                            Text("\(selectedDate.formatted(date: Date.FormatStyle.DateStyle.abbreviated, time: .shortened))")
                                                .bold()

                                            Text("Old Rating: \(kontest.oldRating)")

                                            Text("New Rating: \(kontest.newRating)")
                                        }
                                    }
                                    .padding()
                                }
                            PointMark(x: .value("selectedDate", selectedDate, unit: .day), y: .value("", kontest.newRating))
                        }
                    }
                    .chartScrollableAxes(.horizontal)
                    .chartXVisibleDomain(length: 3600*24*30) // 30 days
                    .padding(.horizontal)
                    .chartXSelection(value: Bindable(codeForcesViewModel).rawSelectedDate)
                    .animation(.default, value: showAnnotations)
                }
            }
        }
        .navigationTitle("CodeForces Rankings")
    }
}

extension CodeForcesGraphView {
    private func getKontestFromDate(date: Date) -> CodeForcesuserRatingAPIResultModel? {
        codeForcesViewModel.codeForcesRatings?.result.first(where: { codeForcesuserRatingAPIResultModel in
            let updateTime = codeForcesuserRatingAPIResultModel.ratingUpdateTimeSeconds
            let updateDate = Date(timeIntervalSince1970: Double(updateTime))

            return updateDate == date
        })
    }
}

#Preview {
    CodeForcesGraphView()
        .frame(width: 500, height: 500)
}
