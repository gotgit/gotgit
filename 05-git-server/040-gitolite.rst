Gitolite 服务架设
******************
Gitolite 是一款 Perl 语言开发的 Git 服务管理工具，通过公钥对用户进行认证，并能够通过配置文件对写操作进行基于分支和路径的精细授权。Gitolite 采用的是 SSH 协议并且使用 SSH 公钥认证，因此无论是管理员还是普通用户，都需要对 SSH 非常熟悉。在开始之前，请确认您已经通读过第29章“使用SSH协议”。

Gitolite 的官方网址是： http://github.com/sitaramc/gitolite 。从提交日志里可以看出作者是 Sitaram Chamarty，最早的提交开始于 2009年8月。作者是受到了 Gitosis 的启发，开发了这款功能更为强大和易于安装的软件。Gitolite 的命名，作者的原意是 Gitosis 和 lite 的组合，不过因为 Gitolite 的功能越来越强大，已经超越了 Gitosis，因此作者笑称 Gitolite 可以看作是 Github-lite —— 轻量级的 Github。

我是在2010年8月才发现 Gitolite 这个项目的，并尝试将公司基于 Gitosis 的管理系统迁移至 Gitolite。在迁移和使用过程中，增加和改进了一些实现，如：通配符版本库的创建过程，对创建者的授权，版本库名称映射等。本文关于 Gitolite 的介绍也是基于我改进的版本 [#]_ 。

* 原作者的版本库地址：

  http://github.com/sitaramc/gitolite

* 笔者改进后的 Gitolite 分支：

  http://github.com/ossxp-com/gitolite

Gitolite 的实现机制和使用特点概述如下：

* Gitolite 安装在服务器( :samp:`server` ) 某个帐号之下，例如 :samp:`git` 帐号。

* 管理员通过 :program:`git` 命令检出名为 :file:`gitolite-admin` 的版本库。

  ::

    $ git clone git@server:gitolite-admin.git

* 管理员将所有Git用户的公钥保存在 gitolite-admin 库的 :file:`keydir` 目录下，并编辑 :file:`conf/gitolite.conf` 文件为用户授权。

* 当管理员提交对 gitolite-admin 库的修改并推送到服务器之后，服务器上 gitolite-admin 版本库的钩子脚本将执行相应的设置工作。

  - 新用户的公钥自动追加到服务器端安装帐号主目录下的 :file:`.ssh/authorized_keys` 文件中，并设置该用户的 shell 为 gitolite 的一条命令 :program:`gl-auth-command` 。在 :file:`.ssh/authorized_keys` 文件中增加的内容示例如下： [#]_

    ::

      command="/home/git/bin/gl-auth-command jiangxin",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty ssh-rsa AAAAB3NzaC1yc2...(公钥内容来自于 jiangxin.pub)... 

  - 更新服务器端的授权文件 :file:`~/.gitolite/conf/gitolite.conf` 。

  - 编译授权文件为 :file:`~/.gitolite/conf/gitolite.conf-compiled.pm` 。

* 若用ssh命令登录服务器（以git用户登录）时，因为公钥认证的相关设置（使用 :program:`gl-auth-command` 作为shell），不能进入 shell 环境，而是打印服务器端 git 库授权信息后马上退出。即用户不会通过 git 用户进入服务器的 shell，也不会对系统的安全造成威胁。

  ::

    $ ssh git@bj
    hello jiangxin, the gitolite version here is v1.5.5-9-g4c11bd8
    the gitolite config gives you the following access:
         R          gistore-bj.ossxp.com/.*$
      C  R  W       ossxp/.*$
     @C @R  W       users/jiangxin/.+$
    Connection to bj closed.

* 用户可以用 git 命令访问授权的版本库。

* 若管理员授权，用户可以远程在服务器上创建新版本库。

下面介绍 Gitolite 的部署和使用。

安装 Gitolite
==============

安装Gitolite（2.1版本）对服务器的要求是：

* Git版本为1.6.6或以上。
* Unix或类Unix（Linux, MacOS等）操作系统。
* 服务器开启SSH服务。

和其他Unix上软件包一样Gitolite既可通过操作系统本身提供的二进制发布包方式安装，也可通过克隆Gitolite源码库从源代码安装Gitolite。

.. note::
   老版本的Gitolite提供了一种从客户端发起安装的模式，但该安装模式需要管理员维护两套不同公钥/私钥对（一个公钥用于无口令登录服务器以安装和更新软件，另外一个公钥用于克隆和推送 gitolite-admin 版本库），稍嫌复杂，在2.1之后的Gitolite取消了这种安装模式。

安装之前
------------

Gitolite搭建的Git服务器是以SSH公钥认证为基础的，无论是普通Git用户还是Gitolite的管理员都通过公钥认证访问Gitolite服务器。在Gitolite的安装过程中需要提供管理员公钥，以便在Gitolite安装完毕后管理员能够远程克隆 :file:`gitolite-admin` 版本库（仅对管理员授权），对Gitolite服务器进行管理——添加新用户和为用户添加授权。

为此在安装Gitolite之前，管理员需要在客户端（用于远程管理Gitolite服务器的客户端）创建用于连接Gitolite服务器的SSH公钥（如果尚不存在的话），并把公钥文件拷贝到服务器上。

1. 在客户端创建SSH公钥/私钥对。

   如果管理员在客户端尚未创建公钥/私钥对，使用下面的命令会在用户主目录下创建名为 :file:`~/.ssh/id_rsa` 的SSH私钥和名为 :file:`~/.ssh/id_rsa.pub` 的公钥文件：

   ::
   
     $ ssh-keygen

2. 将公钥文件从客户端复制到服务器端，以便安装Gitolite时备用。

   可以使用 :program:`ftp` 或U盘拷贝等方式从客户端向服务器端传送文件，不过用 :program:`scp` 命令是非常方便的，例如服务器地址为 ``server`` ，相应的拷贝命令为：

   ::
   
     $ scp ~/.ssh/id_rsa.pub server:/tmp/admin.pub

以发布包形式安装
---------------------

常见的Linux发行版都包含了Gitolite软件包，安装Gitolite使用如下命令：

* Debian/Ubuntu：

  ::
  
    $ sudo aptitude install gitolite
  
* RedHat：
  
  ::
  
    $ sudo yum install gitolite

安装完毕后会自动创建一个专用系统账号如 :samp:`gitolite` 。在Debian平台上创建的 :samp:`gitolite` 账号使用 :file:`/var/lib/gitolite` 作为用户主目录，而非 :file:`/home/gitolite` 。

::

  $ getent passwd gitolite
  gitolite:x:114:121:git repository hosting,,,:/var/lib/gitolite:/bin/bash

安装完毕，运行如下命令完成对Gitolite的配置：

1. 切换至新创建的 :samp:`gitolite` 用户账号。

   ::

     $ sudo su - gitolite

2. 运行 :program:`gl-setup` 命令，并以客户端复制过来的公钥文件路径作为参数。

   ::

     $ gl-setup /tmp/admin.pub

Debian等平台会在安装过程中（或运行 :command:`sudo dpkg-reconfigure gitolite` 命令时），开启配置界面要求用户输入Gitolite专用账号、Git版本库根目录、管理员公钥文件名，然后自动执行 :command:`gl-setup` 完成设置。

从源代码开始安装
---------------------

如果想在系统中部署多个Gitolite实例，希望部署最新的Gitolite版本，或者希望安装自己或他人对Gitolite的定制版本，就要采用从源代码进行Gitolite部署。

1. 创建专用系统账号。

   首先需要在服务器上创建Gitolite专用帐号。因为所有用户都要通过此帐号访问Git版本库，为方便易记一般选择更为简练的 :samp:`git` 作为专用帐号名称。

   ::
   
     $ sudo adduser --system --group --shell /bin/bash git
   
   注意添加的用户要能够远程登录，若系统只允许特定用户组（如 :samp:`ssh` 用户组）的用户才可以通过 SSH 协议登录，就需要将新建的 :samp:`git` 用户添加到该特定的用户组中。执行下面的命令可以将 :samp:`git` 用户添加到 :samp:`ssh` 用户组。
   
   ::
   
     $ sudo adduser git ssh
   
   取消 :samp:`git` 用户的口令，以便只能通过公钥对 :samp:`git` 账号进行认证，增加系统安全性。
   
   ::
   
     $ sudo passwd --delete git

2. 切换到新创建的用户账号，后续的安装都以该用户身份执行。

   ::

     $ sudo su - git

3. 在服务器端下载Gitolite源码。一个更加“Git”的方式就是克隆Gitolite的版本库。

   * 克隆官方的Gitolite版本库如下：

     ::

       $ git clone git://github.com/sitaramc/gitolite.git

   * 也可以克隆定制后的Gitolite版本库，如我在GitHub上基于Gitolite官方版本库建立的分支版本：

     ::

       $ git clone git://github.com/ossxp-com/gitolite.git

4. 安装Gitolite。

   运行源码目录中的 :program:`src/gl-system-install` 执行安装。

   ::

     $ cd gitolite
     $ src/gl-system-install

   如果像上面那样不带参数的执行安装程序，会将Gitolite相关命令安装到 :file:`~/bin` 目录中，相当于执行：

   ::

     $ src/gl-system-install $HOME/bin $HOME/share/gitolite/conf $HOME/share/gitolite/hooks

5. 运行 gl-setup 完成设置。

   若Gitolite安装到 :file:`~/bin` 目录下（即没有安装到系统目录下），需要设置 ``PATH`` 环境变量以便 :program:`gl-setup` 能够正常运行。

   ::

     $ export PATH=~/bin:$PATH

   然后运行 :program:`gl-setup` 命令，并以客户端复制过来的公钥文件路径作为参数。

   ::

     $ ~/bin/gl-setup /tmp/admin.pub


管理 Gitolite
==============

管理员克隆 gitolite-admin 管理库
--------------------------------

当 Gitolite 安装完成后，就会在服务器端版本库根目录下创建一个用于管理Gitolite的版本库。若以 :samp:`git` 用户安装，则该Git版本库的路径为： :file:`~git/repositories/gitolite-admin.git` 。

在客户端用 :program:`ssh` 命令连接服务器 :samp:`server` 的 :samp:`git` 用户，如果公钥认证验证正确的话，Gitolite将此SSH会话的用户认证为 :samp:`admin` 用户，显示 :samp:`admin` 用户的权限。如下：

::

  $ ssh -T git@server
  hello admin, this is gitolite v2.1-7-ge5c49b7 running on git 1.7.7.1
  the gitolite config gives you the following access:
       R   W      gitolite-admin
      @R_ @W_     testing
  

从上面命令的倒数第二行输出可以看出用户 :samp:`admin` 对版本库 ``gitolite-admin`` 拥有读写权限。

为了对Gitolite服务器进行管理，需要在客户端克隆 ``gitolite-admin`` 版本库，使用如下命令：

::

  $ git clone git@server:gitolite-admin.git
  $ cd gitolite-admin/

在客户端克隆的 :file:`gitolite-admin` 目录下有两个子目录 :file:`conf/` 和 :file:`keydir/` ，包含如下文件：

* 文件： :file:`keydir/admin.pub` 。

  目录 :file:`keydir` 下初始时只有一个用户公钥，即管理员 :samp:`amdin` 的公钥。

* 文件： :file:`conf/gitolite.conf` 。

  该文件为授权文件。初始内容为：

  ::

    repo    gitolite-admin
            RW+     =   admin
    
    repo    testing
            RW+     =   @all

  默认授权文件中只设置了两个版本库的授权：

  * gitolite-admin
  
    即本版本库。此版本库用于Gitolite管理，只有 admin 用户有读写和强制更新的权限。

  * testing

    默认设置的测试版本库。设置为任何人都可以读写及强制更新。


增加新用户
----------
增加新用户，就是允许新用户能够通过其公钥访问 Git 服务。只要将新用户的公钥添加到 gitolite-admin 版本库的 :file:`keydir` 目录下，即完成新用户的添加，具体操作过程如下。

1. 管理员从用户获取公钥，并将公钥按照 :file:`username.pub` 格式进行重命名。

   - 用户可以通过邮件或其他方式将公钥传递给管理员，切记不要将私钥误传给管理员。如果发生私钥泄漏，马上重新生成新的公钥/私钥对，并将新的公钥传递给管理员，并申请将旧的公钥作废。
 
   - 用户从不同的客户端主机访问有着不同的公钥，如果希望使用同一个用户名进行授权，可以按照 :file:`username@host.pub` 的方式命名公钥文件，和名为 :file:`username.pub` 的公钥指向同一个用户 :samp:`username` 。
 
   - Gitolite 也支持邮件地址格式的公钥，即形如 :file:`username@gmail.com.pub` 的公钥。Gitolite 能够很智能地区分是以邮件地址命名的公钥还是相同用户在不同主机上的公钥。如果是邮件地址命名的公钥，将以整个邮件地址作为用户名。

   - 还可以在 :file:`keydir` 目录下创建子目录来管理用户公钥，同一用户的不同公钥可以用同一名称保存在不同子目录中。

2. 管理员进入 gitolite-admin 本地克隆版本库中，复制新用户公钥到 keydir 目录。
 
   ::
 
     $ cp /path/to/dev1.pub keydir/
     $ cp /path/to/dev2.pub keydir/
     $ cp /path/to/jiangxin.pub keydir/
 
3. 执行 git add 命令，将公钥添加到版本库。
 
   ::
 
     $ git add keydir
 
4. 执行 git commit，完成提交。
 
   ::
 
     $ git commit -m "add user: jiangxin, dev1, dev2"
 
5. 执行 git push，同步到服务器，才真正完成新用户的添加。
 
   ::
 
     $ git push
     Counting objects: 8, done.
     Delta compression using up to 2 threads.
     Compressing objects: 100% (6/6), done.
     Writing objects: 100% (6/6), 1.38 KiB, done.
     Total 6 (delta 0), reused 0 (delta 0)
     remote: Already on 'master'
     remote:
     remote:                 ***** WARNING *****
     remote:         the following users (pubkey files in parens) do not appear in the config file:
     remote: dev1(dev1.pub),dev2(dev2.pub),jiangxin(jiangxin.pub)

   在 :command:`git push` 的输出中，以 remote 标识的输出是服务器端执行 :file:`post-update` 钩子脚本的错误输出，用于提示新增的三个用户（公钥）在授权文件中没有被引用。接下来会介绍如何修改授权文件，以及如何为用户添加授权。

服务器端的 :samp:`git` 主目录下的 :file:`.ssh/authorized_keys` 文件会随着新增用户公钥而更新，即添加三条新的记录。如下：

::

  $ cat ~git/.ssh/authorized_keys
  # gitolite start
  command="/home/git/bin/gl-auth-command admin",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty    <用户admin的公钥...>
  command="/home/git/bin/gl-auth-command dev1",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty     <用户dev1的公钥...>
  command="/home/git/bin/gl-auth-command dev2",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty     <用户dev2的公钥...>
  command="/home/git/bin/gl-auth-command jiangxin",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty <用户jiangxin的公钥...>
  # gitolite end

更改授权
---------

新用户添加完毕，接下来需要为新用户添加授权，这个过程也比较简单，只需修改 :file:`conf/gitolite.conf` 配置文件，提交并推送。具体操作过程如下：

1. 管理员进入 :file:`gitolite-admin` 本地克隆版本库中，编辑 :file:`conf/gitolite.conf` 。
 
   ::
 
     $ vi conf/gitolite.conf
 
2. 授权指令比较复杂，先通过建立新用户组尝试一下更改授权文件。
 
   考虑到之前增加了三个用户公钥，服务器端发出了用户尚未在授权文件中出现的警告。现在就在这个示例中解决这个问题。
   
   * 可以在其中加入用户组 @team1，将新添加的用户 jiangxin、dev1、dev2 都归属到这个组中。
 
     只需要在 :file:`conf/gitolite.conf` 文件的文件头加入如下指令即可。用户名之间用空格分隔。
 
     ::
 
       @team1 = dev1 dev2 jiangxin
 
   * 编辑完毕退出。可以用 :command:`git diff` 命令查看改动：
 
     还修改了版本库 :samp:`testing` 的授权，将 :samp:`@all` 用户组改为新建立的 :samp:`@team1` 用户组。
 
     ::
 
       $ git diff
       diff --git a/conf/gitolite.conf b/conf/gitolite.conf
       index 6c5fdf8..f983a84 100644
       --- a/conf/gitolite.conf
       +++ b/conf/gitolite.conf
       @@ -1,5 +1,7 @@
       +@team1 = dev1 dev2 jiangxin
       +
        repo    gitolite-admin
                RW+     =   admin
        
        repo    testing
       -        RW+     =   @all
       +        RW+     =   @team1
 
3. 编辑结束，提交改动。
 
   ::
 
     $ git add conf/gitolite.conf
     $ git commit -q -m "new team @team1 auth for repo testing."
 
4. 执行 :command:`git push` ，同步到服务器，授权文件的更改才真正生效。
 
   可以注意到，推送后的输出中没有了警告。
 
   ::
 
     $ git push
     Counting objects: 7, done.
     Delta compression using up to 2 threads.
     Compressing objects: 100% (3/3), done.
     Writing objects: 100% (4/4), 398 bytes, done.
     Total 4 (delta 1), reused 0 (delta 0)
     remote: Already on 'master'
     To gitadmin.bj:gitolite-admin.git
        bd81884..79b29e4  master -> master


Gitolite 授权详解
=================

授权文件的基本语法
------------------

下面看一个不那么简单的授权文件。为方便描述添加了行号。

::

   1  @manager = jiangxin wangsheng
   2  @dev   = dev1 dev2 dev3
   3
   4  repo    gitolite-admin
   5          RW+                         = jiangxin
   6
   7  repo    ossxp/[a-z].+
   8          C                           = @manager
   9          RW+                         = CREATOR
  10          RW                          = WRITERS
  11          R                           = READERS @dev
  12
  13  repo    testing
  14          RW+                         =   @manager
  15          RW      master              =   @dev
  16          RW      refs/tags/v[0-9]    =   dev1
  17          -       refs/tags/          =   @all

在上面的示例中，演示了很多授权指令：

* 第1行，定义了用户组 ``@manager`` ，包含两个用户 ``jiangxin`` 和 ``wangsheng`` 。

* 第2行，定义了用户组 ``@dev`` ，包含三个用户 ``dev1`` 、 ``dev2`` 和 ``dev3`` 。

* 第4-5行，定义了版本库 ``gitolite-admin`` 。指定只有超级用户 ``jiangxin`` 才能够访问，并拥有读（R）写（W）和强制更新（+）的权限。

* 第7行，通过正则表达式为一组版本库进行批量授权。即针对 :file:`ossxp` 目录下以小写字母开头的所有版本库进行授权。

* 第8行，用户组 ``@manager`` 中的用户可以创建版本库。即可以在 :file:`ossxp` 目录下创建以小写字母开头的版本库。

* 第9行，版本库的创建者拥有对所创建版本库的完全权限。版本库的创建者是通过 :command:`git push` 命令创建版本库的那一个人。

* 第10-11行，出现了两个特殊角色 ``WRITERS`` 和 ``READERS`` ，这两个角色不在本配置文件中定义，而是由版本库创建者使用Gitolite支持的 ``setperms`` 命令进行设置。

* 第11行，还设置了 ``@dev`` 用户组的用户对 :file:`ossxp` 目录下的版本库具有读取权限。

* 第13行开始，对 :file:`testing` 版本库进行授权。其中使用了对引用授权的语法。

* 第14行，用户组 ``@manager`` 对所有引用包括分支拥有读写、重置、添加和删除的授权，但里程碑除外，因为第17行定义了一条禁用规则。

* 第15行，用户组 ``@dev`` 可以读写 ``master`` 分支。（还包括名字以 ``master`` 开头的其他分支，如果有的话。）

* 第16行，用户 ``dev1`` 可以创建里程碑（即以 ``refs/tags/v[0-9]`` 开始的引用）。

* 第17行，禁止所有人（ ``@all`` ）对以 ``refs/tags/`` 开头的引用进行写操作。实际上由于之前第14行和第16行建立的授权，用户组 ``@manager`` 的用户和用户 ``dev1`` 能够创建里程碑，而且用户组 ``@manager`` 还能删除里程碑。

下面针对授权指令进行详细的讲解。

定义用户组和版本库组
--------------------
在 :file:`conf/gitolite.conf` 授权文件中，可以定义用户组或版本库组。组名称以 ``@`` 字符开头，可以包含一个或多个成员。成员之间用空格分开。

* 例如定义管理员组：

  ::

    @admin = jiangxin wangsheng

* 组可以嵌套：

  ::

    @staff = @admin @engineers tester1

除了作为用户组外，同样的语法也适用于版本库组。版本库组和用户组的定义没有任何区别，只是在版本库授权指令中处于不同的位置。即位于授权指令中的版本库位置代表版本库组，位于授权指令中的用户位置代表用户组。

版本库ACL
---------

一个版本库可以包含多条授权指令，这些授权指令组成了一个版本库的权限控制列表（ACL）。例如：

::

  repo testing
      RW+                 = jiangxin @admin
      RW                  = @dev @test
      R                   = @all

版本库
^^^^^^^^

每一个版本库授权都以一条 ``repo`` 指令开始。指令 ``repo`` 后面是版本库列表，版本之间用空格分开，还可以包括版本库组。示例如下：

::

  repo sandbox/test1 sandbox/test2 @test_repos

注意版本库名称不要添加 ``.git`` 后缀，在版本库创建或权限匹配过程中会自动添加 ``.git`` 后缀。用 ``repo`` 指令定义的版本库会自动在服务器上创建，但使用正则表达式定义的通配符版本库除外。

通配符版本库就是在 ``repo`` 指令定义的版本库名称中使用了正则表达式。通配符版本库针对的不是某一个版本库，而是匹配一组版本库，这些版本库可能已经存在或尚未创建。例如下面的 ``repo`` 指令定义了一组通配符版本库。

::

  repo redmine/[a-zA-Z].+

通配符版本库匹配时会自动在版本库名称前面加上前缀 ``^`` ，在后面添加后缀 ``$`` 。即通配符版本库对版本库名称进行完整匹配而非部分匹配，这一点和后面将要介绍的正则引用（refex）大不一样。

有时 ``repo`` 指令定义普通版本库和通配符版本库的界限并不是那么清晰，像下面这条 ``repo`` 指令：

::

  repo ossxp/.+

因为点号（.）和加号（+）也可以作为普通字符出现在版本库名称中，这条指令会导致Gitolite创建 :file:`ossxp` 目录，并在目录下创建名为 :file:`.+.git` 的版本库。因此在定义通配符版本库时要尽量写得“复杂点”以免造成误判。

.. tip:: 我对Gitolite进行了一点改进，能够减少对诸如 ``ossxp/.+`` 通配符版本库误判的可能。并提供在定义通配符版本库时使用 ``^`` 前缀和 ``$`` 后缀，以减少误判。如使用如下方式定义通配符版本库： ``repo ^myrepo`` 。

授权指令
^^^^^^^^^^

在 repo 指令之后是缩进的一条或多条授权指令。授权指令的语法如下：

::

  <权限>  [零个或多个正则表达式匹配的引用] = <user> [<user> ...]

每条指令必须指定一个权限，称为授权关键字。包括传统的授权关键字： ``C`` 、 ``R`` 、 ``RW`` 和 ``RW+`` ，以及将分支创建和分支删除分离出来的扩展授权关键字： ``RWC`` 、 ``RW+C`` 、 ``RWD`` 、 ``RW+D`` 、 ``RWCD`` 、 ``RW+CD`` 。

传统的授权关键字包括：

* C

  ``C`` 代表创建版本库，仅在对通配符版本库进行授权时方可使用。用于设定谁可以创建名称与通配符匹配的版本库。

* R

  ``R`` 代表只读权限。

* RW

  ``RW`` 代表读写权限。如果在同一组（针对同一版本库）授权指令中没有出现代表创建分支的扩展授权关键字，则 ``RW`` 还包括创建分支的权限，而不仅是在分支中的读写。

* RW+

  ``RW+`` 除了具有读写权限外，还可以强制推送（执行非快进式推送）。如果在同一组授权指令中没有出现代表分支删除的扩展授权关键字，则 ``RW+`` 还同时包含了创建分支和删除分支的授权。

* ``-``

  ``-`` 含义为禁用。因为禁用规则只在第二阶段授权生效 [#]_ ，所以一般只用于撤销特定用户对特定分支或整个版本库的写操作授权。

扩展的授权关键字将创建分支和删除分支的权限从传统授权关键字中分离出来，从而新增了六个授权关键字。在一个版本库的授权指令中一旦发现创建分支和/或删除分支的授权使用了下列新的扩展授权关键字后，原有的 ``RW`` 和 ``RW+`` 不再行使对创建分支和/或删除分支的授权。

* RWC

  ``RWC`` 代表读写授权、创建新引用（分支、里程碑等）的授权。

* RW+C

  ``RW+C`` 代表读写授权、强制推送和创建新引用的授权。

* RWD

  ``RWD`` 代表读写授权、删除引用的授权。

* RW+D

  ``RW+D`` 代表读写授权、强制推送和删除引用的授权。

* RWCD

  ``RWCD`` 代表读写授权、创建新引用和删除引用的授权。

* RW+CD

  ``RW+CD`` 代表读写授权、强制推送、创建新引用和删除引用的授权。

授权关键字后面（等号前面）是一个可选的正则引用（refex）或正则引用列表（用空格分隔）。

*  正则表达式格式的引用，简称正则引用（refex），在授权检查时对Git版本库的引用进行匹配。

*  如果在授权指令中省略正则引用，则意味着该授权指令对全部的引用都有效。

*  正则引用如果不以 :file:`refs/` 开头，会自动添加 :file:`refs/heads/` 作为前缀。

*  正则引用默认采用部分匹配策略，即如果不以 ``$`` 结尾，则后面可以匹配任意字符，相当于添加 ``.*$`` 作为后缀。

授权关键字后面（等号前面）也可以包含一个以 ``NAME/`` 为前缀的表达式，但这个表达式并非引用，而是路径。支持基于路径的写操作授权。

授权指令以等号（=）为标记分为前后两段，等号后面的是用户列表。用户之间用空格分隔，并且可以使用用户组。

Gitolite 授权机制
-----------------

Gitolite 的授权实际分为两个阶段。第一个阶段称为前Git阶段，即在 Git 命令执行前，由 SSH 连接触发的 :program:`gl-auth-command` 命令执行的授权检查。包括：

* 版本库的读。

  如果用户拥有版本库或版本库的任意分支具有下列权限之一： ``R`` 、 ``RW`` 、 ``RW+`` （或其他扩展关键字） ，则整个版本库（包含所有分支）对用户均可读，否则版本库不可读取。

  最让人迷惑的就是只为某用户分配了对某个分支的读授权（ ``R`` ），而该用户实际上能够读取版本库的任意分支。之所以Gitolite对读授权不能细化到分支甚至目录，只能针对版本库进行粗放的非零即壹的读操作授权，是因为读授权只在版本库授权的第一个阶段进行检查，而在此阶段还获取不到版本库的分支。

* 版本库的写。

  版本库的写授权实际上要在两个阶段分别进行检查。本阶段，即第一阶段仅检查用户是否拥有下列权限之一： ``RW`` 、 ``RW+`` 或 ``C`` 授权，具有这些授权则通过第一阶段的写权限检查。第二个阶段的授权检查由Git版本库的钩子脚本触发，能够实现基于分支和路径的写操作授权，以及对分支创建、删除和是否可强制更新进行授权检查，具体见第二阶段授权过程描述。

* 版本库的创建。

  仅对正则表达式定义的通配符版本库有效。即拥有 ``C`` 授权的用户可以创建和相应的正则表达式匹配的版本库。创建版本库（尤其是通过执行 :command:`git push` 命令创建版本库）不免要涉及到执行新创建的版本库的钩子脚本，所以需要为版本库设置一条创建者可读写的授权。如：

  ::

            RW = CREATOR

Gitolite对授权的第二个阶段的检查，实际上是通过 :file:`update` 钩子脚本进行的。因为版本库的读操作不执行 :file:`update` 钩子，所以读操作只在授权的第一个阶段（前Git阶段）就完成了检查，授权的第二个阶段仅对写操作进行更为精细的授权检查。

* 钩子脚本 :file:`update` 针对推送操作的各个分支进行逐一检查，因此第二个阶段可以进行针对分支写操作的精细授权。

* 在这个阶段可以获取到要更新的新、老引用的 SHA1 哈希值，因此可以判断出是否发生了非快进式推送、是否有新分支创建，以及是否发生了分支的删除，因此可以针对这些操作进行精细的授权。

* 基于路径的写授权也是在这个阶段进行的。

版本库授权案例
===============

Gitolite 的授权非常强大也很复杂，因此从版本库授权的实际案例来学习是非常行之有效的方式。

常规版本库授权
--------------------

授权文件如下：

::

  1  @admin = jiangxin
  2  @dev   = dev1 dev2 badboy jiangxin
  3  @test  = test1 test2
  4
  5  repo testing
  6      RW+ = @admin
  7      R = @test
  8      - = badboy
  9      RW = @dev test1

关于授权的说明：

* 用户 ``jiangxin`` 对版本库具有写的权限，并能够强制推送。

  由于用户 ``jiangxin`` 属于用户组 ``@admin`` ，通过第6行授权指令而具有读写权限，以及强制推送、创建和删除引用的权限。

* 用户 ``test1`` 对版本库具有写的权限。

  第7行定义了 ``test1`` 所属的用户组 ``@test`` 具有只读权限。第9行定义了 ``test1`` 用户具有读写权限。Gitolite 的实现是对读权限和写权限分别进行判断并汇总（并集），从而 ``test1`` 用户具有读写权限。

* 用户 ``badboy`` 对版本库只具有读操作的权限，没有写操作权限。

  第8行的指令以减号（-）开始，是一条禁用指令。禁用指令只在授权的第二阶段起作用，即只对写操作起作用，不会对 ``badboy`` 用户的读权限施加影响。在第9行的指令中， ``badboy`` 所在的 ``@dev`` 组拥有读写权限。但禁用规则会对写操作起作用，导致 ``badboy`` 只有读操作权限，而没有写操作。

上面在Gitolite配置文件中对 ``testing`` 版本库进行的授权，当通过推送更新至Gitolite服务器上时，如果服务器端尚不存在一个名为 ``testing`` 的版本库，Gitolite会自动初始化一个空白的 ``testing`` 版本库。


通配符版本库授权
------------------

授权文件如下：

::

   1   @administrators = jiangxin admin
   2   @dev            = dev1 dev2 badboy
   3   @test           = test1 test2
   4
   5   repo    sandbox/[a-z].+
   6           C       = @administrators
   7           RW+     = CREATOR
   8           R       = @test
   9           -       = badboy
  10           RW      = @dev test1

这个授权文件的版本库名称中使用了正则表达式，匹配在 :file:`sandbox` 目录下的任意以小写字母开头的版本库。因为通配符版本库并非指代一个具体版本库，因而不会在服务器端自动创建，而是需要管理员手动创建。

创建和通配符匹配的版本库，Gitolite的原始实现是克隆即创建。例如管理员 ``jiangxin`` 创建名为 ``sandbox/repos1.git`` 版本库，执行下面命令：

::

  jiangxin$ git clone git@server:sandbox/repos1.git

这种克隆即创建的方式很容易因为录入错误而导致意外创建错误的版本库。我改进的 Gitolite 需要通过推送来创建版本库。下面的示例通过推送操作（以 ``jiangxin`` 用户身份），远程创建版本库 ``sandbox/repos1.git`` 。

::

  jiangxin$ git remote add origin git@server:sandbox/repos1.git
  jiangxin$ git push origin master

对创建完成的 ``sandbox/repo1.git`` 版本库进行授权检查，会发现：

* 用户 ``jiangxin`` 对版本库具有读写权限，而用户 ``admin`` 则不能读取 ``sandbox/repo1.git`` 版本库。

  第6行的授权指令同时为用户 ``jiangxin`` 和 ``admin`` 赋予了创建与通配符相符的版本库的权限。但因为版本库 ``sandbox/repo1.git`` 是由 ``jiangxin`` 而非 ``admin`` 创建的，所以第7条的授权指令只为版本库的创建者 ``jiangxin`` 赋予了读写权限。
  
  Gitolite通过在服务器端该版本库目录下创建一个名为 :file:`gl-creater` 的文件记录了版本库的创建者。

* 和之前的例子相同的是：

  - 用户 ``test1`` 对版本库具有写的权限。
  - 禁用指令让用户 ``badboy`` 对版本库仅具有只读权限。

如果采用接下来的示例中的版本库权限设置，版本库 ``sandbox/repo1.git`` 的创建者 ``jiangxin`` 还可以使用 :command:`setperms` 命令为版本库添加授权。具体用法参见下面的示例。

每个人创建自己的版本库
-----------------------

授权文件如下：

::

  1  @administrators = jiangxin admin
  2
  3  repo    users/CREATOR/[a-zA-Z].*
  4          C   =  @all
  5          RW+ =  CREATOR
  6          RW  =  WRITERS
  7          R   =  READERS @administrators 

关于授权的说明：

* 第4条指令，设置用户可以在自己的名字空间（ :file:`/usrs/<userid>/` ）下，自己创建版本库。例如下面就是用户 ``dev1`` 执行 :command:`git push` 命令在Gitolite服务器上自己的名字空间下创建版本库。

  ::

    dev1$ git push git@server:users/dev1/repos1.git master

* 第5条指令，设置版本库创建者对版本库具有完全权限。
  
  即用户 ``dev1`` 拥有对其自建的 ``users/dev1/repos1.git`` 拥有最高权限。

* 第7条指令，让管理员组 ``@administrators`` 的用户对于 :file:`users/` 下用户自建的版本库拥有读取权限。

那么第6、7条授权指令中出现的 ``WRITERS`` 和 ``READERS`` 是如何定义的呢？实际上这两个变量可以看做是两个用户组，不过这两个用户组不是在Gitolite授权文件中设置，而是由版本库创建者执行 :program:`ssh` 命令创建的。

版本库 ``users/dev1/repos1.git`` 的创建者 ``dev1`` 可以通过 :program:`ssh` 命令连接服务器，使用 :command:`setperms` 命令为自己的版本库设置角色。命令 ``setperms`` 的唯一一个参数就是版本库名称。当执行命令时，会自动进入一个编辑界面，手动输入角色定义后，按下 ``^D``（Ctrl+D）结束编辑。如下所示：

::

  dev1$ ssh git@server setperms users/dev1/repos1.git
  READERS dev2 dev3
  WRITERS jiangxin
  ^D

即在输入 setperms 命令后，进入一个编辑界面，输入 ^D（Ctrl+D）结束编辑。也可以将角色定义文件保存到文件中，用 :command:`setperms` 加载。如下：

::

  dev1$ cat > perms << EOF
  READERS dev2 dev3
  WRITERS jiangxin
  EOF

  dev1$ ssh git@server setperms users/dev1/repos1.git < perms
  New perms are:
  READERS dev2 dev3
  WRITERS jiangxin

当版本库创建者 ``dev1`` 对版本库 ``users/dev1/repos1.git`` 进行了如上设置后，Gitolite在进行授权检查时会将 ``setperms`` 设置的角色定义应用到授权文件中。故此版本库 ``users/dev1/repos1.git`` 中又补充了新的授权：

* 用户 ``dev2`` 和 ``dev3`` 具有读取权限。

* 用户 ``jiangxin`` 具有读写权限。

版本库 ``users/dev1/repos1.git`` 的建立者 ``dev1`` 可以使用 :command:`getperms` 查看自己版本库的角色设置。如下：

::

  dev1$ ssh git@server getperms users/dev1/repos1.git
  READERS dev2 dev3
  WRITERS jiangxin

传统模式的引用授权
----------------------

传统模式的引用授权指的是在授权指令中只采用 ``R`` 、 ``RW`` 和 ``RW+`` 的传统授权关键字，而不包括后面介绍的扩展授权指令。传统的授权指令没有把分支的创建和分支删除权限细分，而是和写操作及强制推送操作混杂在一起。

* 非快进式推送必须拥有上述关键字中的 ``+`` 方可授权。
* 创建引用必须拥有上述关键字中的 ``W`` 方可授权。
* 删除引用必须拥有上述关键字中的 ``+`` 方可授权。
* 如果没有在授权指令中提供引用相关的参数，相当于提供 ``refs/.*`` 作为引用的参数，意味着对所有引用均有效。

授权文件：

::

  1  @administrators = jiangxin admin
  2  @dev            = dev1 dev2 badboy
  3  @test           = test1 test2
  4
  5  repo    test/repo1
  6          RW+                           = @administrators
  7          RW master refs/heads/feature/ = @dev
  8          R                             = @test

关于授权的说明：

* 第6行，对于版本库 ``test/repo1`` ，管理员组用户 ``jiangxin`` 和 ``admin`` 可以读写任意分支、强制推送，以及创建和删除引用。

* 第7行，用户组 ``@dev`` 除了对 ``master`` 和 ``refs/heads/feature/`` 开头的引用具有读写权限外，实际上可以读取所有引用。这是因为读取操作授权阶段无法获知引用。

* 第8行，用户组 ``@test`` 对版本库拥有只读授权。

扩展模式的引用授权
----------------------

扩展模式的引用授权，指的是该版本库的授权指令出现了下列授权关键字中的一个或多个： ``RWC`` 、 ``RWD`` 、 ``RWCD`` 、 ``RW+C`` 、 ``RW+D`` 、 ``RW+CD`` ，将分支的创建权限和删除权限从读写权限中分离出来，从而可对分支进行更为精细的权限控制。


* 非快进式推送必须拥有上述关键字中的 ``+`` 方可授权。
* 创建引用必须拥有上述关键字中的 ``C`` 方可授权。
* 删除引用必须拥有上述关键字中的 ``D`` 方可授权。

即引用的创建和删除使用了单独的授权关键字，和写权限和强制推送权限分开。

下面是一个采用扩展授权关键字的授权文件：

::

  1   repo    test/repo2
  2           RW+C = @administrators 
  3           RW+  = @dev
  4           RW   = @test
  5
  6   repo    test/repo3
  7           RW+CD = @administrators 
  8           RW+C  = @dev
  9           RW    = @test

通过上面的配置文件，对于版本库 ``test/repo2.git`` 具有如下的授权：

* 第2行，用户组 ``@administrators`` 中的用户，具有创建和删除引用的权限，并且能强制推送。
  
  其中创建引用来自授权关键字中的 ``C`` ，删除引用来自授权关键中的 ``+`` ，因为该版本库授权指令中没有出现 ``D`` ，因而删除应用授权沿用传统授权关键字。

* 第3行，用户组 ``@dev`` 中的用户，不能创建引用，但可以删除引用，并且可以强制推送。

  因为第2行授权关键字中字符 ``C`` 的出现，使得创建引用采用扩展授权关键字，因而用户组 ``@dev`` 不具有创建引用的权限。

* 第4行，用户组 ``@test`` 中的用户，拥有读写权限，但是不能创建引用，不能删除引用，也不能强制推送。

通过上面的配置文件，对于版本库 ``test/repo3.git`` 具有如下的授权： 

* 第7行，用户组 ``@administrators`` 中的用户，具有创建和删除引用的权限，并且能强制推送。

  其中创建引用来自授权关键字中的 ``C`` ，删除引用来自授权关键中的 ``D`` 。

* 第8行，用户组 ``@dev`` 中的用户，可以创建引用，并能够强制推送，但不能删除引用。

  因为第7行授权关键字中字符 ``C`` 和 ``D`` 的出现，使得创建和删除引用都采用扩展授权关键字，因而用户组 ``@dev`` 不具有删除引用的权限。

* 第9行，用户组 ``@test`` 中的用户，可以推送到任何引用，但是不能创建引用，不能删除引用，也不能强制推送。


禁用规则的使用
----------------------------

授权文件片段：

::

  1     RW      refs/tags/v[0-9]        =   jiangxin 
  2     -       refs/tags/v[0-9]        =   @dev
  3     RW      refs/tags/              =   @dev

关于授权的说明：

* 用户 ``jiangxin`` 可以创建任何里程碑，包括以 v 加上数字开头的版本里程碑。

* 用户组 ``@dev`` ，只能创建除了版本里程碑（以 v 加上数字开头）之外的其他里程碑。

* 其中以 ``-`` 开头的授权指令建立禁用规则。禁用规则只在授权的第二阶段有效，因此不能限制用户的读取权限。


用户分支
--------

前面我们介绍过通过 ``CREATOR`` 特殊关键字实现用户自建版本库的功能。与之类似，Gitolite还支持在一个版本库中用户自建分支的功能。

用户在版本库中自建分支用到的关键字是 ``USER`` 而非 ``CREATOR`` 。即当授权指令的引用表达式中出现的 ``USER`` 关键字时，在授权检查时会动态替换为用户ID。例如授权文件片段：

::

  1   repo    test/repo4
  2           RW+CD                      = @administrators 
  3           RW+CD refs/heads/u/USER/   = @all
  4           RW+   master               = @dev

关于授权的说明：

* 第2行，用户组 ``@administrators`` 中的用户，对所有引用具有读写、创建和删除的权限，并且能强制推送。
* 第3行，所有用户都可以创建以 ``u/<userid>/`` （含自己用户ID）开头的分支。对自己名字空间下的引用具有完全权限。对于他人名字空间的引用只有读取权限，不能修改。
* 第4行，用户组 ``@dev`` 对 ``master`` 分支具有读写和强制更新的权限，但是不能删除。

对路径的写授权
--------------

Gitolite 也实现了对路径的写操作的精细授权，并且非常巧妙的是实现此功能所增加的代码可以忽略不计。这是因为 Gitolite 把路径当作是特殊格式的引用的授权。

在授权文件中，如果一个版本库的授权指令中的正则引用字段出现了以 ``NAME/`` 开头的引用，则表明该授权指令是针对路径进行的写授权，并且该版本库要进行基于路径的写授权判断。

示例：

::

  1  repo foo
  2      RW                  =   @junior_devs @senior_devs
  3
  4      RW  NAME/           =   @senior_devs
  5      -   NAME/Makefile   =   @junior_devs
  6      RW  NAME/           =   @junior_devs

关于授权的说明：

* 第2行，初级程序员 ``@junior_devs`` 和高级程序员 ``@senior_devs`` 可以对版本库 ``foo`` 进行读写操作。
* 第4行，设定高级程序员 ``@senior_devs`` 对所有文件（ ``NAME/`` ）进行写操作。
* 第5行和第6行，设定初级程序员 ``@junior_devs`` 对除了根目录的 :file:``Makefile`` 文件外的其他文件具有写权限。


创建和导入版本库
====================

Gitolite 维护的版本库默认位于安装用户主目录下的 repositories 目录中，即如果安装用户为 :samp:`git` ，则版本库都创建在 :file:`/home/git/repositories` 目录之下。可以通过配置文件 :file:`.gitolite.rc` 修改默认的版本库的根路径。

::

  $REPO_BASE="repositories";


有多种创建版本库的方式。一种是在授权文件中用 repo 指令设置版本库（未使用正则表达式的版本库）的授权，当对 ``gitolite-admin`` 版本库执行 :command:`git push` 操作时，自动在服务端创建新的版本库。另外一种方式是在授权文件中用正则表达式定义的通配符版本库，不会即时创建（也不可能被创建），而是被授权的用户在远程创建后推送到服务器上完成创建。

在配置文件中出现的版本库，即时生成
----------------------------------

尝试在授权文件 :file:`conf/gitolite.conf` 中加入一段新的版本库授权指令，而这个版本库尚不存在。新添加到授权文件中的内容为：

::

  repo testing2
      RW+                 = @all

然后将授权文件的修改提交并推送到服务器，会看到授权文件中添加新授权的版本库 testing2 被自动创建。

::

  $ git push
  Counting objects: 7, done.
  Delta compression using up to 2 threads.
  Compressing objects: 100% (3/3), done.
  Writing objects: 100% (4/4), 375 bytes, done.
  Total 4 (delta 1), reused 0 (delta 0)
  remote: Already on 'master'
  remote: creating testing2...
  remote: Initialized empty Git repository in /home/git/repositories/testing2.git/
  To gitadmin.bj:gitolite-admin.git
     278e54b..b6f05c1  master -> master

注意其中带 remote 标识的输出，可以看到版本库 testing2.git 被自动初始化了。

此外使用版本库组的语法（即用 @ 创建的组，用作版本库），也会被自动创建。例如下面的授权文件片段设定了一个包含两个版本库的组 :samp:`@testing` ，当将新配置文件推送到服务器上时，会自动创建 :file:`testing3.git` 和 :file:`testing4.git` 。

::

  @testing = testing3 testing4
   
  repo @testing
      RW+                 = @all


通配符版本库，管理员通过推送创建
---------------------------------

通配符版本库是用正则表达式语法定义的版本库，所指的并非某一个版本库而是和正则表达式相匹配的一组版本库。要想使用通配符版本库，需要在服务器端Gitolite的安装用户（如 :samp:`git` ）主目录下，修改配置文件 :file:`.gitolite.rc` ，使其包含如下配置：

::

  $GL_WILDREPOS = 1;

使用通配符版本库，可以对一组版本库进行授权，非常有效。但是版本库的创建则不像前面介绍的那样，不会在授权文件推送到服务器时创建，而是由拥有版本库创建授权（C）的用户手工进行创建。

对于用通配符设置的版本库，用 C 指令指定能够创建此版本库的管理员（拥有创建版本库的授权）。例如：

::

  repo ossxp/[a-z].+
      C                   = jiangxin
      RW                  = dev1 dev2

用户 ``jinagxin`` 可以创建路径符合正则表达式 ``ossxp/[a-z].+`` 的版本库，用户 ``dev1`` 和 ``dev2`` 对版本库具有读写（但是没有强制更新）权限。

* 本地建库。

  ::

     $ mkdir somerepo
     $ cd somerepo
     $ git init 
     $ git commit --allow-empty

* 使用 :command:`git remote` 指令设置远程版本库。

  ::

     $ git remote add origin git@server:ossxp/somerepo.git

  注：jiangxin-server是设置的别名主机，是以jiangxin用户的公钥访问server服务器。

* 运行 :command:`git push` 完成在服务器端版本库的创建。

  ::

     $ git push origin master

使用该方法创建版本库后，创建者 ``jiangxin`` 的用户ID将被记录在版本库目录下的 :file:`gl-creater` 文件中。该帐号具有对该版本库最高的权限。该通配符版本库的授权指令中如果出现关键字 ``CREATOR`` 将会用创建者的用户ID替换。

实际上Gitolite的原始实现是通过克隆即可创建版本库。即当克隆一个不存在的、名称匹配通配符版本库的、且拥有创建权限（ ``C`` ），Gitolite会自动在服务器端创建该版本库。但是我认为这不是一个好的实践，会经常因为在克隆时把 URL 写错，从而导致在服务器端创建垃圾版本库。因此我重新改造了Gitolite通配符版本库创建的实现方法，使用推送操作实现版本库的创建，而克隆一个不存在的版本库会报错、退出。


向Gitolite中导入版本库
-----------------------

在Gitolite搭建时，已经存在并使用的版本库需要导入到Gitolite中。如果只是简单地把这些裸版本库（以 ``.git`` 为后缀不带工作区的版本库）复制到Gitolite的版本库根目录下，针对这些版本库的授权可能不能正常工作。这是因为Gitolite管理的版本库都配置了特定的钩子脚本，以实现基于分支和/或路径的授权，直接拷贝到Gitolite中的版本库没有正确地设置钩子脚本。而且Gitolite还利用版本库中的 :file:`gl-creater` 记录版本库创建者，用 :file:`gl-perms` 记录版本库的自定义授权，而这些也是拷贝过来的版本库不具备的。

对于少量的版本库，直接修修改 ``gitolite-admin`` 的授权文件、添加同名的版本库授权、提交并推送，就会在Gitolite服务器端完成同名版本库的初始化。然后在客户端进入到相应版本库的工作区，执行 :command:`git push` 命令将原有版本库的各个分支和里程碑导入到Gitolite新建的版本库中。

::

  $ git remote add origin git@server:<repo-name>.git
  $ git push --all  origin
  $ git push --tags origin

如果要导入的版本库较多，逐一在客户端执行 ``git push`` 操作很繁琐。可以采用下面的方法。

* 确认要导入所有版本库都以裸版本库形式存在（以 ``.git`` 为后缀，无工作区）。
* 将要导入的裸版本库复制到Gitolite服务器的版本库根目录中。
* 在客户端修改 ``gitolite-admin`` 授权文件，为每个导入的版本库添加授权。
* 推送对 ``gitolite-admin`` 版本库的修改，相应版本库的钩子脚本会自动进行设置。

如果版本库非常多，就连在 ``gitolite-admin`` 的授权文件中添加版本库授权也是难事，还可以采用下面的办法：

* 确认要导入所有版本库都以裸版本库形式存在（以 ``.git`` 为后缀，无工作区）。
* 将要导入的裸版本库复制到Gitolite服务器的版本库根目录中。
* 在服务器端，为每个导入的裸版本库下添加文件 :file:`gl-creater` ，内容为版本库创建者ID。
* 在服务器端运行 :command:`gl-setup` 程序（无需提供公钥参数），参见Gitolite安装相应章节。
* 在客户端修改 ``gitolite-admin`` 授权文件，以通配符版本库形式为导入的版本库进行授权。

对 Gitolite 的改进
==================

Gitolite托管在GitHub上，任何人都可以基于原作者 Sitaramc 的工作进行定制。我对Gitolite的定制版本在 http://github.com/ossxp-com/gitolite ， 包含的扩展和改进有：

* 通配符版本库的创建方式和授权。

  原来的实现是克隆即创建（克隆者需要被授予 C 的权限）。同时还要通过另外的授权语句为用户设置 RW 权限，否则创建者没有读和写权限。

  新的实现是通过推送创建版本库（推送者需要被授予 C 权限）。不必再为创建者赋予 RW 等权限，创建者自动具有对版本库最高的授权。

* 避免通配符版本库的误判。

  若将通配符版本库误判为普通版本库名称，会导致在服务器端创建错误的版本库。新的设计可以在通配符版本库的正则表达式之前添加 :samp:`^` 或之后添加 :samp:`$` 字符避免误判。

* 改变默认配置。

  默认安装即支持通配符版本库。

* 版本库重定向。

  Gitosis 的一个很重要的功能——版本库名称重定向，没有在 Gitolite 中实现。我为 Gitolite 增加了这个功能。

  在Git服务器架设的初期，版本库的命名可能非常随意，例如，redmine 的版本库直接放在根下： :file:`redmine-0.9.x.git` 、 :file:`redmine-1.0.x.git`,  …… 随着 redmine 项目越来越复杂，可能就需要将其放在子目录下进行管理，例如放到 :file:`ossxp/redmine/` 目录下。只需要在 Gitolite 的授权文件中添加下面一行 map 语句，就可以实现版本库名称的重定向。使用旧地址的用户不必重新检出，可以继续使用。

  ::

    map (redmine.*) = ossxp/redmine/$1

Gitolite 功能拓展
==================

版本库镜像
----------

版本库镜像的用途和原理
^^^^^^^^^^^^^^^^^^^^^^^

Git 版本库控制系统往往并不需要设计特别的容灾备份，因为每一个Git用户就是一个备份。但是下面的情况，就很有必要考虑容灾了。

* Git 版本库的使用者很少（每个库可能只有一个用户）。
* 版本库克隆只限制在办公区并且服务器也在办公区内（所有鸡蛋都在一个篮子里）。
* Git 版本库采用集中式的应用模型，需要建立双机热备（以便在故障出现时，实现快速的服务器切换）。

Gitolite 提供了服务器间版本库同步的设置。原理是：

* 主服务器通过配置文件 :file:`~/.gitolite.rc` 中的变量 :samp:`$ENV{GL_SLAVES}` 设置镜像服务器的地址。
* 从服务器通过配置文件 :file:`~/.gitolite.rc` 中的变量 :samp:`$GL_SLAVE_MODE` 设置为从服务器模式。
* 从主服务器端运行脚本 :program:`gl-mirror-sync` 可以实现批量的版本库镜像。
* 主服务器的每一个版本库都配置 :file:`post-receive` 钩子，一旦有提交，即时同步到镜像版本库。

版本库镜像的实现方法
^^^^^^^^^^^^^^^^^^^^^^^

在多个服务器之间设置 Git 库镜像的方法是：

1. 每个服务器都要安装 Gitolite 软件，而且要启用 :file:`post-receive` 钩子。默认的钩子在源代码的 :file:`hooks/common` 目录下，名称为 :file:`post-receive.mirrorpush` ，要将其改名为 :file:`post-receive` 。否则版本库的 :file:`post-receive` 脚本不能生效。

2. 主服务器配置到从服务器的公钥认证，配置使用特殊的 shell： :program:`gl-mirror-shell` 。

   这是因为主服务器在向从服务器同步版本库的时候，如果从服务器上相应的版本库没有创建，需要直接通过 SSH 登录到从服务器，执行创建命令创建版本库。因此需要通过一个特殊的shell，能够同时支持 Gitolite 的授权访问及 shell 环境。这个特殊的 shell 就是 :program:`gl-mirror-shell` 。而且这个 shell可以通过特殊的环境变量绕过服务器的权限检查，避免因为授权问题而导致同步失败。

   实际应用中，不光主服务器，每个服务器都要进行类似设置，目的是主从服务器可能相互切换。注意：在 Gitolite 不同的安装模式下， :program:`gl-mirror-shell` 的安装位置可能不同。

   下面的命令用于更改服务器端Gitolite安装用户的 :file:`~/.ssh/authorized_keys` 配置文件，以便使用特定公钥的其他服务器在访问本服务器时使用这个特殊的 shell。假设在服务器 foo 上，配置服务器bar和baz使用特殊的shell，而来自这两个服务器的连接分别使用 :file:`bar.pub` 和 :file:`baz.pub` 两个公钥文件。

   - 对于以客户端安装方式部署的 Gitolite，可以通过下面的方法确定 :program:`gl-mirror-shell` 的位置，然后修改 :file:`~/.ssh/authorized_keys` 文件。

     ::

       # 在服务器 foo 上执行:
       $ export GL_ADMINDIR=$(cd $HOME;perl -e 'do ".gitolite.rc"; print $GL_ADMINDIR')
       $ cat bar.pub baz.pub |
           sed -e 's,^,command="'$GL_ADMINDIR'/src/gl-mirror-shell" ,' >> ~/.ssh/authorized_keys

   - 对于以服务器端安装方式部署的 Gitolite，可以在路径中找到 :program:`gl-mirror-shell` ，进而设置 :file:`~/.ssh/authorized_keys` 文件。

     ::

       # 在服务器 foo 上执行:
       $ cat bar.pub baz.pub |
           sed -e 's,^,command="'$(which gl-mirror-shell)'" ,' >> ~/.ssh/authorized_keys

3. 在 foo 服务器上设置完毕后，可以从服务器 bar 或 baz 上远程执行下列命令进行测试：

   - 执行命令后退出

     ::

       $ ssh git@foo pwd

   - 进入 shell

     ::

       $ ssh git@foo bash -i

4. 在从服务器上设置配置文件 :file:`~/.gitolite.rc` 。

   进行如下设置后，将不允许用户直接推送到从服务器。但是主服务器仍然可以推送到从服务器，是因为主服务器版本库在推送到从服务器时，使用了特殊的环境变量，能够跳过从服务器版本库的 :file:`update` 脚本。

   ::

     $GL_SLAVE_MODE = 1

5. 在主服务器上设置配置文件 :file:`~/.gitolite.rc` 。
 
   需要配置到从服务器的 SSH 连接，可以设置多个，用空格分隔。注意使用单引号，以避免 @ 字符被 Perl 当作数组解析。
 
   ::
 
     $ENV{GL_SLAVES} = 'gitolite@bar gitolite@baz';
 
6. 在主服务器端执行 :program:`gl-mirror-sync` 进行一次完整的数据同步。
 
   需要以 Gitolite 安装的用户身份（如git）执行。例如在服务器 foo 上执行到从服务器 bar 的同步。
 
   ::
 
     $ gl-mirror-sync gitolite@bar
 
7. 之后，用户每次向主版本库同步，都会通过版本库的 :file:`post-receive` 钩子即时同步到从版本库。
 
当主版本库出现故障时，就需要把从服务器切换为主服务器模式，这就需要进行主从版本库的切换设置。切换非常简单，就是修改 :file:`~/.gitolite.rc` 配置文件，修改 :samp:`$GL_SLAVE_MODE` 设置：主服务器设置为 0，从服务器设置为 1。注意在主服务器恢复之前，要修改主服务器的配置使之降级为从服务器，否则主服务器恢复工作后会造成同时存在多个主服务器，从而导致数据的相互覆盖。


Gitweb 和 Git daemon 支持
--------------------------

Gitolite 和 git-daemon 的整合很简单，就是由 Gitolite 创建的版本库会在版本库目录中创建一个空文件 :file:`git-daemon-export-ok` 。

Gitolite 和 Gitweb 的整合则提供了两个方面的内容。一个是可以设置版本库的描述信息，用于在 Gitweb 的项目列表页面中显示。另外一个是自动生成项目的列表文件供 Gitweb 参考，避免 Gitweb 使用低效率的目录递归搜索查找 Git 版本库列表。

可以在授权文件中设定版本库的描述信息，并在 gitolite-admin 管理库更新时创建到版本库的 description 文件中。

::

  reponame = "one line of description"
  reponame "owner name" = "one line of description"

* 第1行，为名为 :samp:`reponame` 的版本库设定描述。
* 第2行，同时设定版本库的属主名称，以及一行版本库描述。

对于通配符版本库，使用这种方法则很不现实。Gitolite 提供了 SSH 子命令供版本库的创建者使用。

::

  $ ssh git@server setdesc path/to/repos.git
  $ ssh git@server getdesc path/to/repos.git

* 第一条指令用于设置版本库的描述信息。
* 第二条指令显示版本库的描述信息。

至于生成 Gitweb 所用的项目列表文件，默认创建在用户主目录下的 :file:`projects.list` 文件中。对于所有启用 Gitweb 的 [repo] 小节所设定的版本库，以及通过版本库描述隐式声明的版本库都会加入到版本库列表中。

其他功能拓展和参考
------------------

Gitolite 源码的 doc 目录包含用 markdown 标记语言编写的手册，可以直接在 Github 上查看。也可以使用 markdown 的文档编辑工具将 :file:`.mkd` 文档转换为 html 文档。转换工具很多，有 :program:`rdiscount` 、 :program:`Bluefeather` 、 :program:`Maruku` 、 :program:`BlueCloth2` ，等等。

在这些参考文档中，用户可以发现 Gitolite 包含的更多的小功能或秘籍，包括：

* 版本库设置。

  授权文件通过 :command:`git config` 指令为版本库进行附加的设置。例如：

  ::

    repo gitolite
        config hooks.mailinglist = gitolite-commits@example.tld
        config hooks.emailprefix = "[gitolite] "
        config foo.bar = ""
        config foo.baz =

* 多级管理员授权。

  可以为不同的版本库设定管理员，操作 gitolite-admin 库的部分授权文件。具体参考： :file:`doc/5-delegation.mkd` 。

* 自定义钩子脚本。

  因为 Gitolite 占用了几个钩子脚本，如果需要对同名钩子进行扩展，Gitolite 提供了级联的钩子脚本，将定制放在级联的钩子脚本里。

  例如：通过自定义 gitolite-admin 的 :file:`post-update.secondary` 脚本，以实现无须登录服务器即可更改 :file:`.gitolite.rc` 文件。具体参考： :file:`doc/shell-games.mkd` 。

  关于钩子脚本的创建和维护，具体参考： :file:`doc/hook-propagation.mkd` 。

* 管理员自定义命令。

  通过设置配置文件中的 :samp:`$GL_ADC_PATH` 变量，在远程执行该目录下的可执行脚本，如： :program:`rmrepo` 。

  具体参考： :file:`doc/admin-defined-commands.mkd` 。

* 创建匿名的 SSH 认证。

  允许匿名用户访问 Gitolite 提供的 Git 服务。即建立一个和 Gitolite 服务器端帐号同 ID 同主目录的用户，设置其的特定 shell，并且允许口令为空。

  具体参考： :file:`doc/mob-branches.mkd` 。

* 可以通过名为 @all 的版本库进行全局的授权。

  但是不能在 @all 版本库中对 @all 用户组进行授权。

* 版本库或用户非常之多（几千个）的时候，需要使用 **大配置文件** 模式。

  因为 Gitolite 的授权文件要先编译才能生效，而编译文件的大小是和用户及版本库数量的乘积成正比的。选择大配置文件模式则不对用户组和版本库组进行扩展。

  具体参考： :file:`doc/big-config.mkd` 。

* 授权文件支持包含语句，可以将授权文件分成多个独立的单元。

* 执行外部命令，如 rsync。

* Subversion 版本库支持。

  如果在同一个服务器上以 svn+ssh 方式运行 Subversion 服务器，可以使用同一套公钥，同时为用户提供 Git 和 Subversion 服务。

* HTTP 口令文件维护。通过名为 htpasswd 的 SSH 子命令实现。

----

.. [#] 对Gitolite的各项改动采用了Topgit特性分支进行维护，以便和上游最新代码同步更新。还要注意如果在Gitolite使用中发现问题，要区分是由上游软件引发的还是我的改动引起的，而不要把我的错误算在Sitaram头上。
.. [#] 公钥的内容为一整行，因排版需要做了换行处理。
.. [#] 可以为版本库设置配置变量 ``gitolite-options.deny-repo`` 在第一个授权阶段启用禁用规则检查。
.. [#] 参见第8部分41.2.2“Git模板”相关内容。
