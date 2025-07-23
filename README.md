# FinTrack 💸

A cross-platform personal finance manager built with Flutter and Firebase to help you track your income, expenses, and savings goals seamlessly.

-----

## ✨ Key Features

  * **🔐 Secure Authentication:** Secure sign-in and sign-up using Firebase Authentication (Email/Password, Google Sign-In).
  * **📊 Real-time Tracking:** Instantly add and view income (credits) and expenses (debits). Your balance is updated in real-time.
  * **📈 Intuitive Dashboard:** A clean and simple dashboard to visualize your current balance, total income, and total expenses.
  * **🎯 Savings Goals:** Participate in admin-set savings challenges or create your own personal savings goals to build better financial habits.
  * **☁️ Cloud Sync:** All your financial data is securely stored and synced across devices using your unique User ID in Firestore.
  * **📱 Cross-Platform:** A single codebase for both Android and iOS, thanks to Flutter.

-----

## 🛠️ Technologies Used

  * **Frontend:** [Flutter](https://flutter.dev/)
  * **Backend & Database:** [Firebase](https://firebase.google.com/) (Authentication, Firestore)
  * **Language:** [Dart](https://dart.dev/)

-----

## 🚀 Getting Started

Follow these instructions to get a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

  * Flutter SDK: [Flutter Installation Guide](https://flutter.dev/docs/get-started/install)
  * A Firebase project: [Firebase Console](https://console.firebase.google.com/)

### Installation

1.  **Clone the repository:**

    ```sh
    git clone https://github.com/AdityaJandu/FinTrack.git
    cd FinTrack
    ```

2.  **Set up Firebase:**

      * Create a new project on the [Firebase Console](https://console.firebase.google.com/).
      * Add an Android and/or iOS app to your Firebase project.
      * **For Android:** Follow the on-screen instructions to download the `google-services.json` file and place it in the `android/app/` directory.
      * **For iOS:** Follow the instructions to download the `GoogleService-Info.plist` file and place it in the `ios/Runner/` directory using Xcode.
      * Enable **Email/Password Authentication** in the Firebase Authentication tab.
      * Set up **Firestore Database** and update the security rules as needed.

3.  **Install dependencies:**

    ```sh
    flutter pub get
    ```

4.  **Run the application:**

    ```sh
    flutter run
    ```

-----

## 📂 Project Structure

The project follows a standard Flutter project structure:

```
lib/
├── components/              # Reusable UI components like nav bars, cards, icons, text fields, etc.
│   ├── bottom_nav_bar.dart
│   ├── credit_debit_card.dart
│   └── ...
│
├── models/                  # Data models for users, transactions, and challenges
│   ├── challenge.dart
│   ├── transaction_model.dart
│   └── users.dart
│
├── screens/                 # All the main UI screens
│   ├── dash_board.dart
│   ├── home_screen.dart
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── transaction_screen.dart
│   ├── add_transaction_screen.dart
│   ├── update_transaction_screen.dart
│   ├── challenge_screen.dart
│   ├── add_challenge_screen.dart
│   ├── profile_screen.dart
│   └── account_settings_screen.dart
│
├── services/                # Firebase interaction services
│   ├── auth_services.dart
│   ├── transaction_services.dart
│   └── challenge_services.dart
│
├── utils/                   # Utility classes for icons and validators
│   ├── app_icons.dart
│   └── app_validator.dart
│
├── widgets/                 # Smaller reusable widgets like dropdowns, lists, cards, etc.
│   ├── category_dropdown.dart
│   ├── transaction_lists.dart
│   ├── recent_transaction.dart
│   └── ...
│
├── firebase_options.dart    # Firebase configuration file (auto-generated)
└── main.dart                # Application entry point

```

-----

## 🤝 Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request
