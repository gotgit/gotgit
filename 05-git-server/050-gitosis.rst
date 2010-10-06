Gitosis 服务架设
==================

Gitosis 是 Gitolite 的鼻祖，同样也是一款基于SSH公钥认证的 Git 服务管理工具，但是功能要比之前介绍的 Gitolite 要弱的多。Gitosis 由 Python 语言开发，对于偏爱 Python 不喜欢 Perl 的开发者（我就是其中之一），可以对 Gitosis 加以关注。

Gitosis 的出现远远早于 Gitolite，作者 Tommi Virtanen 从 2007 年5月就开始了 gitosis 的开发，最后一次提交是在 2009 年9月，已经停止更新了。但是 Gitosis 依然有其生命力。

* 配置简洁，可以直接在服务器端编辑，成为为某些服务定制的内置的无需管理的 Git 服务。

  Gitosis 的配置文件非常简单，直接保存于服务安装用户（如 git）的主目录下 `.gitosis.conf` 文件中，可以直接在服务器端创建和编辑。

  Gitolite 的授权文件需要复杂的编译，因此一般需要管理员克隆 gitolite-admin 库，远程编辑并推送至服务器。因此用 Gitolite 实现一个无需管理的 Git 服务难度要大很多。
  
* 支持版本库重定向。

  版本库重定向一方面在版本库路径变更后保持旧的URL仍可工作，另一方面用在客户端用简洁的地址屏蔽服务器端复杂的地址。

  例如我开发的一款备份工具，版本库位于 `/etc/gistore/tasks/system/repo.git` （符号链接），客户端使用 `system.git` 即映射到复杂的服务器端地址。

  这个功能我已经在定制的 Gitolite 中实现。

* Python 语言开发，对于喜欢 Python，不喜欢 Perl 的用户，可以选择 Gitosis。

* 在 Github 上有很多 Gitosis 的克隆，我也将我对 gitosis 的改动放在了 github 上：

  http://github.com/ossxp-com/gitosis

Gitosis 因为是 Gitolite 的鼻祖，因此下面的 Gitosis 实现机理，似曾相识：

* Gitosis 安装在服务器(server.name) 某个帐号之下，例如 `git` 帐号

* 管理员通过 git 命令检出名为 gitosis-admin 的版本库

  ::

    $ git clone git@server.name:gitosis-admin.git

* 管理员将 git 用户的公钥保存在 gitosis-admin 库的 keydir 目录下，并编辑 gitosis.conf 文件为用户授权

* 当管理员对 gitosis-admin 库的修改提交并 PUSH 到服务器之后，服务器上 gitosis-admin 版本库的钩子脚本将执行相应的设置工作

  - 新用户公钥自动追加到服务器端安装帐号的 .ssh/authorized_keys 中，并设置该用户的 shell 为 gitosis 的一条命令 `gitosis-serve` 。

    ::

      command="gitosis-serve jiangxin",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty ssh-rsa <公钥内容来自于 jiangxin.pub ...>

  - 更新服务器端的授权文件 `~/.gitosis.conf`

* 用户可以用 git 命令访问授权的版本库

* 当管理员授权，用户可以远程在服务器上创建新版本库

下面介绍 Gitosis 的部署和使用。在示例中，服务器的IP地址为 `192.168.0.2` 。


安装 Gitosis
--------------

Gitosis 的部署和使用可以直接参考源代码中的 README.rst 。你可以直接访问 Github 上我的 gitosis 克隆，因为 Github 能够直接将 rst 文件显示为网页。

参考::

  http://github.com/ossxp-com/gitosis/blob/master/README.rst

Gitosis 的安装
++++++++++++++

Gitosis 安装需要在服务器端执行。下面介绍直接从源代码进行安装，以便获得最新的改进。

Gitosis 的官方 Git 库位于 git://eagain.net/gitosis.git。我在 Github 上创建了一个分支：

  http://github.com/ossxp-com/gitosis

* 使用 git 下载 Gitosis 的源代码。

  ::

    $ git clone git://github.com/ossxp-com/gitosis.git

* gitosis 目录，执行安装。

  ::

    $ cd gitosis
    $ sudo python setup.py install

* 可执行脚本安装在 /usr/local/bin 目录下。

  ::

    $ ls /usr/local/bin/gitosis-*
    /usr/local/bin/gitosis-init  /usr/local/bin/gitosis-run-hook  /usr/local/bin/gitosis-serve

服务器端创建专用帐号
++++++++++++++++++++

安装 Gitosis，还需要在服务器端创建专用帐号，所有用户都通过此帐号访问 Git 库。一般为方便易记，选择 git 作为专用帐号名称。

