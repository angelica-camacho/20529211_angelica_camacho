# PREGUNTAS UNIDAD 2: CREAR UNA POLÍTICA MÍNIMA DE PROTECCIÓN DE CLAVES
_Camacho Castañeda Angélica María 4-1 Lic. En Informática_

### POLÍTICAS PARA GESTIÓN DE CLAVES CRIPTOGRÁFICAS
1. Dar permiso únicamente a personal autorizado para que pueda accesar a las tablas donde se encuentra la información cifrada
2. Modificar periodicamente las claves criptográficas.
3. Generar las claves criptográficas utilizando generadores de números pseudoaleatorios criptográficamente seguros (CSPRNG).
4. Almacenar las claves criptográficas en un gestor de secretos como HashiCorp Vault, manteniéndolas alejadas del código fuente.
5. Eliminar la clave ya que cumpla su ciclo de vida y que no sea necesaria para descifrar datos históricos, y impedir que estas se puedan recuperar.
