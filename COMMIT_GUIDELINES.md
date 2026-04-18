# Lineamientos para Commits

Este documento establece los lineamientos para los mensajes de commit en el proyecto Financial-Planner.

## Convención de Commits

Utilizamos una convención basada en [Conventional Commits](https://www.conventionalcommits.org/). Los mensajes de commit deben seguir el formato:

```text
<tipo>: <descripción>
```

## Tipos de Commits

Los siguientes tipos son permitidos en el prefijo del commit:

- **feat**: Nueva funcionalidad para el usuario
  - Ejemplo: `feat: agrega gráficos de torta al reporte de balance general`

- **fix**: Corrección de un bug
  - Ejemplo: `fix: corrige error al calcular el patrimonio neto`

- **docs**: Cambios en la documentación
  - Ejemplo: `docs: agrega documentación para las tablas de balance`

- **style**: Cambios que no afectan el significado del código (espacios, formato, etc.)
  - Ejemplo: `style: formatea código según rubocop`

- **refactor**: Cambio de código que no corrige un bug ni agrega funcionalidad
  - Ejemplo: `refactor: simplifica cálculo de totales en balance sheet`

- **perf**: Cambio que mejora el rendimiento
  - Ejemplo: `perf: optimiza consulta de balance sheets`

- **test**: Agregar o modificar tests
  - Ejemplo: `test: agrega tests para controlador de balance sheets`

- **chore**: Cambios en el proceso de build o herramientas auxiliares
  - Ejemplo: `chore: actualiza versión de ruby a 4.0.0`

- **ci**: Cambios en los archivos de configuración de CI
  - Ejemplo: `ci: agrega workflow de linters en GitHub Actions`

## Formato del Mensaje

### Reglas

- Usar presente imperativo ("agrega" no "agregó" ni "agregando")
- La primera letra del mensaje debe ser minúscula
- No terminar el mensaje con punto
- Limitar la primera línea a 72 caracteres o menos
- Usar el cuerpo del mensaje para explicar el "qué" y el "por qué" (no el "cómo")
- Separar el título del cuerpo con una línea en blanco

### Ejemplos Correctos

```text
feat: agrega gráficos de torta al reporte de balance general

Implementa visualización de activos y pasivos usando Chart.js.
Los gráficos agrupan activos por categoría y pasivos por tipo.
```

```text
fix: corrige error al calcular el patrimonio neto

El cálculo no consideraba activos con valor cero,
lo que causaba un resultado incorrecto en algunos casos.
```

```text
docs: agrega documentación para las tablas de balance
```

### Ejemplos Incorrectos

```text
feat: Agregué gráficos de torta
feat: agrega gráficos de torta al reporte de balance general.
feat: agrega gráficos de torta al reporte de balance general, también incluye pasivos
FEAT: agrega gráficos
```

## Commits con Breaking Changes

Si el commit introduce un cambio que rompe la compatibilidad, agregue `!` después del tipo y agregue una nota `BREAKING CHANGE:` en el cuerpo:

```text
feat!: cambia el formato de API de balance sheets

BREAKING CHANGE: El endpoint ahora requiere autenticación JWT
en lugar de token de sesión.
```

## Commits con Scope

Opcionalmente, puedes agregar un scope después del tipo para proporcionar contexto adicional:

```
feat(balance_sheet): agrega gráficos de torta
fix(user): corrige error en validación de email
docs(api): actualiza documentación de endpoints
```

## Recomendaciones

- Hacer commits pequeños y enfocados
- Commits más grandes deben ser divididos en commits más pequeños
- Commits deben ser comprensibles sin necesidad de ver el código
- Usar el cuerpo del commit para explicar el contexto cuando sea necesario
- Revisar los cambios antes de hacer commit para asegurar que solo se incluye lo necesario

## Herramientas

El proyecto incluye configuración de rubocop para asegurar consistencia en el código. Asegúrate de ejecutar `bundle exec rubocop` antes de hacer commit.
