Git 克隆
********

到现在为止，读者已经零略到Git的灵活以及健壮性。Git可以通过重置随意撤销提交，可以通过变基操作更改历史，可以随意重组提交，还可以通过reflog的记录纠正错误的操作。但是再健壮的版本库设计，也抵挡不了存储介质的崩溃。还有不要忘了Git版本库是躲在工作区根目录下的 `.git` 目录中，如果忘了这一点直接删除工作区，就会把版本库也同时删掉，悲剧就此发生。

不要把鸡蛋装在一个篮子里，是颠扑不破的安全法则。

在本章会学习到如何使用 git clone 命令建立版本库克隆，以及如何使用 git push 和 git pull 命令实现克隆之间的同步。

鸡蛋不装在一个篮子里
====================

Git的版本库目录和工作区在一起，因此存在一损俱损的问题，即如果删除一个项目的工作区，同时也会把这个项目的版本库删除掉。一个项目仅在一个工作区中维护太危险了，如果有两个工作区就会好很多。

.. figure:: images/gitbook/git-clone-pull-push.png
   :scale: 80

上图中一个项目使用了两个版本库进行维护，两个版本库之间通过 PULL 和/或 PUSH 操作实现同步。

* 版本库A通过克隆操作创建克隆版本库B。
* 版本库A可以通过PUSH（推送）操作，将新提交传递给版本库B；
* 版本库A可以通过PULL（拉回）操作，将版本库B中的新提交拉回到自身（A）。
* 版本库B可以通过PULL（拉回）操作，将版本库A中的新提交拉回到自身（B）。
* 版本库B可以通过PUSH（推送）操作，将新提交传递给版本库A；

Git使用 git clone 命令实现版本库克隆，主要有如下三种用法：

::

  用法1: git clone <repository> <directory>
  用法2: git clone --bare   <repository> <directory.git>
  用法3: git clone --mirror <repository> <directory.git>

这三种用法的区别如下：

* 用法1将 <repository> 指向的版本库创建一个克隆到 <directory> 目录。目录 <directory> 相当于克隆版本库的工作区，文件都会检出，版本库位于工作区下的 `.git` 目录中。
* 用法2和用法3创建的克隆版本库都不含工作区，直接就是版本库的内容，这样的版本库称为裸版本库。一般约定俗成版本库的目录名以 ".git" 为后缀，所以上面示例中将克隆出来的裸版本库目录名协作 <directory.git>。
* 用法3区别于用法2之处在于用法3克隆出来的裸版本对上游版本库进行了注册，这样可以在裸版本库中使用 `git fetch` 命令和上游版本库进行持续同步。

下面就通过不同的Git命令组合，掌握版本库克隆和镜像的技巧。

对等工作区
==========

不使用 `--bare` 或者 `--mirror` 创建出来的克隆包含工作区，这样就会产生两个包含工作区的版本库。这两个版本库是对等的，如下图。

.. figure:: images/gitbook/git-clone-1.png
   :scale: 80

这两个工作区本质上没有区别，但是往往提交是在一个版本（A）中进行的，另外一个（B）作为备份。对于这种对等工作区模式，版本库的同步只有一种可行的操作模式，就是在备份库（B）执行 git pull 命令从源版本库（A）拉回新的提交实现版本库同步。为什么不能从版本库A向版本库B执行 git push 的推送操作呢？看看下面的操作。

执行克隆命令，将版本库 /my/workspace/demo 克隆到 /my/workspace/demo-backup 。

::

  $ git clone /my/workspace/demo /my/workspace/demo-backup
  Cloning into /my/workspace/demo-backup...
  done.

进入 demo 版本库，生成一些测试提交（使用 --allow-empty 参数可以生成空提交）。

::

  $ cd /my/workspace/demo/
  $ git commit --allow-empty -m "sync test 1"
  [master 790e72a] sync test 1
  $ git commit --allow-empty -m "sync test 2"
  [master f86b7bf] sync test 2

