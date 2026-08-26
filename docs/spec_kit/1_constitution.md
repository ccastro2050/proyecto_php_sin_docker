# Constitución del Proyecto PHP

> Principios **innegociables** que gobiernan todo el proyecto. Esta
> constitución es **permanente**: describe el sistema COMPLETO al que se llega
> al final, y no cambia entre versiones.
>
> El proyecto se construye **por versiones** (desarrollo incremental guiado por
> especificaciones): ver el [mapa de versiones](versiones/0_mapa_versiones.md).
> Cada artículo aplica desde la versión que introduce su alcance — por ejemplo,
> en la v1 solo existe `api_facturas` con MariaDB, así que los artículos
> sobre el front y los otros motores son la META, no el estado actual.

---

## Artículo 1 — Propósito didáctico ante todo

Este proyecto existe para **enseñar PHP construyendo software real con
arquitectura** a estudiantes universitarios. Ante cualquier disyuntiva entre
"lo más profesional" y "lo más claro para aprender", gana la claridad:

- Todo el código, comentarios, mensajes y documentación se escriben en **español**.
- Cada archivo abre con un comentario que explica su papel en la arquitectura.
- Se prefiere código explícito y repetitivo-pero-legible sobre metaprogramación compacta.

## Artículo 2 — PHP puro: sin framework y sin Composer

- **PHP 8.3+ "vanilla"**: cero dependencias externas, cero `composer.json`,
  cero `vendor/`. Lo que el estudiante ve es PHP del lenguaje, no magia de un
  framework.
- El enrutamiento vive en UN front controller (`index.php`) legible completo.
- Los contratos entre capas son **`interface` nativas de PHP** — el lenguaje
  las trae de fábrica; aquí se usan de verdad.
- El acceso a datos es **PDO** con *prepared statements*: el SQL queda
  **visible** (nada de ORM que lo esconda).

## Artículo 3 — Arquitectura de 3 capas estricta

```
CAPA 1: FRONT (PHP, :8000)    — solo pinta HTML y llama APIs; NUNCA toca la BD
CAPA 2: API (PHP)            — api_facturas :8022
CAPA 3: DATOS                 — PostgreSQL | MariaDB | SQL Server (bdfacturas)
```

- El front **no abre conexiones de base de datos**; solo habla HTTP con las APIs.
- Las APIs no generan HTML; solo JSON.
- Dentro de cada API: controlador → servicio → repositorio, comunicados por
  interfaces; solo el ensamblador conoce clases concretas.

## Artículo 4 — Arranque simple (SIN Docker)

Esta variante del curso corre **directo en Windows**, con dos piezas que
las salas ya tienen: **XAMPP** (que aporta MariaDB y phpMyAdmin) y
**PHP 8.3** instalado aparte (en el `PATH`). El arranque completo son
dos comandos, declarados aquí y en el quickstart:

1. `.\db\crear_bd.ps1` — una vez, con el MySQL de XAMPP encendido
   (crea la BD completa si no existe; es idempotente).
2. `php -S localhost:8022 index.php` — desde `api_facturas\`
   (el servidor web embebido de PHP; `index.php` es el router).

Sin instaladores exóticos ni pasos ocultos: si algo más hace falta,
va escrito en la documentación.

## Artículo 5 — Independencia del motor de base de datos

- El motor activo se elige con **configuración**, nunca con cambios de código.
- Los tres motores contienen la **misma base de datos** (`bdfacturas_*_local`):
  mismas 12 tablas, mismos datos, mismos triggers y procedimientos.
- Todo acceso a datos pasa por interfaces + un punto único de ensamblaje
  (inversión de dependencias — la D de SOLID).

## Artículo 6 — Persistencia y reproducibilidad

- Los datos viven en el MariaDB de XAMPP (`C:\xampp\mysql\data`):
  sobreviven a apagar el motor y reiniciar la máquina.
- El "botón de pánico" oficial para volver al estado de fábrica:
  borrar la BD y recrearla con el inicializador —
  `DROP DATABASE bdfacturas_mariadb_local;` (desde phpMyAdmin o mysql)
  y de nuevo `.\db\crear_bd.ps1`.

## Artículo 7 — Desarrollo con recarga natural

En PHP no hay "reload" que configurar: **cada petición HTTP
reinterpreta los archivos** — guardar un `.php` y refrescar el
navegador ES el ciclo de desarrollo. El servidor embebido (`php -S`)
no se reinicia nunca durante la clase.

## Artículo 8 — Convenciones fijas

| Cosa | Convención |
|---|---|
| Puertos públicos | front 8020 · · api_facturas **8022** (con `php -S`) |
| Puertos de BD | MariaDB **3306** (la de XAMPP) · PostgreSQL 5432 y SQL Server 1433 (instalaciones locales de versiones futuras) |
| phpMyAdmin | `http://localhost/phpmyadmin` (el de XAMPP, con Apache encendido) |
| Credenciales BD | la API usa `paradigmas` / `paradigmas123`; el administrador de XAMPP es `root` **sin clave** (solo para administrar y para `crear_bd.ps1`) |
| Bases de datos | `bdfacturas_postgres_local` · `bdfacturas_mariadb_local` · `bdfacturas_sqlserver_local` |
| Nombres de código | Clases e interfaces en PascalCase con prefijo `I` para interfaces; métodos y variables en camelCase; archivos = nombre de su clase |
| Estructura por API | `index.php` · `modelos/` · `controladores/` · `servicios/` · `repositorios/` · `excepciones/` |

## Artículo 9 — Seguridad en su justa medida académica

- Los valores SQL siempre van en **prepared statements** (nunca concatenados).
- Las contraseñas de usuarios de la aplicación se almacenan con **hash**
  (nunca texto plano en código nuevo).
- Las credenciales de infraestructura (paradigmas/paradigmas123) son públicas
  y didácticas **a propósito**: este entorno jamás se despliega a producción.
