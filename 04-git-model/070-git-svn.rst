Git 和 SVN 协同模型
===================

在Git 协同模型部分的最后，我们将会在另外的一个角度上看 Git 版本库的协同。不是用户之间在使用 Git 版本库时如何协同，也不是一个项目的多个 Git 版本库如何协同，而是 Git 版本库如何操作其它版本控制系统 —— Subversion。

Subversion 会一直在商业软件开发占据主导，只要商业软件公司封闭源代码的策略不改变。对于熟悉了 Git 的用户，一定会对 Subversion 的那种一旦脱离网络、脱离服务器便寸步难行的工作模式厌烦透顶。实际上对 Subversion 的集中式版本控制的不满和改进在 Git 诞生之前就发生了，这就是 SVK。

在 2003 年（Git 诞生的前两年），台湾的高嘉良就开发了 SVK，用分布式版本控制的方法操作 SVN。其设计思想非常朴素，既然 SVN 的用户可以看到有访问权限数据的全部历史，那么也应该能够依据历史重建一个本地的 SVN 版本库，这样很多 SVN 操作都可以通过本地的 SVN 进行从而脱离网络。当对本地版本库的修改感到满意后，通过本地SVN版本和服务器的SVN版本库的双向同步将改动归并到服务器上。这种工作方式真的非常酷。

我们不必为 SVK 的文档缺乏以及不再维护而感到惋惜，因为有更强的工具登场了，这就是 git-svn。Git-svn 是 Git 软件包的一部分，用 Perl 语言开发。它的工作原理是：

* 将 Subversion 版本库在本地转换为一个 Git 库。
* 转换可以基于 Subversion 的某个目录，或者基于某个分支，或者整个 Subversion 代码库的所有分支和里程碑。
* 远程的 Subversion 版本库可以和本地的 Git 双向同步。Git 本地库修改推送到远程 Subversion 版本库，反之亦然。

Git-svn 作为 Git 软件包的一部分，当 Git 从源码包进行安装时会默认安装，提供 `git svn` 命令。但一些 Linux 发行版 git-svn 作为一个独立的软件包，需要手动进行安装。例如 Debian 和 Ubuntu 运行下面命令安装 git-svn 。

::

  $ sudo aptitude install git-svn

将 git-svn 独立安装是因为 git-svn 软件包有着特殊的依赖，即依赖 Subversion 的 perl 语言绑定接口，Debian/Ubuntu 上由 libsvn-perl 软件包提供。

当 git-svn 正确安装后，就可以使用 `git svn` 命令了。但如果在执行 `git svn` 时遇到下面的错误，则说明 Subversion 的 perl 语言绑定没有正确安装。

::

  $ git svn clone file:///path/to/svn/repos
  Initialized empty Git repository in /data/tmp/git/aaa/repos/.git/
  Can't locate SVN/Core.pm in @INC (@INC contains: /usr/share/perl/5.10.1 /etc/perl /usr/local/lib/perl/5.10.1 /usr/local/share/perl/5.10.1 /usr/lib/perl5 /usr/share/perl5 /usr/lib/perl/5.10 /usr/share/perl/5.10 /usr/local/lib/site_perl /usr/local/lib/perl/5.10.0 /usr/local/share/perl/5.10.0 .) at /usr/lib/git-core/git-svn line 41.


在我们介绍 git-svn 之前，我们先创建一个 SVN 测试版本库。

::

  $ svnadmin create /path/to/svn/repos

  $ svn co file:///path/to/svn/repos svndemo
  取出版本 0
  
  $ cd svndemo
  
  $ mkdir trunk tags branches
  $ svn add *
  A         branches
  A         tags
  A         trunk

  $ svn ci -m "initialized."
  增加           branches
  增加           tags
  增加           trunk
  
  提交后的版本为 1。

我们再向 Subversion 开发主线 trunk 中添加些数据。

::

  $ echo hello > trunk/README
  $ svn add trunk/README
  A         trunk/README
  $ svn ci -m "hello"
  增加           trunk/README
  传输文件数据.
  提交后的版本为 2。

建立分支：

::

  $ svn up
  $ svn cp trunk branches/demo-1.0
  A         branches/demo-1.0
  $ svn ci -m "new branch: demo-1.0"
  增加           branches/demo-1.0

  提交后的版本为 3。

建立里程碑：

::

  $ svn cp -m "new tag: v1.0" trunk file:///path/to/svn/repos/tags/v1.0 

  提交后的版本为 4。


使用 git-svn 操作 SVN 版本库
-----------------------------

$ mkdir gitsvn
$ cd gitsvn
$ git svn clone file:///path/to/svn/repos/trunk
Initialized empty Git repository in /data/tmp/git/gitsvn/trunk/.git/
r1 = 2c73d657dfc3a1ceca9d465b0b98f9e123b92bb4 (refs/remotes/git-svn)
        A       README
r2 = 1863f91b45def159a3ed2c4c4c9428c25213f956 (refs/remotes/git-svn)
Checked out HEAD:
  file:///path/to/svn/repos/trunk r2





git-svn 用 Perl 语言开发

测试环境搭建
------------

