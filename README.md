# IdeaShare — Startup Idea Evaluator

A refined, well-structured Flutter application for capturing, sharing, and evaluating startup ideas. IdeaShare presents a polished interface, thoughtful animations, and robust local persistence so users can submit ideas, receive an AI-derived viability score, and vote on submissions — all with a calm, premium experience.

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [Key Features](#key-features)
3. [Getting Started](#getting-started)
4. [Project Structure](#project-structure)
5. [Assets](#assets)
6. [Theming & UI Notes](#theming--ui-notes)
7. [State Management & Persistence](#state-management--persistence)
8. [Screens](#screens)
9. [Usage Examples](#usage-examples)
10. [Screenshots & Video](#screenshots--video)
11. [Contributing](#contributing)
12. [License](#license)

---

## Project Overview

IdeaShare is designed for clarity and focus. It blends a minimalist visual language with subtle motion — animated backgrounds, staggered list reveals, and elegant card flip transitions — while maintaining a disciplined codebase based on BLoC. The application stores data locally so the experience is uninterrupted and private.

---

## Key Features

* **BLoC State Management** — Clear separation of UI and business logic for testability and scalability.
* **Dual Themes** — A clean Light theme and a refined Dark theme (user preference persisted).
* **Interactive Idea Cards**

  * Tap or swipe to flip and view score breakdown.
  * Only one card may be flipped at once.
  * Animated upvote/downvote with live vote count updates.
* **Local Persistence** — Ideas and votes persisted via `shared_preferences`.
* **Polished Animations** — Animated backgrounds, hero transitions, and staggered entry animations.
* **Onboarding** — One-time guided overlay for first-time users.

---

## Getting Started

### Prerequisites

* Flutter SDK 3.0.0 or higher
* Android Studio or VS Code with Flutter plugin

### Installation

```bash
git clone <your-repository-url>
cd startup_idea_evaluator
flutter pub get
flutter run
```

---

## Project Structure

```
lib/
├── data/
│   ├── models/           # idea_model.dart
│   └── sources/          # local_cache.dart
├── logic/
│   ├── idea_bloc/        # idea_bloc.dart, idea_event.dart, idea_state.dart
│   └── theme_notifier.dart
├── presentation/
│   ├── screens/          # listing, submission, leaderboard
│   └── widgets/          # idea_card, animated_background, app_drawer
├── utils/
│   └── vote_store.dart   # vote management helper
└── main.dart
```

---

## Assets

Ensure the following images are placed in the `assets/` folder and declared in `pubspec.yaml`.

**Files (all `.jpg`)**

* `assets/l1.jpg`
* `assets/l2.jpg`
* `assets/l3.jpg`
* `assets/l4.jpg`
* `assets/l11.jpg` (main light image)
* `assets/d1.jpg`
* `assets/d2.jpg`
* `assets/d3.jpg`
* `assets/d4.jpg`
* `assets/d11.jpg` (main dark image)

**`pubspec.yaml` snippet**

```yaml
flutter:
  assets:
    - assets/l1.jpg
    - assets/l2.jpg
    - assets/l3.jpg
    - assets/l4.jpg
    - assets/l11.jpg
    - assets/d1.jpg
    - assets/d2.jpg
    - assets/d3.jpg
    - assets/d4.jpg
    - assets/d11.jpg
```

**Use in Dart**

```dart
final imageAsset = isDarkMode ? 'assets/d11.jpg' : 'assets/l11.jpg';
return Image.asset(imageAsset, fit: BoxFit.cover);
```

---

## Theming & UI Notes

* **Light Theme**: White base with restrained blues and neutral greys for hierarchy.
* **Dark Theme**: Deep black with muted light-blue accents for a premium feel.
* **Animated Background**: Implement as a reusable widget that renders subtle, animated gradients. Keep saturation low and transitions smooth for a composed appearance.

---

## State Management & Persistence

* BLoC files live under `lib/logic/idea_bloc/`.
* `shared_preferences` stores:

  * Serialized idea list
  * Per-user vote map
  * Theme preference
  * Onboarding completion flag

**Persistence pattern**

1. On app start, read cached ideas and votes.
2. Hydrate BLoC state with persisted data.
3. On change (new idea, vote), update the cache asynchronously and emit updated BLoC state.

---

## Screens

* **Listing Screen** — Displays all ideas (staggered reveal animations).
* **Submission Screen** — Animated, validated form for new ideas.
* **Leaderboard Screen** — Ordered by votes and AI-derived score.
* **Drawer / Settings** — Theme toggle, onboarding replay.

---

## Usage Examples

### Flip card logic

* Keep a single `flippedIdeaId` in the `IdeaBloc` state.
* Flipping sets `flippedIdeaId = ideaId`; tapping a different card replaces it.
* Tapping a flipped card again clears the `flippedIdeaId`.

### Vote action

* Maintain a `Map<String, VoteState>` in local storage keyed by idea id.
* On upvote/downvote:

  1. Optimistically update BLoC state (triggers UI animation).
  2. Persist vote change to `shared_preferences`.
  3. On failure, revert the change and show subtle feedback.

---

## Screenshots & Video

Replace placeholders with project assets. The demo video link is included below.

**Screenshots**

|    Light Mode    |     Dark Mode    |
| :--------------: | :--------------: |
| `assets/l11.jpg` | `assets/d11.jpg` |

| Listing Screen (Light) | Listing Screen (Dark) |
| :--------------------: | :-------------------: |
|     `assets/l1.jpg`    |    `assets/d1.jpg`    |

| Flipped Card (Light) | Flipped Card (Dark) |
| :------------------: | :-----------------: |
|    `assets/l2.jpg`   |   `assets/d2.jpg`   |

**Video Demo**

IdeaShare Demo Video: [https://drive.google.com/file/d/1hYEG70ylsR4o45SWZkO7tuv0COphH4RT/view?usp=drivesdk](https://drive.google.com/file/d/1hYEG70ylsR4o45SWZkO7tuv0COphH4RT/view?usp=drivesdk)

---

## Contributing

1. Fork the repository.
2. Create a feature branch: `git checkout -b feature/your-feature`.
3. Commit changes with clear messages.
4. Open a pull request with a detailed description and screenshots where appropriate.

---

## License

This project is licensed under the MIT License. See `LICENSE.md` for details.

---

*Prepared for publication — replace placeholders (repo URL, screenshots, video link, license) with real assets before release.*
