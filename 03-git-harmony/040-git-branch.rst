Git分支
********

分支是我们的老朋友了，第2篇中的“第6章 Git对象库”、“第7章 Git重置”和“第8\
章 Git检出”等章节中，就已经从实现原理上理解了分支。您想必已经知道了分支\
``master``\ 的存在方式无非就是在目录\ :file:`.git/refs/heads`\ 下的文件\
（或称引用）而已。也看到了分支\ ``master``\ 的指向如何随着提交而变化，\
如何通过\ :command:`git reset`\ 命令而重置，以及如何使用\
:command:`git checkout`\ 命令而检出。

之前的章节都只用到了一个分支：\ ``master``\ 分支，而在本章会接触到多个分支。\
会从应用的角度上介绍分支的几种不同类型：发布分支、特性分支和卖主分支。\
在本章可以学习到如何对多分支进行操作，如何创建分支，如何切换到其他分支，\
以及分支之间的合并、变基等。

代码管理之殇
============

分支是代码管理的利器。如果没有有效的分支管理，代码管理就适应不了复杂的开\
发过程和项目的需要。在实际的项目实践中，单一分支的单线开发模式还远远不够，\
因为：

* 成功的软件项目大多要经过多个开发周期，发布多个软件版本。每个已经发布的\
  版本都可能发现bug，这就需要对历史版本进行更改。

* 有前瞻性的项目管理，新版本的开发往往是和当前版本同步进行的。如果两个版\
  本的开发都混杂在master分支中，肯定会是一场灾难。

* 如果产品要针对不同的客户定制，肯定是希望客户越多越好。如果所有的客户定\
  制都混杂在一个分支中，必定会带来混乱。如果使用多个分支管理不同的定制，\
  但如果管理不善，分支之间定制功能的迁移就会成为头痛的问题。

* 即便是所有成员都在为同一个项目的同一个版本进行工作，每个人领受任务却不\
  尽相同，有的任务开发周期会很长，有的任务需要对软件架构进行较大的修改，\
  如果所有人都工作在同一分支中，就会因为过多过频的冲突导致效率低下。

* 敏捷开发（不管是极限编程XP还是Scrum或其他）是最有效的项目管理模式，其\
  最有效的一个实践就是快速迭代、每晚编译。如果不能将项目的各个功能模块的\
  开发通过分支进行隔离，在软件集成上就会遭遇困难。

发布分支
--------

**为什么bug没完没了？**

在2006年我接触到一个项目团队，使用Subversion做版本控制。最为困扰项目经理\
的是刚刚修正产品的一个bug，马上又会接二连三地发现新的bug。在访谈开发人员，\
询问开发人员是如何修正bug的时候，开发人员的回答让我大吃一惊：“当发现产品\
出现bug的时候，我要中断当前的工作，把我正在开发的新功能的代码注释掉，\
然后再去修改bug，修改好就生成一个war包（Java开发网站项目）给运维部门，\
扔到网站上去。”

于是我就画了下面的一个图（图18-1），大致描述了这个团队进行bug修正的过程，\
从中可以很容易地看出问题的端倪。这个图对于Git甚至其他版本库控制系统同样适用。

.. figure:: /images/git-harmony/branch-release-branch-question.png
   :scale: 80

   图 18-1：没有使用分支导致越改越多的bug


说明：

* 图18-1中的图示①，开发者针对功能1做了一个提交，编号“F1.1”。这时客户报告\
  产品出现了bug。

* 于是开发者匆忙地干了起来，图示②显示了该开发者修正bug的过程：将已经提交\
  的针对功能1的代码“F1.1”注释掉，然后提交一个修正bug的提交（编号：fix1）。

* 开发者编译出新的产品交给客户，接着开始功能1的开发。图示③显示了开发者针\
  对功能1做出了一个新的提交“F1.2”。

* 客户再次发现一个bug。开发者再次开始bug修正工作。

* 图示④和图示⑤显示了此工作模式下非常容易在修复一个bug的时候引入新的bug。

* 图示④的问题在于开发者注释功能1的代码时，不小心将“fix1”的代码也注释掉了，\
  导致曾经修复的bug在新版本中重现。

* 图示⑤的问题在于开发者没有将功能1的代码剔出干净，导致在产品的新版本中引\
  入了不完整和不需要的功能代码。用户可能看到一个新的但是不能使用的菜单项，\
  甚至更糟。

使用版本控制系统的分支功能，可以避免对已发布的软件版本进行bug修正时引入\
新功能的代码，或者因误删其他bug修正代码导致已修复问题重现。在这种情况下\
创建的分支有一个专有的名称：bugfix分支或发布分支（Release Branch）。之所\
以称为发布分支，是因为在软件新版本发布后经常使用此技术进行软件维护，发布\
升级版本。

图18-2演示了如何使用发布分支应对bug修正的问题。

.. figure:: /images/git-harmony/branch-release-branch-answer.png
   :scale: 80

   图 18-2：使用发布分支的bug修正过程

说明：

* 图18-2中的图示②，可以看到开发者创建了一个发布分支（bugfix分支），在分支\
  中提交修正代码“fix1”。注意此分支是自上次软件发布时最后一次提交进行创建\
  的，因此分支中没有包含开发者为新功能所做的提交“F1.1”，是一个“干净”的分支。

* 图示③可以看出从发布分支向主线做了一次合并，这是因为在主线上也同样存在\
  该bug，需要在主线上也做出相应的更改。

* 图示④，开发者继续开发，针对功能1执行了一个新的提交，编号“F1.2”。这时，\
  客户报告有新的bug。

* 继续在发布分支上进行bug修正，参考图示⑤。当修正完成（提交“fix2”）时，基\
  于发布分支创建一个新的软件版本发给客户。不要忘了向主线合并，因为同样的\
  bug可能在主线上也存在。

关于如何基于一个历史提交创建分支，以及如何在分支之间进行合并，在本章后面\
的内容中会详细介绍。

特性分支
--------

**为什么项目一再的拖延？**

有这么一个软件项目，项目已经延期了可是还是看不到一点要完成的样子。最终老\
板变得有些不耐烦了，说道：“那么就砍掉一些功能吧”。项目经理听闻，一阵眩晕，\
因为项目经理知道自己负责的这个项目采用的是单一主线开发，要将一个功能从\
中撤销，工作量非常大，而且可能会牵涉到其他相关模块的变更。

图18-3就是这个项目的版本库示意图，显然这个项目的代码管理没有使用分支。

.. figure:: /images/git-harmony/branch-feature-branch-question.png
   :scale: 100

   图 18-3：没有使用分支导致项目拖延

说明：

* 图18-3中的图示①，用圆圈代表功能1的历次提交，用三角代替功能2的历次提交。\
  因为所有开发者都在主线上工作，所以提交混杂在一起。

* 当老板决定功能2不在这一版本的产品中发布，延期到下一个版本时，功能2的开\
  发者做了一个（或者若干个）反向提交，即图示②中的倒三角（代号为“F2.X”）\
  标识的反向提交，将功能2的所有历史提交全部撤销。

* 图示③表示除了功能2外的其他开发继续进行。

那么负责开发功能2的开发者干什么呢？或者放一个长假，或者在本地开发，与版\
本库隔离，即不向版本库提交，直到延期的项目终于发布之后再将代码提交。这两\
种方法都是不可取的，尤其是后一种隔离开发最危险，如果因为病毒感染、文件误\
删、磁盘损坏，就会导致全部工作损失殆尽。我的项目组就曾经遇到过这样的情况。

采用分支将某个功能或模块的开发与开发主线独立出来，是解决类似问题的办法，\
这种用途的分支被称为特性分支（Feature Branch）或主题分支（Topic Branch）。\
图18-4就展示了如何使用特性分支帮助纠正要延期的项目，协同多用户的开发。

.. figure:: /images/git-harmony/branch-feature-branch-answer.png
   :scale: 100

   图 18-4：使用特性分支协同多功能开发

说明：

* 图18-4中的图示①和前面的一样，都是多个开发者的提交混杂在开发主线中。

* 图示②是当得知功能2不在此次产品发布中后，功能2的开发者所做的操作。

