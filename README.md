# VPS_vps__attack-frame
原项目地址
https://github.com/Albert4417/VpsEnvInstall/blob/master/VPS_Env_install.sh
修改说明
优化了部分代码逻辑---速度有点BUG
（之前学的shell忘得差不多了）----欢迎各位师傅指正优化代码

新增加了python、tmux、docker、proxychains、proxychains4

工具目录：/opt/vps-gj/xxsj-01
增加了几个子域名工具（后续会增加更多工具）

使用说明
先去VPS上去执行一些初始操作 ( 如下以 Ubuntu 20.04 LTS 64bit为例 )
echo "Korc" > /etc/hostname           # 修改机器名 
echo 8.8.8.8 Korc >> /etc/hosts       # 修改解析
 init 6                                # 最后,重启系统使之生效
完成以上操作可执行脚本（后期会加固小鸡--会增加一些方案）

安装
# wget https://github.com/0x076/VPS_vps__attack-frame/releases/download/jb/vps__attackframe__0.2.sh >/dev/null 2>&1
# chmod +x vps__attackframe__0.2.sh
![15](https://user-images.githubusercontent.com/106065628/173065233-4d70e858-620c-459d-83ba-42d7ab0079c3.png)

使用
# sed -i -e 's/\r$//' vps__attackframe__0.2.sh
# ./vps__attackframe__0.2.sh 
![25](https://user-images.githubusercontent.com/106065628/173065265-295ee397-f28a-4504-9232-a34912b2f82d.png)


后期计划
增加更多工具、docker服务、VPS小鸡加固
增加工具（太多了--就不列了）----欢迎各位师傅投稿工具
● Dirbuster
● wFuzz
● dirsearch
● URLBrute
● wpscan
● aem-hacker
● joomscan
● 403bypasser 
● bypass-403
● HawkScan
● 水泽_0x727
