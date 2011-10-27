Topgit 协同模型
***************

如果没有 Topgit ，就不会有此书。因为发现了 Topgit，才让作者下定决心在公司大范围推广 Git；因为 Topgit，激发了作者对 Git 的好奇之心。


作者版本控制系统三个里程碑
===========================

从2005年开始作者专心于开源软件的研究、定制开发和整合，在这之后的几年，一直使用 Subversion 做版本控制。对于定制开发工作，Subversion 有一种称为卖主分支（Vendor Branch）的模式。

.. figure:: /images/git-model/topgit-branch-vendor-branch.png
   :scale: 100

   图22-1：卖主分支工作模式图

卖主分支的工作模式如图22-1所示：

* 图22-1由左至右，提交随着时间而递增。
* 主线 trunk 用于对定制开发的过程进行跟踪。
* 主线的第一个提交 `v1.0` 是导入上游（该开源软件官方版本库）发布的版本。
* 之后在 `v1.0` 提交之处建立分支，是为卖主分支（vendor branch）
* 主线上依次进行了 c1, c2 两次提交，是基于 v1.0 进行的定制开发。
* 当上游有了新版本，提交到卖主分支上，即 `v2.0` 提交。和 `v1.0` 相比除了大量的文件更改外，还可能有文件增加和删除。
* 然后在主线上执行从卖主分支到主线的合并，即提交 `M1` 。因为此时主线上的改动相对少，合并 `v2.0` 并不太费事。
* 主线继续开发。可能同时有针对不同需求的定制开发，在主线上会有越来越多的提交，如上图从 c3 到 c99 近百次提交。
* 如果在卖主分支上导入上游的新版本 `v3.0` ，合并将会非常痛苦。因为主线上针对不同需求的定制开发已经混在在一起！

实践证明，Subversion 的卖主分支对于大规模的定制开发非常不适合。向上游新版本的迁移随着定制功能和提交的增多越来越困难。

在2008年，我们的版本库迁移到 Mercurial（水银，又称为 Hg），并工作在 "Hg + MQ" 模式下，我自以为找到了定制开发版本控制的终极解决方案，那时我们已被 Subversion 的卖主分支折磨的太久了。

Hg 和 Git 一样也是一种分布式版本控制系统，MQ 是 Hg 的一个扩展，可以实现提交和补丁两种模式之间的转换。Hg 版本库上的提交可以通过 `hg qimport` 命令转化为补丁列表，也可以通过 `hg qpush`, `hg qpop` 等命令在补丁列表上游移（出栈和入栈），入栈的补丁转化为 Hg 版本库的提交，补丁出栈会从 Hg 版本库移走最新的提交。

使用 "Hg + MQ" 相比 Subversion 的卖主分支的好处在于：

* 针对不同需求的定制开发，其提交被限定在各自独立的补丁文件之中。

  针对同一个需求的定制开发，无论多少次的更改都体现为补丁文件的变化，而补丁文件本身也是被版本控制的。

* 各个补丁之间是顺序依赖关系，形成一个 Quilt 格式的补丁列表。

* 迁移至上游新版本的过程是：先将所有补丁“出栈”，再将上游新版本提交到主线，然后依次将补丁“入栈”。

  因为上游新版本的代码上下文改变等原因，补丁入栈可能会遇到冲突，只要在解决冲突完毕后，执行 `hg qref` 即可。

* 向上游新版本迁移过程的工作量降低了，是因为提交都按照定制的需求分类了（不同的补丁），每个补丁都可以视为一个功能分支。

但是当需要在定制开发上进行多人协作的时候，“Hg + MQ” 弊病就显现了。因为“Hg + MQ”工作模式下，定制开发的成果是一个补丁库，在补丁库上进行协作难度非常大，当发生冲突的时候，补丁文件本身的冲突解决难度相当大。这就引发了我们第三次版本控制系统大迁移。

2009 年，目光锁定在 Topgit 上。TopGit 的项目名称是来自于 Topic Git 的简写，是基于 Git 用脚本语言开发的辅助工具，是用于管理多个 Git 的特性分支的工具。Topgit 可以非常简单的实现“变基”——迁移至上游新版本。

Topgit 的主要特点有：

* 上游代码库位于开发主线（master 分支），每一个定制开发都对应于一条 Git 分支（refs/heads/t/feature_name）。
* 特性分支之间的依赖关系不像 "Hg + MQ" 简单的逐一依赖模式，而是可以任意设定分支之间的依赖。
* 特性分支和其依赖的分支可以转出为 Quilt 格式的补丁列表。
* 因为针对某一需求的定制开发在特定的分支中，可以多人协同参与，和正常的 Git 开发别无二致。

Topgit 原理
============

图22-2是一个近似的 Topgit 实现图（略去了重要的 top-bases 分支）。

.. figure:: /images/git-model/topgit-topic-branch.png
   :scale: 100

   图22-2：Topgit特性分支关系图

在图22-2中，主线上的 `v1.0` 是上游的版本的一次提交。特性分支 A 和 C 都直接依赖主线 master，而特性分支 B 则依赖特性分支 A。提交 M1 是特定分支 B 因为特性分支 A 更新而做的一次迁移。提交 M2 和 M4，则分别是特性分支 A 和 C 因为上游出现了新版本 `v2.0` 而做的迁移。当然特性分支 B 也要做相应的迁移，是为 M3。

