子树合并
****************

使用子树合并，同样可以实现在一个项目中引用其他项目的数据。但是和子模组方\
式不同的是，使用子树合并模式，外部的版本库整个复制到本版本库中并建立跟踪\
关联。使用子树合并模型，使得对源自外部版本库的数据的访问和本版本库数据的\
访问没有区别，也可以对其进行本地修改，并且能够以子树合并的方式将源自外部\
版本库的改动和本地的修改相合并。

引入外部版本库
===============

为演示子树合并，需要至少准备两个版本库，一个是将被作为子目录引入的版本库\
``util.git``\ ，另外一个是主版本库\ ``main.git``\ 。

::

  $ git --git-dir=/path/to/repos/util.git init --bare
  $ git --git-dir=/path/to/repos/main.git init --bare

在本地检出这两个版本库：

::

  $ git clone /path/to/repos/util.git
  $ git clone /path/to/repos/main.git

需要为这两个空版本库添加些数据。非常简单，每个版本库下只创建两个文件：\
:file:`Makefile`\ 和\ :file:`version`\ 。当执行\ :command:`make`\ 命令时\
显示 version 文件的内容。对\ :file:`version`\ 文件多次提交以建立多个提交\
历史。别忘记在最后使用\ :command:`git push origin master`\ 将版本库推送\
到远程版本库中。

:file:`Makefile`\ 文件示例如下。注意第二行前面的空白是\ ``<TAB>``\ 字符，\
而非空格。

::

  all:
  	  @cat version

在之前尝试的\ :command:`git fetch`\ 命令都是获取同一项目的版本库的内容。\
其实命令\ :command:`git fetch`\ 从哪个项目获取数据并没有什么限制，因为\
Git的版本库不像Subversion那样用一个唯一的UUID标识让Subversion的版本库之间\
势同水火。当然也可以用\ :command:`git pull`\ 来获取其他版本库中的提交，\
但是那样将把两个项目的文件彻底混杂在一起。对于这个示例来说，因为两个项目\
具有同样的文件\ :file:`Makefile`\ 和\ :file:`version`\ ，使用\
:command:`git pull`\ 将导致冲突。所以为了将不同项目的版本库引入，并在稍候\
以子树合并方式添加到一个子目录中，需要用\ :command:`git fetch`\ 命令从其他\
版本库获取数据。

* 为了便于以后对外部版本库的跟踪，在使用\ :command:`git fetch`\ 前，先在\
  ``main``\ 版本库中注册远程版本库\ ``util.git``\ 。

  ::

    $ git remote add util /path/to/repos/util.git

* 查看注册的远程版本库。

  ::

    $ git remote -v
    origin  /path/to/repos/main.git/ (fetch)
    origin  /path/to/repos/main.git/ (push)
    util    /path/to/repos/util.git (fetch)
    util    /path/to/repos/util.git (push)

* 执行\ :command:`git fetch`\ 命令获取\ ``util.git``\ 版本库的提交。

  ::

    $ git fetch util

* 查看分支，包括远程分支。

  ::

    $ git branch -a
    * master
      remotes/origin/master
      remotes/util/master

在不同的分支：\ ``master``\ 分支和\ ``remotes/util/master``\ 分支，文件\
:file:`version`\ 的内容并不相同，因为来自不同的上游版本库。

* master分支中执行\ :command:`make`\ 命令，显示的是\ ``main.git``\
  版本库中\ :file:`version`\ 文件的内容。

  ::

    $ make
    main v2010.1

* 从\ ``util/master``\ 远程分支创建一个本地分支\ ``util-branch``\ ，\
  并切换分支。

  ::

    $ git checkout -b util-branch util/master
    Branch util-branch set up to track remote branch master from util.
    Switched to a new branch 'util-branch'

* 执行\ :command:`make`\ 命令，显示的是\ ``util.git``\ 版本库中\
  :file:`version`\ 文件的内容。

  ::

    $ make
    util v3.0

