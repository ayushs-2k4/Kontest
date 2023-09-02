//
//  KontestDetailsScreen.swift
//  Kontest
//
//  Created by Ayush Singhal on 14/08/23.
//

import SwiftUI

struct KontestDetailsScreen: View {
    @Environment(AllKontestsViewModel.self) private var allKontestsViewModel
    @Environment(\.colorScheme) private var colorScheme

    @State private var isFaded = false

    var kontest: KontestModel

    var body: some View {
        let kontestStartDate = CalendarUtility.getDate(date: kontest.start_time)
        let kontestEndDate = CalendarUtility.getDate(date: kontest.end_time)

        VStack {
            VStack {
                let timeDifferenceString = CalendarUtility.getTimeDifferenceString(startDate: kontestStartDate ?? Date(), endDate: kontestEndDate ?? Date())

                TopCardView(color: KontestModel.getColorForIdentifier(site: kontest.site), kontestStartDate: kontestStartDate ?? Date(), kontestEndDate: kontestEndDate ?? Date(), boxText: timeDifferenceString)
                    .frame(height: 300)

                Spacer()

                VStack {
                    HStack {
                        Text(kontest.site.uppercased())
                            .foregroundStyle(KontestModel.getColorForIdentifier(site: kontest.site))
                            .padding(.horizontal)
                        
                        if CalendarUtility.isKontestRunning(kontestStartDate: kontestStartDate ?? Date(), kontestEndDate: kontestEndDate ?? Date()) || kontest.status == .Running {
                            BlinkingDotView(color: .green)
                                .frame(width: 10, height: 10)
                        }
                    }

                    Text(kontest.name)
                }

                Spacer()
                Spacer()
                Spacer()
                Spacer()
            }
            .multilineTextAlignment(.center)
            .ignoresSafeArea(edges: .top)

            ButtonsView(kontest: kontest, allKontestsViewModel: allKontestsViewModel)
        }
        .frame(maxHeight: .infinity)
    }
}

struct ButtonsView: View {
    let kontest: KontestModel
    let allKontestsViewModel: AllKontestsViewModel
    let kontestStartDate: Date?

    init(kontest: KontestModel, allKontestsViewModel: AllKontestsViewModel) {
        self.kontest = kontest
        self.allKontestsViewModel = allKontestsViewModel
        kontestStartDate = CalendarUtility.getDate(date: kontest.start_time)
    }

    var body: some View {
        VStack {
            if CalendarUtility.isKontestOfFuture(kontestStartDate: kontestStartDate ?? Date()) {
                SingleNotificationMenu(kontest: kontest)
            }

            Link(destination: URL(string: kontest.url)!, label: {
                Text("Contest Registration Page")
                    .frame(maxWidth: .infinity)
            })
        }
        .foregroundStyle(KontestModel.getColorForIdentifier(site: kontest.site))
        .buttonStyle(.bordered)
        .padding()
    }
}

struct TopCardView: View {
    @Environment(\.colorScheme) var colorScheme

    let color: Color
    let kontestStartDate: Date
    let kontestEndDate: Date
    let boxText: String

    var startDateComponenets: DateComponents
    var endDateComponenets: DateComponents

    init(color: Color, kontestStartDate: Date, kontestEndDate: Date, boxText: String) {
        self.color = color
        self.kontestStartDate = kontestStartDate
        self.kontestEndDate = kontestEndDate
        self.boxText = boxText

        startDateComponenets = Calendar.current.dateComponents([.weekday], from: kontestStartDate)
        endDateComponenets = Calendar.current.dateComponents([.weekday], from: kontestEndDate)
    }

    var body: some View {
        ZStack {
            TopCard(color: color)

            HStack(alignment: .top) {
                TimeView(day: CalendarUtility.getWeekdayNameFromDate(date: kontestStartDate), time: kontestStartDate.formatted(date: .omitted, time: .shortened), date: CalendarUtility.getKontestDate(date: kontestStartDate), horizontalAlignment: .leading)
                    .padding(.leading)
                Spacer()

                BoxView(blockColor: colorScheme == .light ? .white : .black, textColor: color, text: boxText)
                    .frame(width: 50, height: 50)

                Spacer()

                TimeView(day: CalendarUtility.getWeekdayNameFromDate(date: kontestEndDate), time: kontestEndDate.formatted(date: .omitted, time: .shortened), date: CalendarUtility.getKontestDate(date: kontestEndDate), horizontalAlignment: .trailing)
                    .padding(.trailing)
            }
        }
    }
}

struct TopCard: View {
    let color: Color
    var body: some View {
        UnevenRoundedRectangle(bottomLeadingRadius: 40, bottomTrailingRadius: 40)
            .foregroundStyle(color)
    }
}

struct BoxView: View {
    let blockColor: Color
    let textColor: Color
    let text: String
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(blockColor)
                .aspectRatio(1, contentMode: .fill)
            Text(text)
                .scaledToFill()
                .padding(.horizontal, 5)
                .foregroundStyle(textColor)
        }
    }
}

struct TimeView: View {
    @Environment(\.colorScheme) var colorScheme
    var day: String
    var time: String
    var date: String
    let horizontalAlignment: HorizontalAlignment

    var body: some View {
        VStack(alignment: horizontalAlignment) {
            Text(day)
                .alignmentGuide(.leading) { _ in 0 }
                .font(.title)
                .bold()
                .frame(alignment: .leading)

            Text(time)
                .alignmentGuide(.leading) { _ in 0 }
                .font(.headline)
                .bold()
                .frame(alignment: .leading)

            Text(date)
                .alignmentGuide(.leading) { _ in 0 }
                .font(.headline)
                .bold()
                .frame(alignment: .leading)
        }
        .foregroundStyle(colorScheme == .light ? .white : .black)
    }
}

#Preview {
//    KontestDetailsView(kontest: KontestModel.from(dto: KontestDTO(name: "Starters 100 (Date to be decided)", url: "https://www.codechef.com/START100", start_time: "2023-08-30 14:30:00 UTC", end_time: "2023-08-30 16:30:00 UTC", duration: "7200", site: "CodeChef", in_24_hours: "No", status: "BEFORE")))

//    let startTime = "2023-08-14 17:42:00 UTC"
//    let endTime = "2023-08-21 17:43:00 UTC"

    let startTime = "2023-08-30 00:00:00 UTC"
    let endTime = "2023-10-30 23:59:00 UTC"

//    return KontestDetailsScreen(kontest: KontestModel.from(dto: KontestDTO(name: "ProjectEuler+", url: "https://hackerrank.com/contests/projecteuler", start_time: startTime, end_time: endTime, duration: "1020.0", site: "HackerRank", in_24_hours: "No", status: "CODING")))
//        .environment(AllKontestsViewModel())
    
    return KontestDetailsScreen(kontest: KontestModel.from(dto: KontestDTO(name: "THIRD PROGRAMMING CONTEST 2023 ALGO (AtCoder Beginner Contest 318)", url: "https://hackerrank.com/contests/projecteuler", start_time: startTime, end_time: endTime, duration: "1020.0", site: "AtCoder", in_24_hours: "No", status: "CODING")))
        .environment(AllKontestsViewModel())
}

// #Preview("TopCardView") {
//    TopCardView(color: .pink)
// }
//
// #Preview("TopCard") {
//    TopCard(color: .pink)
// }
//
// #Preview("BlockView") {
//    BlockView(blockColor: .black, textColor: .pink, text: "2HR")
// }

// #Preview("TimeView") {
//    TimeView(horizontalAlignment: .leading)
// }
