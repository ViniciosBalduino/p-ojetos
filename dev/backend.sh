#!/usr/bin/env bash

set -e

cd "$(dirname "$0")/.."

if [ ! -f ".env" ]; then
  echo "Erro: arquivo .env não encontrado."
  echo "Crie-o com:"
  echo "cp .env.example .env"
  exit 1
fi

set -a
source .env
set +a

cd backend

exec mix phx.server
