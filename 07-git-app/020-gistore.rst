Gistore
********

当了解了etckeeper之后，读者可能会如我一样的提问到：“有没有像etckeeper一\
样的工具，但是能备份任意的文件和目录呢？”

我在Google上搜索类似的工具无果，终于决定动手开发一个，因为无论是我还是我\
的客户，都需要一个更好用的备份工具。这就是Gistore。

::

  Gistore = Git + Store

2010年1月，我在公司的博客上发表了Gistore 0.1版本的消息，参见：\
http://blog.ossxp.com/2010/01/406/\ 。并将Gistore的源代码托管在了Github上，\
参见：\ http://github.com/ossxp-com/gistore\ 。

Gistore出现受到了etckeeper的启发，通过Gistore用户可以对全盘任何目录的数\
据纳入到备份中，定制非常简单和方便。特点有：

* 使用Git作为数据后端。数据回复和历史查看等均使用熟悉的Git命令。

* 每次备份即为一次Git提交，支持文件的添加/删除/修改/重命名等。

* 每次备份的日志自动生成，内容为此次修改的摘要信息。

* 支持备份回滚，可以设定保存备份历史的天数，让备份的空间占用维持在一个相\
  对稳定的水平上。

* 支持跨卷备份。备份的数据源可以来自任何卷/目录或者文件。

* 备份源如果已经Git化，也能够备份。例如\ :file:`/etc`\ 目录因为etckeeper\
  被Git化，仍然可以对其用gistore进行备份。

* 多机异地备份非常简单，使用git克隆即可解决。可以采用git协议、http、或者\
  更为安全的ssh协议。

说明：Gistore只能运行在Linux/Unix上，而且最好以root用户身份运行，以避免\
因为授权问题导致有的文件不能备份。

Gistore的安装
===============

从源码安装Gistore
-------------------

从源代码安装Gistore，可以确保安装的是最新的版本。

* 先用git从Github上克隆代码库。

  ::

    $ git clone git://github.com/ossxp-com/gistore.git

* 执行\ ``setup.py``\ 脚本完成安装

  ::

    $ cd gistore
    $ sudo python setup.py install

    $ which gistore
    /usr/local/bin/gistore

用\ ``easy_install``\ 安装
------------------------------

Gistore是用Python语言开发，已经在PYPI上注册：\
http://pypi.python.org/pypi/gistore\ 。就像其他Python软件包一样，\
可以使用\ ``easy_install``\ 进行安装。

* 确保机器上已经安装了setuptools。

  Setuptools的官方网站在\ http://peak.telecommunity.com/DevCenter/setuptools\ 。\
  几乎每个Linux发行版都有setuptools的软件包，因此可以直接用包管理器进行安装。

  在Debian/Ubuntu上可以使用下面的命令安装setuptools：

  ::

    $ sudo aptitude install python-setuptools

    $ which easy_install
    /usr/bin/easy_install

* 使用\ :command:`easy_install`\ 命令安装Gistore

  ::

      $ sudo easy_install -U gistore

Gistore的使用
==============

先熟悉一下Gistore的术语：

* 备份库：通过\ :command:`gistore init`\ 命令创建的，用于数据备份的数据\
  仓库。备份库包含的数据有：

  - Git版本库相关目录和文件。如\ :file:`repo.git`\ 目录（相当于\
    :file:`.git`\ 目录），\ :file:`.gitignore`\ 文件等。

  - Gistore相关配置。如\ :file:`.gistore/config`\ 文件。

* 备份项：可以为一个备份库指定任意多的备份项目。

  - 例如备份\ :file:`/etc`\ 目录，\ :file:`/var/log`\ 目录，\
    :file:`/boot/grub/menulist`\ 文件等。

  - 备份项在备份库的\ :file:`.gistore/config`\ 文件中指定，如上述备份项\
    在配置文件中写法为：

    ::

      [store /etc]
      [store /var/log]
      [store /boot/grub/menu.lst]

* 备份任务：在执行\ :command:`gistore`\ 命令时，可以指定一个任务或者多个\
  任务。

  - 备份任务可以是对应的备份库的路径。可以使用绝对路径，也可以使用\
    相对路径。

  - 如果不提供备份任务，缺省将当前目录作为备份库的所在。

  - 也可以使用一个任务别名来标识备份任务。


