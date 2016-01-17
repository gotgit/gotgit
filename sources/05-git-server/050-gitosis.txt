Gitosis服务架设
******************

Gitosis是Gitolite的鼻祖，同样也是一款基于SSH公钥认证的Git服务管理工具，\
但是功能要比之前介绍的Gitolite要弱的多。Gitosis由Python语言开发，对于偏\
爱Python不喜欢Perl的开发者（我就是其中之一），可以对Gitosis加以关注。

Gitosis的出现远早于Gitolite，作者Tommi Virtanen从2007年5月就开始了gitosis\
的开发，最后一次提交是在2009年9月，已经停止更新了。但是Gitosis依然有其\
生命力。

* 配置简洁，可以直接在服务器端编辑，成为为某些服务定制的内置的无需管理的\
  Git服务。

  Gitosis的配置文件非常简单，直接保存于服务安装用户（如\ ``git``\ ）的主\
  目录下\ :file:`.gitosis.conf`\ 文件中，可以直接在服务器端创建和编辑。

  Gitolite的授权文件需要复杂的编译，因此一般需要管理员克隆\ ``gitolite-admin``\
  库，远程编辑并推送至服务器。因此用Gitolite实现一个无需管理的Git服务\
  难度要大很多。

* 支持版本库重定向。

  版本库重定向一方面在版本库路径变更后保持旧的URL仍可工作，另一方面用在\
  客户端用简洁的地址屏蔽服务器端复杂的地址。

  例如我开发的一款备份工具（Gistore），版本库位于\
  :file:`/etc/gistore/tasks/system/repo.git`\ （符号链接），客户端使用\
  ``system.git``\ 即映射到复杂的服务器端地址。

  这个功能我已经在定制的Gitolite中实现。

* Python语言开发，对于喜欢Python，不喜欢Perl的用户，可以选择Gitosis。

* 在Github上有很多Gitosis的克隆，我对gitosis的改动放在了github上：

  http://github.com/ossxp-com/gitosis

Gitosis因为是Gitolite的鼻祖，因此下面的Gitosis实现机理，似曾相识：

* Gitosis安装在服务器（\ ``server.name``\ ）某个帐号之下，例如\ ``git``\
  帐号。

* 管理员通过Git命令检出名为\ ``gitosis-admin``\ 的版本库。

  ::

    $ git clone git@server.name:gitosis-admin.git

* 管理员将git用户的公钥保存在\ ``gitosis-admin``\ 库的\ :file:`keydir`\
  目录下，并编辑\ :file:`gitosis.conf`\ 文件为用户授权。

* 当管理员对\ ``gitosis-admin``\ 库的修改提交并PUSH到服务器之后，服务器\
  上\ ``gitosis-admin``\ 版本库的钩子脚本将执行相应的设置工作。

  - 新用户公钥自动追加到服务器端安装帐号的\ :file:`.ssh/authorized_keys`\
    中，并设置该用户的shell为gitosis的一条命令\ :command:`gitosis-serve`\ 。

    ::

      command="gitosis-serve jiangxin",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty ssh-rsa <公钥内容来自于 jiangxin.pub ...>

  - 更新服务器端的授权文件\ :file:`~/.gitosis.conf`\ 。

* 用户可以用Git命令访问授权的版本库。

* 当管理员授权，用户可以远程在服务器上创建新版本库。

下面介绍Gitosis的部署和使用。在下面的示例中，约定：服务器的名称为\
``server``\ ，Gitolite的安装帐号为\ ``git``\ 。 


安装Gitosis
==============

Gitosis的部署和使用可以直接参考源代码中的\ :file:`README.rst`\ 。可以直\
接访问Github上我的gitosis克隆，因为Github能够直接将rst文件显示为网页。

参考::

  http://github.com/ossxp-com/gitosis/blob/master/README.rst

Gitosis的安装
--------------

Gitosis安装需要在服务器端执行。下面介绍直接从源代码进行安装，以便获得最\
新的改进。

Gitosis的官方Git库位于\ ``git://eagain.net/gitosis.git``\ 。我在Github上\
创建了一个分支：

  http://github.com/ossxp-com/gitosis

* 使用git下载Gitosis的源代码。

  ::

    $ git clone git://github.com/ossxp-com/gitosis.git

* 进入 :file:`gitosis`\ 目录，执行安装。

  ::

    $ cd gitosis
    $ sudo python setup.py install

