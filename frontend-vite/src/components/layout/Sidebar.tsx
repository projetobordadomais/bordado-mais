'use client';

import React, { useState, useEffect } from 'react';
import { Link, useLocation, useNavigate } from 'react-router-dom';
import { Home, Image as ImageIcon, Paintbrush, DollarSign, PieChart, Sparkles, User, LogOut, Lock, ShoppingBag, Shield, Gift, Calendar, Users, Package, Timer, FileText, Truck, Percent } from 'lucide-react';
import { cn } from '@/lib/utils';
import { UpgradeModal } from '../shared/UpgradeModal';
import { createClient } from '@/lib/supabase/client';
import { NotificationBell } from '../shared/NotificationBell';

import { usePlatform } from '@/contexts/PlatformContext';
import { useAuth } from '@/lib/hooks/useAuth';

const menuItems = [
    { href: '/dashboard', label: 'Dashboard', icon: Home, isPremium: false },
    { href: '/gerar/risco', label: 'Gerador de Riscos', icon: ImageIcon, isPremium: false },
    { href: '/gerar/bordado-colorido', label: 'Gerar Bordado', icon: Paintbrush, isPremium: false },

];

const premiumItems = [
    { href: '/precificacao', label: 'Precificação', icon: DollarSign, isPremium: true },
    { href: '/financeiro', label: 'Financeiro', icon: PieChart, isPremium: true },
    { href: '/estrategia', label: 'Estratégia IA', icon: Sparkles, isPremium: true },
    { href: '/dashboard/agenda', label: 'Agenda', icon: Calendar, isPremium: true },
    { href: '/dashboard/clientes', label: 'Clientes', icon: Users, isPremium: true },
    { href: '/dashboard/orcamentos', label: 'Orçamentos', icon: FileText, isPremium: true },
    { href: '/dashboard/envios', label: 'Envios', icon: Truck, isPremium: true },
    { href: '/dashboard/estoque', label: 'Estoque', icon: Package, isPremium: true },
    { href: '/dashboard/cronometro', label: 'Cronômetro', icon: Timer, isPremium: true },
];

