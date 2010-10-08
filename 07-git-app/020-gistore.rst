Gistore
========

当了解了 etckeeper 之后，你可能如我一样会问到：“有没有像 etckeeper 一样的工具，但是能备份任意的文件和目录呢？”

我在 Google 上搜索类似的工具无果，终于决定动手开发一个，因为无论是我还是客户，都需要一个更好用的备份工具。这就是 Gistore。 

::

  Gistore = Git + Store

2010年1月，我在公司的博客上发表了 Gistore 0.1 版本的消息，参见： http://blog.ossxp.com/2010/01/406/ 。
并将 Gistore 的源代码托管在了 Github 上，参见： http://github.com/ossxp-com/gistore 。

Gistore 的设计参考了 etckeeper，用户可以对全盘任何目录的数据纳入到备份中，定制非常简单和方便。特点有：

* 使用 Git 作为数据后端。数据回复和历史查看等均使用熟悉的 Git 命令。
* 每次备份即为一次 Git 提交，支持文件的添加/删除/修改/重命名等。
* 每次备份的日志自动生成，内容为此次修改的摘要信息。
* 支持备份回滚，可以设定保存备份历史的天数，让备份的空间占用维持在一个相对稳定的水平上。
* 支持跨卷备份。备份的数据源可以来自任何卷/目录或者文件。
* 备份源如果已经 Git 化，也能够备份。例如 `/etc` 目录因为 etckeeper 被 Git 化，仍然可以对其用 gistore 进行备份。
* 多机异地备份非常简单，使用 git 克隆即可解决。可以采用 git 协议，http，或者更为安全的 ssh 协议。

注意：Gistore 只能运行在 Linux / Unix 上，而且最好以 root 用户身份运行，以避免因为授权问题导致有的文件不能备份。

Gistore 的安装
---------------

从源码安装 gistore
+++++++++++++++++++

从源代码安装 Gistore，可以确保安装的是最新的版本。

* 先用 git 从 Github 上克隆 代码库。

  ::

    $ git clone git://github.com/ossxp-com/gistore.git
    Initialized empty Git repository in /home/jiangxin/gistore/.git/
    remote: Counting objects: 379, done.
    remote: Compressing objects: 100% (328/328), done.
    remote: Total 379 (delta 238), reused 0 (delta 0)
    Receiving objects: 100% (379/379), 61.03 KiB | 49 KiB/s, done.
    Resolving deltas: 100% (238/238), done.


* 执行 setup.py 脚本完成安装

  ::

    $ cd gistore
    $ sudo python setup.py install

    $ which gistore
    /usr/local/bin/gistore

用 easy_install 安装
++++++++++++++++++++

Gistore 是用 Python 语言开发，已经在 PYPI 上注册： http://pypi.python.org/pypi/gistore 。就像其它 Python 软件包一样，可以使用 easy_install 进行安装。

* 确保机器上已经安装了 setuptools。

  Setuptools 的官方网站在 http://peak.telecommunity.com/DevCenter/setuptools 。几乎每个 Linux 发行版都有 setuptools 的软件包，因此可以直接用包管理器进行安装。

  在 Debian / Ubuntu 上可以使用下面的命令安装 setuptools

  ::

    $ sudo aptitude install python-setuptools

    $ which easy_install
    /usr/bin/easy_install

* 使用 `easy_install` 命令安装 gistore

  ::

      $ sudo easy_install -U gistore
      install_dir /usr/local/lib/python2.6/dist-packages/
      Searching for gistore
      Reading http://pypi.python.org/simple/gistore/
      Reading http://github.com/ossxp-com/gistore
      Reading http://www.ossxp.com/
      Best match: gistore 0.2.5
      Downloading http://pypi.python.org/packages/source/g/gistore/gistore-0.2.5.tar.gz#md5=17f3fc5491698dc50a9113a54bb011e8
      Processing gistore-0.2.5.tar.gz
      Running gistore-0.2.5/setup.py -q bdist_egg --dist-dir /tmp/easy_install-pVtCTg/gistore-0.2.5/egg-dist-tmp-1TvrLZ
      zip_safe flag not set; analyzing archive contents...
      gistore.main: module references __file__
      Adding gistore 0.2.5 to easy-install.pth file
      Installing gistore script to /usr/local/bin
      
      Installed /usr/local/lib/python2.6/dist-packages/gistore-0.2.5-py2.6.egg
      Processing dependencies for gistore
      Finished processing dependencies for gistore
      

