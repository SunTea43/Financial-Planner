---
description: Develop a new feature given a description
---

# Workflow para Desarrollar una Nueva Funcionalidad

Este workflow permite desarrollar una funcionalidad completa dado una descripción, creando automáticamente una rama y un PR en GitHub.

## Pasos

1. **Describir la funcionalidad**
   - Proporciona una descripción clara de la funcionalidad que deseas implementar
   - Incluye detalles sobre qué debe hacer la funcionalidad
   - Menciona cualquier requisito específico o dependencia

2. **Crear una nueva rama**
   - Usa `mcp0_create_branch` para crear una rama nueva
   - El nombre de la rama debe ser descriptivo (ej: `feature/add-user-dashboard`)
   - Owner: el owner del repositorio (detectado automáticamente desde git remote)
   - Repo: el nombre del repositorio (detectado automáticamente desde git remote)
   - From branch: `main` (o la rama por defecto del proyecto)

3. **Desarrollar la funcionalidad**
   - Implementa los cambios necesarios en el código
   - Sigue las convenciones del proyecto (Ruby on Rails, Cells, SimpleForm, Bootstrap, etc.)
   - Asegúrate de que el código sea limpio y siga las mejores prácticas
   - Prueba la funcionalidad localmente
   - **Sigue estrictamente los lineamientos de commits** (ver `COMMIT_GUIDELINES.md`):
     - Formato: `<tipo>: <descripción>` (ej: `feat: add pie charts to balance sheet`)
     - Tipos permitidos: feat, fix, docs, style, refactor, perf, test, chore, ci
     - Usar presente imperativo ("add" no "added" ni "adding")
     - Primera letra minúscula
     - No terminar con punto
     - Limitar a 72 caracteres o menos
     - Ejemplos correctos:
       - `feat: configure email delivery with SMTP`
       - `fix: fix net worth calculation error`
       - `docs: add configuration documentation`

4. **Crear tests**
   - Escribe tests unitarios para los modelos y controladores modificados
   - Escribe tests de integración para las nuevas vistas
   - Escribe tests de sistema para flujos completos si es necesario
   - Ejecuta `bin/rails test` o `bin/rails test:system` según corresponda
   - **Itera en los tests hasta que todos pasen** antes de continuar
   - Si los tests fallan, corrige el código o los tests según sea necesario
   - Asegúrate de que no haya errores ni fallos en el suite de tests

5. **Ejecutar linters**
   - Ejecuta `bundle exec rubocop` para verificar el estilo del código
   - Ejecuta `bundle exec brakeman` para análisis de seguridad
   - Ejecuta `bundle exec bundler-audit` para verificar vulnerabilidades en gems
   - Corrige cualquier problema que encuentren los linters antes de continuar
   - Asegúrate de que el código siga las convenciones del proyecto

6. **Crear un Pull Request**
   - Usa `mcp0_create_pull_request` para crear el PR
   - Owner: el owner del repositorio (detectado automáticamente desde git remote)
   - Repo: el nombre del repositorio (detectado automáticamente desde git remote)
   - Head: el nombre de la rama que creaste
   - Base: `main`
   - Title: descripción breve de la funcionalidad
   - Body: usa la plantilla de PR (`.github/pull_request_template.md`) como base
   - Draft: `false` (para crear el PR directamente) o `true` (para crearlo como borrador)
   - Asegúrate de llenar todas las secciones relevantes de la plantilla

7. **Verificar el PR**
   - Revisa que el PR se haya creado correctamente
   - Verifica que los cambios estén incluidos
   - Espera a que se apruebe y se mergee

## Ejemplo de Uso

```bash
/develop-feature "Agregar un dashboard que muestre el resumen de todas las cuentas del usuario con gráficos de gastos mensuales"
```

Esto creará una rama `feature/add-user-dashboard`, implementará la funcionalidad, y creará un PR con los cambios.
