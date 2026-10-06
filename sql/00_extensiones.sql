-- Extensión pgvector, requerida por el Vector Store del RAG (Postgres PGVector Store).
-- Ejecútala primero, en la base de datos del proyecto.

CREATE EXTENSION IF NOT EXISTS vector;

-- Si al crear la extensión aparece un WARNING de "collation version mismatch"
-- (frecuente tras cambiar la imagen Docker de Postgres para incluir pgvector),
-- es inofensivo pero se puede limpiar con:
-- ALTER DATABASE nombre_de_tu_base REFRESH COLLATION VERSION;
