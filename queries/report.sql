-- Management Reports
USE library_db;

-- 1. Full library status report
SELECT
    b.title,
    b.author,
    b.genre,
    b.total_copies,
    b.available_copies,
    (b.total_copies - b.available_copies) AS currently_issued
FROM books
ORDER BY genre, title;

-- 2. Student activity report — who borrows most
SELECT
    s.name,
    s.branch,
    COUNT(t.transaction_id) AS total_books_borrowed,
    SUM(CASE WHEN t.return_date IS NULL AND t.due_date < CURDATE() THEN 1 ELSE 0 END) AS currently_overdue
FROM students s
LEFT JOIN transactions t ON s.student_id = t.student_id
GROUP BY s.student_id, s.name, s.branch
ORDER BY total_books_borrowed DESC;

-- 3. Fine collection summary
SELECT
    COUNT(*) AS total_late_returns,
    SUM(fine_amount) AS total_fines_collected,
    ROUND(AVG(fine_amount), 2) AS average_fine,
    MAX(fine_amount) AS highest_fine
FROM transactions
WHERE fine_amount > 0;