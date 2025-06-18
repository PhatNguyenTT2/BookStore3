# 📚 Hướng dẫn Setup Hoàn chỉnh - Bookstore Application

## 🎯 Tổng quan

Dự án Bookstore Application bao gồm:
- **Backend:** Spring Boot + MySQL 
- **Frontend:** Vue.js 3 + Vuetify
- **Database:** MySQL với 21 bảng dữ liệu
- **ID Generation:** Pattern có ý nghĩa (admin-001, user-001, etc.)

## ✅ Trạng thái hiện tại

### Backend ✅
- **URL:** `http://localhost:8080/bookstore`  
- **Swagger:** `http://localhost:8080/bookstore/swagger-ui/index.html`
- **Status:** Đang chạy

### Frontend ✅  
- **URL:** `http://localhost:5173`
- **Status:** Đang chạy

### Database ✅
- **Schema:** `bookstore_app` đã tạo
- **Tables:** 21 bảng đã được tạo tự động

## 🔢 ID Generation Strategy

### User ID Pattern
- **Admin Users:** `admin-001`, `admin-002`, `admin-003`...
- **Regular Users:** `user-001`, `user-002`, `user-003`...
- **Auto-increment:** Hệ thống tự động tăng số thứ tự khi tạo user mới

### Backend Implementation
- **IdGeneratorService:** Service chuyên tạo ID theo pattern
- **UserService:** Sử dụng IdGeneratorService để tạo ID cho user mới
- **Database Query:** Đếm users theo prefix để xác định số thứ tự tiếp theo

### Other Entities ID
- **Books:** Integer auto-increment (book_id: 1, 2, 3...)
- **Authors:** Integer auto-increment (author_id: 1, 2, 3...)
- **Categories:** Integer auto-increment (category_id: 1, 2, 3...)
- **Invoices:** Integer auto-increment (invoice_id: 1, 2, 3...)
- **Import Receipts:** Integer auto-increment (import_receipt_id: 1, 2, 3...)

## 📊 Import Dữ liệu Mẫu

### Bước 1: Mở MySQL Workbench
1. Kết nối tới MySQL server
2. Chọn schema `bookstore_app`

### Bước 2: Import Script
1. Mở tab Query mới
2. Copy toàn bộ nội dung từ file `complete_sample_data.sql`
3. Paste vào query editor
4. Nhấn Execute (⚡)

### Bước 3: Kiểm tra dữ liệu
```sql
-- Kiểm tra User IDs với pattern mới
SELECT user_id, username, first_name, last_name FROM users ORDER BY user_id;

-- Kiểm tra số lượng records trong các bảng chính
SELECT 'users' as table_name, COUNT(*) as count FROM users
UNION ALL
SELECT 'books', COUNT(*) FROM books  
UNION ALL
SELECT 'authors', COUNT(*) FROM authors
UNION ALL
SELECT 'categories', COUNT(*) FROM categories
UNION ALL
SELECT 'invoices', COUNT(*) FROM invoices;
```

## 🗂️ Cấu trúc Dữ liệu Mẫu

### 👥 Users (10 người)
| User ID | Username | Role | Password | Debt Amount |
|---------|----------|------|----------|-------------|
| admin-001 | admin123 | ADMIN | admin123 | 0.00 |
| user-001 | john_doe | USER | admin123 | 150.00 |
| user-002 | jane_smith | USER | admin123 | 0.00 |
| user-003 | michael_brown | USER | admin123 | 75.50 |
| user-004 | sarah_wilson | USER | admin123 | 0.00 |
| user-005 | david_johnson | USER | admin123 | 200.00 |
| user-006 | emily_davis | USER | admin123 | 0.00 |
| user-007 | robert_miller | USER | admin123 | 120.25 |
| user-008 | lisa_anderson | USER | admin123 | 0.00 |
| user-009 | james_taylor | USER | admin123 | 50.75 |

### 📚 Books (15 cuốn) - Book IDs: 1-15
- Harry Potter and the Philosopher's Stone (ID: 1)
- 1984 (ID: 2)
- Foundation (ID: 3) 
- Murder on the Orient Express (ID: 4)
- The Shining (ID: 5)
- Pride and Prejudice (ID: 6)
- The Adventures of Tom Sawyer (ID: 7)
- The Old Man and the Sea (ID: 8)
- To Kill a Mockingbird (ID: 9)
- The Great Gatsby (ID: 10)
- Mrs. Dalloway (ID: 11)
- A Tale of Two Cities (ID: 12)
- War and Peace (ID: 13)
- One Hundred Years of Solitude (ID: 14)
- Beloved (ID: 15)

### 👨‍💼 Authors (15 tác giả) - Author IDs: 1-15
- J.K. Rowling (ID: 1), George Orwell (ID: 2), Isaac Asimov (ID: 3)
- Agatha Christie (ID: 4), Stephen King (ID: 5), Jane Austen (ID: 6)
- Mark Twain (ID: 7), Ernest Hemingway (ID: 8), Harper Lee (ID: 9)
- F. Scott Fitzgerald (ID: 10), Virginia Woolf (ID: 11), Charles Dickens (ID: 12)
- Leo Tolstoy (ID: 13), Gabriel García Márquez (ID: 14), Toni Morrison (ID: 15)

