/// Shared notification model and list used by dashboard bell (AnnouncementsScreen)
/// and profile Notification screen so both show the same notifications.
class AppNotification {
  const AppNotification({
    required this.title,
    required this.description,
    required this.time,
  });

  final String title;
  final String description;
  final String time;
}

/// Single source of truth for all in-app notifications (bell icon + profile Notification).
const List<AppNotification> appNotifications = [
  AppNotification(
    title: 'Pool Maintenance Scheduled:',
    description:
        'The swimming pool will be closed for routine maintenance from saturday, 15th Feb, 2026 to sunday, 16th Feb, 2026.',
    time: '5:26 am',
  ),
  AppNotification(
    title: 'Fire Safety Drill',
    description:
        'There will be a fire safety drill on monday, 17th Feb, 2026 at 10:00 am.',
    time: '2:16 am',
  ),
  AppNotification(
    title: 'Guest Parking Policy ',
    description:
        "All guests are required to park in the designated guest parking area.",
    time: '9:00 pm',
  ),
  AppNotification(
    title: 'Sports Complex Closure',
    description:
        'The sports complex will be closed for maintenance from tuesday, 18th Feb, 2026 to wednesday, 19th Feb, 2026.',
    time: '2:45 am',
  ),
];
