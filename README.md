# Configuração do Ambiente de Desenvolvimento

Este documento descreve as etapas necessárias para configurar o ambiente de desenvolvimento do projeto em uma nova máquina Linux.

## 1. Tecnologias utilizadas

O projeto utiliza:

| Tecnologia | Versão |
|---|---|
| Node.js | 24.20.0 |
| npm | 11.19.0 |
| Erlang/OTP | 27 |
| Elixir | 1.17.3 / OTP 27 |
| Phoenix | 1.8.x |
| React | Vite |
| PostgreSQL | 16 |
| Docker | Docker Engine |
| Docker Compose | Compose Plugin |
| mise | Gerenciador de versões |
| Git | Controle de versão |

A estrutura principal do projeto é:

```text
projetos/
├── backend/             # API Elixir/Phoenix
├── frontend/            # React + Vite
├── dev/                 # Scripts de desenvolvimento
├── .env.example         # Modelo das variáveis de ambiente
├── .gitignore
├── compose.yaml         # PostgreSQL via Docker
└── mise.toml            # Versões das ferramentas
```

---

# 2. Instalar o Git

Atualize os repositórios:

```bash
sudo apt update
```

Instale o Git:

```bash
sudo apt install -y git
```

Confira:

```bash
git --version
```

Configure sua identidade:

```bash
git config --global user.name "SEU_NOME"
git config --global user.email "SEU_EMAIL"
```

Confira:

```bash
git config --global user.name
git config --global user.email
```

---

# 3. Instalar o Docker

O projeto utiliza PostgreSQL dentro de um container Docker.

Instale inicialmente os pacotes necessários:

```bash
sudo apt update
sudo apt install -y ca-certificates curl
```

Crie o diretório para a chave:

```bash
sudo install -m 0755 -d /etc/apt/keyrings
```

Baixe a chave oficial do Docker:

```bash
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  -o /etc/apt/keyrings/docker.asc
```

Ajuste a permissão:

```bash
sudo chmod a+r /etc/apt/keyrings/docker.asc
```

Para Linux Mint 22.x baseado no Ubuntu 24.04 Noble, configure o repositório:

```bash
echo \
"Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: noble
Components: stable
Architectures: amd64
Signed-By: /etc/apt/keyrings/docker.asc" | \
sudo tee /etc/apt/sources.list.d/docker.sources > /dev/null
```

Atualize:

```bash
sudo apt update
```

Instale o Docker:

```bash
sudo apt install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin
```

Confira:

```bash
docker --version
docker compose version
```

---

# 4. Permitir Docker sem sudo

Adicione seu usuário ao grupo `docker`:

```bash
sudo usermod -aG docker $USER
```

Ative o grupo na sessão atual:

```bash
newgrp docker
```

Confira:

```bash
groups
```

O grupo `docker` deverá aparecer.

Teste:

```bash
docker run hello-world
```

Se aparecer a mensagem `Hello from Docker!`, a instalação está funcionando.

> Em algumas situações será necessário sair da sessão do Linux e entrar novamente para que a alteração do grupo seja aplicada.

---

# 5. PostgreSQL local

O projeto utiliza PostgreSQL pelo Docker.

Caso exista PostgreSQL instalado e executando diretamente no Linux, ele poderá disputar a porta `5432` com o container.

Confira:

```bash
pg_lsclusters
```

Se houver um PostgreSQL local executando na porta `5432`, pare-o:

```bash
sudo systemctl stop postgresql
```

Desative a inicialização automática:

```bash
sudo systemctl disable postgresql
```

Confira novamente:

```bash
pg_lsclusters
```

O status deverá aparecer como:

```text
down
```

Verifique a porta:

```bash
sudo ss -ltnp | grep 5432
```

Antes de iniciar o container, idealmente não deverá haver outro serviço utilizando essa porta.

---

# 6. Instalar dependências para Erlang

O Erlang será instalado pelo `mise`, mas precisa de algumas bibliotecas do sistema para compilação.

Execute:

```bash
sudo apt update

sudo apt install -y \
  build-essential \
  autoconf \
  m4 \
  libncurses-dev \
  libssl-dev \
  libwxgtk3.2-dev \
  libgl1-mesa-dev \
  libglu1-mesa-dev \
  libpng-dev \
  libssh-dev \
  unixodbc-dev \
  xsltproc \
  fop \
  libxml2-utils \
  openjdk-17-jdk
```