上述的描述非常粗糙，因为这样的设计很难实现特性分支导出为补丁文件。例如特性分支B的补丁，实际上应该是 M3 和 M2 之间的差异，而绝不是 M3 到 a2 之间的差异。Topgit 为了能够实现分支导出为补丁，又为每个特性的开发引入了一个特殊的引用 (`refs/top-bases/*`) ，用于追踪分支依赖的“变基”。这些特性分支的基准分支也形成了复杂的分支关系图，如图22-3所示。


.. figure:: /images/git-model/topgit-topic-base-branch.png
   :scale: 100

   图22-3：Topgit特性分支的基准分支关系图

把图22-2和图22-3两张分支图重合，就可以获得各个特性分支在任一点的特性补丁文件。

上面的特性分支 B 还只是依赖一个分支，如果出现一个分支依赖多个特性分支的话，情况就会更加的复杂，更会体现出这种设计方案的精妙。

Topgit 还在每个特性分支工作区的根目录引入两个文件，用以记录分支的依赖以及关于此分支的说明。

* 文件 `.topdeps` 记录该分支所依赖的分支列表。

  该文件通过 `tg create` 命令在创建特性分支时自动创建，或者通过 `tg depend add` 命令来添加新依赖。

* 文件 `.topmsg`  记录该分支的描述信息。

  该文件通过 `tg create` 命令在创建特性分支时创建，也可以手动编辑。
  
Topgit 的安装
===================

Topgit 的可执行命令只有一个 `tg` 。其官方参考手册见: http://repo.or.cz/w/topgit.git?a=blob;f=README 。

安装官方的 Topgit 版本，直接克隆官方的版本库，执行 make 即可。


::

  $ git clone git://repo.or.cz/topgit.git
  $ cd topgit
  $ make
  $ make install

缺省会把可执行文件 `tg` 安装在 $HOME/bin （用户主目录下的 bin 目录）下，如果没有将 ~/bin 加入环境变量 $PATH 中，可能无法执行 tg。如果具有 root 权限，也可以将 tg 安装在系统目录中。

::

  $ prefix=/usr make
  $ sudo prefix=/usr make install

作者对 Topgit 做了一些增强和改进，在后面的章节予以介绍。如果想安装改进的版本，需要预先安装 quilt 补丁管理工具。然后进行如下操作。

::

  $ git clone git://github.com/ossxp-com/topgit.git
  $ cd topgit
  $ QUILT_PATCHES=debian/patches quilt push -a
  $ prefix=/usr make
  $ sudo prefix=/usr make install

如果用的是 Ubuntu 或者 Debian Linux 操作系统，还可以这么安装。

* 先安装 Debian/Ubuntu 打包依赖的相关工具软件。

  ::

    $ sudo aptitude install quilt debhelper build-essential fakeroot dpkg-dev

* 再调用 dpkg-buildpackage 命令，编译出 DEB 包，再安装。

  ::

    $ git clone git://github.com/ossxp-com/topgit.git
    $ cd topgit
    $ dpkg-buildpackage -b -rfakeroot
    $ sudo dpkg -i ../topgit_*.deb

* 安装完毕后，重新加载命令行补齐，可以更方便的使用 tg 命令。

  ::

    $ . /etc/bash_completion


Topgit 的使用
==============

通过前面的原理部分，可以发现 Topgit 为管理特性分支，所引入的配置文件和基准分支都是和 Git 兼容的。

* 在 refs/top-bases/ 命名空间下的引用，用于记录分支的变基历史。
* 在特性分支的工作区根目录引入两个文件 .topdeps 和 .topmsg ，用于记录分支依赖和说明。
* 引入新的钩子脚本 hooks/pre-commit ，用于在提交时检查分支依赖有没有发生循环等。

Topgit 的命令行的一般格式为：

::

  tg [global_option] <subcmd> [command_options...] [arguments...]

* 在子命令前为全局选项，目前可用全局选项只有 `-r <remote>` 。

  `-r <remote>` 可选项，用于设定分支跟踪的远程服务器。默认为 `origin` 。

* 子命令后可以跟命令相关的可选选项，和参数。

tg help 命令
--------------

tg help 命令显示帮助信息。当在 tg help 后面提供子命令名称，可以获得该子命令详细的帮助信息。

tg create 命令
--------------

tg create 命令用于创建新的特性分支。用法：

::

  tg [...] create NAME [DEPS...|-r RNAME]

其中：

* NAME 是新的特性分支的分支名，必须提供。一般约定俗成，NAME 以 `t/` 前缀开头，以标明此分支是一个 Topgit 特性分支。
* DEPS... 是可选的一个或多个依赖分支名。如果不提供依赖分支名，则使用当前分支作为新的特性分支的依赖分支。
* -r RNAME 选项，将远程分支作为依赖分支。不常用。

tg create 命令会创建新的特性分支 refs/heads/NAME，跟踪变基分支 refs/top-bases/NAME，并且在项目根目录下创建文件 .topdeps 和 .topmsg 。会提示用户编辑 .topmsg 文件，输入详细的特性分支描述信息。

例如在一个示例版本库，分支 master 下输入命令：

::

  $ tg create t/feature1
  tg: Automatically marking dependency on master
  tg: Creating t/feature1 base from master...
  Switched to a new branch 't/feature1'
  tg: Topic branch t/feature1 set up. Please fill .topmsg now and make initial commit.
  tg: To abort: git rm -f .top* && git checkout master && tg delete t/feature1

