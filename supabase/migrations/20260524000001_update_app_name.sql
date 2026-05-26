-- Atualiza o nome do aplicativo na tabela plan_config para o novo white-label Bordado+
UPDATE plan_config 
SET app_name = 'Bordado+' 
WHERE id IS NOT NULL;
