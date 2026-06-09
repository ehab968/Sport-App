# 📱 Sport Mob – Live Sports iOS Application

## 📌 Overview
Sport Mob is a native iOS mobile application that provides a premium sports exploration experience, allowing users to track their favorite sports, leagues, and teams with real-time data updates.

The application allows users to view detailed upcoming and past events, manage favorite teams for offline access, and enjoy a highly dynamic, responsive user interface.

The app is built using the AllSportsAPI and follows the MVP (Model-View-Presenter) architecture pattern.


---

## 📸 Screenshots

### 🏁 1. App Onboarding & Core Flow
| Splash Screen | Onboarding Experience | Sports Exploration |
| --- | --- | --- |
| <img src="https://github.com/user-attachments/assets/f6605240-9d67-440e-8e1f-1b10c2c38303" width="240" alt="Splash Screen"> | <img src="https://github.com/user-attachments/assets/18b258db-cf9c-44a0-8184-3ab473788e2c" width="240" alt="Onboarding Screen"> | <img src="https://github.com/user-attachments/assets/8ffdb3f8-ccf4-4d2f-898d-99e2caeb2742" width="240" alt="Sports Exploration"> |

### 🏆 2. Leagues Management & Dynamic Layouts
| Leagues Tracker | League Search | League Details |
| --- | --- | --- |
| <img src="https://github.com/user-attachments/assets/ce88ef04-0453-400b-a88a-ffa8a30259f2" width="240" alt="Leagues Tracker"> | <img src="https://github.com/user-attachments/assets/0c29c72c-147a-42c2-8a6f-2bb396b745b9" width="240" alt="League Search"> | <img src="https://github.com/user-attachments/assets/cb860dd1-d507-45ff-b96e-67b74c5b076f" width="240" alt="League Details"> |

### 🌐 3. Premium Features & Localization
| Premium Team Profile | Favorite Leagues | Native Arabic Localization |
| --- | --- | --- |
| <img src="https://github.com/user-attachments/assets/9cec9e51-4b5e-4c85-a799-57e574f314d3" width="240" alt="Premium Team Profile"> | <img src="https://github.com/user-attachments/assets/12be4c32-496d-4e55-add5-4a3534182992" width="240" alt="Favorite Leagues"> | <img src="https://github.com/user-attachments/assets/fd59a374-71ec-43fc-b85e-dfdf370925b0" width="240" alt="Arabic Localization"> |

---



## ✨ Features

### ⚽ Sports & Leagues Exploration
- Explore available sports (Football, Basketball, Tennis, Cricket) in a clean, dual-column layout
- Track leagues with a custom TableView featuring circular league badges
- Live data fetching for real-time sports tracking
- Interactive Search Bar to filter leagues instantly

---

### 🏆 Dynamic League & Team Details
- Beautifully structured dashboard split into three distinct compositional zones:
  - **Upcoming Events:** Smooth horizontal scrolling layout
  - **Latest Events:** Vertical list showing live match scores
  - **Teams Showcase:** Interactive circular layout displaying competing teams
- Custom-designed, elegant team detail profiles

---

### ⚙ Premium Experience & Customization
- Premium Dark Theme UI across all screens
- Smooth and engaging Onboarding experience for new users
- Sleek, non-intrusive user alerts powered by Toast
- Save and manage favorite teams/leagues for offline viewing

**Language Support**
- Arabic
- English

---

## 🧱 Architecture
The application follows the MVP (Model-View-Presenter) architecture pattern to ensure:
- Clear separation of concerns and decoupled codebase
- High testability, fully backed by comprehensive Unit Testing
- Scalable and maintainable iOS code

---

## 🛠 Tech Stack & Tools
- Language: Swift
- UI Framework: UIKit (Full Auto Layout constraints)
- Architecture: MVP (Model-View-Presenter)
- Reactive Programming: RxSwift
- Complex Layouts: UICollectionViewCompositionalLayout
- Networking: Alamofire
- Media & Caching: SDWebImage
- Local Storage: Core Data
- User Alerts: Toast
- Unit Testing: Implemented

---

## 🔗 API Used
AllSportsAPI  
https://allsportsapi.com

---

## 👥 Collaboration
This project was developed in collaboration with:
- Mahmoud Aladwy

---

## 🚀 Key Learning Outcomes
- Implementing MVP architecture and creating a fully testable codebase
- Writing comprehensive Unit Tests to validate core business logic
- Managing asynchronous stream handling and reactive data binding using RxSwift
- Building complex, dynamic, and responsive grid layouts with UICollectionViewCompositionalLayout
- Handling robust API routing and requests using Alamofire
- Implementing high-performance, asynchronous image caching with SDWebImage
- Persisting local user data for offline availability using Core Data
- Supporting native multi-language localization (English and Arabic) from the app's core
