import React from 'react';
import { Link, useNavigate } from 'react-router-dom';

export default function LandingPage() {
    const navigate = useNavigate();

    return (
        <div className="min-h-screen bg-background font-ui text-foreground selection:bg-primary-light">
            {/* 1. NAVBAR */}
            <header className="fixed top-0 left-0 right-0 bg-white/90 backdrop-blur-md border-b border-border z-50">
                <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-20 flex items-center justify-between">
                    <div className="flex-shrink-0 flex items-center gap-2">
                        <img src="/logo.png" alt="Logo Bordado+" className="h-10 object-contain" />
                    </div>
                    <div className="flex items-center gap-4">
                        <Link 
                            to="/login" 
                            className="text-primary font-semibold hover:text-primary-dark transition-colors px-4 py-2 border-2 border-primary rounded-xl hidden sm:block"
                        >
                            Entrar
                        </Link>
                        <button 
                            onClick={() => navigate('/cadastro')}
                            className="bg-primary hover:bg-primary-dark text-white font-bold py-2.5 px-6 rounded-xl shadow-md transition-all transform hover:-translate-y-0.5"
                        >
                            Começar grátis
                        </button>
                    </div>
                </div>
            </header>

            <main className="pt-20">
                {/* 2. BARRA DE SOCIAL PROOF */}
                <div className="bg-surface-warm border-b border-border py-3">
                    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                        <div className="flex flex-col sm:flex-row justify-center items-center gap-4 sm:gap-12 text-sm font-semibold text-text-muted">
                            <span className="flex items-center gap-2">🧵 500+ bordadeiras</span>
                            <span className="hidden sm:inline text-border">|</span>
                            <span className="flex items-center gap-2">🎨 10.000+ riscos gerados</span>
                            <span className="hidden sm:inline text-border">|</span>
                            <span className="flex items-center gap-2">💰 R$2M+ em vendas calculadas</span>
                        </div>
                    </div>
                </div>

                {/* 3. HERO SECTION */}
                <section className="py-20 lg:py-32 px-4 sm:px-6 lg:px-8 max-w-7xl mx-auto text-center">
                    <div className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-primary/10 text-primary font-bold text-sm mb-8 border border-primary/20">
                        ✨ Plataforma #1 para bordadeiras
                    </div>
                    <h1 className="font-display text-5xl sm:text-6xl lg:text-7xl font-bold text-text mb-6 tracking-tight leading-tight">
                        Transforme seu bordado <br className="hidden sm:block" />
                        em negócio <span className="text-primary relative inline-block">
                            lucrativo
                            <div className="absolute -bottom-2 left-0 w-full h-3 bg-accent/40 -z-10 rounded-full"></div>
                        </span>
                    </h1>
                    <p className="text-xl text-text-light max-w-3xl mx-auto mb-10 leading-relaxed">
                        Crie riscos com IA, precifique automaticamente e gerencie seu financeiro — tudo em um só lugar, feito para bordadeiras brasileiras.
                    </p>
                    <div className="flex flex-col sm:flex-row justify-center items-center gap-4 mb-6">
                        <button 
                            onClick={() => navigate('/cadastro')}
                            className="w-full sm:w-auto bg-primary hover:bg-primary-dark text-white font-bold text-lg py-4 px-10 rounded-2xl shadow-lg transition-all transform hover:-translate-y-1"
                        >
                            Começar grátis agora
                        </button>
                        <button 
                            onClick={() => navigate('/login')}
                            className="w-full sm:w-auto bg-white hover:bg-surface-warm text-text font-bold text-lg py-4 px-10 rounded-2xl shadow-sm border-2 border-border transition-colors"
                        >
                            Já tenho conta
                        </button>
                    </div>
                    <p className="text-sm text-text-muted font-medium">
                        Sem cartão de crédito · Sem compromisso
                    </p>
                </section>

                {/* 4. FEATURES SECTION */}
                <section className="py-24 bg-surface-warm border-y border-border px-4 sm:px-6 lg:px-8">
                    <div className="max-w-7xl mx-auto">
                        <h2 className="font-display text-4xl sm:text-5xl font-bold text-center text-text mb-16">
                            Tudo que você precisa para crescer
                        </h2>
                        <div className="grid md:grid-cols-3 gap-8">
                            {/* Card 1 */}
                            <div className="bg-white p-8 rounded-3xl shadow-sm border border-border hover:shadow-md transition-shadow">
                                <div className="w-14 h-14 bg-primary/10 rounded-2xl flex items-center justify-center text-3xl mb-6 border border-primary/20">
                                    🤖
                                </div>
                                <h3 className="text-2xl font-bold text-text mb-4">Riscos com IA</h3>
                                <p className="text-text-light leading-relaxed">
                                    Gere riscos únicos e profissionais com inteligência artificial. Descreva o que deseja e obtenha o design perfeito em segundos.
                                </p>
                            </div>
                            {/* Card 2 */}
                            <div className="bg-white p-8 rounded-3xl shadow-sm border border-border hover:shadow-md transition-shadow">
                                <div className="w-14 h-14 bg-accent/20 rounded-2xl flex items-center justify-center text-3xl mb-6 border border-accent/40">
                                    💰
                                </div>
                                <h3 className="text-2xl font-bold text-text mb-4">Precificação automática</h3>
                                <p className="text-text-light leading-relaxed">
                                    Calcule o preço justo de cada peça considerando materiais, tempo e margem. Nunca mais tenha prejuízo nas suas encomendas.
                                </p>
                            </div>
                            {/* Card 3 */}
                            <div className="bg-white p-8 rounded-3xl shadow-sm border border-border hover:shadow-md transition-shadow">
                                <div className="w-14 h-14 bg-[#2D7A4F]/10 rounded-2xl flex items-center justify-center text-3xl mb-6 border border-[#2D7A4F]/20">
                                    📊
                                </div>
                                <h3 className="text-2xl font-bold text-text mb-4">Gestão financeira</h3>
                                <p className="text-text-light leading-relaxed">
                                    Acompanhe receitas, despesas e lucro com relatórios visuais claros. Controle total do seu ateliê na palma da mão.
                                </p>
                            </div>
                        </div>
                    </div>
                </section>

                {/* 5. BENEFITS SECTION */}
                <section className="py-24 px-4 sm:px-6 lg:px-8 max-w-7xl mx-auto">
                    <div className="grid lg:grid-cols-2 gap-16 items-center">
                        <div>
                            <h2 className="font-display text-4xl sm:text-5xl font-bold text-text mb-8 leading-tight">
                                Por que bordadeiras amam o Bordado+?
                            </h2>
                            <ul className="space-y-5 mb-10">
                                {[
                                    'Sem conhecimento técnico necessário',
                                    'Riscos prontos em menos de 1 minuto',
                                    'Precificação justa e lucrativa',
                                    'Acompanhe seu crescimento financeiro',
                                    'Acesso em qualquer dispositivo',
                                    'Suporte em português'
                                ].map((benefit, idx) => (
                                    <li key={idx} className="flex items-center gap-4 text-lg text-text-light font-medium">
                                        <div className="w-6 h-6 rounded-full bg-[#2D7A4F] text-white flex items-center justify-center flex-shrink-0 text-sm">
                                            ✓
                                        </div>
                                        {benefit}
                                    </li>
                                ))}
                            </ul>
                            <button 
                                onClick={() => navigate('/cadastro')}
                                className="bg-primary hover:bg-primary-dark text-white font-bold text-lg py-4 px-8 rounded-2xl shadow-lg transition-all"
                            >
                                Criar conta gratuita
                            </button>
                        </div>
                        
                        {/* Mockup visual */}
                        <div className="bg-surface-warm p-6 rounded-3xl border-2 border-border shadow-inner">
                            <div className="bg-white rounded-2xl shadow-xl overflow-hidden border border-border">
                                <div className="bg-background border-b border-border p-4 flex justify-between items-center">
                                    <div className="font-bold text-text">Meu Dashboard</div>
                                    <div className="text-sm bg-success/10 text-success px-3 py-1 rounded-full font-bold">Logada</div>
                                </div>
                                <div className="p-6 space-y-6">
                                    <div className="bg-primary/5 border border-primary/20 p-5 rounded-xl">
                                        <div className="text-sm text-text-muted mb-1">Lucro do Mês</div>
                                        <div className="text-3xl font-display font-bold text-primary">R$ 3.450,00</div>
                                    </div>
                                    <div>
                                        <div className="text-sm font-bold text-text mb-3">Últimas Encomendas</div>
                                        <div className="space-y-3">
                                            {['Porta Maternidade - Alice', 'Jaqueta Jeans Customizada', 'Bastidor Casamento'].map((item, i) => (
                                                <div key={i} className="flex justify-between items-center p-3 bg-surface-warm rounded-lg border border-border">
                                                    <span className="font-medium text-text">{item}</span>
                                                    <span className="text-xs font-bold text-accent px-2 py-1 bg-accent/10 rounded">Em andamento</span>
                                                </div>
                                            ))}
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                {/* 6. DEPOIMENTOS */}
                <section className="py-24 bg-surface-warm border-y border-border px-4 sm:px-6 lg:px-8">
                    <div className="max-w-7xl mx-auto">
                        <h2 className="font-display text-4xl sm:text-5xl font-bold text-center text-text mb-16">
                            O que dizem nossas bordadeiras
                        </h2>
                        <div className="grid md:grid-cols-3 gap-8">
                            {[
                                {
                                    text: "Antes eu perdia horas calculando preços. Agora em segundos sei exatamente quanto cobrar. Recomendo de olhos fechados!",
                                    name: "Ana Lima",
                                    role: "Bordadeira Empreendedora"
                                },
                                {
                                    text: "A geração de riscos com IA mudou meu negócio. Consigo criar coleções únicas que minhas clientes não acham em nenhum outro lugar.",
                                    name: "Maria Santos",
                                    role: "Especialista em Bastidores"
                                },
                                {
                                    text: "Meus alunos adoram os relatórios financeiros. Organização total em um só lugar. A melhor ferramenta do mercado.",
                                    name: "Claudia Oliveira",
                                    role: "Professora de Bordado"
                                }
                            ].map((dep, idx) => (
                                <div key={idx} className="bg-white p-8 rounded-3xl shadow-sm border border-border relative">
                                    <div className="text-5xl text-secondary absolute top-4 left-6 font-display opacity-50">"</div>
                                    <p className="text-text-light text-lg mb-8 relative z-10 leading-relaxed pt-4">
                                        {dep.text}
                                    </p>
                                    <div className="flex items-center gap-4 border-t border-border pt-6">
                                        <div className="w-12 h-12 bg-primary/20 text-primary rounded-full flex items-center justify-center font-bold text-xl">
                                            {dep.name.charAt(0)}
                                        </div>
                                        <div>
                                            <div className="font-bold text-text">{dep.name}</div>
                                            <div className="text-sm text-text-muted">{dep.role}</div>
                                        </div>
                                    </div>
                                </div>
                            ))}
                        </div>
                    </div>
                </section>

                {/* 7. CTA FINAL */}
                <section className="py-24 px-4 sm:px-6 lg:px-8">
                    <div className="max-w-5xl mx-auto bg-primary rounded-3xl p-10 sm:p-16 text-center shadow-xl relative overflow-hidden">
                        <div className="absolute top-0 right-0 w-64 h-64 bg-white opacity-5 rounded-full blur-3xl transform translate-x-1/2 -translate-y-1/2"></div>
                        <div className="absolute bottom-0 left-0 w-64 h-64 bg-accent opacity-20 rounded-full blur-3xl transform -translate-x-1/2 translate-y-1/2"></div>
                        
                        <div className="relative z-10">
                            <h2 className="font-display text-4xl sm:text-5xl font-bold text-white mb-6">
                                Pronta para transformar sua paixão em negócio?
                            </h2>
                            <p className="text-primary-foreground/90 text-xl mb-10 max-w-2xl mx-auto">
                                Junte-se a centenas de bordadeiras que já cresceram com o Bordado+.
                            </p>
                            <button 
                                onClick={() => navigate('/cadastro')}
                                className="bg-white hover:bg-surface-warm text-primary font-bold text-xl py-5 px-12 rounded-2xl shadow-lg transition-transform transform hover:scale-105"
                            >
                                Começar grátis agora
                            </button>
                        </div>
                    </div>
                </section>
            </main>

            {/* 8. FOOTER */}
            <footer className="bg-white border-t border-border py-12 px-4 sm:px-6 lg:px-8">
                <div className="max-w-7xl mx-auto flex flex-col sm:flex-row justify-between items-center gap-6">
                    <div className="flex items-center gap-2">
                        <img src="/logo.png" alt="Logo Bordado+" className="h-8 object-contain" />
                    </div>
                    <p className="text-text-muted text-sm font-medium">
                        © 2026 Bordado+. Todos os direitos reservados.
                    </p>
                </div>
            </footer>
        </div>
    );
}
