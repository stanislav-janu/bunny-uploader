import UserNotifications

/// User notifications for finished and failed uploads.
///
/// Note: macOS has no Live Activities (iOS only), so there is no native
/// notification with a live progress bar. The Dock icon progress bar serves
/// as the live indicator; these notifications fire on completion/failure.
@MainActor
enum Notifications {
    /// Ask for permission once, early in app launch.
    static func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }

    static func uploadFinished(fileName: String) {
        notify(
            title: String(localized: "Upload complete"),
            body: fileName,
            sound: .default
        )
    }

    static func uploadFailed(fileName: String, message: String) {
        notify(
            title: String(localized: "Upload failed"),
            body: "\(fileName): \(message)",
            sound: .defaultCritical
        )
    }

    private static func notify(title: String, body: String, sound: UNNotificationSound) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = sound
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )
        UNUserNotificationCenter.current().add(request)
    }
}
