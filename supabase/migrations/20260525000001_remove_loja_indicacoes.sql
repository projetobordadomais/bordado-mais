-- Migration: Remove Loja (Credit Packages) and Indicacoes (Referrals/Partners)

-- 1. Drop foreign keys and tables
DROP TABLE IF EXISTS public.partner_commissions CASCADE;
DROP TABLE IF EXISTS public.referrals CASCADE;
DROP TABLE IF EXISTS public.credit_packages CASCADE;

-- 2. Remove columns from profiles
ALTER TABLE public.profiles
    DROP COLUMN IF EXISTS referral_code,
    DROP COLUMN IF EXISTS is_partner,
    DROP COLUMN IF EXISTS partner_commission_percent,
    DROP COLUMN IF EXISTS extra_credits;

-- 3. Remove columns from coupons
ALTER TABLE public.coupons
    DROP COLUMN IF EXISTS partner_id,
    DROP COLUMN IF EXISTS is_partner_coupon;