* 可执行脚本安装在\ :file:`/usr/local/bin`\ 目录下。

  ::

    $ ls /usr/local/bin/gitosis-*
    /usr/local/bin/gitosis-init  /usr/local/bin/gitosis-run-hook  /usr/local/bin/gitosis-serve

服务器端创建专用帐号
--------------------

安装Gitosis，还需要在服务器端创建专用帐号，所有用户都通过此帐号访问Git库。\
一般为方便易记，选择git作为专用帐号名称。

::

  $ sudo adduser --system --shell /bin/bash --disabled-password --group it

创建用户\ ``git``\ ，并设置用户的shell为可登录的shell，如\ ``/bin/bash``\ ，\
同时添加同名的用户组。

有的系统，只允许特定的用户组（如\ ``ssh``\ 用户组）的用户才可以通过SSH协\
议登录，这就需要将新建的\ ``git``\ 用户添加到\ ``ssh``\ 用户组中。

::

  $ sudo adduser git ssh

Gitosis服务初始化
------------------

Gitosis服务初始化，就是初始化一个\ ``gitosis-admin``\ 库，并为管理员分配\
权限，还要将Gitosis管理员的公钥添加到专用帐号的\
:file:`~/.ssh/authorized_keys`\ 文件中。

* 如果管理员在客户端没有公钥，使用下面命令创建。

  ::

    $ ssh-keygen

* 管理员上传公钥到服务器。

  ::

    $ scp ~/.ssh/id_rsa.pub server:/tmp

* 服务器端进行Gitosis服务初始化。

  以git用户身份执行\ ``gitosis-init``\ 命令，并向其提供管理员公钥。

  ::

    $ sudo su - git 
    $ gitosis-init < /tmp/id_rsa.pub    

* 确保\ ``gitosis-admin``\ 版本库的钩子脚本可执行。

  ::

    $ sudo chmod a+x ~git/repositories/gitosis-admin.git/hooks/post-update

管理Gitosis
==============

管理员克隆\ ``gitolit-admin``\ 管理库
----------------------------------------

当Gitosis安装完成后，在服务器端自动创建了一个用于Gitosis自身管理的Git库：\
``gitosis-admin.git``\ 。

管理员在客户端克隆\ ``gitosis-admin.git``\ 库，注意要确保认证中使用正确\
的公钥：

::

  $ git clone git@server:gitosis-admin.git
  $ cd gitosis-admin/

  $ ls -F
  gitosis.conf  keydir/

  $ ls keydir/
  jiangxin.pub

可以看出\ ``gitosis-admin``\ 目录下有一个陪孩子文件和一个目录\
:file:`keydir`\ 。

* :file:`keydir/jiangxin.pub`\ 文件

  :file:`keydir`\ 目录下初始时只有一个用户公钥，即管理员的公钥。管理员的\
  用户名来自公钥文件末尾的用户名。

* :file:`gitosis.conf`\ 文件

  该文件为授权文件。初始内容为:

  ::

    1  [gitosis]
    2
    3  [group gitosis-admin]
    4  writable = gitosis-admin
    5  members = jiangxin

  可以看到授权文件的语法完全不同于之前介绍的Gitolite的授权文件。整个授权\
  文件是以用户组为核心，而非版本库为核心。

  * 定义了一个用户组\ ``gitosis-admin``\ 。

    第3行开始定义了一个用户组\ ``gitosis-admin``\ 。

  * 第5行设定了该用户组包含的用户列表。

    初始时只有一个用户，即管理员公钥所属的用户。

  * 第4行设定了该用户组对那些版本库具有写操作。

    这里配置对\ ``gitosis-admin``\ 版本库具有写操作。写操作自动包含了读\
    操作。

增加新用户
----------
增加新用户，就是允许新用户能够通过其公钥访问Git服务。只要将新用户的公钥\
添加到\ ``gitosis-admin``\ 版本库的\ :file:`keydir`\ 目录下，即完成新用\
户的添加。

