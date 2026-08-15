# Shewit 🛍️

**Shewit** is a modern, cross-platform mobile and web e-commerce application built with **Flutter**. It features a clean feature-first architecture, robust state management, and localized data management built to deliver a seamless shopping experience.

---

## 🚀 Features

* **Authentication Module:** Secure user sign-in, login screens, splash flow, and session state management.
* **Product Catalog & Discovery:** Browse products dynamically, view detailed descriptions, filter by categories, and examine rating metrics.
* **Cart & Checkout Workflow:** Full shopping cart capabilities alongside an integrated checkout procedure.
* **Wishlist & Favorites:** Save preferred products for quick access later.
* **User Profile & Settings:** Manage personal configurations, profile data, and preferences.
* **Responsive Multi-Platform Support:** Fully optimized to run natively across Android, iOS, Web, macOS, Linux, and Windows.

---

## 🛠️ Tech Stack & Architecture

* **Framework:** [Flutter](https://flutter.dev/) (Dart)
* **Architecture Style:** Feature-first modular directory structure (`core`, `features`, `shared`)
* **State Management & Data Flow:** Utilizing reactive providers and robust repository patterns (`auth`, `cart`, `products`, `profile`)
* **Network & Serialization:** Integrated data fetching with Dio and automated model generation via Freezed

---

## 📂 Project Structure

```text
Shewit/
├── app/
│   ├── lib/
│   │   ├── core/z
│   │   ├── features/
│   │   ├── shared/ 
│   │   └── main.dart
│   ├── assets/             
│   ├── android/
│   ├── ios/
│   ├── web/
│   ├── windows/
│   ├── macos/
│   ├── linux/               
│   └── pubspec.yaml        
