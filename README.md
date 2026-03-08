# 📱 SSCE Prep Pro

<p align="center">
  <img src="assets/app_icon.png" alt="SSCE Prep Pro Logo" width="120" height="120"/>
</p>

<p align="center">
  <strong>Offline Android Exam Preparation App for SSCE Candidates</strong><br/>
  <em>Study Smart. Pass Bright.</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.0+-02569B?style=for-the-badge&logo=flutter&logoColor=white"/>
  <img src="https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart&logoColor=white"/>
  <img src="https://img.shields.io/badge/Android-5.0+-3DDC84?style=for-the-badge&logo=android&logoColor=white"/>
  <img src="https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge"/>
</p>

---

## About

**SSCE Prep Pro** is a fully offline Android mobile application designed to help Senior Secondary School Certificate Examination (SSCE) candidates in Nigeria prepare effectively for their WAEC and NECO examinations.

The app provides **1,080+ past questions** (2020–2025) across **12 subjects** in Science, Art, and Commercial departments — all available without an internet connection.

---

## Features

-  **Study Mode** — Browse objective questions by subject and filter by year (2020–2025)
-  **Theory Mode** — Study detailed model answers for essay/theory questions
-  **Timed Quiz** — 20 random questions with 30-second timer per question
-  **Progress Tracking** — Track quiz scores and study history
-  **Smart Shuffle** — Questions randomised on every session for varied practice
-  **Fully Offline** — No internet connection required at any time
-  **Clean UI** — Modern, student-friendly interface with department colour coding
-  **Onboarding** — Guided introduction for first-time users

---

## 📚 Subjects Covered

| Department | Subjects |
|---|---|
|  **Science** | Mathematics, Physics, Chemistry, Biology |
|  **Art** | English Language, Literature, Government, CRS, IRS |
|  **Commercial** | Economics, Commerce, Accounting |

### Question Statistics

| Subject | Objective | Theory |
|---|---|---|
| Mathematics | 187 | 10 |
| Physics | 113 | 12 |
| Chemistry | 104 | 11 |
| Biology | 100 | 8 |
| English Language | 77 | 5 |
| Government | 97 | 7 |
| Literature | 65 | 5 |
| CRS | 71 | 5 |
| IRS | 56 | 5 |
| Economics | 77 | 6 |
| Commerce | 71 | 5 |
| Accounting | 62 | 5 |
| **Total** | **1,080** | **84** |

---

##  Tech Stack

| Technology | Purpose |
|---|---|
| **Flutter 3.0+** | Cross-platform UI framework |
| **Dart 3.0+** | Programming language |
| **Hive** | Lightweight offline NoSQL database |
| **JSON** | Question storage and loading |
| **Flutter Native Splash** | Custom splash screen |
| **Flutter Launcher Icons** | Custom app icon |

### Architecture
- **Feature-first** folder structure
- **Service layer** for question loading with caching
- **Hive database** for progress persistence
- **Stateful widgets** with clean separation of concerns

---

## Project Structure

```
lib/
└── src/
    ├── app/                          # App entry, bottom navigation
    ├── core/
    │   ├── database/                 # Hive database service
    │   └── theme/                    # AppColors, AppTheme
    └── features/
        ├── home/                     # Home screen with department chips
        ├── onboarding/               # 4-slide onboarding flow
        ├── departments/              # Department, subject, study mode screens
        ├── quiz/                     # Quiz engine, results, study screens
        └── progress/                 # Progress tracking screen

assets/
└── questions/                        # 24 JSON question files (12 subjects × 2)
```

---

##  Getting Started

### Prerequisites
- Flutter SDK 3.0 or higher
- Dart SDK 3.0 or higher
- Android Studio or VS Code
- Android device or emulator (Android 5.0+)

### Installation

1. **Clone the repository:**
```bash
git clone https://github.com/Emmytee-Oye/ssce-prep-pro.git
cd ssce-prep-pro
```

2. **Install dependencies:**
```bash
flutter pub get
```

3. **Run the app:**
```bash
flutter run
```

4. **Build release APK:**
```bash
flutter build apk --release --split-per-abi
```

---

##  Download

| Version | APK | Compatible With |
|---|---|---|
| v1.0.0 | [Download APK](#) | Android 5.0+ (API 21+) |

> ⚠️ **Installation Note:** Since this app is not on the Play Store, you may need to enable **"Install from Unknown Sources"** in your phone settings.

---
---

## Roadmap

- [ ] Add questions for 2026 exams
- [ ] CBT simulation mode (full exam timer)
- [ ] AI-powered performance analytics
- [ ] Leaderboard and gamification
- [ ] Cloud sync and backup
- [ ] iOS version
- [ ] Past question PDF downloads

---

##  Developer

**Oyetayo Emmanuel Temitope**
📧 oyetayoemmanueltemitope705@gmail.com
🐙 [@Emmytee-Oye](https://github.com/Emmytee-Oye)

---

##  Acknowledgements

- **Flutter Team** — For the amazing framework
- **Hive** — For lightweight offline storage
- All student testers who provided valuable feedback

---

##  License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

<p align="center">Made with ❤️ in Ilorin, Nigeria 🇳🇬</p>