* 管理员从用户获取公钥，并将公钥按照\ :file:`username.pub`\ 格式进行重命名。

  用户可以通过邮件或者其他方式将公钥传递给管理员，切记不要将私钥误传给管
  理员。如果发生私钥泄漏，马上重新生成新的公钥/私钥对，并将新的公钥传递\
  给管理员，并申请将旧的公钥作废。

  关于公钥名称，我引入了类似Gitolite的实现：

  - 用户从不同的客户端主机访问有着不同的公钥，如果希望使用同一个用户名进\
    行授权，可以按照\ ``username@host.pub``\ 方式命名公钥文件，和名为\
    ``username@pub``\ 的公钥指向同一个用户\ ``username``\ 。

  - 也支持邮件地址格式的公钥，即形如\ ``username@gmail.com.pub``\ 的公钥。\
    Gitosis能够很智能的区分是以邮件地址命名的公钥还是相同用户在不同主机\
    上的公钥。如果是邮件地址命名的公钥，将以整个邮件地址作为用户名。

* 管理员进入\ ``gitosis-admin``\ 本地克隆版本库中，复制新用户公钥到\
  :file:`keydir`\ 目录。

  ::

    $ cp /path/to/dev1.pub keydir/
    $ cp /path/to/dev2.pub keydir/

* 执行\ :command:`git add`\ 命令，将公钥添加入版本库。

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

* 执行\ :command:`git commit`\ ，完成提交。

  ::

    $ git commit -m "add user: dev1, dev2"
    [master d7952a5] add user: dev1, dev2
     2 files changed, 2 insertions(+), 0 deletions(-)
     create mode 100644 keydir/dev1.pub
     create mode 100644 keydir/dev2.pub

* 执行\ :command:`git push`\ ，同步到服务器，才真正完成新用户的添加。

  ::

    $ git push
    Counting objects: 7, done.
    Delta compression using up to 2 threads.
    Compressing objects: 100% (5/5), done.
    Writing objects: 100% (5/5), 1.03 KiB, done.
    Total 5 (delta 0), reused 0 (delta 0)
    To git@server:gitosis-admin.git
       2482e1b..d7952a5  master -> master

如果这时查看服务器端\ :file:`~git/.ssh/authorized_keys`\ 文件，会发现新\
增的用户公钥也附加其中：

::

  ### autogenerated by gitosis, DO NOT EDIT
  command="gitosis-serve jiangxin",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty     <用户jiangxin的公钥...>
  command="gitosis-serve dev1",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty ssh-rsa <用户 dev1 的公钥...>
  command="gitosis-serve dev2",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty ssh-rsa <用户 dev1 的公钥...>


更改授权
---------

新用户添加完毕，可能需要重新进行授权。更改授权的方法也非常简单，即修改\
:file:`gitosis.conf`\ 配置文件，提交并推送。 

首先管理员进入\ ``gitosis-admin``\ 本地克隆版本库中，编辑\ :file:`gitosis.conf`\ 。

::

  $ vi gitosis.conf

授权指令比较复杂，先通过建立一个新用户组并授权新版本库\ ``testing``\
尝试一下更改授权文件。例如在\ :file:`gitosis.conf`\ 中添加如下授权内容：

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


* 上面的授权文件为版本库\ ``testing``\ 赋予了三个角色。分别是\
  ``@testing-admin``\ 用户组，\ ``@testing-developer``\ 用户组和\
  ``@testing-reader``\ 用户组。

* 第1行开始的\ ``testing-admin``\ 小节，定义了用户组\ ``@testing-admin``\ 。

* 第2行设定该用户组包含的用户有\ ``jiangxin``\ ，以及前面定义的\
  ``@gitosis-admin``\ 用户组用户。

* 第3行用\ ``admin``\ 指令，设定该用户组用户可以创建版本库\ ``testing``\ 。

  ``admin``\ 指令是笔者新增的授权指令，请确认安装的Gitosis包含笔者的改进。

* 第7行用\ ``writable``\ 授权指令，设定该\ ``@testing-developer``\ 用户组\
  用户可以读写版本库\ ``testing``\ 。

  笔者改进后的Gitosis也可以使用\ ``write``\ 作为\ ``writable``\ 指令的同义词\
  指令。

* 第11行用\ ``readonly``\ 授权指令，设定该\ ``@testing-reader``\ 用户组\
  用户（所有用户）可以只读访问版本库\ ``testing``\ 。

  笔者改进后的Gitosis也可以使用\ ``read``\ 作为\ ``readonly``\ 指令的同\
  义词指令。

编辑结束，提交改动。

::

  $ git add gitosis.conf
  $ git commit -q -m "auth for repo testing."

