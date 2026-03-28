import { createClient } from '@supabase/supabase-js'

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY!

// Admin client with service role (bypass RLS)
export const supabaseAdmin = createClient(supabaseUrl, supabaseServiceKey, {
  auth: {
    autoRefreshToken: false,
    persistSession: false
  }
})

// Regular client for auth operations
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
export const supabase = createClient(supabaseUrl, supabaseAnonKey)

// Types (same as frontend)
export type UserType = 'contratante' | 'prestador'

export interface Profile {
  id: string
  tipo: UserType
  nome: string
  email: string
  celular: string
  foto_url?: string
  created_at: string
  updated_at: string
}

export interface Prestador {
  id: string
  ocupacao: string
  servicos: string[]
  experiencia: string
  descricao?: string
  horario_trabalho?: string
  cidade_id: number
  total_servicos: number
  media_avaliacoes: number
  total_avaliacoes: number
  created_at: string
  updated_at: string
}

export interface Cidade {
  id: number
  nome: string
  estado: string
  created_at: string
}

export interface Avaliacao {
  id: string
  prestador_id: string
  contratante_id: string
  estrelas: number
  comentario?: string
  created_at: string
}

export interface Solicitacao {
  id: string
  contratante_id: string
  prestador_id: string
  servico: string
  descricao: string
  horario_sugerido?: string
  created_at: string
}
