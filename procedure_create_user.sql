CREATE OR REPLACE PROCEDURE gate01.create_user(
    IN p_last_name VARCHAR(32),
    IN p_first_name VARCHAR(32),
    IN p_middle_name VARCHAR(32),
    IN p_phone VARCHAR(20),
    IN p_email VARCHAR(32),
    IN p_address VARCHAR(255)
)
LANGUAGE plpgsql
AS $$
DECLARE
    user_id INT;
BEGIN
    -- Проверяем, существует ли уже пользователь с таким номером телефона
    IF EXISTS (SELECT 1 FROM gate01.user WHERE phone = p_phone) THEN
        RAISE EXCEPTION 'User with phone % already exists', p_phone;
        RETURN;
    END IF;

    -- Добавляем новую запись в таблицу user
    INSERT INTO gate01.user (last_name, first_name, middle_name, phone, email, address)
    VALUES (p_last_name, p_first_name, p_middle_name, p_phone, p_email, p_address)
    RETURNING id INTO user_id;

    -- Возвращаем сообщение с id успешно созданного пользователя
    RAISE NOTICE 'User created successfully with id: %', user_id;
END;
$$;

--CALL gate01.create_user('Иванов', 'Иван', 'Иванович', '79260000000', 'ivan.@example.com', 'ул. Лесная, д.162');