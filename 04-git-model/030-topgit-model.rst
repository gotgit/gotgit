Topgit 协同模型
===============

如果没有 Topgit ，就不会有此书。因为发现了 Topgit，才让我下定决心在公司大范围推广 Git；因为 Topgit，激发了我对 Git 的好奇之心。


我的版本控制系统三个里程碑
---------------------------

从2005年开始我专心于开源软件的研究、定制开发和整合，在这之后的几年，一直使用 Subversion 做版本控制。对于我们这种定制开发的工作，Subversion 有一种称为卖主分支（Vendor Branch）的模式。


::

     +------------V2-------------------------------------V3---   （卖主分支）
     |             \                                       \
  ---V1---o1---o2---M1---o3---o4---o5---o6--- ... ---o99---M2--- （主线）

卖主分支的工作模式如上图所示：

* 上图由左至右，提交随着时间而递增。
* 主线 trunk 用于对定制开发的过程进行跟踪。
* 主线的第一个提交 `V1` 是导入上游（该开源软件官方版本库）发布的版本。
* 之后在 `V1` 提交之处建立分支，是为卖主分支（vendor branch）
* 主线上依次进行了 o1, o2 两次提交，是基于 V1 进行的定制开发。
* 当上游有了新版本，提交到卖主分支上，即 `V2` 提交。和 `V1` 相比除了大量的文件更改外，还可能有文件增加和删除。
* 然后在主线上执行从卖主分支到主线的合并，即提交 `M1` 。因为此时主线上的改动相对少，合并 `V2` 并不太费事。
* 主线继续开发。可能同时有针对不同需求的定制开发，在主线上会有越来越多的提交，如上图从 o3 到 o99 近百次提交。
* 如果在卖主分支上导入上游的新版本 `V3` ，合并将会非常痛苦。因为主线上针对不同需求的定制开发已经混在在一起！

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

但是当我们需要在定制开发上进行多人协作的时候，“Hg + MQ” 弊病就显现了。因为“Hg + MQ”工作模式下，定制开发的成果是一个补丁库，在补丁库上进行协作难度非常大，当发生冲突的时候，补丁的冲突解决不可想象。这就引发了我们第三次版本控制系统大迁移。

2009 年，我们的目光锁定在 Topgit 上。TopGit 的项目名称是来自于 Topic Git 的简写，是基于 Git 的用脚本语言开发的辅助工具，是用于管理多个 Git 的特性分支的工具。Topgit 可以非常简单的实现“变基”——迁移至上游新版本。

Topgit 的主要特点有：

* 上游代码库位于开发主线（master 分支），每一个定制开发都对应于一条 Git 分支（refs/heads/t/feature_name）。
* 特性分支之间的依赖关系不像 "Hg + MQ" 简单的逐一依赖模式，而是可以任意设定分支之间的依赖。
* 特性分支和其依赖的分支可以转出为 Quilt 格式的补丁列表。
* 因为针对某一需求的定制开发在特定的分支中，可以多人协同参与，和正常的 Git 开发别无二致。

Topgit 原理
------------

下面的分支图，是一个近似的 Topgit 实现图（略去了重要的 top-bases 分支）。

::

              +---b1--M1---M3--- （特性分支B: refs/heads/t/B）
              |      /    /
     +---a1---a2---a3----M2---   （特性分支A: refs/heads/t/A）
     |                  /
  ---V1----------------V2---     （主线/卖主分支: master）
     |                  \
     +--------------c1---M4---   （特性分支C: refs/heads/t/C）

在上图中，主线上的 V1 是上游的版本的一次提交。特性分支 A 和 C 都直接依赖主线 master，而特性分支 B 则依赖特性分支 A。提交 M1 是特定分支 B 因为特性分支 A 更新而做的一次迁移。提交 M2 和 M4，则分别是特性分支 A 和 C 因为上游出现了新版本 V2 而做的迁移。当然特性分支 B 也要做相应的迁移，是为 M3。

上述的描述非常粗糙，因为这样的设计很难实现特性分支导出为补丁文件。例如特性分支B的补丁，实际上应该是 M3 和 M2 之间的差异，而绝不是 M3 到 a2 之间的差异。Topgit 为了能够实现分支导出为补丁，又为每个特性的开发引入了第二个分支，追踪分支依赖的“变基”。

