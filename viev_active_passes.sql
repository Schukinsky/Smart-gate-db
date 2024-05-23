CREATE OR REPLACE VIEW gate01.active_passes AS
SELECT 
    CONCAT(u.last_name, ' ', u.first_name, ' ', COALESCE(u.middle_name, '')) AS full_name,
    u.address AS user_address,
    u.phone AS user_phone,
    u.email AS user_email,
    CONCAT(COALESCE(p.phone_number, ''), COALESCE(p.vehicle_number, '')) AS pass,
    p.start_date,
    p.end_date,
    p.blocked
FROM 
    gate01.pass p
LEFT JOIN 
    gate01.user u 
ON 
    p.FK_user = u.id
WHERE 
    p.blocked = FALSE
    AND CURRENT_DATE BETWEEN p.start_date AND p.end_date
ORDER BY 
    u.address, pass;


--SELECT * FROM gate01.active_passes;