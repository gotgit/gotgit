Gitolite 服务架设
==================
Gitolite 是一款 Perl 语言开发的 Git 服务管理工具，通过公钥对用户进行认证，并能够通过配置文件对用户进行精细授权。Gitolite 实际上采用的是 SSH 协议，因此在开始本章之前确认已经通读过之前的“SSH 协议”一章。

TODO: Gitolite 的历史

Gitolite 的实现机制概括如下：

* Gitolite 安装在服务器(server.name) 某个帐号之下，例如 `git` 帐号

* 管理员通过 git 命令检出名为 gitolite-admin 的版本库

  ::

    $ git clone git@server.name:gitolite-admin.git

* 管理员将 git 用户的公钥保存在 gitolite-admin 库的 keydir 目录下，并编辑 conf/gitolite.conf 文件为用户授权

* 当管理员对 gitolite-admin 库的修改提交并 PUSH 到服务器之后，服务器上 gitolite-admin 版本库的钩子脚本将执行相应的设置工作

  - 新用户公钥自动追加到服务器端安装帐号的 .ssh/authorized_keys 中，并设置该用户的 shell 为 gitolite 的一条命令 `gl-auth-command`

    ::

      command="/home/git/.gitolite/src/gl-auth-command jiangxin",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty ssh-rsa AAAAB3N...

  - 更新服务器端的授权文件

* 用户可以用 git 命令访问授权的版本库

* 当用户以 git 用户登录 ssh 服务时，因为公钥认证的相关设置，不再直接进入 shell 环境，而是打印服务器端 git 库授权信息后马上退出

  即用户不会通过 git 用户进入服务器的 shell，也就不会对系统的安全造成威胁。

* 当管理员授权，用户可以远程在服务器上创建新版本库

下面介绍 Gitolite 的部署和使用。在示例中，服务器的IP地址为 `192.168.0.2` 。

服务器端创建专用帐号
--------------------
安装 Gitolite，首先要在服务器端创建专用帐号，所有用户都通过此帐号访问 Git 库。一般为方便易记，选择 git 作为专用帐号名称。

::

  $ sudo adduser --system --shell /bin/bash --group git

创建用户 git，并设置用户的 shell 为可登录的 shell，如 /bin/bash，同时添加同名的用户组。

有的系统，只允许特定的用户组（如 ssh 用户组）的用户才可以通过 SSH 协议登录，这就需要将新建的 git 用户添加到 ssh 用户组中。

::

  $ sudo adduser git ssh

为 git 用户设置口令。当整个 git 服务配置完成，运行正常后，建议取消 git 的口令，只允许公钥认证。

::

  $ sudo passwd git

管理员在客户端使用下面的命令，建立无口令登录：

::

  $ ssh-copy-id git@192.168.0.2

至此，我们已经完成了安装 git 服务的准备工作，可以开始安装 Gitolite 服务软件了。

Gitolite 的安装/升级
---------------------
Gitolite 安装可以在客户端执行，而不需要在服务器端操作，非常方便。安装 Gitolite 的前提是:

* 已经在服务器端创建了专有帐号，如 git
* 管理员能够以 git 用户身份通过公钥认证，无口令方式登录方式登录服务器

安装和升级都可以按照下面的步骤进行：

* 使用 git 下载软件

  ::

    $ git clone git@github.com:ossxp-com/gitolite.git

* 进入 gitolite/src 目录，执行安装

  ::

    $ cd gitolite/src
    $ ./gl-easy-install git 192.168.0.2 admin

* 首先显示版本信息

  ::

    ------------------------------------------------------------------------

    you are upgrading     (or installing first-time)     to v1.5.4-22-g4024621

    Note: getting '(unknown)' for the 'from' version should only happen once.
    Getting '(unknown)' for the 'to' version means you are probably installing
    from a tar file dump, not a real clone.  This is not an error but it's nice to
    have those version numbers in case you need support.  Try and install from a
    clone


