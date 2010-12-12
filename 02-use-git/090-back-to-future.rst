改变历史
********

我是《回到未来》的粉丝，偶尔会做梦，梦见穿梭到未来拿回一本2000-2050体育年鉴。操作Git可以体验到穿梭时空的感觉，Git像极了一个时光机器，不但允许你在历史中穿梭，而且能够改变历史。

在本章的最开始，TODO

悔棋
====

在日常的Git操作中，会经常出现这样的状况，输入 git commit 命令刚刚敲下回车键就后悔了：可能是提交说明中出现了错别字，或者有文件忘记提交，或者有的修改不应该提交，诸如此类。

像Subversion那样的集中式版本控制系统是“落子无悔”的系统，只能叹一口气责怪自己太不小心了。然后根据实际情况弥补：马上做一次新提交改正前面的错误；或者只能将错就错：错误的提交说明就让它一直错下去吧，因为大部分Subversion管理员不敢或者不会放开修改提交说明的功能导致无法对提交说明进行修改。

Git提供了“悔棋”的操作，甚至因为“单步悔棋”是如此经常的发生，乃至于Git提供了一个简洁的操作 —— 修补式提交，命令是："git commit --amend" 。

看看当前版本库最新的两次提交：

::

  cd /my/workspace/demo
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

最新一次的提交是的确是在“实践八”中使用 qgit 进行的提交，但这和提交内容无关，因此需要改掉这个提交的提交说明。使用下面的命令即可做到。

::

  $ git commit --amend -m "Remove hello.h, which is useless."
  [master 7857772] Remove hello.h, which is useless.
   2 files changed, 1 insertions(+), 2 deletions(-)
   delete mode 100644 src/hello.h

上面的命令使用了 "-m" 参数是为了演示的方便，实际上完全可以直接输入 "git commit --amend" ，在弹出的提交说明编辑界面修改提交说明，然后保存退出完成修补提交。

下面再看看最近两次的提交说明，可以看到最新的提交说明更改了（包括提交的SHA1哈希值），而它的父提交（即前一次提交）没有改变。

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

如果最后一步操作不想删除文件 `src/hello.h` ，而只是想修改 `README` ，则可以按照下面的方法进行修补操作。

* 还原删除的 `src/hello.h` 文件。

  ::

    $ git checkout HEAD^ -- src/hello.h

* 此时查看状态，会看到 src/hello.h 被重新添加回暂存区。

  ::

    $ git status
    # On branch master
    # Changes to be committed:
    #   (use "git reset HEAD <file>..." to unstage)
    #
    #       new file:   src/hello.h
    #

* 执行修补提交，不过提交说明是不是也要更改呢，因为毕竟这次提交不会删除文件了。

  ::

    $ git commit --amend -m "commit with --amend test."
    [master 2b45206] commit with --amend test.
     1 files changed, 1 insertions(+), 0 deletions(-)

* 再次查看最近两次提交，会发现最新的提交不再删除文件 `src/hello.h` 了。

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

Git的重置命令是提供悔棋能力的奥秘，实际上上面介绍的单步悔棋也可以用重置命令来实现，只不过Git提供了一个更好用的简洁的命令而已。多步悔棋顾名思义就是可以取消最新连续的多次提交，多次悔棋并非是所有分布式版本控制系统都具有的功能，像 Mercurial/Hg 只能对最新提交悔棋一次（除非使用MQ插件）。Git因为有了强大的重置命令，可以悔棋任意多次。

多步悔棋会在什么场合用到呢？软件开发中针对某个特性功能的开发就是一例。某个开发工程师领受某个特性开发的任务，于是在本地版本库进行了一系列开发、测试、修补、再测试的流程，最终特性功能开发完毕后可能在版本库中留下了多次提交。在将本地版本库改动推送（PUSH）到团队协同工作的核心版本库时，这个开发人员就想用多步悔棋的操作，将多个试验性的提及合为一个完整的提交。

以试验版本库为例，看看版本库最近的三次提交。

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

想要将最近的两个提交合并为一个，并把提交说明改为："modify hello.h"，可以使用如下方法进行操作。

* 使用 "--soft" 参数调用重置命令，回到最近两次提交之前。

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

* 执行提交操作，即完成最新两个提交合并为一个提交的操作。

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

电影《回到未来》（Back to future）第二集，老Biff偷走时光车，到过去（1955年）给了小Biff一本书，导致未来大变。

