改变历史
********

我是《回到未来》的粉丝，偶尔会做梦，梦见穿梭到未来拿回一本2000-2050体育\
年鉴。操作Git可以体验到穿梭时空的感觉，因为Git像极了一个时光机器，不但允\
许你在历史中穿梭，而且能够改变历史。

在本章的最开始，介绍两种最简单和最常用的历史变更操作——“悔棋”操作，就是对\
刚刚进行的一次或几次提交进行修补。对于跳跃式的历史记录的变更，即仅对过去\
某一个或某几个提交作出改变，会在“回到未来”小节详细介绍。在“丢弃历史”小节\
会介绍一种版本库瘦身的方法，这可能会在某些特定的场合用到。

作为分布式版本控制系统，一旦版本库被多人共享，改变历史就可能是无法完成的\
任务。在本章的最后，介绍还原操作实现在不改变历史提交的情况下还原错误的改\
动。

悔棋
====

在日常的Git操作中，会经常出现这样的状况，输入\ :command:`git commit`\ 命\
令刚刚敲下回车键就后悔了：可能是提交说明中出现了错别字，或者有文件忘记提\
交，或者有的修改不应该提交，诸如此类。

像Subversion那样的集中式版本控制系统是“落子无悔”的系统，只能叹一口气责怪\
自己太不小心了。然后根据实际情况弥补：马上做一次新提交改正前面的错误；或\
者只能将错就错：错误的提交说明就让它一直错下去吧，因为大部分Subversion管\
理员不敢或者不会放开修改提交说明的功能导致无法对提交说明进行修改。

Git提供了“悔棋”的操作，甚至因为“单步悔棋”是如此经常的发生，乃至于Git提供\
了一个简洁的操作——修补式提交，命令是：\ :command:`git commit --amend`\ 。

看看当前版本库最新的两次提交：

::

  $ cd /path/to/my/workspace/demo
  $ git log --stat -2
  commit 822b4aeed5de74f949c9faa5b281001eb5439444
  Author: Jiang Xin <jiangxin@ossxp.com>
  Date:   Wed Dec 8 16:27:41 2010 +0800

      测试使用 qgit 提交。

   README      |    1 +
   src/hello.h |    2 --
   2 files changed, 1 insertions(+), 2 deletions(-)

  commit 613486c17842d139871e0f1b0e9191d2b6177c9f
  Author: Jiang Xin <jiangxin@ossxp.com>
  Date:   Tue Dec 7 19:43:39 2010 +0800

      偷懒了，直接用 -a 参数直接提交。

   src/hello.h |    1 +
   1 files changed, 1 insertions(+), 0 deletions(-)

最新一次的提交是的确是在上一章使用\ ``qgit``\ 进行的提交，但这和提交内容\
无关，因此需要改掉这个提交的提交说明。使用下面的命令即可做到。

::

  $ git commit --amend -m "Remove hello.h, which is useless."
  [master 7857772] Remove hello.h, which is useless.
   2 files changed, 1 insertions(+), 2 deletions(-)
   delete mode 100644 src/hello.h

上面的命令使用了\ ``-m``\ 参数是为了演示的方便，实际上完全可以直接输入\
:command:`git commit --amend`\ ，在弹出的提交说明编辑界面修改提交说明，\
然后保存退出完成修补提交。

下面再看看最近两次的提交说明，可以看到最新的提交说明更改了（包括提交的\
SHA1哈希值），而它的父提交（即前一次提交）没有改变。

::

  $ git log --stat -2
  commit 78577724305e3e20aa9f2757ac5531d037d612a6
  Author: Jiang Xin <jiangxin@ossxp.com>
  Date:   Wed Dec 8 16:27:41 2010 +0800

      Remove hello.h, which is useless.

   README      |    1 +
   src/hello.h |    2 --
   2 files changed, 1 insertions(+), 2 deletions(-)

  commit 613486c17842d139871e0f1b0e9191d2b6177c9f
  Author: Jiang Xin <jiangxin@ossxp.com>
  Date:   Tue Dec 7 19:43:39 2010 +0800

      偷懒了，直接用 -a 参数直接提交。

   src/hello.h |    1 +
   1 files changed, 1 insertions(+), 0 deletions(-)

如果最后一步操作不想删除文件\ :file:`src/hello.h`\ ，而只是想修改\
:file:`README`\ ，则可以按照下面的方法进行修补操作。

* 还原删除的\ :file:`src/hello.h`\ 文件。

  ::

    $ git checkout HEAD^ -- src/hello.h

* 此时查看状态，会看到\ :file:`src/hello.h`\ 被重新添加回暂存区。

  ::

    $ git status
    # On branch master
    # Changes to be committed:
    #   (use "git reset HEAD <file>..." to unstage)
    #
    #       new file:   src/hello.h
    #

* 执行修补提交，不过提交说明是不是也要更改呢，因为毕竟这次提交不会删除\
  文件了。

  ::

    $ git commit --amend -m "commit with --amend test."
    [master 2b45206] commit with --amend test.
     1 files changed, 1 insertions(+), 0 deletions(-)

* 再次查看最近两次提交，会发现最新的提交不再删除文件\
  :file:`src/hello.h`\ 了。

  ::

    $ git log --stat -2
    commit 2b452066ef6e92bceb999cf94fcce24afb652259
    Author: Jiang Xin <jiangxin@ossxp.com>
    Date:   Wed Dec 8 16:27:41 2010 +0800

        commit with --amend test.

     README |    1 +
     1 files changed, 1 insertions(+), 0 deletions(-)

    commit 613486c17842d139871e0f1b0e9191d2b6177c9f
    Author: Jiang Xin <jiangxin@ossxp.com>
    Date:   Tue Dec 7 19:43:39 2010 +0800

        偷懒了，直接用 -a 参数直接提交。

     src/hello.h |    1 +
     1 files changed, 1 insertions(+), 0 deletions(-)

