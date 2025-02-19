//
//  ContentView.swift
//  alarm-play-app
//
//  Created by Aleena Leejoy on 2025-02-13.
//

import SwiftUI
import UserNotifications
import AVFoundation

struct Alarm: Identifiable, Codable {
    var id: UUID = UUID()
    var time: Date
    var reason: String
    var repeatDaily: Bool
    var selectedDays: [Bool] // Which days the alarm should repeat
}

struct ContentView: View {
    @State private var alarmTime: Date = Date()
    @State private var reason: String = ""
    @State private var repeatDaily: Bool = false
    @State private var selectedDays: [Bool] = Array(repeating: false, count: 7)
    @State private var alarms: [Alarm] = []
    @State private var editingAlarm: Alarm?
    @State private var selectedSound: String = "minions_wake_up.wav" // Default sound
    @AppStorage("isDarkMode") private var isDarkMode = false // ✅ Store User Preference

 
    
    let availableSounds = ["minions_wake_up.wav", "morning_tone.wav", "beep_alert.mp3"] // Available sounds
    let weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    var body: some View {
            NavigationView { // ✅ Wrap in NavigationView to keep toolbar always accessible
                ScrollView { // ✅ Allow scrolling so Save button is always visible
                    VStack(spacing: 20) {
                        
                        Spacer().frame(height: 130)  // ✅ Extra spacing before the list
                        // 📌 List of Alarms with Swipe Actions
                        if !alarms.isEmpty {
                            VStack {
                
                                Text("Scheduled Alarms")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    .padding(.top, 10) // ✅ More space before the list

                                List {
                                    ForEach(alarms) { alarm in
                                        VStack(alignment: .leading) {
                                            Text("\(formattedTime(alarm.time))")
                                                .font(.headline)
                                                .foregroundColor(.primary)

                                            if !alarm.reason.isEmpty {
                                                Text("Reason: \(alarm.reason)")
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                            }

                                            Text(alarm.repeatDaily ? "Repeats Daily" : repeatSummary(alarm.selectedDays))
                                                .font(.footnote)
                                                .foregroundColor(.secondary)
                                        }
                                        .swipeActions {
                                            Button("Edit") {
                                                editAlarm(alarm)
                                            }
                                            .tint(.yellow)

                                            Button("Delete", role: .destructive) {
                                                deleteAlarm(alarm)
                                            }
                                        }
                                    }
                                }
                                .frame(minHeight: 200, maxHeight: 300) // ✅ Adaptive height
                            }
                        }

                        Text(editingAlarm == nil ? "Set a New Alarm" : "Edit Alarm")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)

                        // 📌 Time Picker
                        DatePicker("Select Time", selection: $alarmTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .datePickerStyle(WheelDatePickerStyle())

                        // 📌 Reason Input
                        TextField("Reason (optional)", text: $reason)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemGray6)))
                            .padding(.horizontal, 40)

                        // 📌 Repeat Daily Toggle
                        Toggle("Repeat Daily", isOn: $repeatDaily)
                            .padding(.horizontal, 40)

                        // 📌 Specific Day Selection
                        if !repeatDaily {
                            HStack {
                                ForEach(0..<7, id: \.self) { index in
                                    Button(action: {
                                        selectedDays[index].toggle()
                                    }) {
                                        Text(weekdays[index])
                                            .font(.caption)
                                            .foregroundColor(selectedDays[index] ? .white : .blue)
                                            .padding(8)
                                            .frame(width: 40)
                                            .background(selectedDays[index] ? Color.blue : Color.clear)
                                            .cornerRadius(10)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color.blue, lineWidth: 1)
                                            )
                                    }
                                }
                            }
                            .padding(.horizontal, 40)
                        }

                        // 📌 Sound Picker
                        VStack {
                            Text("Select Alarm Sound")
                                .font(.headline)
                                .foregroundColor(.primary)

                            Picker("Alarm Sound", selection: $selectedSound) {
                                ForEach(availableSounds, id: \.self) { sound in
                                    Text(sound)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding()
                        }

                        // 📌 Save or Update Alarm Button
                        Button(action: {
                            if let editingAlarm = editingAlarm {
                                updateAlarm(editingAlarm)
                            } else {
                                saveAlarm()
                            }
                        }) {
                            Text(editingAlarm == nil ? "Save Alarm" : "Update Alarm")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .shadow(radius: 3)
                        }
                        .padding(.horizontal, 50)
                    }
                    .padding()
                }
                .background(Color(.systemBackground)) // ✅ Adapts to Light/Dark Mode
                .ignoresSafeArea()
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .navigationTitle("Alarm App") // ✅ Keeps a title in the toolbar
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) { // ✅ Keeps Dark Mode Button visible
                        Button(action: {
                            withAnimation { isDarkMode.toggle() }
                        }) {
                            HStack {
                                Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                                    .foregroundColor(isDarkMode ? .yellow : .blue)
                            }
                            .padding()
                        }
                    }
                }
            }
        }
    // 📌 Format time for display
    func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    // 📌 Generate repeat summary
    func repeatSummary(_ days: [Bool]) -> String {
        let selectedWeekdays = weekdays.enumerated().compactMap { days[$0.offset] ? $0.element : nil }
        return selectedWeekdays.isEmpty ? "One-time alarm" : "Repeats on: \(selectedWeekdays.joined(separator: ", "))"
    }

    // 📌 Request notification permission
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied.")
            }
        }
    }

    // 📌 Save a new alarm
    func saveAlarm() {
        let newAlarm = Alarm(time: alarmTime, reason: reason, repeatDaily: repeatDaily, selectedDays: selectedDays)
        alarms.append(newAlarm)
        scheduleAlarm(newAlarm)
        saveAlarmsToStorage()
    }

    // 📌 Update an existing alarm
    func updateAlarm(_ oldAlarm: Alarm) {
        DispatchQueue.main.async { // ✅ Force UI refresh
            if let index = self.alarms.firstIndex(where: { $0.id == oldAlarm.id }) {
                // Remove old notification
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [oldAlarm.id.uuidString])
                
                // Update the alarm in the list
                self.alarms[index] = Alarm(time: self.alarmTime, reason: self.reason, repeatDaily: self.repeatDaily, selectedDays: self.selectedDays)
                
                // Reschedule the updated alarm
                self.scheduleAlarm(self.alarms[index])
            }
            self.editingAlarm = nil
            self.saveAlarmsToStorage()
        }
    }



    // 📌 Schedule Alarm Notification
    func scheduleAlarm(_ alarm: Alarm) {
        let content = UNMutableNotificationContent()
        content.title = "Alarm"
        content.body = alarm.reason.isEmpty ? "Time to wake up!" : alarm.reason
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: selectedSound))

        content.categoryIdentifier = "ALARM_CATEGORY" // ✅ Make sure this matches the registered category

        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.hour, .minute], from: alarm.time), repeats: alarm.repeatDaily)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        print("📅 Scheduling alarm for \(alarm.time) with sound \(selectedSound) and category ALARM_CATEGORY")

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Error scheduling alarm: \(error.localizedDescription)")
            } else {
                print("✅ Alarm successfully set for \(alarm.time)")
            }
        }
    }

    // 📌 Edit an Alarm
    func editAlarm(_ alarm: Alarm) {
        alarmTime = alarm.time
        reason = alarm.reason
        repeatDaily = alarm.repeatDaily
        selectedDays = alarm.selectedDays
        editingAlarm = alarm
    }

    // 📌 Delete an Alarm
    func deleteAlarm(_ alarm: Alarm) {
        DispatchQueue.main.async { // ✅ Force UI refresh
            self.alarms.removeAll { $0.id == alarm.id }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.id.uuidString])
            self.saveAlarmsToStorage()
        }
    }



    // 📌 Save Alarms to Storage (UserDefaults)
    func saveAlarmsToStorage() {
        if let encoded = try? JSONEncoder().encode(alarms) {
            UserDefaults.standard.set(encoded, forKey: "alarms")
        }
    }

    // 📌 Load Alarms from Storage
    func loadAlarms() {
        DispatchQueue.main.async { // ✅ Force UI refresh
            if let savedAlarms = UserDefaults.standard.data(forKey: "alarms"),
               let decodedAlarms = try? JSONDecoder().decode([Alarm].self, from: savedAlarms) {
                self.alarms = decodedAlarms
            } else {
                self.alarms = [] // ✅ Empty list if no alarms exist
            }
        }
    }


}

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func registerCategories() {
        let snoozeAction = UNNotificationAction(identifier: "SNOOZE_ACTION",
                                                title: "Snooze 5 min",
                                                options: UNNotificationActionOptions(rawValue: 0)) // ✅ No authentication required

        let alarmCategory = UNNotificationCategory(identifier: "ALARM_CATEGORY",
                                                   actions: [snoozeAction],
                                                   intentIdentifiers: [],
                                                   options: [])

        UNUserNotificationCenter.current().setNotificationCategories([alarmCategory])

        print("✅ Notification categories registered: \(alarmCategory.identifier)")
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("🔔 Alarm triggered in foreground!")
        completionHandler([.banner, .sound]) // ✅ Ensure the alert shows when app is open
    }

    // Handle snooze button action
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "SNOOZE_ACTION" {
            print("⏰ Snooze button pressed!")
            snoozeAlarm()
        }
        completionHandler()
    }

    // Function to reschedule alarm 5 minutes later
    func snoozeAlarm() {
        let content = UNMutableNotificationContent()
        content.title = "Alarm"
        content.body = "Snoozed Alarm!"
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "ALARM_CATEGORY" // ✅ Ensure category is set

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 300, repeats: false) // 5 min snooze

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Error scheduling snooze: \(error.localizedDescription)")
            } else {
                print("✅ Snooze set for 5 minutes")
            }
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark) // ✅ Preview in Dark Mode
}