* 首先，功能2的开发者提交一个（或若干个）反向提交，将功能2的相关代码全部\
  撤销。图中倒三角（代号为“F2.X”）的提交就是一个反向提交。

* 接着，功能2的开发者从反向提交开始创建一个特性分支。

* 最后，功能2的开发者将功能2的历史提交拣选到特性分支上。对于Git可以使用\
  拣选命令\ :command:`git cherry-pick`\ 。

* 图示③中可以看出包括功能2在内的所有功能和模块都继续提交，但是提交的分支\
  各不相同。功能2的开发者将代码提交到特性分支上，其他开发者还提交到主线上。

那么在什么情况下使用特性分支呢？试验性、探索性的功能开发应该为其建立特性\
分支。功能复杂、开发周期长（有可能在本次发布中取消）的模块应该为其建立特\
性分支。会更改软件体系架构，破坏软件集成，或者容易导致冲突、影响他人开发\
进度的模块，应该为其建立特性分支。

在使用CVS或Subversion等版本控制系统建立分支时，或者因为太慢（CVS）或者因\
为授权原因需要找管理员进行操作，非常的不方便。Git的分支管理就方便多了，\
一是开发者可以在本地版本库中随心所欲地创建分支，二是管理员可以对共享版本\
库进行设置允许开发者创建特定名称的分支，这样开发者的本地分支可以推送到服\
务器实现数据的备份。关于Git服务器的分支授权参照本书第5篇的Gitolite服务器\
架设的相关章节。

卖主分支
--------

有的项目要引用到第三方的代码模块并且需要对其进行定制，有的项目甚至整个就\
是基于某个开源项目进行的定制。如何有效地管理本地定制和第三方（上游）代码\
的变更就成为了一个难题。卖主分支（Vendor Branch）可以部分解决这个难题。

所谓卖主分支，就是在版本库中创建一个专门和上游代码进行同步的分支，一旦有\
上游代码发布就检入到卖主分支中。图18-5就是一个典型的卖主分支工作流程。

.. figure:: /images/git-harmony/branch-vendor-branch.png
   :scale: 100

   图 18-5：卖主分支工作流程
     
说明：

* 在主线检入上游软件版本1.0的代码。在图中标记为\ ``v1.0``\ 的提交即是。

* 然后在主线上进行定制开发，c1、c2分别代表历次定制提交。

* 当上游有了新版本发布，例如2.0版本，就将上游新版本的源代码提交到卖主分\
  支中。图中标记为\ ``v2.0``\ 的提交即是。

* 然后在主线上合并卖主分支上的新提交，合并后的提交显示为\ ``M1``\ 。

如果定制较少，使用卖主分支可以工作得很好，但是如果定制的内容非常多，在合\
并的时候就会遇到非常多的冲突。定制的代码越多，混杂的越厉害，冲突解决就越\
困难。

本章的内容尚不能针对复杂的定制开发给出满意的版本控制解决方案，本书第4篇\
的“第22章 Topgit协同模型”会介绍一个针对复杂定制开发的更好的解决方案。

分支命令概述
============

在Git中分支管理使用命令\ :command:`git branch`\ 。该命令的主要用法如下：

::

  用法1： git branch
  用法2： git branch <branchname>
  用法3： git branch <branchname> <start-point>
  用法4： git branch -d <branchname>
  用法5： git branch -D <branchname>
  用法6： git branch -m <oldbranch> <newbranch>
  用法7： git branch -M <oldbranch> <newbranch>

说明：

* 用法1用于显示本地分支列表。当前分支在输出中会显示为特别的颜色，并用星\
  号 “*” 标识出来。

* 用法2和用法3用于创建分支。

  用法2基于当前头指针（HEAD）指向的提交创建分支，新分支的分支名为\
  ``<branchname>``\ 。

  用法3基于提交\ ``<start-point>``\ 创建新分支，新分支的分支名为\
  ``<branchname>``\ 。

* 用法4和用法5用于删除分支。

  用法4在删除分支\ ``<branchname>``\ 时会检查所要删除的分支是否已经合并\
  到其他分支中，否则拒绝删除。

  用法5会强制删除分支\ ``<branchname>``\ ，即使该分支没有合并到任何一个分支中。

* 用法6和用法7用于重命名分支。

  如果版本库中已经存在名为\ ``<newbranch>``\ 的分支，用法6拒绝执行重命名，\
  而用法7会强制执行。

下面就通过\ ``hello-world``\ 项目演示Git的分支管理。

Hello World开发计划
====================

上一章从Github上检出的\ ``hello-world``\ 包含了一个C语言开发的应用，现在\
假设项目\ ``hello-world``\ 做产品发布，版本号定为1.0，则进行下面的里程碑\
操作。

* 为\ ``hello-world``\ 创建里程碑\ ``v1.0``\ 。

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

到现在为止还没有运行\ ``hello-world``\ 程序呢，现在就在开发者user1的工作\
区中运行一下。

* 进入\ :file:`src`\ 目录，编译程序。

  ::

    $ cd src
    $ make
    version.h.in => version.h
    cc    -c -o main.o main.c
    cc -o hello main.o

* 使用参数\ ``--help``\ 运行\ ``hello``\ 程序，可以查看帮助信息。

  说明：hello程序的帮助输出中有一个拼写错误，本应该是\ ``--help``\ 的\
  地方写成了\ ``-help``\ 。这是有意为之。

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

  说明：最后一行显示版本为“v1.0”，这显然是来自于新建立的里程碑“v1.0”。

  ::

    $ ./hello
    Hello world.
    (version: v1.0)

* 执行命令的时候，后面添加用户名作为参数，则向该用户问候。

  说明：下面在运行\ ``hello``\ 的时候，显然出现了一个bug，即用户名中间如果\
  出现了空格，输出的欢迎信息只包含了部分的用户名。这个bug也是有意为之。

  ::

    $ ./hello Jiang Xin
    Hi, Jiang.
    (version: v1.0)

**新版本开发计划**

既然1.0版本已经发布了，现在是时候制订下一个版本2.0的开发计划了。计划如下：

* 多语种支持。

  为\ ``hello-world``\ 添加多语种支持，使得软件运行的时候能够使用中文\
  或其他本地化语言进行问候。