多步悔棋
========

Git能够提供悔棋的奥秘在于Git的重置命令。实际上上面介绍的单步悔棋也可以用\
重置命令来实现，只不过Git提供了一个更好用的更简洁的修补提交命令而已。多\
步悔棋顾名思义就是可以取消最新连续的多次提交，多次悔棋并非是所有分布式版\
本控制系统都具有的功能，像Mercurial/Hg只能对最新提交悔棋一次（除非使用\
MQ插件）。Git因为有了强大的重置命令，可以悔棋任意多次。

多步悔棋会在什么场合用到呢？软件开发中针对某个特性功能的开发就是一例。某\
个开发工程师领受某个特性开发的任务，于是在本地版本库进行了一系列开发、测\
试、修补、再测试的流程，最终特性功能开发完毕后可能在版本库中留下了多次提\
交。在将本地版本库改动推送（PUSH）到团队协同工作的核心版本库时，这个开发\
人员就想用多步悔棋的操作，将多个试验性的提及合为一个完整的提交。

以DEMO版本库为例，看看版本库最近的三次提交。

::

  $ git log --stat --pretty=oneline -3
  2b452066ef6e92bceb999cf94fcce24afb652259 commit with --amend test.
   README |    1 +
   1 files changed, 1 insertions(+), 0 deletions(-)
  613486c17842d139871e0f1b0e9191d2b6177c9f 偷懒了，直接用 -a 参数直接提交。
   src/hello.h |    1 +
   1 files changed, 1 insertions(+), 0 deletions(-)
  48456abfaeab706a44880eabcd63ea14317c0be9 add hello.h
   src/hello.h |    1 +
   1 files changed, 1 insertions(+), 0 deletions(-)

想要将最近的两个提交压缩为一个，并把提交说明改为“modify hello.h”，可以使\
用如下方法进行操作。

* 使用\ ``--soft``\ 参数调用重置命令，回到最近两次提交之前。

  ::

    $ git reset --soft HEAD^^

* 版本状态和最新日志。

  ::

    $ git status
    # On branch master
    # Changes to be committed:
    #   (use "git reset HEAD <file>..." to unstage)
    #
    #       modified:   README
    #       modified:   src/hello.h
    #
    $ git log -1
    commit 48456abfaeab706a44880eabcd63ea14317c0be9
    Author: Jiang Xin <jiangxin@ossxp.com>
    Date:   Tue Dec 7 19:39:10 2010 +0800

        add hello.h

* 执行提交操作，即完成最新两个提交压缩为一个提交的操作。

  ::

    $ git commit -m "modify hello.h"
    [master b6f0b0a] modify hello.h
     2 files changed, 2 insertions(+), 0 deletions(-)

* 看看提交日志，“多步悔棋”操作成功。

  ::

    $ git log --stat --pretty=oneline -2
    b6f0b0a5237bc85de1863dbd1c05820f8736c76f modify hello.h
     README      |    1 +
     src/hello.h |    1 +
     2 files changed, 2 insertions(+), 0 deletions(-)
    48456abfaeab706a44880eabcd63ea14317c0be9 add hello.h
     src/hello.h |    1 +
     1 files changed, 1 insertions(+), 0 deletions(-)

回到未来
========

电影《回到未来》（Back to future）第二集，老毕福偷走时光车，到过去\
（1955年）给了小毕福一本书，导致未来大变。

.. figure:: /images/git-solo/back-to-future.png
   :scale: 70

   布朗博士正在解释为何产生两个平行的未来

Git这一台“时光机”也有这样的能力，或者说也会具有这样的行为。当更改历史提\
交（SHA1哈希值变更），即使后续提交的内容和属性都一致，但是因为后续提交中\
有一个属性是父提交的SHA1哈希值，所以一个历史提交的改变会引起连锁变化，导\
致所有后续提交必然的发生变化，就会形成两条平行的时间线：一个是变更前的提\
交时间线，另外一条是更改历史后新的提交时间线。

把此次实践比喻做一次电影（回到未来）拍摄的话，舞台依然是之前的DEMO版本库，\
而剧本是这样的。

* 角色：最近的六次提交。分别依据提交顺序，编号为A、B、C、D、E、F。

  ::

    $ git log --oneline -6
    b6f0b0a modify hello.h                        # F
    48456ab add hello.h                           # E
    3488f2c move .gitignore outside also works.   # D
    b3af728 ignore object files.                  # C
    d71ce92 Hello world initialized.              # B
    c024f34 README is from welcome.txt.           # A

* 坏蛋：提交D。

  即对\ :file:`.gitignore`\ 文件移动的提交不再需要，或者这个提交将和前一\
  次提交（C）压缩为一个。

* 前奏：故事人物依次出场，坏蛋D在图中被特殊标记。

  .. figure:: /images/git-solo/git-rebase-orig.png
     :scale: 100

* 第一幕：抛弃提交D，将正确的提交E和F重新“嫁接”到提交C上，最终坏蛋被消灭。

  .. figure:: /images/git-solo/git-rebase-c.png
     :scale: 100

