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

4. **Crear un Pull Request**
   - Usa `mcp0_create_pull_request` para crear el PR
   - Owner: el owner del repositorio (detectado automáticamente desde git remote)
   - Repo: el nombre del repositorio (detectado automáticamente desde git remote)
   - Head: el nombre de la rama que creaste
   - Base: `main`
   - Title: descripción breve de la funcionalidad
   - Body: descripción detallada de los cambios realizados
   - Draft: `false` (para crear el PR directamente) o `true` (para crearlo como borrador)

5. **Verificar el PR**
   - Revisa que el PR se haya creado correctamente
   - Verifica que los cambios estén incluidos
   - Espera a que se apruebe y se mergee

## Ejemplo de Uso

```bash
/develop-feature "Agregar un dashboard que muestre el resumen de todas las cuentas del usuario con gráficos de gastos mensuales"
```

Esto creará una rama `feature/add-user-dashboard`, implementará la funcionalidad, y creará un PR con los cambios.
