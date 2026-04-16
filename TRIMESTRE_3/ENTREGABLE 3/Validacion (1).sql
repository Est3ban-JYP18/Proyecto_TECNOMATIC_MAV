USE tecnomaticmav;

SET @correo_buscar = 'dylan@test.com';
SET @password_probar = '123456';

SELECT 
    u.idUsuarios,
    u.Correo,
    u.Contrasena,

    SUBSTRING_INDEX(u.Contrasena COLLATE utf8mb4_general_ci, ':' COLLATE utf8mb4_general_ci, 1) AS salt,
    SUBSTRING_INDEX(u.Contrasena COLLATE utf8mb4_general_ci, ':' COLLATE utf8mb4_general_ci, -1) AS hash

INTO 
    @id_usuario,
    @correo,
    @hash_completo,
    @salt,
    @hash_guardado

FROM Usuarios u
WHERE u.Correo = @correo_buscar
LIMIT 1;

SELECT 
    @correo_buscar AS usuario,
    @hash_completo AS hash_completo,
    @salt AS salt_extraido,
    @hash_guardado AS hash_guardado;
    
    SET @resultado = FALSE;

CALL sp_validar_password_sha2(
    @password_probar,
    @hash_completo,
    @resultado
);

SELECT 
    @correo_buscar AS usuario,
    @password_probar AS contraseña_probada,
    @resultado AS es_valida,

    CASE @resultado 
        WHEN 1 THEN 'CONTRASEÑA CORRECTA - Acceso permitido'
        WHEN 0 THEN 'CONTRASEÑA INCORRECTA - Acceso denegado'
    END AS resultado_legible;