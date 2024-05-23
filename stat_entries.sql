SELECT vehicle_number, last_entry
FROM (
    SELECT vehicle_number, MAX(event_time) AS last_entry,
           SUM(CASE WHEN FK_camera = 1 THEN 1 ELSE 0 END) AS entries,
           SUM(CASE WHEN FK_camera = 2 THEN 1 ELSE 0 END) AS exits
    FROM gate01.event
    WHERE success = true
          GROUP BY vehicle_number
) AS counts
WHERE entries > exits;