import React, { Suspense } from 'react';
import AppRouter from './router';
import { Toaster } from '@/components/ui/toaster';
import { AuthProvider } from '@/lib/hooks/useAuth';
import { ModalProvider } from '@/contexts/ModalContext';
import { PlatformProvider } from '@/contexts/PlatformContext';
import { useLicenseCheck } from "./hooks/useLicenseCheck";

export default function App() {
  const { status } = useLicenseCheck();
  if (status === "checking") return null;
  if (status === "blocked") return null;

  return (
    <PlatformProvider>
      <AuthProvider>
        <ModalProvider>
          <Suspense fallback={<div className="min-h-screen flex items-center justify-center font-ui text-text-light text-sm animate-pulse">Carregando Plataforma...</div>}>
            <AppRouter />
            <Toaster />
          </Suspense>
        </ModalProvider>
      </AuthProvider>
    </PlatformProvider>
  );
}
