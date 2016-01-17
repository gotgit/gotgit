Git克隆
********

到现在为止，读者已经零略到Git的灵活性以及健壮性。Git可以通过重置随意撤销\
提交，可以通过变基操作更改历史，可以随意重组提交，还可以通过reflog的记录\
纠正错误的操作。但是再健壮的版本库设计，也抵挡不了存储介质的崩溃。还有一\
点就是不要忘了Git版本库是躲在工作区根目录下的\ :file:`.git`\ 目录中，如\
果忘了这一点直接删除工作区，就会把版本库也同时删掉，悲剧就此发生。

“不要把鸡蛋装在一个篮子里”，是颠扑不破的安全法则。

在本章会学习到如何使用\ :command:`git clone`\ 命令建立版本库克隆，以及如\
何使用\ :command:`git push`\ 和\ :command:`git pull`\ 命令实现克隆之间的\
同步。

鸡蛋不装在一个篮子里
====================

Git的版本库目录和工作区在一起，因此存在一损俱损的问题，即如果删除一个项\
目的工作区，同时也会把这个项目的版本库删除掉。一个项目仅在一个工作区中维\
护太危险了，如果有两个工作区就会好很多。

.. figure:: /images/git-solo/git-clone-pull-push.png
   :scale: 80

上图中一个项目使用了两个版本库进行维护，两个版本库之间通过拉回（PULL）\
和/或推送（PUSH）操作实现同步。

* 版本库A通过克隆操作创建克隆版本库B。
* 版本库A可以通过推送（PUSH）操作，将新提交传递给版本库B；
* 版本库A可以通过拉回（PULL）操作，将版本库B中的新提交拉回到自身（A）。
* 版本库B可以通过拉回（PULL）操作，将版本库A中的新提交拉回到自身（B）。
* 版本库B可以通过推送（PUSH）操作，将新提交传递给版本库A；

Git使用\ :command:`git clone`\ 命令实现版本库克隆，主要有如下三种用法：

::

  用法1: git clone <repository> <directory>
  用法2: git clone --bare   <repository> <directory.git>
  用法3: git clone --mirror <repository> <directory.git>

这三种用法的区别如下：

* 用法1将\ ``<repository>``\ 指向的版本库创建一个克隆到\
  :file:`<directory>`\ 目录。目录\ :file:`<directory>`\ 相当于克隆版本库\
  的工作区，文件都会检出，版本库位于工作区下的\ :file:`.git`\ 目录中。

* 用法2和用法3创建的克隆版本库都不含工作区，直接就是版本库的内容，这样的\
  版本库称为裸版本库。一般约定俗成裸版本库的目录名以\ :file:`.git`\ 为后缀，\
  所以上面示例中将克隆出来的裸版本库目录名写做\ :file:`<directory.git>`\ 。

* 用法3区别于用法2之处在于用法3克隆出来的裸版本对上游版本库进行了注册，\
  这样可以在裸版本库中使用\ :command:`git fetch`\ 命令和上游版本库进行\
  持续同步。

* 用法3只在 1.6.0 或更新版本的Git才提供。

Git的PUSH和PULL命令的用法相似，使用下面的语法：

::

  git push [<remote-repos> [<refspec>]]
  git pull [<remote-repos> [<refspec>]]

其中方括号的含义是参数可以省略，\ ``<remote-repos>``\ 是远程版本库的地址\
或名称，\ ``<refspec>``\ 是引用表达式，暂时理解为引用即可。在后面的章节\
再具体介绍PUSH和PULL命令的细节。

下面就通过不同的Git命令组合，掌握版本库克隆和镜像的技巧。

对等工作区
==========

不使用\ ``--bare``\ 或者\ ``--mirror``\ 创建出来的克隆包含工作区，这样就\
会产生两个包含工作区的版本库。这两个版本库是对等的，如下图。

.. figure:: /images/git-solo/git-clone-1.png
   :scale: 80

