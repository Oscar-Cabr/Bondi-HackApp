# PRD — Bondi App MVP
**Inversión en bonos soberanos para el inversor retail latinoamericano**

> **Versión:** 1.0 | **Fecha:** Abril 2026 | **Estado:** Draft para revisión  
> **Audience:** Engineering, Design, Product, Investors

---

## Tabla de Contenidos

1. [Project Overview](#1-project-overview)
2. [User Personas](#2-user-personas)
3. [User Stories & Acceptance Criteria](#3-user-stories--acceptance-criteria)
4. [UI/UX Requirements](#4-uiux-requirements)
5. [Technical Requirements](#5-technical-requirements)
6. [Business Model & Monetización](#6-business-model--monetización)
7. [Success Metrics & KPIs](#7-success-metrics--kpis)
8. [Implementation Roadmap](#8-implementation-roadmap)
9. [Riesgos & Mitigaciones](#9-riesgos--mitigaciones)
10. [Appendix](#10-appendix)

---

## 1. Project Overview

### 1.1 Problema

El mercado de renta fija en Latinoamérica está estructuralmente cerrado para el inversor minorista joven:

| Barrera | Descripción |
|---|---|
| **Monto mínimo** | Los bonos soberanos requieren inversiones de $1,000–$10,000 USD mínimo en brokers tradicionales |
| **Complejidad operativa** | Apertura de cuenta en broker tarda días; proceso KYC burocrático |
| **Lenguaje financiero** | Términos como "yield", "cupón", "duration" excluyen al no-especialista |
| **Infraestructura legacy** | Plataformas desktop, PDFs, horarios de mesa de dinero |

**Consecuencia:** El joven LATAM ahorra en dólares en efectivo o en cuentas bancarias de bajo rendimiento. No accede a instrumentos que protejan su poder adquisitivo.

### 1.2 Solución

Bondi es una app iOS que tokeniza bonos soberanos latinoamericanos vía Stellar/Etherfuse, permitiendo invertir desde $5 USD con explicaciones en lenguaje natural generadas on-device por Apple Intelligence.

**Tagline de producto:** *"Invierte en bonos desde $5. La IA te explica todo en español."*

### 1.3 Objetivos del MVP

| Objetivo | Métrica de éxito | Plazo |
|---|---|---|
| Validar conversión onboarding → inversión | 70% de usuarios que completan onboarding invierten en 2 semanas | 90 días post-lanzamiento |
| Validar que el lenguaje IA reduce fricción | Tasa de drop < 20% en pantalla de detalle de bono | 60 días post-lanzamiento |
| Validar ticket promedio inicial | Inversión promedio ≥ $15 USD | 90 días post-lanzamiento |
| Validar retención básica | 50% de usuarios activos al día 30 | 90 días post-lanzamiento |

### 1.4 Alcance del MVP

**IN SCOPE:**
- Catálogo de bonos con filtros básicos (país, yield, vencimiento)
- Detalle de bono con explicación Apple Intelligence on-device
- Inversión fraccionada desde ~$5 USD vía Etherfuse + Stellar
- Portafolio personal (balance, rendimientos, vencimientos)
- Notificaciones push de vencimientos (7 días antes)

**OUT OF SCOPE (v2+):**
- Comparador avanzado de bonos
- Chat conversacional completo con IA
- Multi-wallet / múltiples blockchains
- Social / comunidad de inversores
- KYC avanzado propio
- Android

---

## 2. User Personas

### Persona A — "La Ahorradora Frustrada"

> **Valentina, 26, Ciudad de México**

| Atributo | Detalle |
|---|---|
| **Ocupación** | Diseñadora UX en startup, sueldo ~$1,200 USD/mes |
| **Situación financiera** | Ahorra ~$200/mes; tiene $2,000 USD en cuenta de débito sin rendimiento |
| **Tech stack personal** | iPhone 14, apps: Mercado Pago, Spotify, Instagram, Notion |
| **Pain principal** | Sabe que "debería invertir" pero no sabe por dónde empezar; le da miedo perder dinero |
| **Motivación** | Quiere que sus ahorros "trabajen" sin tener que convertirse en experta |
| **Bloqueador clave** | El lenguaje de las plataformas de inversión la intimida; cierra las apps antes de terminar el registro |
| **Cita representativa** | *"Vi un bono del tesoro en Twitter pero no entendí nada de lo que decía. Cerré la pestaña."* |

**Cómo Bondi la sirve:** Valentina abre Bondi, ve "Bono del Gobierno de México · 8.2% anual · vence en 18 meses", toca el bono y Apple Intelligence le explica: "Si inviertes $100 hoy, en 18 meses recibirás aproximadamente $112." Invierte $50 en 3 minutos.

---

### Persona B — "El Crypto-Nativo Diversificador"

> **Sebastián, 29, Bogotá / Buenos Aires**

| Atributo | Detalle |
|---|---|
| **Ocupación** | Developer freelance, ingresos en USDC y ARS/COP |
| **Situación financiera** | Tiene crypto (BTC, ETH, stablecoins); busca diversificar a instrumentos con rendimiento predecible |
| **Tech stack personal** | iPhone 15 Pro, MetaMask, Phantom, Binance, Twitter/X |
| **Pain principal** | Quiere exposición a renta fija soberana sin pasar por el sistema bancario tradicional |
| **Motivación** | Tokenización y custodia on-chain le generan confianza; entiende el concepto de Stellar/Etherfuse |
| **Bloqueador clave** | No quiere pasar por KYC de broker tradicional; desconfía de custodios opacos |
| **Cita representativa** | *"Si los bonos fueran on-chain y el KYC fuera liviano, los compraría hoy mismo."* |

**Cómo Bondi lo sirve:** Sebastián ya entiende los bonos; le importa la infraestructura. Ve que Etherfuse tokeniza en Stellar, que el proceso KYC es delegado y ligero, e invierte como experimento inicial con $100.

---

### Persona C — "El Primer Inversor"

> **Diego, 22, Lima / Santiago**

| Atributo | Detalle |
|---|---|
| **Ocupación** | Estudiante universitario con trabajo part-time; primer empleo formal |
| **Situación financiera** | Ahorra $50–$100 USD/mes; nunca ha invertido nada |
| **Tech stack personal** | iPhone SE / 13, TikTok, YouTube, WhatsApp |
| **Pain principal** | Escucha sobre inversión en redes sociales pero el monto mínimo de cualquier plataforma supera sus ahorros |
| **Motivación** | Quiere "empezar en algo" aunque sea con poco |
| **Bloqueador clave** | Monto mínimo alto + no quiere equivocarse + proceso de registro largo |
| **Cita representativa** | *"Si pudiera empezar con $5 para probar, sí le entraría."* |

**Cómo Bondi lo sirve:** Diego puede invertir $5 en un bono. La IA le explica el riesgo en lenguaje simple. El onboarding es en minutos. Su primera inversión es un hito psicológico que genera hábito.

---

## 3. User Stories & Acceptance Criteria

### Epic 1 — Onboarding & KYC

---

**US-001 — Registro inicial**

> *Como nuevo usuario, quiero registrarme con mi email o Apple ID para crear mi cuenta en menos de 2 minutos.*

**Acceptance Criteria:**
- [ ] El usuario puede registrarse con Sign in with Apple (primer opción) o email + contraseña
- [ ] El flujo de registro no supera 4 pantallas
- [ ] Se muestra progress indicator durante el proceso
- [ ] En caso de error de red, el estado del formulario se conserva
- [ ] El usuario recibe confirmación de cuenta creada (email o notificación in-app)

---

**US-002 — KYC delegado a Etherfuse**

> *Como usuario registrado, quiero completar mi verificación de identidad de forma rápida para poder invertir.*

**Acceptance Criteria:**
- [ ] El flujo KYC es embebido o redirige a Etherfuse sin salir del contexto de Bondi
- [ ] El proceso KYC no supera 5 minutos en condiciones normales
- [ ] Si Etherfuse maneja la verificación, Bondi recibe webhook de confirmación y actualiza el estado del usuario automáticamente
- [ ] El usuario ve un estado claro: "Verificación en proceso" / "Verificado" / "Rechazado - contacta soporte"
- [ ] En caso de rechazo, se muestra mensaje de qué hacer (no un error genérico)
- [ ] El usuario no puede acceder a la pantalla de inversión hasta tener KYC aprobado

---

**US-003 — Onboarding educativo**

> *Como usuario nuevo sin experiencia financiera, quiero entender qué es un bono antes de invertir, en lenguaje simple.*

**Acceptance Criteria:**
- [ ] Se presenta una pantalla de bienvenida que explica el concepto de bono en máximo 3 pasos/slides
- [ ] El usuario puede saltarse el onboarding educativo con un botón "Ya sé qué es un bono"
- [ ] El contenido educativo no usa jerga financiera sin explicación inmediata
- [ ] Las ilustraciones/íconos son coherentes con el sistema de diseño de Bondi

---

### Epic 2 — Catálogo de Bonos

---

**US-004 — Ver catálogo de bonos disponibles**

> *Como usuario verificado, quiero ver todos los bonos disponibles para invertir y poder filtrarlos por mis preferencias.*

**Acceptance Criteria:**
- [ ] La pantalla muestra lista de bonos con: nombre/emisor, país (con bandera), yield estimado anual (%), fecha de vencimiento
- [ ] Los filtros disponibles son: País, Yield (rango), Plazo de vencimiento (corto/mediano/largo)
- [ ] El tiempo de carga inicial del catálogo no supera 2 segundos en conexión 4G
- [ ] Si no hay bonos que coincidan con los filtros, se muestra estado vacío con mensaje claro
- [ ] El catálogo se actualiza en tiempo real o con pull-to-refresh
- [ ] Cada bono en la lista muestra un indicador visual de nivel de riesgo (bajo/medio/alto)

---

**US-005 — Ver detalle de un bono**

> *Como usuario, quiero ver toda la información relevante de un bono específico y entenderla en lenguaje simple.*

**Acceptance Criteria:**
- [ ] La pantalla de detalle incluye: nombre completo del bono, emisor, país, yield actual, fecha de vencimiento, monto mínimo de inversión, explicación IA
- [ ] Apple Intelligence genera on-device una explicación en español natural del bono (sin requerir conexión a internet para la explicación)
- [ ] La explicación IA incluye: qué es el bono, qué rendimiento ofrece con ejemplo en números absolutos, y el riesgo en términos simples
- [ ] La pantalla incluye un simulador simple: "Si invierto $X, en Y meses recibiré $Z"
- [ ] El simulador actualiza en tiempo real al mover el slider de monto
- [ ] Existe botón CTA claro "Invertir ahora" que lleva al flujo de inversión
- [ ] El usuario puede acceder al detalle del bono desde el catálogo y desde su portafolio

---

### Epic 3 — Inversión

---

**US-006 — Realizar una inversión**

> *Como usuario verificado con fondos disponibles, quiero invertir en un bono desde un monto mínimo bajo, en pocos pasos.*

**Acceptance Criteria:**
- [ ] El flujo de inversión no supera 3 pantallas
- [ ] El monto mínimo de inversión es $5 USD o equivalente
- [ ] El usuario puede ingresar el monto de inversión manualmente o usar presets rápidos ($5, $10, $25, $50, $100)
- [ ] Antes de confirmar, se muestra un resumen: monto invertido, yield esperado, fecha de vencimiento, comisión de Bondi (fee transparente)
- [ ] La confirmación requiere Face ID / Touch ID o PIN de la app
- [ ] La transacción se procesa vía Etherfuse + Stellar
- [ ] El usuario recibe confirmación de inversión exitosa con resumen y se redirige a su portafolio
- [ ] En caso de error de transacción, el usuario ve un mensaje claro y no se le cobra

---

**US-007 — Agregar fondos a la cuenta**

> *Como usuario, quiero poder cargar dinero a mi cuenta en Bondi para poder invertir.*

**Acceptance Criteria:**
- [ ] El usuario puede agregar fondos vía transferencia bancaria, tarjeta de crédito/débito, o transferencia USDC (según disponibilidad de Etherfuse)
- [ ] El tiempo de acreditación es comunicado claramente al usuario antes de confirmar
- [ ] El saldo disponible se actualiza automáticamente una vez acreditado
- [ ] El historial de depósitos es visible en la sección de portafolio

---

### Epic 4 — Portafolio

---

**US-008 — Ver mi portafolio personal**

> *Como inversor, quiero ver en un solo lugar todas mis inversiones, mi rendimiento acumulado y los vencimientos próximos.*

**Acceptance Criteria:**
- [ ] La pantalla de portafolio muestra: saldo total invertido, rendimiento acumulado en USD y en %, lista de inversiones activas
- [ ] Cada inversión activa muestra: bono, monto invertido, rendimiento actual, fecha de vencimiento
- [ ] Se muestra una sección "Próximos vencimientos" con los bonos que vencen en los próximos 30 días
- [ ] El rendimiento se actualiza con la frecuencia que permite Etherfuse (mínimo diario)
- [ ] Si el portafolio está vacío, se muestra CTA para ir al catálogo e invertir

---

**US-009 — Ver detalle de una inversión activa**

> *Como inversor, quiero ver el detalle histórico de una inversión específica.*

**Acceptance Criteria:**
- [ ] La pantalla muestra: historial de rendimientos, fecha de inversión, monto original, rendimiento proyectado total a vencimiento
- [ ] El usuario puede ver si la inversión está "on track" respecto al rendimiento prometido

---

### Epic 5 — Notificaciones

---

**US-010 — Recibir alertas de vencimiento**

> *Como inversor, quiero recibir una notificación cuando un bono está por vencer para poder tomar decisiones.*

**Acceptance Criteria:**
- [ ] El sistema envía push notification 7 días antes del vencimiento de cualquier bono en el portafolio del usuario
- [ ] La notificación incluye: nombre del bono, monto que recibirá, fecha exacta de vencimiento
- [ ] La notificación lleva al usuario directamente al detalle de esa inversión al tocarla
- [ ] El usuario puede configurar si desea o no recibir estas notificaciones desde settings

---

**US-011 — Sugerencias de diversificación (Apple Intelligence)**

> *Como inversor con portafolio activo, quiero recibir sugerencias relevantes sobre oportunidades para diversificar.*

**Acceptance Criteria:**
- [ ] Apple Intelligence genera on-device sugerencias de diversificación basadas en el portafolio actual del usuario
- [ ] Las sugerencias se presentan como notificaciones suaves (no intrusivas), máximo 1 por semana
- [ ] Las sugerencias incluyen la razón específica ("Tu portafolio está 100% en MX; considera diversificar con un bono de CL")
- [ ] El usuario puede silenciar este tipo de sugerencias desde settings

---

## 4. UI/UX Requirements

### 4.1 Principios de Diseño

| Principio | Implicación en UI |
|---|---|
| **Claridad sobre completitud** | Mostrar menos información pero más comprensible. No abrumar con datos |
| **Confianza como feature** | Diseño limpio, sin ads, sin ruido visual. El trust es la UI |
| **Mobile-first, iOS-native** | Seguir HIG de Apple. Usar componentes nativos donde sea posible |
| **Lenguaje humano** | Copy en segunda persona, sin jerga, en español (adaptar por país si es necesario) |

### 4.2 Design System

| Token | Valor sugerido |
|---|---|
| **Color primario** | Azul profundo `#1A3A5C` (transmite confianza financiera) |
| **Color acento** | Verde lima `#4ADE80` (para rendimientos positivos) |
| **Color warning** | Ámbar `#F59E0B` |
| **Color error** | Rojo `#EF4444` |
| **Font** | SF Pro (nativa iOS) |
| **Border radius** | 16px para cards |
| **Spacing unit** | 8px base |

### 4.3 User Flows

#### Flow 1 — Onboarding Completo (primer acceso)

```
Splash / Bienvenida
    → [Sign in with Apple / Email]
    → Onboarding educativo (3 slides, skippable)
    → KYC (delegado a Etherfuse, embebido o webview)
    → Estado "Verificando..." (si KYC es asíncrono)
    → Home / Catálogo de bonos ✅
```

#### Flow 2 — Descubrimiento e Inversión (usuario verificado)

```
Home / Catálogo
    → [Filtrar por país/yield/plazo]
    → Lista de bonos
    → Tap en bono → Detalle de bono
        → Explicación IA (generada on-device)
        → Simulador de monto
    → "Invertir ahora"
    → Pantalla de inversión
        → Seleccionar monto
        → Revisar resumen + fee
    → Confirmar con Face ID
    → Confirmación de inversión exitosa
    → Redirige a Portafolio ✅
```

#### Flow 3 — Portafolio y Vencimiento

```
Portafolio
    → Ver inversiones activas
    → Tap en inversión → Detalle de inversión
        → Historial de rendimiento
        → Monto esperado a vencimiento
    ← Notificación push (7 días antes de vencimiento)
        → Deep link a detalle de inversión ✅
```

### 4.4 Pantallas Clave — Wireframe Descriptions

#### Pantalla: Home / Catálogo

```
┌─────────────────────────────┐
│  🔵 Bondi                [👤] │  ← Nav bar: logo + perfil
├─────────────────────────────┤
│  ┌─ Filtros ─────────────┐  │
│  │ [País ▼] [Yield ▼] [Plazo ▼] │  ← Filter chips
│  └───────────────────────┘  │
│                             │
│  ┌─ Card ──────────────────┐│
│  │ 🇲🇽 Bono México          ││
│  │ 8.2% anual · 18 meses   ││
│  │ Desde $5  ●●○ Riesgo bajo││
│  └─────────────────────────┘│
│  ┌─ Card ──────────────────┐│
│  │ 🇨🇱 Bono Chile           ││
│  │ 6.8% anual · 12 meses   ││
│  │ Desde $5  ●○○ Riesgo bajo││
│  └─────────────────────────┘│
│  ┌─ Card ──────────────────┐│
│  │ 🇧🇷 Bono Brasil           ││
│  │ 11.4% anual · 24 meses  ││
│  │ Desde $5  ●●● Riesgo medio││
│  └─────────────────────────┘│
│                             │
├─────────────────────────────┤
│ [Explorar] [Portafolio] [💡]│  ← Tab bar
└─────────────────────────────┘
```

#### Pantalla: Detalle de Bono

```
┌─────────────────────────────┐
│ ← Volver                   │  ← Nav back
├─────────────────────────────┤
│  🇲🇽 Bono Soberano México    │
│  Serie M · Tasa fija        │
│                             │
│  ┌─ Stats ─────────────────┐│
│  │ Yield: 8.2%  Plazo: 18m  ││
│  │ Vence: Jun 2027          ││
│  └─────────────────────────┘│
│                             │
│  ╔═ ✨ Qué significa esto ══╗│
│  ║ El gobierno de México    ║│
│  ║ promete devolverte tu    ║│
│  ║ dinero en 18 meses con   ║│
│  ║ un extra de 8.2% anual.  ║│
│  ║ Es como prestarle a un   ║│
│  ║ país: bajo riesgo, pero  ║│
│  ║ no es una cuenta de      ║│
│  ║ ahorro corriente.        ║│
│  ╚═════════════════════════╝│
│                             │
│  Simulador:                 │
│  Si invierto: [$50    ]     │
│  En 18 meses recibiré: $56.15│
│                             │
│  ┌─────────────────────────┐│
│  │   💚 Invertir ahora     ││
│  └─────────────────────────┘│
└─────────────────────────────┘
```

#### Pantalla: Confirmación de Inversión

```
┌─────────────────────────────┐
│ ← Cancelar   Confirmar     │
├─────────────────────────────┤
│                             │
│       Resumen de inversión  │
│                             │
│  🇲🇽 Bono México · 18 meses  │
│                             │
│  Monto invertido:  $50.00   │
│  Fee Bondi (1%):   - $0.50  │
│  ─────────────────────────  │
│  Total debitado:   $50.50   │
│                             │
│  Rendimiento esperado:      │
│  + $6.15 en 18 meses (8.2%)│
│                             │
│  Recibirás: $56.15          │
│  el 15 de Junio, 2027       │
│                             │
│  ┌─────────────────────────┐│
│  │  🔒 Confirmar con Face ID││
│  └─────────────────────────┘│
└─────────────────────────────┘
```

---

## 5. Technical Requirements

### 5.1 Stack Tecnológico

| Capa | Tecnología | Justificación |
|---|---|---|
| **Mobile** | Swift / SwiftUI (iOS 17+) | iOS-first, Apple Intelligence APIs nativas |
| **AI on-device** | Apple Intelligence APIs (Foundation Models framework) | Explicaciones en español sin latencia de servidor; privacidad |
| **Backend API** | Node.js + TypeScript / Python FastAPI | A definir según equipo; RESTful + WebSockets para updates de portafolio |
| **Base de datos** | PostgreSQL (usuario, portafolio, transacciones) | Relacional; consistencia para datos financieros |
| **Infraestructura** | AWS / GCP | Escalabilidad; compliance posible con zonas LATAM |
| **Blockchain** | Stellar Network | Tokenización vía Etherfuse; bajo costo de transacción |
| **Tokenización** | Etherfuse | Partner de tokenización; manejo de KYC delegado |
| **Push Notifications** | APNs (Apple Push Notification Service) | Nativo iOS |
| **Auth** | Sign in with Apple + JWT | Seguridad; flujo rápido para usuario iOS |

### 5.2 Integraciones Externas

#### Etherfuse API

| Función | Endpoint / Operación |
|---|---|
| KYC / Verificación de identidad | `POST /kyc/submit` → webhook de confirmación |
| Catálogo de bonos disponibles | `GET /bonds` con filtros |
| Detalle de bono | `GET /bonds/{bond_id}` |
| Crear inversión (tokenizar) | `POST /investments` |
| Estado de portafolio | `GET /portfolio/{user_id}` |
| Saldo de cuenta | `GET /account/{user_id}/balance` |
| Depósito de fondos | `POST /account/deposit` |

**Preguntas críticas a validar con Etherfuse antes del build:**
- ¿Maneja Etherfuse el KYC completo o requiere flujo propio?
- ¿Qué tan cerca de real-time son los datos de portafolio?
- ¿Cuál es el monto mínimo real de inversión que soporta la API?
- ¿Hay sandbox de testing disponible?
- ¿Qué países soporta en esta etapa?

#### Apple Intelligence

| Función | API / Framework |
|---|---|
| Explicación de bono en lenguaje natural | Foundation Models framework (on-device) |
| Sugerencias de diversificación | Foundation Models + Adapters |

**Constraint:** Requiere iPhone con chip A17 Pro o superior (iPhone 15 Pro, iPhone 16+) con iOS 18.1+. Esto limita el segmento de usuarios compatibles — documentar como constraint de hardware en onboarding.

### 5.3 Seguridad & Compliance

| Requisito | Implementación |
|---|---|
| Datos financieros en tránsito | TLS 1.3 mínimo en todas las llamadas API |
| Datos financieros en reposo | Encriptación AES-256 en base de datos |
| Autenticación | Face ID / Touch ID para confirmación de inversiones (LocalAuthentication framework) |
| Tokens de acceso | JWT con expiración corta + refresh tokens |
| PII (datos personales) | Cumplimiento LFPDPPP (México), LGPD (Brasil) según mercados objetivo |
| KYC / AML | Delegado a Etherfuse en MVP; validar que su proceso cumple regulación local |

### 5.4 Performance Requirements

| Escenario | Target |
|---|---|
| Carga inicial del catálogo | < 2 segundos en 4G |
| Generación de explicación IA | < 3 segundos (on-device) |
| Confirmación de inversión | < 5 segundos end-to-end |
| Tiempo de onboarding completo (sin KYC) | < 3 minutos |
| Disponibilidad del backend | 99.5% uptime |

### 5.5 Data Model (Simplificado)

```sql
-- Usuarios
users (
  id UUID PRIMARY KEY,
  email VARCHAR,
  apple_id VARCHAR,
  kyc_status ENUM('pending', 'approved', 'rejected'),
  etherfuse_user_id VARCHAR,
  created_at TIMESTAMP
)

-- Bonos (sincronizado desde Etherfuse)
bonds (
  id VARCHAR PRIMARY KEY,         -- Etherfuse bond_id
  name VARCHAR,
  country_code CHAR(2),
  yield_annual DECIMAL(5,2),
  maturity_date DATE,
  min_investment_usd DECIMAL(10,2),
  risk_level ENUM('low', 'medium', 'high'),
  raw_data JSONB,                  -- Datos completos de Etherfuse
  updated_at TIMESTAMP
)

-- Inversiones
investments (
  id UUID PRIMARY KEY,
  user_id UUID REFERENCES users(id),
  bond_id VARCHAR REFERENCES bonds(id),
  amount_usd DECIMAL(10,2),
  fee_usd DECIMAL(10,2),
  expected_return_usd DECIMAL(10,2),
  status ENUM('pending', 'active', 'matured', 'failed'),
  invested_at TIMESTAMP,
  maturity_date DATE,
  etherfuse_tx_id VARCHAR
)

-- Notificaciones enviadas
notifications (
  id UUID PRIMARY KEY,
  user_id UUID REFERENCES users(id),
  investment_id UUID REFERENCES investments(id),
  type ENUM('maturity_7d', 'diversification_suggestion'),
  sent_at TIMESTAMP,
  opened_at TIMESTAMP
)
```

---

## 6. Business Model & Monetización

### 6.1 Fuentes de Ingreso

| Stream | Descripción | Rate MVP |
|---|---|---|
| **Transaction fee** | Fee sobre cada inversión realizada | 1% del monto invertido |
| **Spread de seguro** | Margen sobre coberturas/seguros asociados a los bonos | Pendiente de definir con proveedor de seguros |

### 6.2 Unit Economics (Asunciones MVP)

| Variable | Asunción |
|---|---|
| Inversión promedio inicial | $30 USD |
| Fee por transacción | $0.30 por inversión |
| Inversiones por usuario activo/mes | 1.5 |
| Revenue por usuario activo/mes | ~$0.45 USD |
| CAC objetivo | < $5 USD |
| LTV objetivo (12 meses) | > $8 USD |

*Nota: Estas cifras son para validación de hipótesis. El modelo escala a medida que aumenta el ticket promedio y la frecuencia de inversión.*

### 6.3 Fee Disclosure

El fee de Bondi debe ser **transparente y visible** antes de confirmar cualquier inversión. No hay fees ocultos. Esto es un diferenciador de confianza.

---

## 7. Success Metrics & KPIs

### 7.1 North Star Metric

> **Usuarios que realizan al menos una inversión en sus primeras 2 semanas post-onboarding.**
> Target MVP: **70%**

### 7.2 KPIs por Etapa del Funnel

| Etapa | Métrica | Target 90 días |
|---|---|---|
| **Adquisición** | Descargas de la app | 1,000 downloads |
| **Activación** | % usuarios que completan onboarding + KYC | > 60% |
| **Primera inversión** | % usuarios verificados que invierten en 2 semanas | > 70% |
| **Retención D7** | % usuarios activos al día 7 | > 50% |
| **Retención D30** | % usuarios activos al día 30 | > 40% |
| **Engagement** | Inversiones por usuario activo/mes | ≥ 1.5 |

### 7.3 Métricas de UX/Producto

| Métrica | Target |
|---|---|
| Drop-off en detalle de bono (antes de llegar a "Invertir") | < 30% |
| Tasa de completitud del flujo de inversión | > 80% |
| Crashes por sesión | < 0.5% |
| Rating App Store | ≥ 4.5 |
| Tiempo medio de primer inversión post-registro | < 10 minutos |

### 7.4 Métricas de Negocio

| Métrica | Target 90 días |
|---|---|
| AUM total (Assets Under Management) | $15,000 USD |
| Revenue total (fees) | $150 USD |
| Inversión promedio por transacción | ≥ $20 USD |
| Número de inversiones totales | ≥ 500 |

### 7.5 Alertas (Señales de Alarma)

- Drop-off en KYC > 50% → Revisar flujo o consideraar pre-KYC con Etherfuse
- Drop-off en pantalla de detalle de bono > 40% → Revisar explicación IA y copy
- Inversión promedio < $10 → Revisar presets de monto sugerido
- Retención D7 < 30% → Activar campaña de notificaciones de reengagement

---

## 8. Implementation Roadmap

### Phase 0 — Pre-Build Validation (2 semanas)

**Objetivo:** Validar supuestos técnicos con Etherfuse antes de iniciar el desarrollo.

| Tarea | Owner | Criterio de cierre |
|---|---|---|
| Reunión técnica con Etherfuse: alcance del KYC, sandbox API, catálogo de bonos disponibles | Product + Tech Lead | Respuesta documentada de Etherfuse en todas las preguntas críticas |
| Prototipo interactivo en Figma (flujo completo onboarding → inversión) | Design | Validado con 5 usuarios del segmento target |
| Setup de ambiente de desarrollo iOS + backend | Engineering | App shell corriendo en simulador y conectada a backend de pruebas |
| Definir países y bonos del catálogo MVP | Product | Lista definitiva de 5–10 bonos con los que arranca |

---

### Phase 1 — Core MVP (6–8 semanas)

**Objetivo:** App funcional con el flujo completo: catálogo → detalle → inversión → portafolio.

| Sprint | Features |
|---|---|
| **Sprint 1–2** | Auth (Sign in with Apple + email), Onboarding educativo, Integración KYC Etherfuse, Estados de KYC |
| **Sprint 3–4** | Catálogo de bonos (fetch desde Etherfuse), Filtros básicos, Detalle de bono, Integración Apple Intelligence (explicación on-device) |
| **Sprint 5–6** | Flujo de inversión completo, Confirmación con Face ID, Integración de pago/depósito, Portafolio básico |
| **Sprint 7–8** | Notificaciones push de vencimiento, Simulador de inversión, QA general, Bug fixes, Submit a TestFlight |

---

### Phase 2 — Beta Privada (2–3 semanas)

**Objetivo:** Validar el producto con ~50 usuarios reales antes del lanzamiento público.

| Tarea | Criterio de éxito |
|---|---|
| Distribución a 50 usuarios beta (Testflight) | 50 usuarios activos |
| Monitoreo de métricas de funnel | Identificar drop-offs mayores al target |
| Iteración sobre friction points críticos | Al menos 3 mejoras basadas en feedback real |
| Validación del flujo KYC en condiciones reales | > 60% de completitud |

---

### Phase 3 — Launch (1–2 semanas)

**Objetivo:** Lanzamiento en App Store con estrategia de adquisición inicial.

| Tarea | Detalle |
|---|---|
| Submit a App Store Review | Preparar screenshots, descripción, keywords en español |
| Estrategia de adquisición inicial | Contenido en TikTok/Instagram sobre "bonos desde $5"; comunidades de finanzas personales en LATAM |
| Setup de analytics | Mixpanel o Amplitude para tracking del funnel |
| Setup de soporte | Email / WhatsApp de soporte para primeros usuarios |

---

### Phase 4 — Post-Launch & v2 Planning (Semanas 13+)

| Feature v2 | Prioridad tentativa |
|---|---|
| Comparador avanzado de bonos | Media |
| Chat conversacional con IA | Alta |
| Android | Media |
| Multi-blockchain | Baja |
| Social / comunidad | Baja |

---

## 9. Riesgos & Mitigaciones

| Riesgo | Probabilidad | Impacto | Mitigación |
|---|---|---|---|
| **Etherfuse KYC es lento o complejo** | Alta | Crítico | Validar en Phase 0; diseñar UX que maneje estados de espera de forma elegante; considerar pre-KYC express |
| **Apple Intelligence no soporta español fluido** | Media | Alto | Tener fallback de explicaciones pre-escritas por equipo editorial; testear con modelos reales antes del build |
| **Bajo catálogo de bonos disponibles en Etherfuse** | Media | Alto | Definir catálogo mínimo viable (5 bonos) en Phase 0; explorar bonos de múltiples países |
| **Baja conversión de onboarding** | Media | Alto | Prototipo y testing con usuarios en Phase 0; simplificar al máximo el flujo |
| **Compliance / regulatorio por país** | Media | Alto | Delimitar MVP a 1–2 países donde la regulación es más clara; asesoramiento legal local |
| **Performance de Apple Intelligence < 3s** | Baja | Medio | Generar explicaciones en background mientras el usuario navega el detalle; mostrar skeleton |
| **Fraude / lavado de dinero** | Baja | Crítico | KYC delegado a Etherfuse; límites de inversión bajos en MVP; revisión periódica de transacciones |

---

## 10. Appendix

### 10.1 Glosario

| Término | Definición para el equipo |
|---|---|
| **Bono soberano** | Instrumento de deuda emitido por un gobierno nacional |
| **Yield** | Rendimiento anual expresado como porcentaje del monto invertido |
| **Tokenización** | Representar el derecho sobre un bono en un token en blockchain (Stellar) |
| **Etherfuse** | Plataforma que tokeniza bonos mexicanos (y posiblemente otros LATAM) en Stellar |
| **KYC** | Know Your Customer: verificación de identidad requerida para servicios financieros |
| **AML** | Anti-Money Laundering: cumplimiento contra lavado de dinero |
| **Apple Intelligence** | Suite de modelos de IA on-device de Apple disponible en iOS 18.1+ |

### 10.2 Preguntas Abiertas

| Pregunta | Área | Prioridad |
|---|---|---|
| ¿Etherfuse maneja KYC completo? ¿Qué datos requiere? | Tech + Legal | 🔴 Crítica |
| ¿Cuántos bonos están disponibles hoy en Etherfuse? ¿De qué países? | Product | 🔴 Crítica |
| ¿Cuál es el spread real del seguro y quién es el proveedor? | Business | 🟡 Alta |
| ¿Qué países son el mercado inicial? ¿México primero? | Product | 🟡 Alta |
| ¿Hay restricciones regulatorias para operar en cada país target? | Legal | 🟡 Alta |
| ¿Cuál es el modelo de custodia de los tokens Stellar? | Tech | 🟡 Alta |
| ¿iOS-only es una restricción de corto plazo o estratégica? | Product | 🟢 Media |

### 10.3 Referencias

- Etherfuse: https://etherfuse.com
- Stellar Network: https://stellar.org
- Apple Foundation Models (Apple Intelligence): https://developer.apple.com/apple-intelligence/
- Apple Human Interface Guidelines: https://developer.apple.com/design/human-interface-guidelines/

---

*PRD generado para Bondi App MVP — Versión 1.0 — Abril 2026*  
*Próxima revisión recomendada: post Phase 0 (validación con Etherfuse)*
