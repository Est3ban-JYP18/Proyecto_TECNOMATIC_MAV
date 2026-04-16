USE tecnomaticmav;

CALL sp_registrar_usuario_seguro(
    'Maria',
    'Rodriguez',
    'maria@email.com',
    'MiClaveSegura123*',
    3
);

SELECT Correo, Contrasena 
FROM Usuarios 
WHERE Correo = 'maria@email.com';