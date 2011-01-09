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

注册远程版本库
==============

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


