# Financial Planner

Aplicación web para organizar finanzas personales desarrollada con Ruby on Rails 8.

## Características

- **Gestión de Cuentas**: Crea y gestiona múltiples cuentas de diferentes tipos (corriente, ahorros, inversión, tarjeta de crédito, préstamos, etc.)
- **Balance General**: Registra activos líquidos, activos fijos, pasivos y calcula automáticamente el patrimonio neto. Almacena fecha y hora exacta del registro.
- **Presupuestos**: Crea presupuestos con periodicidad configurable (mensual por defecto) definiendo ingresos, gastos y cálculo automático del flujo de caja libre.
- **Reportes**: Genera reportes de balance general con filtros por cuenta y fechas, mostrando totales y promedios de patrimonio neto.

## Tecnologías

- **Ruby on Rails 8.1.1**
- **PostgreSQL** como base de datos
- **Devise** para autenticación de usuarios
- **Cells** (Trailblazer Cells pattern) para componentes de vista reutilizables
- **SimpleForm** para formularios con integración Bootstrap
- **Bootstrap 5** para estilos CSS
- **Hotwire** (Turbo + Stimulus) para interactividad

## Configuración

### Prerequisitos

- Ruby 3.2.2 o superior
- PostgreSQL
- Node.js (para Bootstrap)
- Yarn

### Instalación

1. Clonar el repositorio
2. Instalar dependencias:
   ```bash
   bundle install
   yarn install
   ```
3. Configurar la base de datos:
   ```bash
   rails db:create
   rails db:migrate
   ```
4. Iniciar el servidor:
   ```bash
   bin/dev
   ```

La aplicación estará disponible en `http://localhost:3000`

## Estructura de la Aplicación

### Modelos Principales

- **User**: Usuarios con autenticación Devise
- **Account**: Cuentas asociadas a usuarios (checking, savings, investment, etc.)
- **BalanceSheet**: Balance general con fecha/hora de registro
- **Asset**: Activos (líquidos y fijos) asociados a un balance
- **Liability**: Pasivos (corto y largo plazo) asociados a un balance
- **Budget**: Presupuestos con periodicidad configurable
- **BudgetItem**: Items de presupuesto (ingresos y gastos)

### Características Técnicas

- Autenticación completa con Devise
- Cells para componentes de vista (ej: `BalanceSheetCell`)
- Formularios con SimpleForm y Bootstrap
- Validaciones en modelos
- Cálculos automáticos (patrimonio neto, flujo de caja)
- Filtros y reportes personalizados

## Uso

1. **Registro/Login**: Crea una cuenta o inicia sesión
2. **Crear Cuentas**: Desde el menú, crea tus cuentas financieras
3. **Registrar Balance General**: Crea un balance general con tus activos y pasivos actuales
4. **Crear Presupuestos**: Define presupuestos mensuales (u otra periodicidad) con ingresos y gastos
5. **Ver Reportes**: Genera reportes filtrados de tus balances generales

## Desarrollo

La aplicación utiliza:
- Cells para componentes de vista reutilizables
- Hotwire (Turbo/Stimulus) para actualizaciones dinámicas sin escribir JavaScript complejo
- Bootstrap para un diseño responsive y moderno
- SimpleForm para formularios consistentes

## Licencia

Este proyecto es de uso personal.
