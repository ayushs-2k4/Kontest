//
//  CalendarPopoverView.swift
//  Kontest
//
//  Created by Ayush Singhal on 23/09/23.
//

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

#Preview {
    CalendarPopoverView(date: Date().addingTimeInterval(-15 * 60), kontestStartDate: Date().addingTimeInterval(86400), isAlreadySetted: true) {
        print("Delete")
    } onPressSet: { setDate in
        print("setDate: \(setDate)")
    }
}
