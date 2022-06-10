#!/bin/bash


echo -e "========================================================================================================="
echo -e "\e[92m 1 ： [只安装NC与工具依赖库] \e[0m"
echo -e "\e[92m 2 ： [只安装环境依赖库] \e[0m"
echo -e "\e[92m 3 ： [只安装渗透测试工具] \e[0m"
echo -e "\e[92m 4 ： [只安装子域名扫描工具] \e[0m"
echo -e "\e[92m 5 ： [全部安装]"
echo -e "========================================================================================================="



# 渗透的VPS可能换的比较勤,脚本的作用就是将平时经常会用到的一些系统 "依赖库" , "各类语言执行环境(python2/3 + Golang + JDK)" 和 一些"小工具" 进行自动安装配置,避免重复劳动

# 判断当前用户权限（ -ne 0 结果不是正确的返回root权限执行   否则执行后面命令 ）
if [ `id -u` -ne 0 ];then                                                       
    echo -e "\n\033[33m请以 root 权限 运行该脚本! \033[0m\n" 
    exit
fi





read -n1  -p "  请输入对应参数 ：" fk 
case $fk in
    1 )
        echo -e "\n\e\033[5;33m 已开始安装,请稍后... \e\033[0m"   
        ################安装工具依赖库################
echo -e "========================================================================================================="
echo -e "\e[92m 系统正在进行初始配置,请稍后... \e[0m"             

apt-get update >/dev/null 2>&1 && apt-get upgrade >/dev/null 2>&1 && sleep 2
if [ $? -eq 0 ] ;then
    apt-get install gcc gdb make gedit tmux  -y >/dev/null 2>&1 && sleep 2
    echo -e "\e[94m 常用基础工具及相关依赖库已安装 20%  ! ٩（●ᴗ●）۶ \e[0m"
    if [ $? -eq 0 ] ;then 
        apt-get install python docker.io proxychains proxychains4  -y >/dev/null 2>&1 && sleep 5 
        echo -e "\e[94m 常用基础工具及相关依赖库已安装 40%  ! ٩（●ᴗ●）۶ \e[0m"
        if [ $? -eq 0 ] ;then
            apt-get install cmake socat telnet tree tcpdump iptraf iftop  -y >/dev/null 2>&1 && sleep 2
            echo -e "\e[94m 常用基础工具及相关依赖库已安装 75%  ! ٩（●ᴗ●）۶ \e[0m"
            if [ $? -eq 0 ] ;then 
                apt-get install nethogs lrzsz git unzip p7zip-full curl wget vim openssl libssl-dev libssh2-1-dev -y >/dev/null 2>&1 && sleep 2
                if [ $? -eq 0 ] ;then
                    echo -e "\e[94m 常用基础工具及相关依赖库安装已完成 ! ٩（●ᴗ●）۶ \e[0m"
                    sleep 5 && cd
                    echo -e "========================================================================================================="
                else
                    echo -e "基础工具及常用依赖库安装失败,请检查后重试 !"
                    exit
                fi
            else
                echo -e "基础工具及常用依赖库安装失败,请检查后重试 !"
                exit
            fi
        else
            echo -e "基础工具及常用依赖库安装失败,请检查后重试 !"
            exit
        fi
    else
        echo -e "基础工具及常用依赖库安装失败,请检查后重试 !"
        exit
    fi
else
    echo -e "基础工具及常用依赖库安装失败,请检查后重试 !"
    exit
fi
echo -e "\e[31m######################################################################################################### \e[0m"  && sleep 2      



################安装配置NC################
echo -e "========================================================================================================="
echo -e "\e[92m 安装配置NC 请稍后... \e[0m"  && sleep 2           

which "add-apt-repository" > /dev/null
if [ $? -eq 0 ];then
    add-apt-repository universe >/dev/null 2>&1
    if [ $? -eq 0 ];then
        apt-get install netcat-traditional -y >/dev/null 2>&1
        if [ $? -eq 0 ];then
            echo -e "\e[94m Nc 安装成功! \e[0m"
            update-alternatives --set nc /bin/nc.traditional >/dev/null 2>&1
            if [ $? -eq 0 ];then
                echo -e "\e[94m Nc 配置成功! \e[0m"
                sleep 5 && cd
                echo -e "========================================================================================================="
            else
                echo -e "Nc 配置失败,请检查后重试!"
                exit
            fi
        else
            echo -e "Nc 安装失败,请检查后重试!"
            exit
        fi
    else
        echo -e "PPA 添加失败,请检查后重试!"
        exit
    fi
else
    echo -e "add-apt-repository 命令不存在,请尝试安装后重试!"
    exit
fi
echo -e "\e[31m######################################################################################################### \e[0m"  



################配置ssh服务################
echo -e "========================================================================================================="
echo -e "\e[92m 准备配置SSH服务 请稍后... \e[0m"  && sleep 2            #sleep 2   睡眠2秒

apt-get install openssh-server -y  >/dev/null 2>&1
if [ $? -eq 0 ] ;then
    echo -e "TCPKeepAlive yes\nAllowTcpForwarding yes\nGatewayPorts yes" >> /etc/ssh/sshd_config && systemctl restart sshd.service
    if [ $? -eq 0 ] ;then
        echo -e "\e[94m SSH 服务配置已完成 ! \e[0m"
        sleep 5 && cd
        echo -e "========================================================================================================="
    else
        echo -e "SSH安装配置失败,请检查后重试 !"
        exit
    fi
fi
echo -e "\e[31m######################################################################################################### \e[0m"    



