//
//  CreateSectionView.swift
//  Kontest
//
//  Created by Ayush Singhal on 12/09/23.
//

import SwiftUI
import WidgetKit

struct CreateSectionView: View {
    let title: String
    let kontests: [KontestModel]
    let toShowDate: Bool
    let toShowTime: Bool
    let widgetFamily: WidgetFamily

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .bold()

            ForEach(kontests.indices) { index in
                createSingleKontestView(kontest: kontests[index], toShowDate: toShowDate, toShowTime: toShowTime, widgetFamily: widgetFamily)
                if index != kontests.count - 1 {
                    Divider()
                }
            }

            Divider()
                .frame(minHeight: 2)
                .overlay(RoundedRectangle(cornerRadius: 10).fill(.gray))
        }
    }
}

struct createSingleKontestView: View {
    let kontest: KontestModel
    let toShowDate: Bool
    let toShowTime: Bool
    let widgetFamily: WidgetFamily

    var body: some View {
        let startDate = CalendarUtility.getDate(date: kontest.start_time)
        if let startDate {
            HStack {
                Text(kontest.name)

                Spacer()

                if toShowTime {
                    Text(startDate.formatted(date: .omitted, time: .shortened))
                }

                if toShowDate {
                    if widgetFamily == .systemExtraLarge {
                        let p = CalendarUtility.getWeekdayNameFromDate(date: startDate)
                        Text("(\(p))")
                    }
                    Text(CalendarUtility.getKontestDate(date: startDate))
                }
            }
        }
    }
}