像这样在\ ``main.git``\ 中引入\ ``util.git``\ 显然不能满足需要，因为在\
``main.git``\ 的本地克隆版本库中，\ ``master``\ 分支访问不到只有在\
``util-branch``\ 分支中才出现的\ ``util``\ 版本库数据。这就需要做进一步\
的工作，将两个版本库的内容合并到一个分支中。即\ ``util-branch``\ 分支的\
数据作为子目录加入到\ ``master``\ 分支。

子目录方式合并外部版本库
=========================

下面就用git的底层命令\ :command:`git read-tree`\ 、\ :command:`git write-tree`\ 、\
:command:`git commit-tree`\ 子命令实现将\ ``util-branch``\ 分支所包含的\
``util.git``\ 版本库的目录树以子目录（\ :file:`lib/`\ ）型式添加到\
``master``\ 分支。

先来看看\ ``util-branch``\ 分支当前最新提交，记住最新提交所指向的目录树\
（tree），即tree-id：0c743e4。

::

  $ git cat-file -p util-branch
  tree 0c743e49e11019678c8b345e667504cb789431ae
  parent f21f9c10cc248a4a28bf7790414baba483f1ec15
  author Jiang Xin <jiangxin@ossxp.com> 1288494998 +0800
  committer Jiang Xin <jiangxin@ossxp.com> 1288494998 +0800

  util v2.0 -> v3.0

查看tree 0c743e4所包含的内容，会看到两个文件：\ :file:`Makefile`\ 和\
:file:`version`\ 。

::

  $ git cat-file -p 0c743e4
  100644 blob 07263ff95b4c94275f4b4735e26ea63b57b3c9e3    Makefile
  100644 blob bebe6b10eb9622597dd2b641efe8365c3638004e    version

切换到master分支，如下方式调用\ :command:`git read-tree`\ 将\
``util-branch``\ 分支的目录树读取到当前分支\ :file:`lib`\ 目录下。

* 切换到master分支。

  ::

    $ git checkout master

* 执行\ :command:`git read-tree`\ 命令，将分支\ ``util-branch``\ 读取到\
  当前分支的一个子目录下。

  ::

    $ git read-tree --prefix=lib util-branch

* 调用\ :command:`git read-tree`\ 只是更新了index，所以查看工作区状态，\
  会看到\ :file:`lib`\ 目录下的两个文件在工作区中还不存在。

  ::

    $ git status
    # On branch master
    # Changes to be committed:
    #   (use "git reset HEAD <file>..." to unstage)
    #
    #       new file:   lib/Makefile
    #       new file:   lib/version
    #
    # Changed but not updated:
    #   (use "git add/rm <file>..." to update what will be committed)
    #   (use "git checkout -- <file>..." to discard changes in working directory)
    #
    #       deleted:    lib/Makefile
    #       deleted:    lib/version
    #

* 执行检出命令，将\ :file:`lib`\ 目录下的文件更新出来。

  ::

    $ git checkout -- lib

* 再次查看状态，会看到前面执行的\ :command:`git read-tree`\ 命令添加到\
  暂存区中的文件。

  ::

    $ git status
    # On branch master
    # Changes to be committed:
    #   (use "git reset HEAD <file>..." to unstage)
    #
    #       new file:   lib/Makefile
    #       new file:   lib/version
    #


现在还不能忙着提交，因为如果现在进行提交就体现不出来两个分支的合并关系。\
需要使用Git底层的命令进行数据提交。

* 调用\ :command:`git write-tree`\ 将暂存区的目录树保存下来。

  要记住调用\ :command:`git write-tree`\ 后形成的新的tree-id：2153518。

  ::

    $ git write-tree
    2153518409d218609af40babededec6e8ef51616

