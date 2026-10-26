SELECT 'Clients' AS table_name, COUNT(*) FROM clients
UNION ALL
SELECT 'Policies', COUNT(*) FROM policies
UNION ALL
SELECT 'Claims', COUNT(*) FROM claims;