################设置命令变量################
# 注,此处的环境变量可按自己的日常操作习惯随意增加
echo -e "========================================================================================================="
echo -e "\e[92m 准备配置当前用户环境变量 请稍后... \e[0m" && sleep 2            #sleep 2   睡眠2秒

echo -e "vi='vim'\npg='ping www.google.com -c 5'\xzg='git clone'\ngrep='grep --color=auto'\n" >> ~/.bashrc && source ~/.bashrc
if [ $? -eq 0 ] ;then
    echo -e "\e[94m 当前用户环境变量配置已完成 ! \e[0m"
    sleep 5 && cd
    echo -e "========================================================================================================="
else
    echo -e "当前用户环境变量配置失败,请检查后重试 !"
    exit
fi
echo -e "\e[31m#########################################################################################################\e[0m"  



# 注,此处的VI编辑配置可按自己的日常操作习惯随意增加
echo -e "========================================================================================================="
echo -e "\e[92m 准备配置当前用户 VI 编辑器 请稍后... \e[0m" && sleep 2
cat << \EOF > ~/.vimrc
set nu              " 显示行号
syntax on           " 语法高亮  
autocmd InsertLeave * se nocul  " 用浅色高亮当前行  
autocmd InsertEnter * se cul    " 用浅色高亮当前行  
set ruler           " 显示标尺  
set showcmd         " 输入的命令显示出来，看的清楚些
set nocompatible
set fencs=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936
set fileencoding=utf-8
EOF
if [ $? -eq 0 ] ;then
    echo -e "\e[94m VI 配置已完成! \e[0m"
    sleep 5 && cd
    echo -e "========================================================================================================="
fi
echo -e "\e[31m######################################################################################################### \e[0m"  



################开启系统路由转发################
echo -e "========================================================================================================="
echo -e "\e[92m 准备开启系统路由转发 请稍后... \e[0m"  && sleep 2            #sleep 2   睡眠2秒
echo 1 > /proc/sys/net/ipv4/ip_forward
if [ $? -eq 0 ] ;then
    sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf && sysctl -p >/dev/null 2>&1
    if [ $? -eq 0 ] ;then
        echo -e "\e[94m 系统路由转发已开启 ! \e[0m"
        sleep 5 && cd
        echo -e "========================================================================================================="
    else
        echo -e "路由转发开启失败,请检查后重试 !"
        exit
    fi
fi
echo -e "\e[31m######################################################################################################### \e[0m" &&  sleep 5 
# 清除所有操作记录,方便日后快速排查问题
history -c –w && > .bash_history && cat /dev/null > /var/log/wtmp && cat /dev/null > /var/log/btmp && cat /dev/null > /var/log/lastlog && cat /dev/null > /var/log/auth.log
if [ $? -eq 0 ] ;then
    echo -e "\e[92m基础 VPS 环境现已全部部署完毕,玩的愉快 !  \e[0m\n" && sleep 2 && cd
fi 

    ;;

    2 )
            echo -e "\n\e\033[5;33m 已开始安装,请稍后... \e\033[0m" 
         ################安装配置 JAVA11 + Python 2.7 + Python 3.8 + Golang 1.14.2 ################
echo -e "========================================================================================================="
echo -e "\e[92m 开始编译安装各种常用语言环境 [ JAVA11 + Python 2.7 + Python 3.8 + Golang 1.14.2 ] 请耐心等待... \e[0m" 
echo -e "========================================================================================================="

echo -e "\e[94m 准备安装配置JAVA11环境 耗时可能较长,请耐心等待... \e[0m"  && sleep 2
apt install openjdk-11-jre-headless -y >/dev/null 2>&1 
if [ $? -eq 0 ] ;then
    echo -e "\e[36m JAVA11 安装配置已完成 ! \e[0m"
            sleep 5 && cd 
            echo -e "========================================================================================================="
        else
            echo -e "JAVA11安装失败,请检查后重试 !"
    exit
fixit
fi



################安装Python 2.7 + Pip2.7################
echo -e "\e[94m 准备安装Python 2.7 + Pip2.7 请稍后... \e[0m" && sleep 2
apt-get install python2.7 python2.7-dev -y >/dev/null 2>&1 
if [ $? -eq 0 ] ;then
    echo -e "\e[36m Python 2.7环境下载完成,准备编译安装 \e[0m"
    curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py >/dev/null 2>&1 && python2.7 get-pip.py >/dev/null 2>&1
    if [ $? -eq 0 ] ;then
        echo -e "\e[36m pytthon2.7编译完成需要安装pip2.7 \e[0m"
        python2.7 -m pip install --upgrade pip >/dev/null 2>&1 && pip2.7 install setuptools >/dev/null 2>&1 && pip2.7  install requests >/dev/null 2>&1 && pip2.7 install urllib3 >/dev/null 2>&1
        if [ $? -eq 0 ] ;then
            echo -e "\e[37m Python 2.7 + Pip2.7 已安装成功 ! \e[0m"
            sleep 5 && cd && rm -rf *.py
            echo -e "========================================================================================================="
        else
            echo -e "Python 2.7环境下载失败 !"
            exit
        fi
    else
        echo -e "Python 2.7环境编译失败 !"
        exit
     fi
else
    echo -e "Python 2.7安装失败 !"
    exit
fi

                

