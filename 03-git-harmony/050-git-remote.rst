远程版本库
***********

Git 作为分布式版本库控制系统，每个人都是本地版本库的主人，可以在本地的版本库中随心所欲的创建分支和里程碑。当需要多人协作，问题就出现了。

* 如何避免将所有用户的所有本地分支都推送到共享版本库，从而造成的混乱？
* 如何避免不同用户针对不同特性开发创建了同名分支而造成分支名称的冲突？
* 如何避免用户随意在共享版本库中创建里程碑而导致里程碑名称上的混乱和冲突？
* 当用户向共享版本库以及其他版本库推送时，每次都需要输入长长的版本库URL，太不方便了。
* 当用户需要经常从多个不同的他人版本库获取提交时，有没有办法不要总是输入长长的版本库URL？
* 如果不带任何其他参数执行 `git fetch`, `git pull` 和 `git push` 到底是和哪个远程版本库以及哪个分支进行交互？

本章介绍的 `git remote` 命令就是用于实现远程版本库的便捷访问，建立远程分支和本地分支的对应，使得 `git fetch`, `git pull` 和 `git push` 能够更为便捷的进行操作。

远程分支
==============

上一章介绍Git分支的时候，每一版本库最多只和一个上游版本库（远程共享版本库）进行交互，实际上 Git 允许一个版本库和任意多的版本库进行交互。有一个疑问，就是每一个 Git 版本库都有一个 master 分支，一个在和多个版本库交互时，其他版本库的 master 分支会不会互相干扰，冲突或者覆盖呢？

先来看看 `hello-world` 远程共享版本库中包含的分支有哪些：

::

  $ git ls-remote --heads file:///path/to/repos/hello-world.git
  8cffe5f135821e716117ee59bdd53139473bd1d8        refs/heads/hello-1.x
  bb4fef88fee435bfac04b8389cf193d9c04105a6        refs/heads/helper/master
  cf71ae3515e36a59c7f98b9db825fd0f2a318350        refs/heads/helper/v1.x
  c4acab26ff1c1125f5e585ffa8284d27f8ceea55        refs/heads/master

原来远程共享版本库中有四个分支，其中 `hello-1.x` 分支是开发者 user1 创建的。现在重新克隆该版本库，如下：

::

  $ cd /path/to/my/workspace/
  $ git clone file:///path/to/repos/hello-world.git
  ...


执行 `git branch` 命令检查分支，会吃惊的看到只有一个分支 `master` 。

::

  $ git branch
  * master

那么远程版本库中的其他分支哪里去了？为什么本地只有一个分支呢？执行 `git show-ref` 命令可以看到全部的本地引用。

::

  $ git show-ref 
  c4acab26ff1c1125f5e585ffa8284d27f8ceea55 refs/heads/master
  c4acab26ff1c1125f5e585ffa8284d27f8ceea55 refs/remotes/origin/HEAD
  8cffe5f135821e716117ee59bdd53139473bd1d8 refs/remotes/origin/hello-1.x
  bb4fef88fee435bfac04b8389cf193d9c04105a6 refs/remotes/origin/helper/master
  cf71ae3515e36a59c7f98b9db825fd0f2a318350 refs/remotes/origin/helper/v1.x
  c4acab26ff1c1125f5e585ffa8284d27f8ceea55 refs/remotes/origin/master
  3171561b2c9c57024f7d748a1a5cfd755a26054a refs/tags/jx/v1.0
  aaff5676a7c3ae7712af61dfb9ba05618c74bbab refs/tags/jx/v1.0-i18n
  e153f83ee75d25408f7e2fd8236ab18c0abf0ec4 refs/tags/jx/v1.1
  83f59c7a88c04ceb703e490a86dde9af41de8bcb refs/tags/jx/v1.2
  1581768ec71166d540e662d90290cb6f82a43bb0 refs/tags/jx/v1.3
  ccca267c98380ea7fffb241f103d1e6f34d8bc01 refs/tags/jx/v2.0
  8a5b9934aacdebb72341dcadbb2650cf626d83da refs/tags/jx/v2.1
  89b74222363e8cbdf91aab30d005e697196bd964 refs/tags/jx/v2.2
  0b4ec63aea44b96d498528dcf3e72e1255d79440 refs/tags/jx/v2.3
  60a2f4f31e5dddd777c6ad37388fe6e5520734cb refs/tags/mytag
  5dc2fc52f2dcb84987f511481cc6b71ec1b381f7 refs/tags/mytag3
  51713af444266d56821fe3302ab44352b8c3eb71 refs/tags/v1.0

