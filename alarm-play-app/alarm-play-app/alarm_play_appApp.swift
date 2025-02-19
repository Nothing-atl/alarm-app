//
//  alarm_play_appApp.swift
//  alarm-play-app
//
//  Created by Aleena Leejoy on 2025-02-13.
//

import SwiftUI
import UserNotifications


@main
struct alarm_play_appApp: App {
    private let notificationDelegate = NotificationDelegate() // Keep reference

    init() {
        UNUserNotificationCenter.current().delegate = notificationDelegate
        notificationDelegate.registerCategories() // ✅ Register categories at app launch
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}




