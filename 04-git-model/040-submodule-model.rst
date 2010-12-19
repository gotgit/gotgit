子模组协同模型
**************

项目的版本库某些情况下需要引用其它版本库中的文件，例如公司积累了一套常用的函数库，被多个项目调用，显然这个函数库的代码不能直接放到某个项目的代码中，而是要独立为一个代码库，那么其它项目要调用公共的函数库，该如何处理呢？分别把公共函数库的文件拷贝到各自的项目中，会造成冗余，丢弃了公共函数库的维护历史，显然不是好的方法。本节要讨论的子模组协同模型，就是解决这个问题的一个方案。

熟悉 Subversion 的用户马上会想起 svn:externals 属性，可以实现对外部代码库的引用。Git 的子模组（submodule）是类似的一种实现。不过因为 Git 的特殊性，二者的区别还是满大的。

  +-----------------------------------------+----------------------------------+----------------------------------+
  |                                         | svn:externals                    | git submodule                    |
  +=========================================+==================================+==================================+
  | 如何记录外部版本库地址？                | 目录的 svn:externals 属性        | 项目根目录下的 .gitmodules 文件  |
  +-----------------------------------------+----------------------------------+----------------------------------+
  | 缺省是否自动检出外部版本库？            | 是。在使用 svn checkout 检出时   | 否。缺省不克隆外部版本库。       |
  |                                         | 若使用参数 --ignore-externals    | 克隆要用 git submodule init,     |
  |                                         | 可以忽略对外部版本库引用不检出。 | git submodule update 命令。      |
  +-----------------------------------------+----------------------------------+----------------------------------+
  | 是否能 **部分** 引用外部版本库内容？    | 是。因为 SVN 支持部分检出。      | 否。必须克隆整个外部版本库。     |
  +-----------------------------------------+----------------------------------+----------------------------------+
  | 是否可以指向分支而随之改变？            | 是。                             | 否。固定于外部版本库某个提交。   |
  +-----------------------------------------+----------------------------------+----------------------------------+

创建子模组
==========

在演示子模组的创建和使用之前，先作些准备工作。先尝试建立两个公共函数库（libA.git 和 libB.git）以及一个引用函数库的主版本库（super.git）。

::

$ git --git-dir=/path/to/repos/libA.git init --bare
$ git --git-dir=/path/to/repos/libB.git init --bare
$ git --git-dir=/path/to/repos/super.git init --bare

向两个公共的函数库中填充些数据。这就需要在工作区克隆两个函数库，提交数据，并推送。

::

  $ git clone /path/to/repos/libA.git 
  $ cd libA
  hack ...
  $ git add .
  $ git commit -m "add data for libA"
  $ git push origin master
  $ cd ..
  
  $ git clone /path/to/repos/libB.git
  $ cd libB
  hack ...
  $ git add .
  $ git commit -m "add data for libB"
  $ git push origin master
  $ cd ..

版本库 super 是准备在其中创建子模组的。super 版本库刚刚初始化还未包含提交，master 分支尚未有正确的引用。需要在 super 版本中至少创建一个提交。

::

  $ git clone /path/to/repos/super.git
  warning: You appear to have cloned an empty repository.
  $ cd super
  $ git commit --allow-empty -m "initialized."
  [master (root-commit) c990091] initialized.
  $ git push origin master

现在就可以在 super 版本库中使用 `git submodule add` 添加子模组了。

::

  $ git submodule add /path/to/repos/libA.git lib/lib_a

  $ git submodule add /path/to/repos/libB.git lib/lib_b

至此看一下 super 版本库工作区的目录结构。在根目录下多了一个 .gitmodules 文件，并且两个函数库分别克隆到 lib/lib_a 目录和 lib/lib_b 目录下。

::

  $ ls -aF
  ./  ../  .git/  .gitmodules  lib/

看看 .gitmodules 的内容：

::

  $ cat .gitmodules 
  [submodule "lib/lib_a"]
          path = lib/lib_a
          url = /path/to/repos/libA.git
  [submodule "lib/lib_b"]
          path = lib/lib_b
          url = /path/to/repos/libB.git

此时 super 的工作区尚未提交。

::

  $ git status
  # On branch master
  # Changes to be committed:
  #   (use "git reset HEAD <file>..." to unstage)
  #
  #       new file:   .gitmodules
  #       new file:   lib/lib_a
  #       new file:   lib/lib_b
  #

完成提交之后，子模组才算正式在 super 版本库中创立。运行 `git push` 把建立了新模组的本地库推送到远程的版本库。

::

  $ git commit -m "add modules in lib/lib_a and lib/lib_b."
  $ git push

