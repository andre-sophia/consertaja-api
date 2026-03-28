-- Seed inicial de cidades
INSERT INTO cidades (nome, estado) VALUES
  ('São Paulo', 'SP'),
  ('Campinas', 'SP'),
  ('Ribeirão Preto', 'SP')
ON CONFLICT DO NOTHING;

-- Note: User data will be created through the application signup process
-- This file only seeds reference data (cidades)
