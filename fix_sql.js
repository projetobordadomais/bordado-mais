const fs = require('fs');
const sql = fs.readFileSync('TODAS_MIGRATIONS.sql', 'utf8');

let lines = sql.split(/\r?\n/);
let alterBlocks = [];
let otherBlocks = [];

for (let i = 0; i < lines.length; i++) {
    let line = lines[i];
    if (line.toUpperCase().trim().startsWith('ALTER TABLE ')) {
        alterBlocks.push(line);
    } else if (line.toUpperCase().trim().startsWith('CREATE TABLE ') && !line.toUpperCase().includes('IF NOT EXISTS')) {
        otherBlocks.push(line.replace(/CREATE TABLE /ig, 'CREATE TABLE IF NOT EXISTS '));
    } else {
        otherBlocks.push(line);
    }
}

let newSql = otherBlocks.join('\n') + '\n\n-- ==========================================\n-- ALTER TABLES REAPLICADAS NO FINAL\n-- ==========================================\n' + alterBlocks.join('\n');
fs.writeFileSync('RESTAURAR_BANCO.sql', newSql);
console.log('RESTAURAR_BANCO.sql created successfully!');
