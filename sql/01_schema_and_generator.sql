-- =========================================================================
-- INSURANCE PORTFOLIO ANALYTICS: SCHEMA & MOCK DATA GENERATOR
-- Description: Creates 3NF normalized schema and seeds 10,000 clients, 
-- 10,000 policies, and 4,000 balanced claims using procedural SQL.
-- =========================================================================

-- DROP TABLES IF EXISTS (For clean idempotency/reset)
DROP TABLE IF EXISTS claims CASCADE;
DROP TABLE IF EXISTS policies CASCADE;
DROP TABLE IF EXISTS clients CASCADE;

-- 1. CREATE CLIENTS TABLE
CREATE TABLE clients (
    client_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    date_of_birth DATE NOT NULL,
    join_date DATE NOT NULL,
    credit_score INT
);

-- 2. CREATE POLICIES TABLE (Referencing Clients)
CREATE TABLE policies (
    policy_id SERIAL PRIMARY KEY,
    client_id INT REFERENCES clients(client_id) ON DELETE CASCADE,
    policy_type VARCHAR(50) NOT NULL, -- Motor, Home, Life, Commercial
    sum_insured DECIMAL(12, 2) NOT NULL,
    monthly_premium DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) NOT NULL, -- Active, Expired, Cancelled
    start_date DATE NOT NULL,
    end_date DATE NOT NULL
);

-- 3. CREATE CLAIMS TABLE (Referencing Policies)
CREATE TABLE claims (
    claim_id SERIAL PRIMARY KEY,
    policy_id INT REFERENCES policies(policy_id) ON DELETE CASCADE,
    claim_date TIMESTAMP DEFAULT NOW(),
    claim_amount DECIMAL(10, 2) NOT NULL,
    payout_amount DECIMAL(10, 2) DEFAULT 0.00,
    claim_status VARCHAR(30) NOT NULL -- Approved, Rejected, Under Review, Submitted
);

-- =========================================================================
-- DATA GENERATION LOGIC (10,000 Clients, 10,000 Policies, 4,000 Claims)
-- =========================================================================

-- Seed Clients
INSERT INTO clients (first_name, last_name, email, date_of_birth, join_date, credit_score)
SELECT 
    'Client_' || i AS first_name,
    'Surname_' || i AS last_name,
    'client_' || i || '@email.com' AS email,
    CURRENT_DATE - INTERVAL '1 year' * (20 + (i % 45)) AS date_of_birth,
    CURRENT_DATE - INTERVAL '1 day' * (i % 1000) AS join_date,
    550 + (i % 300) AS credit_score
FROM generate_series(1, 10000) AS s(i);

-- Seed Policies
INSERT INTO policies (client_id, policy_type, sum_insured, monthly_premium, status, start_date, end_date)
SELECT 
    (i % 10000) + 1 AS client_id,
    CASE (i % 4) 
        WHEN 0 THEN 'Motor' 
        WHEN 1 THEN 'Home' 
        WHEN 2 THEN 'Life' 
        ELSE 'Commercial' 
    END AS policy_type,
    (i % 500 + 50) * 1000.00 AS sum_insured,
    (i % 150 + 50) * 10.00 AS monthly_premium,
    CASE (i % 3) 
        WHEN 0 THEN 'Active' 
        WHEN 1 THEN 'Expired' 
        ELSE 'Cancelled' 
    END AS status,
    CURRENT_DATE - INTERVAL '1 day' * (i % 700) AS start_date,
    CURRENT_DATE + INTERVAL '1 day' * (365 - (i % 700)) AS end_date
FROM generate_series(1, 10000) AS s(i);

-- Seed Claims
INSERT INTO claims (policy_id, claim_date, claim_amount, payout_amount, claim_status)
SELECT 
    (
        SELECT p.policy_id 
        FROM policies p 
        WHERE p.policy_type = CASE (i % 4) 
            WHEN 0 THEN 'Motor' 
            WHEN 1 THEN 'Home' 
            WHEN 2 THEN 'Life' 
            ELSE 'Commercial' 
        END
        ORDER BY RANDOM() 
        LIMIT 1
    ) AS policy_id,
    CURRENT_DATE - INTERVAL '1 day' * (i % 365) AS claim_date,
    CASE (i % 4) 
        WHEN 0 THEN (i % 50 + 5) * 200.00  
        WHEN 1 THEN (i % 50 + 10) * 1000.00 
        WHEN 2 THEN (i % 50 + 20) * 2500.00 
        ELSE (i % 50 + 10) * 1500.00        
    END AS claim_amount,
    CASE 
        WHEN i % 5 != 0 THEN (
            CASE (i % 4) 
                WHEN 0 THEN (i % 50 + 5) * 160.00 
                WHEN 1 THEN (i % 50 + 10) * 800.00 
                WHEN 2 THEN (i % 50 + 20) * 2500.00 
                ELSE (i % 50 + 10) * 1200.00 
            END
        )
        ELSE 0.00 
    END AS payout_amount,
    CASE (i % 5) 
        WHEN 0 THEN 'Rejected' 
        WHEN 1 THEN 'Under Review' 
        WHEN 2 THEN 'Submitted' 
        ELSE 'Approved' 
    END AS claim_status
FROM generate_series(1, 4000) AS s(i);

-- Verification Query
SELECT 'Clients' AS table_name, COUNT(*) FROM clients
UNION ALL
SELECT 'Policies', COUNT(*) FROM policies
UNION ALL
SELECT 'Claims', COUNT(*) FROM claims;