* 自动创建名为 admin 的私钥/公钥对

  gl-easy-install 命令行的最后一个参数即用于设定管理员id，这里设置为 admin。

  ::

    ------------------------------------------------------------------------

    the next command will create a new keypair for your gitolite access

    The pubkey will be /home/jiangxin/.ssh/admin.pub.  You will have to choose a
    passphrase or hit enter for none.  I recommend not having a passphrase for
    now, *especially* if you do not have a passphrase for the key which you are
    already using to get server access!

    Add one using 'ssh-keygen -p' after all the setup is done and you've
    successfully cloned and pushed the gitolite-admin repo.  After that, install
    'keychain' or something similar, and add the following command to your bashrc
    (since this is a non-default key)

        ssh-add $HOME/.ssh/admin

    This makes using passphrases very convenient.


  如果公钥已经存在，会弹出警告

  ::

    ------------------------------------------------------------------------

    Hmmm... pubkey /home/jiangxin/.ssh/admin.pub exists; should I just (re-)use it?

    IMPORTANT: once the install completes, *this* key can no longer be used to get
    a command line on the server -- it will be used by gitolite, for git access
    only.  If that is a problem, please ABORT now.

    doc/6-ssh-troubleshooting.mkd will explain what is happening here, if you need
    more info.

* 自动修改客户端的 .ssh/config 文件，增加别名主机

  即当访问主机 gitolite 时，会自动用名为 admin.pub 的公钥，以 git 用户身份，连接服务器

  ::

    ------------------------------------------------------------------------

    creating settings for your gitolite access in /home/jiangxin/.ssh/config;
    these are the lines that will be appended to your ~/.ssh/config:

    host gitolite
         user git
         hostname 192.168.0.2
         port 22
         identityfile ~/.ssh/admin


* 上传脚本文件到服务器，完成服务器端软件的安装

  ::

    gl-dont-panic                                                                                                             100% 3106     3.0KB/s   00:00
    gl-conf-convert                                                                                                           100% 2325     2.3KB/s   00:00
    gl-setup-authkeys                                                                                                         100% 1572     1.5KB/s   00:00
    ...
    gitolite-hooked                                                                                                           100%    0     0.0KB/s   00:00
    update                                                                                                                    100% 4922     4.8KB/s   00:00


    ------------------------------------------------------------------------

    the gitolite rc file needs to be edited by hand.  The defaults are sensible,
    so if you wish, you can just exit the editor.   

    Otherwise, make any changes you wish and save it.  Read the comments to
    understand what is what -- the rc file's documentation is inline.

    Please remember this file will actually be copied to the server, and that all
    the paths etc. represent paths on the server!   

* 自动打开编辑器(vi)，编辑 .gitolite.rc 文件，编辑结束，上传到服务器


  以下为缺省配置，一般无须改变：

  * $REPO_BASE="repositories";

    用于设置 Git 服务器的根目录，缺省是 Git 用户主目录下的 repositories 目录，可以使用绝对路径。所有 Git 库都将部署在该目录下。

  * $REPO_UMASK = 0007;         # gets you 'rwxrwx---'

    版本库创建使用的掩码。即新建立版本库的权限为 'rwxrwx---'。

  * $GL_BIG_CONFIG = 0;

    如果授权文件非常复杂，更改此项配置为1，以免产生庞大的授权编译文件

  * $GL_WILDREPOS = 1;

    缺省支持通配符版本库授权

  该配置文件为 perl 语法，注意保持文件格式和语法。退出输入 ":q"。

* 至此完成安装

SSH 主机别名
------------
在安装过程中，gitolite 创建了名为 admin 的公钥/私钥对，以名为 admin.pub 的公钥连接服务器，使用的是 git 服务。
但是如果直接连接服务器，使用的是缺省的公钥，会直接进入 shell。

那么如何能够根据需要选择不同的公钥来连接 git 服务器呢？

别忘了我们在前面介绍过的 SSH 主机别名。实际上刚刚在安装 gitolite 的时候，就已经自动为我们创建了一个主机别名。
打开 ~/.ssh/config 文件，可以看到类似内容，如果对主机别名不满意，可以修改。

::

  host gitolite
       user git
       hostname 192.168.0.2
       port 22
       identityfile ~/.ssh/admin 

即：

