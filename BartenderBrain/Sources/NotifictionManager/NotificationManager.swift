//
//  NotificationsManager.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 04/11/24.
//

import Foundation
import UserNotifications

protocol NotificationManager: AnyObject {
    func setupDailyNotifications()
    func updateDailyNotificationHourIfNeeded(with hour: Int)
}

final class AppNotificationManager: NotificationManager {
    static let shared: NotificationManager = AppNotificationManager()
    private init() {}
    private lazy var notificationCenter = UNUserNotificationCenter.current()
    private lazy var dailyNotification = DailyNotification.allCases
    private var todayWeekday: Int { Date().weekday }
    
    // Ignore possible exceptions that may be raised from the notification center
    func setupDailyNotifications() {
        Task { [weak self] in 
            guard let self,
                  let authorized = try? await notificationCenter.requestAuthorization(options: [.alert, .sound]),
                  authorized else { return }
            let pendingRequests = await notificationCenter.pendingNotificationRequests()
            // If pendingRequests.count != dailyNotification.count => First time user opens app
            let excludeToday = pendingRequests.count == dailyNotification.count
            await createDailyNotifications(excludingWeekDay: excludeToday ? todayWeekday : nil)
        }
    }
    
    func updateDailyNotificationHourIfNeeded(with hour: Int) {
        // Update, if needed, time of the todayWeekday trigger event to avoid receiving the daily notification
        guard let dailyNotification = DailyNotification(rawValue: todayWeekday),
        hour < dailyNotification.defaultHour else { return }
        Task { [weak self] in guard let self else { return }
            let newNotificationRequest = createNotificationRequest(for: dailyNotification, at: hour)
            try? await notificationCenter.add(newNotificationRequest)
        }
    }
    
    private func createDailyNotifications(excludingWeekDay: Int? = nil) async {
        /// If excludingWeekDay is nil => First time user opens app, so all daily notifications are setted.
        /// Else => Recreate notifications for weekdays != todayWeekday, to reset time of the trigger events,
        /// avoiding to modify today’s notification, which may have a trigger event at a specific hour
        for notification in dailyNotification {
            if let excludingWeekDay, excludingWeekDay == notification.weekDay { continue }
            let notificationRequest = createNotificationRequest(for: notification)
            try? await notificationCenter.add(notificationRequest)
        }
    }
    
    private func createNotificationRequest(for notification: DailyNotification, at hour: Int? = nil) -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.title = "DAILY_NOTIFICATION.TITLE".localized
        content.body = "DAILY_NOTIFICATION.MESSAGE".localized
        content.sound = .default
        // Create weelky triggered notification
        var dateComponents = DateComponents()
        dateComponents.weekday = notification.weekDay
        dateComponents.hour = hour ?? notification.defaultHour
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        return .init(identifier: notification.identifier, content: content, trigger: trigger)
    }
    
}
