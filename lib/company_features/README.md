# Company Features

This folder contains all the features related to the company role in the application.

## Company Dashboard

The company dashboard provides a bottom navigation bar with 4 main sections:

### 1. Tickets Section (`/tickets`)
- Displays all company tickets
- Shows ticket details including title, description, location, screen, and status
- Allows navigation to ticket details
- Includes a floating action button to create new tickets

### 2. Screen Section (`/screens`)
- Shows all company screens information
- Displays screen type, location, solution type, and ID
- Provides a comprehensive view of all screens managed by the company

### 3. Reports Section (`/reports`)
- Access to company reports functionality
- Inherits from the existing ReportScreen

### 4. Company Section (`/company`)
- Company home screen with general company information
- Shows company overview and statistics

## Navigation

The dashboard uses `IndexedStack` to maintain the state of each section when switching between tabs. This ensures that:
- User input and scroll positions are preserved
- Data is not reloaded unnecessarily
- Smooth transitions between sections

## Floating Action Button

The floating action button (FAB) is only visible on the Tickets section and allows users to create new company tickets.

## Usage

To navigate to the company dashboard, use:
```dart
context.pushNamed(Routes.companyDashboardScreen);
```

## Dependencies

- `CompanyHomeCubit`: Manages company data and tickets
- `UserCubit`: Provides user and company information
- Various models for data handling

## File Structure

```
company_features/
├── company_dashboard_screen.dart    # Main dashboard with bottom navigation
├── tickets/
│   └── tickets_section.dart        # Tickets section
├── screens/
│   └── screens_section.dart        # Screens section
├── reports/                        # Reports functionality
├── home/                          # Company home section
└── ticket_details/                # Ticket details functionality
```