### 📂 Categories (12 thể loại) - Category IDs: 1-12
- Fiction (ID: 1), Science Fiction (ID: 2), Mystery (ID: 3), Romance (ID: 4)
- Biography (ID: 5), History (ID: 6), Science (ID: 7), Technology (ID: 8)  
- Business (ID: 9), Self-Help (ID: 10), Philosophy (ID: 11), Poetry (ID: 12)

### 🧾 Transactions
- **5 Import Receipts** (IDs: 1-5) - Tất cả bởi admin-001
- **7 Invoices** (IDs: 1-7) - Cho các users khác nhau
- **5 Payment Receipts** (IDs: 1-5) - Thanh toán nợ của users
- **Detailed transaction records** cho mỗi loại

### ⚙️ System Parameters
- MAX_DEBT_AMOUNT: 500.00
- MIN_STOCK_QUANTITY: 5
- DEFAULT_MARKUP_PERCENTAGE: 25.0
- MAX_INVOICE_DAYS: 30
- MIN_IMPORT_QUANTITY: 10

### 🔄 Auto-increment Settings
- **Books:** Bắt đầu từ ID 16 (cho records mới)
- **Authors:** Bắt đầu từ ID 16 (cho records mới)
- **Categories:** Bắt đầu từ ID 13 (cho records mới)
- **Import Receipts:** Bắt đầu từ ID 6 (cho records mới)
- **Invoices:** Bắt đầu từ ID 8 (cho records mới)
- **Payment Receipts:** Bắt đầu từ ID 6 (cho records mới)

## 🔑 Permissions & Roles

### ADMIN Role (Quyền đầy đủ)
- READ/WRITE/DELETE: Books, Users, Invoices, Reports
- MANAGE: Import, Payment

### USER Role (Quyền hạn chế)  
- READ: Books, Invoices
- Không thể quản lý hệ thống

## 🚀 Test Các Chức năng

### 1. Authentication Test
```
POST /bookstore/auth/login
Body: {
  "username": "admin",
  "password": "admin123"
}
```

### 2. Test ID Generation (Tạo User Mới)
```
POST /bookstore/users
Authorization: Bearer {admin_token}
Body: {
  "username": "new_user",
  "password": "password123",
  "firstName": "New",
  "lastName": "User",
  "email": "newuser@example.com"
}
// Sẽ tự động tạo ID: user-010
```

### 3. Books API Test
```
GET /bookstore/books
Authorization: Bearer {token}
```

### 4. Users Management (Admin only)
```
GET /bookstore/users  
Authorization: Bearer {admin_token}
```

## 🌐 Frontend Testing

### 1. Truy cập ứng dụng
- URL: `http://localhost:5173`

### 2. Đăng nhập
- Username: `admin` | Password: `admin123` (Admin - ID: admin-001)
- Username: `john_doe` | Password: `admin123` (User - ID: user-001)

### 3. Test các tính năng
- ✅ Books management
- ✅ User management (Admin)
- ✅ Invoice management  
- ✅ Import/Export functionality
- ✅ Reports generation
- ✅ Payment processing
- ✅ **ID auto-generation khi tạo mới**

## 📋 Checklist Hoàn thành

- [x] Backend Spring Boot đang chạy
- [x] Frontend Vue.js đang chạy  
- [x] MySQL database schema tạo thành công
- [x] 21 bảng database đã được tạo
- [x] **ID Generation Service hoạt động**
- [x] **User IDs theo pattern: admin-001, user-001, etc.**
- [x] Dữ liệu mẫu đầy đủ cho tất cả bảng
- [x] Authentication system hoạt động
- [x] Authorization (Roles & Permissions) setup
- [x] **Auto-increment values đã được set đúng**
- [x] API endpoints accessible
- [x] Frontend kết nối backend thành công

## 🛠️ Troubleshooting

### Lỗi kết nối database
```bash
# Kiểm tra MySQL service
# Đảm bảo schema bookstore_app exists
# Kiểm tra credentials trong application.yaml
```

### Lỗi authentication
```bash
# Đảm bảo BCrypt password hash đúng
# Kiểm tra JWT configuration
# Verify roles_permissions mapping
```

### Frontend không load
```bash
# Kiểm tra npm dependencies: npm install
# Verify axios baseURL configuration  
# Check browser console for errors
```

### ID Generation Issues
```bash
# Kiểm tra IdGeneratorService có được inject đúng không
# Verify UserRepository.countByIdStartsWith() hoạt động
# Check database có constraint UNIQUE trên user_id
```

## 📞 Support

Nếu gặp vấn đề, hãy kiểm tra:
1. **Logs:** Backend console và browser developer tools
2. **Database:** Queries execution results và ID sequences
3. **Network:** API calls trong Network tab
4. **Authentication:** JWT tokens validity
5. **ID Generation:** Service logs và database counts

---
**🎉 Chúc mừng! Hệ thống Bookstore với ID Pattern thông minh đã sẵn sàng!**

### 🔮 Tính năng mới:
- ✅ **User IDs có ý nghĩa:** admin-001, user-001, user-002...
- ✅ **Tự động tăng ID:** Hệ thống tự động tính toán ID tiếp theo
- ✅ **Dữ liệu mẫu phong phú:** 10 users, 15 books, 15 authors, 12 categories
- ✅ **Transaction data:** Invoices, payments, imports đầy đủ 