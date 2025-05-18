WITH monthly_transactions AS (
    -- Calculate transactions per customer per month
    SELECT 
        u.id AS customer_id,
        DATE_FORMAT(s.transaction_date, '%Y-%m') AS month,
        COUNT(s.id) AS transaction_count
    FROM users_customuser u
    JOIN savings_savingsaccount s ON u.id = s.owner_id
    WHERE s.transaction_date IS NOT NULL
    GROUP BY u.id, DATE_FORMAT(s.transaction_date, '%Y-%m')
),

customer_stats AS (
    -- Calculate average monthly transactions per customer
    SELECT
        customer_id,
        AVG(transaction_count) AS avg_transactions_per_month,
        -- Categorize based on business rules
        CASE
            WHEN AVG(transaction_count) >= 10 THEN 'High Frequency'
            WHEN AVG(transaction_count) BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM monthly_transactions
    GROUP BY customer_id
)

-- Aggregate results by frequency category
SELECT
    frequency_category,
    COUNT(customer_id) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month
FROM customer_stats
GROUP BY frequency_category
-- Order by category importance
ORDER BY
    CASE frequency_category
        WHEN 'High Frequency' THEN 1
        WHEN 'Medium Frequency' THEN 2
        ELSE 3
    END;