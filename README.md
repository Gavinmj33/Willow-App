# Willow 🌿

A mindful quotes app that brings you moments of presence throughout your day.

## About

Willow delivers carefully curated quotes from beloved mindfulness teachers (Thich Nhat Hanh, Pema Chödrön, Brené Brown, and Mary Oliver) that change with the rhythm of your day.

### Time Periods
- **Morning (6am-12pm)**: Start with intention and presence
- **Afternoon (12pm-5pm)**: Pause and refocus  
- **Evening (5pm-9pm)**: Reflect and unwind
- **Night (9pm-6am)**: Find peace before rest

### Features
- 60 hand-picked mindfulness quotes
- Unique atmospheric visuals for each time period
- Customizable notifications
- Daily quote rotation
- Clean, distraction-free design

## Technical Details

Built with:
- SwiftUI
- UserNotifications framework
- UserDefaults for persistence
- Custom animations with GeometryReader

### Architecture
- `ContentView.swift`: Main app view with theme system
- `QuoteManager.swift`: Quote library and rotation logic
- `NotificationManager.swift`: Notification scheduling
- `TimeOfDayVisuals.swift`: Animated backgrounds for each period
- `SettingsView.swift`: Notification preferences

## Development

### Requirements
- Xcode 15.0+
- iOS 17.0+
- Swift 6.0+

### Building
1. Clone the repository
2. Open `Willow.xcodeproj` in Xcode
3. Select your development team in Signing & Capabilities
4. Build and run on simulator or device

## Roadmap

Potential future features:
- [ ] Favorite quotes
- [ ] Share quotes to social media
- [ ] Home screen widgets
- [ ] Quote search/filtering
- [ ] Custom quote collections
- [ ] Additional visual themes

## Privacy

Willow collects no user data. All preferences are stored locally on your device.

## License

[Choose one: MIT, GPL, or "All Rights Reserved" if you want to keep it proprietary]

## Author

Matthew Gavin

## Acknowledgments

Quotes from:
- Thich Nhat Hanh
- Pema Chödrön  
- Brené Brown
- Mary Oliver
