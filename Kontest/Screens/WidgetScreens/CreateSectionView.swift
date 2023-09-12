//
//  CreateSectionView.swift
//  Kontest
//
//  Created by Ayush Singhal on 12/09/23.
//

import SwiftUI

struct CreateSectionView: View {
    let title: String
    let kontests: [KontestModel]
    let toShowDate: Bool
    let toShowTime: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .bold()

            let size = kontests.count

            ForEach(kontests.indices) { index in
                createSingleKontestView(kontest: kontests[index], toShowDate: toShowDate, toShowTime: toShowTime)
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
                    Text(CalendarUtility.getKontestDate(date: startDate))
                }
            }
        }
    }
}
