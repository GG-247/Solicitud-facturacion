-- ╔══════════════════════════════════════════════════════════════════════╗
-- ║  CONTADORES GB — Script CORREGIDO                                    ║
-- ║  Supabase → SQL Editor → New Query → pega esto → Run                ║
-- ╚══════════════════════════════════════════════════════════════════════╝

-- ── 1. TABLA (solo crea si no existe) ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public.solicitudes_facturacion (
  id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  created_at      TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  updated_at      TIMESTAMPTZ,
  folio           TEXT UNIQUE,
  razon_social    TEXT NOT NULL,
  rfc             TEXT NOT NULL,
  solicitante     TEXT,
  regimen_fiscal  TEXT NOT NULL,
  uso_cfdi        TEXT NOT NULL,
  domicilio_fiscal TEXT NOT NULL,
  codigo_postal   TEXT NOT NULL,
  ciudad          TEXT,
  productos       TEXT NOT NULL DEFAULT '[]',
  total           NUMERIC(12,2) DEFAULT 0,
  tipo_destino    TEXT NOT NULL DEFAULT 'email',
  correo_destino  TEXT,
  telefono_destino TEXT,
  notas           TEXT,
  archivos_urls   TEXT[] DEFAULT ARRAY[]::TEXT[],
  status          TEXT NOT NULL DEFAULT 'pendiente'
                  CHECK (status IN ('pendiente','en_proceso','completado'))
);

-- ── 2. ÍNDICES ──────────────────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_sol_status  ON public.solicitudes_facturacion (status);
CREATE INDEX IF NOT EXISTS idx_sol_created ON public.solicitudes_facturacion (created_at DESC);
CREATE INDEX IF NOT EXISTS idx_sol_rfc     ON public.solicitudes_facturacion (rfc);

-- ── 3. RLS — eliminar antes de crear (evita error 42710) ────────────────
ALTER TABLE public.solicitudes_facturacion ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "insert_public" ON public.solicitudes_facturacion;
DROP POLICY IF EXISTS "select_public" ON public.solicitudes_facturacion;
DROP POLICY IF EXISTS "update_public" ON public.solicitudes_facturacion;

CREATE POLICY "insert_public"
  ON public.solicitudes_facturacion FOR INSERT TO anon WITH CHECK (true);

CREATE POLICY "select_public"
  ON public.solicitudes_facturacion FOR SELECT TO anon USING (true);

CREATE POLICY "update_public"
  ON public.solicitudes_facturacion FOR UPDATE TO anon
  USING (true) WITH CHECK (true);

-- ── 4. STORAGE BUCKET ───────────────────────────────────────────────────
INSERT INTO storage.buckets (id, name, public)
VALUES ('facturas', 'facturas', true)
ON CONFLICT (id) DO NOTHING;

DROP POLICY IF EXISTS "upload_public" ON storage.objects;
DROP POLICY IF EXISTS "read_public"   ON storage.objects;

CREATE POLICY "upload_public"
  ON storage.objects FOR INSERT TO anon
  WITH CHECK (bucket_id = 'facturas');

CREATE POLICY "read_public"
  ON storage.objects FOR SELECT TO anon
  USING (bucket_id = 'facturas');

-- ── 5. TRIGGER UPDATED_AT ───────────────────────────────────────────────
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_updated_at ON public.solicitudes_facturacion;
CREATE TRIGGER trg_updated_at
  BEFORE UPDATE ON public.solicitudes_facturacion
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ── VERIFICACIÓN ────────────────────────────────────────────────────────
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'solicitudes_facturacion'
ORDER BY ordinal_position;