* 任务别名。

  - 在\ :file:`/etc/gistore/tasks`\ 目录中创建的备份库的符号链接的名称，\
    作为这些备份库的任务别名。

  - 通过任务别名的机制，将可能分散在磁盘各处的备份库汇总一起，便于管理员\
    定位备份库。

  - 将所有的别名显示出来，就是任务列表。

创建并初始化备份库
------------------

在使用Gistore开始备份之前，必须先初始化一个备份库。命令行格式如下：

::

  gistore init [备份任务]

初始化备份库的示例如下：

* 将当前目录作为备份库进行初始化：

  ::

    $ mkdir backup
    $ cd backup
    $ gistore init

* 将指定的目录作为备份库进行初始化:

  ::

    $ sudo gistore init /backup/database

当一个备份库初始化完毕后，包含下列文件和目录：

* 目录\ :file:`repo.git`\ ：存储备份的Git版本库。
* 文件\ :file:`.gistore/config`\ ：Gistore配置文件。
* 目录\ :file:`logs`\ ：Gistore运行的日志记录。
* 目录\ :file:`locks`\ ：Gistore运行的文件锁目录。

Gistore的配置文件
------------------

在每一个备份库的\ :file:`.gistore`\ 目录下的\ :file:`config`\ 文件是该备\
份库的配置文件，用于记录Gistore的备份项内容以及备份回滚设置等。

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

* 第2行到第7行的\ ``[main]``\ 小节用于Gistore的全局设置。

* 第3行设置了Gistore使用的SCM后端为Git，这是目前唯一可用的设置。

* 第4行设置了Gistore的每一个历史分支保存的最多的提交数目，缺省200个提交。\
  当超过这个提交数目，进行备份回滚。

* 第5行设置了Gistore保存的历史分支数量，缺省5个历史分支。每当备份回滚时，\
  会将备份主线保存到名为\ ``gistore/1``\ 的历史分支。

* 第6行设置非\ ``root_only``\ 模式。如果开启\ ``root_only``\ 模式，则只有\
  root用户能够执行此备份库的备份。

* 第7行设置了Gistore备份库的版本格式。

* 第9行开始的\ ``[default]``\ 小节设置后面的备份项小节的缺省设置。在后面\
  的\ ``[store ...]``\ 小节可以覆盖此缺省设置。

* 第10行设置是否保留空目录。暂未实现。

* 第11行设置是否保持文件属主和权限。暂未实现。

* 第15行到第19行是备份项小节，小节名称以\ ``store``\ 开始，后面的部分即\
  为备份项的路径。

  如\ ``[store /etc]``\ 的含义是：要对\ :file:`/etc`\ 目录进行备份。

Gistore的备份项管理
---------------------

当然可以直接编辑\ :file:`.gistore/config`\ 文件，通过添加或者删除\
``[store...]``\ 小节的方式管理备份项。Gistore还提供了两个命令进行备份项的管理。

**添加备份项**

进入备份库目录，执行下面的命令，添加备份项\ :file:`/some/dir`\ 。注意备\
份项要使用全路径，即要以“/”开始。

::

  $ gistore add /some/dir


**删除备份项**

进入备份库目录，执行下面的命令，策删除备份项\ :file:`/some/dir`\ 。

::

  $ gistore rm /some/dir

**查看备份项**

进入备份库目录，执行\ :command:`gistore status`\ 命令，显示备份库的设置\
以及备份项列表。

::

  $ gistore status
           Task name : system
           Directory : /data/backup/gistore/system
             Backend : git
   Backup capability : 200 commits * 5 copies
         Backup list :
                       /backup/databases (--)
                       /backup/ldap (--)
                       /data/backup/gistore/system/.gistore (--)
                       /etc (AD)
                       /opt/cosign/conf (--)
                       /opt/cosign/factor (--)
                       /opt/cosign/lib (--)
                       /opt/gosa/conf (--)
                       /opt/ossxp/conf (--)
                       /opt/ossxp/ssl (--)
  
从备份库的状态输出，可以看到：

* 备份库的路径是\ :file:`/data/backup/gistore/system`\ 。

* 备份库有一个任务别名为\ ``system``\ 。

* 备份的容量是200*5，如果按每天一次备份计算的话，总共保存1000天，差不多3\
  年的数据备份。

