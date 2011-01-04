Git 分支
********

分支是我们的老朋友了，在第2部分的“Git对象库探秘”和“Git重置”章节中，就早已经从实现原理上理解了 master 分支的存在方式，以及 master 分支的指向是如何随着提交而变化以及如何通过 `git reset` 命令而重置。

在之前的章节中，始终只用到了一个分支：master 分支。本章可以学习到如何创建分支，如何切换到其他分支工作，以及分支之间的合并、变基等。

代码管理之殇
============

分支是代码管理的利器。如果没有有效的分支管理，代码管理就适应不了复杂的开发过程和项目需要。在实际的项目实践中，单一分支的单线开发模式远远不够。

* 成功的软件项目大多要经过多个开发周期，发布多个软件版本。每个已经发布的版本都可能发现 Bug，就需要对历史版本进行更改。
* 有前瞻性的项目管理，新版本的开发往往是和当前版本同步进行的。如果两个版本的开发都混杂在 master 分支，肯定是一场灾难。
* 如果产品要针对不同客户定制，肯定是希望客户越多越好。如果所有的客户定制都混杂在一个分支中，必定带来混乱。如果使用多个分支管理不同的定制，但管理不擅，分支之间定制功能的迁移会成为头痛的问题。
* 即便是所有成员都在为同一个项目的同一个版本进行工作，每个人领受任务却不尽相同，有的任务开发周期会很长，有的任务需要对软件架构进行较大的修改，如果所有人都工作在同一分支，就会因为过多过频的冲突导致效率低下。
* 敏捷开发（不管是极限编程XP还是 Scrum 或其他）是最有效的项目管理模式，其最有效的一个实践就是快速迭代、每晚编译。如果不能将项目的各个功能模块的开发通过分支进行隔离，在软件集成上就会遇到困难。

发布分支
--------

**为什么 Bug 没完没了？**

在 2006 年，我接触到一个项目团队，使用 Subversion 做版本控制。最为困扰项目经理的是刚刚修正产品的一个 Bug，马上又会接二连三的发现新的 Bug。在访谈开发人员，询问开发人员是如何修正 Bug 的时候，开发人员的回答让我大吃一惊：“当发现产品的 Bug 的时候，我要中断当前工作，把我正在开发的新功能的代码注释掉，然后再去修改 Bug，修改好就生成一个 war 包（Java项目）给运维部门，扔到网站上去。”

于是画了下面的一个图，大致描述了这个团队进行 Bug 修正的过程，从中可以很容易的看出问题的端倪。这个图对于 Git 甚至其他版本库控制系统同样适用。

.. figure:: images/gitbook/branch-release-branch-question.png
   :scale: 80


说明：

* 上图中的图示1，开发者针对功能1做了一个提交，编号 "F1.1" 。这时客户报告产品出现了 Bug。
* 于是开发者匆忙的干了起来，图示2显示了该开发者修正Bug的过程：将已经提交的针对功能1的代码 "F1.1" 注释掉，然后提交一个修正Bug的提交（编号：fix1）。
* 开发者编译出新的产品交给客户，接着开始功能1的开发。图示3显示了开发者针对功能1作出了一个新的提交 "F1.2"。
* 客户再次发现一个 Bug。开发者再次开始 Bug 修正工作。
* 图示4和图示5显示了此工作模式下非常容易在修复的产品中引入新的问题。
* 图示4的问题在于开发者注释功能1的代码时，不小心将 "fix1" 的代码也注释掉了，导致曾经修复的Bug在新版本中重现。
* 图示5的问题在于开发者没有将功能1的代码剔出干净，导致在产品的新版本中引入了不完整和不需要的功能代码。用户可能看到一个新的但是不能使用的菜单项，甚至更糟。

使用版本控制系统的分支功能，可以避免对已发布的软件版本进行 Bug 修正时引入新功能的代码，或者因误删其他 Bug 修正代码导致已修复问题重现。在这种情况下创建的分支有一个专门的名词：Bugfix 分支或发布分支（Release Branch）。之所以又称为发布分支，是因为在软件新版本发布后的维护阶段经常使用此技术进行维护，发布升级版本。

下图演示了如何使用发布分支应对 Bug 修正的问题。

.. figure:: images/gitbook/branch-release-branch-answer.png
   :scale: 80

说明：