* 第二幕：坏蛋D被C感化，融合为"CD"复合体，E和F重新“嫁接”到"CD"复合体上，\
  最终大团圆结局。

  .. figure:: /images/git-solo/git-rebase-cd.png
     :scale: 100

* 道具：分别使用三辆不同的时光车来完成“回到未来”。

  分别是：核能跑车，清洁能源飞车，蒸汽为动力的飞行火车。

时间旅行一
-------------------

《回到未来-第一集》布朗博士设计的第一款时间旅行车是一辆跑车，使用核燃料：\
钚。与之对应，此次实践使用的工具也没有太出乎想象，用一条新的指令——拣选\
指令（\ :command:`git cherry-pick`\ ）实现提交在新的分支上“重放”。

拣选指令——\ :command:`git cherry-pick`\ ，其含义是从众多的提交中挑选出一\
个提交应用在当前的工作分支中。该命令需要提供一个提交ID作为参数，操作过程\
相当于将该提交导出为补丁文件，然后在当前HEAD上重放形成无论内容还是提交说\
明都一致的提交。

首先对版本库要“参演”的角色进行标记，使用尚未正式介绍的命令\ :command:`gi t tag`\
（无非就是在特定命名空间建立的引用，用于对提交的标识）。

::

  $ git tag F
  $ git tag E HEAD^
  $ git tag D HEAD^^
  $ git tag C HEAD^^^
  $ git tag B HEAD~4
  $ git tag A HEAD~5

通过日志，可以看到被标记的6个提交。

::

  $ git log --oneline --decorate -6
  b6f0b0a (HEAD, tag: F, master) modify hello.h
  48456ab (tag: E) add hello.h
  3488f2c (tag: D) move .gitignore outside also works.
  b3af728 (tag: C) ignore object files.
  d71ce92 (tag: hello_1.0, tag: B) Hello world initialized.
  c024f34 (tag: A) README is from welcome.txt.

**现在演出第一幕：干掉坏蛋D**

* 执行\ :command:`git checkout`\ 命令，暂时将HEAD头指针切换到C。

  切换过程显示处于非跟踪状态的警告，没有关系，因为剧情需要。

  ::

    $ git checkout C
    Note: checking out 'C'.

    You are in 'detached HEAD' state. You can look around, make experimental
    changes and commit them, and you can discard any commits you make in this
    state without impacting any branches by performing another checkout.

    If you want to create a new branch to retain commits you create, you may
    do so (now or later) by using -b with the checkout command again. Example:

      git checkout -b new_branch_name

    HEAD is now at b3af728... ignore object files.

* 执行拣选操作将E提交在当前HEAD上重放。

  因为\ ``E``\ 和\ ``master^``\ 显然指向同一角色，因此可以用下面的语法。

  ::

    $ git cherry-pick master^
    [detached HEAD fa0b076] add hello.h
     1 files changed, 1 insertions(+), 0 deletions(-)
     create mode 100644 src/hello.h

* 执行拣选操作将\ ``F``\ 提交在当前HEAD上重放。

  F和master也具有相同指向。

  ::

    $ git cherry-pick master
    [detached HEAD f677821] modify hello.h
     2 files changed, 2 insertions(+), 0 deletions(-)

* 通过日志可以看到坏蛋D已经不在了。

  ::

    $ git log --oneline --decorate -6
    f677821 (HEAD) modify hello.h
    fa0b076 add hello.h
    b3af728 (tag: C) ignore object files.
    d71ce92 (tag: hello_1.0, tag: B) Hello world initialized.
    c024f34 (tag: A) README is from welcome.txt.
    63992f0 restore file: welcome.txt

* 通过日志还可以看出来，最新两次提交的原始创作日期（AuthorDate）和提交日\
  期（CommitDate）不同。AuthorDate是拣选提交的原始更改时间，而CommitDate\
  是拣选操作时的时间，因此拣选后的新提交的SHA1哈希值也不同于所拣选的原\
  提交的SHA1哈希值。

  ::

    $ git log --pretty=fuller --decorate -2
    commit f677821dfc15acc22ca41b48b8ebaab5ac2d2fea (HEAD)
    Author:     Jiang Xin <jiangxin@ossxp.com>
    AuthorDate: Sun Dec 12 12:11:00 2010 +0800
    Commit:     Jiang Xin <jiangxin@ossxp.com>
    CommitDate: Sun Dec 12 16:20:14 2010 +0800

        modify hello.h

    commit fa0b076de600a53e8703545c299090153c6328a8
    Author:     Jiang Xin <jiangxin@ossxp.com>
    AuthorDate: Tue Dec 7 19:39:10 2010 +0800
    Commit:     Jiang Xin <jiangxin@ossxp.com>
    CommitDate: Sun Dec 12 16:18:34 2010 +0800

        add hello.h

* 最重要的一步操作，就是要将master分支指向新的提交ID（f677821）上。

  下面的切换操作使用了reflog的语法，即\ ``HEAD@{1}``\ 相当于切换回master\
  分支前的HEAD指向，即\ ``f677821``\ 。

  ::

    $ git checkout master
    Previous HEAD position was f677821... modify hello.h
    Switched to branch 'master'
    $ git reset --hard HEAD@{1}
    HEAD is now at f677821 modify hello.h

* 使用\ ``qgit``\ 查看版本库提交历史。

  .. figure:: /images/git-solo/git-rebase-graph.png
     :scale: 80

**幕布拉上，后台重新布景**

为了第二幕能够顺利演出，需要将master分支重新置回到提交F上。执行下面的\
操作完成“重新布景”。

