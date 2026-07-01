-- Basic Queries
USE library_db;

-- 1. View all students
SELECT * FROM students;

-- 2. View all books
SELECT * FROM books;

-- 3. View all transactions
SELECT * FROM transactions;

-- 4. View all books that are available right now
SELECT title, author, genre, available_copies
FROM books
WHERE available_copies > 0;

-- 5. View all books that are fully checked out
SELECT title, author, total_copies
FROM books
WHERE available_copies = 0;

-- 6. View complete transaction history with names (not just IDs)
SELECT
    t.transaction_id,
    s.name AS student_name,
    b.title AS book_title,
    t.issue_date,
    t.due_date,
    t.return_date,
    t.fine_amount
FROM transactions t
JOIN students s ON t.student_id = s.student_id
JOIN books b ON t.book_id = b.book_id
ORDER BY t.issue_date DESC;