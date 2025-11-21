#!/bin/bash
set -euo pipefail

# URL base (isso é um teste.) 
BASE_URL="https://raw.githubusercontent.com/FelipeR-UFBA/lab-ransomware/main"
MENU_FILE="menu.sh"

clear
echo "[$(date +%FT%T)] [INFO] Iniciando Lançador Dinâmico..."

# Verifica a dependência 'curl'
if ! command -v curl >/dev/null 2>&1; then
  echo "[$(date +%FT%T)] [ERRO] CRÍTICO: 'curl' não encontrado."
  tail -f /dev/null
  exit 1
fi

echo "[$(date +%FT%T)] [INFO] Baixando menu dinâmico do GitHub..."

# Cria um arquivo temporário para o download (com fallback se /tmp não for gravável)
tmp_file="$(mktemp /tmp/menu.XXXXXX.sh 2>/dev/null || true)"
if [ -z "$tmp_file" ]; then
  # fallback para diretório atual
  tmp_file="./.menu.XXXXXX.sh"
  tmp_file="$(mktemp "$tmp_file")"
fi

# Remoção do temp caso dê merda
trap 'rc=$?; rm -f "$tmp_file" || true; exit $rc' EXIT

# Baixa o arquivo temporário.
if ! curl -fsSL --retry 3 --connect-timeout 10 -o "$tmp_file" "$BASE_URL/$MENU_FILE"; then
  echo "[$(date +%FT%T)] [ERRO] Falha ao baixar $MENU_FILE do repositório."
  tail -f /dev/null
  exit 1
fi

# Verifica se o arquivo não está vazio
if [ ! -s "$tmp_file" ]; then
  echo "[$(date +%FT%T)] [ERRO] Arquivo baixado vazio (possível erro de rede/proxy)."
  tail -f /dev/null
  exit 1
fi

# Move o temporário para local final e dá permissão de exec
mv "$tmp_file" "./$MENU_FILE"
chmod +x "./$MENU_FILE"

# Remove trap 
trap - EXIT

# Executa o menu.sh
echo "[$(date +%FT%T)] [INFO] Executando $MENU_FILE..."
exec "./$MENU_FILE"