################编译安装Python3.8 + Pip3.8################
echo -e "\e[94m 准备安装Python3.8 + Pip3.8 请稍后... \e[0m" && sleep 2 
apt-get install build-essential libncursesw5-dev libgdbm-dev libc6-dev zlib1g-dev libsqlite3-dev tk-dev openssl libffi-dev -y >/dev/null 2>&1
if [ $? -eq 0 ] ;then
    echo -e "\e[36m 开始下载Python-3.8.3.tar.xz ! \e[0m" && sleep 1
    wget https://www.python.org/ftp/python/3.8.3/Python-3.8.3.tar.xz >/dev/null 2>&1
    if [ $? -eq 0 ] ;then
        echo -e "\e[36m Python-3.8.3.tar.xz下载完成,准备编译安装,耗时较长,请耐心等待... \e[0m"
        tar xf Python-3.8.3.tar.xz && cd Python-3.8.3/ && ./configure --enable-optimizations >/dev/null 2>&1 && make>/dev/null 2>&1 && make install >/dev/null 2>&1
        if [ $? -eq 0 ] ;then
            echo -e "\e[37m Python-3.8.3 已编译安装成功 ! \e[0m" && sleep 1
            python3.8 -m pip install --upgrade pip >/dev/null 2>&1
            if [ $? -eq 0 ] ;then
                pip3.8 install wheel >/dev/null 2>&1 && pip3.8 install setuptools >/dev/null 2>&1 && pip3.8 install requests >/dev/null 2>&1
                if [ $? -eq 0 ] ;then
                    echo -e "\e[37m 常用Py3依赖安装成功 ! \e[0m"
                    sleep 5 && cd && rm -fr Python-3.8.*
                    echo -e "========================================================================================================="
                else
                    echo -e "常用Py3依赖失败 !"
                    exit
                fi
            else
                echo -e "Pip3.8 安装失败 !"
                exit
            fi
        else
            echo -e "Python 3.8.3 编译安装失败 !"
            exit
        fi
    else
        echo -e "Python-3.8.3.tar.xz 下载失败 !"
        exit
    fi
else
    echo -e "常用Py3依赖 安装失败 !"
    exit
fi



################安装配置Golang 1.18.3################
echo -e "\e[94m 准备安装配置Golang 1.14.2 请稍后... \e[0m" && sleep 2

wget https://go.dev/dl/go1.18.3.linux-amd64.tar.gz >/dev/null 2>&1
if [ $? -eq 0 ] ;then
    echo -e "\e[36m go1.14.2.linux-amd64.tar.gz下载完成 ! \e[0m" 
    tar xf go1.18.3.linux-amd64.tar.gz && mv go /usr/local
    if [ $? -eq 0 ] ;then
        echo -e "export GOROOT=/usr/local/go\nexport GOPATH=~/work\nexport GOBIN=\$GOROOT/bin\nexport PATH=\$PATH:\$GOROOT/bin:\$GOBIN" >> /etc/profile && source /etc/profile
        if [ $? -eq 0 ] ;then
            go version >/dev/null 2>&1 && go env >/dev/null 2>&1
            if [ $? -eq 0 ] ;then
                echo -e "\e[37m Golang 1.14.2 已安装配置成功 ! \e[0m"
                sleep 5 && cd && rm -fr go*
                echo -e "========================================================================================================="
            else
                echo -e "Golang 1.18.3 安装配置失败 !"
                exit
            fi
        fi
    fi
fi
echo -e "\e[31m######################################################################################################### \e[0m"  && sleep 5
# 清除所有操作记录,方便日后快速排查问题
history -c –w && > .bash_history && cat /dev/null > /var/log/wtmp && cat /dev/null > /var/log/btmp && cat /dev/null > /var/log/lastlog && cat /dev/null > /var/log/auth.log
if [ $? -eq 0 ] ;then
    echo -e "\e[92m基础 VPS 环境现已全部部署完毕,玩的愉快 !  \e[0m\n" && sleep 2 && cd
fi

    ;;

    3 )
        echo -e "\n\e\033[5;33m 已开始安装,请稍后... \e\033[0m" 
        ################安装配置 Metasploit + sqlmap + nmap + masscan + medusa + hydra + wafw00f ################
echo -e "========================================================================================================="
echo -e "\e[92m 开始编译安装各种常用工具 [ Metasploit + sqlmap + masscan + nmap  + medusa + hydra + wafw00f] 请耐心等待... \e[0m" 
echo -e "========================================================================================================="