执行\ :command:`git push`\ ，同步到服务器，才真正完成授权文件的编辑。

::

  $ git push

Gitosis授权详解
=================

Gitosis缺省设置
-----------------

在\ ``[gitosis]``\ 小节中定义Gitosis的缺省设置。如下：

::

  1  [gitosis]
  2  repositories = /gitroot
  3  #loglevel=DEBUG
  4  gitweb = yes
  5  daemon = yes
  6  generate-files-in = /home/git/gitosis

其中：

* 第2行，设置版本库缺省的根目录是\ :file:`/gitroot`\ 目录。

  否则缺省路径是安装用户主目录下的\ :file:`repositories`\ 目录。

* 第3行，如果打开注释，则版本库操作时显示Gitosis调试信息。

* 第4行，启用gitweb的整合。

  可以通过\ ``[repo name]``\ 小节为版本库设置描述字段，用户显示在Gitweb中。

* 第5行，启用git-daemon的整合。

  即新创建的版本库中，创建文件\ :file:`git-daemon-export-ok`\ 。

* 第6行，设置创建的项目列表文件（供gitweb使用）所在的目录。

  缺省即为安装用户的主目录下的\ :file:`gitosis`\ 目录。


管理版本库\ ``gitosis-admin``
--------------------------------

::

  1  [group gitosis-admin]
  2  write = gitosis-admin
  3  members = jiangxin
  4  repositories = /home/git

除了第4行，其他内容在前面都已经介绍过了，是Gitosis自身管理版本库的用户组\
设置。

第4行，重新设置了版本库的缺省根路经，覆盖缺省的\ ``[gitosis]``\ 小节中的\
缺省根路径。实际的\ ``gitosis-admin``\ 版本库的路径为\
:file:`/home/git/gitosis-admin.git`\ 。


定义用户组和授权
-----------------

下面的两个示例小节定义了两个用户组，并且用到了路径变换的指令。

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

在上面的示例中，演示了授权指令以及Gitosis特色的\ ``map``\ 指令。

* 第1行，定义了用户组\ ``@ossxp-admin``\ 。

* 第2行，设定该用户组包含用户\ ``jiangxin``\ 以及用户组\ ``@gitosis-admin``\
  的所有用户。