* 上图中的图示2，可以看到开发者创建了一个发布分支（Bugfix分支），在分支中提交修正代码 "fix1"。注意此分支自上次软件发布时最后一次提交进行创建，因此分支中没有包含开发者为新功能所做的提交 "F1.1"，是一个“干净”的分支。
* 图示3可以看出从发布分支向主线做了一次合并，这是因为在主线也同样存在该 Bug，需要在主线也作出相应的更改。
* 图示4，开发者继续开发，提交了针对功能1的另外一个提交，编号 "F1.2"。这时，客户报告有新的 Bug。
* 继续在发布分支进行 Bug 修正，参考图示5。当修正完成（提交 "fix2"），基于发布分支创建一个新的软件版本发给客户。不要忘了向主线合并，因为同样的 Bug 可能在主线上也存在。

关于如何基于一个历史提交创建分支，以及如何在分支之间进行合并，在本章后面的内容中会详细介绍。

特性分支
--------

**为什么项目一再的拖延？**

有这么一个软件项目，项目已经延期了可是还是看不到一点要完成的样子。最终老板变得有些不耐烦了，说道：“那么就砍掉一些功能吧”。项目经理听闻，一阵眩晕，因为项目经理知道自己负责的这个项目采用的是单一主线开发，要将一个功能从中撤销，工作量非常大，而且可能会牵涉到其他相关模块的变更。

下面的示意图，就是这个项目的版本库示意图，显然这个项目的代码管理没有使用分支。

.. figure:: images/gitbook/branch-feature-branch-question.png
   :scale: 100

说明：

* 上图中的图示1，可以用圆圈代表功能1的历次提交，用三角代替功能2的历次提交。因为所有用户都在主线上工作，所以提交混杂在一起。
* 图示2代表老板决定功能2不在这一版本的产品中发布，延期到下一个版本，于是功能2的开发者做了一个或者若干个反向提交。图中倒三角（代号为 "F2.X"）的提交将功能2的所有提交全部撤销。
* 图示3表示除了功能2外的其他开发继续进行。

那么负责开发功能2的开发者干什么呢？或者放一个长假，或者在本地开发，与版本库隔离，即不向版本库提交，直到延期的项目终于发布之后再将代码提交。这两种方法都是不可取的，尤其是后一种隔离开发最危险，如果因为病毒感染、文件误删、磁盘损坏，就会导致全部工作损失殆尽。我的项目组就曾经遇到过这样的情况。

采用分支将某个功能或模块的开发与开发主线独立出来，是解决类似问题的办法，这种用途的分支被称为特性分支（Feature Branch）或主题分支（Topic Branch）。下面这个图就展示了前面提到的延期的项目在特性分支的帮助下协同多用户的开发。

.. figure:: images/gitbook/branch-feature-branch-answer.png
   :scale: 100

说明：

* 上图中的图例1和前面的一样，都是多个用户的提交混杂在开发主线中。
* 图例2是当得知功能2不在此次产品发布后，开发者做了如下操作：

  - 提交一个（或若干个）反向提交，将功能2的相关代码全部撤销。图中倒三角（代号为 "F2.X"）的提交就是一个反向提交。
  - 接着从反向提交开始创建一个特性分支。
  - 将功能2的历史提交拣选到特性分支上。对于 Git 可以使用拣选命令 `git cherry-pick` 。

* 图例3中可以看出包括功能2在内的所有功能和模块都继续提交，但是提交的分支可能各不相同。功能2的开发者将代码提交到特性分支上，其他用户还提交到主线上。

那么在什么情况下使用特性分支呢？试验性、探索性的功能开发应该为其建立特性分支。功能复杂、开发周期长（有可能在本次发布中取消）的模块应该为其建立特性分支。会对软件体系架构更改，破坏软件集成，或者容易导致冲突、影响他人开发进度的模块，应该为其建立特性分支。

在使用 CVS 或者 Subversion 等版本控制系统建立分支相对不太方便，因为分支建立需要相关授权。Git 的分支管理就方便多了，一是用户可以在本地版本库随心所欲的创建分支，二是管理员可以对共享版本库进行设置允许用户创建特定名称的分支，这样用户的本地分支可以推送到服务器实现数据的备份。关于 Git 服务器的分支授权参照本书第5篇的Gitolite 服务器架设相关章节。

卖主分支
--------

有的项目要引用到第三方的代码模块并且需要对其进行定制，有的项目甚至整个就是基于某个开源项目进行的定制。如何有效的对本地定制和第三方（上游）代码的变更进行管理就成为一个难题。卖主分支（Vendor Branch）可以部分解决这个难题。

