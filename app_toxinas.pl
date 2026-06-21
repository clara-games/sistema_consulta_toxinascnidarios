use strict;
use warnings;
use DBI;
use Mojolicious::Lite; # Transforma o Perl num servidor web instantâneo

# Conexão com o banco de dados
my $database = "venenos.db";
my $dbh = DBI->connect("dbi:SQLite:dbname=$database", "", "", { RaiseError => 1 })
    or die "Erro ao conectar: " . DBI->errstr;

# Rota principal
get '/' => sub {
    my $c = shift;
    
    
    my $busca = $c->param('q') // '';
    my @resultados;
    
    if ($busca ne '') {
        my $sql = "SELECT nome_proteina, especie, sequencia FROM toxinas WHERE especie LIKE ?";
        my $sth = $dbh->prepare($sql);
        $sth->execute("%" . $busca . "%");
        
        while (my $linha = $sth->fetchrow_hashref) {
            push @resultados, $linha;
        }
    }
    
    # Envia os dados para a página HTML abaixo
    $c->render(template => 'index', resultados => \@resultados, busca => $busca);
};

# Iniciar o servidor
app->start;

# O HTML e CSS
__DATA__

@@ index.html.ep
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sistema de Consulta de Toxinas</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg: #ECEFE8;
            --purple: #5B3A9E;
            --purple-dark: #432D72;
            --ink: #1A1A1A;
        }

        * { box-sizing: border-box; }

        html, body {
            margin: 0;
            min-height: 100%;
            background-color: var(--bg);
            color: var(--ink);
            overflow-x: hidden;
        }

        body { font-family: 'Inter', Arial, sans-serif; }

        /* Decoração de canto em gradiente (azul -> roxo -> lilás) */
        .corner {
            position: fixed;
            width: 380px;
            height: 380px;
            pointer-events: none;
            z-index: 0;
        }
        .corner-tr {
            top: 0;
            right: 0;
            clip-path: polygon(100% 0%, 0% 0%, 100% 100%);
            background: linear-gradient(225deg, #2752C5 0%, #6A4AD1 35%, #C49EE8 60%, rgba(196,158,232,0) 85%);
        }
        .corner-bl {
            bottom: 0;
            left: 0;
            clip-path: polygon(0% 100%, 100% 100%, 0% 0%);
            background: linear-gradient(45deg, #2752C5 0%, #6A4AD1 35%, #C49EE8 60%, rgba(196,158,232,0) 85%);
        }

        .container {
            position: relative;
            z-index: 1;
            max-width: 900px;
            margin: 0 auto;
            padding: 60px 40px;
        }

        h1 {
            font-family: 'Inter', sans-serif;
            font-weight: 800;
            letter-spacing: -0.01em;
            font-size: clamp(1.8rem, 4vw, 2.7rem);
            color: var(--purple);
            margin: 0 0 50px 0;
            line-height: 1.2;
        }

        form {
            display: flex;
            gap: 20px;
            margin-bottom: 40px;
        }

        input[type="text"] {
            flex: 1;
            padding: 18px 20px;
            font-size: 1rem;
            font-family: 'Inter', sans-serif;
            font-weight: 500;
            border: 2px solid var(--ink);
            border-radius: 3px;
            background: var(--bg);
            color: var(--ink);
        }
        input[type="text"]::placeholder { color: #6b7280; font-weight: 400; }

        button {
            padding: 18px 36px;
            font-size: 1rem;
            font-family: 'Inter', sans-serif;
            background-color: var(--purple);
            color: white;
            border: 2px solid var(--purple-dark);
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            letter-spacing: 0.01em;
        }
        button:hover { background-color: var(--purple-dark); }

        h2 {
            font-family: 'Inter', sans-serif;
            font-weight: 600;
            font-size: 1.5rem;
            color: var(--purple);
            margin-bottom: 24px;
        }

        .card { background: #F4F1FA; padding: 18px 20px; margin-bottom: 16px; border-radius: 6px; border-left: 5px solid var(--purple); }
        .protein { font-weight: 700; color: #2E1B4D; font-family: 'Inter', sans-serif; }
        .species { color: #6B5A94; font-style: italic; }
        .seq { font-family: 'Courier New', monospace; background: #E4DCF2; padding: 10px; border-radius: 4px; word-break: break-all; margin-top: 10px; font-size: 13px; color: #3D2A5C; }
        .total { font-family: 'Inter', sans-serif; font-weight: 700; margin-top: 24px; color: var(--purple); }
        .empty { color: #475569; }
    </style>
</head>
<body>
    <div class="corner corner-tr"></div>
    <div class="corner corner-bl"></div>

    <div class="container">
        <h1>Programa de Consulta de Toxinas de Cnidários</h1>

        <form method="GET" action="/">
            <input type="text" name="q" value="<%= $busca %>" placeholder="Digite o género ou espécie (ex: Hydra, Actinia)..." required>
            <button type="submit">Pesquisar</button>
        </form>

        % if ($busca ne '') {
            <h2>Resultados para: "<%= $busca %>"</h2>

            % if (scalar @$resultados == 0) {
                <p class="empty">Nenhum registo encontrado para esta espécie.</p>
            % } else {
                % my $i = 1;
                % foreach my $r (@$resultados) {
                    <div class="card">
                        <div><strong>#<%= $i++ %></strong> - <span class="protein"><%= $r->{nome_proteina} %></span></div>
                        <div class="species">Organismo: <%= $r->{especie} %></div>
                        <div class="seq"><%= substr($r->{sequencia}, 0, 70) %>... (<%= length($r->{sequencia}) %> aa)</div>
                    </div>
                % }
                <p class="total">&gt;&gt;&gt; Total de registos encontrados: <%= scalar @$resultados %></p>
            % }
        % }
    </div>
</body>
</html>