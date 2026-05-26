
-- Recriar a função do trigger para garantir que não há erros
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $body
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
$body LANGUAGE plpgsql SECURITY DEFINER;

-- Remover o trigger antigo para evitar duplicatas ou referências quebradas
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

-- Criar o trigger novamente
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
