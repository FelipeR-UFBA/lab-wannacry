#!/bin/bash

# URL base do meu repositório (para baixar os cenários)
BASE_URL="https://raw.githubusercontent.com/FelipeR-UFBA/lab-ransomware/main"

# Função de log com timestamp
log() {
  echo "[$(date +%FT%T)] $*"
}

# Função para limpar processos antigos
cleanup() {
  log "[INFO] Limpando processos antigos (Mininet, OVS, Ryu, Nox)..."
  pkill -9 -f "mininet:" 2>/dev/null || true
  pkill -9 -f "ovs-controller" 2>/dev/null || true
  pkill -9 -f "ryu-manager" 2>/dev/null || true
  pkill -9 -f "nox_core" 2>/dev/null || true
  log "[OK] Limpeza concluída."
}

# Trap para capturar sinais de desligamento (SIGTERM do K8s)
trap cleanup SIGINT SIGTERM

# Limpa qualquer processo fantasma antes de começar
cleanup

# O Pato <- é literalmente só um pato, não vou elaborar.
clear
cat <<'EOF'
⠀⠀⠀⠀⢠⡔⠒⠀⠒⣤⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀so much depends
⠀⠀⠀⢠⠋⠀⠀⠀⠀⠈⢧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀upon
⠀⠀⢀⣦⣆⠀⢰⠦⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⢠⠞⠉⠙⠈⡆⠀⠀⠀⠀⢼⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀a red wheel
⠈⠒⠒⠒⠒⠧⡀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀barrow
⠀⠀⠀⠀⠀⠀⢣⠀⠀⠀⠘⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⡜⠀⠀⠀⠀⠈⠑⠦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀glazed with rain
⠀⠀⠀⠀⠀⡰⠁⠀⠀⠀⢀⠀⠀⠀⠈⠑⠢⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀water
⠀⠀⠀⠀⢠⠃⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠄⣉⠲⢄⡀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⢇⠀⠀⠀⠀⠀⠀⠀⠑⠦⣈⠑⠦⣀⠀⠀⠀beside the white
⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠳⣄⠀⠀⠀⠀⠀⠀⠀⠈⠑⣆⡀⠉⠑⡆chickens
⠀⠀⠀⠀⠈⢦⡀⠀⠀⠀⠀⠀⠀⠀⠑⠂⠤⠀⠠⠤⠤⠄⠊⣁⡀⠤⠚⠁
⠀⠀⢀⡼⡄⠀⠉⣢⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡠⠴⠒⠉⠁⠀⠀⠀⠀
⠀⠀⠈⠻⡧⠒⠉⠈⠀⡅⡏⠈⢃⡾⠞⠁⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠿⣼⡠⟍ But it’s actually a duck.
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀
EOF

# Verificação de Dependências
log "[INFO] Verificando dependências..."
DEPS=("curl" "tmux" "mnsec")
for cmd in "${DEPS[@]}"; do
  if ! command -v "$cmd" &> /dev/null; then
    log "[ERRO] CRÍTICO: Dependência '$cmd' não encontrada."
    log "[ERRO] O contêiner base 'hackinsdn/mininet-sec' pode estar quebrado."
    log "[INFO] Mantendo o pod ativo para depuração..."
    tail -f /dev/null & wait $!
    exit 1
  fi
done
echo ""
log "[OK] Ambiente verificado. Tudo pronto!"
echo ""

# Verificação de Internet
log "[INFO] Verificando conexão com a Internet..."
if ! curl -fsI https://github.com &>/dev/null; then
  log "[ERRO] Sem conexão com a Internet (falha ao acessar GitHub)."
  log "[INFO] Mantendo o pod ativo para depuração..."
  tail -f /dev/null & wait $!
  exit 1
fi
log "[OK] Conexão estabelecida."
echo ""

# Informações do Laboratório
echo "------------------------------------------------------------------"
echo " Laboratório Dinâmico de Simulação de Ransomware - v1.0 (HackInSDN)"
echo " FelipeR"
echo "------------------------------------------------------------------"
echo -e "\033[1;34mEscolha uma opção:\033[0m"
echo ""
echo "  [A] Cenário A: WannaCry Completo (Windows - Falha Esperada de Rede)"
echo "  [B] Cenário B: WannaCry Mínimo (Windows - Teste de Diagnóstico)"
echo "  [C] Cenário C: Linux Ransomware"
echo "  [q] Sair (Apenas ficar no terminal)"
echo ""

# Loop de seleção de cenário
while true; do
  read -r -p "Escolha uma opção [A, B, C, ou q]: " ESCOLHA
  case "$ESCOLHA" in 
    [Aa])
      CENARIO_FILE="cenario-A.yml"
      DESC="Cenário A: WannaCry Completo"
      break ;;
    [Bb])
      CENARIO_FILE="cenario-B.yml"
      DESC="Cenário B: WannaCry Mínimo"
      break ;;
    [Cc])
      CENARIO_FILE="cenario-C.yml"
      DESC="Cenário C: Linux Ransomware"
      break ;;
    [Qq])
      log "[INFO] Saindo. O pod continuará rodando para depuração."
      tail -f /dev/null & wait $!
      exit 0 ;;
    *)
      echo "Opção inválida. Tente novamente." ;;
  esac
done

# Execução do Cenário
echo ""
log "[INFO] Você escolheu: $DESC"
log "[INFO] Baixando a versão mais recente de '$CENARIO_FILE' do GitHub..."

# Apaga o arquivo antigo (se existir) e baixa o novo
rm -f "$CENARIO_FILE"

# curl -fsSL para falhar em erros de HTTP 
if ! curl -fsSL -o "$CENARIO_FILE" "$BASE_URL/$CENARIO_FILE"; then
  echo "******************************************************************"
  log "[ERRO] Falha ao baixar '$CENARIO_FILE' do repositório."
  log "[ERRO] Verifique o nome do arquivo no GitHub ou a conexão."
  echo "******************************************************************"
  log "[INFO] Mantendo o pod ativo para depuração..."
  tail -f /dev/null & wait $!
  exit 1
fi

log "[OK] Arquivo baixado com sucesso."
log "[INFO] Iniciando Mininet-Sec em segundo plano..."

tmux new-session -d -s mnsec -- mnsec --topofile "$CENARIO_FILE"
sleep 2

# Checagem para ver se o mnsec realmente iniciou.
if ! tmux has-session -t mnsec 2>/dev/null; then
  echo "******************************************************************"
  log "[ERRO] CRÍTICO: O 'mnsec' falhou ao iniciar!"
  echo ""
  log "[INFO] Causa provável: a topologia '$CENARIO_FILE' falhou (ex: 'Network is unreachable')."
  log "[INFO] Se você escolheu o Cenário A, isso é o esperado."
  log "[INFO] Se você escolheu outro cenário, revise o arquivo .yml no GitHub."
  echo "******************************************************************"
  log "[INFO] Mantendo o pod ativo para depuração..."
  tail -f /dev/null & wait $!
  exit 1
fi

echo ""
echo "******************************************************************"
log "[OK] SUCESSO! O laboratório '$DESC' está iniciando em segundo plano."
echo ""
echo "O que fazer agora:"
echo "1. AGUARDE 1-2 minutos (para o lab iniciar)."
echo "2. No seu navegador, volte ao painel da HackInSDN."
echo "3. Clique no link 'http-mininet-sec' para ver a GUI."
echo "4. Clique nos links VNC ('vnc-atacante', etc) para ver os desktops."
echo "******************************************************************"

log "[INFO] Mantendo o pod ativo para depuração..."
tail -f /dev/null & wait $!
