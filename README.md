
# Password Manager App - iOS

A secure and user-friendly password manager application built with SwiftUI following the MVVM architecture pattern.

## 📋 Project Overview

This iOS application allows users to securely store and manage their passwords with strong encryption. The app features biometric authentication, password generation, and a clean, intuitive user interface.

## ✨ Features

### Core Functionality
- ✅ **Add Password**: Securely add new passwords with account type, username/email, and password
- ✅ **View Password**: View saved password details with option to show/hide password
- ✅ **Edit Password**: Update existing password information
- ✅ **Delete Password**: Remove passwords with confirmation dialog
- ✅ **Password List**: Home screen displaying all saved passwords with masked passwords

### Security Features
- 🔐 **AES-256 Encryption**: All passwords are encrypted using AES-GCM encryption
- 🔑 **Keychain Storage**: Encryption keys are securely stored in iOS Keychain
- 👤 **Biometric Authentication**: Face ID/Touch ID authentication on app launch
- 🔒 **Secure by Default**: Passwords are masked by default and require explicit action to reveal

### Bonus Features
- 💪 **Password Strength Meter**: Visual indicator showing password strength (Weak/Medium/Strong)
- 🎲 **Password Generator**: Generate strong, random passwords with customizable options:
  - Adjustable length (8-32 characters)
  - Uppercase letters (A-Z)
  - Lowercase letters (a-z)
  - Numbers (0-9)
  - Special characters (!@#$%^&*)
- ✅ **Input Validation**: Ensures all required fields are filled before saving
- ⚠️ **Error Handling**: Graceful error handling with user-friendly messages

## 🏗️ Architecture

### MVVM Pattern
The app follows the Model-View-ViewModel (MVVM) architecture:

```
PasswordMangerApp/
├── Models/
│   └── Password.swift              # Password data model
├── ViewModels/
│   └── PasswordViewModel.swift     # Business logic and data management
├── Views/
│   ├── AuthenticationView.swift    # Biometric authentication screen
│   ├── HomeView.swift              # Password list screen
│   ├── AddPasswordView.swift       # Add new password screen
│   ├── PasswordDetailView.swift    # View/Edit password screen
│   └── PasswordGeneratorView.swift # Password generator screen
├── Services/
│   ├── EncryptionService.swift     # AES encryption service
│   └── BiometricAuthService.swift  # Biometric authentication service
└── Core Data/
    └── PasswordEntity              # Core Data entity
```

## 🔒 Security Implementation

### Encryption
- **Algorithm**: AES-256-GCM (Galois/Counter Mode)
- **Key Storage**: Symmetric keys stored securely in iOS Keychain
- **Key Generation**: Automatic key generation on first launch
- **Data Protection**: All password data encrypted before storage

### Authentication
- **Biometric**: Face ID/Touch ID support
- **Fallback**: Device passcode authentication if biometrics unavailable
- **Auto-trigger**: Authentication required immediately on app launch

### Core Data
- **Secure Storage**: Passwords stored encrypted in SQLite database
- **No Plain Text**: Passwords never stored in plain text
- **Attributes**:
  - `id`: Unique identifier (UUID)
  - `accountType`: Account name (String)
  - `username`: Username/Email (String)
  - `encryptedPassword`: Encrypted password data (Binary)
  - `createdAt`: Creation timestamp (Date)
  - `updatedAt`: Last update timestamp (Date)

## 🚀 Getting Started

### Prerequisites
- Xcode 15.0 or later
- iOS 17.0 or later
- macOS Sonoma or later

### Installation

1. **Clone the repository**:
```bash
git clone <your-repository-url>
cd PasswordMangerApp
```

2. **Open the project in Xcode**:
```bash
open PasswordMangerApp.xcodeproj
```

3. **Configure signing**:
   - Select the project in Xcode
   - Go to "Signing & Capabilities"
   - Select your development team
   - Ensure automatic signing is enabled

4. **Add Face ID Usage Description** (Required for real devices):
   - See [`FACE_ID_SETUP.md`](FACE_ID_SETUP.md) for detailed instructions
   - In Xcode: Target → Info → Add `NSFaceIDUsageDescription` key
   - Value: "We need Face ID to secure your passwords and authenticate access to the app"
   - **Note**: This is required for running on real devices, not needed for simulator

### Running the App

1. **Select a simulator or physical device** in Xcode
2. **Build and run** the project (⌘+R)
3. **Authenticate** using Face ID/Touch ID or device passcode
4. **Start adding passwords** using the "+" button

## 📱 Usage Guide

### Adding a Password
1. Tap the blue "+" button on the home screen
2. Enter the account name (e.g., "Google", "Facebook")
3. Enter your username or email
4. Enter your password or use the password generator
5. View the password strength indicator
6. Tap "Add New Account" to save

### Viewing/Editing a Password
1. Tap any password entry from the list
2. View account details with masked password
3. Tap the eye icon to reveal/hide password
4. Tap "Edit" to modify details
5. Tap "Save" to update or "Cancel" to discard changes

### Deleting a Password
1. Open a password entry
2. Tap the "Delete" button
3. Confirm deletion in the alert dialog

### Generating a Password
1. When adding or editing a password, tap the refresh icon
2. Adjust the length slider (8-32 characters)
3. Toggle character types (uppercase, lowercase, numbers, special)
4. Tap "Generate Password" to create a new one
5. View the strength indicator
6. Tap "Use This Password" to apply it

## 🎨 UI Design

The app follows the provided Figma design with:
- Clean, minimalist interface
- Rounded corners and shadows
- System colors for consistency
- Intuitive navigation
- Accessibility support

## 🧪 Testing

The app includes:
- Preview support for all views
- Sample data in preview mode
- Error handling validation
- Edge case coverage

### Testing Checklist
- [ ] Add password with all fields filled
- [ ] Add password with empty fields (validation)
- [ ] Edit existing password
- [ ] Delete password with confirmation
- [ ] View password with show/hide toggle
- [ ] Generate password with various options
- [ ] Test password strength meter
- [ ] Test biometric authentication
- [ ] Test encryption/decryption

## 📦 Dependencies

### Built-in Frameworks
- **SwiftUI**: UI framework
- **CoreData**: Local database
- **CryptoKit**: Encryption (AES-256-GCM)
- **LocalAuthentication**: Biometric authentication
- **Security**: Keychain access

No external dependencies required! 🎉

## 🔐 Privacy & Security

- ✅ All passwords encrypted with AES-256
- ✅ Encryption keys stored in Keychain
- ✅ Biometric authentication required
- ✅ No network requests (fully offline)
- ✅ No data collection or analytics
- ✅ No third-party services
- ✅ Data stays on device

## 🛠️ Technical Details

### Minimum Requirements
- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

### Core Technologies
- **Language**: Swift
- **UI Framework**: SwiftUI
- **Architecture**: MVVM
- **Database**: Core Data
- **Encryption**: AES-256-GCM via CryptoKit
- **Authentication**: LocalAuthentication Framework

### Performance
- Lightweight app size
- Fast encryption/decryption
- Smooth animations
- Efficient Core Data queries
- Optimized memory usage

## 🤝 Contributing

This is an interview practical project. For production use, consider:
- Adding password categories
- Implementing password sharing
- Adding search functionality
- Supporting password import/export (encrypted)
- Adding password breach checking
- Supporting multiple vaults
- Adding cloud sync (with end-to-end encryption)

## 📄 License

This project is created for interview purposes.

## 👨‍💻 Author

**Aryan kumar Giri**
- Email: aryan7067718303@gmail.com
- Date: January 8, 2026

## 🙏 Acknowledgments

- Figma design provided by the interview team
- Built following iOS security best practices
- Implements modern SwiftUI patterns

---

**Note**: This app demonstrates secure password management following industry best practices for local storage and encryption. For production apps, additional security measures should be considered based on specific requirements.

