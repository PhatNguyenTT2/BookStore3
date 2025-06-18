-- ============================================================================
-- COMPLETE SAMPLE DATA FOR BOOKSTORE APPLICATION
-- Execute this after Spring Boot has created all tables with JPA
-- ============================================================================

-- Clear existing data (in correct order due to foreign keys)
DELETE FROM users_roles;

DELETE FROM roles_permissions;

DELETE FROM books_categories;

DELETE FROM authors_books;

DELETE FROM books_import_receipts;

DELETE FROM books_invoices;

DELETE FROM payment_receipts_invoices;

DELETE FROM monthly_inventory_report_details;

DELETE FROM monthly_debt_report_details;

DELETE FROM payment_receipts;

DELETE FROM invoices;

DELETE FROM import_receipts;

DELETE FROM monthly_inventory_reports;

DELETE FROM monthly_debt_reports;

DELETE FROM books;

DELETE FROM categories;

DELETE FROM authors;

DELETE FROM users;

DELETE FROM roles;

DELETE FROM permissions;

DELETE FROM parameters;

DELETE FROM invalidated_token;

-- ============================================================================
-- 1. PERMISSIONS (13 permissions)
-- ============================================================================
INSERT INTO
    permissions (
        permission_name,
        permission_description
    )
VALUES (
        'READ_USERS',
        'Permission to read user information'
    ),
    (
        'WRITE_USERS',
        'Permission to create and update users'
    ),
    (
        'DELETE_USERS',
        'Permission to delete users'
    ),
    (
        'READ_BOOKS',
        'Permission to view books'
    ),
    (
        'WRITE_BOOKS',
        'Permission to add and update books'
    ),
    (
        'DELETE_BOOKS',
        'Permission to delete books'
    ),
    (
        'READ_AUTHORS',
        'Permission to view authors'
    ),
    (
        'WRITE_AUTHORS',
        'Permission to add and update authors'
    ),
    (
        'DELETE_AUTHORS',
        'Permission to delete authors'
    ),
    (
        'READ_CATEGORIES',
        'Permission to view categories'
    ),
    (
        'WRITE_CATEGORIES',
        'Permission to add and update categories'
    ),
    (
        'DELETE_CATEGORIES',
        'Permission to delete categories'
    ),
    (
        'MANAGE_INVENTORY',
        'Permission to manage inventory operations'
    );

-- ============================================================================
-- 2. ROLES (2 roles)
-- ============================================================================
INSERT INTO
    roles (role_name, role_description)
VALUES (
        'ADMIN',
        'Administrator with full access'
    ),
    (
        'USER',
        'Regular user with limited access'
    );

-- ============================================================================
-- 3. ROLES_PERMISSIONS (Many-to-Many relationship)
-- ============================================================================
-- Admin gets all permissions
INSERT INTO
    roles_permissions (
        roles_role_name,
        permissions_permission_name
    )
VALUES ('ADMIN', 'READ_USERS'),
    ('ADMIN', 'WRITE_USERS'),
    ('ADMIN', 'DELETE_USERS'),
    ('ADMIN', 'READ_BOOKS'),
    ('ADMIN', 'WRITE_BOOKS'),
    ('ADMIN', 'DELETE_BOOKS'),
    ('ADMIN', 'READ_AUTHORS'),
    ('ADMIN', 'WRITE_AUTHORS'),
    ('ADMIN', 'DELETE_AUTHORS'),
    ('ADMIN', 'READ_CATEGORIES'),
    ('ADMIN', 'WRITE_CATEGORIES'),
    ('ADMIN', 'DELETE_CATEGORIES'),
    ('ADMIN', 'MANAGE_INVENTORY');

-- User gets read permissions only
INSERT INTO
    roles_permissions (
        roles_role_name,
        permissions_permission_name
    )
VALUES ('USER', 'READ_BOOKS'),
    ('USER', 'READ_AUTHORS'),
    ('USER', 'READ_CATEGORIES');

-- ============================================================================
-- 4. USERS (10 users with meaningful IDs)
-- ============================================================================
INSERT INTO
    users (
        user_id,
        username,
        password,
        first_name,
        last_name,
        email,
        phone,
        dob,
        debt_amount_user
    )
VALUES
    -- Admin user (ID: admin-001)
    (
        'admin-000',
        'admin123',
        '$2a$10$mfMZmgDH5qBqvwSTRLGQaeMZRWvvRrAzaAEy35uUgPG3JCtHmWzLm',
        'System',
        'Administrator',
        'admin@bookstore.com',
        '0901234567',
        '1990-01-01',
        0.00
    ),

