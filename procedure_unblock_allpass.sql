CREATE OR REPLACE PROCEDURE gate01.unblock_allpass(
    IN p_user_phone VARCHAR(20)
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

    -- Устанавливаем флаг блокировки FALSE для всех пропусков пользователя
    BEGIN
    UPDATE gate01.pass
    SET 
        blocked = FALSE
    WHERE
        FK_user = user_id;
	END;

    -- Возвращаем сообщение о успешном добавлении пропуска
    RAISE NOTICE 'All passes successfully unblocked for user with phone %', p_user_phone;
END;
$$;

--CALL gate01.unblock_allpass ('79260000000');