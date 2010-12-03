子树合并
****************

使用子树合并，同样可以实现在一个项目中引用其它项目的数据。但是和子模组方式不同的是，使用子树合并模式，外部的版本库整个复制到本版本库中并建立跟踪关联。使用子树合并模型，使得对源自外部版本库的数据的访问和本版本库数据的访问没有区别，也可以对其进行本地修改，并且能够通过子树合并的方式将对源自外部版本库的改动和本地的修改相合并。

引入外部版本库
===============

为演示子树合并，需要至少准备两个版本库，一个是将被作为子目录引入的版本库 util.git ，另外一个是主版本库 main.git 。

::

  $ git --git-dir=/path/to/util.git init --bare
  $ git --git-dir=/path/to/main.git init --bare

在本地检出这两个版本库：

::

  $ git clone /path/to/util.git
  $ git clone /path/to/main.git

需要为这两个空版本库添加些数据。非常简单，每个版本库下只创建两个文件： Makefile 和 version。当执行 make 命令时显示 version 文件的内容。对 version 文件多次提交以建立多个提交历史。别忘记在最后使用 `git push origin master` 将版本库推送到远程版本库中。

Makefile 文件示例如下：

::

  all:
  	  @cat version

在之前尝试的 git fetch 命令都是获取同一项目的版本库的内容。其实命令 git fetch 并不禁止用来获取不同项目的版本库数据，因为 Git 的版本库不像 Subversion 那样用一个唯一的 UUID 标识让 Subversion 的版本库之间势同水火。当然也可以用 git pull 来获取其它版本库中的提交，但是那样将把两个项目的文件彻底混杂在一起。对于这个示例来说，因为两个项目具有同样的文件 Makefile 和 version，使用 git pull 将导致冲突。所以为了将不同项目的版本库引入，需要用 `git fetch` 。

为了便于以后对外部版本库的跟踪，在使用 git fetch 时，最好先在 main 版本库中注册远程版本库 util.git。

::

  $ git remote add util /path/to/util.git

  $ git remote -v
  origin  /path/to/main.git/ (fetch)
  origin  /path/to/main.git/ (push)
  util    /path/to/util.git (fetch)
  util    /path/to/util.git (push)

  $ git fetch util

  $ git branch -a
  * master
    remotes/origin/master
    remotes/util/master

基于 remotes/util/master 创建一个本地分支，会看到根目录的 Makefile 和 version 属于原 util.git 版本库，而非 main.git 版本库。

::

  $ make
  main v2010.1

  $ git checkout -b util-branch util/master
  Branch util-branch set up to track remote branch master from util.
  Switched to a new branch 'util-branch'

  $ git branch -a
    master
  * util-branch
    remotes/origin/master
    remotes/util/master

  $ make
  util v3.0

像这样在 main.git 中引入 util.git 显然不能满足需要，因为在 main.git 的本地克隆版本库中，master 分支访问不到只有在 util-branch 分支中才出现的 util 版本库数据。这就需要做进一步的工作，将两个版本库的内容合并到一个分支中。即 util-branch 分支的数据作为子目录加入到 master 分支。

子目录方式合并外部版本库
=========================

下面就用 git 的低端命令 `git read-tree`, `git write-tree`, `git commit-tree` 子命令实现将 util-branch 分支所包含的 util.git 版本库的目录树以子目录（lib/）型式添加到 master 分支。

先来看看 util-branch 分支当前最新提交所指向的目录树（tree）。

::

  $ git cat-file -p util-branch
  tree 0c743e49e11019678c8b345e667504cb789431ae
  parent f21f9c10cc248a4a28bf7790414baba483f1ec15
  author Jiang Xin <jiangxin@ossxp.com> 1288494998 +0800
  committer Jiang Xin <jiangxin@ossxp.com> 1288494998 +0800

  util v2.0 -> v3.0

这是 util-branch 分支中最新提交所包含的信息。记住该提交对应的 tree id 为： 0c743e4 。

查看 tree 0c743e4 所包含的内容。

::

  $ git cat-file -p 0c743e4
  100644 blob 07263ff95b4c94275f4b4735e26ea63b57b3c9e3    Makefile
  100644 blob bebe6b10eb9622597dd2b641efe8365c3638004e    version

切换到 master 分支，如下方式调用 `git read-tree` 将 util-branch 的目录树读取到当前分支 lib 目录下。

::

  $ git checkout master

  $ git read-tree --prefix=lib util-branch

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

  $ git checkout -- lib

  $ git status
  # On branch master
  # Changes to be committed:
  #   (use "git reset HEAD <file>..." to unstage)
  #
  #       new file:   lib/Makefile
  #       new file:   lib/version
  #

调用 git read-tree 只是更新了 index，所以上面还用一条 `git checkout -- lib` 命令更新了工作区 lib 目录的内容。