-- Regular users (ID: user-001 to user-009)
(
    'user-001',
    'john_doe',
    '$2a$10$mfMZmgDH5qBqvwSTRLGQaeMZRWvvRrAzaAEy35uUgPG3JCtHmWzLm',
    'John',
    'Doe',
    'john.doe@email.com',
    '0901234568',
    '1985-03-15',
    150000.00
),
(
    'user-002',
    'jane_smith',
    '$2a$10$mfMZmgDH5qBqvwSTRLGQaeMZRWvvRrAzaAEy35uUgPG3JCtHmWzLm',
    'Jane',
    'Smith',
    'jane.smith@email.com',
    '0901234569',
    '1992-07-22',
    75000.00
),
(
    'user-003',
    'mike_johnson',
    '$2a$10$mfMZmgDH5qBqvwSTRLGQaeMZRWvvRrAzaAEy35uUgPG3JCtHmWzLm',
    'Mike',
    'Johnson',
    'mike.johnson@email.com',
    '0901234570',
    '1988-11-10',
    0.00
),
(
    'user-004',
    'sarah_wilson',
    '$2a$10$mfMZmgDH5qBqvwSTRLGQaeMZRWvvRrAzaAEy35uUgPG3JCtHmWzLm',
    'Sarah',
    'Wilson',
    'sarah.wilson@email.com',
    '0901234571',
    '1995-04-18',
    200000.00
),
(
    'user-005',
    'david_brown',
    '$2a$10$mfMZmgDH5qBqvwSTRLGQaeMZRWvvRrAzaAEy35uUgPG3JCtHmWzLm',
    'David',
    'Brown',
    'david.brown@email.com',
    '0901234572',
    '1987-09-03',
    50000.00
),
(
    'user-006',
    'emily_davis',
    '$2a$10$mfMZmgDH5qBqvwSTRLGQaeMZRWvvRrAzaAEy35uUgPG3JCtHmWzLm',
    'Emily',
    'Davis',
    'emily.davis@email.com',
    '0901234573',
    '1993-12-25',
    0.00
),
(
    'user-007',
    'alex_garcia',
    '$2a$10$mfMZmgDH5qBqvwSTRLGQaeMZRWvvRrAzaAEy35uUgPG3JCtHmWzLm',
    'Alex',
    'Garcia',
    'alex.garcia@email.com',
    '0901234574',
    '1991-06-14',
    100000.00
),
(
    'user-008',
    'lisa_martinez',
    '$2a$10$mfMZmgDH5qBqvwSTRLGQaeMZRWvvRrAzaAEy35uUgPG3JCtHmWzLm',
    'Lisa',
    'Martinez',
    'lisa.martinez@email.com',
    '0901234575',
    '1989-08-07',
    25000.00
),
(
    'user-009',
    'chris_lee',
    '$2a$10$mfMZmgDH5qBqvwSTRLGQaeMZRWvvRrAzaAEy35uUgPG3JCtHmWzLm',
    'Chris',
    'Lee',
    'chris.lee@email.com',
    '0901234576',
    '1994-02-28',
    175000.00
);

-- ============================================================================
-- 5. USERS_ROLES (Many-to-Many relationship)
-- ============================================================================
INSERT INTO
    users_roles (
        users_user_id,
        roles_role_name
    )
VALUES ('admin-000', 'ADMIN'),
    ('user-001', 'USER'),
    ('user-002', 'USER'),
    ('user-003', 'USER'),
    ('user-004', 'USER'),
    ('user-005', 'USER'),
    ('user-006', 'USER'),
    ('user-007', 'USER'),
    ('user-008', 'USER'),
    ('user-009', 'USER');

-- ============================================================================
-- 6. AUTHORS (15 authors - auto increment)
-- ============================================================================
INSERT INTO
    authors (author_name)
VALUES ('Nguyễn Nhật Ánh'),
    ('Tô Hoài'),
    ('Nam Cao'),
    ('Nguyễn Du'),
    ('Hồ Chí Minh'),
    ('Xuân Diệu'),
    ('Nguyễn Tuân'),
    ('Vũ Trọng Phụng'),
    ('Ngô Tất Tố'),
    ('Kim Lân'),
    ('J.K. Rowling'),
    ('George Orwell'),
    ('Harper Lee'),
    ('Jane Austen'),
    ('Mark Twain');

