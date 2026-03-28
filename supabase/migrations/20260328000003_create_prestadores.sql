-- Create prestadores table (additional data for service providers)
CREATE TABLE prestadores (
  id UUID PRIMARY KEY REFERENCES profiles(id) ON DELETE CASCADE,
  ocupacao TEXT NOT NULL,
  servicos TEXT[] NOT NULL, -- ['hidraulica', 'eletrica', 'alvenaria']
  experiencia TEXT NOT NULL,
  descricao TEXT,
  horario_trabalho TEXT,
  cidade_id INTEGER REFERENCES cidades(id) NOT NULL,
  total_servicos INTEGER DEFAULT 0,
  media_avaliacoes DECIMAL(2,1) DEFAULT 0,
  total_avaliacoes INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE prestadores ENABLE ROW LEVEL SECURITY;

-- Policies for prestadores
-- Anyone authenticated can read all prestadores (for catalog)
CREATE POLICY "Anyone can read prestadores"
  ON prestadores FOR SELECT
  TO authenticated
  USING (true);

-- Prestadores can update their own profile
CREATE POLICY "Prestadores can update own profile"
  ON prestadores FOR UPDATE
  USING (auth.uid() = id);

-- Prestadores can insert their own profile (on signup)
CREATE POLICY "Prestadores can insert own profile"
  ON prestadores FOR INSERT
  WITH CHECK (auth.uid() = id);

-- Trigger to auto-update updated_at
CREATE TRIGGER update_prestadores_updated_at
  BEFORE UPDATE ON prestadores
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Indexes for faster queries
CREATE INDEX idx_prestadores_cidade ON prestadores(cidade_id);
CREATE INDEX idx_prestadores_servicos ON prestadores USING GIN(servicos);
CREATE INDEX idx_prestadores_media_avaliacoes ON prestadores(media_avaliacoes DESC);

-- Function to update prestador statistics when avaliacao is added
CREATE OR REPLACE FUNCTION update_prestador_stats()
RETURNS TRIGGER AS $$
BEGIN
  -- Recalculate average and total
  UPDATE prestadores
  SET
    media_avaliacoes = (
      SELECT ROUND(AVG(estrelas)::numeric, 1)
      FROM avaliacoes
      WHERE prestador_id = NEW.prestador_id
    ),
    total_avaliacoes = (
      SELECT COUNT(*)
      FROM avaliacoes
      WHERE prestador_id = NEW.prestador_id
    )
  WHERE id = NEW.prestador_id;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
