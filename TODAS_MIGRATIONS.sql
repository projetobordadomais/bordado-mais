
CREATE TABLE IF NOT EXISTS public.clients (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    whatsapp TEXT,
    city TEXT,
    birthday DATE,
    notes TEXT,
    cpf TEXT,
    email TEXT,
    endereco_rua TEXT,
    endereco_numero TEXT,
    endereco_bairro TEXT,
    endereco_cidade TEXT,
    endereco_estado TEXT,
    endereco_cep TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.inventory_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    category TEXT NOT NULL,
    quantity DECIMAL(10,2) DEFAULT 0,
    min_quantity DECIMAL(10,2) DEFAULT 0,
    unit_cost DECIMAL(10,2) DEFAULT 0,
    unit TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    client_id UUID REFERENCES public.clients(id) ON DELETE CASCADE,
    description TEXT NOT NULL,
    start_date DATE,
    delivery_date DATE,
    value DECIMAL(10,2) DEFAULT 0,
    status TEXT DEFAULT 'em_aberto',
    notes TEXT,
    photo_url TEXT,
    codigo_rastreio TEXT,
    rastreio_enviado_em TIMESTAMPTZ,
    orcamento_id UUID,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.inventory_movements (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    inventory_item_id UUID REFERENCES public.inventory_items(id) ON DELETE CASCADE,
    order_id UUID REFERENCES public.orders(id) ON DELETE SET NULL,
    movement_type TEXT NOT NULL,
    quantity DECIMAL(10,2) NOT NULL,
    unit_cost DECIMAL(10,2),
    total_cost DECIMAL(10,2),
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.order_materials (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID REFERENCES public.orders(id) ON DELETE CASCADE,
    inventory_item_id UUID REFERENCES public.inventory_items(id) ON DELETE SET NULL,
    item_name TEXT,
    quantity DECIMAL(10,2),
    unit_cost DECIMAL(10,2),
    total_cost DECIMAL(10,2),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.time_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    order_id UUID REFERENCES public.orders(id) ON DELETE SET NULL,
    activity_description TEXT NOT NULL,
    started_at TIMESTAMPTZ NOT NULL,
    stopped_at TIMESTAMPTZ,
    duration_minutes DECIMAL(10,2),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.orcamentos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    numero INT,
    cliente_nome TEXT,
    cliente_contato TEXT,
    cliente_cpf TEXT,
    cliente_endereco_cep TEXT,
    cliente_endereco_rua TEXT,
    cliente_endereco_numero TEXT,
    cliente_endereco_bairro TEXT,
    cliente_endereco_cidade TEXT,
    cliente_endereco_estado TEXT,
    valor_frete DECIMAL(10,2),
    validade_dias INT DEFAULT 7,
    condicoes_pagamento TEXT,
    prazo_entrega TEXT,
    observacoes TEXT,
    encomenda_id UUID REFERENCES public.orders(id) ON DELETE SET NULL,
    total DECIMAL(10,2),
    status TEXT DEFAULT 'pendente',
    token_publico UUID DEFAULT uuid_generate_v4(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.orcamento_itens (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    orcamento_id UUID REFERENCES public.orcamentos(id) ON DELETE CASCADE,
    descricao TEXT,
    quantidade DECIMAL(10,2),
    valor_unitario DECIMAL(10,2),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.aprovacao_arte (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    orcamento_id UUID REFERENCES public.orcamentos(id) ON DELETE CASCADE,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    arquivo_nome TEXT,
    arquivo_url TEXT,
    arquivo_tipo TEXT,
    token_publico UUID DEFAULT uuid_generate_v4(),
    status TEXT DEFAULT 'pendente',
    feedback_cliente TEXT,
    expires_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.waitlist (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email TEXT UNIQUE NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.email_campaigns (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    subject TEXT,
    body_html TEXT,
    sent_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.coupons (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code TEXT NOT NULL UNIQUE,
    discount_value DECIMAL(10,2),
    max_uses INT,
    current_uses INT DEFAULT 0,
    active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.invites (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code TEXT NOT NULL UNIQUE,
    used BOOLEAN DEFAULT false,
    used_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    used_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.auth_tokens (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    provider TEXT NOT NULL,
    access_token TEXT NOT NULL,
    refresh_token TEXT,
    expires_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, provider)
);

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_cron";

-- Create Enum Types
DROP TYPE IF EXISTS public.user_role CASCADE;
CREATE TYPE public.user_role AS ENUM ('admin', 'user');
DROP TYPE IF EXISTS public.user_plan CASCADE;
CREATE TYPE public.user_plan AS ENUM ('free', 'premium');
DROP TYPE IF EXISTS public.user_status CASCADE;
CREATE TYPE public.user_status AS ENUM ('active', 'blocked');
DROP TYPE IF EXISTS public.payment_status CASCADE;
CREATE TYPE public.payment_status AS ENUM ('pending', 'approved', 'failed', 'refunded');
DROP TYPE IF EXISTS public.payment_method CASCADE;
CREATE TYPE public.payment_method AS ENUM ('credit_card', 'pix');
DROP TYPE IF EXISTS public.generation_type CASCADE;
CREATE TYPE public.generation_type AS ENUM ('risco', 'bordado_colorido');
DROP TYPE IF EXISTS public.generation_status CASCADE;
CREATE TYPE public.generation_status AS ENUM ('pending', 'processing', 'completed', 'failed');
DROP TYPE IF EXISTS public.transaction_type CASCADE;
CREATE TYPE public.transaction_type AS ENUM ('income', 'expense');

-- ==========================================
-- TABLES
-- ==========================================

-- profiles
CREATE TABLE public.profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL UNIQUE,
  full_name TEXT NOT NULL,
  cpf TEXT UNIQUE, -- Permitido nulo inicialmente, definido na complementação de cadastro
  phone TEXT,
  address_street TEXT,
  address_number TEXT,
  address_complement TEXT,
  address_neighborhood TEXT,
  address_city TEXT,
  address_state TEXT,
  address_zip TEXT,
  role user_role DEFAULT 'user',
  plan user_plan DEFAULT 'free',
  status user_status DEFAULT 'active',
  
  -- Controle de assinaturas e acessos free
  free_generations_used INT DEFAULT 0,
  free_cycle_expires_at TIMESTAMPTZ,
  premium_starts_at TIMESTAMPTZ,
  premium_expires_at TIMESTAMPTZ,
  
  aceitou_termos BOOLEAN DEFAULT false,
  termos_aceitos_em TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- plan_config
CREATE TABLE public.plan_config (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  premium_price_brl DECIMAL(10,2) NOT NULL,
  premium_duration_months INT DEFAULT 12,
  free_generations_limit INT DEFAULT 2,
  premium_generations_limit INT,
  updated_by UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE public.plan_config ADD COLUMN IF NOT EXISTS app_name TEXT;

-- payments
CREATE TABLE public.payments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  plan_config_id UUID REFERENCES public.plan_config(id) ON DELETE SET NULL,
  amount_brl DECIMAL(10,2) NOT NULL,
  status payment_status DEFAULT 'pending',
  payment_method payment_method,
  gateway_transaction_id TEXT,
  gateway_response JSONB,
  paid_at TIMESTAMPTZ,
  expires_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- generations
CREATE TABLE public.generations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  generation_type generation_type NOT NULL,
  status generation_status DEFAULT 'pending',
  form_data JSONB DEFAULT '{}',
  prompt_used TEXT,
  image_storage_path TEXT,
  image_public_url TEXT,
  image_expires_at TIMESTAMPTZ,
  plan_at_generation user_plan,
  error_message TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  completed_at TIMESTAMPTZ
);

-- financial_records
CREATE TABLE public.financial_records (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  type transaction_type NOT NULL,
  category TEXT,
  description TEXT NOT NULL,
  amount_brl DECIMAL(10,2) NOT NULL,
  record_date DATE NOT NULL,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- pricing_calculations
CREATE TABLE public.pricing_calculations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  product_name TEXT,
  materials_cost DECIMAL(10,2),
  labor_hours DECIMAL(5,2),
  hourly_rate DECIMAL(10,2),
  overhead_cost DECIMAL(10,2),
  profit_margin DECIMAL(5,2),
  final_price DECIMAL(10,2),
  form_data JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- strategy_conversations
CREATE TABLE public.strategy_conversations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  title TEXT,
  messages JSONB DEFAULT '[]',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ==========================================
-- INDEXES
-- ==========================================

-- profiles
CREATE INDEX idx_profiles_email ON public.profiles(email);
CREATE INDEX idx_profiles_cpf ON public.profiles(cpf);
CREATE INDEX idx_profiles_plan ON public.profiles(plan);
CREATE INDEX idx_profiles_status ON public.profiles(status);
CREATE INDEX idx_profiles_premium_expires ON public.profiles(premium_expires_at);
CREATE INDEX idx_profiles_free_cycle_expires ON public.profiles(free_cycle_expires_at);

-- payments
CREATE INDEX idx_payments_user_id ON public.payments(user_id);
CREATE INDEX idx_payments_status ON public.payments(status);
CREATE INDEX idx_payments_gateway_transaction ON public.payments(gateway_transaction_id);

-- generations
CREATE INDEX idx_generations_user_id ON public.generations(user_id);
CREATE INDEX idx_generations_status ON public.generations(status);
CREATE INDEX idx_generations_expires_at ON public.generations(image_expires_at);
CREATE INDEX idx_generations_type ON public.generations(generation_type);

-- financial_records
CREATE INDEX idx_financial_records_user_id ON public.financial_records(user_id);
CREATE INDEX idx_financial_records_date ON public.financial_records(record_date);
CREATE INDEX idx_financial_records_type ON public.financial_records(type);

-- pricing_calculations
CREATE INDEX idx_pricing_user_id ON public.pricing_calculations(user_id);

-- strategy_conversations
CREATE INDEX idx_strategy_user_id ON public.strategy_conversations(user_id);


-- ==========================================
-- FUNCTIONS & TRIGGERS
-- ==========================================

-- 1. update_updated_at function
CREATE OR REPLACE FUNCTION public.update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_profiles_updated_at
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

CREATE TRIGGER update_financial_records_updated_at
  BEFORE UPDATE ON public.financial_records
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

CREATE TRIGGER update_strategy_conversations_updated_at
  BEFORE UPDATE ON public.strategy_conversations
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

CREATE TRIGGER update_plan_config_updated_at
  BEFORE UPDATE ON public.plan_config
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();


-- 2. Trigger: Criar profile automaticamente no Auth
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (
    id, 
    email, 
    full_name, 
    role, 
    plan, 
    free_cycle_expires_at
  )
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', 'Usuário'),
    'user',
    'free',
    NOW() + INTERVAL '30 days'
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();


-- 3. Função: Resetar ciclo free
CREATE OR REPLACE FUNCTION public.reset_free_cycle(p_user_id UUID)
RETURNS VOID AS $$
BEGIN
  UPDATE public.profiles
  SET free_generations_used = 0,
      free_cycle_expires_at = NOW() + INTERVAL '30 days'
  WHERE id = p_user_id AND (free_cycle_expires_at < NOW() OR free_cycle_expires_at IS NULL);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- 4. Função: Ativar premium
CREATE OR REPLACE FUNCTION public.activate_premium(p_user_id UUID, p_payment_id UUID, p_duration_months INT DEFAULT 12)
RETURNS VOID AS $$
BEGIN
  UPDATE public.profiles
  SET plan = 'premium',
      premium_starts_at = NOW(),
      premium_expires_at = NOW() + (p_duration_months || ' months')::INTERVAL
  WHERE id = p_user_id;

  UPDATE public.payments
  SET status = 'approved',
      paid_at = NOW(),
      expires_at = NOW() + (p_duration_months || ' months')::INTERVAL
  WHERE id = p_payment_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- 5. Função: Revogar premium por reembolso
CREATE OR REPLACE FUNCTION public.revoke_premium(p_user_id UUID, p_payment_id UUID)
RETURNS VOID AS $$
BEGIN
  UPDATE public.profiles
  SET plan = 'free',
      premium_starts_at = NULL,
      premium_expires_at = NULL
  WHERE id = p_user_id;

  UPDATE public.payments
  SET status = 'refunded'
  WHERE id = p_payment_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- Admin check RLS helper function
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.profiles 
    WHERE id = auth.uid() AND role = 'admin'
  );
$$ LANGUAGE sql SECURITY DEFINER SET search_path = public;


-- ==========================================
-- JOBS PG_CRON
-- ==========================================

-- 1. Limpar imagens expiradas a cada 30 minutos
SELECT cron.schedule(
  'limpar_imagens_expiradas',
  '*/30 * * * *',
  $$
  UPDATE public.generations
  SET image_storage_path = NULL,
      image_public_url = NULL
  WHERE image_expires_at < NOW() AND image_storage_path IS NOT NULL;
  $$
);

-- 2. Todo dia à meia-noite: expirar assinaturas premium vencidas
SELECT cron.schedule(
  'expirar_assinaturas_premium',
  '0 0 * * *',
  $$
  UPDATE public.profiles
  SET plan = 'free',
      premium_starts_at = NULL,
      premium_expires_at = NULL
  WHERE plan = 'premium' AND premium_expires_at < NOW();
  $$
);


-- ==========================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ==========================================

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.plan_config ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.generations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.financial_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.pricing_calculations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.strategy_conversations ENABLE ROW LEVEL SECURITY;

-- profiles
CREATE POLICY "Users can view own profile" ON public.profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON public.profiles FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Admins can perform all actions on profiles" ON public.profiles USING (public.is_admin());

-- payments
CREATE POLICY "Users can view own payments" ON public.payments FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Admins can view all payments" ON public.payments FOR SELECT USING (public.is_admin());

-- generations
CREATE POLICY "Users can view own generations" ON public.generations FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own generations" ON public.generations FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own generations" ON public.generations FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Admins can view all generations" ON public.generations FOR SELECT USING (public.is_admin());

-- financial_records
CREATE POLICY "Users can fully manage own financial records" ON public.financial_records USING (auth.uid() = user_id);
CREATE POLICY "Admins can view all financial records" ON public.financial_records FOR SELECT USING (public.is_admin());

-- pricing_calculations
CREATE POLICY "Users can fully manage own pricing calculations" ON public.pricing_calculations USING (auth.uid() = user_id);
CREATE POLICY "Admins can view all pricing calculations" ON public.pricing_calculations FOR SELECT USING (public.is_admin());

-- strategy_conversations
CREATE POLICY "Users can fully manage own strategy conversations" ON public.strategy_conversations USING (auth.uid() = user_id);
CREATE POLICY "Admins can view all strategy conversations" ON public.strategy_conversations FOR SELECT USING (public.is_admin());

-- plan_config
CREATE POLICY "Anyone authenticated can view plan config" ON public.plan_config FOR SELECT TO authenticated USING (true);
CREATE POLICY "Admins can fully manage plan config" ON public.plan_config USING (public.is_admin());


-- ==========================================
-- DADOS INICIAIS
-- ==========================================

INSERT INTO public.plan_config (premium_price_brl, premium_duration_months, free_generations_limit, premium_generations_limit)
VALUES (97.00, 12, 2, NULL);

-- NOTA: Admin privileges should be granted via Supabase Dashboard manually or via Edge Functions
-- UPDATE profiles SET role = 'admin' WHERE email IN ('email_cairon@dominio.com', 'email_suelen@dominio.com');
-- Adicionando coluna para separar créditos mensais (free_generations_used decresce do limite mensal) 
-- dos créditos avulsos vitálícios (extra_credits).
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS extra_credits INT DEFAULT 0;

-- Adicionando vínculo de pacote na tabela de pagamentos para que o webhook diferencie Assinatura vs Lote
ALTER TABLE payments ADD COLUMN IF NOT EXISTS package_id UUID;

-- Tabela de Pacotes Avulsos (Vitrine)
CREATE TABLE credit_packages (
  id            UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name          TEXT NOT NULL,
  credit_amount INT NOT NULL,
  price_brl     DECIMAL(10,2) NOT NULL,
  active        BOOLEAN DEFAULT TRUE,
  display_order INT DEFAULT 0,
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  updated_at    TIMESTAMPTZ DEFAULT NOW()
);

-- Dados iniciais (Loja de Add-ons)
INSERT INTO credit_packages (name, credit_amount, price_brl, display_order) VALUES
  ('Pacote Bronze', 10,  19.90, 1),
  ('Pacote Prata',  30,  49.90, 2),
  ('Pacote Ouro',   100, 129.90, 3);

-- Segurança e Políticas de Acesso
ALTER TABLE credit_packages ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated can view active packages" ON credit_packages
  FOR SELECT USING (auth.role() = 'authenticated' AND active = TRUE);

CREATE POLICY "Admin can manage packages" ON credit_packages
  FOR ALL USING (EXISTS (
    SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'
  ));

-- Trigger para atualizar `updated_at` na tabela de pacotes
CREATE TRIGGER update_credit_packages_updated_at
  BEFORE UPDATE ON credit_packages
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

-- RPC: Injeção de Créditos em Massa (Mutirão)
CREATE OR REPLACE FUNCTION grant_bulk_credits(p_amount INT)
RETURNS void AS $$
BEGIN
  UPDATE profiles
  SET extra_credits = extra_credits + p_amount
  WHERE status = 'active';
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
-- Create financial_transactions table
CREATE TABLE IF NOT EXISTS financial_transactions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  description TEXT NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  type TEXT CHECK (type IN ('receita', 'despesa')) NOT NULL,
  category TEXT NOT NULL,
  transaction_date DATE NOT NULL DEFAULT CURRENT_DATE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE financial_transactions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own transactions" ON financial_transactions
  FOR ALL USING (auth.uid() = user_id);

-- Create strategy_conversations table for Lia Strategy Chat
CREATE TABLE IF NOT EXISTS strategy_conversations (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  messages JSONB DEFAULT '[]'::jsonb,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE strategy_conversations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own chat sessions" ON strategy_conversations
  FOR ALL USING (auth.uid() = user_id);
-- 1. PLAN CONFIG UPDATES
ALTER TABLE plan_config
ADD COLUMN IF NOT EXISTS free_welcome_credits INT DEFAULT 2,
ADD COLUMN IF NOT EXISTS premium_lia_messages INT DEFAULT 70,
ADD COLUMN IF NOT EXISTS premium_price_brl DECIMAL(10,2) DEFAULT 97.00;

UPDATE plan_config SET
  free_generations_limit = 3,
  free_welcome_credits = 2,
  premium_generations_limit = 15,
  premium_lia_messages = 70,
  premium_price_brl = 97.00;

-- 2. CREDIT PACKAGES
DELETE FROM credit_packages;

INSERT INTO credit_packages (name, credit_amount, price_brl, active) VALUES
('Pacote Inicial', 5, 19.90, true),
('Pacote Popular', 15, 49.90, true),
('Pacote Completo', 30, 99.90, true);

-- 3. PROFILE EXTRA CREDITS AND REFERRAL CODE
ALTER TABLE profiles
ADD COLUMN IF NOT EXISTS referral_code TEXT UNIQUE,
ADD COLUMN IF NOT EXISTS extra_credits INT DEFAULT 0,
ADD COLUMN IF NOT EXISTS welcome_credits_used BOOLEAN DEFAULT false;

UPDATE profiles
SET referral_code = LOWER(SUBSTRING(REPLACE(gen_random_uuid()::text, '-', ''), 1, 8))
WHERE referral_code IS NULL;

-- Garante que todos os perfis legados também ganhem seus 2 créditos de boas vindas retroativos
UPDATE profiles
SET extra_credits = COALESCE(extra_credits, 0) + 2
WHERE welcome_credits_used = false AND COALESCE(extra_credits, 0) = 0;

-- 4. REFERRALS TABLE
CREATE TABLE IF NOT EXISTS referrals (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  referrer_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  referred_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  credits_granted BOOLEAN DEFAULT false
);

ALTER TABLE referrals ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own referrals" ON referrals
  FOR SELECT USING (auth.uid() = referrer_id);

CREATE POLICY "System can insert referrals" ON referrals
  FOR INSERT WITH CHECK (true); -- Permitimos insert no frontend na hora do signup se precisar, ou via DB

-- 5. NOTIFICATIONS TABLE
CREATE TABLE IF NOT EXISTS notifications (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  message TEXT NOT NULL,
  type TEXT DEFAULT 'info',
  read BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own notifications" ON notifications
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can update own notifications" ON notifications
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own notifications" ON notifications
  FOR INSERT WITH CHECK (true); -- Permite inserir a info da notificacao de indicacao

-- 6. PROFILE CREATION TRIGGER (WITH WELCOME CREDITS AND REFERRAL_CODE)
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (
    id, 
    email, 
    full_name, 
    role, 
    plan, 
    free_cycle_expires_at,
    extra_credits,
    referral_code
  )
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', 'Usuário'),
    'user',
    'free',
    NOW() + INTERVAL '30 days',
    2, -- 2 Welcome Credits
    LOWER(SUBSTRING(REPLACE(gen_random_uuid()::text, '-', ''), 1, 8))
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
ALTER TABLE invites ADD COLUMN IF NOT EXISTS plan_type TEXT DEFAULT 'free'; ALTER TABLE invites ADD COLUMN IF NOT EXISTS premium_duration_months INT;
-- Nova tabela para registrar o uso individual de cupons
CREATE TABLE IF NOT EXISTS public.user_coupons (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  coupon_id UUID REFERENCES public.coupons(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, coupon_id)
);

-- Configurações RLS Opcionais
ALTER TABLE public.user_coupons ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own coupon usages" 
  ON public.user_coupons FOR SELECT 
  USING (auth.uid() = user_id);

CREATE POLICY "Admins can view all coupon usages" 
  ON public.user_coupons FOR SELECT 
  USING (public.is_admin());
-- Alterando a coluna status da tabela orders para TEXT puro,
-- removendo restrições de ENUM ou CHECK para dar total liberdade ao frontend.

DO $$ 
BEGIN 
    -- 1. Se houver alguma constraint do tipo CHECK na coluna, vamos derrubar.
    -- O nome normalmente é orders_status_check ou parecido, mas tentaremos os mais comuns.
    ALTER TABLE IF EXISTS public.orders DROP CONSTRAINT IF EXISTS orders_status_check;
    ALTER TABLE IF EXISTS public.orders DROP CONSTRAINT IF EXISTS orders_status_check1;
    
    -- 2. Alterar o tipo da coluna para TEXT definitivamente
    -- Isso lida automagicamente caso a coluna atual fosse um ENUM customizado.
    ALTER TABLE public.orders ALTER COLUMN status TYPE TEXT USING status::text;
    
    -- 3. Definir um valor padrão seguro
    ALTER TABLE public.orders ALTER COLUMN status SET DEFAULT 'em_aberto'::text;
END $$;
-- 1. ADD PARTNER COLUMNS TO PROFILES
ALTER TABLE public.profiles
ADD COLUMN IF NOT EXISTS is_partner BOOLEAN DEFAULT false,
ADD COLUMN IF NOT EXISTS partner_commission_percent DECIMAL(5,2) DEFAULT 0.00;

-- 2. CREATE PARTNER COMMISSIONS TABLE
CREATE TABLE IF NOT EXISTS public.partner_commissions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    partner_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    referred_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
    payment_id UUID REFERENCES public.payments(id) ON DELETE SET NULL,
    amount DECIMAL(10,2) NOT NULL,
    status VARCHAR DEFAULT 'pending', -- 'pending' ou 'paid'
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. RLS POLICIES FOR PARTNER COMMISSIONS
ALTER TABLE public.partner_commissions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Partners can view own commissions"
    ON public.partner_commissions FOR SELECT
    USING (auth.uid() = partner_id);

CREATE POLICY "Admins can fully manage partner commissions"
    ON public.partner_commissions
    USING (public.is_admin());

-- 4. TRIGGER FUNCTION FOR UPDATING updated_at
CREATE TRIGGER update_partner_commissions_updated_at
    BEFORE UPDATE ON public.partner_commissions
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

-- 5. TRIGGER FOR GENERATING COMMISSIONS ON PAYMENT APPROVAL
CREATE OR REPLACE FUNCTION public.generate_partner_commission()
RETURNS TRIGGER AS $$
DECLARE
    v_referrer_id UUID;
    v_is_partner BOOLEAN;
    v_commission_percent DECIMAL;
    v_commission_amount DECIMAL;
BEGIN
    -- Only act when payment status becomes 'approved'
    IF NEW.status = 'approved' AND (OLD.status IS NULL OR OLD.status != 'approved') THEN
        -- Find if user was referred
        SELECT referrer_id INTO v_referrer_id 
        FROM public.referrals 
        WHERE referred_id = NEW.user_id 
        LIMIT 1;

        IF v_referrer_id IS NOT NULL THEN
            -- Check if referrer is a partner
            SELECT is_partner, partner_commission_percent 
            INTO v_is_partner, v_commission_percent
            FROM public.profiles
            WHERE id = v_referrer_id;

            -- If they are a partner and have a percentage configured
            IF v_is_partner = true AND v_commission_percent > 0 THEN
                -- Calculate commission amount
                v_commission_amount := (NEW.amount_brl * v_commission_percent) / 100.0;

                -- Insert into commissions table
                INSERT INTO public.partner_commissions (
                    partner_id, referred_id, payment_id, amount, status
                ) VALUES (
                    v_referrer_id, NEW.user_id, NEW.id, v_commission_amount, 'pending'
                );
            END IF;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Drop trigger if exists to avoid errors on reruns
DROP TRIGGER IF EXISTS on_payment_approved_commission ON public.payments;

CREATE TRIGGER on_payment_approved_commission
    AFTER UPDATE ON public.payments
    FOR EACH ROW EXECUTE FUNCTION public.generate_partner_commission();
-- Adiciona a coluna partner_id à tabela coupons para vincular cupons a parceiras
ALTER TABLE public.coupons ADD COLUMN IF NOT EXISTS partner_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL;
ALTER TABLE public.coupons ADD COLUMN IF NOT EXISTS is_partner_coupon BOOLEAN DEFAULT false;

-- Atualiza a documentação da tabela
COMMENT ON COLUMN public.coupons.partner_id IS 'ID da parceira caso seja um cupom exclusivo gerado para ela';
COMMENT ON COLUMN public.coupons.is_partner_coupon IS 'Flag para identificar se o cupom é atrelado a parceiros e gera indicação automática';
-- 1. Create campaign_config table
CREATE TABLE IF NOT EXISTS public.campaign_config (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  general_trial_limit INT DEFAULT 50,
  general_trial_used INT DEFAULT 0,
  partner_trial_limit INT DEFAULT 50,
  partner_trial_used INT DEFAULT 0,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Insert initial config if not exists
INSERT INTO public.campaign_config (general_trial_limit, partner_trial_limit)
SELECT 50, 50
WHERE NOT EXISTS (SELECT 1 FROM public.campaign_config);

-- RLS
ALTER TABLE public.campaign_config ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can view campaign config" ON public.campaign_config FOR SELECT TO authenticated USING (true);
CREATE POLICY "Admins can manage campaign config" ON public.campaign_config USING (public.is_admin());

-- 2. Update profiles for trial tracking
ALTER TABLE public.profiles
ADD COLUMN IF NOT EXISTS had_trial BOOLEAN DEFAULT false,
ADD COLUMN IF NOT EXISTS trial_starts_at TIMESTAMPTZ,
ADD COLUMN IF NOT EXISTS trial_expires_at TIMESTAMPTZ;

-- 4. Insert FUNDADORA20 coupon if not exists
INSERT INTO public.coupons (code, discount_value, max_uses, current_uses, active)
VALUES ('FUNDADORA20', 20.00, 15, 0, true)
ON CONFLICT (code) DO UPDATE 
SET discount_value = 20.00, max_uses = 15;

-- 5. Create View for Trial Stats
CREATE OR REPLACE VIEW public.trial_stats_view AS
SELECT
  (SELECT general_trial_limit FROM public.campaign_config LIMIT 1) as general_trial_limit,
  (SELECT general_trial_used FROM public.campaign_config LIMIT 1) as general_trial_used,
  (SELECT partner_trial_limit FROM public.campaign_config LIMIT 1) as partner_trial_limit,
  (SELECT partner_trial_used FROM public.campaign_config LIMIT 1) as partner_trial_used,
  (SELECT count(*) FROM public.profiles WHERE had_trial = true) as total_trials_initiated,
  (SELECT count(*) FROM public.profiles WHERE had_trial = true AND plan = 'premium' AND (trial_expires_at IS NULL OR trial_expires_at < NOW())) as total_conversions;
-- Atualiza o nome do aplicativo na tabela plan_config para o novo white-label Bordado+
UPDATE plan_config 
SET app_name = 'Bordado+' 
WHERE id IS NOT NULL;