在 `git show-ref` 的输出中，发现几个不寻常的引用，这些引用以 `refs/remotes/origin/` 为前缀，并且名称和远程版本库的分支名一一对应。这些引用实际上就是从远程版本库的分支拷贝过来，称为远程分支。

Git 的 `git branch` 命令也能够查看这些远程分支，不过要加上 "`-r`" 参数：

::

  $ git branch -r
    origin/HEAD -> origin/master
    origin/hello-1.x
    origin/helper/master
    origin/helper/v1.x
    origin/master

远程分支不是真正意义上的分支，是类似于里程碑一样的引用。如果针对远程分支执行检出命令，会看到大段的错误警告。

::

  $ git checkout origin/hello-1.x
  Note: checking out 'origin/hello-1.x'.

  You are in 'detached HEAD' state. You can look around, make experimental
  changes and commit them, and you can discard any commits you make in this
  state without impacting any branches by performing another checkout.

  If you want to create a new branch to retain commits you create, you may
  do so (now or later) by using -b with the checkout command again. Example:

    git checkout -b new_branch_name

  HEAD is now at 8cffe5f... Merge branch 'hello-1.x' of file:///path/to/repos/hello-world into hello-1.x

上面的大段的错误信息实际上告诉我们一件事，远程分支类似于里程碑如果检出就会使得头指针 `HEAD` 处于分离头指针状态。实际上除了以 `refs/heads` 为前缀的引用之外，任何其他引用如果检出都将使工作区处于分离头指针状态。

**远程分支的前缀**

为什么当前版本库中远程分支都包含前缀 `origin` 呢？这是因为在克隆远程版本库的时候，Git在配置文件中以 `origin` 为名称注册了远程版本库。执行下面的命令可以查看注册的远程版本库信息。

::

  $ git remote -v
  origin  file:///path/to/repos/hello-world.git (fetch)
  origin  file:///path/to/repos/hello-world.git (push)

如果查看 `.git/config` 文件会看到下面的配置。为了说明方便还为每一行添加了行号。

