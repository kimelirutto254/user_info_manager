# User Info Manager

## Overview
This project is a Flutter application that allows users to view and edit user information. It utilizes a RESTful API to fetch and update user data, providing a user-friendly interface for interaction.

## Project Structure
- **lib/**
  - **main.dart**: The entry point of the application.
  - **model/**: Contains data models, such as `user.dart`.
  - **providers/**: Contains state management classes, such as `user_provider.dart`.
  - **screens.dart/**: Contains the UI screens, including:
    - `user_edit_screen.dart`: Screen for editing user details.
    - `user_list.dart`: Screen for displaying the list of users.
    - `splash_screen.dart`: Initial splash screen displayed on app launch.
  - **services/**: Contains service classes for API interactions, such as `api_service.dart`.

## Features
- User list display with search functionality.
- User detail editing.
- Shimmer effect for loading states.

## Installation
1. Clone the repository.
2. Run the following commands to set up the project:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

## API
The application interacts with the following API endpoints:
- **Fetch all users**: `GET https://frontend-interview.touchinspiration.net/api/users`
- **Fetch a single user**: `GET https://frontend-interview.touchinspiration.net/api/users/{id}`
- **Update a user**: `PATCH https://frontend-interview.touchinspiration.net/api/users/{id}`

## Services
The `services` directory contains the `api_service.dart` file, which handles all API interactions using the `Dio` package. Key functionalities include:
- Fetching a list of users.
- Fetching details of a single user.
- Updating user information.

## State Management
The application uses the `Provider` package for state management. Key concepts implemented include:
- **State**: Managed by `UserProvider`.
- **Actions**: Fetching and updating user data.
- **Lifecycle hooks**: `initState` and `addPostFrameCallback` for initializing data.

## Submission
This project was completed as part of a technical assessment for a frontend development role. It demonstrates the ability to:
- Consume RESTful APIs.
- Manage application state effectively.
- Implement a clean and responsive UI.

