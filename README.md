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
1. Identified last transaction date for each account
2. Calculated days since last transaction
3. Filtered for accounts inactive >365 days
4. Classified account type using the boolean flags

### Challenges
- Needed to verify date difference calculation syntax
- Had to ensure proper handling of NULL transaction dates
- Account type classification required understanding of the boolean flags

## Question 4: Customer Lifetime Value (CLV) Estimation

### Approach
1. Calculated account tenure in months
2. Counted total successful transactions
3. Applied the CLV formula incorporating:
   - Transaction frequency (transactions/tenure)
   - Annualization factor (12)
   - Profit assumption (0.1% of transaction value)

### Challenges
- Needed to prevent division by zero for new customers
- Had to validate the profit calculation formula
- Required careful handling of currency conversion
