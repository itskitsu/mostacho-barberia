-- Columnas de control de recordatorios, por si 01_tablas.sql se corrió en una base
-- que ya tenía la tabla `citas` sin estas columnas (migraciones incrementales).
-- Repetible.

ALTER TABLE citas ADD COLUMN IF NOT EXISTS recordatorio_24h_enviado BOOLEAN NOT NULL DEFAULT false;
ALTER TABLE citas ADD COLUMN IF NOT EXISTS recordatorio_2h_enviado  BOOLEAN NOT NULL DEFAULT false;

-- Consultas de referencia usadas por el workflow "Barbería - Recordatorios de citas"
-- (quedan documentadas aquí, no se ejecutan desde este archivo):

-- Rama 24h:
-- SELECT c.*, cl.nombre
-- FROM citas c
-- JOIN clientes cl ON cl.telefono = c.telefono
-- WHERE c.estado = 'agendada'
--   AND c.recordatorio_24h_enviado = false
--   AND c.fecha_hora_inicio BETWEEN (now() AT TIME ZONE 'America/Bogota')
--                                AND (now() AT TIME ZONE 'America/Bogota') + INTERVAL '24 hours';

-- Rama 2h: igual, cambiando el intervalo a '2 hours' y el flag a recordatorio_2h_enviado.

-- Workflow "Barbería - Completar citas y fidelidad" (cada 15 min):
-- 1) Marcar completadas:
-- UPDATE citas SET estado = 'completada'
-- WHERE estado = 'agendada' AND fecha_hora_fin < (now() AT TIME ZONE 'America/Bogota')
-- RETURNING *;
--
-- 2) Actualizar fidelidad del cliente (por cada cita recién completada):
-- UPDATE clientes SET
--   contador_visitas = CASE
--     WHEN $es_gratis THEN 0
--     WHEN contador_visitas + 1 >= 6 THEN 0
--     ELSE contador_visitas + 1
--   END,
--   servicio_gratis_disponible = CASE
--     WHEN $es_gratis THEN false
--     WHEN contador_visitas + 1 >= 6 THEN true
--     ELSE servicio_gratis_disponible
--   END,
--   updated_at = now()
-- WHERE telefono = $telefono;