::

  $ git checkout master
  Already on 'master'
  $ git reset --hard F
  HEAD is now at b6f0b0a modify hello.h
  $ git log --oneline --decorate -6
  b6f0b0a (HEAD, tag: F, master) modify hello.h
  48456ab (tag: E) add hello.h
  3488f2c (tag: D) move .gitignore outside also works.
  b3af728 (tag: C) ignore object files.
  d71ce92 (tag: hello_1.0, tag: B) Hello world initialized.
  c024f34 (tag: A) README is from welcome.txt.

布景完毕，大幕即将再次拉开。

**现在演出第二幕：坏蛋D被感化，融入社会**

* 执行\ :command:`git checkout`\ 命令，暂时将HEAD头指针切换到坏蛋D。

  切换过程显示处于非跟踪状态的警告，没有关系，因为剧情需要。

  ::

    $ git checkout D
    Note: checking out 'D'.

    You are in 'detached HEAD' state. You can look around, make experimental
    changes and commit them, and you can discard any commits you make in this
    state without impacting any branches by performing another checkout.

    If you want to create a new branch to retain commits you create, you may
    do so (now or later) by using -b with the checkout command again. Example:

      git checkout -b new_branch_name

    HEAD is now at 3488f2c... move .gitignore outside also works.

* 悔棋两次，以便将C和D融合。

  ::

    $ git reset --soft HEAD^^ 

* 执行提交，提交说明重用C提交的提交说明。

  ::

    $ git commit -C C
    [detached HEAD 53e621c] ignore object files.
     1 files changed, 3 insertions(+), 0 deletions(-)
     create mode 100644 .gitignore

* 执行拣选操作将E提交在当前HEAD上重放。

  ::

    $ git cherry-pick E
    [detached HEAD 1f99f82] add hello.h
     1 files changed, 1 insertions(+), 0 deletions(-)
     create mode 100644 src/hello.h


* 执行拣选操作将F提交在当前HEAD上重放。

  ::

    $ git cherry-pick F
    [detached HEAD 2f13d3a] modify hello.h
     2 files changed, 2 insertions(+), 0 deletions(-)

* 通过日志可以看到提交C和D被融合，所以在日志中看不到C的标签。

  ::

    $ git log --oneline --decorate -6
    2f13d3a (HEAD) modify hello.h
    1f99f82 add hello.h
    53e621c ignore object files.
    d71ce92 (tag: hello_1.0, tag: B) Hello world initialized.
    c024f34 (tag: A) README is from welcome.txt.
    63992f0 restore file: welcome.txt

* 最重要的一步操作，就是要将master分支指向新的提交ID（2f13d3a）上。

  下面的切换操作使用了reflog的语法，即\ ``HEAD@{1}``\ 相当于切换回master\
  分支前的HEAD指向，即\ ``2f13d3a``\ 。

  ::

    $ git checkout master
    Previous HEAD position was 2f13d3a... modify hello.h
    Switched to branch 'master'
    $ git reset --hard HEAD@{1}
    HEAD is now at 2f13d3a modify hello.h

* 使用\ ``gitk``\ 查看版本库提交历史。

  .. figure:: /images/git-solo/git-rebase-graph-gitk.png
     :scale: 80

**别忘了后台的重新布景**

为了接下来的时间旅行二能够顺利开始，需要重新布景，将master分支重新置回到\
提交F上。

::

  $ git checkout master
  Already on 'master'
  $ git reset --hard F
  HEAD is now at b6f0b0a modify hello.h

时间旅行二
------------------

《回到未来-第二集》布朗博士改进的时间旅行车使用了未来科技，是陆天两用的\
飞车，而且燃料不再依赖核物质，而是使用无所不在的生活垃圾。而此次实践使用\
的工具也进行了升级，采用强大的\ :command:`git rebase`\ 命令。

命令\ :command:`git rebase`\ 是对提交执行变基操作，即可以实现将指定范围\
的提交“嫁接”到另外一个提交之上。其常用的命令行格式有：

::

  用法1: git rebase --onto  <newbase>  <since>      <till>
  用法2: git rebase --onto  <newbase>  <since>
  用法3: git rebase         <newbase>               <till>
  用法4: git rebase         <newbase>
  用法5: git rebase -i ...
  用法6: git rebase --continue
  用法7: git rebase --skip
  用法8: git rebase --abort

不要被上面的语法吓到，用法5会在下节（时间旅行三）中予以介绍，后三种用法\
则是变基运行过程被中断时可采用的命令——继续变基或终止等。

* 用法6是在变基遇到冲突而暂停后，当完成冲突解决后（添加到暂存区，不提交），\
  恢复变基操作的时候使用。

* 用法7是在变基遇到冲突而暂停后，跳过当前提交的时候使用。

* 用法8是在变基遇到冲突后，终止变基操作，回到之前的分支时候使用。

而前四个用法如果把省略的参数补上（方括号内是省略掉的参数），看起来就都和\
用法1就一致了。

::

  用法1: git rebase  --onto  <newbase>  <since>      <till>
  用法2: git rebase  --onto  <newbase>  <since>      [HEAD]
  用法3: git rebase [--onto] <newbase>  [<newbase>]  <till>
  用法4: git rebase [--onto] <newbase>  [<newbase>]  [HEAD]

下面就以归一化的\ :command:`git rebase`\ 命令格式来介绍其用法。

::

  命令格式: git rebase  --onto  <newbase>  <since>  <till>

变基操作的过程：