.. figure:: images/back-to-future/back-to-future.png
   :scale: 70

   布朗博士正在解释为何产生两个平行的未来

Git也有这样的能力，或者说也会具有这样的行为。当更改历史提交（SHA1哈希值变更），即使后续提交的内容和属性都一致，但是因为后续提交中有一个属性要包含其父提交的SHA1哈希值，所以会导致所有后续提交必然的发生变化，就会形成两条平行的时间线：一个是变更前的提交时间线，另外一条是更改历史后新的提交时间线。

把此次实践比喻做一次电影（回到未来）拍摄的话，舞台依然是之前的实践版本库，而剧本是这样的。

* 角色：最近的六次提交。分别依据提交顺序，编号为 A, B, C, D, E, F。

  ::

    $ git log --oneline -6
    b6f0b0a modify hello.h                        # F
    48456ab add hello.h                           # E
    3488f2c move .gitignore outside also works.   # D
    b3af728 ignore object files.                  # C
    d71ce92 Hello world initialized.              # B
    c024f34 README is from welcome.txt.           # A

* 坏蛋：提交D。

  即对 .gitignore 文件移动的提交不再需要，或者这个提交将和前一次提交（C）合并。

* 前奏：故事人物依次出场，坏蛋 D 在图中被特殊标记。

  .. figure:: images/gitbook/git-rebase-orig.png
     :scale: 100

* 第一幕：抛弃提交 D，将正确的提交 E 和 F 重新“嫁接”到提交 C 上，最终坏蛋被消灭。

  .. figure:: images/gitbook/git-rebase-c.png
     :scale: 100

* 第二幕：坏蛋 D 被 C 感化，融合为 "CD" 复合体，E 和 F 重新“嫁接”到"CD"复合体上，最终大团圆结局。

  .. figure:: images/gitbook/git-rebase-cd.png
     :scale: 100

* 道具：分别使用三辆不同的时光车来完成“回到未来”。

  分别是：核能跑车，生物能飞车，飞行的火车。

第一版的时光旅行车
-------------------

布朗博士的第一版本时光旅行车是一款跑车，使用核燃料：钚。而此次实践使用的工具也没有太出乎想像，使用一条新的指令 "git cherry-pick" 实现提交在新的分支上“重放”。 

命令 git cherry-pick 需要提供一个提交作为参数，会将该提交导出为补丁文件，然后在当前HEAD上重放形成无论内容还是提交说明都一致的提交。

首先对版本库要“参演”的角色进行标记，使用尚未正式介绍的命令 "git tag"（无非就是在特定命名空间建立的引用，用于对提交的标识）。

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

* 执行 git checkout 命令，暂时将头指针切换到 C。

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

* 执行 git cherry-pick 将 E 提交在当前 HEAD 上重放。

  因为 E 和 master^ 显然指向同一角色，因此可以用下面的语法。

  ::

    $ git cherry-pick master^
    [detached HEAD fa0b076] add hello.h
     1 files changed, 1 insertions(+), 0 deletions(-)
     create mode 100644 src/hello.h

* 执行 git cherry-pick 将 F 提交在当前 HEAD 上重放。

  F 和 master 也具有相同指向。

  ::

    $ git cherry-pick master
    [detached HEAD f677821] modify hello.h
     2 files changed, 2 insertions(+), 0 deletions(-)

* 通过日志可以看到坏蛋 D 已经不在了。

  ::

    $ git log --oneline --decorate -6
    f677821 (HEAD) modify hello.h
    fa0b076 add hello.h
    b3af728 (tag: C) ignore object files.
    d71ce92 (tag: hello_1.0, tag: B) Hello world initialized.
    c024f34 (tag: A) README is from welcome.txt.
    63992f0 restore file: welcome.txt

* 通过日志还可以看出来，最新两次提交的原始创作日期（AuthorDate）和提交日期（CommitDate）不同。

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

* 最重要的一步操作，就是要将 master 分支指向新的提交 ID（f677821）上。

  下面的切换操作使用了reflog的语法，即 HEAD@{1} 相当于切换回 master 分支前的HEAD指向，即 f677821。

  ::

    $ git checkout master
    Previous HEAD position was f677821... modify hello.h
    Switched to branch 'master'
    $ git reset --hard HEAD@{1}
    HEAD is now at f677821 modify hello.h

* 使用 qgit 查看版本库提交历史。

  .. figure:: images/gitbook/git-rebase-graph.png
     :scale: 80

**幕布拉上，后台重新布景**

