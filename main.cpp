#include "DatabaseHelper.h"
#include "ReminderScreen.h"
#include "NotificationScreen.h"
#include <iostream>

int main() {
    DatabaseHelper db("vehicles.db");
    if (!db.open()) {
        std::cerr << "Failed to open database.\n";
        return 1;
    }
    db.createTables();

    ReminderScreen reminder(db);
    NotificationScreen notifications(db);

    int choice;
    do {
        std::cout << "\n==== Vehicle Maintenance Tracker ====\n";
        std::cout << "1. View Upcoming Reminders\n";
        std::cout << "2. View Overdue Notifications\n";
        std::cout << "3. View Recent Maintenance\n";
        std::cout << "4. Exit\n";
        std::cout << "Choose an option: ";
        std::cin >> choice;

        switch (choice) {
            case 1:
                reminder.showUpcomingReminders(500);
                break;
            case 2:
                notifications.showOverdueNotifications();
                break;
            case 3:
                notifications.showRecentMaintenance();
                break;
            case 4:
                std::cout << "Goodbye!\n";
                break;
            default:
                std::cout << "Invalid choice.\n";
        }
    } while (choice != 4);

    db.close();
    return 0;
}