::

     +---a1---a2
     |        |
     |        +-------a3---M2--- （特性 B 的变基分支: refs/top-bases/t/B）
     |                    /
     +-------------------V2---   （特性 A 的变基分支: refs/top-bases/t/A）
     |                  /
  ---V1----------------V2---     （主线/卖主分支: master）
     |                  \
     +-------------------V2---   （特性 C 的变基分支: refs/top-bases/t/C）


把上面的两张分支图重合，实际上就可以获得各个特性分支在任一点的特性补丁文件。

上面的特性分支 B 还只是依赖一个分支，如果出现一个分支依赖多个特性分支的话，情况就会更加的复杂，更会体现出这种设计方案的精妙。

Topgit 还在每个特性分支工作区的根目录引入两个文件，用以记录分支的依赖以及关于此分支的说明。

* 文件 `.topdeps` 记录该分支所依赖的分支列表。

  该文件通过 `tg create` 命令在创建特性分支时自动创建，或者通过 `tg depend add` 命令来添加新依赖。

* 文件 `.topmsg`  记录该分支的描述信息。

  该文件通过 `tg create` 命令在创建特性分支时创建，也可以手动编辑。
  
Topgit 的安装
-------------------

Topgit 的可执行命令只有一个 `tg` 。其官方参考手册见: http://repo.or.cz/w/topgit.git?a=blob;f=README 。

安装官方的 Topgit 版本，直接克隆官方的版本库，执行 make 即可。


::

  $ git clone git://repo.or.cz/topgit.git
  $ cd topgit
  $ make
  $ make install

缺省会把可执行文件 `tg` 安装在 $HOME/bin （用户主目录下的 bin 目录）下，如果没有将 ~/bin 加入环境变量 $PATH 中，可能无法执行 tg。如果具有 root 权限，也可以将 tg 安装在系统目录中。

::

  $ sudo prefix=/usr make install

我对 Topgit 做了一些增强和改进，在后面的章节予以介绍。如果想安装我改进的版本，需要预先安装 quilt 补丁管理工具。然后进行如下操作。

::

  $ git clone git://github.com/ossxp-com/topgit.git
  $ cd topgit
  $ QUILT_PATCHES=debian/patches quilt push -a
  $ make
  $ sudo prefix=/usr make install

如果您用的是 Ubuntu 或者 Debian Linux 操作系统，还可以这么安装。

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
--------------

通过前面的原理部分，我们可以发现 Topgit 为管理特性分支，所引入的都是和 Git 兼容的。

* 在 refs/top-bases/ 命名空间下的引用，用于记录分支的变基历史。
* 在特性分支的工作区根目录引入两个文件 .topdeps 和 .topmsg ，用于记录分支依赖和说明。
* 引入新的钩子脚本 hooks/pre-commit ，用于在提交时检查分支依赖有没有发生循环等。

Topgit 的命令行的一般格式为：

::

  tg [global_option] <subcmd> [command_options...] [arguments...]

* 在子命令前为全局选项，目前可用全局选项只有 `-r <remote>` 。

  `-r <remote>` 可选项，用于设定分支跟踪的远程服务器。缺省为 `origin` 。

* 子命令后可以跟命令相关的可选选项，和参数。

tg help 命令
++++++++++++++

tg help 命令显示帮助信息。当在 tg help 后面提供子命令名称，可以获得该子命令详细的帮助信息。

tg create 命令
++++++++++++++

tg create 命令用于创建新的特性分支。用法：

::

  tg [...] create NAME [DEPS...|-r RNAME]

其中：

* NAME 是新的特性分支的分支名，必须提供。一般约定俗成，NAME 以 `t/` 前缀开头，以标明此分支是一个 Topgit 特性分支。
* DEPS... 是可选的一个或多个依赖分支名。如果不提供依赖分支名，则使用当前分支作为新的特性分支的依赖分支。
* -r RNAME 选项，将远程分支作为依赖分支。不常用。

tg create 命令会创建新的特性分支 refs/heads/NAME，跟踪变基分支 refs/top-bases/NAME，并且在项目根目录下创建文件 .topdeps 和 .topmsg 。会提示用户编辑 .topmsg 文件，输入详细的特性分支描述信息。

例如在当前分支 master 下输入命令：

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

如果这时我们想创建一个新的特性分支 t/feature2 ，也是依赖 master，注意我们需要提供 master 作为依赖分支。因为我们当前所处的分支为 t/feature1 。

::

  $ tg create t/feature2 master
  $ git commit -m "create tg branch t/feature2"

下面的命令将创建 t/feature3 分支，该分支依赖 t/feature1 和 t/feature2 。

::

  $ tg create t/feature3 t/feature1 t/feature2
  $ git commit -m "create tg branch t/feature3"

