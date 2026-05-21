<div align="center">

# Chính sách bảo mật

**PHTV — Precision Hybrid Typing Vietnamese | Security Policy**

[Trang chủ](README.md) • [Email bảo mật](mailto:phamhungtien.contact@gmail.com) • [Issues](https://github.com/PhamHungTien/PHTV/issues)

</div>

---

## Mục lục

- [Báo cáo lỗi bảo mật](#báo-cáo-lỗi-bảo-mật)
- [Phiên bản được hỗ trợ](#phiên-bản-được-hỗ-trợ)
- [Phạm vi bảo mật](#phạm-vi-bảo-mật)
- [Mức độ nghiêm trọng](#mức-độ-nghiêm-trọng)
- [Thực hành bảo mật](#thực-hành-bảo-mật)
- [Hall of Fame](#hall-of-fame)

---

## Báo cáo lỗi bảo mật

### Quan trọng

**KHÔNG BAO GIỜ** tạo public issue trên GitHub cho các lỗ hổng bảo mật. Điều này có thể gây nguy hiểm cho người dùng khác trước khi bản vá được phát hành.

### Cách báo cáo

**Email:** [phamhungtien.contact@gmail.com](mailto:phamhungtien.contact@gmail.com)
**Subject:** `[SECURITY] Báo cáo lỗ hổng bảo mật - [Tóm tắt ngắn gọn]`

### Thông tin cần cung cấp

Để giúp chúng tôi hiểu và xử lý nhanh chóng, vui lòng bao gồm:

```
1. Mô tả lỗ hổng
   - Loại lỗ hổng (RCE, privilege escalation, data leak, etc.)
   - Tác động thực tế và tiềm ẩn

2. Các bước tái hiện (PoC)
   - Bước 1, 2, 3...
   - Screenshot hoặc video demo (nếu có)
   - Code mẫu để tái hiện

3. Môi trường
   - Phiên bản PHTV: (vd: 3.1.6)
   - macOS version: (vd: Sequoia 15.2)
   - Architecture: (Intel/Apple Silicon)

4. Cách phát hiện
   - Bạn tìm thấy lỗ hổng như thế nào?
   - Tools sử dụng (nếu có)

5. Đề xuất khắc phục (optional)
   - Nếu bạn có ý tưởng về cách sửa
```

### ⏱️ Timeline xử lý

| Giai đoạn | Thời gian | Hành động |
|-----------|-----------|-----------|
| **Xác nhận** | < 24 giờ | Gửi email xác nhận đã nhận báo cáo |
| **Đánh giá** | < 48 giờ | Phân loại mức độ nghiêm trọng |
| **Phát triển** | 3-7 ngày | Bắt đầu làm việc trên bản vá |
| **Testing** | 1-3 ngày | Kiểm tra kỹ lưỡng bản vá |
| **Thông báo** | Trước release | Liên hệ với bạn để review |
| **Phát hành** | Khi sẵn sàng | Release bản vá + công bố |

**Lưu ý:** Timeline có thể thay đổi tùy thuộc vào mức độ nghiêm trọng và độ phức tạp của lỗ hổng.

### 🤝 Tiết lộ có trách nhiệm (Responsible Disclosure)

#### Cam kết của bạn

- ⏰ Cho chúng tôi **ít nhất 90 ngày** để khắc phục trước khi công bố công khai
- 🤐 Giữ bí mật về lỗ hổng cho đến khi bản vá được phát hành
- 🚫 Không khai thác lỗ hổng cho mục đích xấu
- 🚫 Không tiết lộ cho bên thứ ba mà không có sự đồng ý

#### Cam kết của chúng tôi

- ✅ Xử lý báo cáo một cách **nghiêm túc và ưu tiên**
- ✅ **Cập nhật tiến độ** thường xuyên
- ✅ **Ghi nhận công lao** của bạn (nếu bạn muốn)
- ✅ **Không có hành động pháp lý** đối với các nhà nghiên cứu bảo mật thiện chí

## 📌 Phiên bản được hỗ trợ

Chúng tôi khuyến nghị luôn sử dụng phiên bản mới nhất để có bảo mật tốt nhất.

| Phiên bản | Trạng thái hỗ trợ | Chi tiết |
|-----------|-------------------|----------|
| 3.x | **Hỗ trợ đầy đủ** | Phát hành bản vá bảo mật nhanh chóng |
| 2.x | **Hỗ trợ giới hạn** | Chỉ vá lỗi nghiêm trọng nếu còn ảnh hưởng thực tế |
| 1.x trở xuống | **Không hỗ trợ** | Vui lòng nâng cấp lên bản mới nhất |

### 🔄 Chính sách End-of-Life (EOL)

- Mỗi phiên bản major được hỗ trợ **ít nhất 12 tháng** sau khi phiên bản major tiếp theo được phát hành
- Các phiên bản minor trong major hiện tại được hỗ trợ **6 tháng**
- Chúng tôi sẽ thông báo **3 tháng trước** khi EOL một phiên bản

## 🎯 Phạm vi bảo mật

### ✅ Trong phạm vi (In Scope)

Chúng tôi quan tâm đến các lỗ hổng bảo mật liên quan đến:

- **Accessibility/Input Monitoring abuse**: Lạm dụng quyền nhập liệu để truy cập dữ liệu không được phép
- **Privilege escalation**: Nâng quyền truy cập không hợp lệ
- **Code injection**: Inject code độc hại thông qua macro hoặc configuration
- **Data leakage**: Rò rỉ dữ liệu nhạy cảm (keystrokes, clipboard, etc.)
- **Authentication bypass**: Bỏ qua xác thực trong tính năng bảo mật
- **Malicious macro execution**: Thực thi macro độc hại mà không có sự đồng ý
- **Configuration tampering**: Thay đổi cấu hình trái phép
- **Path traversal**: Truy cập file ngoài phạm vi cho phép
- **Memory corruption**: Lỗi tràn bộ nhớ, use-after-free, etc.

### ❌ Ngoài phạm vi (Out of Scope)

Các vấn đề sau **không được coi là lỗ hổng bảo mật**:

- **Social engineering**: Lừa đảo người dùng cài đặt phần mềm độc hại
- **Physical access attacks**: Tấn công yêu cầu truy cập vật lý vào máy
- **Denial of Service (DoS)**: Làm crash hoặc làm chậm ứng dụng
- **Outdated dependencies**: Nếu không có bằng chứng khai thác thực tế
- **UI/UX issues**: Lỗi giao diện không ảnh hưởng bảo mật
- **Feature requests**: Đề xuất tính năng mới
- **Permission requirement**: PHTV cần Accessibility và Input Monitoring để hoạt động

## 📊 Mức độ nghiêm trọng

Chúng tôi sử dụng hệ thống CVSS 3.1 để đánh giá mức độ nghiêm trọng.

### 🔴 Critical (9.0-10.0)

**Response time:** < 24 giờ | **Patch target:** 1-3 ngày

- Remote Code Execution (RCE) không cần tương tác người dùng
- Elevation of privilege lên root/admin
- Rò rỉ thông tin xác thực hệ thống
- Bypass hoàn toàn cơ chế bảo mật

**Ví dụ:**
- Macro có thể thực thi arbitrary code với quyền system
- Đọc được file của user khác trên macOS
- Bypass SIP (System Integrity Protection)

### 🟠 High (7.0-8.9)

**Response time:** < 48 giờ | **Patch target:** 3-7 ngày

- RCE cần tương tác người dùng tối thiểu
- Privilege escalation trong phạm vi user hiện tại
- Rò rỉ dữ liệu nhạy cảm (passwords, keys)
- Authentication bypass

**Ví dụ:**
- Macro độc hại có thể đánh cắp clipboard data
- Bypass whitelist/blacklist app
- Truy cập unauthorized vào keychain

### 🟡 Medium (4.0-6.9)

**Response time:** < 7 ngày | **Patch target:** 14-30 ngày

- Information disclosure không nghiêm trọng
- CSRF trên local endpoints
- Logic flaws có thể bị lạm dụng
- Weak cryptography

**Ví dụ:**
- Lưu trữ config không mã hóa (nhưng không chứa thông tin nhạy cảm)
- Race conditions có thể gây hành vi không mong muốn
- Path traversal giới hạn

### 🟢 Low (0.1-3.9)

**Response time:** < 14 ngày | **Patch target:** Next release

- Minor information disclosure
- Issues yêu cầu nhiều điều kiện tiên quyết
- Security hardening opportunities

**Ví dụ:**
- Version disclosure
- Verbose error messages
- Missing security headers (nếu có web component)

## ✅ Thực hành bảo mật

### 👤 Dành cho người dùng

Giúp bảo vệ bản thân bằng cách tuân theo các best practices:

#### 🔄 Cập nhật

- ✅ **Luôn dùng phiên bản mới nhất**: Cài đặt updates ngay khi có
- ✅ **Bật auto-update**: Nếu có tính năng này
- ✅ **Theo dõi GitHub releases**: Để biết các bản vá bảo mật

#### 🔐 Quyền truy cập

- ✅ **Chỉ cấp quyền cần thiết**: PHTV chỉ cần Accessibility và Input Monitoring
- ✅ **Review permissions định kỳ**: Kiểm tra System Settings > Privacy & Security
- ⚠️ **Không chia sẻ quyền admin**: Không chạy PHTV với sudo

#### 🎯 Sử dụng an toàn

- ✅ **Excluded Apps cho ứng dụng nhạy cảm**:
  - Banking apps
  - Password managers (1Password, LastPass, etc.)
  - Crypto wallets
  - VPN clients
- ✅ **Kiểm tra macro**: Review macro trước khi import từ nguồn không tin cậy
- ✅ **Backup config**: Sao lưu cấu hình trước khi update major version

#### 🚨 Phát hiện bất thường

Liên hệ ngay nếu bạn phát hiện:
- Hành vi lạ của PHTV (ghi file không mong muốn, network requests)
- Crash thường xuyên sau khi update
- Macro tự thêm vào mà bạn không biết

### 👨‍💻 Dành cho nhà phát triển

Các biện pháp bảo mật chúng tôi áp dụng:

#### 📋 Development

- ✅ **Mandatory code review**: Mọi PR đều cần review trước merge
- ✅ **Branch protection**: Main branch được bảo vệ, không push trực tiếp
- ✅ **Signed commits**: Khuyến khích GPG signing
- ✅ **Least privilege principle**: Code chỉ yêu cầu quyền tối thiểu cần thiết

#### 🔍 Security Scanning

- ✅ **Dependency scanning**: Kiểm tra thư viện bên thứ ba
- ✅ **SAST (Static Analysis)**: Phân tích code tĩnh
- ✅ **Hardening**: Compiler flags bảo mật (-fstack-protector, -D_FORTIFY_SOURCE)

#### 🏗️ Build & Release

- ✅ **Code signing**: Tất cả builds đều được sign với Developer ID
- ✅ **Notarization**: Ứng dụng được notarize bởi Apple
- ✅ **Reproducible builds**: Build process minh bạch
- ✅ **SBOM**: Software Bill of Materials cho dependency tracking

#### 📦 Data Handling

- ✅ **Không thu thập dữ liệu cá nhân**: PHTV không gửi keystrokes đi đâu cả
- ✅ **Local-only storage**: Tất cả config lưu local
- ✅ **Secure defaults**: Cấu hình mặc định ưu tiên bảo mật
- ✅ **Input validation**: Validate tất cả input từ user và file

### Quyền macOS PHTV sử dụng

| Quyền | Lý do |
| --- | --- |
| **Accessibility** | Tương tác với ô nhập liệu và commit chữ đã xử lý. |
| **Input Monitoring** | Nhận phím gõ từ macOS để engine xử lý Telex/VNI. |

PHTV không yêu cầu quyền admin để chạy thường ngày. Khi cần phục hồi quyền bị kẹt, ứng dụng chỉ reset entry TCC của bundle hiện tại cho quyền đang thiếu và mở đúng mục System Settings để người dùng bật lại.

## Công bố lỗ hổng (Disclosure)

### Quy trình công bố

Khi một lỗ hổng được vá xong và sẵn sàng công bố, chúng tôi sẽ:

1. **Release bản vá**: Phát hành phiên bản mới với fix
2. **Security Advisory**: Tạo GitHub Security Advisory
3. **Release Notes**: Cập nhật chi tiết trong GitHub Releases
4. **CHANGELOG**: Ghi rõ trong CHANGELOG.md
5. **Thông báo người dùng**: Qua channels chính thức nếu cần
6. **CVE**: Request CVE ID cho lỗi nghiêm trọng

### 📋 Format công bố

```markdown
## Security Advisory: [Severity] - [Vulnerability Name]

**CVE ID**: CVE-YYYY-XXXXX (nếu có)
**Affected Versions**: 3.1.0 - 3.1.5
**Fixed in Version**: 3.1.6
**Severity**: Critical/High/Medium/Low
**CVSS Score**: X.X

### Description
[Mô tả chi tiết lỗ hổng]

### Impact
[Ai bị ảnh hưởng? Hậu quả gì?]

### Mitigation
- Nâng cấp lên phiên bản 3.1.6 trở lên
- [Các biện pháp tạm thời nếu không thể update]

### Credits
Cảm ơn [Researcher Name] đã báo cáo lỗ hổng này.

### Timeline
- YYYY-MM-DD: Nhận báo cáo
- YYYY-MM-DD: Xác nhận lỗ hổng
- YYYY-MM-DD: Phát triển bản vá
- YYYY-MM-DD: Release bản vá
- YYYY-MM-DD: Public disclosure
```

## Hall of Fame

Chúng tôi ghi nhận những nhà nghiên cứu bảo mật đã giúp PHTV an toàn hơn:

### 2026

_Chưa có báo cáo nào được ghi nhận trong năm 2026._

### 2025

_Chưa có báo cáo nào được ghi nhận trong năm 2025._

---

**Bạn muốn được ghi nhận?** Báo cáo lỗ hổng bảo mật cho chúng tôi!

## Liên hệ

### Cho các câu hỏi bảo mật

- **Email**: [phamhungtien.contact@gmail.com](mailto:phamhungtien.contact@gmail.com)
- **Subject line**: Bắt đầu với `[SECURITY]`

### Cho các vấn đề khác

- **Issues**: [GitHub Issues](https://github.com/PhamHungTien/PHTV/issues)
- **Discussions**: [GitHub Discussions](https://github.com/PhamHungTien/PHTV/discussions)

---

<div align="center">

## Bảo mật là ưu tiên hàng đầu

Chúng tôi cam kết bảo vệ người dùng và xử lý mọi báo cáo bảo mật một cách nghiêm túc.

[![Security Policy](https://img.shields.io/badge/Security-Policy-red?logo=security)](SECURITY.md)
[![Report Vulnerability](https://img.shields.io/badge/Report-Vulnerability-critical)](mailto:phamhungtien.contact@gmail.com)
[![Responsible Disclosure](https://img.shields.io/badge/Responsible-Disclosure-success)]()

### Cảm ơn đã giúp PHTV an toàn hơn!

Mọi báo cáo bảo mật đều được đánh giá cao và góp phần làm cho cộng đồng PHTV an toàn hơn.

---

**Quick Links**

[Trang chủ](README.md) • [Email bảo mật](mailto:phamhungtien.contact@gmail.com) • [Issues](https://github.com/PhamHungTien/PHTV/issues) • [Documentation](README.md)

---

**Last updated:** 2026-05-20
**Policy version:** 1.1

</div>
