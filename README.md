# BookStore Management System

Hệ thống quản lý cửa hàng sách được xây dựng với Spring Boot (Backend) và Vue.js (Frontend).

## Yêu cầu hệ thống

- **Java**: JDK 17 hoặc cao hơn
- **Node.js**: Version 16+ và npm
- **MySQL**: Version 8.0+
- **Maven**: Version 3.6+ (hoặc sử dụng Maven Wrapper đi kèm)

## Hướng dẫn cài đặt

### Bước 1: Kết nối với Database MySQL

1. **Tạo database schema:**
   ```sql
   CREATE DATABASE bookstore_app;
   ```

2. **Cấu hình kết nối database:**
   - Mở file `backend/src/main/resources/application.yaml`
   - Kiểm tra và cập nhật thông tin kết nối nếu cần:
   ```yaml
   spring:
     datasource:
       url: "jdbc:mysql://localhost:3306/bookstore_app"
       username: root
       password: root
   ```

### Bước 2: Khởi chạy Backend (Spring Boot)

1. **Di chuyển vào thư mục backend:**
   ```bash
   cd backend
   ```

2. **Chạy ứng dụng Spring Boot:**
   
   **Trên Windows:**
   ```bash
   .\mvnw.cmd spring-boot:run
   ```
   
   **Trên Linux/Mac:**
   ```bash
   ./mvnw spring-boot:run
   ```

3. **Kiểm tra backend hoạt động:**
   - Ứng dụng sẽ chạy tại: `http://localhost:8080/bookstore`
   - Swagger UI: `http://localhost:8080/bookstore/swagger-ui/index.html`
   - Các bảng database sẽ được tự động tạo (JPA auto-create)

### Bước 3: Import dữ liệu mẫu

1. **Sau khi backend đã khởi chạy và tạo các bảng**, chạy script SQL để thêm dữ liệu mẫu:
   ```sql
   -- Mở file complete_sample_data.sql và chạy toàn bộ nội dung
   -- hoặc import trực tiếp vào MySQL Workbench/phpMyAdmin
   ```

2. **Hoặc sử dụng MySQL CLI:**
   ```bash
   mysql -u root -p bookstore_app < complete_sample_data.sql
   ```

### Bước 4: Khởi chạy Frontend (Vue.js)

1. **Mở terminal mới và di chuyển về thư mục gốc:**
   ```bash
   cd ..
   ```

2. **Cài đặt dependencies:**
   ```bash
   npm install
   ```

3. **Chạy ứng dụng Vue.js:**
   ```bash
   npm run dev
   ```

4. **Truy cập ứng dụng:**
   - Frontend sẽ chạy tại: `http://localhost:5173`
   - Đăng nhập với tài khoản admin mặc định (xem trong `complete_sample_data.sql`)

## Cấu trúc Project

```
BookStore3/
├── backend/                 # Spring Boot API
│   ├── src/
│   ├── pom.xml
│   └── mvnw (Maven Wrapper)
├── src/                     # Vue.js Frontend
├── complete_sample_data.sql # Dữ liệu mẫu
└── package.json            # Frontend dependencies
```

## Tính năng chính

- **Quản lý sách**: Thêm, sửa, xóa, tìm kiếm sách
- **Quản lý tác giả và thể loại**: CRUD operations
- **Quản lý người dùng**: Phân quyền, xác thực JWT
- **Quản lý hóa đơn**: Nhập/xuất sách
- **Báo cáo**: Báo cáo tồn kho, công nợ theo tháng
- **Dashboard**: Thống kê tổng quan

## API Documentation

Sau khi khởi chạy backend, truy cập Swagger UI tại:
`http://localhost:8080/bookstore/swagger-ui/index.html`

## Xử lý sự cố

### Backend không khởi chạy được:
- Kiểm tra Java version: `java -version` (cần JDK 17+)
- Kiểm tra MySQL đã khởi chạy và database `bookstore_app` đã tồn tại
- Kiểm tra port 8080 có bị chiếm dụng không

### Frontend không kết nối được:
- Đảm bảo backend đang chạy trên port 8080
- Kiểm tra cấu hình API URL trong `src/plugins/axios.js`
- Clear npm cache: `npm cache clean --force`

### Database connection error:
- Kiểm tra MySQL service đang chạy
- Xác nhận username/password trong `application.yaml`
- Đảm bảo database `bookstore_app` đã được tạo

## Liên hệ

Nếu gặp vấn đề trong quá trình cài đặt, vui lòng tạo issue trên repository này.