* 用getopt进行命令行解析。

  对命令行参数解析框架进行改造，以便实现更灵活、更易扩展的命令行处理。\
  在1.0版本中，程序内部解析命令行参数使用了简单的字符串比较，非常不灵活。\
  从源文件\ :file:`src/main.c`\ 中可以看到当前实现的简陋和局限。

  ::

    $ git grep -n argv
    main.c:20:main(int argc, char **argv)
    main.c:24:    } else if ( strcmp(argv[1],"-h") == 0 ||
    main.c:25:                strcmp(argv[1],"--help") == 0 ) {
    main.c:28:        printf ("Hi, %s.\n", argv[1]);

最终决定由开发者user2负责多语种支持的功能，由开发者user1负责用getopt进行\
命令行解析的功能。

基于特性分支的开发
==================

有了前面“代码管理之殇”的铺垫，在领受任务之后，开发者user1和user2应该为自\
己负责的功能创建特性分支。

创建分支\ ``user1/getopt``
----------------------------

开发者user1负责用getopt进行命令行解析的功能，因为这个功能用到\ ``getopt``\
函数，于是将这个分支命名为\ ``user1/getopt``\ 。开发者 user1 使用\
:command:`git branch`\ 命令创建该特性分支。

* 确保是在开发者user1的工作区中。

  ::

    $ cd /path/to/user1/workspace/hello-world/

* 开发者user1基于当前HEAD创建分支\ ``user1/getopt``\ 。

  ::

    $ git branch user1/getopt


* 使用\ :command:`git branch`\ 创建分支，并不会自动切换。查看当前分支\
  可以看到仍然工作在\ ``master``\ 分支（用星号 “*” 标识）中。

  ::

    $ git branch
    * master
      user1/getopt

* 执行\ :command:`git checkout`\ 命令切换到新分支上。

  ::

    $ git checkout user1/getopt
    Switched to branch 'user1/getopt'

* 再次查看分支列表，当前工作分支的标记符（星号）已经落在\
  ``user1/getopt``\ 分支上。

  ::

    $ git branch
      master
    * user1/getopt

**分支的奥秘**

分支实际上是创建在目录\ :file:`.git/refs/heads`\ 下的引用，版本库初始时\
创建的\ ``master``\ 分支就是在该目录下。在第2篇“Git重置”的章节中，已经\
介绍过master分支的实现，实际上这也是所有分支的实现方式。

* 查看一下目录\ :file:`.git/refs/heads`\ 目录下的引用。

  可以在该目录下看到\ :file:`master`\ 文件，和一个\ :file:`user1`\ 目录。\
  而在\ :file:`user1`\ 目录下是文件\ :file:`getopt`\ 。

  ::

    $ ls -F .git/refs/heads/
    master  user1/
    $ ls -F .git/refs/heads/user1/
    getopt

* 引用文件\ :file:`.git/refs/heads/user1/getopt`\ 记录的是一个提交ID。

  ::

    $ cat .git/refs/heads/user1/getopt 
    ebcf6d6b06545331df156687ca2940800a3c599d

* 因为分支\ ``user1/getopt``\ 是基于头指针HEAD创建的，因此当前该分支和\
  ``master``\ 分支指向是一致的。

  ::

    $ cat .git/refs/heads/master 
    ebcf6d6b06545331df156687ca2940800a3c599d

* 当前的工作分支为\ ``user1/getopt``\ ，记录在头指针文件\
  :file:`.git/HEAD`\ 中。

  切换分支命令\ :command:`git checkout`\ 对文件\ :file:`.git/HEAD`\
  的内容进行更新。可以参照第2篇“第8章 Git检出”的相关章节。

  ::

    $ cat .git/HEAD 
    ref: refs/heads/user1/getopt

创建分支\ ``user2/i18n``
--------------------------------

开发者user2要完成多语种支持的工作任务，于是决定将分支定名为\ ``user2/i18n``\ 。\
每一次创建分支通常都需要完成以下两个工作：

1. 创建分支：执行\ :command:`git branch <branchname>`\ 命令创建新分支。
2. 切换分支：执行\ :command:`git checkout <branchname>`\ 命令切换到新分支。

有没有简单的操作，在创建分支后立即切换到新分支上呢？有的，Git提供了这样\
一个命令，能够将上述两条命令所执行的操作一次性完成。用法如下：

::

  用法： git checkout -b <new_branch> [<start_point>]

即检出命令\ :command:`git checkout`\ 通过参数\ ``-b <new_branch>``\ 实现\
了创建分支和切换分支两个动作的合二为一。下面开发者user2就使用\
:command:`git checkout`\ 命令来创建分支。

* 进入到开发者user2的工作目录，并和上游同步一次。

  ::

    $ cd /path/to/user2/workspace/hello-world/
    $ git pull
    remote: Counting objects: 1, done.
    remote: Total 1 (delta 0), reused 0 (delta 0)
    Unpacking objects: 100% (1/1), done.
    From file:///path/to/repos/hello-world
     * [new tag]         v1.0       -> v1.0
    Already up-to-date.

* 执行\ :command:`git checkout -b`\ 命令，创建并切换到新分支\
  ``user2/i18n``\ 上。

  ::

    $ git checkout -b user2/i18n
    Switched to a new branch 'user2/i18n'

* 查看本地分支列表，会看到已经切换到\ ``user2/i18n``\ 分支上了。

  ::

    $ git branch
      master
    * user2/i18n

开发者 user1 完成功能开发
--------------------------

开发者user1开始在\ ``user1/getopt``\ 分支中工作，重构\ ``hello-world``\
中的命令行参数解析的代码。重构时采用\ ``getopt_long``\ 函数。

您可以试着更改，不过在\ ``hello-world``\ 中已经保存了一份改好的代码，\
可以直接检出。

* 确保是在user1的工作区中。

  ::

    $ cd /path/to/user1/workspace/hello-world/

* 执行下面的命令，用里程碑\ ``jx/v2.0``\ 标记的内容（已实现用getopt进行\
  命令行解析的功能）替换暂存区和工作区。

  下面的\ :command:`git checkout`\ 命令的最后是一个点“.”，因此检出只更改\
  了暂存区和工作区，而没有修改头指针。

  ::

    $ cd /path/to/user1/workspace/hello-world/
    $ git checkout jx/v2.0 -- .


* 查看状态，会看到分支仍保持为\ ``user1/getopt``\ ，但文件\
  :file:`src/main.c`\ 被修改了。

  ::

    $ git status 
    # On branch user1/getopt
    # Changes to be committed:
    #   (use "git reset HEAD <file>..." to unstage)
    #
    #       modified:   src/main.c
    #

* 比较暂存区和HEAD的文件差异，可以看到为实现用getopt进行命令行解析功能而\
  对代码的改动。

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

* 开发者user1提交代码，完成开发任务。

  ::

    $ git commit -m "Refactor: use getopt_long for arguments parsing."
    [user1/getopt 0881ca3] Refactor: use getopt_long for arguments parsing.
     1 files changed, 36 insertions(+), 5 deletions(-)

* 提交完成之后，可以看到这时\ ``user1/getopt``\ 分支和\ ``master``\ 分支\
  的指向不同了。

  ::

    $ git rev-parse user1/getopt master
    0881ca3f62ddadcddec08bd9f2f529a44d17cfbf
    ebcf6d6b06545331df156687ca2940800a3c599d

* 编译运行\ ``hello-world``\ 。

  注意输出中的版本号显示。

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

将\ ``user1/getopt``\ 分支合并到主线
-----------------------------------------

既然开发者user1负责的功能开发完成了，那就合并到开发主线\ ``master``\ 上\
吧，这样测试团队（如果有的话）就可以基于开发主线\ ``master``\ 进行软件集\
成和测试了。

* 为将分支合并到主线，首先user1将工作区切换到主线，即\ ``master``\ 分支。

  ::

    $ git checkout master
    Switched to branch 'master'

* 然后执行\ :command:`git merge`\ 命令以合并\ ``user1/getopt``\ 分支。

  ::

    $ git merge user1/getopt
    Updating ebcf6d6..0881ca3
    Fast-forward
     src/main.c |   41 ++++++++++++++++++++++++++++++++++++-----
     1 files changed, 36 insertions(+), 5 deletions(-)

* 本次合并非常的顺利，实际上合并后\ ``master``\ 分支和\ ``user1/getopt``\
  指向同一个提交。

  这是因为合并前的\ ``master``\ 分支的提交就是\ ``usr1/getopt``\ 分支的\
  父提交，所以此次合并相当于分支\ ``master``\ 重置到\ ``user1/getopt``\
  分支。

  ::

    $ git rev-parse user1/getopt master
    0881ca3f62ddadcddec08bd9f2f529a44d17cfbf
    0881ca3f62ddadcddec08bd9f2f529a44d17cfbf

* 当前本地\ ``master``\ 分支比远程共享版本库的\ ``master``\ 分支领先一个提交。

  可以从状态信息中看到本地分支和远程分支的跟踪关系。

  ::

    $ git status
    # On branch master
    # Your branch is ahead of 'origin/master' by 1 commit.
    #
    nothing to commit (working directory clean)

* 执行推送操作，完成本地分支向远程分支的同步。

  ::

    $ git push
    Counting objects: 7, done.
    Delta compression using up to 2 threads.
    Compressing objects: 100% (4/4), done.
    Writing objects: 100% (4/4), 689 bytes, done.
    Total 4 (delta 3), reused 0 (delta 0)
    Unpacking objects: 100% (4/4), done.
    To file:///path/to/repos/hello-world.git
       ebcf6d6..0881ca3  master -> master

* 删除\ ``user1/getopt``\ 分支。

  既然特性分支\ ``user1/getopt``\ 已经合并到主线上了，那么该分支已经完成\
  了历史使命，可以放心地将其删除。

  ::

    $ git branch -d user1/getopt
    Deleted branch user1/getopt (was 0881ca3).


开发者user2对多语种支持功能有些犯愁，需要多花些时间，那么就先不等他了。

基于发布分支的开发
==================

用户在使用1.0版的\ ``hello-word``\ 过程中发现了两个错误，报告给项目组。

* 第一个问题是：帮助信息中出现文字错误。本应该写为“--help”却写成了“-help”。

* 第二个问题是：当执行\ ``hello-world``\ 的程序，提供带空格的用户名时，\
  问候语中显示的是不完整的用户名。

  例如执行\ :command:`./hello Jiang Xin`\ ，本应该输出“\ ``Hi, Jiang Xin.``\ ”，\
  却只输出了“\ ``Hi, Jiang.``\ ”。

为了能够及时修正1.0版本中存在的这两个bug，将这两个bug的修正工作分别交给\
两个开发者user1和user2完成。

* 开发者user1负责修改文字错误的bug。
* 开发者user2负责修改显示用户名不完整的bug。

现在版本库中\ ``master``\ 分支相比1.0发布时添加了新功能代码，即开发者\
user1推送的用getopt进行命令行解析相关代码。如果基于\ ``master``\ 分支对\
用户报告的两个bug进行修改，就会引入尚未经过测试、可能不稳定的新功能的代码。\
在之前“代码管理之殇”中介绍的发布分支，恰恰适用于此场景。

创建发布分支
-------------

要想解决在1.0版本中发现的bug，就需要基于1.0发行版的代码创建发布分支。

* 软件\ ``hello-world``\ 的1.0发布版在版本库中有一个里程碑相对应。

  ::

    $ cd /path/to/user1/workspace/hello-world/
    $ git tag -n1 -l v*
    v1.0            Release 1.0

* 基于里程碑\ ``v1.0``\ 创建发布分支\ ``hello-1.x``\ 。

  注：使用了\ :command:`git checkout`\ 命令创建分支，最后一个参数\
  ``v1.0``\ 是新分支\ ``hello-1.x``\ 创建的基准点。如果没有里程碑，\
  使用提交ID也是一样。

  ::

    $ git checkout -b hello-1.x v1.0
    Switched to a new branch 'hello-1.x'

* 用\ :command:`git rev-parse`\ 命令可以看到\ ``hello-1.x``\ 分支对应的\
  提交ID和里程碑\ ``v1.0``\ 指向的提交一致，但是和\ ``master``\ 不一样。

  提示：因为里程碑v1.0是一个包含提交说明的里程碑，因此为了显示其对应的\
  提交ID，使用了特别的记法“\ ``v1.0^{}``\ ”。

  ::

    $ git rev-parse hello-1.x v1.0^{} master
    ebcf6d6b06545331df156687ca2940800a3c599d
    ebcf6d6b06545331df156687ca2940800a3c599d
    0881ca3f62ddadcddec08bd9f2f529a44d17cfbf

* 开发者user1将分支\ ``hello-1.x``\ 推送到远程共享版本库，因为开发者\
  user2修改bug时也要用到该分支。

  ::

    $ git push origin hello-1.x
    Total 0 (delta 0), reused 0 (delta 0)
    To file:///path/to/repos/hello-world.git
     * [new branch]      hello-1.x -> hello-1.x

* 开发者user2从远程共享版本库获取新的分支。

  开发者user2执行\ :command:`git fetch`\ 命令，将远程共享版本库的新分支\
  ``hello-1.x``\ 复制到本地引用\ ``origin/hello-1.x``\ 上。

  ::

    $ cd /path/to/user2/workspace/hello-world/
    $ git fetch
    From file:///path/to/repos/hello-world
     * [new branch]      hello-1.x  -> origin/hello-1.x

* 开发者user2切换到\ ``hello-1.x``\ 分支。

  本地引用\ ``origin/hello-1.x``\ 称为远程分支，第19章将专题介绍。该远程\
  分支不能直接检出，而是需要基于该远程分支创建本地分支。第19章会介绍一个\
  更为简单的基于远程分支建立本地分支的方法，本例先用标准的方法建立分支。

  ::

    $ git checkout -b hello-1.x origin/hello-1.x
    Branch hello-1.x set up to track remote branch hello-1.x from origin.
    Switched to a new branch 'hello-1.x'

开发者user1工作在发布分支
---------------------------

开发者user1修改帮助信息中的文字错误。

* 编辑文件\ :file:`src/main.c`\ ，将“-help”字符串修改为“--help”。

  ::

    $ cd /path/to/user1/workspace/hello-world/
    $ vi src/main.c
    ...

* 开发者user1的改动可以从下面的差异比较中看到。

  ::

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
        
* 执行提交。

  ::

    $ git add -u
    $ git commit -m "Fix typo: -help to --help."
    [hello-1.x b56bb51] Fix typo: -help to --help.
     1 files changed, 1 insertions(+), 1 deletions(-)

* 推送到远程共享版本库。

  ::

    $ git push
    Counting objects: 7, done.
    Delta compression using up to 2 threads.
    Compressing objects: 100% (4/4), done.
    Writing objects: 100% (4/4), 349 bytes, done.
    Total 4 (delta 3), reused 0 (delta 0)
    Unpacking objects: 100% (4/4), done.
    To file:///path/to/repos/hello-world.git
       ebcf6d6..b56bb51  hello-1.x -> hello-1.x

开发者user2工作在发布分支
---------------------------

开发者user2针对问候时用户名显示不全的bug进行更改。

* 进入开发者user2的工作区，并确保工作在\ ``hello-1.x``\ 分支中。

  ::

    $ cd /path/to/user2/workspace/hello-world/
    $ git checkout hello-1.x

* 编辑文件\ :file:`src/main.c`\ ，修改代码中的bug。

  ::

    $ vi src/main.c

* 实际上在\ ``hello-world``\ 版本库中包含了我的一份修改，可以看看和您的\
  更改是否一致。

  下面的命令将我对此bug的修改保存为一个补丁文件。

  ::

    $ git format-patch jx/v1.1..jx/v1.2 
    0001-Bugfix-allow-spaces-in-username.patch

* 应用我对此bug的改动补丁。

  如果您已经自己完成了修改，可以先执行\ :command:`git stash`\ 保存自己的\
  修改进度，然后执行下面的命令应用补丁文件。当应用完补丁后，再执行\
  :command:`git stash pop`\ 将您的改动合并到工作区。如果我们的改动一致\
  （英雄所见略同），将不会有冲突。

  ::

    $ patch -p1 < 0001-Bugfix-allow-spaces-in-username.patch
    patching file src/main.c

* 看看代码的改动吧。

  ::

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

* 本地测试一下改进后的软件，看看bug是否已经被改正。如果运行结果能显示出\
  完整的用户名，则bug成功修正。

  ::

    $ cd src/
    $ make
    version.h.in => version.h
    cc    -c -o main.o main.c
    cc -o hello main.o
    $ ./hello Jiang Xin
    Hi, Jiang Xin.
    (version: v1.0-dirty)

* 提交代码。

  ::

    $ git add -u
    $ git commit -m "Bugfix: allow spaces in username."
    [hello-1.x e64f3a2] Bugfix: allow spaces in username.
     1 files changed, 8 insertions(+), 1 deletions(-)

开发者user2合并推送
---------------------------

开发者user2在本地版本库完成提交后，不要忘记向远程共享版本库进行推送。但\
在推送分支\ ``hello-1.x``\ 时开发者user2没有开发者user1那么幸运，因为此\
时远程共享版本库的\ ``hello-1.x``\ 分支已经被开发者user1推送过一次，因此\
开发者user2在推送过程中会遇到非快进式推送问题。

::

  $ git push
  To file:///path/to/repos/hello-world.git
   ! [rejected]        hello-1.x -> hello-1.x (non-fast-forward)
  error: failed to push some refs to 'file:///path/to/repos/hello-world.git'
  To prevent you from losing history, non-fast-forward updates were rejected
  Merge the remote changes (e.g. 'git pull') before pushing again.  See the
  'Note about fast-forwards' section of 'git push --help' for details.

就像在“第15章 Git协议和工作协同”一章中介绍的那样，开发者user2需要执行一\
个拉回操作，将远程共享服务器的改动获取到本地并和本地提交进行合并。

::

  $ git pull
  remote: Counting objects: 7, done.
  remote: Compressing objects: 100% (4/4), done.
  remote: Total 4 (delta 3), reused 0 (delta 0)
  Unpacking objects: 100% (4/4), done.
  From file:///path/to/repos/hello-world
     ebcf6d6..b56bb51  hello-1.x  -> origin/hello-1.x
  Auto-merging src/main.c
  Merge made by recursive.
   src/main.c |    2 +-
   1 files changed, 1 insertions(+), 1 deletions(-)

通过显示分支图的方式查看日志，可以看到在执行\ :command:`git pull`\ 操作\
后发生了合并。

::

  $ git log --graph --oneline
  *   8cffe5f Merge branch 'hello-1.x' of file:///path/to/repos/hello-world into hello-1.x
  |\  
  | * b56bb51 Fix typo: -help to --help.
  * | e64f3a2 Bugfix: allow spaces in username.
  |/  
  * ebcf6d6 blank commit for GnuPG-signed tag test.
  * 8a9f3d1 blank commit for annotated tag test.
  * 60a2f4f blank commit.
  * 3e6070e Show version.
  * 75346b3 Hello world initialized.

现在开发者user2可以将合并后的本地版本库中的提交推送给远程共享版本库了。

::

  $ git push
  Counting objects: 14, done.
  Delta compression using up to 2 threads.
  Compressing objects: 100% (8/8), done.
  Writing objects: 100% (8/8), 814 bytes, done.
  Total 8 (delta 6), reused 0 (delta 0)
  Unpacking objects: 100% (8/8), done.
  To file:///path/to/repos/hello-world.git
     b56bb51..8cffe5f  hello-1.x -> hello-1.x

发布分支的提交合并到主线
----------------------------

当开发者user1和user2都相继在\ ``hello-1.x``\ 分支将相应的bug修改完后，就\
可以从\ ``hello-1.x``\ 分支中编译新的软件产品交给客户使用了。接下来别忘\
了在主线\ ``master``\ 分支也做出同样的更改，因为在\ ``hello-1.x``\ 分支\
修改的bug同样也存在于主线\ ``master``\ 分支中。

使用Git提供的拣选命令，就可以直接将发布分支上进行的bug修正合并到主线上。\
下面就以开发者user2的身份进行操作。

* 进入user2工作区并切换到master分支。

  ::

    $ cd /path/to/user2/workspace/hello-world/
    $ git checkout master

* 从远程共享版本库同步master分支。

  同步后本地\ ``master``\ 分支包含了开发者user1提交的命令行参数解析重构\
  的代码。

  ::

    $ git pull
    remote: Counting objects: 7, done.
    remote: Compressing objects: 100% (4/4), done.
    remote: Total 4 (delta 3), reused 0 (delta 0)
    Unpacking objects: 100% (4/4), done.
    From file:///path/to/repos/hello-world
       ebcf6d6..0881ca3  master     -> origin/master
    Updating ebcf6d6..0881ca3
    Fast-forward
     src/main.c |   41 ++++++++++++++++++++++++++++++++++++-----
     1 files changed, 36 insertions(+), 5 deletions(-)


* 查看分支\ ``hello-1.x``\ 的日志，确认要拣选的提交ID。

  从下面的日志可以看出分支\ ``hello-1.x``\ 的最新提交是一个合并提交，而\
  要拣选的提交分别是其第一个父提交和第二个父提交，可以分别用\ ``hello-1.x^1``\
  和\ ``hello-1.x^2``\ 表示。

  ::

    $ git log -3 --graph --oneline hello-1.x
    *   8cffe5f Merge branch 'hello-1.x' of file:///path/to/repos/hello-world into hello-1.x
    |\  
    | * b56bb51 Fix typo: -help to --help.
    * | e64f3a2 Bugfix: allow spaces in username.
    |/  

* 执行拣选操作。先将开发者user2提交的修正代码拣选到当前分支（即主线）。

  拣选操作遇到了冲突，见下面的命令输出。

  ::

    $  git cherry-pick hello-1.x^1
    Automatic cherry-pick failed.  After resolving the conflicts,
    mark the corrected paths with 'git add <paths>' or 'git rm <paths>'
    and commit the result with: 

            git commit -c e64f3a216d346669b85807ffcfb23a21f9c5c187

* 拣选操作发生冲突，通过查看状态可以看到是在文件\ :file:`src/main.c`\
  上发生了冲突。

  ::

    $ git status
    # On branch master
    # Unmerged paths:
    #   (use "git reset HEAD <file>..." to unstage)
    #   (use "git add/rm <file>..." as appropriate to mark resolution)
    #
    #       both modified:      src/main.c
    #
    no changes added to commit (use "git add" and/or "git commit -a")

**冲突发生的原因**

为什么发生了冲突呢？这是因为拣选\ ``hello-1.x``\ 分支上的一个提交到\
``master``\ 分支时，因为两个甚至多个提交在重叠的位置更改代码所致。通过下面\
的命令可以看到到底是哪些提交引起的冲突。

::

  $ git log master...hello-1.x^1
  commit e64f3a216d346669b85807ffcfb23a21f9c5c187
  Author: user2 <user2@moon.ossxp.com>
  Date:   Sun Jan 9 13:11:19 2011 +0800

      Bugfix: allow spaces in username.

  commit 0881ca3f62ddadcddec08bd9f2f529a44d17cfbf
  Author: user1 <user1@sun.ossxp.com>
  Date:   Mon Jan 3 22:44:52 2011 +0800

      Refactor: use getopt_long for arguments parsing.

可以看出引发冲突的提交一个是当前工作分支\ ``master``\ 上的最新提交，即开\
发者user1的重构命令行参数解析的提交，而另外一个引发冲突的是要拣选的提交，\
即开发者user2针对用户名显示不全所做的错误修正提交。一定是因为这两个提\
交的更改发生了重叠导致了冲突的发生。下面就来解决冲突。

**冲突解决**

冲突解决可以使用图形界面工具，不过对于本例直接编辑冲突文件，手工进行冲突\
解决也很方便。打开文件\ :file:`src/main.c`\ 就可以看到发生冲突的区域都用\
特有的标记符标识出来，参见表18-1中左侧一列中的内容。


表 18-1：冲突解决前后对照

+----------------------------------------------------------------+----------------------------------------------------------------+
| 冲突文件 src/main.c 标识出的冲突内容                           | 冲突解决后的内容对照                                           |
+================================================================+================================================================+
|::                                                              |::                                                              |
|                                                                |                                                                |
|  21 int                                                        |  21 int                                                        |
|  22 main(int argc, char **argv)                                |  22 main(int argc, char **argv)                                |
|  23 {                                                          |  23 {                                                          |
|  24 <<<<<<< HEAD                                               |                                                                |
|  25     int c;                                                 |  24     int c;                                                 |
|  26     char *uname = NULL;                                    |  25     char **p = NULL;                                       |
|  27                                                            |  26                                                            |
|  28     while (1) {                                            |  27     while (1) {                                            |
|  29         int option_index = 0;                              |  28         int option_index = 0;                              |
|  30         static struct option long_options[] = {            |  29         static struct option long_options[] = {            |
|  31             {"help", 0, 0, 'h'},                           |  30             {"help", 0, 0, 'h'},                           |
|  32             {0, 0, 0, 0}                                   |  31             {0, 0, 0, 0}                                   |
|  33         };                                                 |  32         };                                                 |
|  34                                                            |  33                                                            |
|  35         c = getopt_long(argc, argv, "h",                   |  34         c = getopt_long(argc, argv, "h",                   |
|  36                         long_options, &option_index);      |  35                         long_options, &option_index);      |
|  37         if (c == -1)                                       |  36         if (c == -1)                                       |
|  38            break;                                          |  37            break;                                          |
|  39                                                            |  38                                                            |
|  40         switch (c) {                                       |  39         switch (c) {                                       |
|  41         case 'h':                                          |  40         case 'h':                                          |
|  42             return usage(0);                               |  41             return usage(0);                               |
|  43         default:                                           |  42         default:                                           |
|  44             return usage(1);                               |  43             return usage(1);                               |
|  45         }                                                  |  44         }                                                  |
|  46     }                                                      |  45     }                                                      |
|  47                                                            |  46                                                            |
|  48     if (optind < argc) {                                   |  47     if (optind < argc) {                                   |
|  49         uname = argv[optind];                              |  48         p = &argv[optind];                                 |
|  50     }                                                      |  49     }                                                      |
|  51                                                            |  50                                                            |
|  52     if (uname == NULL) {                                   |  51     if (p == NULL || *p == NULL) {                         |
|  53 =======                                                    |                                                                |
|  54     char **p = NULL;                                       |                                                                |
|  55                                                            |                                                                |
|  56     if (argc == 1) {                                       |                                                                |
|  57 >>>>>>> e64f3a2... Bugfix: allow spaces in username.       |                                                                |
|  58         printf ("Hello world.\n");                         |  52         printf ("Hello world.\n");                         |
|  59     } else {                                               |  53     } else {                                               |
|  60 <<<<<<< HEAD                                               |                                                                |
|  61         printf ("Hi, %s.\n", uname);                       |                                                                |
|  62 =======                                                    |                                                                |
|  63         p = &argv[1];                                      |                                                                |
|  64         printf ("Hi,");                                    |  54         printf ("Hi,");                                    |
|  65         do {                                               |  55         do {                                               |
|  66             printf (" %s", *p);                            |  56             printf (" %s", *p);                            |
|  67         } while (*(++p));                                  |  57         } while (*(++p));                                  |
|  68         printf (".\n");                                    |  58         printf (".\n");                                    |
|  69 >>>>>>> e64f3a2... Bugfix: allow spaces in username.       |                                                                |
|  70     }                                                      |  59     }                                                      |
|  71                                                            |  60                                                            |
|  72     printf( "(version: %s)\n", _VERSION );                 |  61     printf( "(version: %s)\n", _VERSION );                 |
|  73     return 0;                                              |  62     return 0;                                              |
|  74 }                                                          |  63 }                                                          |
+----------------------------------------------------------------+----------------------------------------------------------------+

..  comment to fix wrong hightlight in vim.*

在文件\ :file:`src/main.c`\ 冲突内容中，第25-52行及第61行是\ ``master``\
分支中由开发者user1重构命令行解析时提交的内容，而第54-56行及第63-68行则\
是分支\ ``hello-1.x``\ 中由开发者user2提交的修正用户名显示不全的bug的相\
应代码。

表18-1右侧的一列则是冲突解决后的内容。为了和冲突前的内容相对照，重新进行\
了排版，并对差异内容进行加粗显示。您可以参照完成冲突解决。

将手动编辑完成的文件\ :file:`src/main.c`\ 添加到暂存区才真正地完成了冲突\
解决。

::

  $ git add src/main.c

因为是拣选操作，提交时最好重用所拣选提交的提交说明和作者信息，而且也省下\
了自己写提交说明的麻烦。使用下面的命令完成提交操作。

::

  $ git commit -C hello-1.x^1
  [master 10765a7] Bugfix: allow spaces in username.
   1 files changed, 8 insertions(+), 4 deletions(-)

接下来再将开发者 user1 在分支\ ``hello-1.x``\ 中的提交也拣选到当前分支。\
所拣选的提交非常简单，不过是修改了提交说明中的文字错误而已，拣选操作也不\
会引发异常，直接完成。

::

  $ git cherry-pick hello-1.x^2
  Finished one cherry-pick.
  [master d81896e] Fix typo: -help to --help.
   Author: user1 <user1@sun.ossxp.com>
   1 files changed, 1 insertions(+), 1 deletions(-)

现在通过日志可以看到\ ``master``\ 分支已经完成了对已知bug的修复。

::

  $ git log -3 --graph --oneline
  * d81896e Fix typo: -help to --help.
  * 10765a7 Bugfix: allow spaces in username.
  * 0881ca3 Refactor: use getopt_long for arguments parsing.

查看状态可以看到当前的工作分支相对于远程服务器有两个新提交。

::

  $ git status
  # On branch master
  # Your branch is ahead of 'origin/master' by 2 commits.
  #
  nothing to commit (working directory clean)

执行推送命令将本地\ ``master``\ 分支同步到远程共享版本库。

::

  $ git push
  Counting objects: 11, done.
  Delta compression using up to 2 threads.
  Compressing objects: 100% (8/8), done.
  Writing objects: 100% (8/8), 802 bytes, done.
  Total 8 (delta 6), reused 0 (delta 0)
  Unpacking objects: 100% (8/8), done.
  To file:///path/to/repos/hello-world.git
     0881ca3..d81896e  master -> master

分支变基
=========

完成\ ``user2/i18n``\ 特性分支的开发
-----------------------------------------

开发者user2针对多语种开发的工作任务还没有介绍呢，在最后就借着“实现”这个\
稍微复杂的功能来学习一下Git分支的变基操作。

* 进入user2的工作区，并切换到\ ``user2/i18n``\ 分支。

  ::

    $ cd /path/to/user2/workspace/hello-world/
    $ git checkout user2/i18n
    Switched to branch 'user2/i18n'

* 使用\ ``gettext``\ 为软件添加多语言支持。您可以尝试实现该功能。不过在\
  ``hello-world``\ 中已经保存了一份实现该功能的代码（见里程碑\
  ``jx/v1.0-i18n``\ ），可以直接拿过来用。

* 里程碑\ ``jx/v1.0-i18n``\ 最后的两个提交实现了多语言支持功能。

  ::

    $ git log --oneline -2 --stat jx/v1.0-i18n
    ade873c Translate for Chinese.
     src/locale/zh_CN/LC_MESSAGES/helloworld.po |   30 +++++++++++++++++++++------
     1 files changed, 23 insertions(+), 7 deletions(-)
    0831248 Add I18N support.
     src/Makefile                               |   21 +++++++++++-
     src/locale/helloworld.pot                  |   46 ++++++++++++++++++++++++++++
     src/locale/zh_CN/LC_MESSAGES/helloworld.po |   46 ++++++++++++++++++++++++++++
     src/main.c                                 |   18 ++++++++--
     4 files changed, 125 insertions(+), 6 deletions(-)

* 可以通过拣选命令将这两个提交拣选到\ ``user2/i18n``\ 分支中，相当于在分支\
  ``user2/i18n``\ 中实现了多语言支持的开发。

  ::

    $ git cherry-pick jx/v1.0-i18n~1
    ...
    $ git cherry-pick jx/v1.0-i18n
    ...

* 看看当前分拣选后的日志。

  ::

    $ git log --oneline -2 
    7acb3e8 Translate for Chinese.
    90d873b Add I18N support.

* 为了测试刚刚“开发”完成的多语言支持功能，先对源码执行编译。

  ::

    $ cd src 
    $ make
    version.h.in => version.h
    cc    -c -o main.o main.c
    msgfmt -o locale/zh_CN/LC_MESSAGES/helloworld.mo locale/zh_CN/LC_MESSAGES/helloworld.po
    cc -o hello main.o

* 查看帮助信息，会发现帮助信息已经本地化。

  注意：帮助信息中仍然有文字错误，\ ``--help``\ 误写为\ ``-help``\ 。

  ::

    $ ./hello --help
    Hello world 示例 v1.0-2-g7acb3e8
    版权所有 蒋鑫 <jiangxin AT ossxp DOT com>, 2009

    用法:
        hello
                世界你好。

        hello <username>
                向用户问您好。

        hello -h, -help
                显示本帮助页。

* 不带用户名运行\ ``hello``\ ，也会输出中文。

  ::

    $ ./hello
    世界你好。
    (version: v1.0-2-g7acb3e8)

* 带用户名运行\ ``hello``\ ，会向用户问候。

  注意：程序仍然存在只显示部分用户名的问题。

  ::

    $ ./hello Jiang Xin
    您好, Jiang.
    (version: v1.0-2-g7acb3e8)

* 推送分支\ ``user2/i18n``\ 到远程共享服务器。

  推送该特性分支的目的并非是与他人在此分支上协同工作，主要只是为了进行数\
  据备份。

  ::

    $ git push origin user2/i18n 
    Counting objects: 21, done.
    Delta compression using up to 2 threads.
    Compressing objects: 100% (13/13), done.
    Writing objects: 100% (17/17), 2.91 KiB, done.
    Total 17 (delta 6), reused 1 (delta 0)
    Unpacking objects: 100% (17/17), done.
    To file:///path/to/repos/hello-world.git
     * [new branch]      user2/i18n -> user2/i18n

分支\ ``user2/i18n``\ 变基
---------------------------------

在测试刚刚完成的具有多语种支持功能的\ ``hello-world``\ 时，之前改正的两\
个bug又重现了。这并不奇怪，因为分支\ ``user2/i18n``\ 基于\ ``master``\
分支创建的时候，这两个bug还没有发现呢，更不要说改正了。

在最早刚刚创建\ ``user2/i18n``\ 分支时，版本库的结构非常简单，如图18-6所示。

.. figure:: /images/git-harmony/branch-i18n-initial.png
   :scale: 100

   图 18-6：分支 user2/i18n 创建初始版本库分支状态
     
但是当前\ ``master``\ 分支中不但包含了对两个bug的修正，还包含了开发者\
user1调用\ ``getopt``\ 对命令行参数解析进行的代码重构。图18-7显示的是当前\
版本库\ ``master``\ 分支和\ ``user2/i18n``\ 分支的关系图。

.. figure:: /images/git-harmony/branch-i18n-complete.png
   :scale: 100

   图 18-7：当前版本库分支示意图
     
开发者user2要将分支\ ``user2/i18n``\ 中的提交合并到主线\ ``master``\ 中，\
可以采用上一节介绍的分支合并操作。如果执行分支合并操作，版本库的状态将会\
如图18-8所示：

.. figure:: /images/git-harmony/branch-i18n-merge.png
   :scale: 100

   图 18-8：使用分支合并时版本库分支状态
     
这样操作有利有弊。有利的一面是开发者在\ ``user2/i18n``\ 分支中的提交不会\
发生改变，这一点对于提交已经被他人共享时很重要。再有因为\ ``user2/i18n``\
分支是基于\ ``v1.0``\ 创建的，这样可以很容易将多语言支持功能添加到1.0\
版本的\ ``hello-world``\ 中。不过这些对于本项目来说都不重要。至于不利的\
一面，就是这样的合并操作会产生三个提交（包括一个合并提交），对于要对提交\
进行审核的项目团队来说增加了代码审核的负担。因此很多项目在特性分支合并到\
开发主线的时候，都不推荐使用合并操作，而是使用变基操作。如果执行变基操作，\
版本库相关分支的关系图如图18-9所示。

.. figure:: /images/git-harmony/branch-i18n-rebase-complete.png
   :scale: 100

   图 18-9：使用变基操作版本库分支状态
     
很显然，采用变基操作的分支关系图要比采用合并操作的简单多了，看起来更像是\
集中式版本控制系统特有的顺序提交。因为减少了一个提交，也会减轻代码审核的\
负担。

下面开发者user2就通过变基操作将特性分支\ ``user2/i18n``\ 合并到主线。

* 首先确保开发者user2的工作区位于分支\ ``user2/i18n``\ 上。

  ::

    $ cd /path/to/user2/workspace/hello-world/
    $ git checkout user2/i18n

* 执行变基操作。

  ::

    $ git rebase master
    First, rewinding head to replay your work on top of it...
    Applying: Add I18N support.
    Using index info to reconstruct a base tree...
    Falling back to patching base and 3-way merge...
    Auto-merging src/main.c
    CONFLICT (content): Merge conflict in src/main.c
    Failed to merge in the changes.
    Patch failed at 0001 Add I18N support.

    When you have resolved this problem run "git rebase --continue".
    If you would prefer to skip this patch, instead run "git rebase --skip".
    To restore the original branch and stop rebasing run "git rebase --abort".

变基遇到了冲突，看来这回的麻烦可不小。冲突是在合并\ ``user2/i18n``\ 分支\
中的提交“Add I18N support”时遇到的。首先回顾一下变基的原理，参见第2篇“第\
12章 改变历史”相关章节。对于本例，在进行变基操作时会先切换到\ ``user2/i18n``\
分支，并强制重置到\ ``master``\ 分支所指向的提交。然后再将原\ ``user2/i18n``\
分支的提交一一拣选到新的\ ``user2/i18n``\ 分支上。运行下面的命令可以查看\
可能导致冲突的提交列表。

::

  $ git rev-list --pretty=oneline user2/i18n^...master
  d81896e60673771ef1873b27a33f52df75f70515 Fix typo: -help to --help.
  10765a7ef46981a73d578466669f6e17b73ac7e3 Bugfix: allow spaces in username.
  90d873bb93cd7577b7638f1f391bd2ece3141b7a Add I18N support.
  0881ca3f62ddadcddec08bd9f2f529a44d17cfbf Refactor: use getopt_long for arguments parsing

刚刚发生的冲突是在拣选提交“Add I18N suppport”时出现的，所以在冲突文件中\
标识为他人版本的是user2添加多语种支持功能的提交，而冲突文件中标识为自己\
版本的是修正两个bug的提交及开发者user1提交的重构命令行参数解析的提交。\
下面的两个表格（表18-2和表18-3）是文件\ ``src/main.c``\ 发生冲突的两个主要\
区域，表格的左侧一列是冲突文件中的内容，右侧一列则是冲突解决后的内容。为\
了方便参照进行了适当排版。


表 18-2：变基冲突区域一解决前后对照

+-----------------------------------------------------------------+------------------------------------------------------------------+
| 变基冲突区域一内容（文件 src/main.c）                           | 冲突解决后的内容对照                                             |
+=================================================================+==================================================================+
|::                                                               |::                                                                |
|                                                                 |                                                                  |
|  12 int usage(int code)                                         |  12 int usage(int code)                                          |
|  13 {                                                           |  13 {                                                            |
|  14     printf(_("Hello world example %s\n"                     |  14     printf(_("Hello world example %s\n"                      |
|  15            "Copyright Jiang Xin <jiangxin AT ossxp ...\n"   |  15            "Copyright Jiang Xin <jiangxin AT ossxp ...\n"    |
|  16            "\n"                                             |  16            "\n"                                              |
|  17            "Usage:\n"                                       |  17            "Usage:\n"                                        |
|  18            "    hello\n"                                    |  18            "    hello\n"                                     |
|  19            "            say hello to the world.\n\n"        |  19            "            say hello to the world.\n\n"         |
|  20            "    hello <username>\n"                         |  20            "    hello <username>\n"                          |
|  21            "            say hi to the user.\n\n"            |  21            "            say hi to the user.\n\n"             |
|  22 <<<<<<< HEAD                                                |                                                                  |
|  23            "    hello -h, --help\n"                         |  22            "    hello -h, --help\n"                          |
|  24            "            this help screen.\n\n", _VERSION);  |  23            "            this help screen.\n\n"), _VERSION);  |
|  25 ||||||| merged common ancestors                             |                                                                  |
|  26            "    hello -h, -help\n"                          |                                                                  |
|  27            "            this help screen.\n\n", _VERSION);  |                                                                  |
|  28 =======                                                     |                                                                  |
|  29            "    hello -h, -help\n"                          |                                                                  |
|  30            "            this help screen.\n\n"), _VERSION); |                                                                  |
|  31 >>>>>>> Add I18N support.                                   |                                                                  |
|  32     return code;                                            |  24     return code;                                             |
|  33 }                                                           |  25 }                                                            |
+-----------------------------------------------------------------+------------------------------------------------------------------+