* 执行\ :command:`git cat-file`\ 命令显示这棵树的内容，会注意到其中\
  :file:`lib`\ 目录的tree-id和之前查看过的\ ``util-branch``\ 分支最新提交\
  对应的tree-id一样都是0c743e4。

  ::
    
    $ git cat-file -p 2153518409d218609af40babededec6e8ef51616
    100644 blob 07263ff95b4c94275f4b4735e26ea63b57b3c9e3    Makefile
    040000 tree 0c743e49e11019678c8b345e667504cb789431ae    lib
    100644 blob 638c7b7c6bdbde1d29e0b55b165f755c8c4332b5    version

* 要手工创建一个合并提交，即新的提交要有两个父提交。这两个父提交分别是\
  ``master``\ 分支和\ ``util-branch``\ 分支的最新提交。用下面的命令显示\
  两个提交的提交ID，并记下这两个提交ID。

  ::

    $ git rev-parse HEAD
    911b1af2e0c95a2fc1306b8dea707064d5386c2e
    $ git rev-parse util-branch
    12408a149bfa78a4c2d4011f884aa2adb04f0934

* 执行\ :command:`git commit-tree`\ 命令手动创建提交。新提交的目录树来自\
  上面\ :command:`git write-tree`\ 产生的目录树（tree-id为2153518），\
  而新提交（合并提交）的两个父提交直接用上面\ :command:`git rev-parse`\
  显示的两个提交ID表示。

  ::

    $ echo "subtree merge" | \
      git commit-tree 2153518409d218609af40babededec6e8ef51616 \
      -p 911b1af2e0c95a2fc1306b8dea707064d5386c2e \
      -p 12408a149bfa78a4c2d4011f884aa2adb04f0934
    62ae6cc3f9280418bdb0fcf6c1e678905b1fe690

* 执行\ :command:`git commit-tree`\ 命令的输出是提交之后产生的新提交的提\
  交ID。需要把当前的master分支重置到此提交ID。

  ::
    
    $ git reset 62ae6cc3f9280418bdb0fcf6c1e678905b1fe690

* 查看一下提交日志及分支图，可以看到通过复杂的\ :command:`git read-tree`\ 、\
  :command:`git write-tree`\ 和\ :command:`git commit-tree`\ 命令制造\
  的合并提交，的确将两个不同版本库合并到一起了。

  ::

    $ git log --graph --pretty=oneline
    *   62ae6cc3f9280418bdb0fcf6c1e678905b1fe690 subtree merge
    |\  
    | * 12408a149bfa78a4c2d4011f884aa2adb04f0934 util v2.0 -> v3.0
    | * f21f9c10cc248a4a28bf7790414baba483f1ec15 util v1.0 -> v2.0
    | * 76db0ad729db9fdc5be043f3b4ed94ddc945cd7f util v1.0
    * 911b1af2e0c95a2fc1306b8dea707064d5386c2e main v2010.1

* 看看现在的master分支。

  ::

    $ git cat-file -p HEAD
    tree 2153518409d218609af40babededec6e8ef51616
    parent 911b1af2e0c95a2fc1306b8dea707064d5386c2e
    parent 12408a149bfa78a4c2d4011f884aa2adb04f0934
    author Jiang Xin <jiangxin@ossxp.com> 1288498186 +0800
    committer Jiang Xin <jiangxin@ossxp.com> 1288498186 +0800

    subtree merge

* 看看目录树。

  ::

    $ git cat-file -p 2153518409d218609af40babededec6e8ef51616
    100644 blob 07263ff95b4c94275f4b4735e26ea63b57b3c9e3    Makefile
    040000 tree 0c743e49e11019678c8b345e667504cb789431ae    lib
    100644 blob 638c7b7c6bdbde1d29e0b55b165f755c8c4332b5    version

整个过程非常繁琐，但是不要太过担心，只需要对原理了解清楚就可以了，因为在\
后面会介绍一个Git插件封装了复杂的子树合并操作。

利用子树合并跟踪上游改动
========================