所谓卖主分支，就是在版本库中创建一个专门和上游代码进行同步的分支，一旦有上游代码发布就检入到卖主分支中。下面的示意图就是一个典型的卖主分支工作流程。

::

     +------------V2-------------------------------------V3---   （卖主分支）
     |             \                                       \
  ---V1---o1---o2---M1---o3---o4---o5---o6--- ... ---o99---M2--- （主线）

说明：

* 在主线上检入上游软件的 1.0 版本库。在图中标记为 V1 的提交即是。
* 然后在主线上进行定制开发，o1, o2 分别代表历次定制提交。
* 当上游有了新版本库的源代码发布，例如 2.0 版本，就将新版本的上游代码提交到卖主分支中。图中标记为 V2 的提交即是。
* 然后在主线上合并卖主分支上的新提交，合并后的提交显示为 `M1` 。

如果定制较少，使用卖主分支可以工作的很好，但是如果定制的内容非常多，在合并的时候就会遇到非常多的冲突。定制的代码越多，混杂的越厉害，冲突解决就越困难。

本章还不能针对复杂的定制开发给出满意的版本控制解决方案。在本书的第4部分的 Topgit 相关章节会介绍一个对定制开发更好的协同模型。

分支命令概述
============

在 Git 中分支管理使用命令 `git branch` 。该命令的主要用法如下：

::

  用法1： git branch
  用法2： git branch <branchname>
  用法3： git branch <branchname> <start-point>
  用法4： git branch -d <branchname>
  用法5： git branch -D <branchname>
  用法6： git branch -m <oldbranch> <newbranch>
  用法7： git branch -M <oldbranch> <newbranch>

说明：

* 用法1 用于显示本地分支列表。当前分支在输出中会显示为特别的颜色，并用星号 "*" 标识出来。
* 用法2 和用法3 用于创建分支。

  用法2 基于当前头指针（HEAD）指向的提交创建分支，新分支的分支名为 `<branchname>` 。

  用法3 基于提交 `<start-point>` 创建新分支，新分支的分支名为 `<branchname>` 。

* 用法4 和用法5 用于删除分支。

  用法4 在删除分支 <branchname> 时会检查所要删除的分支是否已经合并到其他分支中，否则拒绝删除。

  用法5 会强制删除分支 <branchname> ，即使该分支没有合并到任何一个分支中。

* 用法6 和用法7 用于重命名分支。

  如果版本库中已经存在名为 `<newbranch>` 的分支，用法6 拒绝执行重命名，而用法7 会强制执行。

下面就通过 `hello-world` 项目演示 Git 的分支管理。

Hello World 开发计划
====================

上一章从 Github 上检出的 `hello-world` 包含了一个 C 语言开发的应用，现在假设项目 `hello-world` 做产品发布，版本号定为 1.0，则做下面的里程碑操作。

* 为 `hello-world` 创建里程碑 `v1.0` 。

  ::

    $ cd /path/to/user1/workspace/hello-world/
    $ git tag -m "Release 1.0" v1.0

* 将新建的里程碑推送到远程共享版本库。

  ::

    $ git push origin refs/tags/v1.0
    Counting objects: 1, done.
    Writing objects: 100% (1/1), 158 bytes, done.
    Total 1 (delta 0), reused 0 (delta 0)
    Unpacking objects: 100% (1/1), done.
    To file:///path/to/repos/hello-world.git
     * [new tag]         v1.0 -> v1.0

到现在为止还没有运行 `hello-world` 项目呢，现在就在 user1 的工作区中运行一下。

* 进入 `src` 目录，编译程序。

  ::

    $ cd src
    $ make
    version.h.in => version.h
    cc    -c -o main.o main.c
    cc -o hello main.o

* 使用参数 `--help` 运行 `hello` 程序，可以查看帮助信息。

  说明：hello 程序的帮助输出中有一个拼写错误，本应该是 `--help` 的地方写成了 `-help` 。这是有意为之。

  ::

    $ ./hello --help
    Hello world example v1.0
    Copyright Jiang Xin <jiangxin AT ossxp DOT com>, 2009.

    Usage:
        hello
                say hello to the world.

        hello <username>
                say hi to the user.

        hello -h, -help
                this help screen.

* 不带参数运行，向全世界问候。

  说明：最后一行显示版本为 "v1.0"，这显然是来自于新建立的里程碑 "`v1.0`" 。 
  
  ::

    $ ./hello
    Hello world.
    (version: v1.0)

