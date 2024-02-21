//
//  AutomaticNotificationMenu.swift
//  Kontest
//
//  Created by Ayush Singhal on 2/21/24.
//

import SwiftUI

struct AutomaticNotificationMenu: View {
    let siteAbbreviation: String
    
    let userDefaults = UserDefaults(suiteName: Constants.userDefaultsGroupID)!
    
    @State private var areAutomaticNotificationsEnabled10Minutes: Bool
    @State private var areAutomaticNotificationsEnabled30Minutes: Bool
    @State private var areAutomaticNotificationsEnabled1Hour: Bool
    @State private var areAutomaticNotificationsEnabled6Hours: Bool
    
    init(siteAbbreviation: String) {
        self.siteAbbreviation = siteAbbreviation
        self._areAutomaticNotificationsEnabled10Minutes = State(initialValue: userDefaults.bool(forKey: siteAbbreviation + Constants.automaticNotification10MinutesSuffix))
        
        self._areAutomaticNotificationsEnabled30Minutes = State(initialValue: userDefaults.bool(forKey: siteAbbreviation + Constants.automaticNotification30MinutesSuffix))
        
        self._areAutomaticNotificationsEnabled1Hour = State(initialValue: userDefaults.bool(forKey: siteAbbreviation + Constants.automaticNotification1HourSuffix))
        
        self._areAutomaticNotificationsEnabled6Hours = State(initialValue: userDefaults.bool(forKey: siteAbbreviation + Constants.automaticNotification6HoursSuffix))
    }
    
