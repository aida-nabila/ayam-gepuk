# Ayam Gepuk Restaurant Package Menu Booking App

<div style="display: flex; justify-content: space-around; gap: 10px; flex-wrap: wrap;">
  <img src="https://github.com/user-attachments/assets/7e8b1110-b9a3-470e-9d7c-60acd90fbcc7" width="200px" />
  <img src="https://github.com/user-attachments/assets/22553a77-312b-4a8d-a8ee-b6cfe6721b96" width="200px" />
  <img src="https://github.com/user-attachments/assets/c01c9edd-92ce-4a1c-85e3-4d82ddd441a8" width="200px" />
  <img src="https://github.com/user-attachments/assets/0f2166c0-f16e-4571-b3d7-f83350bb3225" width="200px" />
</div>

## About

> The Ayam Gepuk Restaurant Package Menu Booking App is a mobile application developed using Flutter and Sqflite. This app is designed to allow customers to browse menu items, customize their orders, and book event packages offered by Ayam Gepuk restaurant. The app provides a simple and seamless way to place food orders and schedule reservations.

---

## Features
- **User Authentication**: Sign-up, login, and manage accounts securely
- **Menu Browsing**: Explore various menu items such as chicken, fish, and drinks
- **Order Management**: Add items to the cart, adjust quantities, and view order details
- **Booking System**: Choose a package, set event details (date, time, number of guests), and confirm the booking
- **Admin Management**: Manage user orders, bookings, and menu items

---

## Tech Stack

| **Category**             | **Technology**             | **Purpose**                                        |
|--------------------------|----------------------------|----------------------------------------------------|
| **Programming Language** | Dart (Flutter)             | Cross-platform mobile app development             |
| **Mobile Framework**     | Flutter                    | Framework for building the app                    |
| **Database**             | Sqflite (Local Storage)    | Stores orders, bookings, and menu items locally   |

---

## Installation & Setup

### **Prerequisites**
- Flutter SDK
- Android Studio/VSCode or any preferred IDE
- Sqflite Database: Local SQLite database for storing data

### **Steps to Set Up**
1. **Clone the Repository**

   ```sh
   git clone https://github.com/aida-nabila/ayam-gepuk.git
   cd ayam-gepuk
   
2. **Install Dependencies**
  - Run `flutter pub get` to install necessary dependencies

3. **Set Up Sqflite Database**
  - The app uses Sqflite for local storage. No cloud setup is required
  - The database is created locally on the device, and no additional configuration is needed
    
4. **Run the app on your emulator or device using the command:** <br>
`flutter run`

5. **Access the System** <br>
Open the app on your device or emulator and test the user registration, menu browsing, and event booking features

## Future Improvements 
Here are some planned enhancements for the Ayam Gepuk Restaurant Package Menu Booking App:

- **Firebase Integration** – Transition from Sqflite to Firebase Firestore for cloud-based data management
