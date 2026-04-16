CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_encriptar_password_sha2`(
    IN p_password VARCHAR(255),
    OUT p_password_hash VARCHAR(255)
)
BEGIN
    DECLARE v_salt VARCHAR(64);
    DECLARE v_hash VARCHAR(128);

    IF p_password IS NULL OR p_password = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La contraseña no puede estar vacía';
    END IF;

    -- Generar SALT
    SET v_salt = SHA2(CONCAT(UUID(), NOW()), 256);

    -- Generar HASH con SALT
    SET v_hash = SHA2(CONCAT(p_password, v_salt), 256);

    -- Guardar formato: salt:hash
    SET p_password_hash = CONCAT(v_salt, ':', v_hash);
END