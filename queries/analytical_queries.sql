-- Analytical Queries (the impressive ones)
USE library_db;

-- 1. All overdue books with student name, days overdue
SELECT
    s.name AS student_name,
    s.phone,
    b.title AS book_title,
    t.due_date,
    DATEDIFF(CURDATE(), t.due_date) AS days_overdue
FROM transactions t
JOIN students s ON t.student_id = s.student_id
JOIN books b ON t.book_id = b.book_id
WHERE t.return_date IS NULL
  AND t.due_date < CURDATE()
ORDER BY days_overdue DESC;

-- 2. Top 5 most borrowed books
SELECT
    b.title,
    b.author,
    b.genre,
    COUNT(t.transaction_id) AS times_borrowed
FROM books b
JOIN transactions t ON b.book_id = t.book_id
GROUP BY b.book_id, b.title, b.author, b.genre
ORDER BY times_borrowed DESC
LIMIT 5;

-- 3. Total fines collected per student
SELECT
    s.name AS student_name,
    COUNT(t.transaction_id) AS total_borrows,
    SUM(t.fine_amount) AS total_fine_paid
FROM students s
JOIN transactions t ON s.student_id = t.student_id
GROUP BY s.student_id, s.name
HAVING total_fine_paid > 0
ORDER BY total_fine_paid DESC;

-- 4. Most popular genre
SELECT
    b.genre,
    COUNT(t.transaction_id) AS borrow_count
FROM books b
JOIN transactions t ON b.book_id = t.book_id
GROUP BY b.genre
ORDER BY borrow_count DESC;

-- 5. Monthly borrowing trend
SELECT
    MONTHNAME(issue_date) AS month,
    YEAR(issue_date) AS year,
    COUNT(*) AS books_issued
FROM transactions
GROUP BY YEAR(issue_date), MONTH(issue_date)
ORDER BY YEAR(issue_date), MONTH(issue_date);

-- 6. Students who have never borrowed a book
SELECT s.name, s.email, s.branch
FROM students s
LEFT JOIN transactions t ON s.student_id = t.student_id
WHERE t.transaction_id IS NULL;

-- 7. Average fine per late return
SELECT
    ROUND(AVG(fine_amount), 2) AS avg_fine
FROM transactions
WHERE fine_amount > 0;