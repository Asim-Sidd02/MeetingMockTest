# 📹 Flutter Video Session App

A modern **2-screen Flutter application** demonstrating **Firestore integration, GetX state management, real-time camera video interface, permission handling, and session lifecycle tracking**.

This project is designed to be **demo-safe**, **multi-run stable**, and **interview-ready**.

---

## ✨ Features

### 🗓 Screen 1 – Appointments
- Fetches sessions from **Firebase Firestore**
- Displays **Upcoming / Ongoing Sessions**
- “Join Session” button for each session
- Automatic session seeding for demo stability
- Camera & Microphone permission handling

### 📞 Screen 2 – Video Call Interface
- Real **camera preview** using device camera
- **Camera rotation** (front ↔ back)
- **Real-time stopwatch** tracking session duration
- Modern, clean UI
- “End Call” button to complete the session

### 🔥 Firestore Integration
- On **Join Session** → status updated to `ongoing`
- On **End Call** → status updated to `completed`
- Session duration saved in seconds
- Start & end timestamps recorded

---

## 🧠 Tech Stack

- **Flutter** (Material 3 UI)
- **GetX** – State management & navigation
- **Firebase Firestore** – Backend database
- **Camera Plugin** – Real camera preview
- **Permission Handler** – Runtime permissions

---

## 📂 Project Structure

```
lib/
 ├── controllers/
 │    └── session_controller.dart
 │
 ├── screens/
 │    ├── appointments_screen.dart
 │    └── video_call_screen.dart
 │
 ├── firebase_options.dart
 └── main.dart
```

---

## 🗄 Firestore Data Model

```
sessions {
  title: string
  status: "upcoming" | "ongoing" | "completed"
  duration: number
  startTime: timestamp
  endTime: timestamp
}
```

---

## 🔐 Permissions Used

### Android
```
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
```

Permissions are requested **at runtime** when joining a session.

---

## 🚀 How It Works (Flow)

1. App launches and checks for active sessions
2. If none exist, a session is auto-created (demo mode)
3. User taps **Join**
4. Camera & microphone permissions are requested
5. Session status updated to `ongoing`
6. Video call screen opens with live camera preview
7. Stopwatch starts automatically
8. User taps **End Call**
9. Session marked as `completed`
10. Duration saved to Firestore

---

## 🧪 Demo Stability (Multi-Run Safe)

To ensure sessions always appear:
- If no `upcoming` or `ongoing` sessions exist, the app automatically creates one.
- This prevents empty screens on subsequent runs.

---

## 🛠 Setup Instructions

### 1️⃣ Install Dependencies
```
flutter pub get
```

### 2️⃣ Firebase Setup
- Create a Firebase project
- Enable **Cloud Firestore**
- Initialize Firebase using `firebase_options.dart`
- Start Firestore in **test mode** (for development)

### 3️⃣ Run the App
```
flutter run
```

---

## ⚠️ Notes

- This app uses a **real camera preview**, not a mock UI.
- Firestore rules are assumed to be open for development.
- API keys are safe for client usage; security is enforced via Firestore rules.




## 👤 Author

- **Asim Siddiqui**
- **Contact Information**
  - Email: asimsiddiqui8181@gmail.com
  - LinkedIn: [Asim Siddiqui](https://www.linkedin.com/in/asim-siddiqui-a71731229/)
  - Portfolio: [Asim Sidd](https://asimsidd.vercel.app/)
