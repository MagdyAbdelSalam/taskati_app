🚀 Taskati – Smart To-Do App

Modern, clean, and scalable To-Do application built with Flutter following real-world architecture practices.

👨‍💻 Developer

Mohamed Magdy
Flutter Developer (Learning & Building Real Projects)

📱 Overview

Taskati is a production-structured task management app focused on:

Clean Architecture

Scalable feature-based structure

Smooth animations

Local persistence

Modern UI with Dark Mode support

This project reflects my practical learning journey in Flutter while applying professional development standards.

✨ Key Features

Add / Delete / Complete tasks

Swipe gestures (Left → Delete, Right → Complete)

Task filtering (All – To Do – Completed)

Date selection (No past dates allowed)

Time validation (Start time < End time)

Profile editing (Name & Image)

Dark Mode with instant toggle

Persistent local storage using Hive

Animated task list & empty states

🏗 Architecture

Feature-based Clean Architecture structure:

lib/
 ├── core/
 └── features/
     ├── splash/
     ├── auth/
     ├── home/
     ├── add_task/
     └── profile/

Layers:

UI Layer (Screens & Widgets)

State Management (Cubit – flutter_bloc)

Data Layer (Hive Models & Repositories)

🛠 Tech Stack

Flutter

flutter_bloc (Cubit)

Hive (Local Database)

image_picker

flutter_screenutil

intl

google_fonts

🎨 UI Highlights

Responsive design

Smooth insert/delete animations

Clean minimal interface

Color-coded tasks

Global light & dark theme

📈 Future Improvements

Task editing

Productivity statistics

Notifications

Cloud sync

Localization

⭐ Project Goal

To build a real-world structured Flutter application while mastering:

State management

Clean architecture

Local storage

Form & time validation

Theme handling

Scalable project organization
