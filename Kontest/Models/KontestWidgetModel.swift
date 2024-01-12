//
//  KontestWidgetModel.swift
//  Kontest
//
//  Created by Ayush Singhal on 16/09/23.
//

import AppIntents
import Foundation

struct KontestWidgetModelQuery: EntityQuery {
    func entities(for identifiers: [KontestWidgetModel.ID]) async throws -> [KontestWidgetModel] {
        return []
    }
}

struct KontestWidgetModel: AppEntity, Identifiable {
    static var defaultQuery = KontestWidgetModelQuery()

    static var typeDisplayRepresentation: TypeDisplayRepresentation = ""

    var displayRepresentation: DisplayRepresentation { DisplayRepresentation(title: "DisplayRepresentationTitle") }

    let id: String
    let name: String
    let url: String
    let start_time: String
    let end_time: String
    let duration: String
    let site: String
    let in_24_hours: String
    var status: KontestStatus
    var isSetForReminder10MiutesBefore: Bool
    var isSetForReminder30MiutesBefore: Bool
    var isSetForReminder1HourBefore: Bool
    var isSetForReminder6HoursBefore: Bool
    let logo: String
    var isCalendarEventAdded: Bool
}

extension KontestWidgetModel {
    static func from(kontestModel: KontestModel) -> KontestWidgetModel {
        return KontestWidgetModel(id: kontestModel.id, name: kontestModel.name, url: kontestModel.url, start_time: kontestModel.start_time, end_time: kontestModel.end_time, duration: kontestModel.duration, site: kontestModel.siteAbbreviation, in_24_hours: kontestModel.in_24_hours, status: kontestModel.status, isSetForReminder10MiutesBefore: kontestModel.isSetForReminder10MiutesBefore, isSetForReminder30MiutesBefore: kontestModel.isSetForReminder30MiutesBefore, isSetForReminder1HourBefore: kontestModel.isSetForReminder1HourBefore, isSetForReminder6HoursBefore: kontestModel.isSetForReminder6HoursBefore, logo: kontestModel.logo, isCalendarEventAdded: kontestModel.isCalendarEventAdded)
    }
}
