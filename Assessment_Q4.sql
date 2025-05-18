SELECT 
    u.id AS customer_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    -- Calculate account age in months
    TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE) AS tenure_months,
    -- Count all successful transactions
    COUNT(s.id) AS total_transactions,
    -- CLV formula: (transactions/month) * 12 * avg_profit_per_transaction
    ROUND(
        (COUNT(s.id) / 
        -- Prevent division by zero for new customers
        NULLIF(TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE), 0)
        ) * 12 * 
        -- Calculate average profit per transaction (0.1% of amount)
        (SUM(s.confirmed_amount) * 0.001 / COUNT(s.id)), 
    2
    ) AS estimated_clv
FROM users_customuser u
JOIN savings_savingsaccount s ON u.id = s.owner_id
WHERE 
    -- Only successful transactions
    s.transaction_status = 'success' 
    -- Only funded transactions
    AND s.confirmed_amount > 0
GROUP BY 
    u.id, u.first_name, u.last_name, u.date_joined
ORDER BY 
    -- Highest value customers first
    estimated_clv DESC;