在提交过程中，发现作为子模组方式添加的版本库实际上并没有添加版本库的内容。实际上只是以 gitlink 方式添加了一个链接。至于子模组的实际地址，是由文件 .gitmodules 中指定的。

可以通过查看补丁的方式，看到 lib/lib_a 和 lib/lib_b 子模组的存在模式。

::

  $ git show HEAD

  commit 19bb54239dd7c11151e0dcb8b9389e146f055ba9
  Author: Jiang Xin <jiangxin@ossxp.com>
  Date:   Fri Oct 29 10:16:59 2010 +0800

      add modules in lib/lib_a and lib/lib_b.

  diff --git a/.gitmodules b/.gitmodules
  new file mode 100644
  index 0000000..60c7d1f
  --- /dev/null
  +++ b/.gitmodules
  @@ -0,0 +1,6 @@
  +[submodule "lib/lib_a"]
  +       path = lib/lib_a
  +       url = /path/to/repos/libA.git
  +[submodule "lib/lib_b"]
  +       path = lib/lib_b
  +       url = /path/to/repos/libB.git
  diff --git a/lib/lib_a b/lib/lib_a
  new file mode 160000
  index 0000000..126b181
  --- /dev/null
  +++ b/lib/lib_a
  @@ -0,0 +1 @@
  +Subproject commit 126b18153583d9bee4562f9af6b9706d2e104016
  diff --git a/lib/lib_b b/lib/lib_b
  new file mode 160000
  index 0000000..3b52a71
  --- /dev/null
  +++ b/lib/lib_b
  @@ -0,0 +1 @@
  +Subproject commit 3b52a710068edc070e3a386a6efcbdf28bf1bed5

克隆带子模组的版本库
=====================

之前在对比 Subversion 的 svn:externals 子模组实现差异时，提到过克隆带子模组的 Git 库，并不能自动将子模组的版本库克隆出来。对于只关心项目本身数据，对项目引用的外部项目数据并不关心的用户，这个功能非常好，数据也没有冗余而且克隆的速度也更块。

下面在另外的位置克隆 super 版本库，会发现 lib/lib_a 和 lib/lib_b 并未克隆。

::

  $ git clone /path/to/repos/super.git super-clone

  $ cd super-clone

  $ ls -aF
  ./  ../  .git/  .gitmodules  lib/

  $ find lib
  lib
  lib/lib_a
  lib/lib_b


这时如果运行 `git submodule status` 可以查看到子模组状态。

::

  $ git submodule status
  -126b18153583d9bee4562f9af6b9706d2e104016 lib/lib_a
  -3b52a710068edc070e3a386a6efcbdf28bf1bed5 lib/lib_b

看到每个子模组的目录前面是40位的提交ID，在最前面是一个减号。减号的含义是该子模组尚为检出。

如果需要克隆出子模组型式引用的外部库，首先需要先执行 `git submodule init` 。

::

  $ git submodule init
  Submodule 'lib/lib_a' (/path/to/repos/libA.git) registered for path 'lib/lib_a'
  Submodule 'lib/lib_b' (/path/to/repos/libB.git) registered for path 'lib/lib_b'

执行 `git submodule init` 实际上修改了 `.git/config` 文件，对子模组进行了注册。文件 `.git/config` 的修改示例如下（以加号开始的行代表新增的行）。