现在还不能提交，因为现在提交体现不出来两个分支的合并关系。

调用 `git write-tree` 将 index （暂存区）的目录树保存下来。

::

  $ git write-tree
  2153518409d218609af40babededec6e8ef51616
  
  $ git cat-file -p 2153518409d218609af40babededec6e8ef51616
  100644 blob 07263ff95b4c94275f4b4735e26ea63b57b3c9e3    Makefile
  040000 tree 0c743e49e11019678c8b345e667504cb789431ae    lib
  100644 blob 638c7b7c6bdbde1d29e0b55b165f755c8c4332b5    version

要记住调用 `git write-tree` 后形成的新的 tree-id： 2153518。仔细查看 "git cat-file" 命令的输出，会注意到该 tree-id 指向的目录树中包含的 lib 目录的 treeid 和之前查看过的 util-branch 分支最新提交对应的 treeid 一样都是 0c743e4。

然后要调用 git commit-tree 来产生新的提交。之所以不用 `git commit` 而使用底层命令，是因为要为此新的提交指定两个 parents，让这个提交看起来是两棵树的合并。这两棵树分别是 master 分支和 util-branch 分支。

::

  $ git rev-parse HEAD
  911b1af2e0c95a2fc1306b8dea707064d5386c2e
  $ git rev-parse util-branch
  12408a149bfa78a4c2d4011f884aa2adb04f0934

就以上面两个 revid 为 parents，对树 2153518409d218609af40babededec6e8ef51616 执行提交。

::

  $ echo "subtree merge" | \
    git commit-tree 2153518409d218609af40babededec6e8ef51616 \
    -p 911b1af2e0c95a2fc1306b8dea707064d5386c2e \
    -p 12408a149bfa78a4c2d4011f884aa2adb04f0934
  62ae6cc3f9280418bdb0fcf6c1e678905b1fe690

提交之后产生一个新的 commit id。需要把当前的 master 分支重置到此 commitid。

::
  
  $ git reset 62ae6cc3f9280418bdb0fcf6c1e678905b1fe690

查看一下提交日记及分支图，可以看到通过复杂的 `git read-tree` , `git write-tree` 和 `git commit-tree` 制造的提交，的确将两个不同版本库合并到一起了。

::

  $ git log --graph --pretty=oneline
  *   62ae6cc3f9280418bdb0fcf6c1e678905b1fe690 subtree merge
  |\  
  | * 12408a149bfa78a4c2d4011f884aa2adb04f0934 util v2.0 -> v3.0
  | * f21f9c10cc248a4a28bf7790414baba483f1ec15 util v1.0 -> v2.0
  | * 76db0ad729db9fdc5be043f3b4ed94ddc945cd7f util v1.0
  * 911b1af2e0c95a2fc1306b8dea707064d5386c2e main v2010.1

看看现在的 master 分支。

::

  $ git cat-file -p HEAD
  tree 2153518409d218609af40babededec6e8ef51616
  parent 911b1af2e0c95a2fc1306b8dea707064d5386c2e
  parent 12408a149bfa78a4c2d4011f884aa2adb04f0934
  author Jiang Xin <jiangxin@ossxp.com> 1288498186 +0800
  committer Jiang Xin <jiangxin@ossxp.com> 1288498186 +0800

  subtree merge

  $ git cat-file -p 2153518409d218609af40babededec6e8ef51616
  100644 blob 07263ff95b4c94275f4b4735e26ea63b57b3c9e3    Makefile
  040000 tree 0c743e49e11019678c8b345e667504cb789431ae    lib
  100644 blob 638c7b7c6bdbde1d29e0b55b165f755c8c4332b5    version


整个过程非常繁琐，但是不要太过担心，只需要对原理了解清楚就可以了，因为在后面会介绍一个 Git 插件封装了复杂的子树合并操作。

利用子树合并跟踪上游改动
========================

如果合并子树（lib 目录）的上游（即 util.git）包含了新的提交，如何将 util.git 的新提交合并过来呢？这就要用到名为 subtree 的合并策略。参见前面关于合并的相关章节。

在执行子树合并之前，先切换到 util-branch 分支，获取远程版本库改动。

::

  $ git checkout util-branch

  $ git pull
  remote: Counting objects: 8, done.
  remote: Compressing objects: 100% (4/4), done.
  remote: Total 6 (delta 0), reused 0 (delta 0)
  Unpacking objects: 100% (6/6), done.
  From /path/to/util
     12408a1..5aba14f  master     -> util/master
  Updating 12408a1..5aba14f
  Fast-forward
   version |    2 +-
   1 files changed, 1 insertions(+), 1 deletions(-)

  $ git checkout master

在切换回 master 分支后，如果这时执行 `git merge util-branch` ，会将 uitl-branch 的数据直接合并到 master 分支的根目录下，而实际上是希望合并发生在 lib 目录中，这就需要如下方式进行调用。

