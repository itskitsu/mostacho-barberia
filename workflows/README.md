# Workflows de n8n

Aquí van los flujos exportados desde n8n (un `.json` por flujo):

| Archivo | Flujo |
|---|---|
| `agente-principal.json` | Agente principal (WhatsApp) — "Portafolio - Agente Barbería" |
| `consultar-disponibilidad.json` | Sub-workflow "Barbería - Consultar Disponibilidad" |
| `recordatorios.json` | "Barbería - Recordatorios de citas" (24h y 2h) |
| `completar-citas-fidelidad.json` | "Barbería - Completar citas y fidelidad" |
| `cargar-base-de-conocimiento.json` | Carga de `docs/base-de-conocimiento.md` al Vector Store (Postgres + pgvector) |
| `setup-sql.json` | Ejecuta los scripts de [`sql/`](../sql/) (opcional: también puedes usar `psql`) |

## Cómo exportar un flujo

1. Abre el flujo en n8n.
2. Menú **⋯** (arriba a la derecha) → **Download**.
3. Renombra el archivo y guárdalo en esta carpeta.

## Antes de subirlos a GitHub

- Los `.json` **no** guardan el contenido de las credenciales (solo su nombre e id), pero revísalos igualmente: busca con el buscador de tu editor `token`, `apiKey`, `password`, el Access Token de WhatsApp y el Business Account ID reales.
- Reemplaza cualquier **número de teléfono real de clientes de prueba** que haya quedado pineado en algún nodo por un marcador como `TU_NUMERO_DE_PRUEBA`.
- Si algún nodo tiene datos de clientes reales (nombre, teléfono, cédula) guardados como datos fijos/pinned, quítalos.

## Cómo importarlos

1. En n8n: **Workflows → Import from File**.
2. Asigna tus propias credenciales (WhatsApp Business API, Anthropic, Google Calendar, Google Gemini, Postgres) en los nodos que lo pidan.
3. En *Settings* de cada flujo, zona horaria `America/Bogota` (o la de tu negocio).
4. Configura también las variables de entorno `GENERIC_TIMEZONE` y `TZ` en el propio servicio de n8n — si no coinciden con la zona horaria real del negocio, las citas se crean con un desfase de horas en Google Calendar (ver el README principal, sección de lecciones de migración).
5. En el sub-workflow de disponibilidad, revisa que la lista de barberos (`ESTILISTAS`/equivalente en el código) coincida con tu propio equipo.
6. Publica el workflow principal y registra la URL de producción del webhook en el panel de Meta (WhatsApp → Configuration → Callback URL), y suscribe la app a la cuenta de WhatsApp Business con un POST a `{BUSINESS_ACCOUNT_ID}/subscribed_apps` si los mensajes reales no disparan el webhook.