表 18-3：变基冲突区域二解决前后对照

+-----------------------------------------------------------------+------------------------------------------------------------------+
| 变基冲突区域二内容（文件 src/main.c）                           | 冲突解决后的内容对照                                             |
+=================================================================+==================================================================+
|::                                                               |::                                                                |
|                                                                 |                                                                  |
|  38 <<<<<<< HEAD                                                |                                                                  |
|  39     int c;                                                  |  30     int c;                                                   |
|  40     char **p = NULL;                                        |  31     char **p = NULL;                                         |
|  41                                                             |  32                                                              |
|                                                                 |  33     setlocale( LC_ALL, "" );                                 |
|                                                                 |  34     bindtextdomain("helloworld","locale");                   |
|                                                                 |  35     textdomain("helloworld");                                |
|                                                                 |  36                                                              |
|  42     while (1) {                                             |  37     while (1) {                                              |
|  43         int option_index = 0;                               |  38         int option_index = 0;                                |
|  44         static struct option long_options[] = {             |  39         static struct option long_options[] = {              |
|  45             {"help", 0, 0, 'h'},                            |  40             {"help", 0, 0, 'h'},                             |
|  46             {0, 0, 0, 0}                                    |  41             {0, 0, 0, 0}                                     |
|  47         };                                                  |  42         };                                                   |
|  48                                                             |  43                                                              |
|  49         c = getopt_long(argc, argv, "h",                    |  44         c = getopt_long(argc, argv, "h",                     |
|  50                         long_options, &option_index);       |  45                         long_options, &option_index);        |
|  51         if (c == -1)                                        |  46         if (c == -1)                                         |
|  52            break;                                           |  47            break;                                            |
|  53                                                             |  48                                                              |
|  54         switch (c) {                                        |  49         switch (c) {                                         |
|  55         case 'h':                                           |  50         case 'h':                                            |
|  56             return usage(0);                                |  51             return usage(0);                                 |
|  57         default:                                            |  52         default:                                             |
|  58             return usage(1);                                |  53             return usage(1);                                 |
|  59         }                                                   |  54         }                                                    |
|  60     }                                                       |  55     }                                                        |
|  61                                                             |  56                                                              |
|  62     if (optind < argc) {                                    |  57     if (optind < argc) {                                     |
|  63         p = &argv[optind];                                  |  58         p = &argv[optind];                                   |
|  64     }                                                       |  59     }                                                        |
|  65                                                             |  60                                                              |
|  66     if (p == NULL || *p == NULL) {                          |  61     if (p == NULL || *p == NULL) {                           |
|  67         printf ("Hello world.\n");                          |  62         printf ( _("Hello world.\n") );                      |
|  68 ||||||| merged common ancestors                             |                                                                  |
|  69     if (argc == 1) {                                        |                                                                  |
|  70         printf ("Hello world.\n");                          |                                                                  |
|  71     } else if ( strcmp(argv[1],"-h") == 0 ||                |                                                                  |
|  72                 strcmp(argv[1],"--help") == 0 ) {           |                                                                  |
|  73                 return usage(0);                            |                                                                  |
|  74 =======                                                     |                                                                  |
|  75     setlocale( LC_ALL, "" );                                |                                                                  |
|  76     bindtextdomain("helloworld","locale");                  |                                                                  |
|  77     textdomain("helloworld");                               |                                                                  |
|  78                                                             |                                                                  |
|  79     if (argc == 1) {                                        |                                                                  |
|  80         printf ( _("Hello world.\n") );                     |                                                                  |
|  81     } else if ( strcmp(argv[1],"-h") == 0 ||                |                                                                  |
|  82                 strcmp(argv[1],"--help") == 0 ) {           |                                                                  |
|  83                 return usage(0);                            |                                                                  |
|  84 >>>>>>> Add I18N support.                                   |                                                                  |
|  85     } else {                                                |                                                                  |
|  86 <<<<<<< HEAD                                                |  63     } else {                                                 |
|  87         printf ("Hi,");                                     |  64         printf (_("Hi,"));                                   |
|  88         do {                                                |  65         do {                                                 |
|  89             printf (" %s", *p);                             |  66             printf (" %s", *p);                              |
|  90         } while (*(++p));                                   |  67         } while (*(++p));                                    |
|  91         printf (".\n");                                     |  68         printf (".\n");                                      |
|  92 ||||||| merged common ancestors                             |                                                                  |
|  93         printf ("Hi, %s.\n", argv[1]);                      |                                                                  |
|  94 =======                                                     |                                                                  |
|  95         printf (_("Hi, %s.\n"), argv[1]);                   |                                                                  |
|  96 >>>>>>> Add I18N support.                                   |                                                                  |
|  97     }                                                       |  69     }                                                        |
|                                                                 |                                                                  |
+-----------------------------------------------------------------+------------------------------------------------------------------+

..  comment to fix wrong hightlight in vim.*

将完成冲突解决的文件\ ``src/main.c``\ 加入暂存区。

::

  $ git add -u

查看工作区状态。

::

  $ git status
  # Not currently on any branch.
  # Changes to be committed:
  #   (use "git reset HEAD <file>..." to unstage)
  #
  #       modified:   src/Makefile
  #       new file:   src/locale/helloworld.pot
  #       new file:   src/locale/zh_CN/LC_MESSAGES/helloworld.po
  #       modified:   src/main.c
  #

现在不要执行提交，而是继续变基操作。变基操作会自动完成对冲突解决的提交，\
并对分支中的其他提交继续执行变基，直至全部完成。

::

  $ git rebase --continue
  Applying: Add I18N support.
  Applying: Translate for Chinese.


图18-10显示了版本库执行完变基后的状态。

.. figure:: /images/git-harmony/branch-i18n-rebase.png
   :scale: 100

   图 18-10：变基操作完成后版本库分支状态

现在需要将\ ``user2/i18n``\ 分支的提交合并到主线\ ``master``\ 中。实际上\
不需要在\ ``master``\ 分支上再执行繁琐的合并操作，而是可以直接用推送操作\
——用本地的\ ``user2/i18n``\ 分支直接更新远程版本库的\ ``master``\ 分支。

::

  $ git push origin user2/i18n:master
  Counting objects: 21, done.
  Delta compression using up to 2 threads.
  Compressing objects: 100% (13/13), done.
  Writing objects: 100% (17/17), 2.91 KiB, done.
  Total 17 (delta 6), reused 1 (delta 0)
  Unpacking objects: 100% (17/17), done.
  To file:///path/to/repos/hello-world.git

仔细看看上面运行的\ :command:`git push`\ 命令，终于看到了引用表达式中引\
号前后使用了不同名字的引用。含义是用本地的\ ``user2/i18n``\ 引用的内容\
（提交ID）更新远程共享版本库的\ ``master``\ 引用内容（提交ID）。

执行拉回操作，可以发现远程共享版本库的\ ``master``\ 分支的确被更新了。\
通过拉回操作本地的\ ``master``\ 分支也随之更新。

* 切换到\ ``master``\ 分支，会从提示信息中看到本地\ ``master``\ 分支落后\
  远程共享版本库\ ``master``\ 分支两个提交。

  ::

    $ git checkout master
    Switched to branch 'master'
    Your branch is behind 'origin/master' by 2 commits, and can be fast-forwarded.

* 执行拉回操作，将本地\ ``master``\ 分支同步到和远程共享版本库相同的状态。

  ::

    $ git pull
    Updating d81896e..c4acab2
    Fast-forward
     src/Makefile                               |   21 ++++++++-
     src/locale/helloworld.pot                  |   46 ++++++++++++++++++++
     src/locale/zh_CN/LC_MESSAGES/helloworld.po |   62 ++++++++++++++++++++++++++++
     src/main.c                                 |   18 ++++++--
     4 files changed, 141 insertions(+), 6 deletions(-)
     create mode 100644 src/locale/helloworld.pot
     create mode 100644 src/locale/zh_CN/LC_MESSAGES/helloworld.po

特性分支\ ``user2/i18n``\ 也完成了历史使命，可以删除了。因为之前\
``user2/i18n``\ 已经推送到远程共享版本库，如果想要删除分支不要忘了也将远程\
分支同时删除。

* 删除本地版本库的\ ``user2/i18n``\ 分支。

  ::

    $ git branch -d user2/i18n
    Deleted branch user2/i18n (was c4acab2).

* 删除远程共享版本库的\ ``user2/i18n``\ 分支。

  ::

    $ git push origin :user2/i18n
    To file:///path/to/repos/hello-world.git
     - [deleted]         user2/i18n


----

补充：实际上变基之后\ ``user2/i18n``\ 分支的本地化模板文件（helloworld.pot）\
和汉化文件（helloworld.po）都需要做出相应更新，否则\ ``hello-world``\ 的\
一些输出不能进行本地化。

* 更新模板需要删除文件\ :file:`helloworld.pot`\ ，再执行命令\
  :command:`make po`\ 。

* 重新翻译中文本地化文件，可以使用工具\ :command:`lokalize`\ 或者\
  :command:`kbabel`\ 。

具体的操作过程就不再赘述了。

----

.. EOF
