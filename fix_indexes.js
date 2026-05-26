const fs = require('fs');
let sql = fs.readFileSync('RESTAURAR_BANCO_FINAL.sql', 'utf8');

// Fix CREATE INDEX
sql = sql.replace(/CREATE INDEX (?!IF NOT EXISTS)/gim, 'CREATE INDEX IF NOT EXISTS ');

// Fix CREATE POLICY
sql = sql.replace(/CREATE POLICY \"([^\"]+)\" ON ([\w\.]+)/gim, 'DROP POLICY IF EXISTS \"$1\" ON $2;\nCREATE POLICY \"$1\" ON $2');

// Fix CREATE TRIGGER
// Typically: CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON public.profiles FOR EACH ROW ...
sql = sql.replace(/CREATE TRIGGER (\w+)\s+(?:BEFORE|AFTER)\s+(?:UPDATE|INSERT|DELETE)\s+ON\s+([\w\.]+)/gim, function(match, triggerName, tableName) {
    return 'DROP TRIGGER IF EXISTS ' + triggerName + ' ON ' + tableName + ';\n' + match;
});

// Drop specific function that might conflict if not using OR REPLACE
sql = sql.replace(/CREATE FUNCTION/gim, 'CREATE OR REPLACE FUNCTION');

fs.writeFileSync('RESTAURAR_BANCO_ABSOLUTO.sql', sql);
console.log('RESTAURAR_BANCO_ABSOLUTO.sql created!');
