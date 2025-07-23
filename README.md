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
    cd fintrack
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
├── components/              # Reusable UI widgets and custom components
│   ├── alert_dialogs.dart
│   ├── back_ground_animations.dart
│   ├── back_ground_blur.dart
│   ├── button_animation.dart
│   ├── curved_bar.dart
│   ├── gradient_text.dart
│   ├── my_buttons.dart
│   ├── my_drawer.dart
│   ├── my_text_fields.dart
│   ├── positioned_image.dart
│   ├── rich_text_span.dart
│   └── widget_tiles.dart
│
├── screens/
│   ├── ai_intergration/     # AI-based features
│   │   ├── image_generate.dart
│   │   └── math_notes.dart
│   │
│   ├── auth/                # Authentication and user management
│   │   ├── auth_gate.dart
│   │   ├── auth_service.dart
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   │
│   ├── core_ui/             # Main UI screens
│   │   ├── feature_screen.dart
│   │   ├── home_screen.dart
│   │   ├── info_screen.dart
│   │   ├── profile_screen.dart
│   │   └── splash_screen.dart
│   │
│   └── gallery_and_camera/  # Media handling screens
│       ├── album_screen.dart
│       ├── camera_screen.dart
│       └── view_picture_screen.dart
│
├── firebase_options.dart    # Firebase configuration
└── main.dart                # App entry point

```

-----

## 🤝 Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request
