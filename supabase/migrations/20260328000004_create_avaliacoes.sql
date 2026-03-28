-- Create avaliacoes table
CREATE TABLE avaliacoes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  prestador_id UUID REFERENCES prestadores(id) ON DELETE CASCADE NOT NULL,
  contratante_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  estrelas INTEGER CHECK (estrelas >= 1 AND estrelas <= 5) NOT NULL,
  comentario TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE avaliacoes ENABLE ROW LEVEL SECURITY;

-- Policies for avaliacoes
-- Anyone can read avaliacoes
CREATE POLICY "Anyone can read avaliacoes"
  ON avaliacoes FOR SELECT
  TO authenticated
  USING (true);

-- Only contratantes can create avaliacoes
CREATE POLICY "Contratantes can create avaliacoes"
  ON avaliacoes FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid() AND tipo = 'contratante'
    )
  );

-- Contratantes can update their own avaliacoes
CREATE POLICY "Contratantes can update own avaliacoes"
  ON avaliacoes FOR UPDATE
  USING (auth.uid() = contratante_id);

-- Trigger to update prestador stats when avaliacao is created
CREATE TRIGGER update_prestador_stats_on_avaliacao
  AFTER INSERT ON avaliacoes
  FOR EACH ROW
  EXECUTE FUNCTION update_prestador_stats();

-- Indexes for faster queries
CREATE INDEX idx_avaliacoes_prestador ON avaliacoes(prestador_id);
CREATE INDEX idx_avaliacoes_contratante ON avaliacoes(contratante_id);
CREATE INDEX idx_avaliacoes_created_at ON avaliacoes(created_at DESC);
