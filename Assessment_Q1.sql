WITH savings_accounts AS (
    -- Get all customers with active savings accounts
    SELECT 
        u.id AS owner_id,
        CONCAT(u.first_name, ' ', u.last_name) AS name,
        COUNT(s.id) AS savings_count,
        -- Convert from kobo to currency units
        SUM(s.confirmed_amount)/100 AS savings_deposits
    FROM users_customuser u
    JOIN savings_savingsaccount s ON u.id = s.owner_id
    JOIN plans_plan p ON s.plan_id = p.id
    -- Filter for savings plans with confirmed deposits
    WHERE p.is_regular_savings = 1 AND s.confirmed_amount > 0
    GROUP BY u.id, u.first_name, u.last_name
),

investment_accounts AS (
    -- Get all customers with active investment accounts
    SELECT 
        u.id AS owner_id,
        CONCAT(u.first_name, ' ', u.last_name) AS name,
        COUNT(s.id) AS investment_count,
        SUM(s.confirmed_amount)/100 AS investment_deposits
    FROM users_customuser u
    JOIN savings_savingsaccount s ON u.id = s.owner_id
    JOIN plans_plan p ON s.plan_id = p.id
    -- Filter for investment funds with confirmed deposits
    WHERE p.is_a_fund = 1 AND s.confirmed_amount > 0
    GROUP BY u.id, u.first_name, u.last_name
)

-- Combine results to find customers with both account types
SELECT 
    s.owner_id,
    s.name,
    s.savings_count,
    COALESCE(i.investment_count, 0) AS investment_count,
    (COALESCE(s.savings_deposits, 0) + COALESCE(i.investment_deposits, 0)) AS total_deposits
FROM savings_accounts s
JOIN investment_accounts i ON s.owner_id = i.owner_id
ORDER BY total_deposits DESC;