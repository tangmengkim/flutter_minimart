# MiniStore - Mobile E-Commerce Application

A comprehensive Flutter-based mini e-commerce mobile application designed for seamless shopping experiences on mobile devices. This application provides a complete shopping solution with modern UI/UX design and essential e-commerce functionalities.

## 📱 About This Project

**MiniStore** is a mobile application assignment developed as part of our academic curriculum. The app demonstrates modern mobile development practices using Flutter framework and showcases essential e-commerce features including product browsing, shopping cart management, and secure checkout processes.

### 👥 Development Team

**Developers:**
- **Hak Layheang** | ID: B20235881
- **Tang Mengkim** | ID: B20231674  
- **Sung Sovannsak** | ID: B20231056
- **Ung Sereyvatana** | ID: B20240815

**Submitted to:** Lecturer Oum Saokosal

---

## ✨ Key Features

### 🛍️ Shopping Experience
- **Product Browsing**: Intuitive product catalog with detailed views
- **Smart Search**: Find products quickly with advanced search functionality
- **Shopping Cart**: Add, remove, and manage items in your cart
- **Secure Checkout**: Complete purchase process with secure payment handling
- **Order History**: Track your past orders and purchase history

### 🎨 User Interface
- **Responsive Design**: Optimized for various mobile screen sizes
- **Modern UI**: Clean, intuitive interface following Material Design principles
- **Dark/Light Theme**: Customizable theme preferences
- **Smooth Animations**: Enhanced user experience with fluid transitions
- **Offline Support**: Cached content for better performance

### 🔧 Technical Features
- **Network Caching**: Efficient image and data caching with `cached_network_image`
- **State Management**: Robust state management using `provider`
- **Secure Storage**: Safe data storage with `flutter_secure_storage`
- **API Integration**: RESTful API communication with `dio` and `retrofit`
- **Share Functionality**: Share products with friends using `share_plus`
- **Interactive UI**: Swipe-to-delete functionality with `flutter_slidable`

---

## 🏗️ Project Structure

```
ministore/
├── lib/
│   ├── dio/
│   │   └── baseDio.dart                    # API base configuration
│   │
│   ├── models/                             # Data models and entities
│   │   └── [model files]
│   │
│   ├── provider/                           # State management providers
│   │   ├── auth_provider.dart             # Authentication state
│   │   ├── cart_provider.dart             # Shopping cart state
│   │   └── product_provider.dart          # Product data state
│   │
│   ├── services/                           # API service layer
│   │   ├── auth_service.dart              # Authentication API calls
│   │   ├── categories_service.dart        # Categories API calls
│   │   ├── product_service.dart           # Product API calls
│   │   ├── sale_service.dart              # Sales/orders API calls
│   │   ├── section_service.dart           # Section API calls
│   │   ├── shelves_service.dart           # Shelves API calls
│   │
│   ├── util/                               # Utility functions and helpers
│   │   ├── data.dart                      # Data constants and configurations
│   │   ├── helper.dart                    # Helper functions
│   │   ├── provider.dart                  # Provider configurations
│   │   └── theme.dart                     # Theme configurations
│   │
│   ├── views/                              # UI screens and pages
│   │   ├── auth/                          # Authentication screens
│   │   │   ├── change_password.dart       # Change password screen
│   │   │   ├── forgot_password.dart       # Forgot password screen
│   │   │   └── login.dart                 # Login screen
│   │   │
│   │   ├── home/                          # Home and main screens
│   │   │   ├── cart_page.dart             # Shopping cart screen
│   │   │   ├── checkout_page.dart         # Checkout process screen
│   │   │   ├── custom_bottom_appBar.dart  # Custom bottom navigation
│   │   │   ├── home_page.dart             # Main home screen
│   │   │   ├── invoice_page.dart          # Invoice/receipt screen
│   │   │   └── page_view_controller.dart  # Page navigation controller
│   │   │
│   │   ├── product/                       # Product-related screens
│   │   │   └── product_form_page.dart     # Product details/form screen
│   │   │
│   │   └── profile/                       # User profile screens
│   │       └── profile_page.dart          # User profile screen
│   │
│   ├── widgets/                            # Reusable UI components
│   │   ├── customTextField.dart           # Custom text input field
│   │   ├── product_detail_bottomSheet.dart # Product details bottom sheet
│   │   └── section_popup_widget.dart     # Section popup component
│   │
│   ├── main.dart                          # Application entry point
│   └── route_page.dart                    # Route configuration
│
├── assets/
│   └── images/                            # Image assets
│       └── [image files]
│
├── android/                               # Android-specific configuration
│   ├── app/
│   │   ├── build.gradle                   # Android build configuration
│   │   └── src/
│   └── gradle/
│
├── ios/                                   # iOS-specific configuration
│   ├── Runner/
│   │   ├── Info.plist                     # iOS app configuration
│   │   └── [iOS files]
│   └── [iOS configuration files]
│
├── test/                                  # Unit and widget tests
│   └── [test files]
│
├── pubspec.yaml                           # Dependencies and project configuration
├── pubspec.lock                           # Dependency lock file
├── analysis_options.yaml                 # Code analysis configuration
├── README.md                              # Project documentation
└── LICENSE                                # License file
```

### 📁 Directory Descriptions

#### **`lib/dio/`**
Contains API configuration and base setup for HTTP client using Dio package.

#### **`lib/models/`**
Data models and entity classes that represent the structure of data used throughout the application.

#### **`lib/provider/`**
State management layer using Provider pattern:
- **Authentication Provider**: Manages user authentication state
- **Cart Provider**: Handles shopping cart operations and state
- **Product Provider**: Manages product data and operations

#### **`lib/services/`**
API service layer with Retrofit integration:
- **Service Files**: Define API endpoints and methods
- **Generated Files (.g.dart)**: Auto-generated code for API clients
- Handles all backend communication for different app modules

#### **`lib/util/`**
Utility functions and configurations:
- **Data**: Constants and configuration data
- **Helper**: Common utility functions
- **Provider**: Provider setup and configuration
- **Theme**: App theming and styling configurations

#### **`lib/views/`**
UI screens organized by feature modules:
- **Auth**: Authentication-related screens (login, password management)
- **Home**: Main app screens (home, cart, checkout)
- **Product**: Product-specific screens
- **Profile**: User profile and account screens

#### **`lib/widgets/`**
Reusable UI components and custom widgets used across multiple screens.

### 🔄 Code Generation

The project uses code generation for:
- **JSON Serialization**: Automatic model serialization/deserialization
- **API Clients**: Type-safe HTTP client generation with Retrofit
- **Build Command**: `flutter pub run build_runner build --delete-conflicting-outputs`

---

## 🚀 Getting Started

### 📋 Prerequisites

Before you begin, ensure you have the following installed:
- **Flutter SDK** (Latest stable version)
- **Dart SDK** (Included with Flutter)
- **Android Studio** or **VS Code** with Flutter extensions
- **Git** for version control

### 🔧 Installation Steps

1. **Clone the Repository**
   ```bash
   git clone https://github.com/yourusername/ministore.git
   cd ministore
   ```

2. **Configure API Base URL**
   
   Navigate to the base configuration file and update your API endpoint:
   ```bash
   lib/dio/baseDio.dart
   ```
   
   Update line 9 with your base URL:
   ```dart
   static String baseUrl = 'https://your-api-base-url.com';
   ```

3. **Install Dependencies**
   ```bash
   flutter pub get
   ```

4. **Generate Code Files**
   
   Generate necessary files for JSON serialization and API clients:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

5. **Run the Application**
   ```bash
   flutter run
   ```

---

## 📦 Dependencies

### Core Dependencies
- **dio**: HTTP client for API communication
- **cached_network_image**: Efficient image loading and caching
- **provider**: State management solution
- **json_serializable**: JSON serialization/deserialization
- **flutter_secure_storage**: Secure data storage
- **retrofit**: Type-safe HTTP client

### UI Enhancement Dependencies
- **animated_notch_bottom_bar**: Animated bottom navigation
- **flutter_slidable**: Swipe-to-action functionality
- **widgets_to_image**: Convert widgets to images
- **share_plus**: Native sharing functionality

### Development Dependencies
- **flutter_lints**: Code quality and style guidelines
- **build_runner**: Code generation tool
- **retrofit_generator**: API client code generation
- **pretty_dio_logger**: HTTP request/response logging

---

## 🎯 App Functionality

### User Journey
1. **Launch**: App opens with splash screen and home page
2. **Browse**: User can explore product categories and individual items
3. **Search**: Find specific products using search functionality
4. **Add to Cart**: Select items and add them to shopping cart
5. **Checkout**: Complete purchase with secure payment process
6. **Order Tracking**: View order history and status

### Key Screens
- **Home Screen**: Featured products and categories
- **Product List**: Browse all available products