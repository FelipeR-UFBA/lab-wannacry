#!/bin/bash

# URL base do meu repositório (para baixar os cenários)
BASE_URL="https://raw.githubusercontent.com/FelipeR-UFBA/lab-wannacry/main"

# Função para limpar processos antigos
cleanup() {
  echo "[INFO] Limpando processos antigos (Mininet, OVS, Ryu, Nox)..."
  pkill -9 -f "mininet:"
  pkill -9 -f "ovs-controller"
  pkill -9 -f "ryu-manager"
  pkill -9 -f "nox_core"
  echo "[OK] Limpeza concluída."
}

# "Trap" para capturar sinais de desligamento (SIGTERM do K8s)
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
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠿⣼⡠⟍⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀<- But that's actually a duck
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀
EOF

# Verificação de Dependências
echo "[INFO] Verificando dependências..."
DEPS=("curl" "tmux" "mnsec")
for cmd in "${DEPS[@]}"; do
  if ! command -v "$cmd" &> /dev/null; then
    echo "[ERRO] CRÍTICO: Dependência '$cmd' não encontrada."
    echo "[ERRO] O contêiner base 'hackinsdn/mininet-sec' pode estar quebrado."
    tail -f /dev/null
    exit 1
  fi
done
echo -e "\n Ambiente verificado. Tudo pronto!\n"


# Verificação de Internet
echo "[INFO] Verificando conexão com a Internet..."
if ! ping -c1 github.com &>/dev/null; then
  echo "[ERRO] Sem conexão com a Internet."
  tail -f /dev/null
  exit 1
fi
echo "[OK] Conexão estabelecida."
echo ""

# Informações do Laboratório
echo "------------------------------------------------------------------"
echo " Laboratório Dinâmico de Simulação de Ransomware - v1.0 (HackInSDN)"
echo " FelipeR"
echo "------------------------------------------------------------------"
echo ""
echo "Qual cenário você gostaria de executar?"
echo ""
echo "  [A] Cenário A: WannaCry Completo (Windows - Falha Esperada de Rede)"
echo "  [B] Cenário B: WannaCry Mínimo (Windows - Teste de Diagnóstico)"
echo "  [C] Cenário C: SambaCry (Plano B - Linux - **PENDENTE**)"
echo "  [q] Sair (Apenas ficar no terminal)"
echo ""

while true; do
  read -r -p "Escolha uma opção [A, B, C, ou q]: " ESCOLHA
  case "$ESCOLHA" in 
    [Aa])
      CENARIO_FILE="cenario-A.yml"
      DESC="Cenário A: WannaCry Completo"
      break
      ;;
    [Bb])
      CENARIO_FILE="cenario-B.yml"
      DESC="Cenário B: WannaCry Mínimo"
      break
      ;;
    [Cc])
      CENARIO_FILE="cenario-C.yml"
      DESC="Cenário C: SambaCry (Linux)"
      break
      ;;
    [Qq])
      echo "[INFO] Saindo. O pod continuará rodando para depuração."
      tail -f /dev/null
      exit 0
      ;;
    *)
      echo "Opção inválida. Tente novamente."
      ;;
  esac
done

# Execução do Cenário
echo ""
echo "[INFO] Você escolheu: $DESC"
echo "[INFO] Baixando a versão mais recente de '$CENARIO_FILE' do GitHub..."

# Apaga o arquivo antigo (se existir) e baixa o novo
rm -f "$CENARIO_FILE"

# Usando curl -fsSL para falhar em erros de HTTP 
if ! curl -fsSL -o "$CENARIO_FILE" "$BASE_URL/$CENARIO_FILE"; then
    echo "******************************************************************"
    echo "[ERRO] Falha ao baixar '$CENARIO_FILE' do repositório."
    echo "[ERRO] Verifique o nome do arquivo no GitHub ou a conexão."
    echo "******************************************************************"
    tail -f /dev/null
    exit 1
fi

echo "[OK] Arquivo baixado com sucesso."
echo "[INFO] Iniciando Mininet-Sec em segundo plano..."

tmux new-session -d -s mnsec -- mnsec --topofile "$CENARIO_FILE"

sleep 2

# Checagem para ver se o mnsec realmente iniciou.
if ! tmux has-session -t mnsec 2>/dev/null; then
    echo "******************************************************************"
    echo "[ERRO] CRÍTICO: O 'mnsec' falhou ao iniciar!"
    echo ""
    echo "[INFO] Causa Provável: A topologia '$CENARIO_FILE' falhou (ex: o erro 'Network is unreachable')."
    echo "[INFO] Se você escolheu o Cenário A, isso é o esperado."
    echo "[INFO] Se você escolheu outro cenário, revise o arquivo .yml no GitHub."
    echo "******************************************************************"
    tail -f /dev/null
    exit 1
fi

echo ""
echo "******************************************************************"
echo "[OK] SUCESSO! O laboratório '$DESC' está iniciando em segundo plano."
echo ""
echo "O que fazer agora:"
echo "1. AGUARDE 1-2 minutos (para o lab iniciar)."
echo "2. No seu navegador, volte ao painel da HackInSDN."
echo "3. Clique no link 'http-mininet-sec' para ver a GUI."
echo "4. Clique nos links VNC ('vnc-atacante', etc) para ver os desktops."
echo "******************************************************************"

tail -f /dev/null