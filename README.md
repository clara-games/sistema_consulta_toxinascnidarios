
# Sistema de Consulta de Toxinas de Cnidários

Aplicação web desenvolvida em Perl para pesquisar toxinas registradas em um banco de dados SQLite. O sistema permite consultar proteínas associadas a organismos do filo Cnidaria, exibindo os resultados em uma interface.

## Sobre o projeto

Este projeto foi criado para facilitar a consulta de informações biológicas de forma local, sem depender de serviços externos. A aplicação faz a busca diretamente em um banco de dados SQLite e apresenta os resultados em uma página web.

A ideia principal é unir:

- consulta de dados biológicos
- armazenamento em banco de dados
- interface web simples
- execução local no computador

O sistema foi desenvolvido com foco acadêmico e pode ser usado como base para projetos de bioinformática, páginas de pesquisa ou sistemas internos de consulta.

## Funcionalidades

- Busca por nomenclatura bimodal
- Exibição do nome da proteína
- Exibição da espécie associada
- Visualização parcial da sequência de aminoácidos
- Contagem total de resultados encontrados
- Interface web fácil de usar
- Execução local no computador

## Tecnologias utilizadas

- Perl
- Mojolicious::Lite
- DBI
- DBD::SQLite
- HTML
- CSS

## Estrutura do projeto

```text
.
├── app_toxinas.pl
├── venenos.db
└── templates/
    └── index.html.ep
````

### Arquivos principais

* `app_toxinas.pl`: arquivo principal da aplicação, responsável pelo servidor web, conexão com o banco e exibição dos dados.
* `venenos.db`: banco de dados SQLite com os registros de toxinas.
* `templates/index.html.ep`: template da página web exibida no navegador.

## Como o sistema funciona

1. O usuário abre a aplicação no navegador.
2. Digita um gênero e espécie no campo de busca ou pela nomenclatura binomial (gênero + espécie)
3. O sistema consulta o banco de dados SQLite.
4. Os registros encontrados são exibidos na tela.
5. Caso não exista resultado, o sistema mostra uma mensagem informando isso.

## Requisitos

Antes de executar o projeto, é necessário ter instalado:

* Perl
* Mojolicious
* DBI
* DBD::SQLite
* Banco de dados SQLite já preenchido com os dados do projeto

## Instalação

### Windows

Se estiver usando Windows, a forma mais simples é instalar o Strawberry Perl.

Depois, abra o Prompt de Comando ou PowerShell e instale as dependências com:

```bash
cpan Mojolicious DBI DBD::SQLite
```

### Linux

Em distribuições Linux, instale o Perl e os módulos necessários usando o gerenciador de pacotes da sua distribuição ou o CPAN.

Exemplo:

```bash
cpan Mojolicious DBI DBD::SQLite
```

### macOS

No macOS, o processo também pode ser feito com CPAN:

```bash
cpan Mojolicious DBI DBD::SQLite
```

## Como executar

1. Coloque todos os arquivos do projeto na mesma pasta.
2. Verifique se o arquivo `venenos.db` está no local correto.
3. Abra o terminal dentro da pasta do projeto.
4. Execute o servidor com o comando:

```bash
perl app_toxinas.pl daemon
```

5. Abra o navegador e acesse:

```text
http://127.0.0.1:3000
```

## Como usar

1. Digite o nome de um gênero ou espécie no campo de busca.
2. Clique em "Pesquisar".
3. Veja os resultados retornados pelo sistema.

Exemplos de busca:

* Hydra magnipapillata (Gênero e espécie)
* Actinia (Gênero)


## Personalização

A aparência da aplicação pode ser alterada diretamente no arquivo `index.html.ep`, na seção de estilo CSS.

Também é possível modificar:

* a cor de fundo
* o estilo do botão
* o tamanho dos títulos
* o formato dos cards de resultado
* a quantidade de caracteres exibidos na sequência

## Banco de dados

O projeto utiliza um banco SQLite local. A consulta é feita na tabela `toxinas`, que deve conter pelo menos os seguintes campos:

* `nome_proteina`
* `especie`
* `sequencia`

Se o seu banco usar nomes diferentes, será necessário ajustar a consulta SQL no arquivo `app_toxinas.pl`.

## Objetivo acadêmico

Este projeto foi desenvolvido para demonstrar o uso de:

* programação em Perl
* banco de dados SQLite
* desenvolvimento de aplicações web
* organização e consulta de dados biológicos


```
