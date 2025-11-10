
TARGET_DIR="/home/sambacry"
FILE_NAME="LEIA_ME_SEUS_FICHEIROS_FORAM_CIFRADOS.txt"
FULL_PATH="$TARGET_DIR/$FILE_NAME"

echo "------------------------------------" > "$FULL_PATH"
echo "OLA, O SEU SISTEMA FOI COMPROMETIDO!" >> "$FULL_PATH"
echo "" >> "$FULL_PATH"
echo "Isto é uma prova de conceito para o lab HackInSDN." >> "$FULL_PATH"
echo "O seu serviço Samba estava vulnerável ao CVE-2017-7494,  AGORA VOCÊ VAI TER QUE COMER MERDA NA FRENTE DA WEBCAM PRA RECUPERAR SEUS ARQUIVOS HAHAHAHA." >> "$FULL_PATH"
echo "------------------------------------"


chmod 777 "$FULL_PATH"