# 📱 SSCE Prep Pro

<p align="center">
  <img src="assets/app_icon.png" alt="SSCE Prep Pro Logo" width="120" height="120" style="border-radius: 20px"/>
</p>

<p align="center">
  <strong>Offline Android exam preparation app for SSCE candidates</strong><br/>
  Built with Flutter • Powered by Hive • 1,080+ Questions
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white"/>
  <img src="https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white"/>
  <img src="https://img.shields.io/badge/Platform-Android-3DDC84?style=for-the-badge&logo=android&logoColor=white"/>
  <img src="https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge"/>
</p>

---

## 📖 About

**SSCE Prep Pro** is a fully offline Android mobile application designed to help Nigerian Senior Secondary School Certificate Examination (SSCE) candidates prepare effectively for their WAEC and NECO examinations.

The app provides access to over **1,080 past questions** spanning **12 subjects** across Science, Art, and Commercial departments — all available without an internet connection.

---

## ✨ Features

- 📚 **1,080+ Objective Questions** from 2020–2025 across 12 subjects
- 📝 **82 Theory Questions** with full model answers
- ⏱️ **Timed Quiz Mode** — 30 seconds per question, 20 questions per session
- 🔀 **Randomised Questions** — different questions every session
- 📅 **Year Filter** — study questions by specific exam year (2020–2025)
- 📊 **Progress Tracking** — monitor your performance over time
- 🌙 **Fully Offline** — no internet connection required
- 🎨 **Clean Modern UI** — intuitive and student-friendly interface
- 📱 **Onboarding Flow** — guided introduction for first-time users
- 🏆 **Quiz Results Screen** — detailed score and performance breakdown

---

## 📚 Subjects Covered

| Department | Subjects |
|------------|----------|
| 🔬 **Science** | Mathematics, Physics, Chemistry, Biology |
| 🎨 **Art** | English Language, Literature in English, Government, CRS, IRS |
| 📊 **Commercial** | Economics, Commerce, Accounting |

---

## 🛠️ Tech Stack

| Technology | Purpose |
|------------|---------|
| **Flutter** | Cross-platform UI framework |
| **Dart** | Programming language |
| **Hive** | Lightweight offline NoSQL database |
| **JSON** | Question data storage and loading |
| **flutter_launcher_icons** | Custom app icon generation |
| **flutter_native_splash** | Custom splash screen |

---

## 🏗️ Project Architecture

The app follows a **feature-first architecture** for clean separation of concerns:

```
lib/
├── main.dart
└── src/
    ├── app/
    │   ├── app.dart
    │   └── app_bottom_nav_bar.dart
    ├── core/
    │   ├── database/
    │   │   └── database_service.dart
    │   └── theme/
    │       └── app_theme.dart
    └── features/
        ├── home/
        ├── departments/
        ├── quiz/
        ├── progress/
        └── onboarding/
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.x or higher
- Dart SDK 3.x or higher
- Android Studio or VS Code
- Android device or emulator (API 21+)

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/Emmytee-Oye/ssce-prep-pro.git
cd ssce-prep-pro
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
flutter run
```

4. **Build release APK**
```bash
flutter build apk --release
```

The APK will be generated at:
```
build/app/outputs/flutter-apk/app-release.apk
```

---

## 📁 Question Data Structure

Questions are stored as JSON files in `assets/questions/`. Each file follows this structure:

**Objective questions:**
```json
{
  "subject": "Mathematics",
  "questions": [
    {
      "question": "Question text here?",
      "options": ["Option A", "Option B", "Option C", "Option D"],
      "correctIndex": 0,
      "year": 2024
    }
  ]
}
```

**Theory questions:**
```json
{
  "subject": "Physics",
  "questions": [
    {
      "question": "Theory question here?",
      "answer": "Detailed model answer here...",
      "year": 2024
    }
  ]
}
```

---

## 📊 Questions Database

| Subject | Objective | Theory |
|---------|-----------|--------|
| Mathematics | 187 | 10 |
| Physics | 113 | 12 |
| Chemistry | 104 | 11 |
| Biology | 100 | 8 |
| English Language | 77 | 5 |
| Government | 97 | 7 |
| Literature in English | 65 | 5 |
| CRS | 71 | 5 |
| IRS | 56 | 5 |
| Economics | 77 | 6 |
| Commerce | 71 | 5 |
| Accounting | 62 | 5 |
| **Total** | **1,080** | **84** |

---

## 🎨 Design System

| Element | Value |
|---------|-------|
| Primary Colour | `#2D4A8A` (Deep Blue) |
| Accent Colour | `#F5A623` (Orange) |
| Font | System default (Material) |
| Min SDK | Android 5.0 (API 21) |

---

## 🔮 Future Improvements

- [ ] CBT (Computer Based Test) simulation mode
- [ ] Cloud sync and backup via Firebase
- [ ] AI-powered performance analytics
- [ ] Push notifications for daily study reminders
- [ ] Leaderboard and gamification features
- [ ] iOS version
- [ ] Support for more subjects and exam years
- [ ] Dark mode

---

## 👨‍💻 Developer

**Oyetayo Emmanuel Temitope**  
📧 oyetayoemmanueltemitope705@gmail.com  
🐙 [@Emmytee-Oye](https://github.com/Emmytee-Oye)

---



---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