* 像下面这样输入 SSH 命令，会直接进入 shell，因为使用的是缺省的公钥。

  ::

    $ ssh git@192.168.0.2

* 像下面这样输入 SSH 命令，则不会进入 shell。因为使用名为 admin.pub 的公钥，会显示 git 授权信息并马上退出。

  ::

    $ ssh gitolite


管理员克隆 gitolit-admin 管理库
--------------------------------
当 gitolite 安装完成后，在服务器端自动创建了一个用于 gitolite 自身管理的 git 库: gitolite-admin.git 。

克隆 gitolite-admin.git 库。别忘了使用 ssh 主机别名：

::

  $ git clone gitolite:gitolite-admin.git

  $ git clone gitolite:gitolite-admin.git 
  Initialized empty Git repository in /data/tmp/gitolite-admin/.git/
  remote: Counting objects: 6, done.
  remote: Compressing objects: 100% (4/4), done.
  remote: Total 6 (delta 0), reused 0 (delta 0)
  Receiving objects: 100% (6/6), done.

  $ cd gitolite-admin/

  $ ls -F
  conf/  keydir/

  $ ls conf 
  gitolite.conf

  $ ls keydir/
  admin.pub

我们可以看出 gitolite-admin 目录下有两个目录 conf 和 keydir。

* keydir/admin.pub 文件

  keydir 目录下初始时只有一个用户公钥，即 amdin 用户的公钥

* conf/gitolite.conf 文件

  该文件为授权文件。初始内容为:

  ::

    #gitolite conf
    # please see conf/example.conf for details on syntax and features

    repo gitolite-admin
        RW+                 = admin

    repo testing
        RW+                 = @all

  缺省授权文件中只设置了两个版本库的授权：

  * gitolite-admin
  
    即本版本库（gitolite管理版本库）只有 admin 用户有读写和强制更新的权限

  * testing

    缺省设置的测试版本库，设置为任何人都可以读写以及强制更新


增加新用户
----------
增加新用户，就是允许新用户能够通过其公钥访问 Git 服务。只要将新用户的公钥添加到
gitolite-admin 版本库的 keydir 目录下，即完成新用户的添加。

* 管理员从用户获取公钥，并将公钥按照 username.pub 格式进行重命名

  用户可以通过邮件或者其他方式将公钥传递给管理员，切记不要将私钥误传个管理员。如果发生私钥泄漏，马上重新生成新的公钥/私钥对，并将新的公钥传递给管理员。

  如果用户从不同的客户端访问有着不同的公钥，希望使用同一个用户名进行授权，可以按照 username@host.pub 方式命名。Gitolite 能够很智能的区分出以邮件地址命名的公钥 username@gmail.com.pub 和包含主机名的 username@host.pub 公钥，如果是邮件地址命名的公钥，则以整个邮件地址作为用户名。

* 管理员进入 gitolite-admin 本地克隆版本库中，复制新用户公钥到 keydir 目录

  ::

    $ cp /path/to/dev1.pub keydir/
    $ cp /path/to/dev2.pub keydir/
    $ cp /path/to/jiangxin.pub keydir/

* 执行 git add 命令，将公钥添加入版本库

  ::

    $ git add keydir
    $ git status
    # On branch master
    # Changes to be committed:
    #   (use "git reset HEAD <file>..." to unstage)
    #
    #       new file:   keydir/dev1.pub
    #       new file:   keydir/dev2.pub
    #       new file:   keydir/jiangxin.pub
    #

* 执行 git commit，完成提交

  ::

    $ git commit -m "add user: jiangxin, dev1, dev2"
    [master bd81884] add user: jiangxin, dev1, dev2
     3 files changed, 3 insertions(+), 0 deletions(-)
     create mode 100644 keydir/dev1.pub
     create mode 100644 keydir/dev2.pub
     create mode 100644 keydir/jiangxin.pub

* 执行 git push，同步到服务器，才真正完成新用户的添加

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

在执行 git push 后的输出中，以 remote 标识的输出是服务器端执行 `post-update` 钩子脚本的输出。其中的警告是说新添加的三个用户在授权文件中没有被引用。接下来我们便看看如何修改授权文件，以及如何为用户添加授权。

