//
//  KontestDetailsView.swift
//  Kontests
//
//  Created by Ayush Singhal on 14/08/23.
//

import SwiftUI

struct KontestDetailsView: View {
    @Environment(AllKontestsViewModel.self) private var allKontestsViewModel
    @Environment(\.colorScheme) private var colorScheme

    var kontest: KontestModel

    var body: some View {
        let kontestStartDate = CalendarUtility.getDate(date: kontest.start_time)
        let kontestEndDate = CalendarUtility.getDate(date: kontest.end_time)

        VStack {
            VStack {
                let p = getTimeDifferenceString(startDate: kontestStartDate ?? Date(), endDate: kontestEndDate ?? Date())

                TopCardView(color: KontestModel.getColorForIdentifier(site: kontest.site), kontestStartDate: kontestStartDate ?? Date(), kontestEndDate: kontestEndDate ?? Date(), boxText: p)
                    .frame(height: 300)

                Spacer()

                VStack {
                    HStack {
                        if CalendarUtility.isKontestRunning(kontestStartDate: kontestStartDate ?? Date(), kontestEndDate: kontestEndDate ?? Date()) {
//                            BlinkingDotView(color: .green)
//                                .frame(width: 10, height: 10)
                        }

                        Text(kontest.site.uppercased())
                            .foregroundStyle(KontestModel.getColorForIdentifier(site: kontest.site))
                            .padding(.horizontal)
                    }

                    Text(kontest.name)
                }

                Spacer()
                Spacer()
                Spacer()
                Spacer()
            }
            .multilineTextAlignment(.center)
            .ignoresSafeArea()

            VStack {
                if CalendarUtility.isKontestOfFuture(kontestStartDate: kontestStartDate ?? Date()) {
                    Button {
                        if kontest.isSetForReminder {
                            allKontestsViewModel.removePendingNotification(kontest: kontest)
                        } else {
                            allKontestsViewModel.setNotification(kontest: kontest)
                        }
                    } label: {
                        Text(kontest.isSetForReminder ? "Remove in-app Reminder" : "Add in-app Reminder")
                            .frame(maxWidth: .infinity)
                    }
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
        .frame(maxHeight: .infinity)
    }

    private func getTimeDifferenceString(startDate: Date, endDate: Date) -> String {
        let components = Calendar.current.dateComponents([.day, .hour, .minute], from: startDate, to: endDate)

        var formattedTime = ""

        if let days = components.day, days > 0 {
            formattedTime.append("\(days)D")
        } else {
            if let minutes = components.minute, minutes > 0 {
                if let hours = components.hour, hours > 0 {
                    formattedTime.append("\(hours)H \(minutes)M")
                } else {
                    formattedTime.append("\(minutes)M")
                }
            } else {
                if let hours = components.hour, hours > 0 {
                    formattedTime.append("\(hours)H")
                }
            }
        }

        return formattedTime.isEmpty ? "0H" : formattedTime
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

    init(color: Color, kontestStartDate: Date, kontestEndDate: Date, boxText: String = "2HR") {
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
                TimeView(day: getWeekdayNameFromDate(date: kontestStartDate), time: kontestStartDate.formatted(date: .omitted, time: .shortened), date: CalendarUtility.getKontestDate(date: kontestStartDate), horizontalAlignment: .leading)
                    .padding(.leading)
                Spacer()

                BoxView(blockColor: colorScheme == .light ? .white : .black, textColor: color, text: boxText)
                    .frame(width: 50, height: 50)

                Spacer()

                TimeView(day: getWeekdayNameFromDate(date: kontestEndDate), time: kontestEndDate.formatted(date: .omitted, time: .shortened), date: CalendarUtility.getKontestDate(date: kontestEndDate), horizontalAlignment: .trailing)
                    .padding(.trailing)
            }
        }
    }

    func getWeekdayNameFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: date).uppercased()
    }

    func getTimeFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
}

struct TopCard: View {
    let color: Color
    var body: some View {
        RoundedRectangle(cornerRadius: 40)
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
    var day: String = "FRI"
    var time: String = "08:30"
    var date: String = "11 Aug, 2023"
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
//        .background(.red)
    }
}

#Preview {
//    KontestDetailsView(kontest: KontestModel.from(dto: KontestDTO(name: "Starters 100 (Date to be decided)", url: "https://www.codechef.com/START100", start_time: "2023-08-30 14:30:00 UTC", end_time: "2023-08-30 16:30:00 UTC", duration: "7200", site: "CodeChef", in_24_hours: "No", status: "BEFORE")))

//    let startTime = "2023-08-14 17:42:00 UTC"
//    let endTime = "2023-08-21 17:43:00 UTC"

    let startTime = "2023-08-15 00:00:00 UTC"
    let endTime = "2023-08-15 23:59:00 UTC"

    return KontestDetailsView(kontest: KontestModel.from(dto: KontestDTO(name: "ProjectEuler+", url: "https://hackerrank.com/contests/projecteuler", start_time: startTime, end_time: endTime, duration: "1020.0", site: "HackerRank", in_24_hours: "No", status: "CODING")))
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

#Preview("TimeView") {
    TimeView(horizontalAlignment: .leading)
}