Essas dependências evitam erros de compilação como:

```text
configure: error: No curses library functions found
```

---

# 7. Instalar o mise

O projeto utiliza `mise` para padronizar as versões de Node.js, Erlang e Elixir.

Instale:

```bash
curl https://mise.run | sh
```

Adicione a ativação ao Bash:

```bash
echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc
```

Recarregue:

```bash
source ~/.bashrc
```

Confira:

```bash
mise --version
```

---

# 8. Clonar o projeto

Escolha o diretório onde o projeto será armazenado.

Por exemplo:

```bash
cd ~
```

Clone:

```bash
git clone https://github.com/ViniciosBalduino/p-ojetos.git projetos
```

Entre no projeto:

```bash
cd ~/projetos
```

---

# 9. Autorizar o mise

Ao entrar no projeto pela primeira vez, autorize a configuração:

```bash
mise trust
```

O arquivo:

```text
mise.toml
```

define as versões utilizadas pelo projeto.

Instale-as:

```bash
mise install
```

Essa etapa poderá demorar, principalmente durante a instalação/compilação do Erlang.

---

# 10. Verificar as versões

Execute:

```bash
mise current
```

Depois:

```bash
node --version
npm --version
elixir --version
```

O ambiente esperado deverá ser compatível com:

```text
Node.js      24.20.0
npm          11.19.0
Erlang/OTP   27
Elixir       1.17.3 compilado com OTP 27
```

O comando:

```bash
elixir --version
```

deverá indicar:

```text
Elixir 1.17.3 (compiled with Erlang/OTP 27)
```

---

# 11. Criar as variáveis de ambiente

Na raiz do projeto existe:

```text
.env.example
```

Crie a configuração local:

```bash
cd ~/projetos
cp .env.example .env
```

O arquivo `.env` contém configurações locais e não deve ser enviado ao Git.

O modelo utilizado em desenvolvimento contém:

```env
POSTGRES_USER=backend_user
POSTGRES_PASSWORD=backend_dev
POSTGRES_DB=backend_dev
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
```

> Essas credenciais são destinadas somente ao ambiente local de desenvolvimento.

---

# 12. Instalar dependências do frontend

Entre no frontend:

```bash
cd ~/projetos/frontend
```

Instale exatamente as dependências registradas no `package-lock.json`:

```bash
npm ci
```

O uso de `npm ci` é recomendado em máquinas novas para manter o ambiente reproduzível.

---

# 13. Instalar Hex

Entre no backend:

```bash
cd ~/projetos/backend
```

Instale o Hex:

```bash
mix local.hex --force
```

---

# 14. Instalar Rebar

Instale também o Rebar utilizado por algumas dependências Erlang:

```bash
mix local.rebar --force
```

---

# 15. Instalar dependências do backend

Ainda em:

```text
~/projetos/backend
```

execute:

```bash
mix deps.get
```

Compile:

```bash
mix compile
```

---

# 16. Iniciar o PostgreSQL

Volte para a raiz:

```bash
cd ~/projetos
```

Inicie o PostgreSQL:

```bash
docker compose up -d
```

Confira:

```bash
docker compose ps
```

Deverá aparecer o container:

```text
projeto_postgres
```

com status semelhante a:

```text
Up
```

---

# 17. Testar o PostgreSQL

É possível entrar diretamente no PostgreSQL:

```bash
docker exec -it projeto_postgres \
  psql -U backend_user -d backend_dev
```

Se aparecer:

```text
backend_dev=#
```

o banco está funcionando.

Para sair:

```text
\q
```

---

# 18. Preparar o banco para o Phoenix

As variáveis do `.env` precisam estar disponíveis para os comandos executados manualmente no backend.

Na raiz:

```bash
cd ~/projetos

set -a
source .env
set +a
```

Depois:

```bash
cd backend
mix ecto.create
mix ecto.migrate
```

Em uma instalação nova, as migrations existentes serão aplicadas ao banco.

O script de desenvolvimento do backend já carrega o `.env` automaticamente durante a inicialização normal.

---

# 19. Iniciar somente o backend