提示信息中以 "tg:" 开头的是 Topgit 产生色说明。其中提示用户编辑 .topmsg 文件，然后执行一次 commit 完成 Topgit 特性分支的创建。

如果想撤销此次操作，删除项目根目录下的 .top* 文件，切换到 master 分支，然后执行 tg delete t/feature1 命令删除 t/feature1 分支以及变基跟踪分支 refs/top-bases/t/feature1 。

输入 git status 可以看到当前已经切换到 t/feature1 分支，并且 topgit 已经创建了 .topdeps 和 .topmsg 文件，并已将这两个文件加入到暂存区。

::

  $ git status
  # On branch t/feature1
  # Changes to be committed:
  #   (use "git reset HEAD <file>..." to unstage)
  #
  #       new file:   .topdeps
  #       new file:   .topmsg
  #
  $ cat .topdeps 
  master

打开 .topmsg 文件，会看到下面内容（前面增加了行号）：

::

  1   From: Jiang Xin <jiangxin@ossxp.com>
  2   Subject: [PATCH] t/feature1
  3   
  4   <patch description>
  5   
  6   Signed-off-by: Jiang Xin <jiangxin@ossxp.com>

其中第2行是关于该特性分支的简短描述，第4行是详细描述，可以写多行。

编辑完成，别忘了提交，提交之后才完成 Topgit 分支的创建。

::

  $ git add -u
  $ git commit -m "create tg branch t/feature1"

**创建时指定依赖分支**

如果这时想创建一个新的特性分支 t/feature2 ，并且也是要依赖 master，注意需要在命令行中提供 master 作为第二个参数，以设定依赖分支。因为当前所处的分支为 `t/feature1` ，如果不提供指定的依赖分支会自动依赖当前分子。

::

  $ tg create t/feature2 master
  $ git commit -m "create tg branch t/feature2"

下面的命令将创建 `t/feature3` 分支，该分支依赖 `t/feature1` 和 `t/feature2` 。

::

  $ tg create t/feature3 t/feature1 t/feature2
  $ git commit -m "create tg branch t/feature3"

tg info 命令
--------------

tg info 命令用于显示当前分支或指定的 Topgit 分支的信息。用法：

::

  tg [...] info [NAME]


其中 NAME 是可选的 Topgit 分支名。例如执行下面的命令会显示分支 t/feature3 的信息：

::

  $ tg info 
  Topic Branch: t/feature3 (1/1 commit)
  Subject: [PATCH] t/feature3
  Base: 0fa79a5
  Depends: t/feature1
           t/feature2
  Up-to-date.

切换到 t/feature1 分支，做一些修改，并提交。

::

  $ git checkout t/feature1
  hack...
  $ git commit -m "hacks in t/feature1."

然后再来看 t/feature3 的状态：

::

  $ tg info t/feature3
  Topic Branch: t/feature3 (1/1 commit)
  Subject: [PATCH] t/feature3
  Base: 0fa79a5
  Depends: t/feature1
           t/feature2
  Needs update from:
          t/feature1 (1/1 commit)

状态信息显示 t/feature3 不再是最新的状态（Up-to-date），因为依赖的分支包含新的提交，而需要从 t/feature1 获取更新。

tg update 命令
--------------

tg update 命令用于更新分支，即从依赖的分支或上游跟踪的分支获取最新的提交合并到当前分支。同时也更新在 refs/top-bases/ 命名空间下的跟踪变基分支。

::

  tg [...] update [NAME]

其中 NAME 是可选的 Topgit 分支名。下面就对需要更新的 `t/feature3` 分支执行 "tg update" 命令。

::

  $ git checkout t/feature3
  $ tg update
  tg: Updating base with t/feature1 changes...
  Merge made by recursive.
   feature1 |    1 +
   1 files changed, 1 insertions(+), 0 deletions(-)
   create mode 100644 feature1
  tg: Updating t/feature3 against new base...
  Merge made by recursive.
   feature1 |    1 +
   1 files changed, 1 insertions(+), 0 deletions(-)
   create mode 100644 feature1

从上面的输出信息可以看出执行了两次分支合并操作，一次是针对 `refs/top-bases/t/feature3` 引用指向的跟踪变基分支，另外一次针对的是 `refs/heads/t/feature3` 特性分支。

执行 "tg update" 命令因为要涉及到分支的合并，因此并非每次都会成功。例如在 t/feature3 和 t/feature1 同时对同一个文件（如 feature1）进行修改。然后在 t/feature3 中再执行 tg update 可能就会报错，进入冲突解决状态。

::

  $ tg update t/feature3
  tg: Updating base with t/feature1 changes...
  Merge made by recursive.
   feature1 |    1 +
   1 files changed, 1 insertions(+), 0 deletions(-)
  tg: Updating t/feature3 against new base...
  Auto-merging feature1
  CONFLICT (content): Merge conflict in feature1
  Automatic merge failed; fix conflicts and then commit the result.
  tg: Please commit merge resolution. No need to do anything else
  tg: You can abort this operation using `git reset --hard` now
  tg: and retry this merge later using `tg update`.

可以看出第一次对 refs/top-bases/t/feature3 引用指向的跟踪变基分支成功合并，但在对 t/feature3 特性分支进行合并是出错。