echo -e "\e[94m 准备下载Metasploit ! \e[0m" && sleep 2
wget https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb >/dev/null 2>&1 && sleep 2
if [ $? -eq 0 ] ;then
    echo -e "\e[36m Metasploit下载完成 准备编译请稍后... ! \e[0m" && sleep 2
    mv msfupdate.erb msfinstall && chmod +x msfinstall && ./msfinstall >/dev/null 2>&1 && sleep 2
    if [ $? -eq 0 ] ;then
        echo -e "\e[36m Metasploit已经安装完成 ! \e[0m\n" && sleep 2
        echo -e "\e[94m 准备安装sqlmap 请稍后... \e[0m" && sleep 2
        apt-get install sqlmap nmap masscan medusa hydra wafw00f -y >/dev/null 2>&1 && sleep 2
        if [ $? -eq 0 ] ;then
            sqlmap -h >/dev/null 2>&1
            echo -e "\e[36m sqlmap 已经安装完成 ! \e[0m\n" && sleep 2
            echo -e "\e[94m nmap 准备安装 ! \e[0m"
            if [ $? -eq 0 ] ;then
                nmap -h >/dev/null 2>&1
                echo -e "\e[36m nmao 已经安装完成 ! \e[0m\n" && sleep 2
                echo -e "\e[94m masscan 准备安装 ! \e[0m"
                if [ $? -eq 0 ] ;then
                    masscan -h >/dev/null 2>&1
                    echo -e "\e[36m masscan 已经安装完成 ! \e[0m\n" && sleep 2
                    echo -e "\e[94m medusa 准备安装 ! \e[0m"
                    if [ $? -eq 0 ] ;then
                        medusa -h >/dev/null 2>&1
                        echo -e "\e[36m medusa 已经安装完成 ! \e[0m\n" && sleep 2
                        echo -e "\e[94m hydra 准备安装 ! \e[0m"
                        if [ $? -eq 0 ] ;then
                            hydra -h >/dev/null 2>&1
                            echo -e "\e[36m hydra 已经安装完成 ! \e[0m\n" && sleep 2
                            echo -e "\e[94m wafw00f 准备安装 ! \e[0m"
                            if [ $? -eq 0 ] ;then
                                wafw00f -h >/dev/null 2>&1
                                echo -e "\e[36m wafw00f 已经安装完成 ! \e[0m" && sleep 2
                                echo -e "========================================================================================================="
                            else
                                echo -e "Metasploit 下载失败 !"
                                exit
                            fi
                        else
                            echo -e "Metasploit 安装失败 !"
                            exit
                        fi
                    else
                        echo -e "sqlmap 安装失败 !"
                        exit
                    fi
                else
                    echo -e "nmap 安装失败 !"
                    exit
                fi
            else
                echo -e "masscan 安装失败 !"
                exit
            fi
        else
            echo -e "medusa 安装失败 !"
            exit
        fi
    else
        echo -e "hydra 安装失败 !"
        exit
    fi
else
    echo -e "wafw00f 安装失败 !"
    exit
fi
echo -e "=========================================================================================================\n" sleep 2

echo -e "\e[31m######################################################################################################### \e[0m"  && sleep 5
# 清除所有操作记录,方便日后快速排查问题
history -c –w && > .bash_history && cat /dev/null > /var/log/wtmp && cat /dev/null > /var/log/btmp && cat /dev/null > /var/log/lastlog && cat /dev/null > /var/log/auth.log
if [ $? -eq 0 ] ;then
    echo -e "\e[92m基础 VPS 环境现已全部部署完毕,玩的愉快 !  \e[0m\n" && sleep 2 && cd
fi

    ;; 

    4 )
        echo -e "\n\e\033[5;33m 已开始安装,请稍后... \e\033[0m" 
################安装配置 OneForAll + Sublist3r + theHarvester + Starmap ################
echo -e "========================================================================================================="
echo -e "\e[92m 开始编译安装各种常用工具 [ OneForAll + Sublist3r + Starmap + theHarvester + Starmap ] 请耐心等待... \e[0m" 
echo -e "========================================================================================================="

cd /opt && mkdir vps-gj && cd vps-gj && mkdir xxsj-01 && cd  xxsj-01  && sleep 2

################ OneForAll + Sublist3r + Starmap + theHarvester ################
echo -e "\e[94m 开始安装子域名工具 请稍后... ! \e[0m\n" && sleep 2
git clone --recursive https://github.com/shmilylty/OneForAll.git >/dev/null 2>&1
if [ $? -eq 0 ] ;then
    echo -e "\e[36m OneForAll 已经下载完成 ! \e[0m" && sleep 2
    cd OneForAll/ &&  python3 -m pip install -U pip setuptools wheel -i https://mirrors.aliyun.com/pypi/simple/ >/dev/null 2>&1 && pip3 install -r requirements.txt -i https://mirrors.aliyun.com/pypi/simple/ >/dev/null 2>&1
    echo q | python3 oneforall.py -h >/dev/null 2>&1 && cd ../
    if [ $? -eq 0 ] ;then
        echo -e "\e[37m OneForAll 已安装成功 ! \e[0m\n"
        git clone --recursive https://github.com/aboul3la/Sublist3r.git >/dev/null 2>&1
        if [ $? -eq 0 ] ;then
            echo -e "\e[36m Sublist3r 已经下载完成 ! \e[0m" && sleep 2 
            cd Sublist3r/ &&  pip2.7 install -r requirements.txt >/dev/null 2>&1 && python sublist3r.py -h >/dev/null 2>&1 && cd ../
            if [ $? -eq 0 ] ;then
                echo -e "\e[37m Sublist3r 已安装成功 ! \e[0m\n"  
                wget https://github.com/ZhuriLab/Starmap/releases/download/v0.0.9/Starmap-linux >/dev/null 2>&1 && chmod +x Starmap-linux && mv Starmap-linux Starmap
                if [ $? -eq 0 ] ;then
                    echo -e "\e[36m Starmap 已经下载完成 ! \e[0m" && sleep 2
                    ./Starmap -h >/dev/null 2>&1
                    if [ $? -eq 0 ] ;then
                        echo -e "\e[37m Starmap 已安装成功 ! \e[0m\n" 
                        git clone --recursive https://github.com/laramies/theHarvester.git >/dev/null 2>&1
                        if [ $? -eq 0 ] ;then
                            echo -e "\e[36m theHarvester 已经下载完成 ! \e[0m" && sleep 2
                            cd theHarvester && python3 -m pip install -r requirements/base.txt >/dev/null 2>&1 && python3 theHarvester.py -h  >/dev/null 2>&1
                            if [ $? -eq 0 ] ;then
                                echo -e "\e[37m theHarvester 已安装成功 ! \e[0m" && cd ../
                                echo -e "========================================================================================================="
                            else
                                echo -e "OneForAll 下载失败 !"
                                exit
                            fi
                        else
                            echo -e "OneForAll 安装失败 !"
                            exit
                        fi
                    else
                        echo -e "Sublist3r 下载失败 !"
                        exit
                    fi
                else
                    echo -e "Sublist3r 安装失败 !"
                    exit
                fi
            else
                echo -e "Starmap 下载失败 !"
                exit
            fi
        else
            echo -e "Starmap 安装失败 !"
            exit
        fi
    else
        echo -e "theHarvester 下载失败 !"
        exit
    fi
