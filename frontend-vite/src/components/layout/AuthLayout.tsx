import React from 'react';
import { Outlet } from 'react-router-dom';

export default function AuthLayout() {
    return (
        <div className="flex min-h-screen bg-background text-foreground selection:bg-primary-light justify-center items-center p-4 sm:p-8">
            {/* Centralizado: Formulários (Login, Cadastro) */}
            <div className="w-full max-w-[420px] bg-surface sm:bg-transparent rounded-2xl shadow-xl sm:shadow-none p-6 sm:p-0">
                <Outlet />
            </div>
        </div>
    );
}