::

  $ sudo adduser --system --shell /bin/bash --disabled-password --group git

创建用户 git，并设置用户的 shell 为可登录的 shell，如 /bin/bash，同时添加同名的用户组。

有的系统，只允许特定的用户组（如 ssh 用户组）的用户才可以通过 SSH 协议登录，这就需要将新建的 git 用户添加到 ssh 用户组中。

::

  $ sudo adduser git ssh

Gitosis 服务初始化
++++++++++++++++++

Gitosis 服务初始化，就是初始化一个 gitosis-admin 库，并为管理员分配权限，还要将 Gitosis 管理员的公钥添加到专用帐号的 `~/.ssh/authorized_keys` 文件中。

* 如果管理员在客户端没有公钥，使用下面命令创建

  ..

    $ ssh-keygen

* 管理员上传公钥到服务器

  ..

    $ scp ~/.ssh/id_rsa.pub server:/tmp

* 服务器端进行 Gitosis 服务初始化

  以 git 用户身份执行 gitosis-init 命令，并向其提供管理员公钥。

  ..
  
    $ sudo su - git 
    $ gitosis-init < /tmp/id_rsa.pub    

* 确保 gitosis-admin 版本库的钩子脚本可执行。

    $ sudo chmod 755 ~git/repositories/gitosis-admin.git/hooks/post-update

管理 Gitosis
--------------

管理员克隆 gitolit-admin 管理库
++++++++++++++++++++++++++++++++

当 gitosis 安装完成后，在服务器端自动创建了一个用于 gitosis 自身管理的 git 库: gitosis-admin.git 。

管理员在客户端克隆 gitosis-admin.git 库，注意要确保认证中使用正确的公钥：

::

  $ git clone git@server:gitosis-admin.git
  $ cd gitosis-admin/

  $ ls -F
  gitosis.conf  keydir/

  $ ls keydir/
  jiangxin.pub

我们可以看出 gitosis-admin 目录下有一个陪孩子文件和一个目录 keydir。

* keydir/jiangxin.pub 文件

  keydir 目录下初始时只有一个用户公钥，即管理员的公钥。管理员的用户名来自公钥文件末尾的用户名。

* gitosis.conf 文件

  该文件为授权文件。初始内容为:

  ::

    1  [gitosis]
    2
    3  [group gitosis-admin]
    4  writable = gitosis-admin
    5  members = jiangxin

  我们可以看到授权文件的语法完全不同于之前介绍的 Gitolite 的授权文件。整个授权文件是以用户组为核心，而非版本库为核心。
  
  * 定义了一个用户组 gitosis-admin 。
  
    第3行开始定义了一个用户组 gitosis-admin 。

  * 第5行设定了该用户组包含的用户列表。

    初始时只有一个用户，即管理员公钥所属的用户。

  * 第4行设定了该用户组对那些版本库具有写操作。
  
    这里配置对 gitosis-admin 版本库具有写操作。写操作自动包含了读操作。

增加新用户
++++++++++
增加新用户，就是允许新用户能够通过其公钥访问 Git 服务。只要将新用户的公钥添加到 gitosis-admin 版本库的 keydir 目录下，即完成新用户的添加。

* 管理员从用户获取公钥，并将公钥按照 username.pub 格式进行重命名。

  用户可以通过邮件或者其他方式将公钥传递给管理员，切记不要将私钥误传给管理员。如果发生私钥泄漏，马上重新生成新的公钥/私钥对，并将新的公钥传递给管理员，并申请将旧的公钥作废。

  关于公钥名称，我引入了类似 Gitolite 的实现：

  - 用户从不同的客户端主机访问有着不同的公钥，如果希望使用同一个用户名进行授权，可以按照 `username@host.pub` 方式命名公钥文件，和名为 `username@pub` 的公钥指向同一个用户 `username` 。
  
 -  也支持邮件地址格式的公钥，即形如 `username@gmail.com.pub` 的公钥。Gitosis 能够很智能的区分是以邮件地址命名的公钥还是相同用户在不同主机上的公钥。如果是邮件地址命名的公钥，将以整个邮件地址作为用户名。

* 管理员进入 gitosis-admin 本地克隆版本库中，复制新用户公钥到 keydir 目录。

  ::

    $ cp /path/to/dev1.pub keydir/
    $ cp /path/to/dev2.pub keydir/

* 执行 git add 命令，将公钥添加入版本库。

  ::

    $ git add keydir
    $ git status
    # On branch master
    # Changes to be committed:
    #   (use "git reset HEAD <file>..." to unstage)
    #
    #       new file:   keydir/dev1.pub
    #       new file:   keydir/dev2.pub
    #