如果 git 的版本小于 1.7，直接使用 subtree 合并策略。

::

  $ git merge -s subtree util-branch

如果 git 的版本是 1.7 之后（含1.7）的版本，则可以使用缺省的 recursive 合并策略，通过参数 subtree=<prefix> 在合并时使用正确的子树进行匹配合并。避免了使用 subtree 合并策略时的猜测。

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

既然可以将一个代码库通过子树合并方式作为子目录加入到另外一个版本库中，反之也可以将一个代码库的子目录独立出来转换为另外的版本库。不过这个反向过程异常复制。

要将一个版本库的子目录作为顶级目录导出到另外的项目，潜藏的条件是要导出历史的，因为如果不关心历史，直接文件拷贝重建项目就可以了。子树拆分的大致过程是：

1. 找到要导出的目录的提交历史，并反向排序。
2. 依次对每个提交执行下面的操作：
3. 找出提交中导出目录对应的 tree id。
4. 对该 tree id 执行 `git commit-tree` 。
5. 执行 `git commit-tree` 要保持提交信息还要重新设置提交的 parents。

这个过程复杂且易出错，幸好已经有人开发出 Git 的插件，实现了前面提到的子树合并和子树拆分。

git subtree 插件
=================

Git subtree 插件用 shell 脚本开发，安装之后为 Git 提供了新的 `git subtree` 命令，支持前面介绍的子树合并和子树拆分。命令非常简单易用，用户再也不必和低端的 Git 命令打交道了。

Git subtree 插件的作者将代码库公布在 Github 上： http://github.com/apenwarr/git-subtree/ 。

安装 Git subtree 很简单：

::

  $ git clone git://github.com/apenwarr/git-subtree.git
  $ cd git-subtree
  $ make doc
  $ make test
  $ sudo make install

git subtree add
----------------

命令 `git subtree add` 相当于完成将其它版本库以子目录方式加入到当前版本库。用法：

::

  git subtree add [--squash] -P <prefix> <commit>
  git subtree add [--squash] -P <prefix> <repository> <refspec>

其中可选的 `--squash` 含义为压缩为一个版本后再添加。

对于文章中的示例，为了将 util.git 合并到 main.git 的 lib 目录。可以直接这样调用：

::

  $ git subtree add -P lib /path/to/util.git master

不过推荐的方法还是先在本地建立 util.git 版本库的追踪分支。

::

  $ git remote add util /path/to/util.git
  $ git fetch util
  $ git checkout -b util-branch util/master
  $ git subtree add -P lib util-branch
  
git subtree merge
-----------------

命令 `git subtree merge` 相当于将外部版本库跟踪分支的更新合并到子目录中，相当于完成了 `git merge -s subtree` 。用法：

::

  git subtree merge [--squash] -P <prefix> <commit>

其中可选的 `--squash` 含义为压缩为一个版本后再合并。

对于文章中的示例，为了将 util-branch 分支包含的上游最新改动合并到 master 分支 的 lib 目录。可以直接这样调用：

::

  $ git subtree merge -P lib util-branch

git subtree pull
-----------------

命令 `git subtree pull` 相当于从外部版本库执行一次 fetch，然后再执行 `git subtree merge` 。用法：

::

  git subtree pull [--squash] -P <prefix> <repository> <refspec...>

对于文章中的示例，为了将 util.git 版本库的 master 分支包含的最新改动合并到 master 分支 的 lib 目录。可以直接这样调用：

::

  $ git subtree pull -P lib /path/to/util.git master

更喜欢用前面介绍的 `git subtree merge` 命令，因为 `git subtree pull` 存在版本库地址写错的风险。

git subtree split
-----------------

命令 `git subtree split` 相当将目录拆分为独立的分支，即子树拆分。拆分后形成的分支可以通过推送到新的版本库实现原版本库的目录独立为一个新的版本库。用法：

::

  git subtree split -P <prefix> [--branch <branch>] [--onto ...] [--ignore-joins] [--rejoin] <commit...>

说明：

* 该命令的总是输出子树拆分后的最后一个 commit-id。这样可以通过管道方式传递给其它命令，如 `git subtree push` 命令。
* 参数 `--branch` 提供拆分后创建的分支名称。如果不提供，只能通过 git subtree split 命令提供的 commit_id 得到拆分的结果。
* 参数 `--onto` 参数将目录拆分附加于已经存在的提交上。
* 参数 `--ignore-joins` 忽略对之前拆分历史的检查。
* 参数 `--rejoin` 会将拆分结果合并到当前分支，因为采用 ours 的合并策略，不会破坏当前分支。

git subtree push
-----------------

命令 `git subtree push` 先执行子树拆分，再将拆分的分支推送到远程服务器。用法：

::

  git subtree push -P <prefix> <repository> <refspec...>

