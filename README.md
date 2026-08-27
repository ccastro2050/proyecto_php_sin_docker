# Proyecto PHP (sin Docker) — construcción por versiones

Proyecto de curso (USB Medellín). Aquí NO se descarga un sistema terminado:
**se construye un sistema real por versiones en PHP puro**, guiado por
especificaciones. El repositorio siempre contiene la **versión en curso,
funcionando** — usted la ejecuta, la estudia y luego la **reconstruye desde
cero** en su propio proyecto.

> 🐳 Esta es la variante **SIN Docker** del curso, para las salas donde no
> hay Docker Desktop: la BD vive en el MariaDB de **XAMPP** y la API corre
> con el servidor embebido de PHP. Si su máquina tiene Docker, existe la
> variante principal con contenedores:
> [proyecto_php](https://github.com/ccastro2050/proyecto_php) — misma API,
> misma spec, otra infraestructura.

---

## 1. Cómo le trabaja el estudiante (léame primero)

### Qué necesita instalado (una sola vez)

| Herramienta | Para qué |
|---|---|
| **Git** | Clonar el repositorio y traer versiones nuevas |
| **XAMPP** | Aporta la BD (MariaDB, puerto 3306) y phpMyAdmin — NO se usa su PHP |
| **PHP 8.3** (en el `PATH`) | El intérprete con el que corre la API (el de XAMPP es viejo: 8.0) |
| **VS Code** | El editor — y su terminal integrada (*Terminal → New Terminal*) |

> Verifique el PHP con `php -v` (debe decir 8.3.x) y que la extensión
> `pdo_mysql` esté habilitada (`php -m` debe listarla; si no, quítele el
> `;` a `extension=pdo_mysql` en el `php.ini`).

### Primera vez: cargar y EJECUTAR la versión (dos comandos)

1. Abra el **XAMPP Control Panel** y dele **Start** a **MySQL** (verde).
2. En la terminal integrada de VS Code (*Terminal → New Terminal*, PowerShell):

```powershell
git clone https://github.com/ccastro2050/proyecto_php_sin_docker.git
cd proyecto_php_sin_docker

# 1. Crear la BD en el MariaDB de XAMPP (solo la primera vez):
.\db\crear_bd.ps1

# 2. Arrancar la API (queda corriendo; se detiene con Ctrl+C):
cd api_facturas
php -S localhost:8022 index.php
```

**Eso es todo.** Quedan corriendo la base de datos (bdfacturas completa en
MariaDB) y la API:

| Qué | Dónde |
|---|---|
| **API Facturas** — diagnóstico | http://localhost:8022/ |
| Listar productos | http://localhost:8022/api/producto |
| **phpMyAdmin** (administrar MariaDB desde el navegador) | http://localhost/phpmyadmin (con Apache de XAMPP encendido) |
| MariaDB (para SQLTools/DBeaver, opcional) | `localhost:3306` · `paradigmas`/`paradigmas123` |

Pruebe la joya didáctica de la v1: PUT con solo `{"stock": 99}` → 422; el
mismo body en PATCH → 200. Esa diferencia es parte de lo que enseña la
versión (contratos exactos en el spec kit).

### Los días siguientes (volver a encender)

1. XAMPP Control Panel → **Start** a MySQL (los datos se conservan).
2. `php -S localhost:8022 index.php` desde `api_facturas\`.

### Cuando hay cambios

| Qué cambió | Qué hacer |
|---|---|
| **Usted edita un `.php`** | **Nada** — PHP reinterpreta cada petición: guardar y refrescar (F5) |
| **El profesor publicó una versión nueva** | `git pull` (la BD no cambia: es la misma desde v1) |
| **Quiere resetear la BD** a sus datos originales | Borre la BD (`DROP DATABASE bdfacturas_mariadb_local;` en phpMyAdmin) y re-corra `.\db\crear_bd.ps1` |
| **Apagar todo** | Ctrl+C en la terminal de la API; Stop a MySQL en el panel (opcional — los datos se conservan) |

### Y ahora, SU trabajo: reconstruirla desde cero

Ejecutar la versión del repo es solo el punto de partida. Lo que se evalúa es
**reconstruirla usted mismo, en una carpeta propia (fuera del clon)**,
siguiendo las especificaciones — con o sin ayuda de IA:

> 🤖 ¿Va a trabajar con IA? Siga la **[Guía para construir la versión con
> IA](docs/GUIA_IA.md)** — cubre los dos caminos con su prompt exacto listo
> para copiar: **chat web** (Gemini, DeepSeek, ChatGPT: qué archivos subirle)
> e **IDE agéntico** (Antigravity, Cursor, Claude Code: cómo supervisar al
> agente).

### Conceptos resumidos (los que acaba de usar)

| Concepto | En una frase |
|---|---|
| **Clonar** | Descargar el repositorio con su historial; `git pull` trae lo nuevo |
| **XAMPP** | El paquete que trae MariaDB y phpMyAdmin ya instalados — el panel los enciende y apaga |
| **`crear_bd.ps1`** | El inicializador: ejecuta `db/init.sql` en el MariaDB de XAMPP y deja la BD lista (idempotente) |
| **`php -S`** | El servidor web embebido de PHP: una terminal, un puerto, cero configuración |
| **PHP reinterpreta** | No hay "reload": cada petición vuelve a leer los `.php` — guardar y refrescar ES el ciclo |
| **Spec kit** | Los documentos que dicen QUÉ/CÓMO/EN QUÉ ORDEN — la fuente de verdad |
| **Versión / tag** | Un incremento cerrado y verificado (`v1`, `v2`, …): se avanza solo en verde |

> Detalle del entorno: [docs/ENTORNO_LOCAL.md](docs/ENTORNO_LOCAL.md).

---

## 2. Estructura del repositorio

Qué es cada carpeta y cada archivo, y para qué sirve:

```
proyecto_php_sin_docker/
├── db/
│   ├── init.sql                 # Crea bdfacturas COMPLETA (12 tablas, triggers, datos)
│   └── crear_bd.ps1             # El inicializador: la ejecuta en el MariaDB de XAMPP
│                                #   (idempotente; crea también el usuario del curso)
│
├── backupdb/                    # Respaldos (dumps) de la BD — su README explica
│                                #   cómo hacer el backup y cómo restaurarlo
│
├── postman/                     # La colección de Postman lista para importar:
│                                #   los endpoints de la v1 con clics (no hay Swagger
│                                #   en PHP puro — Postman cumple ese papel)
│
├── api_facturas/                # LA API DE LA v1 — PHP puro, sin framework (puerto 8022)
│   ├── index.php                # Front controller: TODA petición entra aquí y se enruta
│   ├── controladores/           # Capa 1 — HTTP: valida el body (422) y traduce a
│   │                            #   códigos de estado y JSON
│   ├── servicios/               # Capa 2 — negocio: interfaz, reglas y el ensamblador
│   │                            #   (la proto-fábrica que arma las capas)
│   ├── repositorios/            # Capa 3 — datos: interfaz + SQL con PDO para MariaDB
│   ├── modelos/                 # Producto: la clase entidad clásica (propiedades
│   │                            #   privadas + getters/setters + toArray)
│   ├── excepciones/             # NoEncontradoExcepcion (el servicio la lanza → 404)
│   └── pruebas/                 # prueba_capas.php: repositorio FALSO en memoria
│                                #   (demuestra que las capas se desacoplan de verdad)
├── docs/
│   ├── spec_kit/                # LAS ESPECIFICACIONES: constitución permanente +
│   │                            #   una carpeta de specs por versión (v1, v2, …)
│   ├── GUIA_IA.md               # Cómo reconstruir la versión desde 0 con ayuda de una IA
│   ├── ENTORNO_LOCAL.md         # XAMPP + php -S: el entorno de esta variante, explicado
│   ├── PARADIGMA_POO.md         # Material conceptual: POO, SOLID+capas, ACID
│   ├── SOLID_CAPAS_PATRONES.md         #   y SDD (un .md por tema)
│   ├── PRINCIPIOS_ACID.md       #
│   ├── SDD_SPECKIT.md           #
│   ├── TUTORIAL_PHPMYADMIN.md   # Tutoriales de administración de la BD, paso a paso
│   ├── TUTORIAL_VSCODE_SQLTOOLS.md  #   con capturas reales
│   └── img_phpmyadmin/ img_sqltools/  # Las capturas de esos tutoriales
│
├── .gitignore / .gitattributes  # Higiene del repo (ignora .session.sql, normaliza EOL)
└── README.md                    # Este archivo
```

La regla de lectura: **la infraestructura son XAMPP + `db/crear_bd.ps1`**,
la API vive en `api_facturas/` (una carpeta por capa), y **todo lo que
explica** vive en `docs/`. Cuando lleguen las versiones siguientes, aquí
aparecerán más carpetas de componentes.

## 3. La ruta de versiones

```
v1  api_facturas (PHP puro): CRUD de producto, solo MariaDB   ← USTED ESTÁ AQUÍ (cerrada: tag v1)
v2  más tablas (persona, factura maestro-detalle…)
v3  segundo motor (PostgreSQL) — nace la fábrica de repositorios
v4  tercer motor (SQL Server)
v5  frontend PHP
```

La regla del juego: la **constitución** es permanente, cada versión tiene su
propia spec, y una versión está TERMINADA solo cuando pasa sus criterios de
aceptación (se cierra con tag). Detalle completo:
**[mapa de versiones](docs/spec_kit/versiones/0_mapa_versiones.md)**.

## 4. Las especificaciones de la versión actual (v1)

| Documento | Qué contiene |
|---|---|
| [Constitución](docs/spec_kit/1_constitution.md) | Las reglas permanentes del proyecto (PHP puro, capas, arranque simple) |
| [2_spec.md](docs/spec_kit/versiones/v1_producto_mariadb/2_spec.md) | QUÉ construir y los 6 criterios de aceptación |
| [3_plan.md](docs/spec_kit/versiones/v1_producto_mariadb/3_plan.md) | CÓMO: stack, carpetas, capas e interfaces |
| [4_research.md](docs/spec_kit/versiones/v1_producto_mariadb/4_research.md) | Las decisiones y sus alternativas descartadas *(lectura opcional)* |
| [5_data_model.md](docs/spec_kit/versiones/v1_producto_mariadb/5_data_model.md) | La BD completa (dada) y la tabla `producto` que usa la v1 |
| [6_contracts.md](docs/spec_kit/versiones/v1_producto_mariadb/6_contracts.md) | Los 7 endpoints con formatos exactos (5 verbos HTTP) |
| [7_quickstart.md](docs/spec_kit/versiones/v1_producto_mariadb/7_quickstart.md) | Smoke test para validar lo construido |
| [8_tasks.md](docs/spec_kit/versiones/v1_producto_mariadb/8_tasks.md) | Las fases de construcción, en orden |

## 5. Material conceptual del curso

| Documento | Qué cubre |
|---|---|
| [El flujo de una petición](docs/FLUJO_DE_UNA_PETICION.md) | **Léalo primero:** dónde está el GET, dónde se captura el POST, y el viaje completo de una petición por las capas — con los comandos para probar los 5 verbos |
| [Colección de Postman](postman/README.md) | Los 13 endpoints de la v1 listos para importar y probar con clics — incluida la pareja PUT=422 vs PATCH=200 |
| [SDD y Spec Kit](docs/SDD_SPECKIT.md) | La metodología con la que se trabaja este curso: la spec manda sobre el código |
| [Calidad de las pruebas](docs/CALIDAD_DE_PRUEBAS.md) | Cobertura, la métrica CRAP y mutation testing: cómo saber si sus pruebas de verdad protegen — y por qué hoy es reto opcional, no alcance del proyecto |
| [El paradigma P.O.O. en PHP](docs/PARADIGMA_POO.md) | Qué es un paradigma, los 4 pilares, y las `interface` de PHP + la validación como frontera |
| [SOLID, capas y patrones de diseño](docs/SOLID_CAPAS_PATRONES.md) | Los 5 principios y las capas — y en qué versión se demuestra cada uno |
| [Principios ACID](docs/PRINCIPIOS_ACID.md) | Las 4 garantías transaccionales, por qué una facturación las exige, y el contraste con BASE |
| [El entorno local](docs/ENTORNO_LOCAL.md) | XAMPP (MariaDB + phpMyAdmin), el PHP 8.3 aparte y `php -S` — qué es cada pieza y cómo se relacionan |
| [Tutorial phpMyAdmin](docs/TUTORIAL_PHPMYADMIN.md) | Administrar bdfacturas desde el navegador: estructura, Diseñador, SQL, edición y respaldo — paso a paso con capturas |
| [Tutorial SQLTools (VS Code)](docs/TUTORIAL_VSCODE_SQLTOOLS.md) | La misma BD sin salir del editor: instalación, conexión, explorar y consultar — paso a paso con capturas |

---

*Proyecto PHP (sin Docker) · USB Medellín · Base de datos bdfacturas (facturación + RBAC).*
