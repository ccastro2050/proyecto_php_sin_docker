# Quickstart — Versión 1: producto + MariaDB (PHP puro)

> **Versión 1** · Validación rápida de la v1 ya construida. Si aún no hay
> nada, empiece por [8_tasks.md](8_tasks.md).

---

## 1. Arrancar TODO (dos comandos)

Prerrequisitos (una sola vez por máquina): **XAMPP** con su MySQL
encendido (panel de control → Start) y **PHP 8.3** en el `PATH`
(verifique con `php -v`).

```powershell
# desde la raíz del proyecto (terminal integrada de VS Code):

# 1. Crear la BD (solo la primera vez — es idempotente):
.\db\crear_bd.ps1

# 2. Arrancar la API (queda corriendo; se detiene con Ctrl+C):
cd api_facturas
php -S localhost:8022 index.php
```

Eso deja la BD (bdfacturas completa en el MariaDB de XAMPP) y la API
PHP corriendo. No hay venv ni dependencias que instalar: **PHP no
necesita nada más**.

## 2. Smoke test (los 6 criterios de aceptación, en orden)

```powershell
# 1. Diagnóstico (y de paso: edite el mensaje en index.php, guarde y
#    refresque — el cambio aparece SIN reiniciar nada: PHP reinterpreta)
curl http://localhost:8022/

# 2. Listar — los 8 productos, y el query string en acción
curl http://localhost:8022/api/producto                      # total: 8
curl "http://localhost:8022/api/producto?limite=3"           # total: 3

# 3. Obtener uno / inexistente (parámetro de ruta)
curl http://localhost:8022/api/producto/PR001    # 200 Laptop Lenovo
curl -i http://localhost:8022/api/producto/PR999 # 404

# 4. Ciclo con los 5 verbos
curl -X POST http://localhost:8022/api/producto -H "Content-Type: application/json" `
     -d '{\"codigo\":\"PR009\",\"nombre\":\"Webcam Logitech\",\"stock\":5,\"valorunitario\":120000}'
curl -X PUT  http://localhost:8022/api/producto/PR009 -H "Content-Type: application/json" `
     -d '{\"nombre\":\"Webcam Logitech C920\",\"stock\":10,\"valorunitario\":150000}'   # reemplazo COMPLETO
curl -X PATCH http://localhost:8022/api/producto/PR009 -H "Content-Type: application/json" `
     -d '{\"stock\":7}'                                       # parcial: solo el stock
curl http://localhost:8022/api/producto/PR009    # nombre C920, stock = 7
curl -X DELETE http://localhost:8022/api/producto/PR009
curl -i -X DELETE http://localhost:8022/api/producto/PR009   # 404 (ya no existe)

# 4b. La diferencia PUT vs PATCH — el MISMO body, distinto veredicto
curl -i -X PUT   http://localhost:8022/api/producto/PR001 -H "Content-Type: application/json" `
     -d '{\"stock\":99}'    # 422: a PUT le faltan nombre y valorunitario
curl -i -X PATCH http://localhost:8022/api/producto/PR001 -H "Content-Type: application/json" `
     -d '{\"stock\":17}'    # 200: PATCH acepta el subconjunto

# 5. La validación como frontera — nunca llega a la BD
curl -i -X POST http://localhost:8022/api/producto -H "Content-Type: application/json" `
     -d '{\"codigo\":\"PRX\",\"nombre\":\"Test\",\"stock\":-5,\"valorunitario\":100}'   # 422 con errores[]
curl -i -X POST http://localhost:8022/api/producto -H "Content-Type: application/json" `
     -d '{\"codigo\":\"PR001\",\"nombre\":\"Dup\",\"stock\":1,\"valorunitario\":1}' # 500 (PK duplicada)

# extra: PATCH body vacío y límite inválido (reglas de negocio → 400)
curl -i -X PATCH http://localhost:8022/api/producto/PR001 -H "Content-Type: application/json" -d '{}'
curl -i "http://localhost:8022/api/producto?limite=0"
```

**6. Prueba de capas** (sin MariaDB): un script que instancie
`ServicioProducto` con un repositorio falso en memoria que implemente
`IRepositorioProducto` y verifique crear/listar/eliminar — si funciona, las
capas quedaron bien cortadas ([8_tasks.md](8_tasks.md) Fase 4). Se corre con
`php` a secas (desde `api_facturas\`; ni siquiera necesita la BD encendida):

```powershell
php pruebas/prueba_capas.php
```

## 3. Si algo falla

| Síntoma | Causa probable |
|---|---|
| `could not find driver` | Falta la extensión `pdo_mysql` en su PHP: habilítela en `php.ini` (quite el `;` a `extension=pdo_mysql`) |
| 500 en todos los endpoints con "denegó dicha conexión" | El MySQL de XAMPP está apagado — dele Start en el panel de control |
| `Parse error ... readonly` | Está corriendo la API con un PHP viejo (el de XAMPP es 8.0): use el PHP 8.3 del `PATH` (`php -v` para verificar) |
| 204 donde esperaba los 8 productos | La tabla está vacía: borre la BD y re-corra `.\db\crear_bd.ps1` |
| El `LIMIT` falla con error de sintaxis | El `:limite` se enlazó como string — debe ser `bindValue(..., PDO::PARAM_INT)` ([3_plan.md](3_plan.md) §4.4) |
| PATCH con el mismo valor responde 404 | Falta `PDO::MYSQL_ATTR_FOUND_ROWS => true` en la conexión: sin él, MariaDB reporta 0 filas cuando el valor no cambió ([3_plan.md](3_plan.md) §4.4) |
| Edité un `.php` y no veo el cambio | Caché del navegador: fuerce con Ctrl+F5 (PHP siempre reinterpreta; el navegador a veces no) |
| Puerto 8022 ocupado | Otra API suya quedó corriendo — busque la terminal donde corre `php -S` y deténgala con Ctrl+C |