* 执行命令的时候，后面添加用户名，向用户问候。

  说明：下面在运行 `hello` 的时候，显然出现了一个 Bug，即用户名中间如果出现了空格，输出的欢迎信息只包含了部分的用户名。这个 Bug 也是有意为之。

  ::

    $ ./hello Jiang Xin
    Hi, Jiang.
    (version: v1.0)

**新版本开发计划**

既然 v1.0 已经发布了，现在是时候制订下一个版本 v2.0 的开发计划。计划如下：

* 多语种支持。

  即为 `hello-world` 添加多语种支持，使得问候的时候能够显示中文或其他本地化语言。

* 参数解析框架改造，以便实现更灵活的命令行处理。

  在 v1.0 版本中，程序内部解析参数使用了简单的字符串比较，非常不灵活，需要将其改造为使用 `getopt_long` 函数处理命令行参数。

  从源文件 `src/main.c` 中可以当前实现的局限。

  ::

    $ git grep -n argv
    main.c:20:main(int argc, char **argv)
    main.c:24:    } else if ( strcmp(argv[1],"-h") == 0 ||
    main.c:25:                strcmp(argv[1],"--help") == 0 ) {
    main.c:28:        printf ("Hi, %s.\n", argv[1]);

最终决定由用户 user2 负责“多语种支持”，由用户 user1 负责“参数解析框架改造”。

创建特性分支
============

有了前面“代码管理之殇”的铺垫，在领受任务之后，用户 user1 和 user2 应该为自己负责的功能创建特性分支。

创建分支 user1/getopt
----------------------

用户 user1 负责“参数解析框架改造”功能，因为这个功能用到 `getopt` 函数，于是用户 user1 在本地版本库创建分支 `user1/getopt` 。

* 用户 user1 基于当前 HEAD 创建分支 `user1/getopt` 。

  ::

    $ git branch user1/getopt

* 显示本地分支，当前工作分支仍为 master 分支，在下面的输出中用星号 "*" 标识。

  ::

    $ git branch
    * master
      user1/getopt

* 执行 `git checkout` 命令切换到新分支上。

  ::

    $ git checkout user1/getopt
    Switched to branch 'user1/getopt'

* 再次查看分支，看到已经切换到新分支上。

  ::

    $ git branch
      master
    * user1/getopt

分支的奥秘
----------

分支实际上是创建在目录 `.git/refs/heads` 下的引用，版本库初始时创建的 `master` 分支就是在该目录下。在第2部分“Git重置”的章节中，已经介绍过 master 分支的实现，实际上这也是所有分支的实现方式。

* 查看一下目录 `.git/refs/heads` 目录下的引用。

  可以在该目录下看到 `master` 文件，和一个目录 `user1`。而在 `user1` 目录下是文件 `getopt` 。

  ::

    $ ls -F .git/refs/heads/
    master  user1/
    $ ls -F .git/refs/heads/user1/
    getopt

* 因为引用 `.git/refs/heads/user1/getopt` 是基于头指针 HEAD 创建的分支，因此该文件的内容和 `master` 分支内容应该一致，都执行同一个提交。

  ::

    $ cat .git/refs/heads/user1/getopt 
    ebcf6d6b06545331df156687ca2940800a3c599d
    $ cat .git/refs/heads/master 
    ebcf6d6b06545331df156687ca2940800a3c599d
    $ git cat-file -p ebcf6d6
    tree 1d902fedc4eb732f17e50f111dcecb638f10313e
    parent 8a9f3d16ce2b4d39b5d694de10311207f289153f
    author user1 <user1@sun.ossxp.com> 1293959073 +0800
    committer user1 <user1@sun.ossxp.com> 1293959073 +0800

    blank commit for GnuPG-signed tag test.

* 当前分支为 `user1/getopt` ，实际上是因为执行 `git checkout` 命令时更新了 `.git/HEAD` 文件的内容。可以参照第2部分“Git检出”相关章节。

  ::

    $ cat .git/HEAD 
    ref: refs/heads/user1/getopt

在 user1/getopt 分支中工作
--------------------------

用户 user1 开始在 `user1/getopt` 分支中工作，重构 `hello-world` 中的命令行参数解析的代码。重构时采用 `getopt_long` 函数。

读者可以试着更改，不过在 `hello-world` 中已经保存了一份改好的代码，可以直接检出。

* 执行下面的命令，用里程碑 `jx/v2.0` 标记的内容替换暂存区和工作区。

  ::

    $ git checkout jx/v2.0 -- .

* 因为上面的 `git checkout` 命令的最后是一个点 "." ，因此检出只更改了暂存区和工作区，而没有修改头指针。

  下面命令可以看出当前分支仍为 `user1/getopt` ，而且文件 `src/main.c` 被修改了。

  ::

    $ git status 
    # On branch user1/getopt
    # Changes to be committed:
    #   (use "git reset HEAD <file>..." to unstage)
    #
    #       modified:   src/main.c
    #

* 比较暂存区和HEAD的文件差异，可以看到重构命令行解析对代码的改动。

  ::

    $ git diff --cached
    diff --git a/src/main.c b/src/main.c
    index 6ee936f..fa5244a 100644
    --- a/src/main.c
    +++ b/src/main.c
    @@ -1,4 +1,6 @@
     #include <stdio.h>
    +#include <getopt.h>
    +
     #include "version.h"
     
     int usage(int code)
    @@ -19,15 +21,44 @@ int usage(int code)
     int
     main(int argc, char **argv)
     {
    -    if (argc == 1) {
    +    int c;
    +    char *uname = NULL;
    +
    +    while (1) {
    +        int option_index = 0;
    +        static struct option long_options[] = {
    +            {"help", 0, 0, 'h'},
    +            {0, 0, 0, 0}
    +        };
    ...

* 提交。

  ::

    $ git commit -m "Refactor: use getopt_long for arguments parsing."
    [user1/getopt 0881ca3] Refactor: use getopt_long for arguments parsing.
     1 files changed, 36 insertions(+), 5 deletions(-)

* 提交完成之后，可以看到这时 user1/getopt 分支和 master 分支的指向不同了。

  ::

    $ git rev-parse user1/getopt master
    0881ca3f62ddadcddec08bd9f2f529a44d17cfbf
    ebcf6d6b06545331df156687ca2940800a3c599d

* 编译运行 `hello-world` 。

  ::
    $ cd src
    $ make clean
    rm -f hello main.o version.h
    $ make
    version.h.in => version.h
    cc    -c -o main.o main.c
    cc -o hello main.o
    $ ./hello 
    Hello world.
    (version: v1.0-1-g0881ca3)

使用 git checkout 命令创建分支
--------------------------------

用户 user2 要完成本地化的工作任务，那么分支名可以定为 `user2/i18n` 。每一次创建分支通常都要完成以下两个工作：

1. 执行 `git branch <branchname>` 命令创建新分支。
2. 执行 `git checkout <branchname>` 命令切换到新分支。

为了简化操作， Git 还提供了更为简练易用的命令，将上述两条命令要执行的动作一次完成。用法如下：

::

  用法： git checkout -b <new_branch> [<start_point>]

即使用 `-b` 参数执行 `git checkout` 命令，实现了分支创建和切换两个动作的合二为一。下面就在 user2 的工作区试着执行一下。

* 切换到 user2 的工作目录，并和上游同步一次。

  ::

    $ cd /path/to/user2/workspace/hello-world/
    $ git pull
    remote: Counting objects: 1, done.
    remote: Total 1 (delta 0), reused 0 (delta 0)
    Unpacking objects: 100% (1/1), done.
    From file:///path/to/repos/hello-world
     * [new tag]         v1.0       -> v1.0
    Already up-to-date.

* 执行 `git checkout -b` 命令，创建并切换到 `user2/i18n` 分支上。

  ::

    $ git checkout -b user2/i18n
    Switched to a new branch 'user2/i18n'

* 查看本地分支列表，会看到已经切换到 `user2/i18n` 分支上了。

  ::

    $ git branch
      master
    * user2/i18n

为 `hello-world` 添加本地化支持比较复杂，需要多花些时间，因此在稍后才能完成。

创建发布分支
============

测试部门终于发现了并报告了 `hello-world` v1.0 版本的两个问题：

* 帮助信息中出现文字错误。本应该写为 "--help" 却写成了 "-help"。

* 当执行 `hello-world` 的程序，提供带空格的用户名时，问候语中显示的是不完整的用户名。

  例如执行 "`./hello Jiang Xin`"，本应该输出 "`Hi, Jiang Xin.`"，却只输出了 "`Hi, Jiang.`"。

还是将这两个 Bug 修正工作交给开发者 user1 和 user2 。最终确定：

* 需要从 v1.0 版本创建一个分支，定名为 `hello-1.x` 。
* 用户 user1 负责修改文字错误的 Bug。
* 用户 user2 负责修改显示用户名不完整的 bug。

那么就开始吧。

* 首先由用户 user1 创建分支 `hello-1.x` 。

  ::

    $ cd /path/to/user1/workspace/hello-world/
    $ git checkout -b hello-1.x v1.0
    Switched to a new branch 'hello-1.x'

* 用户 user1 将分支 `hello-1.x` 推送到远程共享版本库。

  ::

    $ git push origin hello-1.x
    Total 0 (delta 0), reused 0 (delta 0)
    To file:///path/to/repos/hello-world.git
     * [new branch]      hello-1.x -> hello-1.x

* 用户 user2 从远程服务器获取新的分支。

  远程共享版本库的新分支 `hello-1.x` 复制到本地引用 `origin/hello-1.x` 。

  ::

    $ cd /path/to/user2/workspace/hello-world/
    $ git fetch
    From file:///path/to/repos/hello-world
     * [new branch]      hello-1.x  -> origin/hello-1.x

* 用户 user2 切换到 hello-1.x 分支。

  实际上在本地创建了一个跟踪远程 hello-1.x 分支的本地分支。

  ::

    $ git checkout hello-1.x
    Branch hello-1.x set up to track remote branch hello-1.x from origin.
    Switched to a new branch 'hello-1.x'

* 用户 user1 修改帮助信息中的错误。

  用户 user1 的改动可以从下面的差异比较中看到。

  ::

    $ cd /path/to/user1/workspace/hello-world/
    $ vi src/main.c
    ...

    $ git diff
    diff --git a/src/main.c b/src/main.c
    index 6ee936f..e76f05e 100644
    --- a/src/main.c
    +++ b/src/main.c
    @@ -11,7 +11,7 @@ int usage(int code)
                "            say hello to the world.\n\n"
                "    hello <username>\n"
                "            say hi to the user.\n\n"
    -           "    hello -h, -help\n"
    +           "    hello -h, --help\n"
                "            this help screen.\n\n", _VERSION);
         return code;
     }
        
* 用户 user1 提交并推送到远程共享版本库。

  ::

    $ git add -u
    $ git commit -m "Fix typo: -help to --help."
    [hello-1.x b56bb51] Fix typo: -help to --help.
     1 files changed, 1 insertions(+), 1 deletions(-)
    $ git push
    Counting objects: 7, done.
    Delta compression using up to 2 threads.
    Compressing objects: 100% (4/4), done.
    Writing objects: 100% (4/4), 349 bytes, done.
    Total 4 (delta 3), reused 0 (delta 0)
    Unpacking objects: 100% (4/4), done.
    To file:///path/to/repos/hello-world.git
       ebcf6d6..b56bb51  hello-1.x -> hello-1.x

* 用户 user2 修改问候用户名显示不全的 Bug。

  ::

    $ cd /path/to/user1/workspace/hello-world/
    $ vi src/main.c
    ...

    $ git format-patch jx/v1.1..jx/v1.2 
    0001-Bugfix-allow-spaces-in-username.patch

    $ git diff
    diff --git a/src/main.c b/src/main.c
    index 6ee936f..f0f404b 100644
    --- a/src/main.c
    +++ b/src/main.c
    @@ -19,13 +19,20 @@ int usage(int code)
     int
     main(int argc, char **argv)
     {
    +    char **p = NULL;
    +
         if (argc == 1) {
             printf ("Hello world.\n");
         } else if ( strcmp(argv[1],"-h") == 0 ||
                     strcmp(argv[1],"--help") == 0 ) {
                     return usage(0);
         } else {
    -        printf ("Hi, %s.\n", argv[1]);
    +        p = &argv[1];
    +        printf ("Hi,");
    +        do {
    +            printf (" %s", *p);
    +        } while (*(++p));
    +        printf (".\n");
         }
     
         printf( "(version: %s)\n", _VERSION );


    $ cd src/
    $ make
    version.h.in => version.h
    cc    -c -o main.o main.c
    cc -o hello main.o
    $ ./hello Jiang Xin
    Hi, Jiang Xin.
    (version: v1.0-dirty)


    $ git commit -m "Bugfix: allow spaces in username."
    [user2/i18n 93bb097] Bugfix: allow spaces in username.
     1 files changed, 8 insertions(+), 1 deletions(-)

分支的变基
==========


分支管理规范
============