* 首先会执行\ :command:`git checkout`\ 切换到\ ``<till>``\ 。

  因为会切换到\ ``<till>``\ ，因此如果\ ``<till>``\ 指向的不是一个分支\
  （如master），则变基操作是在\ ``detached HEAD``\ （分离头指针）状态进行\
  的，当变基结束后，还要像在“时间旅行一”中那样，对master分支执行重置以实现\
  把变基结果记录在分支中。

* 将\ ``<since>..<till>``\ 所标识的提交范围写到一个临时文件中。

  还记得前面介绍的版本范围语法，\ ``<since>..<till>``\ 是指包括\
  ``<till>``\ 的所有历史提交排除\ ``<since>``\ 以及\ ``<since>``\ 的历史\
  提交后形成的版本范围。

* 当前分支强制重置（git reset --hard）到\ ``<newbase>``\ 。

  相当于执行：\ :command:`git reset --hard <newbase>`\ 。

* 从保存在临时文件中的提交列表中，一个一个将提交按照顺序重新提交到重置\
  之后的分支上。

* 如果遇到提交已经在分支中包含，跳过该提交。

* 如果在提交过程遇到冲突，变基过程暂停。用户解决冲突后，执行\
  :command:`git rebase --continue`\ 继续变基操作。或者执行\
  :command:`git rebase --skip`\ 跳过此提交。或者执行\
  :command:`git rebase --abort`\ 就此终止变基操作切换到变基前的分支上。

很显然为了执行将E和F提交跳过提价D，“嫁接”到C提交上。可以如此执行变基命令：

::

  $ git rebase --onto C E^ F

因为\ ``E^``\ 等价于D，并且F和当前HEAD指向相同，因此可以这样操作：

::

  $ git rebase --onto C D

有了对变基命令的理解，就可以开始新的“回到未来”之旅了。

确认舞台已经布置完毕。

::

  $ git status -s -b
  ## master
  $ git log --oneline --decorate -6
  b6f0b0a (HEAD, tag: F, master) modify hello.h
  48456ab (tag: E) add hello.h
  3488f2c (tag: D) move .gitignore outside also works.
  b3af728 (tag: C) ignore object files.
  d71ce92 (tag: hello_1.0, tag: B) Hello world initialized.
  c024f34 (tag: A) README is from welcome.txt.

**现在演出第一幕：干掉坏蛋D**

* 执行变基操作。

  因为下面的变基操命令行使用了参数F。F是一个里程碑指向一个提交，而非master，\
  会导致后面变基完成还需要对master分支执行重置。在第二幕中会使用master，\
  会发现省事不少。

  ::

    $ git rebase --onto C E^ F
    First, rewinding head to replay your work on top of it...
    Applying: add hello.h
    Applying: modify hello.h

* 最后一步必需的操作，就是要将master分支指向变基后的提交上。

  下面的切换操作使用了reflog的语法，即\ ``HEAD@{1}``\ 相当于切换回master\
  分支前的HEAD指向，即\ ``3360440``\ 。

  ::

    $ git checkout master
    Previous HEAD position was 3360440... modify hello.h
    Switched to branch 'master'
    $ git reset --hard HEAD@{1}
    HEAD is now at 3360440 modify hello.h

* 经过检查，操作完毕，收工。

  ::

    $ git log --oneline --decorate -6
    3360440 (HEAD, master) modify hello.h
    1ef3803 add hello.h
    b3af728 (tag: C) ignore object files.
    d71ce92 (tag: hello_1.0, tag: B) Hello world initialized.
    c024f34 (tag: A) README is from welcome.txt.
    63992f0 restore file: welcome.txt

**幕布拉上，后台重新布景**

为了第二幕能够顺利演出，需要将master分支重新置回到提交F上。执行下面的\
操作完成“重新布景”。

::

  $ git checkout master
  Already on 'master'
  $ git reset --hard F
  HEAD is now at b6f0b0a modify hello.h

布景完毕，大幕即将再次拉开。

**现在演出第二幕：坏蛋D被感化，融入社会**

* 执行\ :command:`git checkout`\ 命令，暂时将HEAD头指针切换到坏蛋D。

  切换过程显示处于非跟踪状态的警告，没有关系，因为剧情需要。

  ::

    $ git checkout D
    Note: checking out 'D'.

    You are in 'detached HEAD' state. You can look around, make experimental
    changes and commit them, and you can discard any commits you make in this
    state without impacting any branches by performing another checkout.

    If you want to create a new branch to retain commits you create, you may
    do so (now or later) by using -b with the checkout command again. Example:

      git checkout -b new_branch_name

    HEAD is now at 3488f2c... move .gitignore outside also works.

* 悔棋两次，以便将C和D融合。

  ::

    $ git reset --soft HEAD^^ 

* 执行提交，提交说明重用C提交的提交说明。

  ::

    $ git commit -C C
    [detached HEAD 2d020b6] ignore object files.
     1 files changed, 3 insertions(+), 0 deletions(-)
     create mode 100644 .gitignore

* 记住这个提交ID：\ ``2d020b6``\ 。

  用里程碑是最好的记忆提交ID的方法：

  ::

    $ git tag newbase
    $ git rev-parse newbase
    2d020b62034b7a433f80396118bc3f66a60f296f

* 执行变基操作，将E和F提交“嫁接”到\ ``newbase``\ 上。

  下面的变基操命令行没有像之前的操作使用使用了参数F，而是使用分支master。\
  所以接下来的变基操作会直接修改master分支，而无须再进行对master的重置操作。

  ::

    $ git rebase --onto newbase E^ master
    First, rewinding head to replay your work on top of it...
    Applying: add hello.h
    Applying: modify hello.h