export function Sidebar() {
    const location = useLocation();
    const pathname = location.pathname;
    const navigate = useNavigate();
    const supabase = createClient();
    const { platformName, platformLogo } = usePlatform();
    const { profile: authProfile } = useAuth();

    const isPremium = true;
    const role = authProfile?.role || 'user';
    const profileName = authProfile?.full_name ? authProfile.full_name.split(' ')[0] : 'Usuário';

    const [showUpgradeModal, setShowUpgradeModal] = useState(false);

    const handleSignOut = async () => {
        await supabase.auth.signOut();
        navigate('/login');
    };

    return (
        <>
            <aside className="hidden lg:flex flex-col w-[260px] h-screen fixed top-0 left-0 bg-surface-warm border-r border-black/10 z-20 shadow-md">

                {/* CABEÇALHO COM LOGO */}
                <Link to="/dashboard" className="pt-6 pb-6 px-6 flex flex-col items-center justify-center border-b border-black/10 shrink-0 group hover:bg-primary/10/40 transition-colors">
                    <img
                        src={platformLogo || '/logo.png'}
                        alt={`Logo ${platformName}`}
                        onError={(e) => { e.currentTarget.src = '/logo.png'; }}
                        style={{ height: '110px', width: 'auto', objectFit: 'contain', marginBottom: '0px' }}
                        className="transition-opacity group-hover:opacity-90"
                    />
                </Link>

                {/* MENU NAVIGÁVEL */}
                <nav className="flex-1 overflow-y-auto overflow-x-hidden pt-4 pb-2 px-4 [&::-webkit-scrollbar]:w-1.5 [&::-webkit-scrollbar-track]:bg-transparent [&::-webkit-scrollbar-thumb]:bg-black/10 [&::-webkit-scrollbar-thumb]:rounded-full hover:[&::-webkit-scrollbar-thumb]:bg-black/20 transition-colors">

                    {/* MENU BÁSICO */}
                    <div className="mb-5">
                        <span className="text-[10px] font-bold text-text/60 tracking-wider uppercase ml-2 mb-2 block">Menu</span>
                        <div className="space-y-0.5">
                            {menuItems.map((item) => {
                                const isActive = item.href === '/dashboard' ? pathname === '/dashboard' : (pathname === item.href || pathname.startsWith(item.href + '/'));
                                return (
                                    <Link key={item.href} to={item.href} className={cn(
                                        'w-full flex items-center gap-3 px-3 py-2.5 rounded-xl transition-all duration-200 font-ui text-sm group text-left relative',
                                        isActive
                                            ? 'bg-primary text-white font-medium shadow-sm'
                                            : 'text-text hover:bg-primary/10 hover:text-text'
                                    )}>
                                        <item.icon className={cn("w-4 h-4 shrink-0", isActive ? 'text-white' : 'text-text/70 group-hover:text-text')} />
                                        <span className="flex-1">{item.label}</span>
                                    </Link>
                                );
                            })}
                        </div>
                    </div>

                    {/* MENU FERRAMENTAS */}
                    <div className="mb-5">
                        <span className="text-[10px] font-bold text-text/60 tracking-wider uppercase ml-2 mb-2 block">Ferramentas</span>
                        <div className="space-y-0.5">
                            {premiumItems.map((item) => {
                                const isActive = pathname === item.href || pathname.startsWith(item.href + '/');
                                const isLocked = !isPremium;
                                const Element = isLocked ? 'button' : Link;
                                const linkProps = isLocked ? { onClick: () => setShowUpgradeModal(true) } : { to: item.href };

                                return (
                                    <Element key={item.href} {...(linkProps as any)} className={cn(
                                        'w-full flex items-center gap-3 px-3 py-2.5 rounded-xl transition-all duration-200 font-ui text-sm group text-left relative',
                                        isActive
                                            ? 'bg-primary text-white font-medium shadow-sm'
                                            : 'text-text hover:bg-primary/10 hover:text-text',
                                        isLocked && 'opacity-60'
                                    )}>
                                        <item.icon className={cn("w-4 h-4 shrink-0", isActive ? 'text-white' : 'text-text/70 group-hover:text-text')} />
                                        <span className="flex-1">{item.label}</span>
                                        {isLocked && <Lock className="w-3 h-3 text-primary" aria-label="Recurso Premium" />}
                                    </Element>
                                );
                            })}
                        </div>
                    </div>
                </nav>

                {/* ÁREA DE CONTA FIXA NO RODAPÉ */}
                <div className="shrink-0 pt-2 pb-4 px-4 border-t border-black/10 bg-surface-warm shadow-[0_-6px_16px_rgba(0,0,0,0.06)] z-10">
                    <span className="text-[10px] font-bold text-text/60 tracking-wider uppercase ml-2 mb-2 block">Conta</span>
                    <div className="space-y-0.5 mb-3">
                        <div className="flex items-center gap-2 w-full">
                            <Link to="/perfil" className={cn(
                                'flex-1 flex items-center gap-3 px-3 py-2.5 rounded-xl transition-all duration-200 font-ui text-sm group text-left relative',
                                pathname.startsWith('/perfil')
                                    ? 'bg-primary text-white font-medium shadow-sm'
                                    : 'text-text hover:bg-primary/10 hover:text-text'
                            )}>
                                <User className={cn("w-4 h-4 shrink-0", pathname.startsWith('/perfil') ? 'text-white' : 'text-text/70 group-hover:text-text')} />
                                <span className="flex-1">Meu Perfil</span>
                            </Link>
                            <div className="flex shrink-0 h-full items-center justify-center pr-2">
                                <NotificationBell />
                            </div>
                        </div>

                        {role === 'admin' && (
                            <Link to="/admin" className={cn(
                                'w-full flex items-center gap-3 px-3 py-2.5 rounded-xl transition-all duration-200 font-ui text-sm group text-left relative',
                                pathname.startsWith('/admin')
                                    ? 'bg-primary text-white font-medium shadow-sm'
                                    : 'text-text hover:bg-primary/10 hover:text-text'
                            )}>
                                <Shield className={cn("w-4 h-4 shrink-0", pathname.startsWith('/admin') ? 'text-white' : 'text-text/70 group-hover:text-text')} />
                                <span className="flex-1">Painel Admin</span>
                            </Link>
                        )}


                    </div>

                    {/* CARD DO USUÁRIO */}
                    <div style={{ backgroundColor: '#2C160A', borderColor: '#4E312F' }} className="p-3 rounded-xl border flex items-center gap-3 shadow-sm relative group">
                        <div className="w-9 h-9 rounded-full bg-primary flex items-center justify-center text-white font-display flex-shrink-0 uppercase font-bold text-sm shadow-sm">
                            {profileName.charAt(0)}
                        </div>
                        <div className="overflow-hidden flex-1">
                            <p style={{ color: '#F2E4D0' }} className="text-sm font-semibold truncate">{profileName}</p>
                            {role === 'admin' ? (
                                <span style={{ color: '#A07850' }} className="text-[9px] font-bold tracking-wider uppercase flex items-center gap-1">
                                    <Shield className="w-3 h-3" /> Administrador
                                </span>
                            ) : (
                                <span style={{ color: '#A07850' }} className="text-[9px] font-bold tracking-wider uppercase">Bordado+</span>
                            )}
                        </div>
                        <button onClick={handleSignOut} className="absolute right-3 p-1.5 rounded-md text-text/40 hover:bg-primary/10 hover:text-primary transition-colors" title="Sair do Ateliê">
                            <LogOut className="w-4 h-4" />
                        </button>
                    </div>
                </div>
            </aside>

            <UpgradeModal open={showUpgradeModal} onOpenChange={setShowUpgradeModal} />
        </>
    );
}

