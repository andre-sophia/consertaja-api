-- Drop existing policy
DROP POLICY IF EXISTS "Anyone can read cidades" ON cidades;

-- Create new policy that allows EVERYONE (authenticated and anon) to read cities
CREATE POLICY "Anyone can read cidades"
  ON cidades FOR SELECT
  TO anon, authenticated
  USING (true);