::

   [core]
           repositoryformatversion = 0
           filemode = true
           bare = false
           logallrefupdates = true
   [remote "origin"]
           fetch = +refs/heads/*:refs/remotes/origin/*
           url = /path/to/repos/super.git
   [branch "master"]
           remote = origin
           merge = refs/heads/master
  +[submodule "lib/lib_a"]
  +       url = /path/to/repos/libA.git
  +[submodule "lib/lib_b"]
  +       url = /path/to/repos/libB.git

然后执行 `git submodule update` 才完成子模组版本库的克隆。

::

  $ git submodule update
  Initialized empty Git repository in /data/tmp/super-clone/lib/lib_a/.git/
  Submodule path 'lib/lib_a': checked out '126b18153583d9bee4562f9af6b9706d2e104016'
  Initialized empty Git repository in /data/tmp/super-clone/lib/lib_b/.git/
  Submodule path 'lib/lib_b': checked out '3b52a710068edc070e3a386a6efcbdf28bf1bed5'


在子模组中修改和子模组的更新
============================

执行 `git submodule update` 更新出来的子模组，都以某个具体的提交版本进行检出。进入某个子模组目录，会发现其处于非跟踪状态。

::

  $ cd lib/lib_a

  $ git branch
  * (no branch)
    master

  $ cd ../..

显然这种情况下，如果修改 lib/lib_a 下的文件，提交会丢失。下面介绍一下如何在检出的子模组中修改，以及更新子模组。

在子模组中切换到 master 分支（或者其它想要修改的分支）后，再进行修改。

::

  $ cd lib/lib_a

  $ git checkout master

  hack ...

  $ git commit

  $ git status
  # On branch master
  # Your branch is ahead of 'origin/master' by 1 commit.
  #
  nothing to commit (working directory clean)

在 git status 的状态输出，可以看出新提交尚未推送到远程版本库。现在暂时不推送，看看在 super 版本库中执行 `git submodule update` 对子模组的影响。

::

  $ cd ../..

  $ git status
  # On branch master
  # Changed but not updated:
  #   (use "git add <file>..." to update what will be committed)
  #   (use "git checkout -- <file>..." to discard changes in working directory)
  #
  #       modified:   lib/lib_a (new commits)
  #
  no changes added to commit (use "git add" and/or "git commit -a")

  $ git submodule status
  +5dea2693e5574a6e3b3a59c6b0c68cb08b2c07e9 lib/lib_a (heads/master)
   3b52a710068edc070e3a386a6efcbdf28bf1bed5 lib/lib_b (heads/master)

在 super 版本库执行 `git status` 可以看到子模组已修改，包含更新的提交。通过 `git submodule stauts` 可以看出 lib/lib_a 子模组指向了新的提交ID（前面有一个加号），而 lib/lib_b 模组状态正常（提交ID前是一个空格，不是加号也不是减号）。

这时如果不小心执行了一次 `git submodule update` 命令，会将 lib/lib_a 重新切换到旧的指向。

::

  $ git submodule update
  Submodule path 'lib/lib_a': checked out '126b18153583d9bee4562f9af6b9706d2e104016'
  
  $ git submodule status
   126b18153583d9bee4562f9af6b9706d2e104016 lib/lib_a (remotes/origin/HEAD)
   3b52a710068edc070e3a386a6efcbdf28bf1bed5 lib/lib_b (heads/master)

那么刚才在 lib/lib_a 中的提交丢失了么？实际上因为已经提交到了 master 主线，因此没有丢失，但是如果有未提交数据就会造成数据丢失。

进到 lib/lib_a 目录，重新检出 master 分支找回之前的提交。

::

  $ cd lib/lib_a
  $ git branch
  * (no branch)
    master
  $ git checkout master
  Previous HEAD position was 126b181... add data for libA
  Switched to branch 'master'
  Your branch is ahead of 'origin/master' by 1 commit.

然后退回到 super 项目根目录，执行提交，完成 submodule 的更新。

::

  $ cd ../..

  $ git status -s
   M lib/lib_a

  $ git diff
  diff --git a/lib/lib_a b/lib/lib_a
  index 126b181..5dea269 160000
  --- a/lib/lib_a
  +++ b/lib/lib_a
  @@ -1 +1 @@
  -Subproject commit 126b18153583d9bee4562f9af6b9706d2e104016
  +Subproject commit 5dea2693e5574a6e3b3a59c6b0c68cb08b2c07e9

  $ git add -u

  $ git commit -m "submodule lib/lib_a upgrade to new version."

此时如果执行 `git push` 将 super 版本库推送到远程版本库，存在一个问题。即 super 的子模组 lib/lib_a 指向了一个新的提交，而该提交还在本地的 lib/lib_a 版本库中没有向上游推送，这会导致其他人克隆 super 版本库并更新模组时因为找不到该版本而导致出错。

::

  fatal: reference is not a tree: 5dea2693e5574a6e3b3a59c6b0c68cb08b2c07e9
  Unable to checkout '5dea2693e5574a6e3b3a59c6b0c68cb08b2c07e9' in submodule path 'lib/lib_a'

为了避免这种可能性的发生，最好先对 lib/lib_a 中的新提交进行推送，然后再对 super 的子模组更新的改动进行推送。即：

::

  $ cd lib/lib_a
  $ git push
  $ cd ../..
  $ git push

隐性子模组
==========

我在开发备份工具 Gistore 时遇到一个棘手的问题就是隐性子模组的问题。Gistore 备份工具的原理是将要备份的目录都挂载（mount）在工作区中，然后执行 `git add` 。但是如果有某个目录已经被 Git 化了，就只会以子模组方式将该目录添加进来，而不会添加该目录下的文件。对于一个备份工具来说，意味着备份没有成功。

例如当前 super 版本库下有两个子模组：

::

  $ git submodule status
   126b18153583d9bee4562f9af6b9706d2e104016 lib/lib_a (remotes/origin/HEAD)
   3b52a710068edc070e3a386a6efcbdf28bf1bed5 lib/lib_b (heads/master)

然后创建一个新目录 others，并把该目录用 git 初始化并做一次空的提交。

::

  $ mkdir others
  $ cd others
  $ git init
  $ git commit --allow-empty -m initial
  [master (root-commit) 90364e1] initial

还在 others 目录下创建一个文件 `newfile` 。

::

  $ date > newfile

回到上一级目录，执行 `git status` ，看到有一个 others 目录没有加入版本库控制，这很自然。

::

  $ cd ..

  $ git status
  # On branch master
  # Untracked files:
  #   (use "git add <file>..." to include in what will be committed)
  #
  #       others/
  nothing added to commit but untracked files present (use "git add" to track)

但是如果对 others 目录执行 `git add` 后，会发现奇怪的状态。

::

  $ git add others

  $ git status
  # On branch master
  # Changes to be committed:
  #   (use "git reset HEAD <file>..." to unstage)
  #
  #       new file:   others
  #
  # Changed but not updated:
  #   (use "git add <file>..." to update what will be committed)
  #   (use "git checkout -- <file>..." to discard changes in working directory)
  #   (commit or discard the untracked or modified content in submodules)
  #
  #       modified:   others (untracked content)
  #

  $ git diff --cached
  diff --git a/others b/others
  new file mode 160000
  index 0000000..90364e1
  --- /dev/null
  +++ b/others
  @@ -0,0 +1 @@
  +Subproject commit 90364e1331abc29cc63e994b4d2cfbf7c485e4ad

  $ git commit -m "add others as submodule."

可以看出 others 被当做子模组添加到 super 版本库中。之所以 `git status` 的显示中 others 出现两次，是因为 others 版本库本身“不干净”，存在尚未加入版本控制的文件。

执行 `git submoudle status` 命令，会报错。因为 others 作为子模组，没有在 .gitmodules 文件中注册。

::

  $ git submodule status
   126b18153583d9bee4562f9af6b9706d2e104016 lib/lib_a (remotes/origin/HEAD)
   3b52a710068edc070e3a386a6efcbdf28bf1bed5 lib/lib_b (heads/master)
  No submodule mapping found in .gitmodules for path 'others'

那么如何避免 others 以子模组型式添加入库，而要把 others 目录下的文件加入版本库呢？同时，又不能破坏 others 本身的版本库。

::

  $ git rm --cached others
  rm 'others'

  $ git status
  # On branch master
  # Changes to be committed:
  #   (use "git reset HEAD <file>..." to unstage)
  #
  #       deleted:    others
  #
  # Untracked files:
  #   (use "git add <file>..." to include in what will be committed)
  #
  #       others/

  $ git add others/

  $ git status
  # On branch master
  # Changes to be committed:
  #   (use "git reset HEAD <file>..." to unstage)
  #
  #       deleted:    others
  #       new file:   others/newfile
  #

  $ git commit -m "add contents in others/."
  [master 1e0c418] add contents in others/.
   2 files changed, 1 insertions(+), 1 deletions(-)
   delete mode 160000 others
   create mode 100644 others/newfile

上面的操作中，首先先删除了在库中的 others 子模组（使用 --cached 参数执行删除）；然后为了添加 others 目录下的文件，使用了 "others/" （注意 others 后面的路径分割符 '/'）。现在查看一下子模组的状态，会看到只有之前的两个子模组显示出来。

::

  $ git submodule status
   126b18153583d9bee4562f9af6b9706d2e104016 lib/lib_a (remotes/origin/HEAD)
   3b52a710068edc070e3a386a6efcbdf28bf1bed5 lib/lib_b (heads/master)

子模组的管理问题
=================

子模组最主要的一个问题是子模组并不能基于外部版本库的某一个分支进行创建，使得更新后，子模组处于非跟踪状态，不便于在子模组中进行对外部版本库进行改动。尤其对于授权或者其它原因将一个版本库拆分为子模组后，管理非常不方便。在后面介绍 Android repo 工作模式为多版本库的有效管理指出了另一可行方案。

如果在局域网内维护的版本库所引用的子模组版本库在另外的服务器，甚至在互联网上，克隆子版本库就要浪费很多时间。而且如果子模组指向的版本库不在我们的掌控之内，一旦需要对其进行定制会因为提交无法向远程服务器推送而无法实现。在下面一节的子树合并中，会给出针对这个问题的解决方案。
