use strict;
use warnings;
use DBI;

# 1. Conectar ao banco de dados SQLite (ele cria o arquivo 'venenos.db' automaticamente)
my $database = "venenos.db";
my $dbh = DBI->connect("dbi:SQLite:dbname=$database", "", "", {
    RaiseError     => 1, # Faz o Perl parar o programa se houver erro no SQL
    PrintError     => 0,
    AutoCommit     => 1,
}) or die "Não foi possível conectar: " . DBI->errstr;

print "Base de dados '$database' criada/conectada com sucesso!\n";

# 2. Comando SQL para criar a tabela de toxinas
my $sql_criar_tabela = <<'SQL';
CREATE TABLE IF NOT EXISTS toxinas (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_proteina TEXT NOT NULL,
    especie TEXT NOT NULL,
    tipo_toxina TEXT,
    sequencia TEXT
);
SQL

# 3. Executar o comando no banco de dados
$dbh->do($sql_criar_tabela);
print "Tabela 'toxinas' criada com sucesso!\n";

# 4. Desconectar 
$dbh->disconnect();