else
    echo -e "theHarvester 安装失败 !"
    exit
fi



# 清除所有操作记录,方便日后快速排查问题
history -c –w && > .bash_history && cat /dev/null > /var/log/wtmp && cat /dev/null > /var/log/btmp && cat /dev/null > /var/log/lastlog && cat /dev/null > /var/log/auth.log
if [ $? -eq 0 ] ;then
    echo -e "\e[92m基础 VPS 环境现已全部部署完毕,玩的愉快 !  \e[0m\n" && sleep 2 && cd
fi

;; 








    5 )
        echo -e "\n\e\033[5;33m 已开始安装,请稍后... \e\033[0m" 
        ################安装工具依赖库################
echo -e "========================================================================================================="
echo -e "\e[92m 系统正在进行初始配置,请稍后... \e[0m"             

apt-get update >/dev/null 2>&1 && apt-get upgrade >/dev/null 2>&1 && sleep 2
if [ $? -eq 0 ] ;then
    apt-get install gcc gdb make gedit tmux  -y >/dev/null 2>&1 && sleep 2
    echo -e "\e[94m 常用基础工具及相关依赖库已安装 20%  ! ٩（●ᴗ●）۶ \e[0m"
    if [ $? -eq 0 ] ;then 
        apt-get install python docker.io proxychains proxychains4  -y >/dev/null 2>&1 && sleep 5 
        echo -e "\e[94m 常用基础工具及相关依赖库已安装 40%  ! ٩（●ᴗ●）۶ \e[0m"
        if [ $? -eq 0 ] ;then
            apt-get install cmake socat telnet tree tcpdump iptraf iftop  -y >/dev/null 2>&1 && sleep 2
            echo -e "\e[94m 常用基础工具及相关依赖库已安装 75%  ! ٩（●ᴗ●）۶ \e[0m"
            if [ $? -eq 0 ] ;then 
                apt-get install nethogs lrzsz git unzip p7zip-full curl wget vim openssl libssl-dev libssh2-1-dev -y >/dev/null 2>&1 && sleep 2
                if [ $? -eq 0 ] ;then
                    echo -e "\e[94m 常用基础工具及相关依赖库安装已完成 ! ٩（●ᴗ●）۶ \e[0m"
                    sleep 5 && cd
                    echo -e "========================================================================================================="
                else
                    echo -e "基础工具及常用依赖库安装失败,请检查后重试 !"
                    exit
                fi
            else
                echo -e "基础工具及常用依赖库安装失败,请检查后重试 !"
                exit
            fi
        else
            echo -e "基础工具及常用依赖库安装失败,请检查后重试 !"
            exit
        fi
    else
        echo -e "基础工具及常用依赖库安装失败,请检查后重试 !"
        exit
    fi
else
    echo -e "基础工具及常用依赖库安装失败,请检查后重试 !"
    exit
fi
echo -e "\e[31m######################################################################################################### \e[0m"  && sleep 2  



################安装配置NC################
echo -e "========================================================================================================="
echo -e "\e[92m 安装配置NC 请稍后... \e[0m"  && sleep 2           

which "add-apt-repository" > /dev/null
if [ $? -eq 0 ];then
    add-apt-repository universe >/dev/null 2>&1
    if [ $? -eq 0 ];then
        apt-get install netcat-traditional -y >/dev/null 2>&1
        if [ $? -eq 0 ];then
            echo -e "\e[94m Nc 安装成功! \e[0m"
            update-alternatives --set nc /bin/nc.traditional >/dev/null 2>&1
            if [ $? -eq 0 ];then
                echo -e "\e[94m Nc 配置成功! \e[0m"
                sleep 5 && cd
                echo -e "========================================================================================================="
            else
                echo -e "Nc 配置失败,请检查后重试!"
                exit
            fi
        else
            echo -e "Nc 安装失败,请检查后重试!"
            exit
        fi
    else
        echo -e "PPA 添加失败,请检查后重试!"
        exit
    fi
else
    echo -e "add-apt-repository 命令不存在,请尝试安装后重试!"
    exit
fi
echo -e "\e[31m######################################################################################################### \e[0m"  



################配置ssh服务################
echo -e "========================================================================================================="
echo -e "\e[92m 准备配置SSH服务 请稍后... \e[0m"  && sleep 2            #sleep 2   睡眠2秒

apt-get install openssh-server -y  >/dev/null 2>&1
if [ $? -eq 0 ] ;then
    echo -e "TCPKeepAlive yes\nAllowTcpForwarding yes\nGatewayPorts yes" >> /etc/ssh/sshd_config && systemctl restart sshd.service
    if [ $? -eq 0 ] ;then
        echo -e "\e[94m SSH 服务配置已完成 ! \e[0m"
        sleep 5 && cd
        echo -e "========================================================================================================="
    else
        echo -e "SSH安装配置失败,请检查后重试 !"
        exit
    fi
