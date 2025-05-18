SELECT 
    p.id AS plan_id,
    s.owner_id,
    -- Classify account type based on plan flags
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type,
    -- Get the most recent transaction date
    MAX(s.transaction_date) AS last_transaction_date,
    -- Calculate days since last activity
    DATEDIFF(CURRENT_DATE, MAX(s.transaction_date)) AS inactivity_days
FROM plans_plan p
JOIN savings_savingsaccount s ON p.id = s.plan_id
WHERE 
    -- Exclude accounts with no transaction history
    s.transaction_date IS NOT NULL
GROUP BY 
    p.id, s.owner_id, p.is_regular_savings, p.is_a_fund
HAVING 
    -- Filter for accounts inactive >365 days
    DATEDIFF(CURRENT_DATE, MAX(s.transaction_date)) > 365
ORDER BY 
    -- Sort by longest inactive first
    inactivity_days DESC;