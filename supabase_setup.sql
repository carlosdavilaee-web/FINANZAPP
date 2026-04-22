-- =============================================
-- PEGA TODO ESTO EN SUPABASE > SQL EDITOR
-- Y PRESIONA "RUN"
-- =============================================

-- Tabla: movimientos (gastos e ingresos)
CREATE TABLE IF NOT EXISTS movimientos (
  id         BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  user_id    UUID REFERENCES auth.users NOT NULL,
  descripcion TEXT,
  monto      REAL NOT NULL,
  tipo       TEXT CHECK(tipo IN ('ingreso', 'gasto')),
  categoria  TEXT,
  fecha      DATE DEFAULT CURRENT_DATE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Tabla: metas de ahorro
CREATE TABLE IF NOT EXISTS metas (
  id             BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  user_id        UUID REFERENCES auth.users NOT NULL,
  nombre         TEXT NOT NULL,
  monto_objetivo REAL NOT NULL,
  monto_actual   REAL DEFAULT 0,
  created_at     TIMESTAMPTZ DEFAULT NOW()
);

-- Tabla: inversiones
CREATE TABLE IF NOT EXISTS inversiones (
  id            BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  user_id       UUID REFERENCES auth.users NOT NULL,
  concepto      TEXT NOT NULL,
  monto_inicial REAL NOT NULL,
  tasa_interes  REAL NOT NULL,
  tipo_tasa     TEXT CHECK(tipo_tasa IN ('anual', 'mensual')),
  tipo_interes  TEXT CHECK(tipo_interes IN ('simple', 'compuesto')),
  tiempo_meses  INTEGER NOT NULL,
  fecha_inicio  DATE,
  estado        TEXT DEFAULT 'activa',
  notas         TEXT,
  created_at    TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- SEGURIDAD: cada usuario solo ve sus datos
-- =============================================

ALTER TABLE movimientos ENABLE ROW LEVEL SECURITY;
ALTER TABLE metas       ENABLE ROW LEVEL SECURITY;
ALTER TABLE inversiones ENABLE ROW LEVEL SECURITY;

CREATE POLICY "movimientos_propios" ON movimientos
  FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "metas_propias" ON metas
  FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "inversiones_propias" ON inversiones
  FOR ALL USING (auth.uid() = user_id);
