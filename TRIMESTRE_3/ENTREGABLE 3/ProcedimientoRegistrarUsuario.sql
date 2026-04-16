CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrar_usuario_seguro`(
    IN p_nombres VARCHAR(45),
    IN p_apellidos VARCHAR(50),
    IN p_correo VARCHAR(150),
    IN p_password VARCHAR(255),
    IN p_rol INT
)
BEGIN
    DECLARE v_password_hash VARCHAR(255);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error al registrar usuario' AS mensaje;
    END;

    START TRANSACTION;

    -- Validar correo único
    IF EXISTS (SELECT 1 FROM Usuarios WHERE Correo = p_correo) THEN
        SELECT 'El correo ya está registrado' AS mensaje;
        ROLLBACK;
    ELSE

        -- Encriptar contraseña
        CALL sp_encriptar_password_sha2(p_password, v_password_hash);

        -- Insertar usuario
        INSERT INTO Usuarios (
            Nombres,
            Apellidos,
            Correo,
            Contrasena,
            Roles_idRoles
        )
        VALUES (
            p_nombres,
            p_apellidos,
            p_correo,
            v_password_hash,
            p_rol
        );

        COMMIT;

        SELECT 'Usuario registrado correctamente' AS mensaje;
    END IF;

END