tg info 命令
++++++++++++++

tg info 命令用于显示当前分支或指定的 Topgit 分支的信息。用法：

::

  tg [...] info [NAME]


其中 NAME 是可选的 Topgit 分支名。例如我们执行下面的命令会显示分支 t/feature3 的信息：

::

  $ tg info 
  Topic Branch: t/feature3 (1/1 commit)
  Subject: [PATCH] t/feature3
  Base: 0fa79a5
  Depends: t/feature1
           t/feature2
  Up-to-date.

我们切换到 t/feature1 分支，做一些修改，并提交。

::

  $ git checkout t/feature1
  hack...
  $ git commit -m "hacks in t/feature1."

然后我们再来看 t/feature3 的状态：

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
++++++++++++++

tg update 命令用于更新分支，即从依赖的分支或上游跟踪的分支获取最新的提交合并到当前分支。同时也更新在 refs/top-bases/ 命名空间下的跟踪变基分支。

::

  tg [...] update [NAME]

其中 NAME 是可选的 Topgit 分支名。例如我们就对需要更新的 t/feature3 分支执行 tg update 命令。

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

从上面的输出信息可以看出执行了两次分支合并操作，一次是针对 refs/top-bases/t/feature3 引用指向的跟踪变基分支，另外一次针对的是 refs/heads/t/feature3 特性分支。

执行 tg update 命令因为要设计到分支的合并，因此并非每次都会成功。例如我们在 t/feature3 和 t/feature1 同时对同一个文件（如 feature1）进行修改。然后在 t/feature3 中再执行 tg update 可能就会报错，进入冲突解决状态。

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

我们可以看出第一次对 refs/top-bases/t/feature3 引用指向的跟踪变基分支成功合并，但在对 t/feature3 特性分支进行合并是出错。

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


通过 tg info 命令可以看出当前分支状态是 Up-to-date，但是之前有提示：分支的基（Base）要比头（Head）新，请执行 tg update 命令。这时如果我们执行 tg summary 命令的话，我们可以看到 t/feature3 处于 B (Break) 状态。用 git status 命令，我们可以看出因为两个分支同时修改了文件 `feature1`  导致冲突。

我们可以编辑 feature1 文件，或者调用冲突解决工具解决冲突，之后再提交，才真正完成此次 tg update 。

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
++++++++++++++

tg summary 命令用于显示 Topgit 管理的特性分支的列表及各个分支的状态。用法：

::

  tg [...] summary [-t | --sort | --deps | --graphviz]

不带任何参数执行 tg summary 是最常用的 topgit 命令。在介绍无参数的 tg summary 命令之前，我们先看看其它简单的用法。

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

使用 --graphviz 会输出 GraphViz 格式文件，可以用于显示分支图。

::

  $ tg summary --graphviz | dot -T png -o topgit.png

.. figure:: images/topgit/graphviz.png
   :scale: 100

   Topgit 特性分支关系图

不带任何参数执行 tg summary 会显示分支列表及状态。这是最常用的 topgit 命令之一。

::


  $ tg summary
          t/feature1                      [PATCH] t/feature1
   0      t/feature2                      [PATCH] t/feature2
  >       t/feature3                      [PATCH] t/feature3

其中:

* 标识 '>' ：（t/feature3 分支之前的大于号) 用于标记当前所处的特性分支。
* 标记 '0' ：（t/feature2 分支前的数字 0） 含义是该分支中没有提交，这一个建立后尚未使用或废弃的分支。
'D' marks that it is out-of-date wrt. its dependencies,

* 标记 'D' ： 表明该分支处于过时（out-of-date）状态。可能是一个或多个依赖的分支包含了新的提交，尚未合并到此特性分支。可以用 `tg info` 命令看出到底是由于哪个依赖分支的改动导致该特性分支处于过时状态。
* 标记 'B' ： 之前我们的演示中出现过，表明该分支处于 Break 状态，即可能由于冲突未解决或者其它原因导致该特性分支的基（base）相对该分支的头（head）不匹配。refs/top-bases 下的跟踪变基分支迁移了，但是特性分支未完成迁移。
* 标记 '!' ： 表明该特性分支所依赖的分支不存在。
* 标记 'l' ： 表明该特性分支只存在于本地，不存在于远程跟踪服务器。
* 标记 'r' ： 表明该特性分支既存在于本地，又存在于远程跟踪服务器，并且两者匹配。
* 标记 'L' ： 表明该特性分支，本地的要被远程跟踪服务器要新。
* 标记 'R' ： 表明该特性分支，远程跟踪服务器的要被本地的新。
* 如果没有出现 'l/r/L/R' ： 表明该版本库尚未设置远程跟踪版本库（没有remote）。
* 一般带有标记 'r' 的是最常见的，也是最正常的。

