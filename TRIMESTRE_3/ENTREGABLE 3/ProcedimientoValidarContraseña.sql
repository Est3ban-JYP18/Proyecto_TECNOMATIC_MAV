CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_validar_password_sha2`(
    IN p_password_intento VARCHAR(255),
    IN p_password_hash_almacenado VARCHAR(255),
    OUT p_es_valida BOOLEAN
)
BEGIN
    DECLARE v_salt VARCHAR(64);
    DECLARE v_hash_guardado VARCHAR(128);
    DECLARE v_hash_calculado VARCHAR(128);

    -- Separar salt y hash
    SET v_salt = SUBSTRING_INDEX(p_password_hash_almacenado, ':', 1);
    SET v_hash_guardado = SUBSTRING_INDEX(p_password_hash_almacenado, ':', -1);

    -- Recalcular hash
    SET v_hash_calculado = SHA2(CONCAT(p_password_intento, v_salt), 256);

    -- Comparar
    IF v_hash_calculado = v_hash_guardado THEN
        SET p_es_valida = TRUE;
    ELSE
        SET p_es_valida = FALSE;
    END IF;
END