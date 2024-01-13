//
//  CalendarPopoverView.swift
//  Kontest
//
//  Created by Ayush Singhal on 23/09/23.
//

import EventKit
import SwiftUI

struct CalendarPopoverView: View {
    let date: Date
    let kontestStartDate: Date
    @State private var selectedDate: Date
    let isAlreadySetted: Bool

    let onPressDelete: () -> Void
    let onPressSet: (_ setDate: Date) -> Void

    init(date: Date, kontestStartDate: Date, isAlreadySetted: Bool, onPressDelete: @escaping () -> Void, onPressSet: @escaping (_: Date) -> Void) {
        self.date = date
        self.kontestStartDate = kontestStartDate
        self._selectedDate = State(initialValue: date)
        self.isAlreadySetted = isAlreadySetted
        self.onPressDelete = onPressDelete
        self.onPressSet = onPressSet
    }

    var body: some View {
        VStack {
            DatePicker("Select When to Alert", selection: $selectedDate, in: .now ... kontestStartDate)

            PickerView()

            HStack {
                Button(role: .destructive) {
                    onPressDelete()
                } label: {
                    Text(isAlreadySetted ? "Delete" : "Cancel")
                    #if !os(macOS)
                        .foregroundStyle(.red)
                    #endif
                }

                Spacer()

                Button(isAlreadySetted ? "Change" : "Set") {
                    onPressSet(selectedDate)
                }
                .foregroundStyle(.blue)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

struct PickerView: View {
    let arr: [(String, [EKCalendar])] = getDict()

    @State private var selectedAccountIndex = 0
    @State private var selectedCalendarIndex = 0

    var body: some View {
        Text("selected account index: \(selectedAccountIndex)")
        Text("selected calendar index: \(selectedCalendarIndex)")

        VStack {
            Picker("Select Account", selection: $selectedAccountIndex) {
                ForEach(arr.indices, id: \.self) { index in
                    Text(arr[index].0)
                        .tag(index)
                }
            }

            Picker("Select Calendar", selection: $selectedCalendarIndex) {
                let selectedAccountValue = arr[selectedAccountIndex].1

                ForEach(selectedAccountValue.indices, id: \.self) { index in
                    Text("\(selectedAccountValue[index].title)")
                        .tag(index)
                }
            }
        }
        .onChange(of: selectedAccountIndex) {
            selectedCalendarIndex = 0
        }
    }
}

func getDict() -> [(String, [EKCalendar])] {
    do {
        let dict = try CalendarUtility.getChangableCalendarsByTheirSources()

//        let k = dict.sorted { ele1, ele2 in
//            ele1.key < ele2.key
//        }

        return dict
    } catch {
        return []
    }
}

#Preview {
    CalendarPopoverView(date: Date().addingTimeInterval(-15 * 60), kontestStartDate: Date().addingTimeInterval(86400), isAlreadySetted: true) {
        print("Delete")
    } onPressSet: { setDate in
        print("setDate: \(setDate)")
    }
}
