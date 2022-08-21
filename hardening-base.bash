##!/bin/bash
#Script que faz a configuração base de um debian11

#instalação de pacotes básicos
apt install initscripts lsb-base systemd git
apt install -y nfs-common sudo dirmngr

#instalação de pacotes de segurança e anti-rootkit
apt install -y rkhunter chkrootkit unhide debsecan

#inlusao de usuario no SUDOERS
echo "danyelmnr ALL=(ALL) ALL" >> /etc/sudoers

#configuração de firewall com UFW
apt install ufw
ufw default deny incoming
ufw default allow outgoing
ufw allow 4140/tcp
ufw allow 123/udp
ufw allow 53/udp
ufw enable

#limite de sessão de usuário
echo "export TMOUT=300" >> /etc/profile
echo "export TMOUT=300" >> /root/.bashrc
echo "export TMOUT=300" >> /etc/skel/.bashrc

#CONFIGURAÇÕES SSH
#realiza backup de conf do arquivo sshd_config
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.old
# Definindo porta SSH
sed -i 's/^#\(Port\).*/\1 4140/' /etc/ssh/sshd_config;
echo 'Protocol 2' >> /etc/ssh/sshd_config
#ativação de Banner em sessão SSH
banner_path='/etc/issue.net'
sed -i 's/^#\(Banner\).*/\1 ${banner_path}/' /etc/ssh/sshd_config;
#ativação de log de SSH
sed -i 's/^#\(SyslogFacility\).*/\1 AUTH/' /etc/ssh/sshd_config;
sed -i 's/^#\(LogLevel\).*/\1 INFO/' /etc/ssh/sshd_config;
#configuração de parâmetros importantes para segurança do SSH
sed -i 's/^#\(PermitRootLogin\).*/\1 no/' /etc/ssh/sshd_config;
sed -i 's/^#\(MaxSessions\).*/\1 2/' /etc/ssh/sshd_config;
sed -i 's/^#\(PermitEmptyPasswords\).*/\1 no/' /etc/ssh/sshd_config;
#desativa o login via senha, deixando apenas via chaves assimétricas
#sed -i 's/^#\(PasswordAuthentication\).*/\1 no/' /etc/ssh/sshd_config
#Configuração do Banner do sistema
echo -e '\nWelcome! \n\nSession started successfully. Everything done in the system will be logged. \n\nContact: danyel.mendes@ifsertao-pe.edu.br\n' > /etc/issue.net
systemctl restart ssh

#remoção de kernels não utilizados, atualização do sistema e limpeza de pacotes não usados
dpkg -l | egrep 'linux-image-[0-9\.-]*-amd64' | awk '{print $2}' | grep -v $(uname -r) | xargs apt purge -y
apt update
apt dist-upgrade -y
apt clean
apt autoremove

#instalação de cliente NTP
apt install chrony
service chrony restart

#bash colorido para usuários
mkdir /etc/skel/.bashrc
echo "export LS_OPTIONS='--color=auto'" >> /etc/skel/.bashrc
echo "PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[01;34m\]@\[\033[01;31m\]\h\[\033[00m\]:\[\033[01;37m\]\w\[\033[01;32m\]\$\[\033[00m\] '" >> /etc/skel/.bashrc

#criação de pasta de diretório de  scripts
cd /
mkdir /scripts