* 看看提交日志，看到提交C和提交D都不见了，代之以融合后的提交\
  ``newbase``\ 。

  还可以看到最新的提交除了和HEAD的指向一致，也和master分支的指向一致。

  ::

    $ git log --oneline --decorate -6
    2495dc1 (HEAD, master) modify hello.h
    6349328 add hello.h
    2d020b6 (tag: newbase) ignore object files.
    d71ce92 (tag: hello_1.0, tag: B) Hello world initialized.
    c024f34 (tag: A) README is from welcome.txt.
    63992f0 restore file: welcome.txt

* 当前的确已经在master分支上了，操作全部完成。

  ::

    $ git branch
    * master

* 清理一下，然后收工。

  前面的操作中为了方便创建了标识提交的新里程碑\ ``newbase``\ ，将这个\
  里程碑现在没有什么用处了删除吧。

  ::

    $ git tag -d newbase
    Deleted tag 'newbase' (was 2d020b6)

**别忘了后台的重新布景**

为了接下来的时间旅行三能够顺利开始，需要重新布景，将master分支重新置回到\
提交F上。

::

  $ git checkout master
  Already on 'master'
  $ git reset --hard F
  HEAD is now at b6f0b0a modify hello.h

时间旅行三
------------------

《回到未来-第三集》铁匠布朗博士手工打造了可以时光旅行的飞行火车，使用蒸\
汽作为动力。这款时间旅行火车更大，更安全，更舒适，适合一家四口外加宠物的\
时空旅行。与之对应本次实践也将采用“手工打造”：交互式变基。

交互式变基就是在上一节介绍的变基命令的基础上，添加了\ ``-i``\ 参数，在变\
基的时候进入一个交互界面。使用了交互界面的变基操作，不仅仅是自动化变基转\
换为手动确认那么没有技术含量，而是充满了魔法。

执行交互式变基操作，会将\ ``<since>..<till>``\ 的提交悉数罗列在一个文件\
中，然后自动打开一个编辑器来编辑这个文件。可以通过修改文件的内容（删除提\
交，修改提交的动作关键字）实现删除提交，压缩多个提交为一个提交，更改提交\
的顺序，更改历史提交的提交说明。

例如下面的界面就是针对当前DEMO版本库执行的交互式变基时编辑器打开的文件：

::

  pick b3af728 ignore object files.
  pick 3488f2c move .gitignore outside also works.
  pick 48456ab add hello.h
  pick b6f0b0a modify hello.h

  # Rebase d71ce92..b6f0b0a onto d71ce92
  #
  # Commands:
  #  p, pick = use commit
  #  r, reword = use commit, but edit the commit message
  #  e, edit = use commit, but stop for amending
  #  s, squash = use commit, but meld into previous commit
  #  f, fixup = like "squash", but discard this commit's log message
  #  x <cmd>, exec <cmd> = Run a shell command <cmd>, and stop if it fails
  #
  # If you remove a line here THAT COMMIT WILL BE LOST.
  # However, if you remove everything, the rebase will be aborted.

从该文件可以看出：

* 开头的四行由上到下依次对应于提交C、D、E、F。
* 前四行缺省的动作都是\ ``pick``\ ，即应用此提交。
* 参考配置文件中的注释，可以通过修改动作名称，在变基的时候执行特定操作。
* 动作\ ``reword``\ 或者简写为\ ``r``\ ，含义是变基时应用此提交，但是在\
  提交的时候允许用户修改提交说明。

  这个功能在Git 1.6.6 之后开始提供，对于修改历史提交的提交说明异常方便。\
  老版本的Git还是使用\ ``edit``\ 动作吧。

* 动作\ ``edit``\ 或者简写为\ ``e``\ ，也会应用此提交，但是会在应用时停\
  止，提示用户使用\ :command:`git commit --amend`\ 执行提交，以便对提交\
  进行修补。

  当用户执行\ :command:`git commit --amend`\ 完成提交后，还需要执行\
  :command:`git rebase --continue`\ 继续变基操作。Git会对用户进行相应地\
  提示。

  实际上用户在变基暂停状态执行修补提交可以执行多次，相当于把一个提交分解\
  为多个提交。而且\ ``edit``\ 动作也可以实现\ ``reword``\ 的动作，因此\
  对于老版本的Git没有\ ``reword``\ 可用，则可以使用此动作。

* 动作\ ``squash``\ 或者简写为\ ``s``\ ，该提交会与前面的提交压缩为一个。

* 动作\ ``fixup``\ 或者简写为\ ``f``\ ，类似\ ``squash``\ 动作，但是此\
  提交的提交说明被丢弃。

  这个功能在Git 1.7.0 之后开始提供，老版本的Git还是使用\ ``squash``\
  动作吧。

* 可以通过修改配置文件中这四个提交的先后顺序，进而改变最终变基后提交的\
  先后顺序。

* 可以对相应提交对应的行执行删除操作，这样该提交就不会被应用，进而在变基\
  后的提交中被删除。

有了对交互式变基命令的理解，就可以开始新的“回到未来”之旅了。

确认舞台已经布置完毕。

::

  $ git status -s -b
  ## master
  $ git log --oneline --decorate -6
  b6f0b0a (HEAD, tag: F, master) modify hello.h
  48456ab (tag: E) add hello.h
  3488f2c (tag: D) move .gitignore outside also works.
  b3af728 (tag: C) ignore object files.
  d71ce92 (tag: hello_1.0, tag: B) Hello world initialized.
  c024f34 (tag: A) README is from welcome.txt.