::

     ...
   6 [remote "origin"]
   7   fetch = +refs/heads/*:refs/remotes/origin/*
   8   url = file:///path/to/repos/hello-world.git
   9 [branch "master"]
  10   remote = origin
  11   merge = refs/heads/master

其中第6-8行定义了一个 `[remote]` 小节，该小节配置了远程版本库 `file:///path/to/repos/hello-world.git` 字符串 "origin" 和

$ git checkout helper/master
Branch helper/master set up to track remote branch helper/master from origin.
Switched to a new branch 'helper/master'



即头指针 `HEAD` 处于分离头指针状态。

如果检出远程分支，就合检出里程碑hhhhh

检查本地克隆下的文件 `.git/config` 。

::

  $ cd hello-world
  $ cat .git/config
  [remote "origin"]
    fetch = +refs/heads/*:refs/remotes/origin/*
    url = file:///path/to/repos/hello-world.git
  [branch "master"]
    remote = origin
    merge = refs/heads/master



，那么如果不同的版本库具有相同的分支（但实际功能不同）

注册远程版本库
==============

在前面的章节中，多次看到不带其他参数的执行 `git fetch`, `git pull` 和 `git push` 命令，那么这些命令操作的是哪个版本库以及哪个分支呢？

克隆操作自动注册
----------------





克隆远程版本库的操作

* 远程版本库是否有 HEAD，及影响？
* 本地 master 如何创建？
* fetch / pull 命令的区分
* push 命令？
* 克隆版本库后 config 文件中的内容？

使用 git remote 命令
--------------------

git remote

克隆即分支

* 一些 DCVS，如 Hg，压根就没有分支概念，有的只是不同的版本库克隆
* Git 有分支也有克隆，可以吧克隆看成是另外的分支，反之亦然
* 克隆的操作

remote 和克隆

* 问题： 如何将修改 push 到不同的服务器？
* 先来看看这个问题： git clone 和 git init 的配置文件的差别
* 什么是 remote？

  git remote -v

* 那么如何push 到不同服务器呢？

  git remote add ...

  git push ... master

* remote 的名字空间

  git remote add ： 跟踪其他源（除了缺省克隆时指定的源外）

  ::

    $ git remote add linux-nfs git://linux-nfs.org/pub/nfs-2.6.git

    $ git fetch linux-nfs
    refs/remotes/linux-nfs/master: storing branch 'master' ...
    commit: bf81b46

* 相当于对 .git/config 进行了修改

  ::

    $ git remote add name url 设定另外的同步源，用于 pull 和 fetch。相当于在 .git/config 文件尾部增加一个 remote 小节
    $ tail .git/config
    [remote "linux-nfs"]
            url = git://linux-nfs.org/pub/nfs-2.6.git
            fetch = +refs/heads/*:refs/remotes/linux-nfs/*

* remote update

  更改版本库注册
  git config 配置中的 .merge 和 .rebase
  See `branch.<name>.rebase` in linkgit:git-config[1] if you want to make `git pull` always use `{litdd}rebase` instead of merging. 

git fetch
============

直接使用地址

        如果不设置 remote，直接从 url fetch，如何？ FETCH_HEAD

使用注册版本库

        如果设置了remote，fetch，会创建远程分支。
        远程分支都到哪里去了？

            理解 Git 远程分支

                获取远程版本库的分支
                缺省同步/克隆一个版本库，是将 .git/refs/heads/ 下的本地分支克隆到新的版本库的 .git/refs/remote/ 下面
                如果要将一个源库的 remotes 分支也同步到镜像版本库，需要增加一个 fetch 设置。具体的应用范例，参见

::

        mkdir project
        cd project
        git init
        git remote add origin server:/pub/project
        git config --add remote.origin.fetch '+refs/remotes/*:refs/remotes/*'
        git fetch

        如何查看远程服务器的分支？
            显示和查看远程分支： git branch -r
                git 以 origin/master 名称在本地版本库保留了远程版本库的分支。
                未 packed 的库，在 .git/refs/remotes/origin 目录下的文件代表远程分支
                packed 之后的库，在 .git/packed-refs 文件： 

* 保存了 tags 和 commit id 对应关系。
* 还保存了 远程版本库分支名： refs/remotes/origin/*

  ::

        如何删除远程服务器的分支？
            删除远程分支:  git push origin :<remote-branch-name>
                相当于命令 git push [remotename] [localbranch]:[remotebranch]  的 [localbranch] 为空
                git push origin :branch_name
        如何在远程服务器上创建分支？
        如何使用远程分支
            远程分支不能直接 checkout！
                远程分支不能直接检出/查看，需要通过创建本地分支方式检出
                $ git checkout -b my-todo-copy origin/todo
                或者使用 --track 参数，直接创建同名的本地分支，以便更好的和该远程分支同步
                建立远程分支的本地分支： git checkout -b branchname origin/branchname
                建立远程分支的本地分支的另外一个等价方法：
        $ git checkout --track origin/branchname
        远程分支引发的冲突
            别人先我提交
            我收回先前提交
        里程碑的获取
        为什么不能把所有的 tag 复制下来？例如 master 分支重置之前的 tag

git push
=========

::

    直接使用地址
    使用注册版本库
    分支的推送
        本地分支和远程分支的关系
            本地分支用于临时性的提交和试验（experiment)，如果和上游某个分支同名，会有什么问题么？
            具体说1: 如果我执行了 git pull ，会把上游的同名分支拉过来么？这可能是我不需要的。
            具体说2：如果我不小心执行了 git push，会把我本地的测试提交推送上游么？
    里程碑的推送
    获取和推送使用不同的地址
        设置 remote.name.pushurl，推送到自己克隆的版本库

分支和里程碑的安全性
====================


分支间跟踪
==========

--track 。 缺省远程版本库克隆会建立跟踪。使用 --track 可以建立本地分支跟踪。