fi
echo -e "\e[31m######################################################################################################### \e[0m"    



################设置命令变量################
# 注,此处的环境变量可按自己的日常操作习惯随意增加
echo -e "========================================================================================================="
echo -e "\e[92m 准备配置当前用户环境变量 请稍后... \e[0m" && sleep 2            #sleep 2   睡眠2秒

echo -e "vi='vim'\npg='ping www.google.com -c 5'\xzg='git clone'\ngrep='grep --color=auto'\n" >> ~/.bashrc && source ~/.bashrc
if [ $? -eq 0 ] ;then
    echo -e "\e[94m 当前用户环境变量配置已完成 ! \e[0m"
    sleep 5 && cd
    echo -e "========================================================================================================="
else
    echo -e "当前用户环境变量配置失败,请检查后重试 !"
    exit
fi
echo -e "\e[31m#########################################################################################################\e[0m"  



# 注,此处的VI编辑配置可按自己的日常操作习惯随意增加
echo -e "========================================================================================================="
echo -e "\e[92m 准备配置当前用户 VI 编辑器 请稍后... \e[0m" && sleep 2
cat << \EOF > ~/.vimrc
set nu              " 显示行号
syntax on           " 语法高亮  
autocmd InsertLeave * se nocul  " 用浅色高亮当前行  
autocmd InsertEnter * se cul    " 用浅色高亮当前行  
set ruler           " 显示标尺  
set showcmd         " 输入的命令显示出来，看的清楚些
set nocompatible
set fencs=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936
set fileencoding=utf-8
EOF
if [ $? -eq 0 ] ;then
    echo -e "\e[94m VI 配置已完成! \e[0m"
    sleep 5 && cd
    echo -e "========================================================================================================="
fi
echo -e "\e[31m######################################################################################################### \e[0m"  



################开启系统路由转发################
echo -e "========================================================================================================="
echo -e "\e[92m 准备开启系统路由转发 请稍后... \e[0m"  && sleep 2            #sleep 2   睡眠2秒
echo 1 > /proc/sys/net/ipv4/ip_forward
if [ $? -eq 0 ] ;then
    sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf && sysctl -p >/dev/null 2>&1
    if [ $? -eq 0 ] ;then
        echo -e "\e[94m 系统路由转发已开启 ! \e[0m"
        sleep 5 && cd
        echo -e "========================================================================================================="
    else
        echo -e "路由转发开启失败,请检查后重试 !"
        exit
    fi
fi
echo -e "\e[31m######################################################################################################### \e[0m" &&  sleep 5










################安装配置 JAVA11 + Python 2.7 + Python 3.8 + Golang 1.14.2 ################
echo -e "========================================================================================================="
echo -e "\e[92m 开始编译安装各种常用语言环境 [ JAVA11 + Python 2.7 + Python 3.8 + Golang 1.14.2 ] 请耐心等待... \e[0m" 
echo -e "========================================================================================================="

echo -e "\e[94m 准备安装配置JAVA11环境 耗时可能较长,请耐心等待... \e[0m"  && sleep 2
apt install openjdk-11-jre-headless -y >/dev/null 2>&1 
if [ $? -eq 0 ] ;then
    echo -e "\e[36m JAVA11 安装配置已完成 ! \e[0m"
            sleep 5 && cd 
            echo -e "========================================================================================================="
        else
            echo -e "JAVA11安装失败,请检查后重试 !"
    exit
fixit
fi



################安装Python 2.7 + Pip2.7################
echo -e "\e[94m 准备安装Python 2.7 + Pip2.7 请稍后... \e[0m" && sleep 2
apt-get install python2.7 python2.7-dev -y >/dev/null 2>&1 
if [ $? -eq 0 ] ;then
    echo -e "\e[36m Python 2.7环境下载完成,准备编译安装 \e[0m"
    curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py >/dev/null 2>&1 && python2.7 get-pip.py >/dev/null 2>&1
    if [ $? -eq 0 ] ;then
        echo -e "\e[36m pytthon2.7编译完成需要安装pip2.7 \e[0m"
        python2.7 -m pip install --upgrade pip >/dev/null 2>&1 && pip2.7 install setuptools >/dev/null 2>&1 && pip2.7  install requests >/dev/null 2>&1 && pip2.7 install urllib3 >/dev/null 2>&1
        if [ $? -eq 0 ] ;then
            echo -e "\e[37m Python 2.7 + Pip2.7 已安装成功 ! \e[0m"
            sleep 5 && cd && rm -rf *.py
            echo -e "========================================================================================================="
        else
            echo -e "Python 2.7环境下载失败 !"
            exit
        fi
    else
        echo -e "Python 2.7环境编译失败 !"
        exit
     fi
else
    echo -e "Python 2.7安装失败 !"
    exit
fi

                

