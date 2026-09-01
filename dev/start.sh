#!/usr/bin/env bash

set -e

cd "$(dirname "$0")/.."

cleanup() {
  trap - INT TERM EXIT

  echo
  echo "Encerrando frontend e backend..."

  kill "$BACKEND_PID" "$FRONTEND_PID" 2>/dev/null || true
  wait "$BACKEND_PID" "$FRONTEND_PID" 2>/dev/null || true

  echo "Aplicações encerradas."
  exit 0
}

trap cleanup INT TERM

echo "Iniciando PostgreSQL..."
docker compose up -d

echo "Iniciando backend..."
./dev/backend.sh &
BACKEND_PID=$!

echo "Iniciando frontend..."
./dev/frontend.sh &
FRONTEND_PID=$!

echo
echo "Ambiente de desenvolvimento iniciado."
echo "Frontend: http://localhost:5173"
echo "Backend:  http://localhost:4000"
echo
echo "Pressione Ctrl+C para encerrar."

wait "$BACKEND_PID" "$FRONTEND_PID"
