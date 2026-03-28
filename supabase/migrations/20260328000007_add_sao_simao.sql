-- Add São Simão city
INSERT INTO cidades (nome, estado)
VALUES ('São Simão', 'SP')
ON CONFLICT DO NOTHING;
