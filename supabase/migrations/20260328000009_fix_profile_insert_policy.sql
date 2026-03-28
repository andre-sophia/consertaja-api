-- Fix RLS policy for profiles to allow signup
-- The issue: auth.uid() returns null during signup because session isn't established yet
-- Solution: Allow anon role to insert profiles during signup process

-- Drop existing insert policy
DROP POLICY IF EXISTS "Users can insert own profile" ON profiles;

-- Create new policy that allows both anon and authenticated users to insert
-- This is safe because we still check that the id matches the auth user
CREATE POLICY "Users can insert own profile on signup"
  ON profiles FOR INSERT
  TO anon, authenticated
  WITH CHECK (auth.uid() = id);
