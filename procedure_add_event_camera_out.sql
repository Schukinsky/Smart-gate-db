CREATE OR REPLACE PROCEDURE gate01.add_event_camera_out(
    IN p_vehicle_number VARCHAR(20),
    IN p_photo_url VARCHAR(255) DEFAULT gate01.generate_photo_name() -- для тестового стенда генерируем занчения функцией generate_photo_name
)
LANGUAGE plpgsql
AS $$
DECLARE
    pass_start_date DATE;
    pass_end_date DATE;
    pass_blocked BOOLEAN;
    camera_id INT := 2; --  значение 1 - въезд, 2 - выезд
BEGIN
    -- Получаем информацию о пропуске
    SELECT start_date, end_date, blocked
    INTO pass_start_date, pass_end_date, pass_blocked
    FROM gate01.pass
    WHERE vehicle_number = p_vehicle_number;

    -- Если пропуска с указанным номером не существует, записываем событие с флагом неуспеха и выводим сообщение
    IF NOT FOUND THEN
        INSERT INTO gate01.event (FK_pass, event_time, vehicle_number, FK_camera, photo_url, success, note)
        VALUES ((SELECT id FROM gate01.pass WHERE vehicle_number = p_vehicle_number), CURRENT_TIMESTAMP, p_vehicle_number, camera_id, p_photo_url, FALSE, 'Pass with number ' || p_vehicle_number || ' not found');
        RAISE NOTICE 'Event added but pass with number % not found', p_vehicle_number;
        RETURN;
    END IF;

    -- Если пропуск заблокирован, записываем событие с флагом неуспеха и выводим сообщение
    IF pass_blocked THEN
        INSERT INTO gate01.event (FK_pass, event_time, vehicle_number, FK_camera, photo_url, success, note)
        VALUES ((SELECT id FROM gate01.pass WHERE vehicle_number = p_vehicle_number), CURRENT_TIMESTAMP, p_vehicle_number, camera_id, p_photo_url, FALSE, 'Pass with number ' || p_vehicle_number || ' is blocked');
        RAISE NOTICE 'Event added but pass with number % is blocked', p_vehicle_number;
        RETURN;
    END IF;

    -- Проверяем, что текущая дата находится в пределах даты начала - даты окончания пропуска
    IF CURRENT_DATE BETWEEN pass_start_date AND pass_end_date THEN
        -- Добавляем запись в таблицу event с успешным флагом и выводим сообщение
        INSERT INTO gate01.event (FK_pass, event_time, vehicle_number, FK_camera, photo_url, success)
        VALUES ((SELECT id FROM gate01.pass WHERE vehicle_number = p_vehicle_number), CURRENT_TIMESTAMP, p_vehicle_number, camera_id, p_photo_url, TRUE);
        RAISE NOTICE 'Event added successfully for pass with number %', p_vehicle_number;
    ELSE
        -- Если текущая дата не находится в пределах даты начала - даты окончания пропуска, добавляем запись с флагом неуспеха и выводим сообщение
        INSERT INTO gate01.event (FK_pass, event_time, vehicle_number, FK_camera, photo_url, success, note)
        VALUES ((SELECT id FROM gate01.pass WHERE vehicle_number = p_vehicle_number), CURRENT_TIMESTAMP, p_vehicle_number, camera_id, p_photo_url, FALSE, 'Current date is not within the valid range for pass with number ' || p_vehicle_number);
        RAISE NOTICE 'Event added but current date is not within the valid range for pass with number %', p_vehicle_number;
    END IF;
END;
$$;

--CALL gate01.add_event_camera_out('Р686СК000');
--CALL gate01.add_event_camera_out('Р686СК000', 'http://fileserver.org/images/img_0000000002.jpg');