为了第二幕能够顺利演出，需要将 master 分支重新置回到提交 F 上。执行下面的操作完成“重新布景”。

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

* 执行 git checkout 命令，暂时将头指针切换到坏蛋 D。

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

* 执行提交，提交说明重用 C 提交的提交说明。

  ::

    $ git commit -C C
    [detached HEAD 53e621c] ignore object files.
     1 files changed, 3 insertions(+), 0 deletions(-)
     create mode 100644 .gitignore

* 执行 git cherry-pick 将 E 提交在当前 HEAD 上重放。

  ::

    $ git cherry-pick E
    [detached HEAD 1f99f82] add hello.h
     1 files changed, 1 insertions(+), 0 deletions(-)
     create mode 100644 src/hello.h


* 执行 git cherry-pick 将 F 提交在当前 HEAD 上重放。

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

* 最重要的一步操作，就是要将 master 分支指向新的提交 ID（f677821）上。

  下面的切换操作使用了reflog的语法，即 HEAD@{1} 相当于切换回 master 分支前的HEAD指向，即 f677821。

  ::

    $ git checkout master
    Previous HEAD position was 2f13d3a... modify hello.h
    Switched to branch 'master'
    $ git reset --hard HEAD@{1}
    HEAD is now at 2f13d3a modify hello.h

* 使用 gitk 查看版本库提交历史。

  .. figure:: images/gitbook/git-rebase-graph-gitk.png
     :scale: 80

**别忘了后台的重新布景**

为了使用第二版的时光旅行车，需要重新布景，将 master 分支重新置回到提交 F 上。

::

  $ git checkout master
  Already on 'master'
  $ git reset --hard F
  HEAD is now at b6f0b0a modify hello.h

第二版的时光旅行车
------------------

布朗博士的第二版本时光旅行车采用了未来科技，可以飞天，而且燃料不再依赖核物质，而是使用无所不在的生活垃圾。而此次实践使用的工具也进行了升级，采用强大的 "git rebase" 命令。

命令 "git rebase" 是对提交执行变基操作，即可以实现将指定范围的提交“嫁接”到另外一个提交之上。其常用的命令行格式有：

::

  用法1: git rebase  --onto  <newbase>  <since>      <till>
  用法2: git rebase  --onto  <newbase>  <since>
  用法3: git rebase          <newbase>               <till>
  用法4: git rebase          <newbase>
  用法5: git rebase -i ...
  用法6: git rebase --continue
  用法7: git rebase --skip
  用法8: git rebase --abort

不要被上面的语法吓到，首先后四种用法，本节还用不到：

* 用法5是进入交互模式（在第三版时光车予以介绍）。
* 用法6是在变基遇到冲突而暂停后，当完成冲突解决后，恢复变基操作的时候使用。
* 用法7是在变基遇到冲突而暂停后，跳过当前提交的时候使用。
* 用法8是在变基遇到冲突后，终止变基操作，回到之前的分支时候使用。

而前四个用法如果把省略的参数补上（方括号内是省略掉的参数），看起来就都和用法1就一致了。

::

  用法1: git rebase  --onto  <newbase>  <since>      <till>
  用法2: git rebase  --onto  <newbase>  <since>      [HEAD]
  用法3: git rebase [--onto] <newbase>  [<newbase>]  <till>
  用法4: git rebase [--onto] <newbase>  [<newbase>]  [HEAD]

下面就介绍一下 "git rebase" 的用法。命令格式：

::

  git rebase  --onto  <newbase>  <since>      <till>

变基操作的过程：

* 首先会将 <since>..<till> 所标识的提交范围写到一个临时文件中。

  还记得前面介绍的版本范围语法，<since>..<till> 是指包括 <till> 的所有历史提交排除 <since> 以及 <since> 的历史提交后形成的版本范围。

* 当前分支强制重置（git reset --hard）到 <newbase>。

  相当于执行： git reset --hard <newbase> 。

* 从保存在临时文件中的提交列表中，一个一个将提交按照顺序重新提交到重置之后的分支上。

* 如果遇到提交已经在分支中包含，跳过该提交。

* 如果在提交过程遇到冲突，变基过程暂停。用户解决冲突后，执行 git rebase --continue 继续变基操作。或者执行 git rebase --skip 跳过此提交。或者执行 git rebase --abort 就此终止变基操作切换到变基前的分支上。

很显然为了执行将 E 和 F 提交跳过提价 D，“嫁接”到 C 提交上。可以如此执行变基命令：

