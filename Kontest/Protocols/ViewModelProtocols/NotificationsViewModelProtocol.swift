//
//  NotificationViewModelProtocol.swift
//  Kontest
//
//  Created by Ayush Singhal on 18/09/23.
//

import Foundation
import UserNotifications

protocol NotificationsViewModelProtocol: Sendable {
    var pendingNotifications: [UNNotificationRequest] { get }
    
    func getAllPendingNotifications()
    
    func getNumberOfNotificationsWhichCanBeSettedForAKontest(kontest: KontestModel) -> Int
    
    func getNumberOfSettedNotificationForAKontest(kontest: KontestModel) -> Int
    
    func setNotification(kontest: KontestModel, minutesBefore: Int, hoursBefore: Int, daysBefore: Int, kontestTitle: String, kontestSubTitle: String, kontestBody: String) async throws
    
    func setNotificationForKontest(kontest: KontestModel, minutesBefore: Int, hoursBefore: Int, daysBefore: Int, kontestTitle: String, kontestSubTitle: String, kontestBody: String) async throws
    
    func setNotificationForAllKontests(minutesBefore: Int, hoursBefore: Int, daysBefore: Int, kontestTitle: String, kontestSubTitle: String, kontestBody: String) async throws
    
    func removeAllPendingNotifications()
    
    func printAllPendingNotifications()
    
    func updateIsSetForNotification(kontest: KontestModel, to: Bool, minutesBefore: Int, hoursBefore: Int, daysBefore: Int, removeAll: Bool)
}
