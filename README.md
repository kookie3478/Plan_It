# PLAN IT - Shift Management That Works Offline and in Sync With Your Team.

A Flutter-based mobile application designed to help users create, assign, and manage rotating work shifts in a calendar view. This app is ideal for individuals, teams, or workplaces that follow scheduled or recurring shifts. It focuses on simplicity, personalization, and offline persistence using local storage.

---

## Features

### 📅 Interactive Shift Calendar
An intuitive calendar interface built using the `TableCalendar` package allows users to view and manage shifts daily. The calendar provides an easy overview of all assigned shifts and supports interactive selection.

### 🧩 Custom Shift Creation
Users can define their own set of shifts (e.g., Morning, Evening, Night) with custom names and associated colors. This allows full flexibility in tailoring the app to unique work environments.

### 🖌️ Assign Shifts to Dates or Ranges
Shifts can be assigned to single dates or to a continuous range of selected dates. This is especially useful for repeated schedules (e.g., a week of night shifts).

### 💾 Local Storage with SharedPreferences
All shift data — including created shifts and assigned dates — is stored locally using `SharedPreferences`, ensuring persistence even when the app is closed or restarted. No internet connection is required.

### 🔐 Firebase Authentication
Secure user authentication is handled through Firebase, enabling users to sign up, log in, and maintain individual access to their calendar and data.

### 👥 Role-Based Access & Grouping
Users belong to specific groups. Group-based access ensures that only members of the same group can view or interact with each other’s data and applications.

### 📝 Leave Application System
Users can apply for leave directly from the app. These applications can then be reviewed by an admin (or recipient user) from the same group who has the ability to approve or reject them.

### 📂 Done Applications View
Once an application has been approved or rejected, it is automatically moved to a separate “Done Applications” section to keep the dashboard clean and organized.

---

## 🛠️ Tech Stack

### 🧱 Core Framework
- **Flutter** – Cross-platform mobile app development

### 📦 State Management
- **GetX** – Lightweight and powerful for reactive programming and navigation

### 🔐 Authentication
- **Firebase Authentication** – Email/password login system

### 🗂️ Local Data Storage
- **SharedPreferences** – For storing shifts and assignments offline

### 📆 UI Components
- **TableCalendar** – Elegant and customizable calendar widget

### 🌐 Others
- **Firebase Firestore** (for application/approval data only)
- **Material Design** – Clean and native UI experience
