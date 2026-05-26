-- ==========================================
-- CORREÇÃO DE POLÍTICAS DE RLS (ROW LEVEL SECURITY)
-- ESTE SCRIPT CORRIGE O ERRO: "new row violates row-level security policy for table time_sessions"
-- ==========================================

-- 1. Ativar RLS em todas as tabelas do sistema de gestão que não tinham
ALTER TABLE public.clients ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.inventory_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.inventory_movements ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.order_materials ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.time_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.orcamentos ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.orcamento_itens ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.aprovacao_arte ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.auth_tokens ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.waitlist ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.email_campaigns ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.coupons ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.invites ENABLE ROW LEVEL SECURITY;

-- 2. Criar as Políticas (Policies)
-- A lógica padrão: O usuário autenticado (auth.uid()) só pode interagir com os dados onde o user_id for igual ao dele.
-- Admins têm acesso total.

-- CLIENTS
CREATE POLICY "Users can fully manage own clients" ON public.clients USING (auth.uid() = user_id);
CREATE POLICY "Admins can view all clients" ON public.clients FOR SELECT USING (public.is_admin());

-- INVENTORY_ITEMS
CREATE POLICY "Users can fully manage own inventory items" ON public.inventory_items USING (auth.uid() = user_id);
CREATE POLICY "Admins can view all inventory items" ON public.inventory_items FOR SELECT USING (public.is_admin());

-- ORDERS
CREATE POLICY "Users can fully manage own orders" ON public.orders USING (auth.uid() = user_id);
CREATE POLICY "Admins can view all orders" ON public.orders FOR SELECT USING (public.is_admin());

-- INVENTORY_MOVEMENTS
CREATE POLICY "Users can fully manage own inventory movements" ON public.inventory_movements USING (auth.uid() = user_id);
CREATE POLICY "Admins can view all inventory movements" ON public.inventory_movements FOR SELECT USING (public.is_admin());

-- TIME_SESSIONS (Cronômetro)
CREATE POLICY "Users can fully manage own time sessions" ON public.time_sessions USING (auth.uid() = user_id);
CREATE POLICY "Admins can view all time sessions" ON public.time_sessions FOR SELECT USING (public.is_admin());

-- ORCAMENTOS
CREATE POLICY "Users can fully manage own orcamentos" ON public.orcamentos USING (auth.uid() = user_id);
CREATE POLICY "Admins can view all orcamentos" ON public.orcamentos FOR SELECT USING (public.is_admin());

-- APROVACAO_ARTE
CREATE POLICY "Users can fully manage own aprovacao arte" ON public.aprovacao_arte USING (auth.uid() = user_id);
CREATE POLICY "Admins can view all aprovacao arte" ON public.aprovacao_arte FOR SELECT USING (public.is_admin());

-- AUTH_TOKENS
CREATE POLICY "Users can manage own auth tokens" ON public.auth_tokens USING (auth.uid() = user_id);

-- ORDER_MATERIALS (Depende da tabela orders)
-- O usuário pode gerenciar materiais de um pedido se ele for o dono do pedido
CREATE POLICY "Users can manage materials of own orders" ON public.order_materials 
USING (EXISTS (SELECT 1 FROM public.orders WHERE orders.id = order_materials.order_id AND orders.user_id = auth.uid()));

-- ORCAMENTO_ITENS (Depende da tabela orcamentos)
CREATE POLICY "Users can manage itens of own orcamentos" ON public.orcamento_itens 
USING (EXISTS (SELECT 1 FROM public.orcamentos WHERE orcamentos.id = orcamento_itens.orcamento_id AND orcamentos.user_id = auth.uid()));

-- WAITLIST (Qualquer um pode inserir, apenas admins podem ver)
CREATE POLICY "Anyone can insert into waitlist" ON public.waitlist FOR INSERT WITH CHECK (true);
CREATE POLICY "Admins can view waitlist" ON public.waitlist FOR SELECT USING (public.is_admin());

-- EMAIL_CAMPAIGNS (Apenas admins)
CREATE POLICY "Admins can fully manage email campaigns" ON public.email_campaigns USING (public.is_admin());

-- COUPONS (Qualquer um pode ver cupons ativos, admins podem gerenciar)
CREATE POLICY "Anyone can view active coupons" ON public.coupons FOR SELECT USING (active = true OR public.is_admin());
CREATE POLICY "Admins can fully manage coupons" ON public.coupons USING (public.is_admin());

-- INVITES (Qualquer um pode ver convites para validar, admins podem gerenciar)
CREATE POLICY "Anyone can view invites" ON public.invites FOR SELECT USING (true);
CREATE POLICY "Authenticated users can update invites" ON public.invites FOR UPDATE TO authenticated USING (true);
CREATE POLICY "Admins can fully manage invites" ON public.invites USING (public.is_admin());

-- Garantir que as políticas antigas, se houver, não causem conflitos (opcional, apenas para evitar erros se rodar 2 vezes)
-- O Supabase ignorará o erro se a tabela já tinha RLS ativado.