-- ============================================================================
-- 7. CATEGORIES (12 categories - auto increment)
-- ============================================================================
INSERT INTO
    categories (category_name)
VALUES ('Văn học Việt Nam'),
    ('Tiểu thuyết'),
    ('Truyện ngắn'),
    ('Thơ ca'),
    ('Sách thiếu nhi'),
    ('Khoa học viễn tưởng'),
    ('Trinh thám'),
    ('Lịch sử'),
    ('Tâm lý học'),
    ('Kinh tế'),
    ('Công nghệ'),
    ('Ngoại ngữ');

-- ============================================================================
-- 8. BOOKS (15 books - auto increment)
-- ============================================================================
INSERT INTO
    books (
        book_name,
        published_year,
        import_price,
        quantity
    )
VALUES (
        'Dế Mèn phiêu lưu ký',
        1941,
        45000.00,
        50
    ),
    ('Tắt đèn', 1939, 55000.00, 30),
    (
        'Truyện Kiều',
        1820,
        80000.00,
        25
    ),
    (
        'Nhật ký trong tù',
        1960,
        65000.00,
        40
    ),
    (
        'Thơ Xuân Diệu',
        1938,
        70000.00,
        35
    ),
    (
        'Vang bóng một thời',
        1980,
        60000.00,
        45
    ),
    ('Số đỏ', 1936, 75000.00, 20),
    (
        'Tắt đèn (Tái bản)',
        1939,
        55000.00,
        25
    ),
    ('Làng', 1943, 50000.00, 30),
    ('Vợ nhặt', 1954, 40000.00, 35),
    (
        'Harry Potter và Hòn đá Phù thủy',
        1997,
        120000.00,
        100
    ),
    ('1984', 1949, 85000.00, 60),
    (
        'Giết con chim nhại',
        1960,
        90000.00,
        40
    ),
    (
        'Kiêu hãnh và Định kiến',
        1813,
        95000.00,
        35
    ),
    (
        'Cuộc phiêu lưu của Tom Sawyer',
        1876,
        70000.00,
        45
    );

-- ============================================================================
-- 9. AUTHORS_BOOKS (Many-to-Many relationship)
-- ============================================================================
INSERT INTO
    authors_books (author_id, book_id)
VALUES
    -- Vietnamese Literature
    (2, 1), -- Tô Hoài - Dế Mèn phiêu lưu ký
    (3, 2), -- Nam Cao - Tắt đèn
    (4, 3), -- Nguyễn Du - Truyện Kiều
    (5, 4), -- Hồ Chí Minh - Nhật ký trong tù
    (6, 5), -- Xuân Diệu - Thơ Xuân Diệu
    (1, 6), -- Nguyễn Nhật Ánh - Vang bóng một thời
    (8, 7), -- Vũ Trọng Phụng - Số đỏ
    (3, 8), -- Nam Cao - Tắt đèn (Tái bản)
    (9, 9), -- Ngô Tất Tố - Làng
    (10, 10), -- Kim Lân - Vợ nhặt
    -- International Literature
    (11, 11), -- J.K. Rowling - Harry Potter
    (12, 12), -- George Orwell - 1984
    (13, 13), -- Harper Lee - Giết con chim nhại
    (14, 14), -- Jane Austen - Kiêu hãnh và Định kiến
    (15, 15);
-- Mark Twain - Tom Sawyer

-- ============================================================================
-- 10. BOOKS_CATEGORIES (Many-to-Many relationship)
-- ============================================================================
INSERT INTO
    books_categories (book_id, category_id)