* 第3行，设定该用户组具有创建及读写与通配符\ ``ossxp/**``\ 匹配的版本库。

  两个星号匹配任意字符包括路径分隔符（/）。此功能属于笔者扩展的功能。

* 第4行，设定该用户组可以只读访问\ ``gistore/*``\ 匹配的版本库。

  一个星号匹配任意字符包括路径分隔符（/）。 此功能也属于笔者扩展的功能。

* 第5行，是Gitosis特有的版本库名称重定位功能。

  即对\ ``redmine-*``\ 匹配的版本库，先经过名称重定位，在名称前面加上\
  ``ossxp/remdine``\ 。其中\ ``\\1``\ 代表匹配的整个版本库名称。

  用户组\ ``@ossxp-admin``\ 的用户对于重定位后的版本库，具有\ ``admin``\
  （创建和读写）权限。

* 第6行，是我扩展的版本库名称重定位功能，支持正则表达式。

  等号左边的名称进行通配符匹配，匹配后，再经过右侧的一对正则表达式进行\
  转换（冒号前的用于匹配，冒号后的用于替换）。

* 第10行，使用了内置的\ ``@all``\ 用户组，因此不需要通过\ ``members``\
  设定用户，因为所有用户均属于该用户组。

* 第11行，设定所有用户均可以只读访问\ ``ossxp/**``\ 匹配的版本库。

* 第12-17行，对特定路径进行映射，并分配只读权限。

* 第18行，设置版本库的根路径为\ :file:`/gitroot`\ ，而非缺省的版本库根路径。

Gitweb整合
-----------

Gitosis和Gitweb的整合，提供了两个方面的内容。一个是可以设置版本库的描述\
信息，用于在gitweb的项目列表页面显示。另外一个是自动生成项目的列表文件供\
Gitweb参考，避免Gitweb使用效率低的目录递归搜索查找Git版本库列表。


例如在\ :file:`gitosis.conf`\ 中下面的配置用于对\ ``redmine-1.0.x``\
版本库的Gitweb整合进行设置。

::

  1  [repo ossxp/redmine/redmine-1.0.x]
  2  gitweb = yes
  3  owner = Jiang Xin
  4  description = Redmine 1.0.x 群英汇定制开发

* 第1行，\ ``repo``\ 小节用于设置版本库的Gitweb整合。

  版本库的实际路径是用版本库缺省的根（即在\ ``[gitosis]``\ 小节中定义的\
  或者缺省的）加上此小节中的版本库路径组合而成的。

* 第2行，启用Gitweb整合。如果省略，使用全局\ ``[gitosis]``\ 小节中gitweb的设置。

* 第3行，用于设置版本库的属主。

* 第4行，用于设置版本库的描述信息，显示在Gitweb的版本库列表中。

每一个\ ``repo``\ 小节所指向的版本库，如果启用了Gitweb选项，则版本库名称\
汇总到一个项目列表文件中。该项目列表文件缺省保存在\ :file:`~/gitosis/projects.list`\ 中。


创建新版本库
=============

Gitosis维护的版本库位于安装用户主目录下的\ :file:`repositories`\ 目录中，\
即如果安装用户为\ ``git``\ ，则版本库都创建在\ :file:`/home/git/repositories`\
目录之下。可以通过配置文件\ :file:`gitosis.conf`\ 修改缺省的版本库的根路径。

可以直接在服务器端创建，或者在客户端远程创建版本库。

**克隆即创建，还是PUSH即创建？**

在客户端远程创建版本库时，Gitosis的原始实现是对版本库具有\ ``writable``\
（读写）权限的用户，对不存在的版本库执行克隆操作时，自动创建。但是我认为\
这不是一个好的实践，会经常因为克隆的URL写错，导致在服务器端创建垃圾版\
本库。笔者改进的实现如下：

* 增加了名为\ ``admin``\ （或\ ``init``\ ）的授权指令，只有具有此授权的\
  用户，才能够创建版本库。

* 只具有\ ``writable``\ （或\ ``write``\ ）权限的用户，不能在服务器上创\
  建版本库。

* 不通过克隆创建版本库，而是在对版本库进行PUSH的时候进行创建。当克隆一个\
  不存在的版本库，会报错退出。

远程在服务器上创建版本库的方法如下：

* 首先，本地建库。

  ::

     $ mkdir somerepo
     $ cd somerepo
     $ git init 
     $ git commit --allow-empty

* 使用\ :command:`git remote`\ 指令添加远程的源。

  ::

     $ git remote add origin git@server:ossxp/somerepo.git

* 运行\ :command:`git push`\ 完成在服务器端版本库的创建

  ::

    $ git push origin master


轻量级管理的Git服务
=====================

轻量级管理的含义是不采用缺省的稍显复杂的管理模式（远程克隆\ ``gitosis-admin``\
库，修改并PUSH的管理模式），而是直接在服务器端通过预先定制的配置文件提供\
Git服务。这种轻量级管理模式，对于为某些应用建立快速的Git库服务提供了便利。

例如在使用备份工具Gistore进行文件备份时，可以用Gitosis架设轻量级的Git服\
务，可以在远程使用Git命令进行双机甚至是异地备份。

首先创建一个专用帐号，并设置该用户只能执行\ :command:`gitosis-serve`\
命令。例如创建帐号\ ``gistore``\ ，通过修改\ :command:`/etc/ssh/sshd_config`\
配置文件，实现限制该帐号登录的可执行命令。

::

  Match user gistore
      ForceCommand gitosis-serve gistore
      X11Forwarding no
      AllowTcpForwarding no
      AllowAgentForwarding no
      PubkeyAuthentication yes
      #PasswordAuthentication no

上述配置信息告诉SSH服务器，凡是以\ ``gistore``\ 用户登录的帐号，强制执行\
Gitosis的命令。

然后，在该用户的主目录下创建一个配置文件\ :file:`.gitosis.conf`\ （注意\
文件名前面的点号），如下：

::

  [gitosis]
  repositories = /etc/gistore/tasks
  gitweb = yes
  daemon = no

  [group gistore]
  members = gistore
  map readonly * = (.*):\1/repo

上述配置的含义是：

* 用户\ ``gistore``\ 才能够访问\ :file:`/etc/gistore/tasks`\ 下的Git库。

* 版本库的名称要经过变换，例如\ ``system``\ 库会变换为实际路径\
  :file:`/etc/gistore/tasks/system/repo.git`\ 。
