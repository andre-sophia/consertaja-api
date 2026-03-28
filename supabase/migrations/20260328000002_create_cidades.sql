-- Create cidades table
CREATE TABLE cidades (
  id SERIAL PRIMARY KEY,
  nome TEXT NOT NULL,
  estado TEXT NOT NULL DEFAULT 'SP',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE cidades ENABLE ROW LEVEL SECURITY;

-- Anyone can read cidades
CREATE POLICY "Anyone can read cidades"
  ON cidades FOR SELECT
  TO authenticated
  USING (true);

-- Index for faster queries
CREATE INDEX idx_cidades_nome ON cidades(nome);