这两个工作区本质上没有区别，但是往往提交是在一个版本（A）中进行的，另外\
一个（B）作为备份。对于这种对等工作区模式，版本库的同步只有一种可行的操\
作模式，就是在备份库（B）执行 git pull 命令从源版本库（A）拉回新的提交实\
现版本库同步。为什么不能从版本库A向版本库B执行 git push 的推送操作呢？看\
看下面的操作。

执行克隆命令，将版本库\ :file:`/path/to/my/workspace/demo`\ 克隆到\
:file:`/path/to/my/workspace/demo-backup`\ 。

::

  $ git clone /path/to/my/workspace/demo /path/to/my/workspace/demo-backup
  Cloning into /path/to/my/workspace/demo-backup...
  done.

进入 demo 版本库，生成一些测试提交（使用\ ``--allow-empty``\ 参数可以\
生成空提交）。

::

  $ cd /path/to/my/workspace/demo/
  $ git commit --allow-empty -m "sync test 1"
  [master 790e72a] sync test 1
  $ git commit --allow-empty -m "sync test 2"
  [master f86b7bf] sync test 2

能够在 demo 版本库向 demo-backup 版本库执行PUSH操作么？执行一下\
:command:`git push`\ 看一看。

::

  $ git push /path/to/my/workspace/demo-backup
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
  To /path/to/my/workspace/demo-backup
   ! [remote rejected] master -> master (branch is currently checked out)
  error: failed to push some refs to '/path/to/my/workspace/demo-backup'

翻译成中文：

::

  $ git push /path/to/my/workspace/demo-backup
  ...
  对方说: 错了:
                拒绝更新已检出的分支 refs/heads/master 。
                缺省更新非裸版本库的当前分支是不被允许的，因为这将会导致
                暂存区和工作区与您推送至版本库的新提交不一致。这太古怪了。

                如果您一意孤行，也不是不允许，但是您需要为我设置如下参数：

                    receive.denyCurrentBranch = ignore|warn

                到 /path/to/my/workspace/demo-backup

   ! [对方拒绝] master -> master (分支当前已检出)
  错误: 部分引用的推送失败了, 至 '/path/to/my/workspace/demo-backup'

从错误输出可以看出，虽然可以改变Git的缺省行为，允许向工作区推送已经检\
出的分支，但是这么做实在不高明。

为了实现同步，需要进入到备份版本库中，执行\ :command:`git pull`\ 命令。

::

  $ git pull
  From /path/to/my/workspace/demo
     6e6753a..f86b7bf  master     -> origin/master
  Updating 6e6753a..f86b7bf
  Fast-forward

在 demo-backup 版本库中查看提交日志，可以看到在 demo 版本库中的新提交\
已经被拉回到 demo-backup 版本库中。

::

  $ git log --oneline -2
  f86b7bf sync test 2
  790e72a sync test 1

**为什么执行 git pull 拉回命令没有像执行 git push 命令那样提供那么多的参数呢？**

这是因为在执行\ :command:`git clone`\ 操作后，克隆出来的demo-backup版本库\
中对源版本库（上游版本库）进行了注册，所以当在 demo-backup 版本库执行\
拉回操作，无须设置上游版本库的地址。

在 demo-backup 版本库中可以使用下面的命令查看对上游版本库的注册信息：

::

  $ cd /path/to/my/workspace/demo-backup
  $ git remote -v
  origin  /path/to/my/workspace/demo (fetch)
  origin  /path/to/my/workspace/demo (push)

实际注册上游远程版本库的奥秘都在Git的配置文件中（略去无关的行）：

