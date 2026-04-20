# MVP Scope — Bondi App
*Inversión en bonos soberanos para el inversor retail latinoamericano*

---

## 🎯 Problema Core

Los bonos son inaccesibles para el joven latinoamericano: montos altos, brokers complejos y lenguaje financiero que intimida. Bondi elimina esas barreras desde el iPhone.

---

## 👤 Perfil de Usuario

| Atributo | Detalle |
|---|---|
| Edad | 20 – 35 años |
| Mercado | LATAM (iOS) |
| Experiencia financiera | Ninguna requerida |

---

## 🔥 Flujo MVP — 5 Pasos

1. El usuario **descubre bonos disponibles** — lista con filtros básicos (país, yield, vencimiento)
2. Ve el **detalle de un bono** — Apple Intelligence explica en lenguaje natural qué es, qué rendimiento ofrece y cuál es el riesgo
3. **Invierte con monto mínimo bajo** — fracciones tokenizadas vía Etherfuse / Stellar desde unos pocos dólares
4. Accede a su **portafolio personal** — balance, rendimiento acumulado y vencimientos próximos
5. Recibe **alertas y sugerencias on-device** — Apple Intelligence notifica sobre vencimientos y oportunidades de diversificación

---

## ✅ Features MVP

- **Catálogo de bonos con filtros básicos** — país, yield estimado, vencimiento
- **Detalle de bono con explicación IA** — Apple Intelligence on-device en lenguaje natural
- **Inversión mínima fraccionada** — Etherfuse + Stellar; desde ~$5 USD
- **Portafolio personal** — balance, rendimientos, vencimientos
- **Notificaciones push de vencimientos** — alertas 1 semana antes

---

## ❌ NO va en MVP

- Comparador avanzado de bonos *(nice-to-have v2)*
- Chat conversacional completo con el modelo IA *(v2)*
- Multi-wallet / varios blockchains *(solo Stellar en MVP)*
- Social / comunidad de inversores
- KYC avanzado propio *(delegar a Etherfuse si es posible)*

---

## 🎊 Criterio de Éxito

> El MVP funciona si: **el 70% de los usuarios que completan el onboarding realizan al menos una inversión en sus primeras 2 semanas.**

---

## ✅ Test de Enfoque

- **Test de 30 segundos:** "App para invertir en bonos desde $5, con IA que te explica todo en español, sin necesidad de saber finanzas." ✓
- **Test de enfoque:** Máximo 5 features críticas — cumple exactamente ✓
- **Test de problema:** Resuelve UN problema: la barrera de entrada a la renta fija para el inversor retail LATAM ✓

---

## ⚠️ Punto de Atención

El flujo de **KYC/onboarding** puede ser el cuello de botella real. Validar qué tan liviano puede ser con Etherfuse antes de iniciar el build. Si Etherfuse maneja la verificación de identidad, el flujo se simplifica enormemente; si no, ese paso puede matar la conversión antes de que el usuario llegue a ver un solo bono.

---

*Template basado en el framework de Proof Bondi App — Versión Express*