::

  $ tg info
  Topic Branch: t/feature3 (3/2 commits)
  Subject: [PATCH] t/feature3
  Base: 37dcb62
  * Base is newer than head! Please run `tg update`.
  Depends: t/feature1
           t/feature2
  Up-to-date.

  $ tg summary 
          t/feature1                      [PATCH] t/feature1
   0      t/feature2                      [PATCH] t/feature2
  >     B t/feature3                      [PATCH] t/feature3

  $ git status
  # On branch t/feature3
  # Unmerged paths:
  #   (use "git add/rm <file>..." as appropriate to mark resolution)
  #
  #       both modified:      feature1
  #
  no changes added to commit (use "git add" and/or "git commit -a")


通过 "tg info" 命令可以看出当前分支状态是 Up-to-date，但是之前有提示：分支的基（Base）要比头（Head）新，请执行 tg update 命令。这时如果执行 "tg summary" 命令的话，可以看到 t/feature3 处于 B (Break) 状态。用 git status 命令，可以看出因为两个分支同时修改了文件 `feature1`  导致冲突。

可以编辑 feature1 文件，或者调用冲突解决工具解决冲突，之后再提交，才真正完成此次 `tg update` 。

::

  $ git mergetool 
  $ git commit -m "resolved conflict with t/feature1."

  $ tg info
  Topic Branch: t/feature3 (4/2 commits)
  Subject: [PATCH] t/feature3
  Base: 37dcb62
  Depends: t/feature1
           t/feature2
  Up-to-date.

tg summary 命令
---------------

tg summary 命令用于显示 Topgit 管理的特性分支的列表及各个分支的状态。用法：

::

  tg [...] summary [-t | --sort | --deps | --graphviz]

不带任何参数执行 tg summary 是最常用的 topgit 命令。在介绍无参数的 tg summary 命令之前，先看看其他简单的用法。

使用 -t 参数只显示特性分支列表。

::

  $ tg summary -t
  t/feature1
  t/feature2
  t/feature3

使用 --deps 参数会显示 Topgit 特性分支，及其依赖的分支。
::

  $ tg summary  --deps
  t/feature1 master
  t/feature2 master
  t/feature3 t/feature1
  t/feature3 t/feature2

使用 --sort 参数按照分支依赖的顺序显示分支列表，除了 Topgit 分支外，依赖的非 Topgit 分支也会显示：

::

  $ tg summary  --sort
  t/feature3
  t/feature2
  t/feature1
  master

使用 --graphviz 会输出 GraphViz 格式文件，可以用于显示特性分支之间的关系。

::

  $ tg summary --graphviz | dot -T png -o topgit.png

生成的特性分支关系图如图22-4所示。

.. figure:: /images/git-model/topgit-graphviz.png
   :scale: 100

   图22-4：Topgit 特性分支依赖关系图

不带任何参数执行 tg summary 会显示分支列表及状态。这是最常用的 topgit 命令之一。

::


  $ tg summary
          t/feature1                      [PATCH] t/feature1
   0      t/feature2                      [PATCH] t/feature2
  >       t/feature3                      [PATCH] t/feature3

其中:

* 标识 '>' ：（t/feature3 分支之前的大于号) 用于标记当前所处的特性分支。
* 标记 '0' ：（t/feature2 分支前的数字 0） 含义是该分支中没有提交，这一个建立后尚未使用或废弃的分支。
* 标记 'D' ： 表明该分支处于过时（out-of-date）状态。可能是一个或多个依赖的分支包含了新的提交，尚未合并到此特性分支。可以用 `tg info` 命令看出到底是由于哪个依赖分支的改动导致该特性分支处于过时状态。
* 标记 'B' ： 之前演示中出现过，表明该分支处于 Break 状态，即可能由于冲突未解决或者其他原因导致该特性分支的基（base）相对该分支的头（head）不匹配。refs/top-bases 下的跟踪变基分支迁移了，但是特性分支未完成迁移。
* 标记 '!' ： 表明该特性分支所依赖的分支不存在。
* 标记 'l' ： 表明该特性分支只存在于本地，不存在于远程跟踪服务器。
* 标记 'r' ： 表明该特性分支既存在于本地，又存在于远程跟踪服务器，并且两者匹配。
* 标记 'L' ： 表明该特性分支，本地的要被远程跟踪服务器要新。
* 标记 'R' ： 表明该特性分支，远程跟踪服务器的要被本地的新。
* 如果没有出现 'l/r/L/R' ： 表明该版本库尚未设置远程跟踪版本库（没有remote）。
* 一般带有标记 'r' 的是最常见的，也是最正常的。

下面通过 tg remote 为测试版本库建立一个对应的远程跟踪版本库，然后就能在 tg summary 的输出中看到标识符 'l/r' 等。

tg remote 命令
--------------

tg remote 命令用于为远程跟踪版本库设置 Topgit 的特性分支的关联，在和该远程版本库进行 fetch, pull 等操作时能够同步 Topgit 相关分支。

::

  tg [...] remote [--populate] [REMOTE]

其中 REMOTE 为远程跟踪版本库的名称，如“origin”，会自动在该远程源的配置中增加 refs/top-bases 下引用的同步。下面的示例中前面用加号标记的行就是当执行 `tg remote origin` 后增加的设置。

