-- Create solicitacoes table (WhatsApp request history)
CREATE TABLE solicitacoes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  contratante_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  prestador_id UUID REFERENCES prestadores(id) ON DELETE CASCADE NOT NULL,
  servico TEXT NOT NULL,
  descricao TEXT NOT NULL,
  horario_sugerido TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE solicitacoes ENABLE ROW LEVEL SECURITY;

-- Policies for solicitacoes
-- Users can read their own solicitacoes
CREATE POLICY "Users can read own solicitacoes"
  ON solicitacoes FOR SELECT
  USING (
    auth.uid() = contratante_id OR auth.uid() = prestador_id
  );

-- Contratantes can create solicitacoes
CREATE POLICY "Contratantes can create solicitacoes"
  ON solicitacoes FOR INSERT
  WITH CHECK (
    auth.uid() = contratante_id AND
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid() AND tipo = 'contratante'
    )
  );

-- Indexes for faster queries
CREATE INDEX idx_solicitacoes_contratante ON solicitacoes(contratante_id, created_at DESC);
CREATE INDEX idx_solicitacoes_prestador ON solicitacoes(prestador_id, created_at DESC);
CREATE INDEX idx_solicitacoes_created_at ON solicitacoes(created_at DESC);
