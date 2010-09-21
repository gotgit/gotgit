Gitolite 服务架设
==================
Gitolite 是一款 Perl 语言开发的 Git 服务管理工具，可以实现对公钥认证的 Git 用户的区分，进行精细授权。

* 为通过公钥的访问 git 帐号的用户提供安全的 shell

  通过服务器端 git 用户的 .ssh/authorized_keys 中，为公钥设定安全的 shell。

  ::

    command="/home/git/.gitolite/src/gl-auth-command jiangxin",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty ssh-rsa AAAAB3N...

* 当用户试图以 git 用户登录 ssh 服务时，不再直接进入 shell 环境，而是打印服务器端 git 库授权信息后马上退出
* 只有管理员有权限克隆名为 gitolite-admin.git 的库
* 管理员将用户公钥以 username.git 的格式加入到 gitolite-admin 库的 keydir 目录

  用 git add 命令将 keydir 目录下的公钥加入版本库

* 管理员编辑 gitolite-admin 库的配置文件 conf/gitolite.conf, 为新用户授权

  用户名就是公钥文件名（去掉.pub）。完成编辑后，提交并 push，才完成授权


服务器端创建专用帐号
--------------------
在服务器端创建专用帐号，所有用户都通过此帐号访问 Git 库。

::

  $ sudo adduser --system --shell /bin/bash --group git

创建用户 git，并设置用户的 shell 为可登录的 shell，如 /bin/bash，同时添加同名的用户组。

有的系统，只允许特定的用户组（如ssh）的用户可以以ssh 登录，就需要将新建的 git 用户添加到 ssh 用户组中。

::

  $ sudo adduser git ssh

为 git 用户口令。当整个 git 服务配置完成，运行正常后，建议取消 git 的口令，只允许公钥认证。

::

  $ sudo passwd git

管理员在客户端使用下面的命令，建立无口令登录：

::

  $ ssh-copy-id git@192.168.0.2

至此，我们已经完成了安装 git 服务的准备工作。需要安装 Gitolite 服务器以便对 Git
库进行精细授权，请跳过下面内容，直接进入下一章。

实际上，如果 Git 服务器只提供少数信任的用户访问，实际上可以免去后面复杂的 gitolite 服务器架设。

* 管理员收集需要访问 git 服务的用户公钥。如: user1.pub, user2.pub
* 使用 ssh-copy-id 命令将各个 git 用户的公钥加入公钥认证列表中

  ::

    $ ssh-copy-id -i user1.pub git@192.168.0.2
    $ ssh-copy-id -i user2.pub git@192.168.0.2

* 在服务器端的 git 主目录下建立 git 库，就可以实现多个用户利用同一个系统帐号(git) 访问 Git 服务了

缺点是：

* 可以登录到 shell，导致安全隐患
* 所有用户的登录帐号没有区分，无法进行精细授权

下面介绍的 Gitolite，可以解决这两个问题。

Gitolite 的安装/升级
---------------------
Gitolite 安装可以在客户端执行，而不需要在服务器端操作，非常方便。安装 Gitolite 的前提是:

* 已经在服务器端创建了专有帐号，如 git
* 管理员能够以 git 用户身份通过公钥认证，无口令方式登录方式登录服务器

安装和升级都可以安装下面的步骤进行

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

这样当我们执行 ssh git@192.168.0.2 时，使用的是缺省的公钥，会直接进入 shell。

当我们执行 ssh gitolite 时，使用名为 admin.pub 的公钥，会显示 git 授权信息并马上退出。

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

  用户可以通过邮件或者其他方式将公钥传递给管理员，切记不要将私钥误传个管理员。
  如果发生私钥泄漏，马上重新生成新的公钥/私钥对，并将新的公钥传递给管理员。

  如果用户从不同的客户端访问有着不同的公钥，希望使用同一个用户名进行授权，
  可以按照 username@host.pub 方式命名。

* 管理员进入 gitolite-admin 本地克隆版本库中，复制新用户公钥到 keydir 目录

  ::

    $ cp /path/to/username.pub keydir/

* 执行 git add 命令，将公钥添加入版本库

  ::

    $ git add keydir/username.git

* 执行 git commit，完成提交

  ::

    $ git commit -m "add new user: xxx"

* 执行 git push，同步到服务器，才真正完成新用户的添加

  ::

    $ git push


更改授权
---------
新用户添加完毕，可能需要重新进行授权。更改授权的方法也非常简单，即修改 conf/gitolite.cong 配置文件，提交并 push。

* 管理员进入 gitolite-admin 本地克隆版本库中，编辑 conf/gitolite.conf

  ::

    $ vi conf/gitolite.conf

* 编辑结束，执行 git add 命令，将修改后的 conf/gitolite.conf 加入提交列表中

  ::

    $ git add conf/gitolite.conf

* 执行 git commit，完成提交

  ::

    $ git commit

* 执行 git push，同步到服务器，才真正完成授权文件的编辑

  ::

    $ git push


授权文件的语法
---------------
授权文件示例:

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

授权管理版本库ACL
++++++++++++++++++
例如:

::

  repo gitolite-admin
      RW+                 = jiangxin

* repo 指令开始版本库授权
* repo后面可以是一个或多个版本库，可以使用正则表达式
* 后面缩进的为授权指令。

  语法： 

  ::

    (C|R|RW|RW+|RWC|RW+C|RWD|RW+D|RWCD|RW+CD) [zero or more refexes] = [one or more users]

  * 单独的C是创建版本库
    仅对使用通配符的版本库有效，因为非通配符直接创建
  * RW+和RW的不同

    RW+可以rewind，即non-fast forward可以强制push

创建新版本库
-------------
有多种创建版本库的方式。

一种是在授权文件中用 repo 指令设置版本库（未使用正则表达式的版本库）的授权，
当执行对 gitolite-admin 版本库执行 git push 操作，自动在服务端创建新的版本库。

通配符版本库，管理员通过push创建
++++++++++++++++++++++++++++++++++
对于用通配符设置的版本库，用 C 指令指定能够创建此版本库的管理员。例如：

::

  repo ossxp/.+
      C                   = @admin
      RW                  = @all

属于 @admin 用户组的用户，可以在本地建库，通过 git push 在服务器端建立版本库:

* 本地建库

  ::

     $ mkdir somerepo
     $ cd somerepo
     $ git init 
     $ git commit --allow-empty

* 使用 git remote 指令添加远程的源

  ::

     $ git remote add origin ServerAlias:ossxp/somerepo.git

* 运行 git push 完成在服务器端版本库的创建

  ::

     $ git push origin master

直接在服务器端创建
+++++++++++++++++++
可以在服务器端通过 git init 直接建库，或者通过复制实现批量建库。

有几点要注意的是：

* git 版本库的根路径是由服务器端 ~git/.gitolite.rc 文件中的指令指定的

  ~git/.gitolite.rc 配置文件缺省指定 ~git/repositories/ 目录为版本库的根

  ::

    $REPO_BASE="repositories";

  可以修改该配置文件，使用绝对路径指定 git 版本库的根，或者用符号链接，
  让 ~git/repositories 链到真实的版本库的根路径。

* 确保服务器端版本库目录的权限和属主。

