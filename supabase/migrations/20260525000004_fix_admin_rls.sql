-- ==========================================
-- CORREÇÃO DE POLÍTICAS RLS PARA ADMINS
-- ==========================================
-- O erro do "silêncio" (onde não dá erro, mas também não atualiza no banco) 
-- acontecia porque os administradores tinham permissão apenas de VER (SELECT) 
-- os dados dos outros usuários, mas não podiam ATUALIZAR (UPDATE) ou DELETAR.
-- Este script concede poder total aos administradores.

-- 1. CLIENTS
DROP POLICY IF EXISTS "Admins can view all clients" ON public.clients;
CREATE POLICY "Admins can manage all clients" ON public.clients FOR ALL USING (public.is_admin());

-- 2. INVENTORY_ITEMS
DROP POLICY IF EXISTS "Admins can view all inventory items" ON public.inventory_items;
CREATE POLICY "Admins can manage all inventory items" ON public.inventory_items FOR ALL USING (public.is_admin());

-- 3. ORDERS
DROP POLICY IF EXISTS "Admins can view all orders" ON public.orders;
CREATE POLICY "Admins can manage all orders" ON public.orders FOR ALL USING (public.is_admin());

-- 4. INVENTORY_MOVEMENTS
DROP POLICY IF EXISTS "Admins can view all inventory movements" ON public.inventory_movements;
CREATE POLICY "Admins can manage all inventory movements" ON public.inventory_movements FOR ALL USING (public.is_admin());

-- 5. TIME_SESSIONS
DROP POLICY IF EXISTS "Admins can view all time sessions" ON public.time_sessions;
CREATE POLICY "Admins can manage all time sessions" ON public.time_sessions FOR ALL USING (public.is_admin());

-- 6. ORCAMENTOS
DROP POLICY IF EXISTS "Admins can view all orcamentos" ON public.orcamentos;
CREATE POLICY "Admins can manage all orcamentos" ON public.orcamentos FOR ALL USING (public.is_admin());

-- 7. APROVACAO_ARTE
DROP POLICY IF EXISTS "Admins can view all aprovacao arte" ON public.aprovacao_arte;
CREATE POLICY "Admins can manage all aprovacao arte" ON public.aprovacao_arte FOR ALL USING (public.is_admin());
