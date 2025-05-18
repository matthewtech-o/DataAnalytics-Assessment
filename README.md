# DataAnalytics-Assessment

## Question 1: High-Value Customers with Multiple Products

### Approach
1. Created two CTEs to identify customers with:
   - Active savings accounts (`is_regular_savings = 1`)
   - Active investment accounts (`is_a_fund = 1`)
2. Joined these CTEs to find customers with both account types
3. Calculated total deposits by converting from kobo to currency units
4. Sorted by total deposits to highlight highest-value customers

### Challenges
- Initially confused `plan_type_id` with account type before recognizing the boolean flags
- Had to handle NULL values in the COALESCE functions
- Needed to divide by 100 to convert kobo amounts

## Question 2: Transaction Frequency Analysis

### Approach
1. Calculated monthly transaction counts per customer
2. Averaged these monthly counts to get reliable frequency metrics
3. Applied business rules for categorization
4. Aggregated results by frequency category

### Challenges
- Needed to ensure accurate month extraction from timestamps
- Had to handle customers with very short activity periods
- Business rules for categorization required careful CASE statement construction

## Question 3: Account Inactivity Alert

### Approach
1. Joined plan and transaction tables to get account details
2. Calculated days since last transaction using `DATEDIFF`
3. Classified account types using boolean flags:
   - `is_regular_savings` for savings accounts
   - `is_a_fund` for investment accounts
4. Filtered for accounts with >365 days inactivity
5. Ordered by longest inactive first for prioritization

### Challenges
- Needed to verify proper handling of NULL transaction dates
- Required understanding of status codes (assumed 1=active)
- Had to ensure accurate date difference calculations
- Account type classification required testing edge cases

## Question 4: Customer Lifetime Value (CLV) Estimation

### Approach
1. Calculated customer tenure in months since signup
2. Counted all successful transactions
3. Implemented CLV formula:
   - Transaction frequency (transactions/tenure)
   - Annualization factor (12)
   - Profit assumption (0.1% of transaction value)
4. Added NULLIF to handle new customers (zero tenure)
5. Converted kobo amounts in calculations
6. Ordered by highest CLV first for marketing prioritization

### Challenges
- Needed to prevent division by zero for new signups
- Required careful validation of the profit calculation
- Had to ensure proper currency unit handling (kobo conversion)
- Formula required multiple nested calculations
