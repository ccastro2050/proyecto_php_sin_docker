# backupdb — respaldos de la base de datos

En esta carpeta se guardan los **respaldos (backups)** de `bdfacturas`.
En MySQL/MariaDB el respaldo clásico es un **dump**: un archivo `.sql`
con los `CREATE TABLE` y los `INSERT` de todo lo que hay — texto plano
que se puede abrir y leer.

> ¿En qué se diferencia de `db/init.sql`? En que ese script crea la BD
> en su **estado inicial** (los datos de fábrica del curso), mientras que
> un backup captura **SU estado actual**: lo que usted insertó, editó o
> borró. Si solo quiere volver al estado inicial, no necesita backup:
> borre la BD y re-corra `.\db\crear_bd.ps1`.

Convención de nombres: `bdfacturas_mariadb_AAAA-MM-DD.sql` (si hace
varios el mismo día, agregue un sufijo: `_2.sql`).

---

## Cómo hacer un backup

Con el MySQL de XAMPP encendido, desde la **raíz del repositorio** (un
solo comando; `mysqldump` es la herramienta de respaldo que trae XAMPP):

```powershell
& "C:\xampp\mysql\bin\mysqldump.exe" -u root --default-character-set=utf8mb4 --result-file="$PWD\backupdb\bdfacturas_mariadb_2026-08-09.sql" bdfacturas_mariadb_local
```

Qué hace cada pieza:

- `mysqldump -u root` — el respaldador, entrando como el administrador
  de XAMPP (root sin clave).
- `--default-character-set=utf8mb4` — el dump sale en UTF-8 (las tildes
  viajan intactas).
- `--result-file=...` — escribe DIRECTO al archivo (sin pasar por la
  consola de Windows, que dañaría la codificación). `$PWD` es la carpeta
  actual — por eso se corre desde la raíz del repo.

El dump lleva las **tablas, sus datos y sus triggers** (los triggers van
incluidos por defecto). Los **procedimientos almacenados NO se
respaldan a propósito**: no cambian con el uso (los provee `db/init.sql`
y el restore no los toca) — y de paso se evita un defecto del MariaDB
de XAMPP, que puede caerse al restaurarlos (`--routines`).

## Cómo restaurar un backup (restore)

El camino inverso: ejecutar el dump sobre la BD. El comando `source` lee
el archivo directo del disco (mysql entiende rutas con `/`):

```powershell
& "C:\xampp\mysql\bin\mysql.exe" -u root --default-character-set=utf8mb4 -D bdfacturas_mariadb_local -e "source backupdb/bdfacturas_mariadb_2026-08-09.sql"
```

> Se restaura como **root** porque el dump incluye los triggers y
> procedimientos con su "dueño" (`DEFINER`), y solo un administrador
> puede recrearlos a nombre de otro.

Verifique: `http://localhost:8022/api/producto` (con la API corriendo)
debe mostrar los datos tal como estaban cuando hizo el backup.

## Para probar el ciclo completo (ejercicio)

1. Haga un backup (arriba).
2. Cambie algo a propósito: cree un producto `PR999` con la API (POST
   desde Postman) o edite el stock de uno existente.
3. Restaure el backup.
4. `PR999` desapareció (o el stock volvió) — la BD regresó EXACTAMENTE
   al momento del backup. Eso es un respaldo funcionando.

> ⚠️ El restore pisa el contenido actual de la BD con el del archivo.
> Lo que haya cambiado DESPUÉS del backup se pierde. Por eso los
> respaldos se hacen ANTES de operaciones riesgosas (y en producción,
> con agenda).