VALUES
    -- Vietnamese Literature + specific categories
    (1, 1),
    (1, 5), -- Dế Mèn - Văn học VN + Sách thiếu nhi
    (2, 1),
    (2, 3), -- Tắt đèn - Văn học VN + Truyện ngắn
    (3, 1),
    (3, 4), -- Truyện Kiều - Văn học VN + Thơ ca
    (4, 1),
    (4, 8), -- Nhật ký trong tù - Văn học VN + Lịch sử
    (5, 1),
    (5, 4), -- Thơ Xuân Diệu - Văn học VN + Thơ ca
    (6, 1),
    (6, 2), -- Vang bóng một thời - Văn học VN + Tiểu thuyết
    (7, 1),
    (7, 2), -- Số đỏ - Văn học VN + Tiểu thuyết
    (8, 1),
    (8, 3), -- Tắt đèn (Tái bản) - Văn học VN + Truyện ngắn
    (9, 1),
    (9, 2), -- Làng - Văn học VN + Tiểu thuyết
    (10, 1),
    (10, 3), -- Vợ nhặt - Văn học VN + Truyện ngắn
    -- International Literature
    (11, 2),
    (11, 6), -- Harry Potter - Tiểu thuyết + Khoa học viễn tưởng
    (12, 2),
    (12, 6), -- 1984 - Tiểu thuyết + Khoa học viễn tưởng
    (13, 2),
    (13, 9), -- Giết con chim nhại - Tiểu thuyết + Tâm lý học
    (14, 2),
    (14, 9), -- Kiêu hãnh và Định kiến - Tiểu thuyết + Tâm lý học
    (15, 2),
    (15, 5);
-- Tom Sawyer - Tiểu thuyết + Sách thiếu nhi

-- ============================================================================
-- 11. PARAMETERS (5 system parameters)
-- ============================================================================
INSERT INTO
    parameters (param_name, param_value)
VALUES ('MIN_INVENTORY_STOCK', 10.0),
    ('MAX_DEBT_AMOUNT', 500000.0),
    (
        'DEFAULT_MARKUP_PERCENTAGE',
        30.0
    ),
    ('MAX_BOOKS_PER_INVOICE', 20.0),
    ('MONTHLY_REPORT_DAY', 1.0);

-- ============================================================================
-- 12. IMPORT_RECEIPTS (5 import receipts - auto increment)
-- ============================================================================
INSERT INTO
    import_receipts (
        admin_id,
        import_date,
        total_amount
    )
VALUES (
        'admin-000',
        '2024-01-15',
        2500000.00
    ),
    (
        'admin-000',
        '2024-02-20',
        3200000.00
    ),
    (
        'admin-000',
        '2024-03-10',
        1800000.00
    ),
    (
        'admin-000',
        '2024-04-05',
        2900000.00
    ),
    (
        'admin-001',
        '2024-05-12',
        2200000.00
    );

-- ============================================================================
-- 13. BOOKS_IMPORT_RECEIPTS (Junction table with additional data)
-- ============================================================================
INSERT INTO
    books_import_receipts (
        book_id,
        import_receipt_id,
        quantity,
        import_price
    )
VALUES
    -- Import Receipt 1 (January)
    (1, 1, 20, 45000.00),
    (2, 1, 15, 55000.00),
    (3, 1, 10, 80000.00),
    (11, 1, 25, 120000.00),
    -- Import Receipt 2 (February)
    (4, 2, 20, 65000.00),
    (5, 2, 18, 70000.00),
    (12, 2, 30, 85000.00),
    (13, 2, 20, 90000.00),
    -- Import Receipt 3 (March)
    (6, 3, 25, 60000.00),
    (7, 3, 10, 75000.00),
    (14, 3, 15, 95000.00),
    -- Import Receipt 4 (April)
    (8, 4, 15, 55000.00),
    (9, 4, 20, 50000.00),
    (10, 4, 25, 40000.00),
    (15, 4, 30, 70000.00),
    -- Import Receipt 5 (May)
    (1, 5, 30, 45000.00),
    (11, 5, 50, 120000.00);

-- ============================================================================
-- 14. INVOICES (7 invoices - auto increment)
-- ============================================================================
INSERT INTO
    invoices (
        user_id,
        admin_id,
        create_at,
        total_amount,
        paid_amount,
        debt_amount
    )
VALUES (
        'user-001',
        'admin-001',
        '2024-01-20',
        250000.00,
        100000.00,
        150000.00
    ),
    (
        'user-002',
        'admin-001',
        '2024-02-15',
        180000.00,
        105000.00,
        75000.00
    ),
    (
        'user-003',
        'admin-001',
        '2024-02-28',
        320000.00,
        320000.00,
        0.00
    ),
    (
        'user-004',
        'admin-001',
        '2024-03-12',
        450000.00,
        250000.00,
        200000.00
    ),
    (
        'user-005',
        'admin-001',
        '2024-03-25',
        95000.00,
        45000.00,
        50000.00
    ),
    (
        'user-007',
        'admin-001',
        '2024-04-08',
        275000.00,
        175000.00,
        100000.00
    ),
    (
        'user-009',
        'admin-001',
        '2024-04-22',
        390000.00,
        215000.00,
        175000.00
    );