    var body: some View {
        Menu {
            Button {
                if areAutomaticNotificationsEnabled10Minutes {
                    userDefaults.setValue(false, forKey: siteAbbreviation + Constants.automaticNotification10MinutesSuffix)
                } else {
                    userDefaults.setValue(true, forKey: siteAbbreviation + Constants.automaticNotification10MinutesSuffix)
                }
                
                self.areAutomaticNotificationsEnabled10Minutes = userDefaults.bool(forKey: siteAbbreviation + Constants.automaticNotification10MinutesSuffix)
            } label: {
                Image(systemName: self.areAutomaticNotificationsEnabled10Minutes ? "bell.fill" : "bell")
                Text(self.areAutomaticNotificationsEnabled10Minutes ? "Remove 10 minutes before notification" : "Set notification for 10 minutes before")
            }
            .help(self.areAutomaticNotificationsEnabled10Minutes ? "Remove Notification for this site 10 minutes before" : "Set Notification for this site 10 minutes before") // Tooltip text
            
            Button {
                if areAutomaticNotificationsEnabled30Minutes {
                    userDefaults.setValue(false, forKey: siteAbbreviation + Constants.automaticNotification30MinutesSuffix)
                } else {
                    userDefaults.setValue(true, forKey: siteAbbreviation + Constants.automaticNotification30MinutesSuffix)
                }
                
                self.areAutomaticNotificationsEnabled30Minutes = userDefaults.bool(forKey: siteAbbreviation + Constants.automaticNotification30MinutesSuffix)
            } label: {
                Image(systemName: self.areAutomaticNotificationsEnabled30Minutes ? "bell.fill" : "bell")
                Text(self.areAutomaticNotificationsEnabled30Minutes ? "Remove 30 minutes before notification" : "Set notification for 30 minutes before")
            }
            .help(self.areAutomaticNotificationsEnabled30Minutes ? "Remove Notification for this site 30 minutes before" : "Set Notification for this site 30 minutes before") // Tooltip text
            
            Button {
                if areAutomaticNotificationsEnabled1Hour {
                    userDefaults.set(false, forKey: siteAbbreviation + Constants.automaticNotification1HourSuffix)
                } else {
                    userDefaults.set(true, forKey: siteAbbreviation + Constants.automaticNotification1HourSuffix)
                }
                
                self.areAutomaticNotificationsEnabled1Hour = userDefaults.bool(forKey: siteAbbreviation + Constants.automaticNotification1HourSuffix)
            } label: {
                Image(systemName: self.areAutomaticNotificationsEnabled1Hour ? "bell.fill" : "bell")
                Text(self.areAutomaticNotificationsEnabled1Hour ? "Remove 1 hour before notification" : "Set notification for 1 hour before")
            }
            .help(self.areAutomaticNotificationsEnabled1Hour ? "Remove Notification for this site 1 hour before" : "Set Notification for this site 1 hour before") // Tooltip text
            
            Button {
                if areAutomaticNotificationsEnabled6Hours {
                    userDefaults.set(false, forKey: siteAbbreviation + Constants.automaticNotification6HoursSuffix)
                } else {
                    userDefaults.set(true, forKey: siteAbbreviation + Constants.automaticNotification6HoursSuffix)
                }
                
                self.areAutomaticNotificationsEnabled6Hours = userDefaults.bool(forKey: siteAbbreviation + Constants.automaticNotification6HoursSuffix)
            } label: {
                Image(systemName: self.areAutomaticNotificationsEnabled6Hours ? "bell.fill" : "bell")
                Text(self.areAutomaticNotificationsEnabled6Hours ? "Remove 6 hours before notification" : "Set notification for 6 hours before")
            }
            .help(self.areAutomaticNotificationsEnabled6Hours ? "Remove Notification for this site 6 hours before" : "Set Notification for this site 6 hours before") // Tooltip text
        } label: {
            let imageName = (areAutomaticNotificationsEnabled10Minutes && areAutomaticNotificationsEnabled30Minutes && areAutomaticNotificationsEnabled1Hour && areAutomaticNotificationsEnabled6Hours) ? "bell.fill" : "bell"
            
            Image(systemName: imageName)
        } primaryAction: {
            if areAutomaticNotificationsEnabled10Minutes && areAutomaticNotificationsEnabled30Minutes && areAutomaticNotificationsEnabled1Hour && areAutomaticNotificationsEnabled6Hours {
                userDefaults.setValue(false, forKey: siteAbbreviation + Constants.automaticNotification10MinutesSuffix)
                userDefaults.setValue(false, forKey: siteAbbreviation + Constants.automaticNotification30MinutesSuffix)
                userDefaults.setValue(false, forKey: siteAbbreviation + Constants.automaticNotification1HourSuffix)
                userDefaults.setValue(false, forKey: siteAbbreviation + Constants.automaticNotification6HoursSuffix)
            } else {
                userDefaults.setValue(true, forKey: siteAbbreviation + Constants.automaticNotification10MinutesSuffix)
                userDefaults.setValue(true, forKey: siteAbbreviation + Constants.automaticNotification30MinutesSuffix)
                userDefaults.setValue(true, forKey: siteAbbreviation + Constants.automaticNotification1HourSuffix)
                userDefaults.setValue(true, forKey: siteAbbreviation + Constants.automaticNotification6HoursSuffix)
            }
            
            self.areAutomaticNotificationsEnabled10Minutes = userDefaults.bool(forKey: siteAbbreviation + Constants.automaticNotification10MinutesSuffix)
            self.areAutomaticNotificationsEnabled30Minutes = userDefaults.bool(forKey: siteAbbreviation + Constants.automaticNotification30MinutesSuffix)
            self.areAutomaticNotificationsEnabled1Hour = userDefaults.bool(forKey: siteAbbreviation + Constants.automaticNotification1HourSuffix)
            self.areAutomaticNotificationsEnabled6Hours = userDefaults.bool(forKey: siteAbbreviation + Constants.automaticNotification6HoursSuffix)
        }
        .menuStyle(.borderedButton)
    }
}

#Preview {
    AutomaticNotificationMenu(siteAbbreviation: Constants.SiteAbbreviations.CodeChef.rawValue)
        .frame(width: 400, height: 400)
}