* 在备份项列表，可以看到多达10项备份列表。

  每个备份项后面的括号代表其备份选项，其中\ :file:`/etc`\ 的备份选项为\
  ``AD``\ 。\ ``A``\ 代表记录并保持授权，\ ``D``\ 的含义是保持空目录。


执行备份任务
-------------

执行备份任务非常简单：

* 进入到备份库根目录下，执行：

  ::

    $ sudo gistore commit

* 或者在命令行上指定备份库的路径。

  ::

    $ sudo gistore ci /backup/database

  说明：\ ``ci``\ 为\ ``commit``\ 命令的简称。

查看备份日志及数据
-------------------

备份库中的\ :file:`repo.git`\ 就是备份数据所在的Git库，这个Git库是一个\
不带工作区的裸库。可以对其执行\ :command:`git log`\ 命令来查看备份日志。

因为并非采用通常\ :file:`.git`\ 作为版本库名称，而且不带工作区，需要通过\
``--git-dir``\ 参数制定版本库位置，如下：

::

  $ git --git-dir=repo.git log

当然，也可以进入到\ :file:`repo.git`\ 目录，执行\ :command:`git log`\ 命令。

下面是我公司内的服务器每日备份的日志片断：

::

  commit 9d16b5668c1a09f6fa0b0142c6d34f3cbb33072f
  Author: Jiang Xin <jiangxin@ossxp.com>
  Date:   Thu Aug 5 04:00:23 2010 +0800
  
      Changes summary: total= 423, A: 407, D: 1, M: 15
      ------------------------------------------------
          A => etc/gistore/tasks/Makefile, opt/cosign/lib/share/locale/cosign.pot, opt/cosign/lib/templates-local.old/expired_error.html, opt/cosign/lib/templates-local.old3/error.html, opt/cosign/lib/templates/inc/en/0020_scm.html, ...402 more...
          D => etc/gistore/tasks/default
          M => .gistore/config, etc/gistore/tasks/gosa, etc/gistore/tasks/testlink, etc/group, etc/gshadow-, ...10 more...
  
  commit 01b6bce2e4ee2f8cda57ceb3c4db0db9eb90bbed
  Author: Jiang Xin <jiangxin@ossxp.com>
  Date:   Wed Aug 4 04:01:09 2010 +0800
  
      Changes summary: total= 8, A: 7, M: 1
      -------------------------------------
          A => backup/databases/blog_bj/blog_bj.sql, backup/databases/ossxp/mysql.sql, backup/databases/redmine/redmine.sql, backup/databases/testlink/testlink-1.8.sql, backup/databases/testlink/testlink.sql, ...2 more...
          M => .gistore/config
  
  commit 15ef2e88f33dfa7dfb04ecbcdb9e6b2a7c4e6b00
  Author: Jiang Xin <jiangxin@ossxp.com>
  Date:   Tue Aug 3 16:59:12 2010 +0800
  
      Changes summary: total= 2665, A: 2665
      -------------------------------------
          A => .gistore/config, etc/apache2/sites-available/gems, etc/group-, etc/pam.d/dovecot, etc/ssl/certs/0481cb65.0, ...2660 more...
  
  commit 6883d5c2ca77caab9f9b2cfd68dcbc27526731c8
  Author: Jiang Xin <jiangxin@ossxp.com>
  Date:   Tue Aug 3 16:55:49 2010 +0800
  
      gistore root commit initialized.

从上面的日志可以看出：

* 备份发生在晚上4点钟左右。这是因为备份是晚上自动执行的。

* 最老的备份，即ID为\ ``6883d5c``\ 的提交，实际上是一个不包含任何数据的\
  空备份，在数据发生回滚的时候，设置为回滚的起点。这个后面会提到。

* ID为\ ``15ef2e8``\ 的提交是一次手动提交。提交说明中可以看到添加了2665\
  个文件。

* 最新的备份ID为\ ``9d16b56``\ ，其中既又文件添加（A），又有文件删除\
  （D），还有文件变更（M），会随机选择各5个文件出现在提交日志中。

**如果想查看详细的文件变更列表？**

使用下面的命令：

