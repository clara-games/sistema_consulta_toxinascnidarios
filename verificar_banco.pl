use strict;
use warnings;
use DBI;

my $database = "venenos.db";
my $dbh = DBI->connect("dbi:SQLite:dbname=$database", "", "", { RaiseError => 1 })
    or die "Erro ao conectar: " . DBI->errstr;

my ($total) = $dbh->selectrow_array("SELECT COUNT(*) FROM toxinas");
print "Total de registos na tabela 'toxinas': $total\n";

my $sth = $dbh->prepare("SELECT nome_proteina, especie FROM toxinas WHERE especie LIKE ?");
$sth->execute("%Hydra%");

my $encontrados = 0;
while (my $linha = $sth->fetchrow_hashref) {
    print " - $linha->{nome_proteina} | $linha->{especie}\n";
    $encontrados++;
}

print "\nTotal encontrado para 'Hydra': $encontrados\n";
$dbh->disconnect();
