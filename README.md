# LAB-WANNACRY

## 🎯 Objetivo do Laboratório

Este laboratório tem como objetivo principal fornecer um ambiente seguro e controlado para a análise e estudo do *ransomware* **WannaCry (Wana Decrypt0r)**, que causou uma epidemia global em maio de 2017.

O estudo foca em:
1.  Compreender o mecanismo de infecção e a vetor de propagação (exploração da vulnerabilidade **MS17-010 / EternalBlue**).
2.  Analisar o comportamento do *malware*, incluindo a cifragem de arquivos e a nota de resgate.
3.  Estudar as técnicas de análise de *malware* aplicáveis ao WannaCry.
4.  Implementar e testar medidas de mitigação e prevenção.

---

## 🛠️ Pré-requisitos e Setup

Para reproduzir este laboratório, você precisará dos seguintes componentes e softwares:

### 💻 Hardware e Software Necessários

* **Sistema Operacional Host:** [Especifique o SO, ex: Windows 10, Linux, macOS]
* **Software de Virtualização:** [Especifique o software, ex: Oracle VirtualBox, VMware Workstation/Fusion]
* **Máquina Virtual 1 (Alvo):** Windows [Versão e arquitetura, ex: Windows 7 SP1 32-bit ou Windows Server 2008 R2]. **É crucial que a máquina alvo seja vulnerável (patches de segurança de antes de Março de 2017).**
* **Máquina Virtual 2 (Opcional - Atacante/Análise):** [Ex: Kali Linux, REMnux, ou outra distribuição de análise]

### ⚙️ Configuração da Rede

Recomenda-se enfaticamente que a rede virtual seja configurada no modo **Host-Only** ou **Rede Interna** para isolar completamente o ambiente de laboratório da sua rede de produção e da internet.

* **Modo:** [Ex: Host-Only / Rede Interna]
* **Faixa de IP:** [Ex: 192.168.56.0/24]

---

## 📂 Estrutura do Repositório

O repositório está organizado para facilitar o acesso aos recursos necessários para o laboratório.

| Arquivo/Diretório | Descrição |
| :--- | :--- |
| `malware/` | Contém as amostras do WannaCry (ou *placeholders* para download seguro) e os *payloads* necessários. |
| `scripts/` | Scripts de auxílio para o setup (ex: scripts para criar arquivos de teste ou configurar *honeypots*). |
| `documentacao/` | Arquivos de apoio como diagramas de rede, relatórios de análise preliminares, ou guias de *setup*. |
| `README.md` | Este arquivo, contendo as instruções e documentação do laboratório. |

---

## 👨‍💻 Instruções de Execução

Siga os passos abaixo em seu ambiente de virtualização isolado.

### Passo 1: Preparação das Máquinas Virtuais

1.  Instale e configure a VM Alvo (Windows vulnerável).
2.  Certifique-se de que a rede está configurada conforme a seção **Configuração da Rede** acima.

### Passo 2: Análise Estática (Opcional)

1.  **[Adicione o passo de análise estática, ex: Cálculo de Hash, análise com PEview.]**

### Passo 3: Simulação da Infecção

1.  No ambiente isolado, execute a amostra do WannaCry (ou a simulação controlada).
2.  **[Adicione o comando ou método de execução.]**

### Passo 4: Análise Dinâmica e Comportamento

1.  Monitore a atividade do *malware* (tráfego de rede, alterações no sistema de arquivos, processos).
2.  **[Adicione as ferramentas de monitoramento usadas, ex: Wireshark, Process Monitor.]**
3.  Documente o processo de cifragem e a criação de arquivos específicos do WannaCry (`@WanaDecryptor@.exe`, `00000000.eky`, etc.).

### Passo 5: Mitigação e Limpeza

1.  **[Adicione os passos de mitigação, ex: aplicação do patch MS17-010, simulação da detecção do *kill switch*.]**
2.  Desligue a VM Alvo e realize um *snapshot* de segurança, ou reverta para um *snapshot* limpo.

---

## ⚠️ Aviso Legal

Este material foi criado exclusivamente para **fins educacionais e de pesquisa**.

* **NUNCA** execute o *malware* em ambientes conectados à internet ou em sua rede de produção.
* O autor deste repositório e a plataforma não se responsabilizam por quaisquer danos causados pelo uso indevido deste conteúdo.
* O estudo de *malware* deve sempre ser conduzido em um ambiente virtualizado e completamente isolado (`air-gapped`).
