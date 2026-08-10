# ==============================================================
# crear_bd.ps1 — crea la base de datos bdfacturas en el MariaDB
# de XAMPP.
#
# XAMPP trae MariaDB (el panel lo llama "MySQL") ya instalado:
# el mismo motor del curso, sin instalar ni configurar nada más.
# Este script hace lo que en otros entornos hace un inicializador:
# verifica que el motor esté encendido, ejecuta el script provisto
# db/init.sql (que crea la BD completa con sus 12 tablas, triggers,
# procedimientos y datos) y crea el usuario del curso.
#
# Es IDEMPOTENTE: correrlo mil veces no daña nada — si la BD ya
# existe, no hace nada.
#
# ANTES de correrlo: abra el XAMPP Control Panel y dele Start a
# MySQL (debe quedar en verde, puerto 3306).
#
# Uso (desde la raíz del proyecto):
#   .\db\crear_bd.ps1
#
# Para crear una BD con OTRO nombre (por ejemplo la de SU
# reconstrucción de la guía de IA):
#   .\db\crear_bd.ps1 -NombreBd bdfacturas_mi_v1
# ==============================================================

# param() declara los parámetros del script; si no se pasa nada,
# se usa el nombre de la BD del curso:
param(
    [string]$NombreBd = "bdfacturas_mariadb_local"
)

# El cliente de línea de comandos de MariaDB que trae XAMPP.
# (Si su XAMPP está en otra carpeta, ajuste esta ruta.)
$mysql = "C:\xampp\mysql\bin\mysql.exe"

if (-not (Test-Path $mysql)) {
    Write-Host "[crear_bd] ERROR: no se encontró $mysql"
    Write-Host "[crear_bd] ¿XAMPP está instalado en C:\xampp?"
    exit 1
}

# $PSScriptRoot = la carpeta donde vive ESTE script (db\), así el
# script funciona sin importar desde dónde se llame:
$script = Join-Path $PSScriptRoot "init.sql"

Write-Host "[crear_bd] Verificando que MySQL/MariaDB esté encendido..."
# -u root = el usuario administrador (en XAMPP viene SIN clave);
# -e = ejecutar esta consulta y salir. Si falla, el motor está apagado:
& $mysql -u root -e "SELECT 1" *> $null
if ($LASTEXITCODE -ne 0) {
    Write-Host "[crear_bd] ERROR: MySQL no responde."
    Write-Host "[crear_bd] Abra el XAMPP Control Panel y dele Start a MySQL."
    exit 1
}

Write-Host "[crear_bd] Asegurando el usuario del curso (paradigmas)..."
# La API NO se conecta como root: usa el usuario del curso, igual que
# en producción se usa un usuario con permisos limitados a SU base.
# Esto corre SIEMPRE (aunque la BD ya exista): es idempotente gracias
# al IF NOT EXISTS. Se crea para 'localhost' y '127.0.0.1' porque
# MariaDB los trata como orígenes distintos:
& $mysql -u root -e "CREATE USER IF NOT EXISTS 'paradigmas'@'localhost' IDENTIFIED BY 'paradigmas123'; CREATE USER IF NOT EXISTS 'paradigmas'@'127.0.0.1' IDENTIFIED BY 'paradigmas123'; GRANT ALL PRIVILEGES ON ``$NombreBd``.* TO 'paradigmas'@'localhost'; GRANT ALL PRIVILEGES ON ``$NombreBd``.* TO 'paradigmas'@'127.0.0.1'; FLUSH PRIVILEGES;"

Write-Host "[crear_bd] Verificando si la base de datos $NombreBd existe..."
# information_schema.schemata = el catálogo de bases de datos del motor.
# -N -s = salida limpia (solo el valor, sin encabezados ni bordes):
$existe = & $mysql -u root -N -s -e "SELECT COUNT(*) FROM information_schema.schemata WHERE schema_name = '$NombreBd'"

if ("$existe".Trim() -eq "1") {
    Write-Host "[crear_bd] La base de datos $NombreBd ya existe. No se hace nada."
    exit 0
}

Write-Host "[crear_bd] Ejecutando init.sql (12 tablas, triggers, SPs y datos)..."
# init.sql trae el nombre de la BD del curso escrito adentro. Si se
# pidió OTRO nombre (la reconstrucción del estudiante), se genera una
# copia temporal del script con el nombre cambiado:
$aEjecutar = $script
if ($NombreBd -ne "bdfacturas_mariadb_local") {
    $temporal = Join-Path $env:TEMP "init_$NombreBd.sql"
    (Get-Content $script -Raw -Encoding UTF8).Replace("bdfacturas_mariadb_local", $NombreBd) |
        Set-Content $temporal -Encoding UTF8
    $aEjecutar = $temporal
}

# El comando "source" hace que mysql lea el archivo DIRECTO del disco
# (sin pasar por la consola de Windows, que dañaría las tildes), y
# --default-character-set=utf8mb4 fija la conexión en UTF-8.
# mysql entiende las rutas con / aunque estemos en Windows:
$rutaMysql = $aEjecutar.Replace("\", "/")
& $mysql --default-character-set=utf8mb4 -u root -e "source $rutaMysql"
if ($LASTEXITCODE -ne 0) {
    Write-Host "[crear_bd] ERROR ejecutando init.sql."
    exit 1
}

Write-Host "[crear_bd] Listo: $NombreBd creada con sus 12 tablas y datos de ejemplo."