::

   [remote "origin"]
          url = /path/to/repos/tgtest.git
          fetch = +refs/heads/*:refs/remotes/origin/*
  +       fetch = +refs/top-bases/*:refs/remotes/origin/top-bases/*

如果使用 --populate 参数，除了会向上面那样设置缺省的 Topgit 远程版本库外，会自动执行 `git fetch` 命令，然后还会为新的 Topgit 特性分支在本地创建新的分支，以及其对应的跟踪分支。

当执行 tg 命令时，如果不用 '-r remote' 全局参数，默认使用缺省的 Topgit 远程版本库。

下面为前面测试的版本库设置一个远程的跟踪版本库。

先创建一个裸版本库 tgtest.git 。

::

  $ git init --bare /path/to/repos/tgtest.git
  Initialized empty Git repository in /path/to/repos/tgtest.git/

然后在测试版本库中注册名为 origin 的远程版本库为刚刚创建的版本库。

::
 
  $ git remote add origin /path/to/repos/tgtest.git

执行 git push，将主线同步到远程的版本库。

::

  $ git push origin master
  Counting objects: 7, done.
  Delta compression using up to 2 threads.
  Compressing objects: 100% (3/3), done.
  Writing objects: 100% (7/7), 585 bytes, done.
  Total 7 (delta 0), reused 0 (delta 0)
  Unpacking objects: 100% (7/7), done.
  To /path/to/repos/tgtest.git
   * [new branch]      master -> master

之后通过 tg remote 命令告诉 Git 这个远程版本库需要跟踪 Topgit 分支。

::

  $ tg remote --populate origin

会在当前的版本库的 .git/config 文件中添加设置（以加号开头的行）：

::

   [remote "origin"]
          url = /path/to/repos/tgtest.git
          fetch = +refs/heads/*:refs/remotes/origin/*
  +       fetch = +refs/top-bases/*:refs/remotes/origin/top-bases/*
  +[topgit]
  +       remote = origin

这时再执行 tg summary 会看到分支前面都有标记 'l'，即本地提交比远程版本库要新。

::

  $ tg summary 
    l     t/feature1                      [PATCH] t/feature1
   0l     t/feature2                      [PATCH] t/feature2
  > l     t/feature3                      [PATCH] t/feature3

将 t/feature2 的特性分支推送到远程版本库。

::

  $ tg push t/feature2
  Counting objects: 5, done.
  Delta compression using up to 2 threads.
  Compressing objects: 100% (3/3), done.
  Writing objects: 100% (4/4), 457 bytes, done.
  Total 4 (delta 0), reused 0 (delta 0)
  Unpacking objects: 100% (4/4), done.
  To /path/to/repos/tgtest.git
   * [new branch]      t/feature2 -> t/feature2
   * [new branch]      refs/top-bases/t/feature2 -> refs/top-bases/t/feature2

再来看看 tg summary 的输出，会看到 t/feature2 的标识变为 'r'，即远程和本地相同步。

::

  $ tg summary 
    l     t/feature1                      [PATCH] t/feature1
   0r     t/feature2                      [PATCH] t/feature2
  > l     t/feature3                      [PATCH] t/feature3

使用 `tg push --all` (改进过的Topgit)，会将所有的 topgit 分支推送到远程版本库。之后再来看 tg summary 的输出。

::

  $ tg summary 
    r     t/feature1                      [PATCH] t/feature1
   0r     t/feature2                      [PATCH] t/feature2
  > r     t/feature3                      [PATCH] t/feature3

如果版本库设置了多个远程版本库，要针对每一个远程版本库执行 `tg remote <REMOTE>` ，但只能有一个远程的源用 `--populate` 参数调用 `tg remote` 将其设置为缺省的远程版本库。

tg push 命令
--------------

在前面 tg remote 的介绍中，已经看到了 tg push 命令。tg push 命令用于将 Topgit 特性分支及对应的变基跟踪分支推送到远程版本库。用法：

::

  tg [...] push [--dry-run] [--no-deps] [--tgish-only] [--all|branch*]

tg push 命令后面的参数指定要推送给远程服务器的分支列表，如果省略则推送当前分支。改进的 tg push 可以不提供任何分支，只提供 --all 参数就可以将所有 Topgit 特性分支推送到远程版本库。

参数 --dry-run 是测试执行效果，不真正执行。--no-deps 参数含义是不推送依赖的分支，缺省推送。--tgish-only 参数的含义是只推送 Topgit 特性分支，缺省指定的所有分支都进行推送。

tg depend 命令
--------------

tg depend 命令目前仅实现了为当前的 Topgit 特性分支增加新的依赖。用法：

::

  tg [...] depend add NAME 

会将 NAME 加入到文件 .topdeps 中，并将 NAME 分支向该特性分支以及变基跟踪分支进行合并操作。虽然 Topgit 可以检查到分支的循环依赖，但还是要注意合理的设置分支的依赖，合并重复的依赖。

tg base 命令
--------------

tg base 命令用于显示特性分支的基（base）当前的 commit-id。

tg delete 命令
--------------

tg delete 命令用于删除 Topgit 特性分支以及其对应的变基跟踪分支。用法：

::

  tg [...] delete [-f] NAME

缺省只删除没有改动的分支，即标记为 '0' 的分支，除非使用 '-f' 参数。

目前此命令尚不能自动清除其分支中对删除分支的依赖，还需要手工调整 `.topdeps` 文件，删除不存在分支的依赖。

tg patch 命令
--------------

tg patch 命令通过比较特性分支及其变基跟踪分支的差异，显示该特性分支的补丁。用法：

::

  tg [...] patch [-i | -w] [NAME]

其中 -i 参数显示暂存区和变基跟踪分支的差异。-w 参数显示工作区和变基跟踪分支的差异。

tg patch 命令存在的一个问题是只有在工作区的根执行才能够正确显示。这个缺陷已经在我改进的 Topgit 中被改正。

tg export 命令
--------------

tg export 命令用于导出特性分支及其依赖，便于向上游贡献。可以导出 Quilt 格式的补丁列表，或者顺序提交到另外的分支中。用法：

::

  tg [...] export ([--collapse] NEWBRANCH | [--all | -b BRANCH1,BRANCH2...] --quilt DIRECTORY | --linearize NEWBRANCH)

这个命令有三种导出方法。

* 将所有的 Topgit 特性分支压缩为一个提交到新的分支。

  ::

    tg [...] export --collapse NEWBRAQNCH

* 将所有的 Topgit 特性分支按照线性顺序提交到一个新的分支中。

  ::

    tg [...] export --linearize NEWBRANCH

* 将指定的 Topgit 分支（一个或多个）及其依赖分支转换为 Quilt 格式的补丁，保存到指定目录中。

  ::

    tg [...] export -b BRANCH1,BRANCH2... --quilt DIRECTORY

在导出为 Quilt 格式补丁的时候，如果想将所有的分支导出，必须用 -b 参数将分支全部罗列（或者分支的依赖关系将所有分支囊括），这对于需要导出所有分支非常不方便。我改进的 Topgit 通过 --all 参数，实现导出所有分支。

tg import 命令
--------------

tg import 命令将分支的提交转换为 Topgit 特性分支，每个分支称为一个特性分支，各个特性分支线性依赖。用法：

::

  tg [...] import [-d BASE_BRANCH] {[-p PREFIX] RANGE...|-s NAME COMMIT}


如果不使用 -d 参数，特性分支以当前分支为依赖。特性分支名称自动生成，使用约定俗成的 t/ 作为前缀，也可以通过 -p 参数指定其他前缀。可以通过 -s 参数设定特性分支的名称。

tg log 命令
--------------

tg log 命令显示特性分支的提交历史，并忽略合并引入的提交。

::

  tg [...] log [NAME] [-- GIT LOG OPTIONS...]

tg log 命令实际是对 git log 命令的封装。这个命令通过 --no-merges 和 --first-parent 参数调用 git log，虽然屏蔽了大量因和依赖分支合并而引入的依赖分支的提交日志，但是同时也屏蔽了合并到该特性分支的其他贡献者的提交。

tg mail 命令
--------------

tg mail 命令将当前分支或指定特性分支的补丁以邮件型式外发。用法：

::

  tg [...] mail [-s SEND_EMAIL_ARGS] [-r REFERENCE_MSGID] [NAME]

`tg mail` 调用 `git send-email` 发送邮件，-s 参数用于向该命令传递参数（需要用双引号括起来）。邮件中的目的地址从 patch 文件头h中的 To，Cc 和 Bcc 等字段获取。参数 -r 引用回复邮件的id以便正确生成 in-reply-to 邮件头。

注意：此命令可能会发送多封邮件，可以通过如下设置在调用 `git send-email` 命令发送邮件时进行确认。

::

  git config sendemail.confirm always

tg graph 命令
--------------

tg graph 命令并非官方提供的命令，而是源自一个补丁，实现文本方式的 Topgit 分支图。当然这个文本分支图没有 `tg summary --graphviz` 生成的那么漂亮。

Topgit hacks
==============

在 Topgit 的使用中陆续发现一些不合用的地方，于是便使用 Topgit 特性分支的方式来改进 Topgit 自身的代码。在群英汇博客上，介绍了这几个改进，参见： http://blog.ossxp.com/tag/topgit/ 。

下面就以此为例，介绍如何参与一个 Topgit 管理下的项目的开发。改进的 Topgit 版本库地址为:  git://github.com/ossxp-com/topgit.git 。

首先克隆该版本库。

::

  $ git clone git://github.com/ossxp-com/topgit.git
  $ cd topgit

查看远程分支。

::

  $ git branch -r
  origin/HEAD -> origin/master
  origin/master
  origin/t/debian_locations
  origin/t/export_quilt_all
  origin/t/fast_tg_summary
  origin/t/graphviz_layout
  origin/t/tg_completion_bugfix
  origin/t/tg_graph_ascii_output
  origin/t/tg_patch_cdup
  origin/t/tg_push_all
  origin/tgmaster

看到远程分支中出现了熟悉的以 t/ 为前缀的 Topgit 分支，说明这个版本库是一个 Topgit 管理的定制开发版本库。那么为了能够获取 Topgit 的变基跟踪分支，需要用 `tg remote` 命令对缺省的 origin 远程版本库注册一下。

::

  $ tg remote --populate origin
  tg: Remote origin can now follow TopGit topic branches.
  tg: Populating local topic branches from remote 'origin'...
  From git://github.com/ossxp-com/topgit
   * [new branch]      refs/top-bases/t/debian_locations -> origin/top-bases/t/debian_locations
   * [new branch]      refs/top-bases/t/export_quilt_all -> origin/top-bases/t/export_quilt_all
   * [new branch]      refs/top-bases/t/fast_tg_summary -> origin/top-bases/t/fast_tg_summary
   * [new branch]      refs/top-bases/t/graphviz_layout -> origin/top-bases/t/graphviz_layout
   * [new branch]      refs/top-bases/t/tg_completion_bugfix -> origin/top-bases/t/tg_completion_bugfix
   * [new branch]      refs/top-bases/t/tg_graph_ascii_output -> origin/top-bases/t/tg_graph_ascii_output
   * [new branch]      refs/top-bases/t/tg_patch_cdup -> origin/top-bases/t/tg_patch_cdup
   * [new branch]      refs/top-bases/t/tg_push_all -> origin/top-bases/t/tg_push_all
  tg: Adding branch t/debian_locations...
  tg: Adding branch t/export_quilt_all...
  tg: Adding branch t/fast_tg_summary...
  tg: Adding branch t/graphviz_layout...
  tg: Adding branch t/tg_completion_bugfix...
  tg: Adding branch t/tg_graph_ascii_output...
  tg: Adding branch t/tg_patch_cdup...
  tg: Adding branch t/tg_push_all...
  tg: The remote 'origin' is now the default source of topic branches.

执行 `tg summary` 看一下本地 Topgit 特性分支状态。

::

  $ tg summary 
    r  !  t/debian_locations              [PATCH] make file locations Debian-compatible
    r  !  t/export_quilt_all              [PATCH] t/export_quilt_all
    r  !  t/fast_tg_summary               [PATCH] t/fast_tg_summary
    r  !  t/graphviz_layout               [PATCH] t/graphviz_layout
    r  !  t/tg_completion_bugfix          [PATCH] t/tg_completion_bugfix
    r     t/tg_graph_ascii_output         [PATCH] t/tg_graph_ascii_output
    r  !  t/tg_patch_cdup                 [PATCH] t/tg_patch_cdup
    r  !  t/tg_push_all                   [PATCH] t/tg_push_all

怎么？出现了感叹号？记得前面在介绍 tg summary 命令的章节中提到过，感叹号的出现说明该特性分支依赖的分支丢失。用 `tg info` 查看一下某个特性分支。

::

  $ tg info t/export_quilt_all 
  Topic Branch: t/export_quilt_all (6/4 commits)
  Subject: [PATCH] t/export_quilt_all
  Base: 8b0f1f9
  Remote Mate: origin/t/export_quilt_all
  Depends: tgmaster
  MISSING: tgmaster
  Up-to-date.

原来该特性分支依赖 tgmaster 分支，而不是 master 分支。远程存在 tgmaster 分支而本地尚不存在。于是在本地建立 tgmaster 跟踪分支。

::

  $ git checkout tgmaster
  Branch tgmaster set up to track remote branch tgmaster from origin.
  Switched to a new branch 'tgmaster'

这回 `tg summary` 的输出正常了。

::

  $ tg summary 
    r     t/debian_locations              [PATCH] make file locations Debian-compatible
    r     t/export_quilt_all              [PATCH] t/export_quilt_all
    r     t/fast_tg_summary               [PATCH] t/fast_tg_summary
    r     t/graphviz_layout               [PATCH] t/graphviz_layout
    r     t/tg_completion_bugfix          [PATCH] t/tg_completion_bugfix
    r     t/tg_graph_ascii_output         [PATCH] t/tg_graph_ascii_output
    r     t/tg_patch_cdup                 [PATCH] t/tg_patch_cdup
    r     t/tg_push_all                   [PATCH] t/tg_push_all

通过下面命令创建图形化的分支图。

::

  $ tg summary --graphviz | dot -T png -o topgit.png

生成的特性分支关系图如图22-5所示。

.. figure:: /images/git-model/topgit-hacks.png
   :scale: 100

   图22-5：Topgit 改进项目的特性分支依赖关系图

其中：

* 特性分支 `t/export_quilt_all` ，为 `tg export --quilt` 命令增加 `--all` 选项，以便导出所有特性分支。
* 特性分支 `t/fast_tg_summary` ，主要是改进 tg 命令补齐时分支的显示速度，当特性分支接近上百个时差异非常明显。
* 特性分支 `t/graphviz_layout` ，改进了分支的图形输出格式。
* 特性分支 `t/tg_completion_bugfix` ，解决了命令补齐的一个 Bug。
* 特性分支 `t/tg_graph_ascii_output` ，源自 Bert Wesarg 的贡献，非常巧妙的实现了文本化的分支图显示，展示了 gvpr 命令的强大功能。
* 特性分支 `t/tg_patch_cdup` ，解决了在项目的子目录下无法执行 tg patch 的问题。
* 特性分支 `t/tg_push_all` ，通过为 `tg push` 增加 `--all` 选项，解决了当 tg 从 0.7 升级到 0.8 后，无法批量向上游推送特性分支的问题。

下面展示一下如何跟踪上游的最新改动，并迁移到新的上游版本。分支 tgmaster 用于跟踪上游的 Topgit 分支，以 t/ 开头的分支是对 Topgit 改进的特性分支，而 master 分支实际上是导出 Topgit 补丁文件并负责编译特定 Linux 平台发行包的分支。

把官方的 Topgit 分支以 upstream 的名称加入为新的远程版本库。

::

  $ git remote add upstream git://repo.or.cz/topgit.git

然后将 upstream 远程版本的 master 分支合并到本地的 tgmaster 分支。

::

  $ git pull upstream master:tgmaster
  From git://repo.or.cz/topgit
     29ab4cf..8b0f1f9  master     -> tgmaster

此时再执行 `tg summary` 会发现所有的 Topgit 分支都多了一个标记 `D` ，表明因为依赖分支的更新导致Topgit特性分支过时了。

::

  $ tg summary
    r D   t/debian_locations              [PATCH] make file locations Debian-compatible
    r D   t/export_quilt_all              [PATCH] t/export_quilt_all
    r D   t/fast_tg_summary               [PATCH] t/fast_tg_summary
    r D   t/graphviz_layout               [PATCH] t/graphviz_layout
    r D   t/tg_completion_bugfix          [PATCH] t/tg_completion_bugfix
    r D   t/tg_graph_ascii_output         [PATCH] t/tg_graph_ascii_output
    r D   t/tg_patch_cdup                 [PATCH] t/tg_patch_cdup
    r D   t/tg_push_all                   [PATCH] t/tg_push_all

依次对各个分支执行 `tg update` ，完成对更新的依赖分支的合并。

::

  $ tg update t/export_quilt_all
  ...

对各个分支完成更新后，会发现 tg summary 的输出中，标识过时的 `D` 标记变为 `L` ，即本地比远程服务器分支要新。

::

  $ tg summary 
    rL    t/debian_locations              [PATCH] make file locations Debian-compatible
    rL    t/export_quilt_all              [PATCH] t/export_quilt_all
    rL    t/fast_tg_summary               [PATCH] t/fast_tg_summary
    rL    t/graphviz_layout               [PATCH] t/graphviz_layout
    rL    t/tg_completion_bugfix          [PATCH] t/tg_completion_bugfix
    rL    t/tg_graph_ascii_output         [PATCH] t/tg_graph_ascii_output
    rL    t/tg_patch_cdup                 [PATCH] t/tg_patch_cdup
    rL    t/tg_push_all                   [PATCH] t/tg_push_all

执行 `tg push --all` 就可以实现将所有 Topgit 特性分支推送到远程服务器上。当然需要具有提交权限才可以。

Topgit 使用中的注意事项
========================

**经常运行 tg remote --populate 获取他人创建的特性分支**

运行命令 `git fetch origin` 和远程版本库（origin）同步，只能将他人创建的 Topgit 特性分支在本地以 `refs/remotes/origin/t/<branch-name>` 的名称保存，而不能自动在本地建立分支。

当版本库是使用 Topgit 维护的话，应该在和远程版本库同步的时候使用执行 `tg remote --populate origin` 。这条命令会做两件事情：

* 自动调用 `git fetch origin` 获取远程 origin 版本库的新的提交和引用。
* 检查 `refs/remotes/origin/top-bases/` 下的所有引用，如果是新的、在本地 (`refs/top-bases/`) 尚不存在，说明有其他人创建了新的特性分支。Topgit 会据此自动的在本地创建新的特性分支。

**适时的调整特性分支的依赖关系**

例如前面示例的 Topgit 库的依赖关系，各个分支可能的依赖文件内容如下。

* 分支 `t/feature1` 的 `.topdeps` 文件

  ::

    master

* 分支 `t/feature2` 的 `.topdeps` 文件

  ::

    master

* 分支 `t/feature3` 的 `.topdeps` 文件

  ::

    t/feature1
    t/feature2

如果分支 t/feature3 的 .topdeps 文件是这样的，可能就会存在问题。

  ::

    master
    t/feature1
    t/feature2

问题出在 `t/feature3` 依赖的其他分支已经依赖了 `master` 分支。虽然不会造成致命的影响，但是在特定情况下这种重复会造成不便。例如在 `master` 分支更新后，可能由于代码重构的比较厉害，在特性分支迁移时会造成冲突，如在 `t/feature1` 分支执行 `tg update` 会遇到冲突，当辛苦完成冲突解决并提交后，在 `t/feature3` 执行 `tg update` 时因为先依赖的是 `master` 分支，会先在 `master` 分支上对 `t/feature3` 分支进行变基，肯定会遇到和 `t/feature1` 相同的冲突，还要再重复的解决一次。

如果在 `.topdeps` 文件中将对 `master` 分支的重复的依赖删除，就不会出现上面的重复进行冲突解决的问题了。

同样的道理，如果 `t/feature3` 的 `.topdeps` 文件写成这样，效果也将不同：

  ::

    t/feature2
    t/feature1

依赖的顺序不同会造成变基的顺序也不同，同样也会产生重复的冲突解决。因此当发现重复的冲突时，可以取消变基操作，修改特性分支的 `.topdeps` 文件，调整文件内容（删除重复分支，调整分支顺序）并提交，然后在执行 `tg update` 继续变基操作。

**Topgit 特性分支的里程碑和分支管理**

Topgit 本身就是对特性分支进行管理的软件。Topgit 的某个时刻的开发状态是所有 Topgit 管理下的分支（包括跟踪分支）整体的状态。如果需要对 Topgit 所有相关的分支进行跟踪管理该如何实现呢？

例如 master 主线由于提交了上游的新版本而改动，在对各个 Topgit 特性分支执行 `tg update` 时，搞的一团糟，而又不小心执行了 `tg push --all` ，这下无论本地和远程都处于混乱的状态。

使用里程碑（tags）来管理是不可能的，因为 tag 只能针对一个分支做标记而不能标记所有的分支。

使用克隆是唯一的方法。即针对不同的上游建立不同的 Git 库，通过不同的克隆实现针对不同上游版本特性分支开发的管理。例如一旦上游出现新版本，就从当前版本库建立一个克隆，或者用于保存当前上游版本的特性开发状态，或者用于新的上游版本的特性开发。

也许还可以通过其他方法实现，例如将 Topgit 所有相关分支都复制到一个特定的引用目录中，如 `refs/top-tags/v1.0/` 用于实现特性分支的里程碑记录。

