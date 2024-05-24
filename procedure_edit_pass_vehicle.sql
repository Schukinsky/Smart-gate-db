CREATE OR REPLACE PROCEDURE gate01.edit_pass_vehicle(
    in_vehicle_number VARCHAR(20),
    in_start_date DATE,
    in_end_date DATE,
    in_blocked BOOLEAN
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Проверка, что дата начала меньше или равна дате окончания
    IF in_start_date > in_end_date THEN
        RAISE EXCEPTION 'Start date % is greater than end date %', in_start_date, in_end_date;
        RETURN;
    END IF;

    IF EXISTS (SELECT 1 FROM gate01.pass WHERE vehicle_number = in_vehicle_number) THEN
        UPDATE gate01.pass
        SET 
            start_date = in_start_date,
            end_date = in_end_date,
            blocked = in_blocked
        WHERE
            vehicle_number = in_vehicle_number;
        
        -- Вывод сообщения при успешном изменении
        RAISE NOTICE 'Pass for vehicle number % successfully updated', in_vehicle_number;
    ELSE
        RAISE EXCEPTION 'Pass with vehicle number % does not exist', in_vehicle_number;
    END IF;
END;
$$;


--CALL gate01.edit_pass_vehicle('Р686СК197', '2024-05-23', '2024-12-31', TRUE);