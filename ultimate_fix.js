const fs = require('fs');
let sql = fs.readFileSync('TODAS_MIGRATIONS.sql', 'utf8');

// 1. Move first 2 lines to end
let lines = sql.split(/\r?\n/);
let extractedAlters = [];
if (lines[0] && lines[0].includes('ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS aceitou_termos')) {
    extractedAlters.push(lines.shift());
}
if (lines[0] && lines[0].includes('ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS termos_aceitos_em')) {
    extractedAlters.push(lines.shift());
}
sql = lines.join('\n');

// 2. CREATE TABLE -> CREATE TABLE IF NOT EXISTS
sql = sql.replace(/CREATE TABLE\s+(?!IF NOT EXISTS)(public\.\w+|\w+)/ig, 'CREATE TABLE IF NOT EXISTS $1');

// 3. CREATE INDEX -> CREATE INDEX IF NOT EXISTS
sql = sql.replace(/CREATE INDEX (?!IF NOT EXISTS)/gim, 'CREATE INDEX IF NOT EXISTS ');

// 4. CREATE POLICY -> DROP POLICY IF EXISTS ... ; CREATE POLICY
sql = sql.replace(/CREATE POLICY \"([^\"]+)\" ON ([\w\.]+)/gim, 'DROP POLICY IF EXISTS \"$1\" ON $2;\nCREATE POLICY \"$1\" ON $2');

// 5. CREATE TRIGGER
sql = sql.replace(/CREATE TRIGGER (\w+)\s+(BEFORE|AFTER)\s+(UPDATE|INSERT|DELETE)\s+ON\s+([\w\.]+)/gim, function(match, triggerName, timing, action, tableName) {
    return 'DROP TRIGGER IF EXISTS ' + triggerName + ' ON ' + tableName + ';\n' + match;
});

// 6. Comments out CREATE TYPE and CREATE EXTENSION
sql = sql.replace(/^(CREATE TYPE .*);/gim, '-- $1;');
sql = sql.replace(/^(CREATE EXTENSION .*);/gim, '-- $1;');

// Re-append the alters
sql = sql + '\n\n-- ALTERACOES REAPLICADAS\n' + extractedAlters.join('\n');

fs.writeFileSync('SALVACAO_DO_BANCO.sql', sql);
console.log('SALVACAO_DO_BANCO.sql criado com sucesso!');