下面我们通过 tg remote 为我们的测试版本库建立一个对应的远程跟踪版本库。

tg remote 命令
++++++++++++++

tg  命令用于创建新的特性分支。用法：

::

  tg [...] 

其中：



::

  $ git init --bare /path/to/test1.git
  Initialized empty Git repository in /path/to/test1.git/

::
 
  $ git remote add origin /path/to/test1.git
  $ git push origin master
  Counting objects: 7, done.
  Delta compression using up to 2 threads.
  Compressing objects: 100% (3/3), done.
  Writing objects: 100% (7/7), 585 bytes, done.
  Total 7 (delta 0), reused 0 (delta 0)
  Unpacking objects: 100% (7/7), done.
  To /path/to/test1.git
   * [new branch]      master -> master

之后我们通过 tg remote 命令告诉 Git 这个远程版本库需要跟踪 Topgit 分支。

::

  $ tg remote --populate origin

::

 [remote "origin"]
        url = /path/to/test1.git
        fetch = +refs/heads/*:refs/remotes/origin/*
+       fetch = +refs/top-bases/*:refs/remotes/origin/top-bases/*
+[topgit]
+       remote = origin

::

$ tg summary 
  l     t/feature1                      [PATCH] t/feature1
 0l     t/feature2                      [PATCH] t/feature2
> l     t/feature3                      [PATCH] t/feature3


$ tg push t/feature2
Counting objects: 5, done.
Delta compression using up to 2 threads.
Compressing objects: 100% (3/3), done.
Writing objects: 100% (4/4), 457 bytes, done.
Total 4 (delta 0), reused 0 (delta 0)
Unpacking objects: 100% (4/4), done.
To /path/to/test1.git
 * [new branch]      t/feature2 -> t/feature2
 * [new branch]      refs/top-bases/t/feature2 -> refs/top-bases/t/feature2

$ tg summary 
  l     t/feature1                      [PATCH] t/feature1
 0r     t/feature2                      [PATCH] t/feature2
> l     t/feature3                      [PATCH] t/feature3



tg push 命令
++++++++++++++

tg  命令用于创建新的特性分支。用法：

::

  tg [...] 

其中：



tg depend 命令
++++++++++++++

tg  命令用于创建新的特性分支。用法：

::

  tg [...] 

其中：



tg base 命令
++++++++++++++

tg  命令用于创建新的特性分支。用法：

::

  tg [...] 

其中：


tg delete 命令
++++++++++++++

tg  命令用于创建新的特性分支。用法：

::

  tg [...] 

其中：


tg export 命令
++++++++++++++

tg  命令用于创建新的特性分支。用法：

::

  tg [...] 

其中：


tg graph 命令
++++++++++++++

tg  命令用于创建新的特性分支。用法：

::

  tg [...] 

其中：


tg import 命令
++++++++++++++

tg  命令用于创建新的特性分支。用法：

::

  tg [...] 

其中：


tg log 命令
++++++++++++++

tg  命令用于创建新的特性分支。用法：

::

  tg [...] 

其中：


tg mail 命令
++++++++++++++

tg  命令用于创建新的特性分支。用法：

::

  tg [...] 

其中：


tg patch 命令
++++++++++++++

tg  命令用于创建新的特性分支。用法：

::

  tg [...] 

其中：






用 Topgit 模式改进 Topgit
---------------------------



设置上游


$ git pull upstream master:tgmaster
From git://repo.or.cz/topgit
   29ab4cf..8b0f1f9  master     -> tgmaster
$ tg summary
  r D   t/debian_locations              [PATCH] make file locations Debian-compatible
  r D   t/export_quilt_all              [PATCH] t/export_quilt_all
  r D   t/fast_tg_summary               [PATCH] t/fast_tg_summary
  r D   t/graphviz_layout               [PATCH] t/graphviz_layout
  r D   t/tg_completion_bugfix          [PATCH] t/tg_completion_bugfix
  r D   t/tg_graph_ascii_output         [PATCH] t/tg_graph_ascii_output
  r D   t/tg_patch_cdup                 [PATCH] t/tg_patch_cdup
  r D   t/tg_push_all                   [PATCH] t/tg_push_all
$ git co t/export_quilt_all
Switched to branch 't/export_quilt_all'
$ tg info
Topic Branch: t/export_quilt_all (5/4 commits)
Subject: [PATCH] t/export_quilt_all
Base: 29ab4cf
Remote Mate: origin/t/export_quilt_all
Depends: tgmaster
Needs update from:
        tgmaster (23/23 commits)
$ tg update
tg: Updating base with tgmaster changes...
Updating 29ab4cf..8b0f1f9
Fast-forward
 .gitignore                 |   41 ++++++++++------
 README                     |   44 ++++++++++++++++-
 contrib/tg-completion.bash |   18 +++++++-
 hooks/pre-commit.sh        |   83 +++++++++++++++++++++++++++++---
 tg-base.sh                 |    9 ++++
 tg-depend.sh               |   39 ++++++++++++---
 tg-export.sh               |    7 +--
 tg-log.sh                  |   30 ++++++++++++
 tg-remote.sh               |    5 ++-
 tg-summary.sh              |  114 ++++++++++++++++++++++++++++----------------
 tg-update.sh               |   18 +++++--
 tg.sh                      |   31 ++++++++++--
 12 files changed, 346 insertions(+), 93 deletions(-)
 create mode 100644 tg-base.sh
 create mode 100644 tg-log.sh
tg: The t/export_quilt_all head is up-to-date wrt. its remote branch.
tg: Updating t/export_quilt_all against new base...
Auto-merging README
Auto-merging tg-export.sh
Merge made by recursive.
 .gitignore                 |   41 ++++++++++------
 README                     |   44 ++++++++++++++++-
 contrib/tg-completion.bash |   18 +++++++-
 hooks/pre-commit.sh        |   83 +++++++++++++++++++++++++++++---
 tg-base.sh                 |    9 ++++
 tg-depend.sh               |   39 ++++++++++++---
 tg-export.sh               |    7 +--
 tg-log.sh                  |   30 ++++++++++++
 tg-remote.sh               |    5 ++-
 tg-summary.sh              |  114 ++++++++++++++++++++++++++++----------------
 tg-update.sh               |   18 +++++--
 tg.sh                      |   31 ++++++++++--
 12 files changed, 346 insertions(+), 93 deletions(-)
 create mode 100644 tg-base.sh
 create mode 100644 tg-log.sh
$ tg info
Topic Branch: t/export_quilt_all (6/4 commits)
Subject: [PATCH] t/export_quilt_all
Base: 8b0f1f9
Remote Mate: origin/t/export_quilt_all
* Local head is ahead of the remote head.
Depends: tgmaster
Up-to-date.
$ tg summary 
  r D   t/debian_locations              [PATCH] make file locations Debian-compatible
> rL    t/export_quilt_all              [PATCH] t/export_quilt_all
  r D   t/fast_tg_summary               [PATCH] t/fast_tg_summary
  r D   t/graphviz_layout               [PATCH] t/graphviz_layout
  r D   t/tg_completion_bugfix          [PATCH] t/tg_completion_bugfix
  r D   t/tg_graph_ascii_output         [PATCH] t/tg_graph_ascii_output
  r D   t/tg_patch_cdup                 [PATCH] t/tg_patch_cdup
  r D   t/tg_push_all                   [PATCH] t/tg_push_all
$ tg push --all

$ git co master
$ git merge tgmaster
Merge made by recursive.
 .gitignore                 |   41 ++++++++++------
 README                     |   44 ++++++++++++++++-
 contrib/tg-completion.bash |   18 +++++++-
 hooks/pre-commit.sh        |   83 +++++++++++++++++++++++++++++---
 tg-base.sh                 |    9 ++++
 tg-depend.sh               |   39 ++++++++++++---
 tg-export.sh               |    7 +--
 tg-log.sh                  |   30 ++++++++++++
 tg-remote.sh               |    5 ++-
 tg-summary.sh              |  114 ++++++++++++++++++++++++++++----------------
 tg-update.sh               |   18 +++++--
 tg.sh                      |   31 ++++++++++--
 12 files changed, 346 insertions(+), 93 deletions(-)
 create mode 100644 tg-base.sh
 create mode 100644 tg-log.sh
$ make -f debian/rules debian/patches
rm -rf debian/patches
tg export --quilt --all debian/patches
Exporting t/debian_locations
Exporting t/export_quilt_all
Exporting t/fast_tg_summary
Exporting t/graphviz_layout
Exporting t/tg_completion_bugfix
Exporting t/tg_graph_ascii_output
Exporting t/tg_patch_cdup
Exporting t/tg_push_all
Exported topic branch  (total 8 topics) to directory debian/patches




$ tg -r github summary 
  rL    t/debian_locations              [PATCH] make file locations Debian-compatible
  rL    t/export_quilt_all              [PATCH] t/export_quilt_all
  rL    t/fast_tg_summary               [PATCH] t/fast_tg_summary
  rL    t/graphviz_layout               [PATCH] t/graphviz_layout
  rL    t/tg_completion_bugfix          [PATCH] t/tg_completion_bugfix
  rL    t/tg_graph_ascii_output         [PATCH] t/tg_graph_ascii_output
  rL    t/tg_patch_cdup                 [PATCH] t/tg_patch_cdup
  rL    t/tg_push_all                   [PATCH] t/tg_push_all



群英汇 TopGit 改进 (1): tg push 全部分支
-----------------------------------------

TopGit 的项目名称是来自于 Topic Git 的简写，是用于管理多个 Git 的特性分支的工具。如果您对 Hg 的 MQ 有所了解的话，我可以告诉你，TopGit 是用 Git 维护补丁列表的工具；TopGit 就是 MQ 在 Git 中的等价物 ，而且做的更好。 Yes

   1. 什么是 TopGit？参见 TopGit 手册
   2. TopGit 代码库：http://repo.or.cz/w/topgit.git

群英汇终于决定采用 Git 作为公司内部的代码管理工具，就是因为我们发现了 TopGit。参见：《群英汇版本控制系统的选择：subversion, hg, git》。

在每日的使用过程中，我们也发现了 TopGit 的一些问题，不断的挠到我们的痒处。遵循 ESR的理论 ，我们决定对 TopGit 进行改进，于是就有了我们在 Github 上的 TopGit 版本库： http://github.com/ossxp-com/topgit

最近，我又感觉到 TopGit 一个不便利的地方，今天终于临时决定 Hack。Hack 结束之后，就有了写一个系列文章的想法，于是这个系列文章，就从今天这个最新的 Hack 写起。
为 tg push 命令增加 –all 参数

我之前的一篇文章：《Git 如何拆除核弹起爆码，以及 topgit 0.7到0.8的变迁》，曾经提到过，TopGit 0.7 到 0.8 的一个非常大的改变，就是取消了在 .git/config 中的 强制 non-fast-forward 更新的 push 参数。

在 TopGit 0.7 以及之前的版本，可以通过执行一个简单的 git push 命令，就可以将所有的 TopGit 分支以及相关的 top-bases 分支 PUSH 到服务器上。

但是 TopGit 0.8 版本之后，不再向 .git/config 中添加相关 PUSH 指令，因为强制 non-fast-forward 的 PUSH 会导致多人协同工作时，互相覆盖对方改动！！！但是这么做的结果，也就失去了使用 git push 向远程服务器同步 TopGit 分支的便利。

TopGit 0.8 版本提供了一个新命令 tg push，用于向服务器 PUSH TopGit 分支以及关联的 top-bases 分支。这样，就弥补了不能再使用 git push 和服务器同步 TopGit 以及 top-bases 分支的遗憾了。

一个让人痒痒的问题产生了：

    * tg push 只能 push 当前工作的 TopGit 分支；
    * 或者 tg push 后面加上各个分支的名字，实现对分支的 PUSH
    * 但是 tg push 没有一个 –all 选项，必须一个一个的将需要 PUSH 的 tg 分支罗列出来
    * 我们有的项目的分支有上百个！！！如果改动的多的话，要一个一个切换或者一个一个写在命令行中，太恐怖了。 Sweat

问题的解决：

    * 增加了对 -a 以及 –all 参数的支持
    * 如果用户没有指定分支，并且提供了 -a | –all 参数，则将当前所有 topgit 分支加入同步的分支列表中
    * 创建新的分支，开始写代码：

      $ tg create t/tg_push_all tgmaster
      tg: Creating t/tg_push_all base from tgmaster...
      Switched to a new branch 't/tg_push_all'
      tg: Topic branch t/tg_push_all set up. Please fill .topmsg now and make initial commit.
      tg: To abort: git rm -f .top* && git checkout tgmaster && tg delete t/tg_push_all

      # Hack, Hack, Hack...
      # Test, Test, Test...

      $ git st
      # On branch t/tg_push_all
      # Changes to be committed:
      #   (use "git reset HEAD <file>..." to unstage)
      #
      #       new file:   .topdeps
      #       new file:   .topmsg
      #
      # Changed but not updated:
      #   (use "git add <file>..." to update what will be committed)
      #   (use "git checkout -- <file>..." to discard changes in working directory)
      #
      #       modified:   .topmsg
      #       modified:   tg-push.sh
      #

      $ git ci -a -m "add --all option support to tg_push"
      [t/tg_push_all 7df16a5] add --all option support to tg_push
       3 files changed, 22 insertions(+), 1 deletions(-)
       create mode 100644 .topdeps
       create mode 100644 .topmsg

    * 切换到 master (debian) 分支，编译新的 群英汇 软件包  topgit＋，并安装

      $ git co master
      $ git br
      * master
       t/debian_locations
       t/export_quilt_all
       t/fast_tg_summary
       t/tg_completion_bugfix
       t/tg_patch_cdup
       t/tg_push_all
       tgmaster
      $ make -f debian/rules  debian/patches
      rm -rf debian/patches
      tg export --quilt --all debian/patches
      Exporting t/debian_locations
      Exporting t/export_quilt_all
      Exporting t/fast_tg_summary
      Exporting t/tg_completion_bugfix
      Exporting t/tg_patch_cdup
      Exporting t/tg_push_all
      Exported topic branch  (total 6 topics) to directory debian/patches
      $ git st
      # On branch master
      # Changed but not updated:
      #   (use "git add <file>..." to update what will be committed)
      #   (use "git checkout -- <file>..." to discard changes in working directory)
      #
      #       modified:   debian/patches/series
      #
      # Untracked files:
      #   (use "git add <file>..." to include in what will be committed)
      #
      #       debian/patches/t/tg_push_all.diff
      no changes added to commit (use "git add" and/or "git commit -a")
      $ git add debian/patches/t/tg_patch_all.diff
      $ vi debian/changelog
      edit, edit, edit...
      $ head -5 debian/changelog
      topgit (0.8-1+ossxp7) unstable; urgency=low

       * add --all support to tg patch.

       -- Jiang Xin <jiangxin@ossxp.com>
      $ git ci -a -m "new patch: add --all option support to tg_push."
      [master c927b02] new patch: add --all option support to tg_push.
       3 files changed, 61 insertions(+), 0 deletions(-)
       create mode 100644 debian/patches/t/tg_push_all.diff

      $ dpkg-buildpackage -b -rfakeroot
      ...
      dpkg-deb：正在新建软件包“topgit”，包文件为“../topgit_0.8-1+ossxp7_all.deb”。
       dpkg-genchanges -b >../topgit_0.8-1+ossxp7_amd64.changes
      ...
      $ sudo dpkg -i ../topgit_0.8-1+ossxp7_all.deb
      ...

    * 改动 PUSH 到 Github

      $ git remote -v
      github  git@github.com:ossxp-com/topgit.git (fetch)
      github  git@github.com:ossxp-com/topgit.git (push)
      origin  git@bj.ossxp.com:users/jiangxin/topgit.git (fetch)
      origin  git@bj.ossxp.com:users/jiangxin/topgit.git (push)
      upstream        git://repo.or.cz/topgit.git (fetch)
      upstream        git://repo.or.cz/topgit.git (push)
      $ tg -r github summary
      r     t/debian_locations              [PATCH] make file locations Debian-compatible
      r     t/export_quilt_all              [PATCH] t/export_quilt_all
      r     t/fast_tg_summary               [PATCH] t/fast_tg_summary
      r     t/tg_completion_bugfix          [PATCH] t/tg_completion_bugfix
      r     t/tg_patch_cdup                 [PATCH] t/tg_patch_cdup
      l     t/tg_push_all                   [PATCH] t/tg_push_all
      $ tg -r github push --all
      Everything up-to-date
      Everything up-to-date
      Everything up-to-date
      Everything up-to-date
      Everything up-to-date
      Counting objects: 7, done.
      Delta compression using up to 2 threads.
      Compressing objects: 100% (4/4), done.
      Writing objects: 100% (5/5), 757 bytes, done.
      Total 5 (delta 2), reused 0 (delta 0)
      To git@github.com:ossxp-com/topgit.git
      * [new branch]      refs/top-bases/t/tg_push_all -> refs/top-bases/t/tg_push_all
      * [new branch]      t/tg_push_all -> t/tg_push_all

    * 改完，收工。

相关代码提交：

    * http://github.com/ossxp-com/topgit/commit/7df16a56c0fff942e731d1831332ba7216162c2a



Topgit 分支图显示
------------------

使用 Git + topgit 做版本控制，当 topgit分支（功能分支）非常多并且相互依赖比较复杂时，非常需要有一个直观的图形化的分支依赖图。

联想到我们使用 git 经常用到的 git glog 命令输出，如果 topgit 分支图能够有类似的显示就太好了：

| | * t/unittest
| |/
| *---.   t/message_localize
| |\ \ \
| * | | | t/auth_log_for_fail2ban
|/ / / /
| * | | t/factor_invite
|/ / /
| * | t/factor_ldap
|/ /
| * t/include_macro_for_templates
| * t/multi_language
|/
* master

正在冥思苦想如何实现时，忽然发现 topgit 的 tg-summary 中原来已经有图形输出的实现，是借用 graphviz 工具进行图形化输出…


tg summary 命令的 graphviz 输出

原来 tg summary 命令已经包含了分支关系图的输出，只不过输出的是 graphviz 的 .dot 格式文件。

使用下面的命令可以输出 topgit 分支图：

$ tg summary --graphviz

下面是我们改进后的 tg summary –graphviz 命令的输出

# GraphViz output; pipe to:
#   | dot -Tpng -o
# or
#   | dot -Txlib

digraph G {

  graph [
    rankdir = RL
    label="TopGit Layout\n\n\n"
    fontsize = 14
    labelloc=top
    pad = "0.5,0.5"
  ];

  node [
    shape=box
    fontsize = 12
    fontcolor= blue
    color= blue
  ];

  edge [
    color= green
  ];

  "t/add_know_user_support_for_autoadmingroup" -> "master";
  "t/attach_default_action" -> "master";
  "t/attach_dl_content_type" -> "master";
  "t/auth_actions" -> "t/wikiutil_d";
  "t/auth_by_category_hierarchic" -> "master";
  "t/auth_by_category_hierarchic" -> "t/macro_showcategory";
   ...
}

GraphViz 格式输出文件解说：

    * 头几行已经暗示了如何使用本输出，只要通过管道输入给graphviz的 dot 命令，就可以生成相应的图片
    * graph 小节的 rankdir = RL 指令设置节点的方向。这里是从右至左
    * node 小节的 shape=box 指令，设定输出图片中节点的形状是长方形
    * edge 小节的 color= green 指令，设定输出图片中连接线的颜色为绿色
    * 后面的是数据。即分支的依赖关系，将根据此依赖关系画图

使用 graphviz 显示分支图

首先确认已经安装了 graphviz 软件包。该软件包有30多个命令，其中我们将用到的有：

    * dot：画直连图。将 topgit 的 graphviz 格式输出数据转换为图片。
    * ccomps：对节点进行过滤，如忽略孤立节点，或者只显示当前节点所在的图，而忽略之外的节点。
    * gvpr：图片流编辑器，可以嵌入脚本实现定制的输出。

示例，针对 cosign 的topgit 分支，显示分支图。

命令：

$ tg summary --graphviz | dot -Tpng -o topgit.png

输出的分支图：
分支图的文本输出

还记得本文一开始设置的目标么？类似 git glog 命令的文本分支图显示。

非常令人惊奇的是，居然找到同样有此需求的人，并且已经实现。参见：  http://kerneltrap.org/mailarchive/git/2009/5/20/2922

    * 惊奇一：相同的需求。都是希望获取类似 git glog 的文本分支图显示，或者称为 ascii art 输出。
      文本格式输出的好处除了简单易用外，还可以拷贝粘贴，而图像就不行了。
    * 惊奇二：实现思路相似。都想到了利用 git 现有代码，主要就是 graph.c
    * 惊奇三：作者竟然这么简单就实现了。利用 graphviz 的 gvpr 非常简单的就实现了，重用了 topgit 的 graphviz 输出和 git 的相关代码。

采用拿来主义，最终也实现了文本显示 topgit 分支图的目标。示例：

$ tg graph --header
* t/bugfix_cosign_httponly_quirk
| From: Jiang Xin <worldhello.net@gmail.com>
| Subject: [PATCH] t/bugfix_cosign_httponly_quirk
|
| * t/bugfix_no_retry_report
|/  From: Jiang <jiangxin@ossxp.com>
|   Subject: [PATCH] t/bugfix_no_retry_report
|   
| * t/factor_admin
|/  From: Jiang <jiangxin@ossxp.com>
|   Subject: [PATCH] t/factor_admin
|   
| *   t/message_translation
| |\  From: Jiang <jiangxin@ossxp.com>
| | | Subject: [PATCH] t/message_translation



