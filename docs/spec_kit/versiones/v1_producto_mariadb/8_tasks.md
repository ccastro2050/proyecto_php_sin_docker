# Tareas — Versión 1: api_facturas con producto + MariaDB (PHP puro)

> **Versión 1** · El orden de construcción, partiendo de CERO. Cada fase termina
> en algo **verificable**. Requisitos: [2_spec.md](2_spec.md) · técnica:
> [3_plan.md](3_plan.md) · contratos: [6_contracts.md](6_contracts.md) ·
> validación final: [7_quickstart.md](7_quickstart.md).

---

## Fase 0 — Base de datos y esqueleto
- [ ] Copiar a `db/init.sql` el script **provisto** con esta versión (la BD
      `bdfacturas` COMPLETA en dialecto MariaDB — no se escribe ni se genera
      con IA; ver [5_data_model.md](5_data_model.md) §1).
- [ ] Copiar el inicializador provisto `db/crear_bd.ps1` y, con el MySQL
      de XAMPP encendido (panel de control → Start), correrlo desde la
      raíz: `.\db\crear_bd.ps1` (crea la BD completa y el usuario del
      curso; es idempotente — ver [3_plan.md](3_plan.md) §5).
- [ ] Crear la carpeta `api_facturas/` con subcarpetas `modelos/`,
      `controladores/`, `servicios/`, `repositorios/` y `excepciones/`.

**Verificar:** phpMyAdmin (`http://localhost/phpmyadmin`) ve las
**12 tablas** y `SELECT count(*) FROM producto` da **8**.

## Fase 1 — El modelo Producto (la clase entidad)
- [ ] `modelos/Producto.php`: la clase entidad al estilo clásico —
      4 propiedades **privadas** (`codigo` string, `nombre` string,
      `stock` int, `valorunitario` float), constructor que las asigna,
      **getters** para las 4, **setters** para las 3 que pueden cambiar
      (el código es la llave: sin setter) y `toArray()` que devuelve el
      array columna→valor para el JSON.

**Verificar:** en un script suelto (o `php -a`),
`$p = new Producto('PR001', 'Prueba', 5, 100.0);` construye el objeto,
`$p->getStock()` devuelve 5, `$p->setStock(9)` lo cambia, y
`json_encode($p->toArray())` devuelve el JSON con las 4 columnas.

## Fase 2 — Contratos (interfaces) y excepción de negocio
- [ ] `repositorios/IRepositorioProducto.php`: interface con los 5 métodos
      (`obtenerTodos(int $limite)`, `obtenerPorCodigo` — devuelve
      `?Producto` —, `crear(Producto $producto)`, `actualizar` — la usan
      PUT y PATCH — y `eliminar`). Las lecturas devuelven el MODELO.
- [ ] `servicios/IServicioProducto.php`: interface del servicio.
- [ ] `excepciones/NoEncontradoExcepcion.php`: la excepción que el
      controlador traducirá a 404.

**Verificar:** `php -l` pasa en los tres archivos (sintaxis válida).

## Fase 3 — Repositorio MariaDB
- [ ] `repositorios/RepositorioProductoMariaDB.php`: PDO perezoso
      (`ERRMODE_EXCEPTION`, `ATTR_EMULATE_PREPARES => false`), los 5 métodos
      con prepared statements de [3_plan.md](3_plan.md) §4.4, `:limite` con
      `PDO::PARAM_INT`, y un método privado `armarProducto(array $fila)` que
      convierte cada fila en objeto `Producto` casteando (`stock → int`,
      `valorunitario → float` — el driver entrega los números como texto).

**Verificar:** un script suelto que instancie el repositorio con el DSN de
`localhost:3306` lista los 8 productos y trae PR001 por código.

## Fase 4 — Servicio (y la prueba de capas)
- [ ] `servicios/ServicioProducto.php`: recibe `IRepositorioProducto` por
      constructor; valida reglas de negocio (`limite > 0`, código no vacío,
      PATCH sin campos → `InvalidArgumentException`); traduce "no existe" a
      `NoEncontradoExcepcion`.
- [ ] `servicios/ensamblador.php`: `crearServicioProducto()` — la función de
      [3_plan.md](3_plan.md) §4.3 (sin fábrica multi-motor: eso es v3).

**Verificar (criterio 6 de la spec):** `pruebas/prueba_capas.php` instancia
`ServicioProducto` con un **repositorio falso en memoria** (una clase con
`implements IRepositorioProducto` sobre un array) y hace
crear/listar/eliminar SIN MariaDB corriendo. Si esto funciona, las capas
quedaron bien.

## Fase 5 — Controlador y front controller
- [ ] `controladores/ControladorProducto.php`: los 6 métodos de producto con
      la validación del controlador (422), la traducción de excepciones de
      [3_plan.md](3_plan.md) §4.5 (400/404/500) y el 204 para lista vacía.
- [ ] `index.php`: requires, header JSON, router con `if` por ruta y verbo
      ([3_plan.md](3_plan.md) §4.6), endpoint `/` de diagnóstico y 404 por
      defecto.

**Verificar:** con la BD arriba y `php -S localhost:8022 index.php`,
probar: listar (200 con 8 y `?limite=3` con 3), obtener PR001
(200), PR999 (404), POST inválido (422 con `errores[]`), y el contraste
PUT vs PATCH con `{"stock": 7}` (422 vs 200).

## Fase 6 — El arranque completo, de memoria
- [ ] Verificar que el arranque desde cero funciona con los dos comandos
      de la constitución (Artículo 4): borrar la BD
      (`DROP DATABASE bdfacturas_mariadb_local;` desde phpMyAdmin),
      correr `.\db\crear_bd.ps1` y arrancar la API con
      `php -S localhost:8022 index.php` desde `api_facturas\`.

**Verificar:** los dos comandos dejan BD y API funcionando (criterio 1 de
la spec); editar un `.php`, guardar y refrescar muestra el cambio sin
reiniciar nada.

## Fase 7 — Cierre de la versión
- [ ] Correr el smoke test completo de [7_quickstart.md](7_quickstart.md) §2 —
      equivale a los 6 criterios de aceptación de [2_spec.md](2_spec.md) §5.
- [ ] `.gitignore` (`*.session.sql`, archivos de IDE).
- [ ] Commit y tag `v1`.

**La v1 está TERMINADA.** Solo ahora se escribe la spec de la v2
([mapa de versiones](../0_mapa_versiones.md)).