::

  $ git --git-dir=repo.git show --stat 9d16b56

  commit 9d16b5668c1a09f6fa0b0142c6d34f3cbb33072f
  Author: Jiang Xin <jiangxin@ossxp.com>
  Date:   Thu Aug 5 04:00:23 2010 +0800
  
      Changes summary: total= 423, A: 407, D: 1, M: 15
      ------------------------------------------------
          A => etc/gistore/tasks/Makefile, opt/cosign/lib/share/locale/cosign.pot, opt/cosign/lib/templates-local.old/expired_error.html, opt/cosign/lib/templ
          D => etc/gistore/tasks/default
          M => .gistore/config, etc/gistore/tasks/gosa, etc/gistore/tasks/testlink, etc/group, etc/gshadow-, ...10 more...
  
   .gistore/config                                    |    4 +
   backup/databases/redmine/redmine.sql               |   44 +-
   etc/apache2/include/redmine/redmine.conf           |   40 +-
   etc/gistore/tasks/Makefile                         |    1 +
   etc/gistore/tasks/default                          |    1 -
   etc/gistore/tasks/gosa                             |    2 +-
  
   ...
  
   opt/gosa/conf/sieve-spam.txt                       |    6 +
   opt/gosa/conf/sieve-vacation.txt                   |    4 +
   opt/ossxp/conf/cron.d/ossxp-backup                 |    8 +-
   423 files changed, 30045 insertions(+), 51 deletions(-)

在备份库的\ :file:`logs`\ 目录下，还有一个备份过程的日志文件\
:file:`logs/gitstore.log`\ 。记录了每次备份的诊断信息，主要用于调试Gistore。

查看及恢复备份数据
-------------------

所有的备份数据，实际上都在\ :file:`repo.git`\ 目录指向的Git库中维护。\
如何获取呢？

**克隆方式检出**

执行下面的命令，克隆裸版本库\ ``repo.git``\ ：

::

  $ git clone repo.git data

进入\ :file:`data`\ 目录，就可以以Git的方式查看历史数据，以及恢复历史数据。\
当然恢复的历史数据还要拷贝到原始位置才能实现数据的恢复。

**分离的版本库和工作区方式检出**

还有一个稍微复杂的方法，就是既然版本库已经在\ ``repo.git``\ 了，可以直接\
利用它，避免克隆导致空间上的浪费，尤其是当备份库异常庞大的情况。

* 创建一个工作目录，如\ :file:`export`\ 。

  ::

    $ mkdir export

* 设置环境变量，制定版本库和工作区的位置。注意使用绝对路径。

  下面的命令中，用\ :command:`pwd`\ 命令获得当前工作路径，借以得到绝对\
  路径。

  ::

    $ export GIT_DIR=`pwd:file:`/repo.git
    $ export GIT_WORK_TREE=`pwd:file:`/export

* 然后就可以进入\ :file:` export`\ 目录，执行Git操作了。

  ::

    $ git status
    $ git checkout .

**为什么没有历史备份？**

当针对\ ``repo.git``\ 执行\ :command:`git log`\ 的时候，满心期望能够看到\
备份的历史，但是看到的却只有孤零零的几个备份记录。不要着急，可能是备份回\
滚了。

参见下节的备份回滚，会找到如何获取更多历史备份的方法。

备份回滚及设置
---------------

我在开发Gistore时，最麻烦的就是备份历史的管理。如果不对备份历史进行回滚，\
必然会导致提交越来越多，备份空间占用越来越大，直至磁盘空间占慢。

最早的想法是使用\ :command:`git rebase`\ 。即将准备丢弃的早期备份历史合并\
成为一个提交，后面的提交变基到合并提交之上，这样就实现了对历史提交的丢弃。\
但是这样的操作即费时，又比较复杂。忽然又一天灵机一动，为什么不用分支来\
实现对回滚数据的保留？至于备份主线（master分支）从一个新提交开始重建。

回滚后master分支如何从一个新提交开始呢？较早的实现是直接重置到一个空提交\
（gistore/0）上，但是这样会导致接下来的备份非常耗时。一个更好的办法是使用\
:command:`git commit-tree`\ 命令，直接从回滚前的master分支创建新提交。\
在读者看到这本书的时候，我应该已经才用了新的实现。

具体的实现过程是：

* 首先在备份库初始化的时候，就会建立一个空的提交，并打上里程碑Tag：\
  ``gistore/0``\ （新的实现这个步骤变得没有必要）。

* 每次备份，都提交在Git库的主线master上。

