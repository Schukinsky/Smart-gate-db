CREATE OR REPLACE PROCEDURE gate01.add_pass_phone(
    IN p_user_phone VARCHAR(20),
    IN p_phone_number VARCHAR(20),
    IN p_start_date DATE,
    IN p_end_date DATE
)
LANGUAGE plpgsql
AS $$
DECLARE
    user_id INT;
BEGIN
    -- Получаем ID пользователя по номеру телефона
    SELECT id INTO user_id FROM gate01.user WHERE phone = p_user_phone;

    -- Если пользователь с указанным номером телефона не найден, выбрасываем исключение
    IF user_id IS NULL THEN
        RAISE EXCEPTION 'User with phone % not found', p_user_phone;
        RETURN;
    END IF;

    -- Добавляем пропуск в таблицу pass
    INSERT INTO gate01.pass (FK_user, phone_number, start_date, end_date)
    VALUES (user_id, p_phone_number, p_start_date, p_end_date);

    -- Возвращаем сообщение о успешном добавлении пропуска
    RAISE NOTICE 'Pass added successfully for user with phone %', p_user_phone;
END;
$$;

--CALL gate01.add_pass_phone ('79260000000', '79260000000', '2024-05-23', '2024-12-31');