-- ============================================================================
-- 15. BOOKS_INVOICES (Junction table with additional data)
-- ============================================================================
INSERT INTO
    books_invoices (
        invoice_id,
        book_id,
        quantity,
        sell_price
    )
VALUES
    -- Invoice 1 (user-001)
    (1, 1, 2, 58500.00), -- Dế Mèn (45000 * 1.3)
    (1, 11, 1, 156000.00), -- Harry Potter (120000 * 1.3)
    -- Invoice 2 (user-002)
    (2, 2, 1, 71500.00), -- Tắt đèn
    (2, 5, 1, 91000.00), -- Thơ Xuân Diệu
    -- Invoice 3 (user-003)
    (3, 12, 2, 110500.00), -- 1984 (2 books)
    (3, 6, 1, 78000.00), -- Vang bóng một thời
    -- Invoice 4 (user-004)
    (4, 3, 1, 104000.00), -- Truyện Kiều
    (4, 13, 2, 117000.00), -- Giết con chim nhại (2 books)
    (4, 15, 1, 91000.00), -- Tom Sawyer
    -- Invoice 5 (user-005)
    (5, 10, 2, 52000.00), -- Vợ nhặt (2 books)
    -- Invoice 6 (user-007)
    (6, 4, 1, 84500.00), -- Nhật ký trong tù
    (6, 14, 1, 123500.00), -- Kiêu hãnh và Định kiến
    (6, 9, 1, 65000.00), -- Làng
    -- Invoice 7 (user-009)
    (7, 7, 1, 97500.00), -- Số đỏ
    (7, 8, 2, 71500.00), -- Tắt đèn (Tái bản) (2 books)
    (7, 11, 1, 156000.00);
-- Harry Potter

-- ============================================================================
-- 16. PAYMENT_RECEIPTS (5 payment receipts - auto increment)
-- ============================================================================
INSERT INTO
    payment_receipts (
        payer_id,
        admin_id,
        total_amount,
        create_at
    )
VALUES (
        'user-001',
        'admin-001',
        50000.00,
        '2024-01-25'
    ),
    (
        'user-002',
        'admin-001',
        25000.00,
        '2024-02-20'
    ),
    (
        'user-004',
        'admin-001',
        100000.00,
        '2024-03-15'
    ),
    (
        'user-007',
        'admin-001',
        75000.00,
        '2024-04-10'
    ),
    (
        'user-009',
        'admin-001',
        125000.00,
        '2024-04-25'
    );

-- ============================================================================
-- 17. PAYMENT_RECEIPTS_INVOICES (Junction table with composite key)
-- ============================================================================
INSERT INTO
    payment_receipts_invoices (
        payment_receipt_id,
        invoice_id,
        paid_amount
    )
VALUES (1, 1, 50000.00), -- Payment 1 → Invoice 1
    (2, 2, 25000.00), -- Payment 2 → Invoice 2
    (3, 4, 100000.00), -- Payment 3 → Invoice 4
    (4, 6, 75000.00), -- Payment 4 → Invoice 6
    (5, 7, 125000.00);
-- Payment 5 → Invoice 7

-- ============================================================================
-- VERIFICATION QUERIES (commented out - uncomment to run)
-- ============================================================================
/*
-- Check data counts
SELECT 'permissions' as table_name, COUNT(*) as count FROM permissions
UNION ALL SELECT 'roles', COUNT(*) FROM roles
UNION ALL SELECT 'users', COUNT(*) FROM users
UNION ALL SELECT 'authors', COUNT(*) FROM authors
UNION ALL SELECT 'categories', COUNT(*) FROM categories
UNION ALL SELECT 'books', COUNT(*) FROM books
UNION ALL SELECT 'import_receipts', COUNT(*) FROM import_receipts
UNION ALL SELECT 'invoices', COUNT(*) FROM invoices
UNION ALL SELECT 'payment_receipts', COUNT(*) FROM payment_receipts;

-- Check relationships
SELECT COUNT(*) as role_permissions FROM roles_permissions;
SELECT COUNT(*) as user_roles FROM users_roles;
SELECT COUNT(*) as book_authors FROM authors_books;
SELECT COUNT(*) as book_categories FROM books_categories;
SELECT COUNT(*) as import_details FROM books_import_receipts;
SELECT COUNT(*) as invoice_details FROM books_invoices;
SELECT COUNT(*) as payment_details FROM payment_receipts_invoices;
*/