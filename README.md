# TheQuad: Premium Life Operating System

**A subscription-free, privacy-first iOS application to balance and track the four critical quadrants of life: Career, Iron, Temple, and Life.**

TheQuad is a native iOS application built with **SwiftUI** and **SwiftData** that acts as a daily command center. Unlike modern productivity apps that rely on expensive cloud subscriptions, TheQuad creates a "Wired Cloud" by storing all media and databases locally on the device, offering professional-grade analytics and media generation without data ever leaving the user's hands.

---

## 📱 Core Features

### 1. The Quad Dashboard
The home screen acts as a daily command center featuring four interactive status cards.
* **Visual Status:** Instantly see which quadrants are pending or "DONE" for the day.
* **Time Travel:** Seamlessly navigate to past dates to view history or edit logs.
* **Modern UI:** Dark mode neon aesthetic optimized for OLED screens.

### 2. Smart Logging & Dynamic Forms
The input system adapts based on the quadrant selected:
* **Iron (Fitness):** Input fields for "Weight Lifted" and "Reps" to track progressive overload.
* **Life (Social):** Includes a "Cookbook" toggle to rate meals (1-5 stars) and save recipes.
* **Media Integration:** Support for uploading photos and videos directly from the library to the local database.

### 3. "Wired Cloud" Architecture
* **100% Local Storage:** All data, photos, and videos are stored in the app's `Documents` directory.
* **iTunes File Sharing:** The iPhone acts as an external drive. Connect to a Mac to drag-and-drop the entire media library for backup or editing.
* **Zero Subscriptions:** No AWS costs, no recurring fees.

### 4. The Reel Generator (Content Studio)
A custom-built video processing engine using `AVFoundation` and `AVKit`.
* **Auto-Stitch:** Takes daily video logs from a selected date range.
* **Smart Trimming:** Automatically identifies video assets, trims them to 2.5-second highlights, and scales them to 9:16 vertical video format.
* **Result:** Exports a ready-to-share "Monthly Recap" video to the Photos app.

### 5. Advanced Analytics
* **Visual Calendar:** A monthly view with color-coded dot indicators showing daily consistency across all four quadrants.
* **Balance Breakdown:** Pie charts visualizing where energy is being spent (e.g., 40% Career, 10% Temple).
* **Batch Export:** A powerful export tool that organizes media into a folder hierarchy (`Quadrant -> Month -> File`) and saves it to the iOS Files app.

---

## 🛠 Technical Stack

* **Language:** Swift 5
* **UI Framework:** SwiftUI
* **Database:** SwiftData (Persistent local storage)
* **Video Engineering:** AVFoundation, AVKit (Composition, Export Sessions, Layer Instructions)
* **Concurrency:** Swift Concurrency (Async/Await)
* **File System:** FileManager (Local document persistence)

---

## 🚀 Getting Started

### Prerequisites
* Mac with Xcode 16+
* iPhone running iOS 17+ (Required for SwiftData)

### Installation
1.  **Clone the repo**
    ```sh
    git clone [https://github.com/yourusername/TheQuad.git](https://github.com/yourusername/TheQuad.git)
    ```
2.  **Open in Xcode**
    * Navigate to the folder and open `TheQuad.xcodeproj`.
3.  **Configure Signing**
    * Go to Project Settings -> Signing & Capabilities.
    * Select your Apple ID / Developer Team.
4.  **Permissions**
    * Ensure `Info.plist` includes permissions for Camera and Photo Library usage.
5.  **Build and Run**
    * Connect your iPhone and press `Cmd + R`.

---

## 📸 Usage Guide

1.  **Log a Win:** Tap a quadrant card (e.g., "Iron") and log your workout with a video.
2.  **Track Progress:** Swipe the calendar to see your consistency streaks.
3.  **Generate a Reel:** Go to the Settings tab, select "Last Month," and tap "Create Monthly Reel." The app will process your clips and save a highlight video to your camera roll.
4.  **Backup Data:** Plug your phone into a computer. Open Finder/iTunes, select your phone, go to "Files," and drag the `TheQuad` folder to your desktop.

---

## 🔒 Privacy

TheQuad was built with a "Privacy First" philosophy.
* **No Tracking:** No analytics SDKs or third-party trackers.
* **No Servers:** Data never leaves the device unless explicitly exported by the user.
* **Sandbox Security:** Media is stored within the app's sandboxed container.

---

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.