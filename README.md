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

4. Configurar variables de entorno (ver sección de Configuración de Email)

5. Iniciar el servidor:

   ```bash
   bin/dev
   ```

La aplicación estará disponible en `http://localhost:3000`

### Configuración de Email

La aplicación está configurada para enviar correos electrónicos. Para habilitar esta funcionalidad, necesitas configurar las siguientes variables de entorno:

#### Variables de Entorno Requeridas

Copia el archivo `.env.example` a `.env` y configura las variables:

```bash
cp .env.example .env
```

Las variables requeridas son:

- **SMTP_ADDRESS**: Dirección del servidor SMTP (default: smtp.gmail.com)
- **SMTP_PORT**: Puerto del servidor SMTP (default: 587)
- **SMTP_DOMAIN**: Dominio del servidor SMTP
- **SMTP_USER_NAME**: Usuario de SMTP (tu email)
- **SMTP_PASSWORD**: Contraseña de SMTP (para Gmail, usa una contraseña de aplicación)
- **SMTP_FROM_ADDRESS**: Dirección de remitente por defecto
- **APP_HOST**: Dominio de la aplicación (para producción)
- **SECRET_KEY_BASE**: Clave secreta de Rails (genera con `bin/rails secret`)

#### Configuración para Gmail

Si usas Gmail como servidor SMTP:

1. Habilita la autenticación de dos factores en tu cuenta de Google
2. Genera una contraseña de aplicación en <https://myaccount.google.com/apppasswords>
3. Usa la contraseña de aplicación como `SMTP_PASSWORD`
4. Configura las variables de entorno:

   ```bash
   SMTP_ADDRESS=smtp.gmail.com
   SMTP_PORT=587
   SMTP_DOMAIN=gmail.com
   SMTP_USER_NAME=tu-email@gmail.com
   SMTP_PASSWORD=tu-contraseña-de-aplicación
   SMTP_FROM_ADDRESS=noreply@tu-dominio.com
   APP_HOST=tu-dominio.com
   ```

#### Entorno de Desarrollo

En desarrollo, los correos se abren automáticamente en el navegador usando `letter_opener` en lugar de enviarse realmente. Esto permite previsualizar los correos sin necesidad de configurar un servidor SMTP real.

#### Entorno de Producción

En producción, la aplicación usa SMTP para enviar correos. Asegúrate de configurar todas las variables de entorno requeridas antes de desplegar.

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
