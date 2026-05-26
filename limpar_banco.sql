-- Script para limpar todas as tabelas do projeto de forma segura
-- Use o comando CASCADE para remover as dependências entre as tabelas

DROP TABLE IF EXISTS public.inventory_movements CASCADE;
DROP TABLE IF EXISTS public.order_materials CASCADE;
DROP TABLE IF EXISTS public.time_sessions CASCADE;
DROP TABLE IF EXISTS public.aprovacao_arte CASCADE;
DROP TABLE IF EXISTS public.orcamento_itens CASCADE;
DROP TABLE IF EXISTS public.orcamentos CASCADE;
DROP TABLE IF EXISTS public.orders CASCADE;
DROP TABLE IF EXISTS public.inventory_items CASCADE;
DROP TABLE IF EXISTS public.clients CASCADE;
DROP TABLE IF EXISTS public.waitlist CASCADE;
DROP TABLE IF EXISTS public.email_campaigns CASCADE;
DROP TABLE IF EXISTS public.coupons CASCADE;
DROP TABLE IF EXISTS public.invites CASCADE;
DROP TABLE IF EXISTS public.auth_tokens CASCADE;
DROP TABLE IF EXISTS public.plan_config CASCADE;
DROP TABLE IF EXISTS public.notifications CASCADE;
DROP TABLE IF EXISTS public.profiles CASCADE;

-- Exclui funções e triggers criados (opcional, mas recomendado para limpeza total)
DROP FUNCTION IF EXISTS public.handle_new_user() CASCADE;
DROP FUNCTION IF EXISTS public.get_next_orcamento_numero(uuid) CASCADE;
