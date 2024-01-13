//
//  CodeChefGraphView.swift
//  Kontest
//
//  Created by Ayush Singhal on 1/13/24.
//

import Charts
import Foundation
import SwiftUI

struct CodeChefGraphView: View {
    let codeChefViewModel: CodeChefViewModel = Dependencies.instance.codeChefViewModel

    @State private var showAnnotations: Bool = true

    var body: some View {
        VStack {
            if codeChefViewModel.username.isEmpty {
                Text("Please update your username in the settings")
            }
            else if codeChefViewModel.isLoading {
                ProgressView()
            }
            else {
                if let error = codeChefViewModel.error {
                    Text("Error: \(error.localizedDescription)")
                }
                else {
                    Text(codeChefViewModel.username)

                    Text("Total Kontests attended: \(codeChefViewModel.attendedKontests.count)")

                    Toggle("Show Annotations?", isOn: $showAnnotations)
                        .toggleStyle(.switch)
                        .padding(.horizontal)

                    CodeChefChart(showAnnotations: $showAnnotations)
                }
            }
        }
    }
}

struct CodeChefChart: View {
    @Binding var showAnnotations: Bool

    let curGradient = LinearGradient(
        gradient: Gradient(
            colors: [
                Color(.systemBrown).opacity(0.8),
                Color(.systemBrown).opacity(0.5),
                Color(.systemBrown).opacity(0.35),
                Color(.systemBrown).opacity(0.3),
                Color(.systemBrown).opacity(0.2),
                Color(.systemBrown).opacity(0.15),
                Color(.systemBrown).opacity(0.1),
                Color(.systemBrown).opacity(0.05),
                Color(.systemBrown).opacity(0.03),
                Color(.systemBrown).opacity(0.01),
                Color(.systemBrown).opacity(0)
            ]
        ),
        startPoint: .top,
        endPoint: .bottom
    )

    let codeChefViewModel: CodeChefViewModel = Dependencies.instance.codeChefViewModel

    var body: some View {
        #if os(macOS)
            EmptyView()
                .hidden()
                .onChange(of: codeChefViewModel.selectedDate) { _, selectedDate in
                    if selectedDate != nil {
                        HapticFeedbackUtility.performHapticFeedback()
                    }
                }
        #endif

        Chart {
            ForEach(codeChefViewModel.attendedKontests) { attendedKontest in
                let date = CalendarUtility.getFormattedDateForCodeChefKontestRatings(date: attendedKontest.endDate)

                let rating = Int(attendedKontest.rating)
                let name = attendedKontest.name

                if let date, let rating {
                    PointMark(x: .value("Time", date, unit: .day), y: .value("Ratings", rating))
                        .opacity(0)
                        .annotation(position: .top) {
                            if showAnnotations {
                                Text("\(rating)")
                            }
                        }
                        .annotation(position: .bottom) {
                            if showAnnotations {
                                VStack {
                                    Text("\(date.formatted(date: .numeric, time: .shortened))")

                                    #if os(macOS)
                                        Text(name)
                                    #endif
                                }
                            }
                        }

                    LineMark(x: .value("Time", date, unit: .day), y: .value("Ratings", rating))
                        .interpolationMethod(.catmullRom)
                        .symbol(Circle().strokeBorder(lineWidth: 2))

                    AreaMark(x: .value("Time", date, unit: .day), y: .value("Ratings", rating))
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(curGradient)
                }
            }

            if let selectedDate = codeChefViewModel.selectedDate, let kontest = getKontestFromDate(date: selectedDate) {
                RuleMark(x: .value("selectedDate", selectedDate, unit: .day))
                    .zIndex(-1)
                    .annotation(position: .leading, spacing: 0, overflowResolution: .init(
                        x: .fit(to: .chart),
                        y: .disabled
                    )) {
                        VStack(spacing: 10) {
                            Text(kontest.name)

                            Text("Ended: \(selectedDate.formatted(date: Date.FormatStyle.DateStyle.abbreviated, time: .shortened))")

                            Text("Ranking: \(kontest.rank)")

                            Text("rating: \(kontest.rating)")
                        }
                        .padding()
                    }

                if let rating = Int(kontest.rating) {
                    PointMark(x: .value("selectedDate", selectedDate, unit: .day), y: .value("", rating))
                }
            }
        }
        .foregroundStyle(.brown)
        .chartScrollableAxes(.horizontal)
        .chartXVisibleDomain(length: 3600 * 24 * 30) // 30 days
        .padding(.horizontal)
        .chartXSelection(value: Bindable(codeChefViewModel).rawSelectedDate)
        .animation(.default, value: showAnnotations)
    }
}

extension CodeChefChart {
    private func getKontestFromDate(date: Date) -> CodeChefScrapingContestModel? {
        return codeChefViewModel.attendedKontests.first { codeChefScrapingContestModel in
            let endDate = CalendarUtility.getFormattedDateForCodeChefKontestRatings(date: codeChefScrapingContestModel.endDate) ?? .now

            return date == endDate
        }
    }
}

#Preview {
    CodeChefGraphView()
        .frame(width: 500, height: 500)
}
