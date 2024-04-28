CREATE OR REPLACE PROCEDURE gate_01.create_user(
    IN p_last_name TEXT,
    IN p_first_name TEXT,
    IN p_middle_name TEXT,
    IN p_phone TEXT,
    IN p_email TEXT,
    IN p_address_name TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_address_id INT;
    v_user_id INT;
BEGIN
    -- Проверяем, существует ли адрес в таблице Address
    SELECT id INTO v_address_id FROM Address WHERE name = p_address_name;

    -- Если адрес не найден, создаем новый и получаем его идентификатор
    IF NOT FOUND THEN
        INSERT INTO Address (name) VALUES (p_address_name) RETURNING id INTO v_address_id;
    END IF;

    -- Создаем запись в таблице User
    INSERT INTO "User" (last_name, first_name, middle_name, phone, email, FK_address)
    VALUES (p_last_name, p_first_name, p_middle_name, p_phone, p_email, v_address_id)
    RETURNING id INTO v_user_id;

    -- Выводим идентификатор созданного пользователя
    RAISE NOTICE 'New user created with id: %', v_user_id;
END;
$$;


CALL gate_01.create_user('Doe', 'John', 'Robert', '123456789', 'john.doe@example.com', '123 Main St');