################编译安装Python3.8 + Pip3.8################
echo -e "\e[94m 准备安装Python3.8 + Pip3.8 请稍后... \e[0m" && sleep 2 
apt-get install build-essential libncursesw5-dev libgdbm-dev libc6-dev zlib1g-dev libsqlite3-dev tk-dev openssl libffi-dev -y >/dev/null 2>&1
if [ $? -eq 0 ] ;then
    echo -e "\e[36m 开始下载Python-3.8.3.tar.xz ! \e[0m" && sleep 1
    wget https://www.python.org/ftp/python/3.8.3/Python-3.8.3.tar.xz >/dev/null 2>&1
    if [ $? -eq 0 ] ;then
        echo -e "\e[36m Python-3.8.3.tar.xz下载完成,准备编译安装,耗时较长,请耐心等待... \e[0m"
        tar xf Python-3.8.3.tar.xz && cd Python-3.8.3/ && ./configure --enable-optimizations >/dev/null 2>&1 && make>/dev/null 2>&1 && make install >/dev/null 2>&1
        if [ $? -eq 0 ] ;then
            echo -e "\e[37m Python-3.8.3 已编译安装成功 ! \e[0m" && sleep 1
            python3.8 -m pip install --upgrade pip >/dev/null 2>&1
            if [ $? -eq 0 ] ;then
                pip3.8 install wheel >/dev/null 2>&1 && pip3.8 install setuptools >/dev/null 2>&1 && pip3.8 install requests >/dev/null 2>&1
                if [ $? -eq 0 ] ;then
                    echo -e "\e[37m 常用Py3依赖安装成功 ! \e[0m"
                    sleep 5 && cd && rm -fr Python-3.8.*
                    echo -e "========================================================================================================="
                else
                    echo -e "常用Py3依赖失败 !"
                    exit
                fi
            else
                echo -e "Pip3.8 安装失败 !"
                exit
            fi
        else
            echo -e "Python 3.8.3 编译安装失败 !"
            exit
        fi
    else
        echo -e "Python-3.8.3.tar.xz 下载失败 !"
        exit
    fi
else
    echo -e "常用Py3依赖 安装失败 !"
    exit
fi



################安装配置Golang 1.18.3################
echo -e "\e[94m 准备安装配置Golang 1.14.2 请稍后... \e[0m" && sleep 2

wget https://go.dev/dl/go1.18.3.linux-amd64.tar.gz >/dev/null 2>&1
if [ $? -eq 0 ] ;then
    echo -e "\e[36m go1.14.2.linux-amd64.tar.gz下载完成 ! \e[0m" 
    tar xf go1.18.3.linux-amd64.tar.gz && mv go /usr/local
    if [ $? -eq 0 ] ;then
        echo -e "export GOROOT=/usr/local/go\nexport GOPATH=~/work\nexport GOBIN=\$GOROOT/bin\nexport PATH=\$PATH:\$GOROOT/bin:\$GOBIN" >> /etc/profile && source /etc/profile
        if [ $? -eq 0 ] ;then
            go version >/dev/null 2>&1 && go env >/dev/null 2>&1
            if [ $? -eq 0 ] ;then
                echo -e "\e[37m Golang 1.14.2 已安装配置成功 ! \e[0m"
                sleep 5 && cd && rm -fr go*
                echo -e "========================================================================================================="
            else
                echo -e "Golang 1.18.3 安装配置失败 !"
                exit
            fi
        fi
    fi
fi
echo -e "\e[31m######################################################################################################### \e[0m"  && sleep 5










################安装配置 Metasploit + sqlmap + nmap + masscan + medusa + hydra + wafw00f ################
echo -e "========================================================================================================="
echo -e "\e[92m 开始编译安装各种常用工具 [ Metasploit + sqlmap + masscan + nmap  + medusa + hydra + wafw00f] 请耐心等待... \e[0m" 
echo -e "========================================================================================================="

echo -e "\e[94m 准备下载Metasploit ! \e[0m" && sleep 2
wget https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb >/dev/null 2>&1 && sleep 2
if [ $? -eq 0 ] ;then
    echo -e "\e[36m Metasploit下载完成 准备编译请稍后... ! \e[0m" && sleep 2
    mv msfupdate.erb msfinstall && chmod +x msfinstall && ./msfinstall >/dev/null 2>&1 && sleep 2
    if [ $? -eq 0 ] ;then
        echo -e "\e[36m Metasploit已经安装完成 ! \e[0m\n" && sleep 2
        echo -e "\e[94m 准备安装sqlmap 请稍后... \e[0m" && sleep 2
        apt-get install sqlmap nmap masscan medusa hydra wafw00f -y >/dev/null 2>&1 && sleep 2
        if [ $? -eq 0 ] ;then
            sqlmap -h >/dev/null 2>&1
            echo -e "\e[36m sqlmap 已经安装完成 ! \e[0m\n" && sleep 2
            echo -e "\e[94m nmap 准备安装 ! \e[0m"
            if [ $? -eq 0 ] ;then
                nmap -h >/dev/null 2>&1
                echo -e "\e[36m nmao 已经安装完成 ! \e[0m\n" && sleep 2
                echo -e "\e[94m masscan 准备安装 ! \e[0m"
                if [ $? -eq 0 ] ;then
                    masscan -h >/dev/null 2>&1
                    echo -e "\e[36m masscan 已经安装完成 ! \e[0m\n" && sleep 2
                    echo -e "\e[94m medusa 准备安装 ! \e[0m"
                    if [ $? -eq 0 ] ;then
                        medusa -h >/dev/null 2>&1
                        echo -e "\e[36m medusa 已经安装完成 ! \e[0m\n" && sleep 2
                        echo -e "\e[94m hydra 准备安装 ! \e[0m"
                        if [ $? -eq 0 ] ;then
                            hydra -h >/dev/null 2>&1
                            echo -e "\e[36m hydra 已经安装完成 ! \e[0m\n" && sleep 2
                            echo -e "\e[94m wafw00f 准备安装 ! \e[0m"
                            if [ $? -eq 0 ] ;then
                                wafw00f -h >/dev/null 2>&1
                                echo -e "\e[36m wafw00f 已经安装完成 ! \e[0m" && sleep 2
                                echo -e "========================================================================================================="
                            else
                                echo -e "Metasploit 下载失败 !"
                                exit
                            fi
                        else
                            echo -e "Metasploit 安装失败 !"
                            exit
                        fi
                    else
                        echo -e "sqlmap 安装失败 !"
                        exit
                    fi
                else
                    echo -e "nmap 安装失败 !"
                    exit
                fi
            else
                echo -e "masscan 安装失败 !"
                exit
            fi
        else
            echo -e "medusa 安装失败 !"
            exit
        fi
    else
        echo -e "hydra 安装失败 !"
        exit
    fi