**现在演出第一幕：干掉坏蛋D**

* 执行交互式变基操作。

  ::

    $ git rebase -i D^

* 自动用编辑器修改文件。文件内容如下：

  ::

    pick 3488f2c move .gitignore outside also works.
    pick 48456ab add hello.h
    pick b6f0b0a modify hello.h

    # Rebase b3af728..b6f0b0a onto b3af728
    #
    # Commands:
    #  p, pick = use commit
    #  r, reword = use commit, but edit the commit message
    #  e, edit = use commit, but stop for amending
    #  s, squash = use commit, but meld into previous commit
    #  f, fixup = like "squash", but discard this commit's log message
    #  x <cmd>, exec <cmd> = Run a shell command <cmd>, and stop if it fails
    #
    # If you remove a line here THAT COMMIT WILL BE LOST.
    # However, if you remove everything, the rebase will be aborted.
    #

* 将第一行删除，使得上面的配置文件看起来像是这样（省略井号开始的注释）：

  ::

    pick 48456ab add hello.h
    pick b6f0b0a modify hello.h

* 保存退出。

* 变基自动开始，即刻完成。

  显示下面的内容。

  ::

    Successfully rebased and updated refs/heads/master.

* 看看日志。当前分支master已经完成变基，消灭了“坏蛋D”。

  ::

    $ git log --oneline --decorate -6
    78e5133 (HEAD, master) modify hello.h
    11eea7e add hello.h
    b3af728 (tag: C) ignore object files.
    d71ce92 (tag: hello_1.0, tag: B) Hello world initialized.
    c024f34 (tag: A) README is from welcome.txt.
    63992f0 restore file: welcome.txt

**幕布拉上，后台重新布景**

为了第二幕能够顺利演出，需要将master分支重新置回到提交F上。执行下面的操\
作完成“重新布景”。

::

  $ git checkout master
  Already on 'master'
  $ git reset --hard F
  HEAD is now at b6f0b0a modify hello.h

布景完毕，大幕即将再次拉开。

**现在演出第二幕：坏蛋D被感化，融入社会**

* 同样执行交互式变基操作，不过因为要将C和D压缩为一个，因此变基从C的\
  父提交开始。

  ::

    $ git rebase -i C^

* 自动用编辑器修改文件。文件内容如下（忽略井号开始的注释）：

  ::

    pick b3af728 ignore object files.
    pick 3488f2c move .gitignore outside also works.
    pick 48456ab add hello.h
    pick b6f0b0a modify hello.h

* 修改第二行（提交D），将动作由\ ``pick``\ 修改为\ ``squash``\ 。

  修改后的内容如下：

  ::

    pick b3af728 ignore object files.
    squash 3488f2c move .gitignore outside also works.
    pick 48456ab add hello.h
    pick b6f0b0a modify hello.h

* 保存退出。
* 自动开始变基操作，在执行到\ ``squash``\ 命令设定的提交时，进入提交前的\
  日志编辑状态。

  显示的待编辑日志如下。很明显C和D的提交说明显示在了一起。

  ::

    # This is a combination of 2 commits.
    # The first commit's message is:

    ignore object files.

    # This is the 2nd commit message:

    move .gitignore outside also works.

* 保存退出，即完成\ ``squash``\ 动作标识的提交以及后续变基操作。
* 看看提交日志，看到提交C和提交D都不见了，代之以一个融合后的提交。

  ::

    $ git log --oneline --decorate -6
    c0c2a1a (HEAD, master) modify hello.h
    c1e8b66 add hello.h
    db512c0 ignore object files.
    d71ce92 (tag: hello_1.0, tag: B) Hello world initialized.
    c024f34 (tag: A) README is from welcome.txt.
    63992f0 restore file: welcome.txt

* 可以看到融合C和D的提交日志实际上是两者日志的融合。在前面单行显示的日志\
  中看不出来。

  ::

    $ git cat-file -p HEAD^^
    tree 00239a5d0daf9824a23cbf104d30af66af984e27
    parent d71ce9255b3b08c718810e4e31760198dd6da243
    author Jiang Xin <jiangxin@ossxp.com> 1291720899 +0800
    committer Jiang Xin <jiangxin@ossxp.com> 1292153393 +0800

    ignore object files.

    move .gitignore outside also works.

时光旅行结束了，多么神奇的Git啊。

丢弃历史
========

历史有的时候会成为负担。例如一个人使用的版本库有一天需要作为公共版本库多\
人共享，最早的历史可能不希望或者没有必要继续保持存在，需要一个抛弃部分早\
期历史提交的精简的版本库用于和他人共享。再比如用Git做文件备份，不希望备\
份的版本过多导致不必要的磁盘空间占用，同样会有精简版本的需要：只保留最近\
的100次提交，抛弃之前的历史提交。那么应该如何操作呢？

使用交互式变基当然可以完成这样的任务，但是如果历史版本库有成百上千个，把\
成百上千个版本的变基动作有\ ``pick``\ 修改为\ ``fixup``\ 可真的很费事，\
实际上Git有更简便的方法。

现在DEMO版本库有如下的提交记录：

::

  $ git log --oneline --decorate 
  c0c2a1a (HEAD, master) modify hello.h
  c1e8b66 add hello.h
  db512c0 ignore object files.
  d71ce92 (tag: hello_1.0, tag: B) Hello world initialized.
  c024f34 (tag: A) README is from welcome.txt.
  63992f0 restore file: welcome.txt
  7161977 delete trash files. (using: git add -u)
  2b31c19 (tag: old_practice) Merge commit 'acc2f69'
  acc2f69 commit in detached HEAD mode.
  4902dc3 does master follow this new commit?
  e695606 which version checked in?
  a0c641e who does commit?
  9e8a761 initialized.

