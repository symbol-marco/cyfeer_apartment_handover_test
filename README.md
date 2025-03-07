# Cyfeer Apartment Handover

A Flutter application for apartment handover management.

## Giới thiệu

Cyfeer Apartment Handover là ứng dụng quản lý việc bàn giao căn hộ được phát triển bằng Flutter. Ứng dụng cung cấp các tính năng để quản lý thông tin căn hộ, quá trình bàn giao và tài liệu liên quan.

## Yêu cầu hệ thống

- Flutter SDK (3.27.1)
- Android Studio / VS Code
- iOS Simulator 18.0 Iphone 16 Pro hoặc thiết bị thật (cho iOS)


## Cài đặt

### 1. Cài đặt Flutter

Nếu bạn chưa cài đặt Flutter, hãy làm theo hướng dẫn tại [trang chủ Flutter](https://flutter.dev/docs/get-started/install).

Kiểm tra cài đặt Flutter:
```bash
flutter doctor
```

### 2. Clone repository

```bash
git clone https://github.com/your-username/cyfeer_apartment_handover_test.git
cd cyfeer_apartment_handover_test
```

### 3. Cài đặt dependencies

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. Cấu hình môi trường

## Chạy ứng dụng

### Chạy trên máy ảo hoặc thiết bị thật

```bash
flutter run
```

### Build cho từng nền tảng

#### Android

```bash
flutter build apk
```
File APK sẽ được tạo tại `build/app/outputs/flutter-apk/app-release.apk`

#### iOS

```bash
flutter build ios
```
Sau đó mở file `ios/Runner.xcworkspace` bằng Xcode để thiết lập và chạy trên thiết bị iOS.

## Debug và tùy chọn phát triển

### Performance profiling

```bash
flutter run --profile
```

### Hot reload và Hot restart

Khi ứng dụng đang chạy, bạn có thể:
- Nhấn `r` để hot reload
- Nhấn `R` để hot restart

## Cấu trúc thư mục

```
cyfeer_apartment_handover/
├── android/            # Android project files
├── ios/               # iOS project files
├── assets/            # Static assets (images, fonts, etc)
├── lib/               # Dart source code
│   ├── models/        # Data models
│   ├── views/       # Application screens
│   ├── view_model/       # Reusable widgets
│   ├── services/      # Business logic and API services
│   ├── utils/         # Utility functions
│   └── main.dart      # Entry point
├── test/              # Test files
└── pubspec.yaml       # Project dependencies
```

