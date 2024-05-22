CREATE OR REPLACE FUNCTION gate01.generate_photo_name() RETURNS TEXT AS $$
DECLARE
    prefix TEXT := 'http://fileserver.org/images/img_';
    extension TEXT := '.jpg';
BEGIN
    RETURN CONCAT(prefix, TO_CHAR(current_timestamp, 'YYYYMMDDHH24MISS'), extension);
END;
$$ LANGUAGE plpgsql;

--SELECT gate01.generate_photo_name();