能够在 demo 版本库向 demo-backup 版本库执行 PUSH 操作么？执行一下 git push 看一看。

::

  $ git push /my/workspace/demo-backup
  Counting objects: 2, done.
  Delta compression using up to 2 threads.
  Compressing objects: 100% (2/2), done.
  Writing objects: 100% (2/2), 274 bytes, done.
  Total 2 (delta 1), reused 0 (delta 0)
  Unpacking objects: 100% (2/2), done.
  remote: error: refusing to update checked out branch: refs/heads/master
  remote: error: By default, updating the current branch in a non-bare repository
  remote: error: is denied, because it will make the index and work tree inconsistent
  remote: error: with what you pushed, and will require 'git reset --hard' to match
  remote: error: the work tree to HEAD.
  remote: error: 
  remote: error: You can set 'receive.denyCurrentBranch' configuration variable to
  remote: error: 'ignore' or 'warn' in the remote repository to allow pushing into
  remote: error: its current branch; however, this is not recommended unless you
  remote: error: arranged to update its work tree to match what you pushed in some
  remote: error: other way.
  remote: error: 
  remote: error: To squelch this message and still keep the default behaviour, set
  remote: error: 'receive.denyCurrentBranch' configuration variable to 'refuse'.
  To /my/workspace/demo-backup
   ! [remote rejected] master -> master (branch is currently checked out)
  error: failed to push some refs to '/my/workspace/demo-backup'

翻译成中文：

::

  $ git push /my/workspace/demo-backup
  ...
  对方说: 错了: 
                拒绝更新已检出分支 refs/heads/master 。
                缺省更新非裸版本库当前分支是不被允许的，因为这将会导致暂存区和工作区
                与您推送至版本库的新提交不一致。这太古怪了。

                如果您一意孤行，也不是不允许，但是您需要为我设置如下参数

                    receive.denyCurrentBranch = ignore|warn

  到 /my/workspace/demo-backup
   ! [对方拒绝] master -> master (分支当前已检出)
  错误: 部分引用的推送失败了, 至 '/my/workspace/demo-backup'

从错误输出可以看出，虽然可以改变Git的缺省行为，允许向工作区推送已经检出的分支，但是这么做实在不高明。

为了实现同步，需要进入到备份版本库中，执行 git pull 命令。

::

  $ git pull
  From /my/workspace/demo
     6e6753a..f86b7bf  master     -> origin/master
  Updating 6e6753a..f86b7bf
  Fast-forward

在 demo-backup 版本库中查看提交日志，可以看到在 demo 版本库中的新提交已经被拉回到 demo-backup 版本库中。

::

  $ git log --oneline -2
  f86b7bf sync test 2
  790e72a sync test 1

**为什么执行 git pull 拉回命令比前面的 git push 推送命令简洁呢？**

这是因为在执行 git clone 操作后，克隆出来的 demo-backup 版本库中对源版本库（上游版本库）进行了注册，所以当在 demo-backup 版本库执行拉回操作，无须设置上游版本库的地址。

在 demo-backup 版本库中可以使用下面的命令查看对上游版本库的注册信息：

::

  $ cd /my/workspace/demo-backup
  $ git remote -v
  origin  /my/workspace/demo (fetch)
  origin  /my/workspace/demo (push)

实际注册上游远程版本库的奥秘都在 Git 的配置文件中（略去无关的行）：

::

  $ cat /my/workspace/demo-backup/.git/config 
  ...
  [remote "origin"]
          fetch = +refs/heads/*:refs/remotes/origin/*
          url = /my/workspace/demo
  [branch "master"]
          remote = origin
          merge = refs/heads/master

关于配置文件 remote 小节和 branch 小节的奥秘在后面的章节予以介绍。

克隆生成裸版本库
================


.. figure:: images/gitbook/git-clone-2.png
   :scale: 80

创建生成裸版本库
================

.. figure:: images/gitbook/git-clone-3.png
   :scale: 80