* 执行 git commit，完成提交。

  ::

    $ git commit -m "add user: dev1, dev2"
    [master d7952a5] add user: dev1, dev2
     2 files changed, 2 insertions(+), 0 deletions(-)
     create mode 100644 keydir/dev1.pub
     create mode 100644 keydir/dev2.pub
* 执行 git push，同步到服务器，才真正完成新用户的添加。

  ::

    $ git push
    Counting objects: 7, done.
    Delta compression using up to 2 threads.
    Compressing objects: 100% (5/5), done.
    Writing objects: 100% (5/5), 1.03 KiB, done.
    Total 5 (delta 0), reused 0 (delta 0)
    To git@server:gitosis-admin.git
       2482e1b..d7952a5  master -> master

如果我们这时查看服务器端 ~git/.ssh/authorized_keys 文件，会发现新增的用户公钥也附加其中：

::

  ### autogenerated by gitosis, DO NOT EDIT
  command="gitosis-serve jiangxin",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty     <用户jiangxin的公钥...>
  command="gitosis-serve dev1",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty ssh-rsa <用户 dev1 的公钥...>
  command="gitosis-serve dev2",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty ssh-rsa <用户 dev1 的公钥...>


更改授权
+++++++++

新用户添加完毕，可能需要重新进行授权。更改授权的方法也非常简单，即修改 gitosis.conf 配置文件，提交并 PUSH 。 

* 管理员进入 gitosis-admin 本地克隆版本库中，编辑 gitosis.conf 。

  ::

    $ vi gitosis.conf

* 授权指令比较复杂，我们先通过建立一个新用户组并授权新版本库 testing 尝试一下更改授权文件。

  在 gitosis.conf 中添加如下授权内容：

  ::

    1   [group testing-admin]
    2   members = jiangxin @gitosis-admin
    3   admin = testing
    4 
    5   [group testing-devloper]
    6   members = dev1 dev2
    7   writable = testing
    8 
    9   [group testing-reader]
    10  members = @all
    11  readonly = testing
    

  * 上面的授权文件为版本库 testing 赋予了三个角色。分别是 @testing-admin 用户组，@testing-developer 用户组和 @testing-reader 用户组。

  * 第1行开始的 testing-admin 小节，定义了用户组 @testing-admin 。

  * 第2行设定该用户组包含的用户有 jiangxin，以及前面定义的 @gitosis-admin 用户组用户。

  * 第3行用 admin 指令，设定该用户组用户可以创建版本库 testing 。

    admin 指令是笔者新增的授权指令，请确认安装的 Gitosis 包含笔者的改进。

  * 第7行用 writable 授权指令，设定该 @testing-developer 用户组用户可以读写版本库 testing 。

    笔者改进后的 Gitosis 也可以使用 write 作为 writable 指令的同义词指令。

  * 第11行用 readonly 授权指令，设定该 @testing-reader 用户组用户（所有用户）可以只读访问版本库 testing 。

    笔者改进后的 Gitosis 也可以使用 read 作为 readonly 指令的同义词指令。

* 编辑结束，提交改动。

  ::

    $ git add gitosis.conf
    $ git commit -q -m "auth for repo testing."

* 执行 git push，同步到服务器，才真正完成授权文件的编辑。

  ::

    $ git push
  
Gitosis 授权详解
-----------------

Gitosis 缺省设置
+++++++++++++++++

在 [gitosis] 小节中定义 Gitosis 的缺省设置。如下：

::

  1  [gitosis]
  2  repositories = /gitroot
  3  #loglevel=DEBUG
  4  gitweb = yes
  5  daemon = yes

其中：

* 第2行，设置版本库缺省的根目录是 /gitroot 目录。

  否则缺省路径是安装用户主目录下的 repositories 目录。

* 第3行，如果打开注释，则版本库操作时显示 Gitosis 调试信息。

* 第4行，启用 gitweb 的整合。

  可以通过 [repo name] 小节为版本库设置描述字段，用户显示在 gitweb 中。

* 第5行，启用 git-daemon 的整合。

  即新创建的版本库中，创建文件 `git-daemon-export-ok` 。

管理版本库 gitosis-admin
+++++++++++++++++++++++++

::

  1  [group gitosis-admin]
  2  write = gitosis-admin
  3  members = jiangxin
  4  repositories = /home/git

除了第4行，其他内容在前面都已经介绍过了，是 Gitosis 自身管理版本库的用户组设置。