如果子树（\ :file:`lib`\ 目录）的上游（即\ ``util.git``\ ）包含了新的提交，\
如何将\ ``util.git``\ 的新提交合并过来呢？这就要用到名为subtree的合并策略。\
参见第3篇第16章第16.6小节“合并策略”中相关内容。

在执行子树合并之前，先切换到\ ``util-branch``\ 分支，获取远程版本库改动。

::

  $ git checkout util-branch

  $ git pull
  remote: Counting objects: 8, done.
  remote: Compressing objects: 100% (4/4), done.
  remote: Total 6 (delta 0), reused 0 (delta 0)
  Unpacking objects: 100% (6/6), done.
  From /path/to/repos/util
     12408a1..5aba14f  master     -> util/master
  Updating 12408a1..5aba14f
  Fast-forward
   version |    2 +-
   1 files changed, 1 insertions(+), 1 deletions(-)

  $ git checkout master

在切换回master分支后，如果这时执行\ :command:`git merge util-branch`\ ，\
会将\ ``uitl-branch``\ 的数据直接合并到\ ``master``\ 分支的根目录下，而\
实际上是希望合并发生在\ :file:`lib`\ 目录中，这就需要如下方式进行调用，\
以subtree策略进行合并。

如果Git的版本小于1.7，直接使用subtree合并策略。

::

  $ git merge -s subtree util-branch

如果Git的版本是1.7之后（含1.7）的版本，则可以使用缺省的recursive合并策略，\
通过参数\ ``subtree=<prefix>``\ 在合并时使用正确的子树进行匹配合并。避免\
了使用subtree合并策略时的猜测。

::

  $ git merge -Xsubtree=lib util-branch

再来看看执行子树合并之后的分支图示。

::

  $ git log --graph --pretty=oneline
  *   f1a33e55eea04930a500c18a24a8bd009ecd9ac2 Merge branch 'util-branch'
  |\  
  | * 5aba14fd347fc22cd8fbd086c9f26a53276f15c9 util v3.1 -> v3.2
  | * a6d53dfcf78e8a874e9132def5ef87a2b2febfa5 util v3.0 -> v3.1
  * |   62ae6cc3f9280418bdb0fcf6c1e678905b1fe690 subtree merge
  |\ \  
  | |/  
  | * 12408a149bfa78a4c2d4011f884aa2adb04f0934 util v2.0 -> v3.0
  | * f21f9c10cc248a4a28bf7790414baba483f1ec15 util v1.0 -> v2.0
  | * 76db0ad729db9fdc5be043f3b4ed94ddc945cd7f util v1.0
  * 911b1af2e0c95a2fc1306b8dea707064d5386c2e main v2010.1

子树拆分
==========

既然可以将一个代码库通过子树合并方式作为子目录加入到另外一个版本库中，反\
之也可以将一个代码库的子目录独立出来转换为另外的版本库。不过这个反向过程\
非常复杂。要将一个版本库的子目录作为顶级目录导出到另外的项目，潜藏的条件\
是要导出历史的，因为如果不关心历史，直接文件拷贝重建项目就可以了。子树拆\
分的大致过程是：

1. 找到要导出的目录的提交历史，并反向排序。
2. 依次对每个提交执行下面的操作：
3. 找出提交中导出目录对应的tree-id。
4. 对该tree-id执行\ :command:`git commit-tree`\ 。
5. 执行\ :command:`git commit-tree`\ 要保持提交信息还要重新设置提交的父\
   提交（parent）。

手工执行这个操作复杂且易出错，可以用下节介绍的\ ``git subtree``\ 插件，\
或使用第6篇第35.4小节“Git版本库整理”中介绍的\ :command:`git filter-branch`\
命令进行子目录过滤。

``git subtree``\ 插件
==========================

Git subtree插件用shell脚本开发，安装之后为Git提供了新的\ :command:`git subtree`\
命令，支持前面介绍的子树合并和子树拆分。命令非常简单易用，将其他版本库\
以子树形式导入，再也不必和底层的Git命令打交道了。