Gistore 的使用
--------------

我们先熟悉一下 Gistore 的术语：

* 备份库：通过 gistore 创建并维护的一个用于备份的 git 库

  - 包含 git 库本身（repo.git目录, .gitignore文件等）
  - 以及 gistore 相关配置（.gistore）目录

* 备份项：可以为一个备份库指定任意多的备份项目

  - 例如备份 /etc 目录, /var/log 目录, /boot/grub/menulist 文件等
  - 备份项在备份库的 .gistore/config 文件中指定，如上例的备份项在配置文件中写法为：

    ::

      [store /etc]
      [store /var/log]
      [store /boot/grub/menu.lst]

* 备份任务：在执行大部分 gistore 的命令时，需要指定一个任务或者多个任务

  - 备份任务可以是对应的 备份库 的路径。
  
    可以使用绝对路径，也可以使用相对路径。

  - 如果不提供备份任务，缺省将当前目录作为 备份库 的所在。

  - 也可以使用一个任务别名来标识备份任务。


* 任务别名

  - 在 `/etc/gistore/tasks` 目录中创建的备份库的符号链接的名称，作为这些备份库的任务别名。
  - 通过任务别名的机制，将可能分散在磁盘各处的备份库汇总一起，便于管理员定位备份库。
  - 将所有的别名显示出来，就是任务列表。

创建并初始化备份库
++++++++++++++++++

在使用 gistore 开始备份之前，必须先初始化一个备份库。 命令行格式如下：

::

  gistore init [备份任务]

初始化备份库的示例如下：

* 将当前目录作为备份库进行初始化：

  $ mkdir backup
  $ cd backup
  $ gistore init

* 将指定的目录作为备份库进行初始化

  $ sudo gistore init /backup/database

当一个备份库初始化完毕后，包含下列文件和目录：

* 目录 `repo.git` ：存储备份的 Git 版本库。
* 文件 `.gistore/config` ：Gistore 配置文件。
* 目录 `logs` ：Gistore 运行的日志记录。
* 目录 `locks` ：Gistore 运行的文件锁目录。

Gistore 的配置文件
++++++++++++++++++

在每一个备份库的 `.gistore` 目录下的 `config` 文件是该备份库的配置文件，用于记录 Gistore 的备份项内容以及备份回滚设置等。

例如下面的配置内容：

::

  1   # Global config for all sections
  2   [main]
  3   backend = git
  4   backup_history = 200
  5   backup_copies = 5
  6   root_only = no
  7   version = 2
  8
  9   [default]
  10  keep_empty_dir = no
  11  keep_perm = no
  12
  13  # Define your backup list below. Section name begin with 'store ' will be backup.
  14  # eg: [store /etc]
  15  [store /opt/mailman/archives]
  16  [store /opt/mailman/conf]
  17  [store /opt/mailman/lists]
  18  [store /opt/moin/conf]
  19  [store /opt/moin/sites]

如何理解这个配置文件呢？

* 第2行到第7行的 [main] 小节用于 Gistore 的全局设置。
* 第3行设置了 Gistore 使用的 SCM 后端为 Git，这是目前唯一可用的设置。
* 第4行设置了 Gistore 的每一个历史分支保存的最多的提交数目，缺省200个提交。当超过这个提交数目，进行备份回滚。
* 第5行设置了 Gistore 保存的历史分支数量，缺省5个历史分支。每当备份回滚时，会将备份主线保存到名为 `gistore/1` 的历史分支。
* 第6行设置非 root_only 模式。如果开启 root_only 模式，则只有 root 用户能够执行此备份库的备份。
* 第7行设置了 Gistore 备份库的版本格式。
* 第9行开始的 [default] 小节设置后面的备份项小节的缺省设置。在后面的 [store ...] 小节可以覆盖此缺省设置。
* 第10行设置是否保留空目录。暂未实现。
* 第11行设置是否保持文件属主和权限。暂未实现。
* 第15行到第19行是备份项小节，小节名称以 `store` 开始，后面的部分即为备份项的路径。

  如 [store /etc] 的含义是：要对 `/etc` 目录进行备份。