::

  git rebase --onto C E^ F

因为 E^ 等价于 D，并且 F 和当前 HEAD 指向相同，因此可以这样操作：

::

  git rebase --onto C D

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

  ::

    $  git rebase --onto C E^ F
    First, rewinding head to replay your work on top of it...
    Applying: add hello.h
    Applying: modify hello.h

* 最后一步必需的操作，就是要将 master 分支指向变基后的提交上。

  下面的切换操作使用了reflog的语法，即 HEAD@{1} 相当于切换回 master 分支前的HEAD指向，即 f677821。

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

为了第二幕能够顺利演出，需要将 master 分支重新置回到提交 F 上。执行下面的操作完成“重新布景”。

::

  $ git checkout master
  Already on 'master'
  git reset --hard F
  HEAD is now at b6f0b0a modify hello.h

布景完毕，大幕即将再次拉开。

**现在演出第二幕：坏蛋D被感化，融入社会**

* 执行 git checkout 命令，暂时将头指针切换到坏蛋 D。

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

* 执行提交，提交说明重用 C 提交的提交说明。

  ::

    $ git commit -C C
    [detached HEAD 5444832] ignore object files.
     1 files changed, 3 insertions(+), 0 deletions(-)
     create mode 100644 .gitignore

* 记住这个提交ID: 5444832。

  用里程碑是最好的记忆提交ID的方法：

  ::

    $ git tag newbase
    $ git rev-parse newbase
    5444832753841f9dc1a7a92a9338a0862a198dd5

* 执行变基操作，将 E 和 F 提交“嫁接”到 newbase 上。

  ::

    $  git rebase --onto newbase E^ F
    First, rewinding head to replay your work on top of it...
    Applying: add hello.h
    Applying: modify hello.h

* 看看提交日志，看到提交 C 和提交 D 都不见了，代之以融合后的提交 newbase。

  ::

    $ git log --oneline --decorate -6
    cb7f310 (HEAD) modify hello.h
    c6b193d add hello.h
    5444832 (tag: newbase) ignore object files.
    d71ce92 (tag: hello_1.0, tag: B) Hello world initialized.
    c024f34 (tag: A) README is from welcome.txt.
    63992f0 restore file: welcome.txt

* 很显然还需要将 master 重置到当前的 HEAD 上。

  ::

    $ git checkout master
    Previous HEAD position was cb7f310... modify hello.h
    Switched to branch 'master'
    $ git reset --hard HEAD@{1}
    HEAD is now at cb7f310 modify hello.h

* 清理一下，然后收工。

  前面的操作中为了方便创建了标识提交的新里程碑 newbase，将这个里程碑现在没有什么用处了删除吧。

  ::

    $ git tag -d newbase
    Deleted tag 'newbase' (was 5444832)

**别忘了后台的重新布景**

为了使用第三版的时光旅行车，需要重新布景，将 master 分支重新置回到提交 F 上。

::

  $ git checkout master
  Already on 'master'
  $ git reset --hard F
  HEAD is now at b6f0b0a modify hello.h

第三版的时光旅行车
------------------

布朗博士的第三版本时光旅行车（飞行火车，燃料：有机肥料）


Step 10: 反删除和恢复
========================

    有的时候改变历史并不合适。
        用户1的提交（图）
        被用户2获取
        用户2更改后的图
        用户1更改历史。
        用户1从用户2 pull，就导致历史重现。
    不求完美 但求卓越
        Git 允许人们犯错，是因为Git提供给人纠错的机会。
        Git 忠实的记录每一步操作，无论正确的操作和错误的操作。
        常常犯下的错误在版本控制来看，有哪些呢？
        添加了不该添加的数据。例如 .o 文件。曾经看过一个客户把 2G 的虚拟机文件检入版本库，最好用下章的方式删除
        删除了不该删除的文件。很简单，删除只是在最新版本中不出现，历史版本中尚在，恢复即是了。
        文件修改引入错误。还原就是了。
    恢复错误的删除
        直接添加就可以了。
        会导致版本中文件加倍么？
    恢复错误的添加
        为了避免错误的添加，使用文件忽略功能。
        需要彻底删除的文件 —— 核弹起爆密码，见下一章。
    恢复错误的修改
        revert 命令
        指向 revert 部分？不提交的 revert，然后 git add -p 。
    我们可以看到前面的反删除和恢复都是不改变历史的操作，但是要改变历史呢？

