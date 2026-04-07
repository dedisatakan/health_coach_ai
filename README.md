# Health Coach AI

A Flutter health & wellness app featuring 4 AI-powered coaches, built as a case study for Connectinno.

## Features

- **4 AI Coaches** — Dietitian, Fitness Coach, Pilates Instructor, Yoga Teacher
- **AI Chat** — Each coach has a unique persona powered by Gemini (Firebase AI Logic)
- **Dynamic Personas** — Coach personalities fetched live from Firebase Remote Config
- **Chat History** — All sessions persisted locally with Hive (NoSQL, zero native deps)
- **Bottom Navigation** — Coaches list and History tab

## Architecture

Feature-based folder structure with strict separation of concerns:
```
lib/
├── core/
│   └── services/
│       ├── hive_service.dart         # Local storage init & box access
│       └── remote_config_service.dart # Firebase Remote Config + coach list
├── features/
│   ├── coaches/
│   │   ├── cubit/                    # CoachesCubit + CoachesState
│   │   ├── data/models/coach.dart    # In-memory Coach model
│   │   └── presentation/             # CoachesPage, _CoachCard
│   ├── chat/
│   │   ├── cubit/                    # ChatCubit + ChatState
│   │   ├── data/models/              # ChatMessage (Hive typeId: 1)
│   │   └── presentation/             # ChatPage, bubbles, input bar
│   └── history/
│       ├── cubit/                    # HistoryCubit + HistoryState
│       ├── data/models/              # ChatSession (Hive typeId: 0)
│       └── presentation/             # HistoryPage
├── app.dart                          # MaterialApp + bottom nav shell
└── main.dart                         # Firebase + Hive init, app entry
```

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter |
| State Management | Cubit (flutter_bloc) |
| AI Backend | Firebase AI Logic (Gemini 2.5 Flash Lite) |
| Dynamic Config | Firebase Remote Config |
| Local Storage | Hive |
| ID Generation | uuid |

## State Management

Three Cubits, each owning one feature slice:

- **CoachesCubit** — loads coaches from Remote Config (`CoachesInitial → CoachesLoading → CoachesLoaded`)
- **ChatCubit** — manages message flow and Firebase AI calls (`ChatInitial → ChatLoaded(isTyping) → ChatLoaded`)
- **HistoryCubit** — reads persisted sessions from Hive (`HistoryInitial → HistoryLoaded`)

## Firebase Setup

- **Firebase AI Logic** — Gemini Developer API (free tier, no Blaze plan required)
- **Remote Config** — 4 string parameters to create in your Firebase project:
  - `dietitian_prompt` — persona for Dr. Ayşe
  - `fitness_coach_prompt` — persona for Coach Mert
  - `pilates_instructor_prompt` — persona for Instructor Selin
  - `yoga_teacher_prompt` — persona for Guru Deniz
- Config files excluded from version control (`.gitignore`)

## Getting Started

```bash
# 1. Clone the repo
git clone https://github.com/dedisatakan/health_coach_ai.git
cd health_coach_ai

# 2. Install dependencies
flutter pub get

# 3. Set up Firebase (requires your own Firebase project)
dart pub global activate flutterfire_cli
flutterfire configure --project=YOUR_PROJECT_ID

# 4. Run
flutter run
```
