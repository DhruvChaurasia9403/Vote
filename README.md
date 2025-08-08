# IdeaShare: Startup Idea Evaluator

## Project Overview

IdeaShare is a dynamic and interactive Flutter application designed for brainstorming, sharing, and evaluating startup ideas. It provides a platform for users to submit their concepts, receive an AI-generated viability score, and vote on other submissions. The app features a clean, minimalist user interface with distinct light and dark themes, engaging animations, and persistent local storage to ensure a seamless user experience.

The application is built using modern Flutter practices, with a focus on clean architecture, state management using BLoC, and a highly interactive, animated UI.

---

## Features

- **State Management**: Utilizes the BLoC (Business Logic Component) pattern for robust and scalable state management, ensuring a clean separation between UI and business logic.
- **Dynamic Theming**: Switch between a clean White/Blue/Grey light theme and a sleek Black/Light Blue dark theme. The user's preference is saved locally and persists across app launches.
- **Interactive Idea Cards**:
    - **Flip Animation**: Tap the AI score or swipe horizontally on an idea card to flip it over and view a detailed score breakdown.
    - **Single Flipped Card**: The application ensures only one card can be in a flipped state at any given time, providing a clean and focused user experience.
    - **Upvote/Downvote System**: Users can cast or retract their vote on any idea. The vote count updates in real-time with a satisfying animation.
- **Local Data Persistence**: All ideas and user votes are saved locally on the device using `shared_preferences`, ensuring data is retained between sessions.
- **Engaging UI & Animations**:
    - **Animated Backgrounds**: Subtle, constantly shifting gradients on every screen provide a dynamic and premium feel.
    - **Staggered List Animations**: Lists of ideas and leaderboard entries animate into view gracefully.
    - **Hero Animations**: Smooth transitions for key UI elements.
- **User Onboarding**: A one-time tutorial overlay guides new users, highlighting the main navigation and action buttons.
- **Core Screens**:
    - **Listing Screen**: Displays all submitted ideas.
    - **Submission Screen**: A modern, animated form for submitting new ideas.
    - **Leaderboard Screen**: Ranks the top-voted ideas with a distinct visual hierarchy.
    - **Navigation Drawer**: Provides easy access to all app sections and the theme switcher.

---

## Getting Started

### Prerequisites

- Flutter SDK (Version 3.0.0 or higher)
- An IDE such as Android Studio or VS Code with the Flutter plugin.

### Installation

1.  **Clone the repository:**
    ```sh
    git clone <your-repository-url>
    ```
2.  **Navigate to the project directory:**
    ```sh
    cd startup_idea_evaluator
    ```
3.  **Install dependencies:**
    ```sh
    flutter pub get
    ```
4.  **Run the application:**
    ```sh
    flutter run
    ```

---

## Project Structure

The project follows a clean architecture, separating concerns into distinct layers.

```
lib/
├── data/
│   ├── models/           # Contains the data models (e.g., idea_model.dart)
│   └── sources/          # Handles data persistence (e.g., local_cache.dart)
├── logic/
│   ├── idea_bloc/        # BLoC files for state management (bloc, event, state)
│   └── theme_notifier.dart # Manages the application's theme state
├── presentation/
│   ├── screens/          # All the main screens of the application
│   └── widgets/          # Reusable widgets (e.g., idea_cards, app_drawer)
├── utils/
│   └── vote_store.dart   # Utility for managing user vote data
└── main.dart             # The main entry point of the application
```

---

## Screenshots

*(Please replace the placeholder text below with your actual screenshots)*

| Light Mode | Dark Mode |
| :---: | :---: |
| <img src="[Insert Light Mode Listing Screen Screenshot Here]" width="300"> | <img src="[Insert Dark Mode Listing Screen Screenshot Here]" width="300"> |
| *Listing Screen (Light)* | *Listing Screen (Dark)* |
| <img src="[Insert Light Mode Card Back Screenshot Here]" width="300"> | <img src="[Insert Dark Mode Card Back Screenshot Here]" width="300"> |
| *Flipped Card (Light)* | *Flipped Card (Dark)* |
| <img src="[Insert Light Mode Submission Screen Screenshot Here]" width="300"> | <img src="[Insert Dark Mode Submission Screen Screenshot Here]" width="300"> |
| *Submission Screen (Light)* | *Submission Screen (Dark)* |

---

## Video Demo

A full video walkthrough of the application's features and animations can be found at the link below.

**[Insert Your Google Drive or YouTube Video Link Here]**