Gistore 的备份项管理
+++++++++++++++++++++

当然可以直接编辑 `.gistore/config` 文件，通过添加或者删除 [store...] 小节的方式管理备份项。但 Gistore 提供了两个命令进行备份项的管理。

* 添加备份项。

  进入备份库目录，执行下面的命令，添加备份项 `/some/dir` 。注意备份项要使用全路径，即要以 "`/`" 开始。

  ::

    $ gistore add /some/dir


* 删除备份项。

  进入备份库目录，执行下面的命令，策删除备份项 `/some/dir` 。

  ::

    $ gistore rm /some/dir


执行备份任务
+++++++++++++

执行备份任务非常简单：

* 进入到备份库根目录下，执行：

  ::

    $ sudo gistore commit

* 或者在命令行上指定备份库的路径。

  ::

    $ sudo gistore ci /backup/database

  说明： `ci` 为 `commit` 命令的简称。

查看备份日志及数据
+++++++++++++++++++

备份的日志经过了特别的设计，能够概览备份的信息。


查看详细的备份列表，则需要借助于 git 命令。


备份回滚及设置
+++++++++++++++

查看状态

注册备份任务别名
+++++++++++++++++

因为 gistore 可以在任何目录下创建备份任务，因此管理员很难定位当前到底存在多少个备份库。还有就是执行备份时，要在命令行指定长长备份库路径。

任务别名就是用来解决这些问题的。

为备份任务创建任务别名非常简单，只需要 在 /etc/gistore/tasks 目录中创建的备份库的符号链接，该符号链接的名称，作为这些备份库的任务别名

::

  $ sudo ln -s /home/jiangxin/Desktop/mybackup /etc/gistore/tasks/jx
  $ sudo ln -s /backup/database /etc/gistore/tasks/db
   

于是，就创建了两个任务别名，在以后执行备份时，可以简化备份命令：

::

  $ sudo gistore ci jx
  $ sudo gistore ci db

查看一份完整备份列表也非常简答：

::

  $ gistore list
  db        : /backup/database
  jx        : /home/jiangxin/Desktop/mybackup

当 gistore list 命令后面指定某个任务列表时，相当于执行 gistore status 命令，查看备份状态信息：

::

  $ gistore list db

可以用一条命令对所有的任务别名执行备份：

::

  $ gistore commit-all


自动备份：crontab
+++++++++++++++++++

在 /etc/cron.d/ 目录下创建一个文件，如 `/etc/cron.d/gistore` ：

::

  ## gistore backup
  0   4  *   *   *    root  /usr/bin/gistore commit-all -vvvv


Gistore 双机备份
----------------

Gistore 备份库的主体就是 `repo.git` ，一个 Git 库。我们可以通过架设一个 Git 库，远程主机通过克隆该备份库实现双机备份甚至是异地备份。而且最酷的是，整个数据同步的过程是可视的、快速的和无痛的，感谢伟大而又神奇的 Git。

最好使用公钥认证的基于SSH的Git服务器架设，因为一是可以实现无口令的数据同步，二是增加安全性，因为备份数据中可能包含敏感数据。

还有我们可以直接利用现成的 `/etc/gistore/tasks` 目录作为版本库的根。当然我们还需要通过一个地址变换的小巧门，实现 Git 服务的架设。即：

::

  $ git clone gistore@server:system.git
                                |
                                +----------> Gitosis ----------> /etc/gistore/tasks/system/repo.git

Gitosis 服务器软件的地址变换魔法正好可以帮助我们实现。在前面 Gitosis 的最后一个章节我们介绍的正是如何架设一个供 Gistore 双机备份的 Git 服务。请参考 TODO。