第4行，重新设置了版本库的缺省根路经，覆盖缺省的 [gitosis] 小节中的缺省根路径。实际的 gitosis-admin 版本库的路径为 `/home/git/gitosis-admin.git` 。


定义用户组和授权
+++++++++++++++++

下面的两个示例小节定义了两个用户组，并且用到了路径变幻的指令。

::

  1   [group ossxp-admin]
  2   members = @gitosis-admin jiangxin
  3   admin = ossxp/**
  4   read = gistore/*
  5   map admin redmine-* = ossxp/redmine/\1
  6   map admin ossxp/redmine-* = ossxp/(redmine-.*):ossxp/redmine/\1
  7   map admin ossxp/testlink-* = ossxp/(testlink-.*):ossxp/testlink/\1
  8   map admin ossxp/docbones* = ossxp/(docbones.*):ossxp/docutils/\1
  9   
  10  [group all]
  11  read = ossxp/**
  12  map read redmine-* = ossxp/redmine/\1
  13  map read testlink-* = ossxp/testlink/\1
  14  map read pysvnmanager-gitsvn = mirrors/pysvnmanager-gitsvn
  15  map read ossxp/redmine-* = ossxp/(redmine-.*):ossxp/redmine/\1
  16  map read ossxp/testlink-* = ossxp/(testlink-.*):ossxp/testlink/\1
  17  map read ossxp/docbones* = ossxp/(docbones.*):ossxp/docutils/\1
  18  repositories = /gitroot

在上面的示例中，我们演示了授权指令以及 Gitosis 特色的 map 指令。

* 第1行，定义了用户组 @ossxp-admin 。

* 第2行，设定该用户组包含用户 jiangxin 以及用户组 @gitosis-admin 的所有用户。

* 第3行，设定该用户组可以创建及读写和通配符 ossxp/** 匹配的版本库。

  两个星号匹配任意字符包括路径分隔符（/）。此功能属于笔者扩展的功能。

* 第4行，设定该用户组可以只读访问 gistore/* 匹配的版本库。

  一个星号匹配任意字符包括路径分隔符（/）。 此功能也属于笔者扩展的功能。

* 第5行，是 Gitosis 特有的版本库名称重定位功能。

  即对 redmine-* 匹配的版本库，先经过名称重定位，在名称前面加上 `ossxp/remdine` 。其中 \1 命中的版本库名称。

  用户组 @ossxp-admin 的用户对于重定位后的版本库，具有 admin （创建和读写）权限。

* 第6行，是我扩展的版本库名称重定位功能，支持正则表达式。

  格式有点傻。等号左边的名称进行通配符匹配，匹配后，再经过右侧的一对正则表达式进行转换（冒号前的用于匹配，冒号后的用于替换）。

* 第10行，使用了内置的 @all 用户组，因此不需要通过 members 设定用户，因为所有用户均属于该用户组。

* 第11行，设定所有用户均可以只读访问 ossxp/** 匹配的版本库。

* 第12-17行，对特定路径进行映射，并分配只读权限。

* 第18行，设置版本库的根路径为 /gitroot，而非缺省的版本库根路径。

Gitweb 整合
+++++++++++

当在 [gitosis] 小节中启用 Gitweb 整合后，就可以通过 [repo name] 小节设置版本库和 gitweb 的整合。



版本库授权案例
---------------

Gitosis 的授权非常强大也非常复杂，因此从版本库授权的实际案例来学习非常行之有效。

其他人可以读取我的版本库
+++++++++++++++++++++++++


Gistore 内置的 Git 服务
+++++++++++++++++++++++++



创建新版本库
-------------

Gitosis 维护的版本库位于安装用户主目录下的 repositories 目录中，即如果安装用户为 `git` ，则版本库都创建在 /home/git/repositories 目录之下。可以通过配置文件 .gitosis.rc 修改缺省的版本库的根路径。

::

  $REPO_BASE="repositories";


有多种创建版本库的方式。一种是在授权文件中用 repo 指令设置版本库（未使用正则表达式的版本库）的授权，当对 gitosis-admin 版本库执行 git push 操作，自动在服务端创建新的版本库。另外一种方式是在授权文件中用正则表达式定义的版本库，不会即时创建，而是被授权的用户在远程创建后PUSH到服务器上完成创建。

注意，在授权文件中创建的版本库名称不要带 .git 后缀，在创建版本库过程中会自动在版本库后面追加 .git 后缀。

在配置文件中出现的版本库，即时生成
++++++++++++++++++++++++++++++++++

我们尝试在授权文件 `gitosis.conf` 中加入一段新的版本库授权指令，而这个版本库尚不存在。新添加到授权文件中的内容：

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
  To gitadmin.bj:gitosis-admin.git
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

通配符版本库是用正则表达式语法定义的版本库，所指的非某一个版本库而是和名称相符的一组版本库。首先要想使用通配符版本库，需要在服务器端安装用户（如 `git` ）用户的主目录下的配置文件 `.gitosis.rc` 中，包含如下配置：

::

  $GL_WILDREPOS = 1;

使用通配符版本库，可以对一组版本库进行授权，非常有效。但是版本库的创建则不像前面介绍的那样，不会在授权文件 PUSH 到服务器时创建，而是拥有版本库创建授权（C）的用户手工进行创建。

对于用通配符设置的版本库，用 C 指令指定能够创建此版本库的管理员（拥有创建版本库的授权）。例如：

::

  repo ossxp/.+
      C                   = jiangxin
      RW                  = dev1 dev2

管理员 jinagxin 可以创建路径符合正则表达式 "`ossxp/.+`" 的版本库，用户 dev1 和 dev2 对版本库具有读写（但是没有强制更新）权限。

使用该方法创建版本库后，创建者的 uid 将被记录在版本库目录下的 gl-creator 文件中。该帐号具有对该版本库最高的权限。该通配符版本库的授权指令中如果出现 `CREATOR` 将被创建者的 uid 替换。

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

Gitosis 的原始实现是通配符版本库的管理员在对不存在的版本库执行 clone 操作时，自动创建。但是我认为这不是一个好的实践，会经常因为 clone 的 URL 写错，导致在服务器端创建垃圾版本库。因此我重新改造了 gitosis 通配符版本库创建的实现，改为在对版本库进行 PUSH 的时候进行创建，而 clone 一个不存在的版本库，会报错退出。


直接在服务器端创建
+++++++++++++++++++

当版本库的数量很多的时候，在服务器端直接通过 git 命令创建或者通过复制创建可能会更方便。但是要注意，在服务器端手工创建的版本库和 Gitosis 创建的版本库最大的不同在于钩子脚本。如果不能为手工创建的版本库正确设定版本库的钩子，会导致失去一些 Gitosis 特有的功能。例如：失去分支授权的功能。

一个由 Gitosis 创建的版本库，hooks 目录下有三个钩子脚本实际上链接到 gitosis 安装目录下的相应的脚本文件中：

::

  gitosis-hooked -> /home/git/.gitosis/hooks/common/gitosis-hooked
  post-receive.mirrorpush -> /home/git/.gitosis/hooks/common/post-receive.mirrorpush
  update -> /home/git/.gitosis/hooks/common/update

那么手工在服务器上创建的版本库，有没有自动更新钩子脚本的方法呢？

有，就是重新执行一遍 gitosis 的安装，会自动更新版本库的钩子脚本。安装过程一路按回车即可。

::

  $ cd gitosis/src
  $ ./gl-easy-install git 192.168.0.2 admin


除了钩子脚本要注意以外，还要确保服务器端版本库目录的权限和属主。


对 Gitosis 的改进
------------------

笔者对 Gitosis 进行扩展和改进，涉及到的内容主要包括：

* 通配符版本库的创建方式和授权。

  原来的实现是克隆即创建（克隆者需要被授予 C 的权限）。同时还要通过另外的授权语句为用户设置 RW 权限，否则创建者没有读和写权限。

  新的实现是通过 PUSH 创建版本库（PUSH 者需要被授予 C 权限）。不必再为创建者赋予 RW 等权限，创建者自动具有对版本库最高的授权。

* 避免通配符版本库误判。

  通配符版本库误判，会导致在服务器端创建错误的版本库。新的设计还可以在通配符版本库的正则表达式前或后添加 `^` 或 `$` 字符，而不会造成授权文件编辑错误。

* 改变缺省配置。

  缺省安装即支持通配符版本库。

* 版本库重定向。

  Gitosis 的一个很重要的功能：版本库名称重定向，没有在 Gitosis 中实现。我们为 Gitosis 增加了这个功能。

  在Git服务器架设的开始，版本库的命名可能非常随意，例如 redmine 的版本库直接放在根下，例如： `redmine-0.9.x.git`, `redmine-1.0.x.git`, ...  当 `redmine` 项目越来越复杂，可能就需要将其放在子目录下进行管理，例如放到 `ossxp/redmine/` 目录下。

  只需要在 Gitosis 的授权文件中添加下面一行 map 语句，就可以实现版本库名称重定向。使用旧的地址的用户不必重新检出，可以继续使用。

  ::

    map (redmine.*) = ossxp/redmine/$1


