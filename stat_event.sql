SELECT 
    e.event_time, 
    CONCAT(u.last_name, ' ', u.first_name, ' ', COALESCE(u.middle_name, '')) AS full_name,
    u.address,
    CONCAT(COALESCE(p.phone_number, ''), COALESCE(p.vehicle_number, '')) AS pass,
    e.vehicle_number,
	c.name AS movement_direction,
    e.note 
FROM 
    gate01.event e
JOIN 
    gate01.pass p ON e.FK_pass = p.id
JOIN 
    gate01.user u ON p.FK_user = u.id
JOIN
    gate01.camera c ON e.FK_camera = c.id
WHERE 
    e.success = false
ORDER BY 
    e.event_time;