Gitsubtree 插件的作者将代码库公布在Github上：\ http://github.com/apenwarr/git-subtree/\ 。

安装Git subtree很简单：

::

  $ git clone git://github.com/apenwarr/git-subtree.git
  $ cd git-subtree
  $ make doc
  $ make test
  $ sudo make install

:command:`git subtree add`
------------------------------

命令\ :command:`git subtree add`\ 相当于将其他版本库以子树方式加入到当前\
版本库。用法：

::

  git subtree add [--squash] -P <prefix> <commit>
  git subtree add [--squash] -P <prefix> <repository> <refspec>

其中可选的\ ``--squash``\ 含义为压缩为一个版本后再添加。

对于文章中的示例，为了将\ ``util.git``\ 合并到\ ``main.git``\ 的\
:file:`lib`\ 目录。可以直接这样调用：

::

  $ git subtree add -P lib /path/to/repos/util.git master

不过推荐的方法还是先在本地建立\ ``util.git``\ 版本库的追踪分支。

::

  $ git remote add util /path/to/repos/util.git
  $ git fetch util
  $ git checkout -b util-branch util/master
  $ git subtree add -P lib util-branch
  
:command:`git subtree merge`
---------------------------------

命令\ :command:`git subtree merge`\ 相当于将子树对应的远程分支的更新重新\
合并到子树中，相当于完成了\ :command:`git merge -s subtree`\ 操作。用法：

::

  git subtree merge [--squash] -P <prefix> <commit>

其中可选的\ ``--squash``\ 含义为压缩为一个版本后再合并。

对于文章中的示例，为了将\ ``util-branch``\ 分支包含的上游最新改动合并到\
master分支的\ :file:`lib`\ 目录。可以直接这样调用：

::

  $ git subtree merge -P lib util-branch

:command:`git subtree pull`
-------------------------------

命令\ :command:`git subtree pull`\ 相当于先对子树对应的远程版本库执行一次\
:command:`git fetch`\ 操作，然后再执行\ :command:`git subtree merge`\ 。用法：

::

  git subtree pull [--squash] -P <prefix> <repository> <refspec...>

对于文章中的示例，为了将\ ``util.git``\ 版本库的master分支包含的最新改动\
合并到master分支的\ :file:`lib`\ 目录。可以直接这样调用：

::

  $ git subtree pull -P lib /path/to/repos/util.git master

更喜欢用前面介绍的\ :command:`git subtree merge`\ 命令，因为\
:command:`git subtree pull`\ 存在版本库地址写错的风险。

:command:`git subtree split`
------------------------------

命令\ :command:`git subtree split`\ 相当将目录拆分为独立的分支，即子树拆\
分。拆分后形成的分支可以通过推送到新的版本库实现原版本库的目录独立为一个\
新的版本库。用法：

::

  git subtree split -P <prefix> [--branch <branch>] [--onto ...] [--ignore-joins] [--rejoin] <commit...>

说明：

* 该命令的总是输出子树拆分后的最后一个commit-id。这样可以通过管道方式传\
  递给其他命令，如\ :command:`git subtree push`\ 命令。

* 参数\ ``--branch``\ 提供拆分后创建的分支名称。如果不提供，只能通过\
  :command:`git subtree split`\ 命令提供的提交ID得到拆分的结果。

* 参数\ ``--onto``\ 参数将目录拆分附加于已经存在的提交上。

* 参数\ ``--ignore-joins``\ 忽略对之前拆分历史的检查。

* 参数\ ``--rejoin``\ 会将拆分结果合并到当前分支，因为采用ours的合并策略，\
  不会破坏当前分支。

:command:`git subtree push`
-------------------------------

命令\ :command:`git subtree push`\ 先执行子树拆分，再将拆分的分支推送到\
远程服务器。用法：

::

  git subtree push -P <prefix> <repository> <refspec...>

该命令的用法和\ :command:`git subtree split`\ 类似，不再赘述。