更改授权
---------
新用户添加完毕，可能需要重新进行授权。更改授权的方法也非常简单，即修改 conf/gitolite.cong 配置文件，提交并 push。

* 管理员进入 gitolite-admin 本地克隆版本库中，编辑 conf/gitolite.conf

  ::

    $ vi conf/gitolite.conf

* 授权指令比较复杂，我们先通过建立新用户组尝试一下更改授权文件。

  考虑到之前我们增加了三个用户公钥之后，服务器端发出了用户尚未在授权文件中出现的警告。我们就在这个示例中解决这个问题。
  
  * 例如我们在其中加入用户组 @team1，将新添加的用户 jiangxin, dev1, dev2 都归属到这个组中

    我们只需要在 conf/gitolite.conf 文件的文件头加入如下指令。用户之间用空格分隔。

    ::

      @team1 = dev1 dev2 jiangxin

  * 编辑完毕退出。我们可以用 git diff 命令查看改动：

    我们还修改了版本库 testing 的授权，将 @all 用户组改为我们新建立的 @team1 用户组。

    ::

      $ git diff
      diff --git a/conf/gitolite.conf b/conf/gitolite.conf
      index 6c5fdf8..f983a84 100644
      --- a/conf/gitolite.conf
      +++ b/conf/gitolite.conf
      @@ -1,10 +1,12 @@
       #gitolite conf
       # please see conf/example.conf for details on syntax and features
      
      +@team1 = dev1 dev2 jiangxin
      +
       repo gitolite-admin
           RW+                 = admin
      
       repo testing
      -    RW+                 = @all
      +    RW+                 = @team1
      
      

* 编辑结束，提交改动

  ::

    $ git add conf/gitolite.conf
    $ git commit -q -m "new team @team1 auth for repo testing."

* 执行 git push，同步到服务器，才真正完成授权文件的编辑

  我们可以注意到，PUSH 后的输出中没有了警告。

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


授权文件的基本语法
------------------

下面我们看一个不那么简单的授权文件:

::

  @admin = jiangxin wangsheng

  repo gitolite-admin
      RW+                 = jiangxin

  repo ossxp/.+
      C                   = @admin
      RW                  = @all

  repo testing
      RW      master              =   junio
      RW+     pu                  =   junio
      RW      cogito$             =   pasky
      RW      bw/                 =   linus
      -                           =   somebody
      RW      tmp/                =   @all
      RW      refs/tags/v[0-9]    =   junio

在上面的示例中，我们演示了很多授权指令

* 定义了用户组 @admin，包含两个用户 jiangxin 和 wangsheng
* 定义了版本库 gitolite-admin。并指定只有用户 jiangxin 才能够访问，并拥有读(R)写(W)和强制更新(+)的权限
* 通过正则表达式定义了一组版本库，即在 ossxp/ 目录下的所有版本库

  * 用户组 @admin 中的用户，可以在 ossxp 目录下创建版本库
  * 所有用户都可以读写 ossxp 目录下的版本库，但不能强制更新