Na raiz:

```bash
cd ~/projetos
./dev/backend.sh
```

O Phoenix deverá ficar disponível em:

```text
http://localhost:4000
```

A API de teste pode ser acessada em:

```text
http://localhost:4000/api/hello
```

---

# 20. Iniciar somente o frontend

Em outro terminal:

```bash
cd ~/projetos
./dev/frontend.sh
```

O Vite deverá ficar disponível em:

```text
http://localhost:5173
```

---

# 21. Iniciar o ambiente completo

Para iniciar PostgreSQL, Phoenix e React:

```bash
cd ~/projetos
./dev/start.sh
```

O ambiente deverá disponibilizar:

```text
Frontend
http://localhost:5173

Backend
http://localhost:4000

API de teste
http://localhost:4000/api/hello

PostgreSQL
localhost:5432
```

O frontend deverá conseguir acessar o backend e exibir a resposta da API.

---

# 22. Encerrar o ambiente

Frontend e backend podem ser encerrados com:

```text
Ctrl+C
```

O PostgreSQL continuará rodando em segundo plano pelo Docker.

Para pará-lo:

```bash
cd ~/projetos
docker compose stop
```

Para iniciá-lo novamente:

```bash
docker compose start
```

Também é possível remover o container:

```bash
docker compose down
```

O volume do PostgreSQL será preservado.

## Atenção

Não execute:

```bash
docker compose down -v
```

a menos que realmente queira apagar o volume e os dados do banco de desenvolvimento.

---

# 23. Fluxo diário de desenvolvimento

Depois que a máquina estiver configurada, normalmente basta entrar no projeto:

```bash
cd ~/projetos
```

Atualizar o código:

```bash
git pull
```

E iniciar:

```bash
./dev/start.sh
```

---

# 24. Fluxo básico do Git

Antes de começar uma alteração:

```bash
git status
git pull
```

Depois de desenvolver:

```bash
git status
git add .
git commit -m "descrição da alteração"
git push
```

A branch principal do projeto é:

```text
main
```

---

# 25. Arquivos que não devem ser enviados ao Git

O `.gitignore` impede o versionamento de arquivos como:

```text
.env
frontend/node_modules/
frontend/dist/
backend/deps/
backend/_build/
```

Nunca adicione manualmente o `.env` ao Git.

O arquivo que deve ser versionado é:

```text
.env.example
```

---

# 26. Diagnóstico rápido

## Docker sem permissão

Erro:

```text
permission denied while trying to connect to the docker API
```

Tente:

```bash
newgrp docker
```

ou encerre a sessão do Linux e entre novamente.

Confira:

```bash
groups
```

---

## Porta 5432 ocupada

Confira:

```bash
sudo ss -ltnp | grep 5432
```

Se o PostgreSQL local estiver executando:

```bash
sudo systemctl stop postgresql
```

---

## Verificar containers

```bash
docker compose ps
```

---

## Verificar logs do PostgreSQL

```bash
docker compose logs postgres
```

---

## Verificar versões do projeto

```bash
mise current
```

---

## Reinstalar dependências do frontend

```bash
cd ~/projetos/frontend
rm -rf node_modules
npm ci
```

---

## Atualizar dependências Elixir conforme o lockfile

```bash
cd ~/projetos/backend
mix deps.get
```

---

# 27. Checklist de uma máquina nova

Antes de considerar a configuração concluída, verifique:

- Git instalado e configurado.
- Docker instalado.
- Usuário pertencendo ao grupo `docker`.
- `docker run hello-world` funcionando.
- PostgreSQL local não ocupando a porta 5432.
- Dependências de compilação do Erlang instaladas.
- `mise` instalado.
- Repositório clonado.
- `mise trust` executado.
- `mise install` concluído.
- Elixir compilado para OTP 27.
- `.env` criado a partir de `.env.example`.
- `npm ci` concluído.
- Hex instalado.
- Rebar instalado.
- `mix deps.get` concluído.
- PostgreSQL Docker executando.
- Migrations executadas.
- Phoenix executando na porta 4000.
- React/Vite executando na porta 5173.
- Frontend conseguindo acessar `/api/hello`.

Quando todos esses itens estiverem funcionando, a máquina está pronta para desenvolvimento.
