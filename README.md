# UAE EOSB Calculator iOS

A modern, native iOS application for calculating End of Service Benefits (EOSB) according to UAE Labor Law Article 132. This iOS app provides an intuitive interface for employees and HR professionals to calculate accurate gratuity amounts with proper Arabic language support and right-to-left (RTL) layout.

## Features

• ✅ **Native iOS Experience** - Built with SwiftUI for optimal performance and native iOS feel
• ✅ **Multi-language Support** - English and Arabic (العربية) with proper RTL layout
• ✅ **Real-time Validation** - Comprehensive form validation with helpful error messages
• ✅ **Accurate Calculations** - Integrated with backend API for precise EOSB calculations
• ✅ **Responsive Design** - Works seamlessly on iPhone and iPad devices
• ✅ **Accessibility** - VoiceOver and accessibility features supported
• ✅ **Dark Mode Support** - Automatic dark/light theme switching
• ✅ **Network Monitoring** - Handles offline scenarios gracefully
• ✅ **Performance Optimized** - Native iOS performance with efficient API caching

## Quick Start

### Prerequisites

• **Xcode 15.0+** (recommended)
• **iOS 16.0+** target deployment
• **macOS 13.0+** for development
• **Apple Developer Account** (for device deployment)

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/abhisekmallik/uae-gratuity-calculator-ios.git
   cd uae-gratuity-calculator-ios
   ```

2. **Open in Xcode**

   ```bash
   open "UAE Gratuity Calculator.xcodeproj"
   ```

3. **Select your development team**
   - Select the project in Xcode navigator
   - Go to "Signing & Capabilities" tab
   - Select your development team

4. **Build and run**
   - Select your target device or simulator
   - Press `Cmd+R` to build and run

## Project Structure

```swift
UAE Gratuity Calculator/
├── UAE_Gratuity_CalculatorApp.swift    # Main app entry point
├── ContentView.swift                   # Main view controller
├── Models/                            # Data models
│   └── EOSBModels.swift              # EOSB calculation models
├── Views/                            # UI components
│   ├── ResultsView.swift             # Results display
│   └── UIComponents.swift            # Reusable UI components
├── Services/                         # API and business logic
│   └── APIService.swift              # Backend API integration
├── Localization/                     # Internationalization
│   └── Localizable.swift             # String localization
└── Assets.xcassets/                  # App icons and assets
    ├── AppIcon.appiconset/
    └── AccentColor.colorset/
```

## Technology Stack

• **Framework**: SwiftUI with iOS 16.0+ deployment target
• **Language**: Swift 5.9+
• **Architecture**: MVVM with ObservableObject state management
• **Networking**: URLSession with async/await
• **Localization**: Native iOS internationalization
• **UI Framework**: SwiftUI with native iOS components
• **State Management**: @StateObject and @ObservableObject
• **Date Handling**: Native Foundation Date APIs
• **Testing**: XCTest framework

## App Features

### Form Components

• **Employee Details Form** - Intuitive input fields for salary, contract type, and dates
• **Date Pickers** - Native iOS date selection with validation
• **Dropdown Selectors** - Dynamic options loaded from backend configuration
• **Real-time Validation** - Immediate feedback on input errors
• **Clear/Reset Functionality** - Easy form reset with confirmation

### Results Display

• **Calculation Breakdown** - Detailed explanation of EOSB calculation
• **Visual Components** - Native iOS design with proper typography
• **Currency Formatting** - Proper AED formatting with localization
• **Penalty Information** - Clear display of applicable penalties and reasons

### Internationalization (i18n)

• **Language Support** - English and Arabic with complete translations
• **RTL Layout** - Proper right-to-left layout for Arabic
• **Date Localization** - Culture-specific date formats
• **Number Formatting** - Localized currency and number display

## Backend Integration

This iOS app integrates with the [UAE EOSB Calculator Backend](https://github.com/abhisekmallik/uae-gratuity-calculator-backend) to provide:

• **Configuration API** - Dynamic dropdown values and calculation rules
• **Calculation API** - Accurate EOSB calculations per UAE Labor Law
• **Validation** - Server-side input validation and error handling

### API Endpoints Used

• `GET /api/eosb/config` - Fetch configuration data
• `POST /api/eosb/calculate` - Calculate EOSB amount
• `GET /api/eosb/health` - Backend health check

## EOSB Calculation Features

### Supported Scenarios
• **All Contract Types** - Unlimited and limited contracts
• **All Termination Types** - Resignation, termination, retirement, death, disability
• **Penalty Calculations** - Automatic application of resignation penalties
• **Service Period** - Precise calculation using actual calendar dates
• **Future Date Support** - Planning and projection scenarios

### Calculation Display

• **Breakdown View** - Detailed calculation steps and formulas
• **Service Summary** - Years, months, and days of service
• **Penalty Information** - Clear explanation of applicable penalties
• **Currency Formatting** - Professional AED amount display

## Development

### Build Configurations

• **Debug** - Development builds with debugging enabled
• **Release** - Production builds optimized for App Store

### Testing

```bash
# Run unit tests
Cmd+U in Xcode

# Run UI tests
Select UI Test scheme and run
```

### Code Quality

• **SwiftLint** - Code style and quality checking
• **Swift Package Manager** - Dependency management
• **Accessibility** - VoiceOver and accessibility compliance

## Deployment

### TestFlight (Beta Testing)

1. **Archive the app** in Xcode
2. **Upload to App Store Connect**
3. **Create TestFlight build**
4. **Add external testers**

### App Store Release

1. **Prepare app metadata** in App Store Connect
2. **Upload final build** via Xcode
3. **Submit for review**
4. **Release after approval**

### App Store Optimization

• **App Store Screenshots** - Localized for English and Arabic
• **App Description** - Optimized for UAE market
• **Keywords** - Relevant search terms for UAE employment
• **Privacy Policy** - Compliant with App Store requirements

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Commit your changes (`git commit -m 'Add some amazing feature'`)
5. Push to the branch (`git push origin feature/amazing-feature`)
6. Open a Pull Request

## License

This project is licensed under the ISC License.

## Support

For questions or issues, please create an issue in the repository.

## Related Projects

• [UAE EOSB Calculator Backend](https://github.com/abhisekmallik/uae-gratuity-calculator-backend) - RESTful API backend service
• [UAE EOSB Calculator Frontend](https://github.com/abhisekmallik/uae-gratuity-calculator-frontend) - Web application frontend

## Summary

This UAE EOSB Calculator iOS app provides a comprehensive, native mobile interface for calculating End of Service Benefits according to UAE Labor Law. With support for multiple languages, native iOS design patterns, and seamless integration with the backend API, it offers a professional solution for employees and HR professionals in the UAE.

### Key Highlights

• 🎯 **Accurate & Reliable** - Integrated with tested backend calculations
• 🌐 **Multilingual** - Full English and Arabic support with RTL layout
• 📱 **Native iOS** - Built with SwiftUI for optimal performance
• ♿ **Accessible** - VoiceOver and accessibility features supported
• 🚀 **Performance** - Native iOS performance with efficient caching
• 🔧 **Configurable** - Dynamic configuration from backend API

This iOS application provides an intuitive and professional mobile interface for the accurate calculation of UAE EOSB benefits, making it easy for users to understand their end-of-service entitlements on their iPhone or iPad.
