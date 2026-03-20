# REST Countries App

A professional Flutter application that provides a comprehensive list of countries with detailed information from the REST Countries API. Built with clean architecture principles and modern Flutter development practices.

## ✨ Features

- 🌍 **Browse Countries**: Explore a complete list of countries with flags, names, and basic information
- 🔍 **Search Functionality**: Quickly find countries by name with real-time search
- 📋 **Detailed Information**: View comprehensive country details including:
  - Official name and alternative names
  - Capital city and region
  - Population and area
  - Currencies and languages
  - Timezone and calling codes
  - And much more
- 💾 **Offline Support**: Local caching with Hive for offline access to previously loaded data
- 🎨 **Modern UI**: Beautiful and responsive user interface with loading states and error handling
- ⚡ **High Performance**: Optimized network requests and smooth animations

## 📱 Platform Support

- Android (SDK 21+)
- iOS (12.0+)
- Web
- Windows
- macOS
- Linux

## 🛠️ Tech Stack

### State Management
- **flutter_bloc** (v8.1.3): Implements the BLoC pattern for state management
- **bloc** (v8.1.2): Core BLoC library for business logic

### Networking
- **dio** (v5.3.3): Powerful HTTP client for REST API calls
- **connectivity_plus** (v5.0.1): Network connectivity detection

### Dependency Injection
- **get_it** (v7.6.4): Simple service locator for dependency injection
- **injectable** (v2.3.0): Code generation for get_it

### Local Storage
- **hive** (v2.2.3): Lightweight local database
- **hive_flutter** (v1.1.0): Flutter integration for Hive

### Functional Programming
- **dartz** (v0.10.1): Functional programming support with Either, Option, etc.

### Utilities
- **equatable** (v2.0.5): Simplifies equality comparisons for objects
- **logger** (v2.0.2): Professional logging solution
- **intl** (v0.18.1): Internationalization and localization

### UI Components
- **cached_network_image** (v3.3.0): Cached network image loading
- **shimmer** (v3.0.0): Loading shimmer effect
- **flutter_svg** (v2.0.9): SVG image support

### Development Tools
- **build_runner** (v2.4.7): Code generation
- **injectable_generator** (v2.4.0): Generate dependency injection code
- **hive_generator** (v2.0.1): Generate Hive type adapters

## 📐 Architecture

This project follows **Clean Architecture** with clear separation of concerns:
