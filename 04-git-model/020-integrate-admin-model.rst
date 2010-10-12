整合管理员协同模型
==================

没有集中式的服务器

每个人通过 ssh 授权，对他人开放版本库访问

整合管理员：负责整合各个开发者的版本库，并维护一个公共的整合版本库

基于 SSH 公钥认证的 Git 服务器： gitosis

简单部署的 gitosis~lite

::

    aptitude 或者 easy-install 安装
    创建一个帐号如 gitosis，并设置登录口令
    设置 /etc/ssh/sshd_config
        Match user gitosis
    ForceCommand gitosis-serve gitosis
    X11Forwarding no
    AllowTcpForwarding no
    AllowAgentForwarding no
    PubkeyAuthentication yes
    #PasswordAuthentication no    
    其他人如果想无口令登录，执行命令： ssh-copy-id
    在 gitosis 用户主目录下，创建一个 .gitosis.conf 文件

        [gitosis]
        repositories = /gitroot
        loglevel=DEBUG
        gitweb = no
        daemon = no

        [group readers]
        members = @all
        readonly = repos1 repos2

        # [group writers]
        # members = @all
        # writable = repos3 repos4

问题： 向别人开放的带工作区的版本库 push 失败

receive.denyCurrentBranch 缺省是 refuse，导致不能向含工作目录的库 push


设置几个开发负责人。开发负责人本身也是程序员

每个人负责管理多个程序员的提交

从程序员版本库 Fetch/Pull，再由开发负责人统一 PUSH 到公共服务器

