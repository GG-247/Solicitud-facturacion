# 📊 Contadores GB — Portal de Facturación
### Proyecto Green Belt Six Sigma · Área de Facturación

Sistema digital de gestión de solicitudes de facturación con tablero **Kanban + Andon** para el despacho de contadores.

---

## 🌐 Páginas del sistema

| Archivo | Descripción |
|---|---|
| `index.html` | **Portal del cliente** — Formulario de 4 pasos para solicitar facturas |
| `dashboard.html` | **Panel de control interno** — Tablero Kanban + sistema Andon |
| `config.js` | Configuración de conexión a Supabase *(debes editar este archivo)* |
| `supabase-setup.sql` | Script SQL para crear la base de datos en Supabase |

---

## 🚀 Guía de instalación paso a paso

### PASO 1 — Crear cuenta en Supabase (base de datos gratuita)

1. Ve a **[https://supabase.com](https://supabase.com)** y crea una cuenta gratuita
2. Haz clic en **"New Project"**
3. Ponle el nombre: `contadores-gb`
4. Elige una contraseña segura y selecciona la región más cercana (ej. `South America (São Paulo)`)
5. Espera ~2 minutos a que se cree el proyecto

---

### PASO 2 — Configurar la base de datos

1. En tu proyecto de Supabase, ve al menú lateral → **SQL Editor**
2. Haz clic en **"New Query"**
3. Copia y pega todo el contenido del archivo `supabase-setup.sql`
4. Haz clic en **"Run"** (▶)
5. Verifica que aparezca `Success` en verde

---

### PASO 3 — Obtener tus credenciales

1. En Supabase, ve al menú → **Settings** → **API**
2. Copia los siguientes valores:
   - **Project URL** → algo como `https://abcdefgh.supabase.co`
   - **anon / public key** → empieza con `eyJhbGciOiJIUzI1NiIsInR5cCI6Ikp...`

---

### PASO 4 — Editar `config.js`

Abre el archivo `config.js` y reemplaza los valores:

```javascript
const SUPABASE_URL  = 'https://TU_PROYECTO.supabase.co';   // ← pega tu Project URL
const SUPABASE_ANON_KEY = 'TU_ANON_KEY_AQUI';              // ← pega tu anon key
```

---

### PASO 5 — Subir a GitHub Pages

1. Crea una cuenta en **[https://github.com](https://github.com)** si no tienes
2. Crea un nuevo repositorio: `contadores-gb` (público)
3. Sube los 5 archivos: `index.html`, `dashboard.html`, `config.js`, `supabase-setup.sql`, `README.md`
4. Ve a: **Settings** → **Pages**
5. En "Source" selecciona **"main"** branch → carpeta **"/ (root)"**
6. Haz clic en **Save**
7. En ~1 minuto tendrás tu URL: `https://tu-usuario.github.io/contadores-gb/`

---

## ✨ Funcionalidades del sistema

### Portal del Cliente (`index.html`)
- ✅ Formulario en 4 pasos con validación completa
- ✅ **Datos fiscales**: RFC, Régimen Fiscal, Uso de CFDI, Domicilio, CP
- ✅ **Conceptos**: tabla dinámica de productos/servicios con cálculo de totales
- ✅ **Destino**: correo electrónico o número de WhatsApp
- ✅ **Archivos**: arrastrar y soltar PDFs, imágenes, XMLs (hasta 10 MB c/u)
- ✅ Folio único generado automáticamente (ej. `GB-482931`)
- ✅ Diseño responsivo (funciona en celular y computadora)

### Panel de Control (`dashboard.html`)
- ✅ **Tablero Kanban** con 3 columnas: Pendiente → En Proceso → Completado
- ✅ **Arrastrar y soltar** tarjetas entre columnas
- ✅ **Sistema Andon** con 3 niveles de alerta:
  - 🟢 **Verde**: solicitud recibida hace menos de 18 horas (en tiempo)
  - 🟡 **Amarillo**: entre 18 y 24 horas (próxima a vencer)
  - 🔴 **Rojo**: más de 24 horas (¡VENCIDA! requiere atención inmediata)
- ✅ Alerta visual parpadeante cuando hay solicitudes vencidas
- ✅ Contadores en tiempo real: a tiempo / próx. vencer / vencidas
- ✅ Modal de detalle completo con todos los datos del cliente
- ✅ Descarga/vista de archivos adjuntos
- ✅ Filtros por estado, nivel Andon y búsqueda por texto
- ✅ Auto-actualización cada 60 segundos

---

## 🎯 Impacto en métricas Six Sigma

| Problema original | Solución implementada |
|---|---|
| Solicitudes perdidas por correo/WhatsApp | Canal único a través del portal web |
| Tiempo de respuesta > 24 hrs sin control | Sistema Andon alerta automáticamente al acercarse al límite |
| Sin visibilidad del estado de cada solicitud | Kanban visual con 3 etapas claramente definidas |
| Información fiscal incompleta | Formulario con campos obligatorios y validación en tiempo real |
| Sin trazabilidad | Folio único + registro en base de datos con timestamp |

---

## 🛠️ Tecnologías utilizadas

- **Frontend**: HTML5, CSS3, JavaScript vanilla (sin frameworks)
- **Base de datos**: [Supabase](https://supabase.com) (PostgreSQL en la nube, gratuito)
- **Almacenamiento de archivos**: Supabase Storage
- **Hosting**: GitHub Pages (gratuito)

---

## 📞 Soporte

Si tienes algún problema con la instalación, revisa:
1. Que las credenciales en `config.js` sean correctas
2. Que el bucket `facturas` en Supabase Storage sea **público**
3. Que las políticas RLS estén correctamente aplicadas (ver `supabase-setup.sql`)
