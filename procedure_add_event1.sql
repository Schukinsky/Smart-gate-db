CREATE OR REPLACE PROCEDURE add_event(
    IN p_pass_number VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
DECLARE
    pass_start_date DATE;
    pass_end_date DATE;
    pass_blocked BOOLEAN;
BEGIN
    -- Проверяем существование пропуска с указанным номером
    IF NOT EXISTS (SELECT 1 FROM gate01.pass WHERE pass_number = p_pass_number) THEN
        -- Если пропуска с указанным номером не существует, выводим сообщение и завершаем процедуру
        RAISE EXCEPTION 'Pass with number % not found', p_pass_number;
        RETURN;
    END IF;

    -- Получаем информацию о пропуске
    SELECT start_date, end_date, blocked INTO pass_start_date, pass_end_date, pass_blocked
    FROM gate01.pass
    WHERE pass_number = p_pass_number;

    -- Проверяем, заблокирован ли пропуск
    IF pass_blocked THEN
        -- Если пропуск заблокирован, добавляем запись в таблицу event с флагом неуспеха и выводим сообщение
        INSERT INTO gate01.event (FK_pass, access_time, success)
        VALUES ((SELECT id FROM gate01.pass WHERE pass_number = p_pass_number), CURRENT_TIMESTAMP, FALSE);
        RAISE EXCEPTION 'Event added but pass with number % is blocked', p_pass_number;
        RETURN;
    END IF;

    -- Проверяем, что текущая дата находится в пределах даты начала - даты окончания пропуска
    IF CURRENT_DATE BETWEEN pass_start_date AND pass_end_date THEN
        -- Добавляем запись в таблицу event с успешным флагом и выводим сообщение
        INSERT INTO gate01.event (FK_pass, access_time, success)
        VALUES ((SELECT id FROM gate01.pass WHERE pass_number = p_pass_number), CURRENT_TIMESTAMP, TRUE);
        RAISE EXCEPTION 'Event added successfully for pass with number %', p_pass_number;
    ELSE
        -- Если текущая дата не находится в пределах даты начала - даты окончания пропуска, добавляем запись с флагом неуспеха и выводим сообщение
        INSERT INTO gate01.event (FK_pass, access_time, success)
        VALUES ((SELECT id FROM gate01.pass WHERE pass_number = p_pass_number), CURRENT_TIMESTAMP, FALSE);
        RAISE EXCEPTION 'Event added but current date is not within the valid range for pass with number %', p_pass_number;
    END IF;
END;
$$;