else
    echo -e "wafw00f 安装失败 !"
    exit
fi

echo -e "\e[31m######################################################################################################### \e[0m"  && sleep 5












################安装配置 OneForAll + Sublist3r + theHarvester + Starmap ################
echo -e "========================================================================================================="
echo -e "\e[92m 开始编译安装各种常用工具 [ OneForAll + Sublist3r + Starmap + theHarvester + Starmap ] 请耐心等待... \e[0m" 
echo -e "========================================================================================================="

cd /opt && mkdir vps-gj && cd vps-gj && mkdir xxsj-01 && cd  xxsj-01  && sleep 2

################ OneForAll + Sublist3r + Starmap + theHarvester ################
echo -e "\e[94m 开始安装子域名工具 请稍后... ! \e[0m\n" && sleep 2
git clone --recursive https://github.com/shmilylty/OneForAll.git >/dev/null 2>&1
if [ $? -eq 0 ] ;then
    echo -e "\e[36m OneForAll 已经下载完成 ! \e[0m" && sleep 2
    cd OneForAll/ &&  python3 -m pip install -U pip setuptools wheel -i https://mirrors.aliyun.com/pypi/simple/ >/dev/null 2>&1 && pip3 install -r requirements.txt -i https://mirrors.aliyun.com/pypi/simple/ >/dev/null 2>&1
    echo q | python3 oneforall.py -h >/dev/null 2>&1 && cd ../
    if [ $? -eq 0 ] ;then
        echo -e "\e[37m OneForAll 已安装成功 ! \e[0m\n"
        git clone --recursive https://github.com/aboul3la/Sublist3r.git >/dev/null 2>&1
        if [ $? -eq 0 ] ;then
            echo -e "\e[36m Sublist3r 已经下载完成 ! \e[0m" && sleep 2 
            cd Sublist3r/ &&  pip2.7 install -r requirements.txt >/dev/null 2>&1 && python sublist3r.py -h >/dev/null 2>&1 && cd ../
            if [ $? -eq 0 ] ;then
                echo -e "\e[37m Sublist3r 已安装成功 ! \e[0m\n"  
                wget https://github.com/ZhuriLab/Starmap/releases/download/v0.0.9/Starmap-linux >/dev/null 2>&1 && chmod +x Starmap-linux && mv Starmap-linux Starmap
                if [ $? -eq 0 ] ;then
                    echo -e "\e[36m Starmap 已经下载完成 ! \e[0m" && sleep 2
                    ./Starmap -h >/dev/null 2>&1
                    if [ $? -eq 0 ] ;then
                        echo -e "\e[37m Starmap 已安装成功 ! \e[0m\n" 
                        git clone --recursive https://github.com/laramies/theHarvester.git >/dev/null 2>&1
                        if [ $? -eq 0 ] ;then
                            echo -e "\e[36m theHarvester 已经下载完成 ! \e[0m" && sleep 2
                            cd theHarvester && python3 -m pip install -r requirements/base.txt >/dev/null 2>&1 && python3 theHarvester.py -h  >/dev/null 2>&1
                            if [ $? -eq 0 ] ;then
                                echo -e "\e[37m theHarvester 已安装成功 ! \e[0m" && cd ../
                                echo -e "========================================================================================================="
                            else
                                echo -e "OneForAll 下载失败 !"
                                exit
                            fi
                        else
                            echo -e "OneForAll 安装失败 !"
                            exit
                        fi
                    else
                        echo -e "Sublist3r 下载失败 !"
                        exit
                    fi
                else
                    echo -e "Sublist3r 安装失败 !"
                    exit
                fi
            else
                echo -e "Starmap 下载失败 !"
                exit
            fi
        else
            echo -e "Starmap 安装失败 !"
            exit
        fi
    else
        echo -e "theHarvester 下载失败 !"
        exit
    fi
else
    echo -e "theHarvester 安装失败 !"
    exit
fi



# 清除所有操作记录,方便日后快速排查问题
history -c –w && > .bash_history && cat /dev/null > /var/log/wtmp && cat /dev/null > /var/log/btmp && cat /dev/null > /var/log/lastlog && cat /dev/null > /var/log/auth.log
if [ $? -eq 0 ] ;then
    echo -e "\e[92m基础 VPS 环境现已全部部署完毕,玩的愉快 !  \e[0m\n" && sleep 2 && cd
fi

;; 

esac
echo -e "\n\e\033[5;33m٩（●ᴗ●）۶ | ٩（●ᴗ●）۶ | ٩（●ᴗ●）۶ | ٩（●ᴗ●）۶ | ٩（●ᴗ●）۶ | ٩（●ᴗ●）۶ | ٩（●ᴗ●）۶ | ٩（●ᴗ●）۶ | ٩（●ᴗ●）۶ | \e\033[0m\n"  
exit 0












