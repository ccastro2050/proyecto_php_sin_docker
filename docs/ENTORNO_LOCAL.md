# El entorno local — XAMPP + PHP 8.3 + `php -S`

> El "motor" de esta variante del curso: qué es cada pieza, por qué está
> ahí y cómo se relacionan. Es el documento análogo al de conceptos de
> infraestructura de cualquier proyecto — aquí la infraestructura no son
> contenedores sino **programas instalados en su Windows**.

---

## 1. Las tres piezas

```
XAMPP ──► MariaDB  (localhost:3306)   ← la base de datos bdfacturas
      └─► Apache + phpMyAdmin (http://localhost/phpmyadmin) ← administrarla

PHP 8.3 (aparte, en el PATH) ──► php -S localhost:8022  ← LA API
```

| Pieza | Qué aporta | Qué NO se le usa |
|---|---|---|
| **XAMPP** | MariaDB (la BD) y phpMyAdmin (administración web) | Su PHP (es 8.0, viejo para el curso) |
| **PHP 8.3** | El intérprete que corre la API | — |
| **`php -S`** | El servidor web embebido del propio PHP | — |

## 2. XAMPP: el panel de control

XAMPP es un paquete clásico de las salas académicas: trae **Apache**,
**MariaDB** (el panel lo llama "MySQL"), **PHP** y **phpMyAdmin** ya
instalados en `C:\xampp`. Su **Control Panel** es el tablero de
encendido:

- **MySQL → Start**: enciende el MariaDB en el puerto **3306**. Es el
  único servicio OBLIGATORIO para el curso — la API se conecta ahí.
- **Apache → Start**: enciende el servidor web de XAMPP en el puerto 80,
  necesario solo para usar **phpMyAdmin** (`http://localhost/phpmyadmin`).
- Los datos de MariaDB viven en `C:\xampp\mysql\data`: sobreviven a Stop,
  a cerrar el panel y a reiniciar la máquina.

> El usuario administrador del MariaDB de XAMPP es `root` **sin clave**
> (así viene de fábrica; aceptable para una máquina de estudio). La API
> no lo usa: se conecta con el usuario del curso
> (`paradigmas`/`paradigmas123`) que crea `db\crear_bd.ps1` — la misma
> higiene de producción: cada aplicación con su usuario limitado.

## 3. ¿Y por qué no el PHP de XAMPP?

El XAMPP de las salas trae **PHP 8.0**, y el código del curso usa
construcciones de PHP moderno (por ejemplo `readonly`, que existe desde
la 8.1). Por eso la API corre con un **PHP 8.3 instalado aparte** (el
zip oficial de php.net, descomprimido y agregado al `PATH`).

Verificaciones (en cualquier terminal):

```powershell
php -v      # debe decir PHP 8.3.x
php -m      # debe listar pdo_mysql (la extensión que habla con MariaDB)
```

Si `pdo_mysql` no aparece: en el `php.ini` del PHP 8.3, quite el `;` a
la línea `;extension=pdo_mysql` (y verifique que `extension_dir` apunte
a la carpeta `ext` de esa instalación).

## 4. `php -S`: el servidor embebido

PHP trae su propio servidor web para desarrollo — una terminal, un
puerto, cero configuración:

```powershell
cd api_facturas
php -S localhost:8022 index.php
```

- `-S localhost:8022` — escuche en ese puerto.
- `index.php` al final — el **router**: TODA petición (también
  `/api/producto/PR001`) entra por ese archivo, que es exactamente el
  diseño del front controller de la v1.
- La terminal queda "ocupada" mostrando cada petición que llega — eso es
  el log. Se detiene con **Ctrl+C**.

Y la propiedad más cómoda del curso: **PHP reinterpreta los archivos en
cada petición**. Guardar un `.php` y refrescar el navegador ES el ciclo
de desarrollo — no hay build, no hay reload, no hay reinicio.

## 5. El botón de pánico

¿La BD quedó en mal estado por un experimento? Volver al estado de
fábrica son dos pasos (el Artículo 6 de la constitución):

```sql
-- en phpMyAdmin (pestaña SQL) o con el cliente mysql:
DROP DATABASE bdfacturas_mariadb_local;
```

```powershell
.\db\crear_bd.ps1     # desde la raíz del repo — la recrea completa
```

## 6. Este entorno y la variante con Docker

Este curso tiene un repositorio gemelo que corre las MISMAS piezas en
contenedores: [proyecto_php](https://github.com/ccastro2050/proyecto_php).
La API y las especificaciones son idénticas; cambia solo quién pone la
infraestructura:

| | Esta variante (sin Docker) | La variante con Docker |
|---|---|---|
| MariaDB | El de XAMPP (`localhost:3306`) | Contenedor (`localhost:13326`) |
| Crear la BD | `.\db\crear_bd.ps1` | Automático al primer arranque |
| phpMyAdmin | El de XAMPP (`http://localhost/phpmyadmin`) | Contenedor (`http://localhost:8101`) |
| La API | `php -S` con su PHP 8.3 | Contenedor con PHP 8.3 |
| Encender | Panel XAMPP + un comando | `docker compose up -d` |
| Resetear la BD | `DROP DATABASE` + `crear_bd.ps1` | `docker compose down -v` + `up -d` |

La lección de fondo es la misma en ambos: la aplicación no sabe ni le
importa DÓNDE corre su base de datos — solo conoce un DSN que llega por
configuración.