::

  $ cat /path/to/my/workspace/demo-backup/.git/config 
  ...
  [remote "origin"]
          fetch = +refs/heads/*:refs/remotes/origin/*
          url = /path/to/my/workspace/demo
  [branch "master"]
          remote = origin
          merge = refs/heads/master

关于配置文件\ ``[remote]``\ 小节和\ ``[branch]``\ 小节的奥秘在后面的章节\
予以介绍。

克隆生成裸版本库
================

上一节在对等工作区模式下，工作区之间执行推送，可能会引发大段的错误输出，\
如果采用裸版本库则没有相应的问题。这是因为裸版本库没有工作区。没有工作区\
还有一个好处就是空间占用会更小。

.. figure:: /images/git-solo/git-clone-2.png
   :scale: 80

使用\ ``--bare``\ 参数克隆demo版本库到\ :file:`/path/to/repos/demo.git`\ ，\
然后就可以从 demo 版本库向克隆的裸版本库执行推送操作了。（为了说明方便，\
使用了\ :file:`/path/to/repos/`\ 作为Git裸版本的根路径，在后面的章节\
中这个目录也作为Git服务器端版本库的根路径。可以在磁盘中以root账户创建\
该路径并设置正确的权限。）

::

  $ git clone --bare /path/to/my/workspace/demo /path/to/repos/demo.git
  Cloning into bare repository /path/to/repos/demo.git...
  done.

克隆出来的\ :file:`/path/to/repos/demo.git`\ 目录就是版本库目录，不含\
工作区。

* 看看\ :file:`/path/to/repos/demo.git`\ 目录的内容。

  ::

    $ ls -F /path/to/repos/demo.git
    branches/  config  description  HEAD  hooks/  info/  objects/  packed-refs  refs/

* 还可以看到\ ``demo.git``\ 版本库\ ``core.bare``\ 的配置为\ ``true``\ 。

  ::

    $ git --git-dir=/path/to/repos/demo.git config core.bare
    true

进入demo版本库，生成一些测试提交。

::

  $ cd /path/to/my/workspace/demo/
  $ git commit --allow-empty -m "sync test 3"
  [master d4b42b7] sync test 3
  $ git commit --allow-empty -m "sync test 4"
  [master 0285742] sync test 4

在demo版本库向demo-backup版本库执行PUSH操作，还会有错误么？

* 不带参数执行\ :command:`git push`\ ，因为未设定上游远程版本库，\
  因此会报错：

  ::

    $ git push
    fatal: No destination configured to push to.

* 在执行\ :command:`git push`\ 时使用\ :file:`/path/to/repos/demo.git`\
  作为参数。

  推送成功。

  ::

    $ git push /path/to/repos/demo.git
    Counting objects: 2, done.
    Delta compression using up to 2 threads.
    Compressing objects: 100% (2/2), done.
    Writing objects: 100% (2/2), 275 bytes, done.
    Total 2 (delta 1), reused 0 (delta 0)
    Unpacking objects: 100% (2/2), done.
    To /path/to/repos/demo.git
       f86b7bf..0285742  master -> master

看看\ :file:`demo.git`\ 版本库，是否已经完成了同步？

::

  $ git log --oneline -2
  0285742 sync test 4
  d4b42b7 sync test 3

这个方式实现版本库本地镜像显然是更好的方法，因为可以直接在工作区修改、\
提交，然后执行\ :command:`git push`\ 命令实现推送。稍有一点遗憾的是推送命\
令还需要加上裸版本库的路径。这个遗憾在后面介绍远程版本库的章节会给出解决\
方案。

创建生成裸版本库
================

裸版本库不但可以通过克隆的方式创建，还可以通过\ :command:`git init`\
命令以初始化的方式创建。之后的同步方式和上一节大同小异。

.. figure:: /images/git-solo/git-clone-3.png
   :scale: 80

命令\ :command:`git init`\ 在“Git初始化”一章就已经用到了，是用于初始化\
一个版本库的。之前执行\ :command:`git init`\ 命令初始化的版本库是带\
工作区的，如何以裸版本库的方式初始化一个版本库呢？奥秘就在于\
``--bare``\ 参数。

下面的命令会创建一个空的裸版本库于目录\ :file:`/path/to/repos/demo-init.git` 中。

::

  $ git init --bare /path/to/repos/demo-init.git
  Initialized empty Git repository in /path/to/repos/demo-init.git/

创建的果真是裸版本库么？

* 看看 :file:`/path/to/repos/demo-init.git` 下的内容：

  ::

    $ ls -F /path/to/repos/demo-init.git
    branches/  config  description  HEAD  hooks/  info/  objects/  refs/

* 看看这个版本库的配置\ ``core.bare``\ 的值：

  ::

    $ git --git-dir=/path/to/repos/demo-init.git config core.bare
    true

可是空版本库没有内容啊，那就执行PUSH操作为其创建内容呗。

::

  $ cd /path/to/my/workspace/demo
  $ git push /path/to/repos/demo-init.git
  No refs in common and none specified; doing nothing.
  Perhaps you should specify a branch such as 'master'.
  fatal: The remote end hung up unexpectedly
  error: failed to push some refs to '/path/to/repos/demo-init.git'

为什么出错了？翻译一下错误输出。

::

  $ cd /path/to/my/workspace/demo
  $ git push /path/to/repos/demo-init.git
  没有指定要推送的引用，而且两个版本库也没有共同的引用。
  所以什么也没有做。
  可能您需要提供要推送的分支名，如 'master'。
  严重错误：远程操作意外终止
  错误：部分引用推送失败，至 '/path/to/repos/demo-init.git'

关于这个问题详细说明要在后面的章节介绍，这里先说一个省略版：因为\
:file:`/path/to/repos/demo-init.git` 版本库刚刚初始化完成，还没有任何\
提交更不要说分支了。当执行\ :command:`git push`\ 命令时，如果没有设定\
推送的分支，而且当前分支也没有注册到远程某个分支，将检查远程分支是否有\
和本地相同的分支名（如master），如果有，则推送，否则报错。

所以需要把\ :command:`git push`\ 命令写的再完整一些。像下面这样操作，就\
可以完成向空的裸版本库的推送。

::

  $ git push /path/to/repos/demo-init.git master:master
  Counting objects: 26, done.
  Delta compression using up to 2 threads.
  Compressing objects: 100% (20/20), done.
  Writing objects: 100% (26/26), 2.49 KiB, done.
  Total 26 (delta 8), reused 0 (delta 0)
  Unpacking objects: 100% (26/26), done.
  To /path/to/repos/demo-init.git
   * [new branch]      master -> master

上面的\ :command:`git push`\ 命令也可以简写为：\ :command:`git push /pat
h/to/repos/demo-init.git master`\ 。

推送成功了么？看看\ :file:`demo-init.git`\ 版本库中的提交。

::

  $ git --git-dir=/path/to/repos/demo-init.git log --oneline -2
  0285742 sync test 4
  d4b42b7 sync test 3

好了继续在 demo 中执行几次提交。

::

  $ cd /path/to/my/workspace/demo/
  $ git commit --allow-empty -m "sync test 5"
  [master 424aa67] sync test 5
  $ git commit --allow-empty -m "sync test 6"
  [master 70a5aa7] sync test 6

然后再向\ :file:`demo-init.git`\ 推送。注意这次使用的命令。

::

  $ git push /path/to/repos/demo-init.git
  Counting objects: 2, done.
  Delta compression using up to 2 threads.
  Compressing objects: 100% (2/2), done.
  Writing objects: 100% (2/2), 273 bytes, done.
  Total 2 (delta 1), reused 0 (delta 0)
  Unpacking objects: 100% (2/2), done.
  To /path/to/repos/demo-init.git
     0285742..70a5aa7  master -> master

为什么这次使用\ :command:`git push`\ 命令后面没有跟上分支名呢？这是因为\
远程版本库（demo-init.git）中已经不再是空版本库了，而且有名为master的分支。

通过下面的命令可以查看远程版本库的分支。

::

  $ git ls-remote /path/to/repos/demo-init.git
  70a5aa7a7469076fd435a9e4f89c4657ba603ced        HEAD
  70a5aa7a7469076fd435a9e4f89c4657ba603ced        refs/heads/master

至此相信读者已经能够把鸡蛋放在不同的篮子中了，也对Git更加的喜爱了吧。
