# Clipboard History for macOS

Ứng dụng menu bar macOS được rút gọn từ PHTV và chỉ giữ lại tính năng Clipboard History.

## Tính năng còn giữ

- Lưu lịch sử clipboard cho văn bản, ảnh và file.
- Mở nhanh bằng phím tắt, mặc định là `Control + V`.
- Tìm kiếm, chọn lại và dán nhanh một mục đã lưu.
- Bỏ qua nội dung clipboard từ các ứng dụng nhạy cảm như password manager.
- Cài đặt Clipboard History, bao gồm bật/tắt, phím tắt và giới hạn số mục.
- Cài đặt quyền Trợ năng để ứng dụng có thể dán lại nội dung vào app đang dùng.

## Giới hạn lịch sử

Giới hạn tối đa đã được nâng lên `500` mục clipboard. Mặc định ứng dụng bật Clipboard History và dùng giới hạn `500` mục.

## Build

Build local bằng Xcode:

```sh
xcodebuild build \
  -project App/PHTV.xcodeproj \
  -scheme PHTV \
  -configuration Debug \
  -destination 'platform=macOS' \
  CODE_SIGN_IDENTITY="-" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGNING_ALLOWED=NO \
  DEVELOPMENT_TEAM=""
```

GitHub Actions chạy workflow `CI` để build app và chạy test logic của Clipboard History.
