CREATE OR REPLACE FUNCTION gate01.get_passes_info(apply_conditions BOOLEAN DEFAULT FALSE)
RETURNS TABLE (
	full_name TEXT,
    user_address VARCHAR(255),
    user_phone VARCHAR(20),
    user_email VARCHAR(255),
    pass TEXT,
    start_date DATE,
    end_date DATE,
    blocked BOOLEAN
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF apply_conditions THEN
        RETURN QUERY
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
            u.address;
    ELSE
        RETURN QUERY
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
        ORDER BY 
            u.address;
    END IF;
END;
$$;

--SELECT * FROM gate01.get_passes_info(TRUE); -- все пропуска
--SELECT * FROM gate01.get_passes_info(TRUE); -- только активные пропуска