* 当Git库的master主线的提交数达到规定的阈值（缺省200），对gistore分支进\
  行回滚，并基于当前master打上分支：\ ``gistore/1``\ 。

  - 如果设置了5个回滚分支，并且存在其他回滚分支，则分支依次向后回滚。

  - 删除\ ``gistore/5``\ ，\ ``gistore/4``\ 分支改名为\ ``gistore/5``\ ，\
    等等，最后将\ ``gistore/1``\ 重命名为\ ``gistore/2``\ 。

  - 基于当前master建立分支\ ``gistore/1``\ 。

  - 将当前master以最新提交的树创建一个不含历史的提交，并重置到该提交。\
    即master分支抛弃所有的备份历史。

  - 在新的master分支进行一次新的备份。

* 当回滚发生后，对备份库的远程数据同步不会有什么影响，传输的数据量也仅是\
  新增备份和上一次备份的差异。

**如何找回历史备份？**

通过上面介绍的Gistore回滚的实现方法，会知道当回滚发生后，主线master只包\
含两个提交。一个是上一次备份的数据，另外一个是最新的数据备份。似乎大部分\
备份历史被完全丢弃了。其实，可以从分支\ ``gistore/1``\ 中看到最近备份的\
历史，还可以从其他分支（如果有的话）会看到更老的历史。

查看回滚分支的提交历史：

::

  $ git --git-dir=repo.git log gistore/1

通过日志找出要恢复的时间点和提交号，使用\ :command:`git checkout`\ 即可\
检出历史版本。


注册备份任务别名
-----------------

因为Gistore可以在任何目录下创建备份任务，管理员很难定位当前到底存在多少\
个备份库，因此需要提供一个机制，让管理员能够看到系统中有哪些备份库。还有，\
就是在使用Gistore时若使用长长的备份库路径作为参数会显得非常笨拙。任务\
别名就是用来解决这些问题的。

任务别名实际上就是在备份库在目录\ :file:`/etc/gistore/tasks`\ 下创建的符\
号连接。

为备份任务创建任务别名非常简单，只需要在\ :file:`/etc/gistore/tasks`\
目录中创建的备份库的符号链接，该符号链接的名称，作为这些备份库的任务别名。

::

  $ sudo ln -s /home/jiangxin/Desktop/mybackup /etc/gistore/tasks/jx
  $ sudo ln -s /backup/database /etc/gistore/tasks/db
   

于是，就创建了两个任务别名，在以后执行备份时，可以简化备份命令：

::

  $ sudo gistore commit jx
  $ sudo gistore commit db

查看一份完整备份列表也非常简单，执行\ :command:`gistore list`\ 命令即可。

::

  $ gistore list
  db        : /backup/database
  jx        : /home/jiangxin/Desktop/mybackup

当\ ``gistore list``\ 命令后面指定某个任务列表时，相当于执行\
``gistore status``\ 命令，查看备份状态信息：

::

  $ gistore list db

可以用一条命令对所有的任务别名执行备份：

::

  $ gistore commit-all


自动备份：crontab
-------------------

在\ :file:`/etc/cron.d/`\ 目录下创建一个文件，如\ :file:`/etc/cron.d/gistore`\ ，包含如下内容：

::

  ## gistore backup
  0   4  *   *   *    root  /usr/bin/gistore commit-all

这样每天凌晨4点，就会以root用户身份执行\ :command:`gistore commit-all`\ 
命令。

为了执行相应的备份计划，需要将备份库在\ :file:`/etc/gistore/tasks`\
目录下创建符号链接。

Gistore双机备份
================

Gistore备份库的主体就是\ ``repo.git``\ ，即一个Git库。可以通过架设一个\
Git服务器，远程主机通过克隆该备份库实现双机备份甚至是异地备份。而且最酷的\
是，整个数据同步的过程是可视的、快速的和无痛的，感谢伟大而又神奇的Git。

最好使用公钥认证的基于SSH的Git服务器架设，因为一是可以实现无口令的数据\
同步，二是增加安全性，因为备份数据中可能包含敏感数据。

还有可以直接利用现成的\ :file:`/etc/gistore/tasks`\ 目录作为版本库的根。\
当然还需要在架设的Git服务器上，使用一个地址变换的小巧门。Gitosis服务器软\
件的地址变换魔法正好可以帮助实现。参见第31章第31.5节“轻量级管理的Git服务”。