如果希望把里程碑A（c024f34）之前的历史提交历史全部清除可以如下进行操作。

* 查看里程碑A指向的目录树。

  用\ ``A^{tree}``\ 语法访问里程碑A对应的目录树。

  ::

    $ git cat-file -p A^{tree}
    100644 blob 51dbfd25a804c30e9d8dc441740452534de8264b    README

* 使用\ ``git commit-tree``\ 命令直接从该目录树创建提交。

  ::

    $ echo "Commit from tree of tag A." | git commit-tree A^{tree}
    8f7f94ba6a9d94ecc1c223aa4b311670599e1f86

* 命令\ ``git commit-tree``\ 的输出是一个提交的SHA1哈希值。查看这个提交。

  会发现这个提交没有历史提交，可以称之为孤儿提交。

  ::

    $ git log 8f7f94ba6a9d94ecc1c223aa4b311670599e1f86
    commit 8f7f94ba6a9d94ecc1c223aa4b311670599e1f86
    Author: Jiang Xin <jiangxin@ossxp.com>
    Date:   Mon Dec 13 14:17:17 2010 +0800

        Commit from tree of tag A.

* 执行变基，将master分支从里程碑到最新的提交全部迁移到刚刚生成的孤儿提交上。

  ::

    $ git rebase --onto 8f7f94ba6a9d94ecc1c223aa4b311670599e1f86 A master
    First, rewinding head to replay your work on top of it...
    Applying: Hello world initialized.
    Applying: ignore object files.
    Applying: add hello.h
    Applying: modify hello.h

* 查看日志看到当前master分支的历史已经精简了。

  ::

    $ git log --oneline --decorate
    2584639 (HEAD, master) modify hello.h
    30fe8b3 add hello.h
    4dd8a65 ignore object files.
    5f2cae1 Hello world initialized.
    8f7f94b Commit from tree of tag A.

使用图形工具查看提交历史，会看到两棵树：最上面的一棵树是刚刚通过变基抛弃\
了大部分历史提交的新的master分支，下面的一棵树则是变基前的提交形成的。下\
面的一棵树之所以还能够看到，或者说还没有从版本库中彻底清除，是因为有部分\
提交仍带有里程碑标签。

.. figure:: /images/git-solo/git-rebase-purge-history-graph.png
   :scale: 90

反转提交
========

前面介绍的操作都涉及到对历史的修改，这对于一个人使用Git没有问题，但是如\
果多人协同就会有问题了。多人协同使用Git，在本地版本库做的提交会通过多人\
之间的交互成为他人版本库的一部分，更改历史操作只能是针对自己的版本库，而\
无法去修改他人的版本库，正所谓“覆水难收”。在这种情况下要想修正一个错误历\
史提交的正确做法是反转提交，即重新做一次新的提交，相当于错误的历史提交的\
反向提交，修正错误的历史提交。

Git反向提交命令是:\ :command:`git revert`\ ，下面在DEMO版本库中实践一下。\
注意：Subversion的用户不要想当然的和\ :command:`svn revert`\ 命令对应，\
这两个版本控制系统中的\ ``revert``\ 命令的功能完全不相干。

当前DEMO版本库最新的提交包含如下改动：

::

  $ git show HEAD
  commit 25846394defe16eab103b92efdaab5e46cc3dc22
  Author: Jiang Xin <jiangxin@ossxp.com>
  Date:   Sun Dec 12 12:11:00 2010 +0800

      modify hello.h

  diff --git a/README b/README
  index 51dbfd2..ceaf01b 100644
  --- a/README
  +++ b/README
  @@ -1,3 +1,4 @@
   Hello.
   Nice to meet you.
   Bye-Bye.
  +Wait...
  diff --git a/src/hello.h b/src/hello.h
  index 0043c3b..6e482c6 100644
  --- a/src/hello.h
  +++ b/src/hello.h
  @@ -1 +1,2 @@
   /* test */
  +/* end */

在不改变这个提交的前提下对其修改进行撤销，就需要用到\ ``git revert``\
反转提交。

::

  $ git revert HEAD

运行该命令相当于将HEAD提交反向再提交一次，在提交说明编辑状态下暂停，显示\
如下（注释行被忽略）：

::

  Revert "modify hello.h"

  This reverts commit 25846394defe16eab103b92efdaab5e46cc3dc22.

可以在编辑器中修改提交说明，提交说明编辑完毕保存退出则完成反转提交。查看\
提交日志可以看到新的提交相当于所撤销提交的反向提交。

::

  $ git log --stat -2
  commit 6e6753add1601c4efa7857ab4c5b245e0e161314
  Author: Jiang Xin <jiangxin@ossxp.com>
  Date:   Mon Dec 13 15:19:12 2010 +0800

      Revert "modify hello.h"
      
      This reverts commit 25846394defe16eab103b92efdaab5e46cc3dc22.

   README      |    1 -
   src/hello.h |    1 -
   2 files changed, 0 insertions(+), 2 deletions(-)

  commit 25846394defe16eab103b92efdaab5e46cc3dc22
  Author: Jiang Xin <jiangxin@ossxp.com>
  Date:   Sun Dec 12 12:11:00 2010 +0800

      modify hello.h

   README      |    1 +
   src/hello.h |    1 +
   2 files changed, 2 insertions(+), 0 deletions(-)