* testing 测试版本的权限非常复杂

  * 用户 junio 可以读写 master 分支。（还包括名字以 master 开头的其他分支，如果有的话）
  * 用户 junio 可以读写并强制更新 pu 分支。（还包括名字以 pu 开头的其他分支，如果有的话）
  * 用户 pasky 可以读写并强制更新 cogito 分支。 (仅此分支，精确匹配）

定义用户组
+++++++++++
在 conf/gitolite.conf 文件的头部，定义用户组或者版本库组。

* 例如： @admin = jiangxin wangsheng
* 组可以嵌套： @staff = @admin @engineers tester1
* 除了作为用户组外，同样语法也适用于版本库组

版本库ACL
+++++++++

一个版本库可以包含多条授权指令，这些授权指令组成了一个版本库的权限控制列表（ACL）。

例如:

::

  repo gitolite-admin
      RW+                 = jiangxin

* repo 指令开始版本库授权
* repo 后面的参数可以是一个或多个版本库，也可以使用正则表达式
* repo 指令之后，是缩进的一条或者多条授权指令。

授权指令的语法:

::

  (C|R|RW|RW+|RWC|RW+C|RWD|RW+D|RWCD|RW+CD) [zero or more refexes] = [one or more users]

* 授权指令以等号（=）为标记分为前后两段，前面的是权限，后面的是用户列表。

* 单独的C是创建版本库

  仅对使用通配符的版本库有效，因为非通配符直接创建

* RW+和RW的不同

  RW+可以rewind，即non-fast forward可以强制push

版本库授权案例
--------------

Gitolite 的授权非常强大也非常复杂，因此从版本库授权的实际案例来学习非常行之有效。

版本库读写和rewind的授权
++++++++++++++++++++++++


  ::

    repo testing
        R = dev1 dev2
        RW = dev3 dev4
        W = dev5
        RW+ = jiangxin
        - = badboy

对 ref 的写授权
++++++++++++++

* 分支的读写授权


* 分支的删除授权


* 分支的创建授权

对路径的写授权
++++++++++++++

对通配符版本库的授权
++++++++++++++++++++


创建新版本库
-------------

Gitolite 维护的版本库位于安装用户主目录下的 repositories 目录中，即如果安装用户为 `git` ，则版本库都创建在 /home/git/repositories 目录之下。可以通过配置文件 .gitolite.rc 修改缺省的版本库的根路径。

::

  $REPO_BASE="repositories";


有多种创建版本库的方式。一种是在授权文件中用 repo 指令设置版本库（未使用正则表达式的版本库）的授权，当执行对 gitolite-admin 版本库执行 git push 操作，自动在服务端创建新的版本库。另外一种方式是在授权文件中用正则表达式定义的版本库，不会即时创建，而是被授权的用户在远程创建后PUSH到服务器上完成创建。

注意，在授权文件中创建的版本库名称不要带 .git 后缀，在创建版本库过程中会自动在版本库后面追加 .git 后缀。

在配置文件中出现的版本库，即时生成
++++++++++++++++++++++++++++++++++

我们尝试在授权文件 `conf/gitolite.conf` 中加入一段新的版本库授权指令，而这个版本库尚不存在。新添加到授权文件中的内容：

::

  repo testing2
      RW+                 = @all

然后将授权文件的修改提交并 PUSH 到服务器，我们会看到授权文件中添加新授权的版本库 testing2 被自动创建。

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

注意其中带 remote 标识的输出，我们看到版本库 testing2.git 被自动初始化了。

此外使用版本库组的语法（即用 @ 创建的组，用作版本库），也会被自动创建。例如下面的授权文件片段设定了一个包含两个版本库的组 `@testing` ，当将新配置文件 PUSH 到服务器上的时候，会自动创建 `testing3.git` 和 `testing4.git` 。

::

  @testing = testing3 testing4
   
  repo @testing
      RW+                 = @all

还有一种版本库语法，是用正则表达式定义的版本库，这类版本库因为所指的版本库并不确定，因此不会自动创建。


通配符版本库，管理员通过push创建
+++++++++++++++++++++++++++++++++

通配符版本库是用正则表达式语法定义的版本库，所指的非某一个版本库而是和名称相符的一组版本库。首先要想使用通配符版本库，需要在服务器端安装用户（如 `git` ）用户的主目录下的配置文件 `.gitolite.rc` 中，包含如下配置：

::

  $GL_WILDREPOS = 1;

使用通配符版本库，可以对一组版本库进行授权，非常有效。但是版本库的创建则不像前面介绍的那样，不会在授权文件 PUSH 到服务器时创建，而是拥有版本库创建授权（C）的用户手工进行创建。

对于用通配符设置的版本库，用 C 指令指定能够创建此版本库的管理员（拥有创建版本库的授权）。例如：

::

  repo ossxp/.+
      C                   = jiangxin
      RW                  = dev1 dev2

管理员 jinagxin 可以创建路径符合正则表达式 "`ossxp/.+`" 的版本库，用户 dev1 和 dev2 对版本库具有读写（但是没有强制更新）权限。

* 本地建库

  ::

     $ mkdir somerepo
     $ cd somerepo
     $ git init 
     $ git commit --allow-empty

* 使用 git remote 指令添加远程的源

  ::

     $ git remote add origin jiangxin@server:ossxp/somerepo.git

* 运行 git push 完成在服务器端版本库的创建

  ::

     $ git push origin master

**克隆即创建，还是PUSH即创建？**

Gitolite 的原始实现是通配符版本库的管理员在对不存在的版本库执行 clone 操作时，自动创建。但是我认为这不是一个好的实践，会经常因为 clone 的 URL 写错，导致在服务器端创建垃圾版本库。因此我重新改造了 gitolite 通配符版本库创建的实现，改为在对版本库进行 PUSH 的时候进行创建，而 clone 一个不存在的版本库，会报错退出。


直接在服务器端创建
+++++++++++++++++++

当版本库的数量很多的时候，在服务器端直接通过 git 命令创建或者通过复制创建可能会更方便。但是要注意，在服务器端手工创建的版本库和 Gitolite 创建的版本库最大的不同在于钩子脚本。如果不能为手工创建的版本库正确设定版本库的钩子，会导致失去一些 Gitolite 特有的功能。例如：失去分支授权的功能。

一个由 Gitolite 创建的版本库，hooks 目录下有三个钩子脚本实际上链接到 gitolite 安装目录下的相应的脚本文件中：

::

  gitolite-hooked -> /home/git/.gitolite/hooks/common/gitolite-hooked
  post-receive.mirrorpush -> /home/git/.gitolite/hooks/common/post-receive.mirrorpush
  update -> /home/git/.gitolite/hooks/common/update

那么手工在服务器上创建的版本库，有没有自动更新钩子脚本的方法呢？

有，就是重新执行一遍 gitolite 的安装，会自动更新版本库的钩子脚本。安装过程一路按回车即可。

::

  $ cd gitolite/src
  $ ./gl-easy-install git 192.168.0.2 admin


除了钩子脚本要注意以外，还要确保服务器端版本库目录的权限和属主。


Gitolite 授权机制
-----------------
Gitolite 的授权实际分为两个阶段，第一个阶段称为前git阶段，即在 Git 命令执行前，由 SSH 链接触发的 gl-auth-command 命令执行的授权检查。包括：

* 版本库的读

  用户必须拥有版本库至少一个分支的下列权限之一：`R`, `RW`, 或 `RW+` ，则整个版本库包含所有分支对用户均可读。

  而版本库分支实际上在这个阶段获取不到，即版本库的读取不能按照分支授权，只能是版本库的整体授权。

* 版本库的写

  版本库的写授权，则要在两个阶段分别进行检查。第一阶段的检查是看用户是否拥有下列权限之一： `RW`, `RW+` 或者 `C` 授权。

  第二个阶段检查分支以及是否拥有强制更新。具体见后面的描述。

* 版本库的创建

  仅对正则表达式定义的通配符版本库有效。即拥有 `C` 授权的用户，可以创建和对应正则表达式匹配的版本库。同时该用户也拥有对版本库的读写权限。

对授权的第二个阶段的检查，实际上是通过 update 钩子脚本进行的。

* 钩子脚本 `update` 只是针对 PUSH 操作的各个分支进行逐一检查，因此第二个阶段对版本库的读授权无任何影响。

* 在这个阶段终于可以获取到 ref（分支，里程碑等），可以进行分支授权的判断。

* 在这个阶段也可以获取到要更新的新的和老的 ref 的 SHA 摘要，因此也可以进行是否有回滚（rewind）的发生，即是否允许强制更新。

分支授权
--------

路径授权
--------

版本库镜像
----------

为 Subversion 提供服务
----------------------

Gitweb 和 Gitdaemon 支持
------------------------

  * for daemon, create the file `git-daemon-export-ok` in the repository
  * for gitweb, add the repo (plus owner name, if given) to the list of
    projects to be served by gitweb (see the config file variable
    `$PROJECTS_LIST`, which should have the same value you specified for
    `$projects_list` when setting up gitweb)
  * put the description, if given, in `$repo/description`


