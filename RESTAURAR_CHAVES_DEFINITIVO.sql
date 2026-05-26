ALTER TABLE public.payments DROP CONSTRAINT IF EXISTS payments_user_id_fkey;
ALTER TABLE public.payments ADD CONSTRAINT payments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;

ALTER TABLE public.generations DROP CONSTRAINT IF EXISTS generations_user_id_fkey;
ALTER TABLE public.generations ADD CONSTRAINT generations_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;

ALTER TABLE public.financial_records DROP CONSTRAINT IF EXISTS financial_records_user_id_fkey;
ALTER TABLE public.financial_records ADD CONSTRAINT financial_records_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;

ALTER TABLE public.pricing_calculations DROP CONSTRAINT IF EXISTS pricing_calculations_user_id_fkey;
ALTER TABLE public.pricing_calculations ADD CONSTRAINT pricing_calculations_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;

ALTER TABLE public.strategy_conversations DROP CONSTRAINT IF EXISTS strategy_conversations_user_id_fkey;
ALTER TABLE public.strategy_conversations ADD CONSTRAINT strategy_conversations_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;

ALTER TABLE public.partner_commissions DROP CONSTRAINT IF EXISTS partner_commissions_partner_id_fkey;
ALTER TABLE public.partner_commissions ADD CONSTRAINT partner_commissions_partner_id_fkey FOREIGN KEY (partner_id) REFERENCES public.profiles(id) ON DELETE CASCADE;

ALTER TABLE public.partner_commissions DROP CONSTRAINT IF EXISTS partner_commissions_referred_id_fkey;
ALTER TABLE public.partner_commissions ADD CONSTRAINT partner_commissions_referred_id_fkey FOREIGN KEY (referred_id) REFERENCES public.profiles(id) ON DELETE SET NULL;

ALTER TABLE public.referrals DROP CONSTRAINT IF EXISTS referrals_referrer_id_fkey;
ALTER TABLE public.referrals ADD CONSTRAINT referrals_referrer_id_fkey FOREIGN KEY (referrer_id) REFERENCES public.profiles(id) ON DELETE CASCADE;

ALTER TABLE public.referrals DROP CONSTRAINT IF EXISTS referrals_referred_id_fkey;
ALTER TABLE public.referrals ADD CONSTRAINT referrals_referred_id_fkey FOREIGN KEY (referred_id) REFERENCES public.profiles(id) ON DELETE CASCADE;

ALTER TABLE public.user_coupons DROP CONSTRAINT IF EXISTS user_coupons_user_id_fkey;
ALTER TABLE public.user_coupons ADD CONSTRAINT user_coupons_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;

ALTER TABLE public.financial_transactions DROP CONSTRAINT IF EXISTS financial_transactions_user_id_fkey;
ALTER TABLE public.financial_transactions ADD CONSTRAINT financial_transactions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;

ALTER TABLE public.plan_config DROP CONSTRAINT IF EXISTS plan_config_updated_by_fkey;
ALTER TABLE public.plan_config ADD CONSTRAINT plan_config_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.profiles(id) ON DELETE SET NULL;

ALTER TABLE public.coupons DROP CONSTRAINT IF EXISTS coupons_partner_id_fkey;
ALTER TABLE public.coupons ADD CONSTRAINT coupons_partner_id_fkey FOREIGN KEY (partner_id) REFERENCES public.profiles(id) ON DELETE SET NULL;
