# Pergunta pelo endereço IP da VPS
read -p "Digite o endereço IP da sua VPS: " ip_vps

# Pergunta pela porta da VPS
while true; do
  read -p "Digite a porta que deseja usar para a Evolution API: " porta_vps
  if [[ "$porta_vps" =~ ^[0-9]+$ ]]; then
    # Verifica se a porta já está em uso
    netstat -tuln | grep ":$porta_vps" > /dev/null
    if [ $? -eq 0 ]; then
      echo "A porta $porta_vps já está em uso. Por favor, escolha outra porta."
    else
      break
    fi
  else
    echo "Por favor, digite um número de porta válido."
  fi
done

# Continuar com o download e configuração da Evolution API
echo "Baixando Evolution API..."

# Navega até o diretório onde você deseja clonar o repositório
cd ~

# Clona o repositório
git clone https://github.com/EvolutionAPI/evolution-api.git

# Navega até o diretório da Evolution API
cd ~/evolution-api/src

cd evolution-api

#git branch -a

#git checkout develop

# Edita o arquivo dev-env.yml para configurar a porta e URL corretamente
sed -i "s/PORT: 8080/PORT: $porta_vps/" dev-env.yml
sed -i "s/URL: localhost/URL: http:\/\/$ip_vps:$porta_vps/" dev-env.yml

# Renomeia o arquivo dev-env.yml para env.yml
mv dev-env.yml env.yml

echo "Arquivo dev-env.yml renomeado para env.yml com sucesso."

# Volta para o diretório principal
cd ~/evolution-api

# Instalação e configuração do Evolution API
echo "Instalando pacotes..."
npm install

# Iniciar o PM2 para gerenciar o servidor
echo "Iniciando o PM2..."
pm2 start 'npm run start:prod' --name ApiEvolution

# Configurar PM2 para iniciar na inicialização do sistema
pm2 startup

pm2 save

# Salvar a configuração do PM2
pm2 save --force

pm2 save

echo "Evolution API instalado e configurado com sucesso."

exit 0
