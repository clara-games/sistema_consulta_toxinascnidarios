use strict;
use warnings;
use DBI;

# 1. Conectar ao banco de dados
my $database = "venenos.db";
my $dbh = DBI->connect("dbi:SQLite:dbname=$database", "", "", { RaiseError => 1 })
    or die "Erro ao conectar ao banco: " . DBI->errstr;

# 2. Abrir o arquivo de dados do UniProt
my $arquivo_tsv = "dados_uniprot.tsv";
open(my $fh, '<:encoding(UTF-8)', $arquivo_tsv) 
    or die "Não foi possível abrir o arquivo '$arquivo_tsv': $!";


my $cabecalho = <$fh>;
chomp $cabecalho;
my @nomes_campos = split("\t", $cabecalho);

# Mapa nome_do_campo -> posição (ex.: $pos{"Organism"} = 5)
my %pos;
for my $i (0 .. $#nomes_campos) {
    $pos{ $nomes_campos[$i] } = $i;
}

# Avisa se o ficheiro não tiver a coluna de Sequência (precisa ser adicionada no UniProt em "Customize columns" -> "Sequences" -> "Sequence")
unless (exists $pos{"Sequence"}) {
    warn "AVISO: a coluna 'Sequence' não foi encontrada no TSV. O campo 'sequencia' vai ficar vazio.\n";
    warn "       No UniProt, clique em 'Customize columns' -> categoria 'Sequences' -> marque 'Sequence' antes de baixar.\n";
}

# 3. Preparar o comando SQL de inserção (Uso de Placeholders '?' para segurança)
my $sth = $dbh->prepare("INSERT INTO toxinas (nome_proteina, especie, tipo_toxina, sequencia) VALUES (?, ?, ?, ?)");

print "A ler os dados biológicos e a alimentar a base de dados...\n";
my $linhas_inseridas = 0;

# 4. Ler o arquivo linha por linha
while (my $linha = <$fh>) {
    chomp $linha; # Remove a quebra de linha no fim
    next if $linha eq ''; # ignora linhas vazias no fim do ficheiro

    # O arquivo TSV separa as colunas por TABs (\t). Vamos dividir a linha nessas colunas:
    my @colunas = split("\t", $linha);

    # Função auxiliar: pega a coluna pelo NOME do cabeçalho, não pela posição fixa.
    # Assim, se reordenares ou adicionares colunas no UniProt, o script continua a funcionar.
    my $pega = sub {
        my ($nome_campo, $padrao) = @_;
        return $padrao unless exists $pos{$nome_campo};
        my $valor = $colunas[ $pos{$nome_campo} ];
        return (defined $valor && $valor ne '') ? $valor : $padrao;
    };

    my $id_uniprot    = $pega->("Entry", "Desconhecido");
    my $nome_proteina = $pega->("Protein names", "Toxina Sem Nome");
    my $especie       = $pega->("Organism", "Cnidaria sp.");
    my $sequencia     = $pega->("Sequence", ""); # precisa da coluna "Sequence" ativada no UniProt
    my $tipo_toxina   = "Toxina de Cnidário"; # Uma classificação genérica para começar

    # Limpar o nome da espécie 
    $especie =~ s/\s*\(.*\)//g; 

    # Executar a inserção no banco de dados SQLite
    $sth->execute($nome_proteina, $especie, $tipo_toxina, $sequencia);
    $linhas_inseridas++;
}

# Fechar o arquivo e desconectar do banco
close($fh);
$dbh->disconnect();

print "Sucesso! Foram inseridas $linhas_inseridas toxinas de cnidários na tua base de dados!\n";