历史穿梭
******************

经过了之前众多的实践，版本库中已经积累了很多次提交了，从下面的命令可以看\
出来有14次提交。

::

  $ git rev-list HEAD | wc -l
  14

有很多工具可以研究和分析Git的历史提交，在前面的实践中已经用过很多相关的\
Git命令进行查看历史提交、查看文件的历史版本、进行差异比较等。本章除了对\
之前用到的相关Git命令作以总结外，还要再介绍几款图形化的客户端。

图形工具：gitk
==============

gitk是最早实现的一个图形化的Git版本库浏览器软件，基于tcl/tk实现，因此gitk\
非常简洁，本身就是一个1万多行的tcl脚本写成的。gitk的代码已经和Git的代码\
放在同一个版本库中，gitk随Git一同发布，不用特别的安装即可运行。gitk可以\
显示提交的分支图，可以显示提交，文件，版本间差异等。

在版本库中调用gitk，就会浏览该版本库，显示其提交分支图。gitk可以像命令行\
工具一样使用不同的参数进行调用。

* 显示所有的分支。

  ::

    $ gitk --all

* 显示2周以来的提交。

  ::

    $ gitk --since="2 weeks ago"

* 显示某个里程碑（v2.6.12）以来，针对某些目录和文件\
  （\ :file:`include/scsi`\ 目录和\ :file:`drivers/scsi`\ 目录）的提交。

  ::

    $ gitk v2.6.12.. include/scsi drivers/scsi

下面的图示就是在DEMO版本库中运行\ :command:`gitk --all`\ 的显示。

.. figure:: /images/git-solo/gitk.png
   :scale: 80

在上图中可见不同颜色和形状区分的引用：

* 绿色的\ ``master``\ 分支。
* 黄色的\ ``hello_1.0``\ 和\ ``old_practice``\ 里程碑。
* 灰色的\ ``stash``\ 。

gitk使用tcl/tk开发，在显示上没有系统中原生图形应用那么漂亮的界面，甚至\
可以用丑陋来形容，下面介绍的gitg和qgit在易用性上比gitk进步了不少。

图形工具：gitg
================

\ ``gitg``\ 是使用GTK+图形库实现的一个Git版本库浏览器软件。Linux下最著名\
的Gnome桌面环境使用的就是GTK+，因此在Linux下\ ``gitg``\ 有着非常漂亮的原\
生的图形界面。\ ``gitg``\ 不但能够实现gitk的全部功能，即浏览提交历史和文\
件，还能帮助执行提交。

在Linux上安装gitg很简单，例如在Debian或Ubuntu上，直接运行下面的命令就可\
以进行安装。

::

  $ sudo aptitude install gitg

安装完毕就可以在可执行路径中找到\ ``gitg``\ 。

::

  $ which gitg
  /usr/bin/gitg

为了演示\ ``gitg``\ 具备提交功能，先在工作区作出一些修改。

* 删除没有用到的\ :file:`hello.h`\ 文件。

  ::
  
    $ cd /path/to/my/workspace/demo
    $ rm src/hello.h

* 在\ :file:`README`\ 文件后面追加一行。

  ::

    $ echo "Wait..." >> README

* 当前工作区的状态。

  ::

    $ git status -s
     M README
     D src/hello.h

现在可以在工作区下执行\ ``gitg``\ 命令。

::

  $ gitg &

下图就是\ ``gitg``\ 的缺省界面，显示了提交分支图，以及选中提交的提交信息\
和变更文件列表等。

  .. figure:: /images/git-solo/gitg-history.png
     :scale: 75

在上图中可以看见用不同颜色的标签显示的状态标识（包括引用）：

* 橙色的\ ``master``\ 分支。
* 黄色的\ ``hello_1.0``\ 和\ ``old_practice``\ 里程碑。
* 粉色的\ ``stash``\ 标签。
* 以及白色的显示工作区非暂存状态的标签。

点击\ ``gitg``\ 下方窗口的标签“tree”，会显示此提交的目录树。

  .. figure:: /images/git-solo/gitg-tree.png
     :scale: 75

提交功能是\ ``gitg``\ 的一大特色。点击\ ``gitg``\ 顶部窗口的\ ``commit``\
标签，显示下面的界面。

  .. figure:: /images/git-solo/gitg-commit-1-all-unstaged.png
     :scale: 75

左下方窗口显示的是未更新到暂存区的本地改动。鼠标右击，在弹出菜单中选择\
“Stage”。

  .. figure:: /images/git-solo/gitg-commit-2-add-stage.png
     :scale: 75

当把文件\ :file:`README`\ 添加到暂存区后，可以看到\ :file:`README`\
文件出现在右下方的窗口中。

  .. figure:: /images/git-solo/gitg-commit-3-mixed-stage-unstage.png
     :scale: 75

此时如果回到提交历史查看界面，可以看到在“stash”标签的下方，同时出现了\
“staged”和“unstaged”两个标签分别表示暂存区和工作区的状态。

  .. figure:: /images/git-solo/gitg-commit-4-history-stage-unstage.png
     :scale: 75

当通过\ ``gitg``\ 的界面选择好要提交的文件（加入暂存区）之后，执行提交。

  .. figure:: /images/git-solo/gitg-commit-5-commit.png
     :scale: 75

上图的提交说明对话框的下方有两个选项，当选择了“Add signed-off-by”选项后，\
在提交日志中会自动增加相应的说明文字。下图可以看到刚刚的提交已经显示在\
提交历史的最顶端，在提交说明中出现了\ ``Signed-off-by``\ 文字说明。

  .. figure:: /images/git-solo/gitg-commit-6-new-history.png
     :scale: 75

``gitg``\ 还是一个比较新的项目，在本文撰写的时候，\ ``gitg``\ 才是0.0.6\
版本，相比下面要介绍的\ ``qgit``\ 还缺乏很多功能。例如\ ``gitg``\ 没有文\
件的blame（追溯）界面，也不能直接将文件检出，但是\ ``gitg``\ 整体的界面\
风格，以及易用的提交界面给人的印象非常深刻。

图形工具：qgit
==============

前面介绍的\ ``gitg``\ 是基于GTK+这一Linux标准的图形库，那么也许有读者已\
经猜到\ ``qgit``\ 是使用Linux另外一个著名的图形库QT实现的Git版本库浏览器\
软件。QT的知名度不亚于GTK+，是著名的KDE桌面环境用到的图形库，也是蓄势待\
发准备和Android一较高低的MeeGo的UI核心。\ ``qgit``\ 目前的版本是2.3，相比\
前面介绍的\ ``gitg``\ 其经历的开发周期要长了不少，因此也提供了更多的功能。

在Linux上安装\ ``qgit``\ 很简单，例如在Debian或Ubuntu上，直接运行下面的\
命令就可以进行安装。

::

  $ sudo aptitude install qgit

安装完毕就可以在可执行路径中找到\ ``qgit``\ 。

::

  $ which qgit
  /usr/bin/qgit

``qgit``\ 和\ ``gitg``\ 一样不但能够浏览提交历史和文件，还能帮助执行提交。\
为了测试提交，将在上一节所做的提交回滚。

* 使用重置命令回滚最后一次提交。

  ::
 
    $ git reset HEAD^
    Unstaged changes after reset:
    M       README
    M       src/hello.h


* 当前工作区的状态。

  ::

    $ git status
    # On branch master
    # Changed but not updated:
    #   (use "git add/rm <file>..." to update what will be committed)
    #   (use "git checkout -- <file>..." to discard changes in working directory)
    #
    #       modified:   README
    #       deleted:    src/hello.h
    #
    no changes added to commit (use "git add" and/or "git commit -a")
 
现在可以在工作区下执行\ ``qgit``\ 命令。

::

  $ qgit &

启动\ ``qgit``\ ，首先弹出一个对话框，提示对显示的提交范围和分支范围进行选择。

  .. figure:: /images/git-solo/qgit-splash-select.png
     :scale: 100

对所有的选择打钩，显示下面的\ ``qgit``\ 的缺省界面。其中包括了提交分支图，\
以及选中提交的提交信息和变更文件列表等。

  .. figure:: /images/git-solo/qgit-history.png
     :scale: 75

在上图中可以看见用不同颜色的标签显示的状态标识（包括引用）：

* 绿色的\ ``master``\ 分支。
* 黄色的\ ``hello_1.0``\ 和\ ``old_practice``\ 里程碑。
* 灰色的\ ``stash``\ 标签，显示在了创建时候的位置，并其包含的针对暂存区\
  状态的提交也显示出来。
* 最顶端显示一行绿色背景的文件：工作区有改动。

``qgit``\ 的右键菜单非常丰富，上图显示了鼠标右击提交时显示的弹出菜单，\
可以创建、切换标签或分支，可以将提交导出为补丁文件。

点击\ ``qgit``\ 右下方变更文件列表窗口，可以选择将文件检出或者直接查看。

  .. figure:: /images/git-solo/qgit-changefiles.png
     :scale: 75

要想显示目录树，键入大写字母\ ``T``\ ，或者鼠标单击工具条上的图标\
|QGIT-TREE-TOGGLE|\ ，就会在左侧显示目录树窗口，如下。

  .. figure:: /images/git-solo/qgit-tree-view.png
     :scale: 75

.. |QGIT-TREE-TOGGLE| image:: /images/git-solo/icon-11-12-qgit-tree-toggle.png

从上图也可以看到目录树的文件包含的右键菜单。当选择查看一个文件时，会显示\
此文件的追溯，即显示每一行是在哪个版本由谁修改的。追溯窗口见下图右下方窗口。

  .. figure:: /images/git-solo/qgit-blame.png
     :scale: 75

``qgit``\ 也可以执行提交。选中\ ``qgit``\ 顶部窗口最上一行\
“Working dir changes”，鼠标右击，显示的弹出菜单包含了“Commit...”选项。

  .. figure:: /images/git-solo/qgit-commit-1-revlist.png
     :scale: 75

点击弹出菜单中的“Commit...”，显示下面的对话框。

  .. figure:: /images/git-solo/qgit-commit-2-dialog-unstaged.png
     :scale: 75

自动选中了所有的文件。上方窗口的选中文件目前状态是“Not updated in index”，\
就是说尚未添加到暂存区。

使用\ ``qgit``\ 做提交，只要选择好要提交的文件列表，即使未添加到暂存区，\
也可以直接提交。在下方的提交窗口写入提交日志，点击“Commit”按钮开始提交。

  .. figure:: /images/git-solo/qgit-commit-3-commit-unstaged.png
     :scale: 75

提交完毕返回\ ``qgit``\ 主界面，在显示的提交列表的最上方，原来显示的\
“Working dir changes”已经更新为“Nothing to commit”，并且可以看到刚刚的提交\
已经显示在提交历史的最顶端。

  .. figure:: /images/git-solo/qgit-commit-4-revlist.png
     :scale: 75


命令行工具
==============

上面介绍的几款图形界面的Git版本库浏览器最大的特色就是更好看的提交关系图，\
还能非常方便的浏览历史提交的目录树，并从历史提交的目录树中提取文件等。\
这些操作对于Git命令行同样可以完成。使用Git命令行探索版本库历史对于读者来\
说并不新鲜，因为在前几章的实践中已经用到了相关命令，展示了对历史记录的操\
作。本节对这些命令的部分要点进行强调和补充。

前面历次实践的提交基本上是线性的提交，研究起来没有挑战性。为了能够更加接\
近于实际又不失简洁，我构造了一个版本库，放在了Github上。可以通过如下操作\
在本地克隆这个示例版本库。

::

  $ cd /path/to/my/workspace/
  $ git clone git://github.com/ossxp-com/gitdemo-commit-tree.git
  Cloning into gitdemo-commit-tree...
  remote: Counting objects: 63, done.
  remote: Compressing objects: 100% (51/51), done.
  remote: Total 63 (delta 8), reused 0 (delta 0)
  Receiving objects: 100% (63/63), 65.95 KiB, done.
  Resolving deltas: 100% (8/8), done.
  $ cd gitdemo-commit-tree

运行\ ``gitg``\ 命令，显示其提交关系图。

.. figure:: /images/git-solo/gitg-demo-commit-tree.png
   :scale: 100

是不是有点“乱花渐欲迷人眼”的感觉。如果把提交用里程碑标识的圆圈来代表，稍\
加排列就会看到下面的更为直白的提交关系图。

.. figure:: /images/git-solo/commit-tree.png
   :scale: 100

Git的大部分命令可以使用提交版本作为参数（如：\
:command:`git diff <commit-id>`\ ），有的命令则使用一个版本范围作为参数\
（如：\ :command:`git log <rev1>..<rev2>`\ ）。Git的提交有着各式各样的\
表示法，提交范围也是一样，下面就通过两个命令\ :command:`git rev-parse`\
和\ :command:`git rev-list`\ 分别研究一下Git的版本表示法和版本范围表示法。

版本表示法：\ :command:`git rev-parse`
------------------------------------------

命令\ :command:`git rev-parse`\ 是Git的一个底层命令，其功能非常丰富\
（或者说杂乱），很多Git脚本或工具都会用到这条命令。

此命令的部分应用在“Git初始化”章节中就已经看到。例如可以显示Git版本库的\
位置（\ ``--git-dir``\ ），当前工作区目录的深度（\ ``--show-cdup``\ ），\
甚至可以用于被Git无关应用用于解析命令行参数（\ ``--parseopt``\ ）。

此命令可以显示当前版本库中的引用。

* 显示分支。

  ::

    $ git rev-parse --symbolic --branches

* 显示里程碑。

  ::

    $ git rev-parse --symbolic --tags
    A
    B
    C
    D
    E
    F
    G
    H
    I
    J

* 显示定义的所有引用。

  其中\ :file:`refs/remotes/`\ 目录下的引用成为远程分支（或远程引用），\
  在后面的章节会予以介绍。

  ::

    $ git rev-parse --symbolic --glob=refs/*
    refs/heads/master
    refs/remotes/origin/HEAD
    refs/remotes/origin/master
    refs/tags/A
    refs/tags/B
    refs/tags/C
    refs/tags/D
    refs/tags/E
    refs/tags/F
    refs/tags/G
    refs/tags/H
    refs/tags/I
    refs/tags/J

命令\ :command:`git rev-parse`\ 另外一个重要的功能就是将一个Git对象表达式\
表示为对应的SHA1哈希值。针对本节开始克隆的版本库\ ``gitdemo-commit-tree``\ ，\
做如下操作。

* 显示HEAD对应的SHA1哈希值。

  ::

    $ git rev-parse  HEAD
    6652a0dce6a5067732c00ef0a220810a7230655e

* 命令\ :command:`git describe`\ 的输出也可以显示为SHA1哈希值。

  ::

    $ git describe
    A-1-g6652a0d
    $ git rev-parse A-1-g6652a0d
    6652a0dce6a5067732c00ef0a220810a7230655e

* 可以同时显示多个表达式的SHA1哈希值。

  下面的操作可以看出master和refs/heads/master都可以用于指代master分支。

  ::

    $ git rev-parse  master  refs/heads/master
    6652a0dce6a5067732c00ef0a220810a7230655e
    6652a0dce6a5067732c00ef0a220810a7230655e

* 可以用哈希值的前几位指代整个哈希值。

  ::

    $ git rev-parse  6652  6652a0d
    6652a0dce6a5067732c00ef0a220810a7230655e
    6652a0dce6a5067732c00ef0a220810a7230655e

* 里程碑的两种表示法均指向相同的对象。

  里程碑对象不一定是提交，有可能是一个Tag对象。Tag对象包含说明或者签名，\
  还包括到对应提交的指向。

  ::

    $ git rev-parse  A  refs/tags/A
    c9b03a208288aebdbfe8d84aeb984952a16da3f2
    c9b03a208288aebdbfe8d84aeb984952a16da3f2

* 里程碑A指向了一个Tag对象而非提交的时候，用下面的三个表示法都可以指向\
  里程碑对应的提交。

  实际上下面的语法也可以直接作用于轻量级里程碑（直接指向提交的里程碑）\
  或者作用于提交本身。

  ::

    $ git rev-parse  A^{}  A^0  A^{commit}
    81993234fc12a325d303eccea20f6fd629412712
    81993234fc12a325d303eccea20f6fd629412712
    81993234fc12a325d303eccea20f6fd629412712

* ``A``\ 的第一个父提交就是\ ``B``\ 所指向的提交。

  回忆之前的介绍，\ ``^``\ 操作符代表着父提交。当一个提交有多个父提交时，\
  可以通过在符号\ ``^``\ 后面跟上一个数字表示第几个父提交。\ ``A^``\  就\
  相当于 \ ``A^1``\ 。而\ ``B^0``\ 代表了\ ``B``\ 所指向的一个Commit对象\
  （因为\ ``B``\ 是Tag对象）。

  ::

    $ git rev-parse  A^  A^1  B^0
    776c5c9da9dcbb7e463c061d965ea47e73853b6e
    776c5c9da9dcbb7e463c061d965ea47e73853b6e
    776c5c9da9dcbb7e463c061d965ea47e73853b6e

* 更为复杂的表示法。

  连续的\ ``^``\ 符号依次沿着父提交进行定位至某一祖先提交。\ ``^``\
  后面的数字代表该提交的第几个父提交。

  ::

    $ git rev-parse  A^^3^2  F^2  J^{}
    3252fcce40949a4a622a1ac012cb120d6b340ac8
    3252fcce40949a4a622a1ac012cb120d6b340ac8
    3252fcce40949a4a622a1ac012cb120d6b340ac8

* 记号\ ``~<n>``\ 就相当于连续<n>个符号\ ``^``\ 。

  ::

    $ git rev-parse  A~3  A^^^  G^0
    e80aa7481beda65ae00e35afc4bc4b171f9b0ebf
    e80aa7481beda65ae00e35afc4bc4b171f9b0ebf
    e80aa7481beda65ae00e35afc4bc4b171f9b0ebf

* 显示里程碑A对应的目录树。下面两种写法都可以。

  ::

    $ git rev-parse  A^{tree}  A:
    95ab9e7db14ca113d5548dc20a4872950e8e08c0
    95ab9e7db14ca113d5548dc20a4872950e8e08c0


* 显示树里面的文件，下面两种表示法均可。

  ::

    $ git rev-parse  A^{tree}:src/Makefile  A:src/Makefile
    96554c5d4590dbde28183e9a6a3199d526eeb925
    96554c5d4590dbde28183e9a6a3199d526eeb925

* 暂存区里的文件和HEAD中的文件相同。

  ::

    $ git rev-parse  :gitg.png  HEAD:gitg.png
    fc58966ccc1e5af24c2c9746196550241bc01c50
    fc58966ccc1e5af24c2c9746196550241bc01c50

* 还可以通过在提交日志中查找字串的方式显示提交。

  ::

    $ git rev-parse :/"Commit A"
    81993234fc12a325d303eccea20f6fd629412712

* 再有就是reflog相关的语法，参见“Git重置”章节中关于reflog的介绍。

  ::

    $ git rev-parse HEAD@{0} master@{0}
    6652a0dce6a5067732c00ef0a220810a7230655e
    6652a0dce6a5067732c00ef0a220810a7230655e

版本范围表示法：git rev-list
----------------------------

有的Git命令可以使用一个版本范围作为参数，命令\ :command:`git rev-list`\
可以帮助研究Git的各种版本范围语法。

.. figure:: /images/git-solo/commit-tree-with-id.png
   :scale: 100

* 一个提交ID实际上就可以代表一个版本列表。含义是：该版本开始的所有历史提交。

  ::

    $ git rev-list --oneline  A 
    8199323 Commit A: merge B with C.
    0cd7f2e commit C.
    776c5c9 Commit B: merge D with E and F
    beb30ca Commit F: merge I with J
    212efce Commit D: merge G with H
    634836c commit I.
    3252fcc commit J.
    83be369 commit E.
    2ab52ad commit H.
    e80aa74 commit G.

* 两个或多个版本，相当于每个版本单独使用时指代的列表的并集。

  ::

    $ git rev-list --oneline  D  F
    beb30ca Commit F: merge I with J
    212efce Commit D: merge G with H
    634836c commit I.
    3252fcc commit J.
    2ab52ad commit H.
    e80aa74 commit G.

* 在一个版本前面加上符号（\ ``^``\ ）含义是取反，即排除这个版本及其历史版本。

  ::

    $ git rev-list --oneline  ^G D
    212efce Commit D: merge G with H
    2ab52ad commit H.

* 和上面等价的“点点”表示法。使用两个点连接两个版本，如\ ``G..D``\ ，\
  就相当于\ ``^G D``\ 。

  ::

    $ git rev-list --oneline  G..D
    212efce Commit D: merge G with H
    2ab52ad commit H.

* 版本取反，参数的顺序不重要，但是“点点”表示法前后的版本顺序很重要。

  * 语法：\ ``^B C``

    ::

      $ git rev-list --oneline  ^B C
      0cd7f2e commit C.

  * 语法：\ ``C ^B``

    ::

      $ git rev-list --oneline  C ^B
      0cd7f2e commit C.

  * 语法：\ ``B..C``\ 相当于\ ``^B C``

    ::

      $ git rev-list --oneline  B..C
      0cd7f2e commit C.

  * 语法：``C..B``\ 相当于\ ``^C B``

    ::

      $ git rev-list --oneline  C..B
      776c5c9 Commit B: merge D with E and F
      212efce Commit D: merge G with H
      83be369 commit E.
      2ab52ad commit H.
      e80aa74 commit G.

* 三点表示法的含义是两个版本共同能够访问到的除外。

  B和C共同能够访问到的F、I、J排除在外。

  ::

    $ git rev-list --oneline  B...C
    0cd7f2e commit C.
    776c5c9 Commit B: merge D with E and F
    212efce Commit D: merge G with H
    83be369 commit E.
    2ab52ad commit H.
    e80aa74 commit G.

* 三点表示法，两个版本的前后顺序没有关系。

  实际上\ ``r1...r2``\ 相当于\ ``r1 r2 --not $(git merge-base --all r1 r2)``\ ，\
  和顺序无关。

  ::

    $ git rev-list --oneline  C...B
    0cd7f2e commit C.
    776c5c9 Commit B: merge D with E and F
    212efce Commit D: merge G with H
    83be369 commit E.
    2ab52ad commit H.
    e80aa74 commit G.

* 某提交的历史提交，自身除外，用语法\ ``r1^@``\ 表示。

  ::

    $ git rev-list --oneline  B^@
    beb30ca Commit F: merge I with J
    212efce Commit D: merge G with H
    634836c commit I.
    3252fcc commit J.
    83be369 commit E.
    2ab52ad commit H.
    e80aa74 commit G.

* 提交本身不包括其历史提交，用语法\ ``r1^!``\ 表示。

  ::

    $ git rev-list --oneline  B^!
    776c5c9 Commit B: merge D with E and F

    $ git rev-list --oneline  F^! D
    beb30ca Commit F: merge I with J
    212efce Commit D: merge G with H
    2ab52ad commit H.

浏览日志：\ :command:`git log`
---------------------------------

命令\ :command:`git log`\ 是老朋友了，在前面的章节中曾经大量的出现，用于\
显示提交历史。

**参数代表版本范围**

当不使用任何参数调用，相当于使用了缺省的参数HEAD，即显示当前HEAD能够访问\
到的所有历史提交。还可以使用上面介绍的版本范围表示法，例如：

::

  $ git log --oneline F^! D
  beb30ca Commit F: merge I with J
  212efce Commit D: merge G with H
  2ab52ad commit H.
  e80aa74 commit G.

**分支图显示**

通过\ ``--graph``\ 参数调用\ :command:`git log`\ 可以显示字符界面的提交\
关系图，而且不同的分支还可以用不同的颜色来表示。如果希望每次查看日志的时\
候都看到提交关系图，可以设置一个别名，用别名来调用。

::

  $ git config --global alias.glog "log --graph"

定义别名之后，每次希望自动显示提交关系图，就可以使用别名命令：

::

  $ git glog --oneline
  * 6652a0d Add Images for git treeview.
  *   8199323 Commit A: merge B with C.
  |\  
  | * 0cd7f2e commit C.
  | |     
  |  \    
  *-. \   776c5c9 Commit B: merge D with E and F
  |\ \ \  
  | | |/  
  | | *   beb30ca Commit F: merge I with J
  | | |\  
  | | | * 3252fcc commit J.
  | | * 634836c commit I.
  | * 83be369 commit E.
  *   212efce Commit D: merge G with H
  |\  
  | * 2ab52ad commit H.
  * e80aa74 commit G.


**显示最近的几条日志**

可以使用参数\ ``-<n>``\ （<n>为数字），显示最近的<n>条日志。例如下面的命\
令显示最近的3条日志。

::

  $ git log -3 --pretty=oneline
  6652a0dce6a5067732c00ef0a220810a7230655e Add Images for git treeview.
  81993234fc12a325d303eccea20f6fd629412712 Commit A: merge B with C.
  0cd7f2ea245d90d414e502467ac749f36aa32cc4 commit C.

**显示每次提交的具体改动**

使用参数\ ``-p``\ 可以在显示日志的时候同时显示改动。

::

  $ git log -p -1
  commit 6652a0dce6a5067732c00ef0a220810a7230655e
  Author: Jiang Xin <jiangxin@ossxp.com>
  Date:   Thu Dec 9 16:07:11 2010 +0800

      Add Images for git treeview.
      
      Signed-off-by: Jiang Xin <jiangxin@ossxp.com>

  diff --git a/gitg.png b/gitg.png
  new file mode 100644
  index 0000000..fc58966
  Binary files /dev/null and b/gitg.png differ
  diff --git a/treeview.png b/treeview.png
  new file mode 100644
  index 0000000..a756d12
  Binary files /dev/null and b/treeview.png differ

因为是二进制文件改动，缺省不显示改动的内容。实际上Git的差异文件提供对二\
进制文件的支持，在后面“Git应用”章节予以专题介绍。

**显示每次提交的变更概要**

使用\ ``-p``\ 参数会让日志输出显得非常冗余，当不需要知道具体的改动而只想\
知道改动在哪些文件上，可以使用\ ``--stat``\ 参数。输出的变更概要像极了\
Linux的\ :command:`diffstat`\ 命令的输出。

::

  $ git log --stat --oneline  I..C
  0cd7f2e commit C.
   README    |    1 +
   doc/C.txt |    1 +
   2 files changed, 2 insertions(+), 0 deletions(-)
  beb30ca Commit F: merge I with J
  3252fcc commit J.
   README           |    7 +++++++
   doc/J.txt        |    1 +
   src/.gitignore   |    3 +++
   src/Makefile     |   27 +++++++++++++++++++++++++++
   src/main.c       |   10 ++++++++++
   src/version.h.in |    6 ++++++
   6 files changed, 54 insertions(+), 0 deletions(-)

**定制输出**

Git的差异输出命令提供了很多输出模板提供选择，可以根据需要选择冗余显示或\
者精简显示。

* 参数\ ``--pretty=raw``\ 显示提交的原始数据。可以显示提交对应的树ID。

  ::

    $ git log --pretty=raw -1
    commit 6652a0dce6a5067732c00ef0a220810a7230655e
    tree e33be9e8e7ca5f887c7d5601054f2f510e6744b8
    parent 81993234fc12a325d303eccea20f6fd629412712
    author Jiang Xin <jiangxin@ossxp.com> 1291882031 +0800
    committer Jiang Xin <jiangxin@ossxp.com> 1291882892 +0800

        Add Images for git treeview.
        
        Signed-off-by: Jiang Xin <jiangxin@ossxp.com>

* 参数\ ``--pretty=fuller``\ 会同时显示作者和提交者，两者可以不同。

  ::

    $ git log --pretty=fuller -1
    commit 6652a0dce6a5067732c00ef0a220810a7230655e
    Author:     Jiang Xin <jiangxin@ossxp.com>
    AuthorDate: Thu Dec 9 16:07:11 2010 +0800
    Commit:     Jiang Xin <jiangxin@ossxp.com>
    CommitDate: Thu Dec 9 16:21:32 2010 +0800

        Add Images for git treeview.
        
        Signed-off-by: Jiang Xin <jiangxin@ossxp.com>

* 参数\ ``--pretty=oneline``\ 显然会提供最精简的日志输出。也可以使用\
  ``--oneline``\ 参数，效果近似。

  ::

    $ git log --pretty=oneline -1
    6652a0dce6a5067732c00ef0a220810a7230655e Add Images for git treeview.

如果只想查看、分析某一个提交，也可以使用\ :command:`git show`\ 或者\
:command:`git cat-file`\ 命令。

* 使用\ :command:`git show`\ 显示里程碑D及其提交：

  ::

    $ git show D --stat
    tag D
    Tagger: Jiang Xin <jiangxin@ossxp.com>
    Date:   Thu Dec 9 14:24:52 2010 +0800

    create node D

    commit 212efce1548795a1edb08e3708a50989fcd73cce
    Merge: e80aa74 2ab52ad
    Author: Jiang Xin <jiangxin@ossxp.com>
    Date:   Thu Dec 9 14:06:34 2010 +0800

        Commit D: merge G with H
        
        Signed-off-by: Jiang Xin <jiangxin@ossxp.com>

     README    |    2 ++
     doc/D.txt |    1 +
     doc/H.txt |    1 +
     3 files changed, 4 insertions(+), 0 deletions(-)

* 使用\ :command:`git cat-file`\ 显示里程碑D及其提交。

  参数\ ``-p``\ 的含义是美观的输出（pretty）。

  ::

    $ git cat-file -p D^0
    tree 1c22e90c6bf150ee1cde6cefb476abbb921f491f
    parent e80aa7481beda65ae00e35afc4bc4b171f9b0ebf
    parent 2ab52ad2a30570109e71b56fa1780f0442059b3c
    author Jiang Xin <jiangxin@ossxp.com> 1291874794 +0800
    committer Jiang Xin <jiangxin@ossxp.com> 1291875877 +0800

    Commit D: merge G with H

    Signed-off-by: Jiang Xin <jiangxin@ossxp.com>

差异比较：\ :command:`git diff`
-----------------------------------

Git差异比较功能在前面的实践中也反复的接触过了，尤其是在介绍暂存区的相关\
章节重点介绍了\ :command:`git diff`\ 命令如何对工作区、暂存区、版本库进\
行比较。

* 比较里程碑B和里程碑A，用命令：\ :command:`git diff B A`
* 比较工作区和里程碑A，用命令：\ :command:`git diff A`
* 比较暂存区和里程碑A，用命令：\ :command:`git diff --cached A`
* 比较工作区和暂存区，用命令：\ :command:`git diff`
* 比较暂存区和HEAD，用命令：\ :command:`git diff --cached`
* 比较工作区和HEAD，用命令：\ :command:`git diff HEAD`

**Git中文件在版本间的差异比较**

差异比较还可以使用路径参数，只显示不同版本间该路径下文件的差异。语法格式：

::

  $ git diff <commit1> <commit2> -- <paths>


**非Git目录/文件的差异比较**

命令\ :command:`git diff`\ 还可以在Git版本库之外执行，对非Git目录进行比\
较，就像GNU的\ :command:`diff`\ 命令一样。之所以提供这个功能是因为Git差\
异比较命令更为强大，提供了对GNU差异比较的扩展支持。

::

  $ git diff <path1> <path2>


**扩展的差异语法**

Git扩展了GNU的差异比较语法，提供了对重命名、二进制文件、文件权限变更的支\
持。在后面的“Git应用”辟专题介绍二进制文件的差异比较和补丁的应用。

**逐词比较，而非缺省的逐行比较**

Git的差异比较缺省是逐行比较，分别显示改动前的行和改动后的行，到底改动哪\
里还需要仔细辨别。Git还提供一种逐词比较的输出，有的人会更喜欢。使用\
``--word-diff``\ 参数可以显示逐词比较。

::

  $ git diff --word-diff
  diff --git a/src/book/02-use-git/080-git-history-travel.rst b/src/book/02-use-git/080-git-history-travel.rst
  index f740203..2dd3e6f 100644
  --- a/src/book/02-use-git/080-git-history-travel.rst
  +++ b/src/book/02-use-git/080-git-history-travel.rst
  @@ -681,7 +681,7 @@ Git的大部分命令可以使用提交版本作为参数（如：git diff），

  ::

    [-18:23:48 jiangxin@hp:~/gitwork/gitbook/src/book$-]{+$+} git log --stat --oneline  I..C
    0cd7f2e commit C.
     README    |    1 +
     doc/C.txt |    1 +

上面的逐词差异显示是有颜色显示的：删除内容\ ``[-...-]``\ 用红色表示，\
添加的内容\ ``{+...+}``\ 用绿色表示。

文件追溯：\ :command:`git blame`
------------------------------------

在软件开发过程中当发现Bug并定位到具体的代码时，Git的文件追溯命令可以指出\
是谁在什么时候，什么版本引入的此Bug。

当针对文件执行\ :command:`git blame`\ 命令，就会逐行显示文件，在每一行的\
行首显示此行最早是在什么版本引入的，由谁引入。

::

  $ cd /path/to/my/workspace/gitdemo-commit-tree
  $ git blame README
  ^e80aa74 (Jiang Xin 2010-12-09 14:00:33 +0800  1) DEMO program for git-scm-book.
  ^e80aa74 (Jiang Xin 2010-12-09 14:00:33 +0800  2) 
  ^e80aa74 (Jiang Xin 2010-12-09 14:00:33 +0800  3) Changes
  ^e80aa74 (Jiang Xin 2010-12-09 14:00:33 +0800  4) =======
  ^e80aa74 (Jiang Xin 2010-12-09 14:00:33 +0800  5) 
  81993234 (Jiang Xin 2010-12-09 14:30:15 +0800  6) * create node A.
  0cd7f2ea (Jiang Xin 2010-12-09 14:29:09 +0800  7) * create node C.
  776c5c9d (Jiang Xin 2010-12-09 14:27:31 +0800  8) * create node B.
  beb30ca7 (Jiang Xin 2010-12-09 14:11:01 +0800  9) * create node F.
  ^3252fcc (Jiang Xin 2010-12-09 14:00:33 +0800 10) * create node J.
  ^634836c (Jiang Xin 2010-12-09 14:00:33 +0800 11) * create node I.
  ^83be369 (Jiang Xin 2010-12-09 14:00:33 +0800 12) * create node E.
  212efce1 (Jiang Xin 2010-12-09 14:06:34 +0800 13) * create node D.
  ^2ab52ad (Jiang Xin 2010-12-09 14:00:33 +0800 14) * create node H.
  ^e80aa74 (Jiang Xin 2010-12-09 14:00:33 +0800 15) * create node G.
  ^e80aa74 (Jiang Xin 2010-12-09 14:00:33 +0800 16) * initialized.

只想查看某几行，使用\ ``-L n,m``\ 参数，如下：

::

  $ git blame -L 6,+5 README
  81993234 (Jiang Xin 2010-12-09 14:30:15 +0800  6) * create node A.
  0cd7f2ea (Jiang Xin 2010-12-09 14:29:09 +0800  7) * create node C.
  776c5c9d (Jiang Xin 2010-12-09 14:27:31 +0800  8) * create node B.
  beb30ca7 (Jiang Xin 2010-12-09 14:11:01 +0800  9) * create node F.
  ^3252fcc (Jiang Xin 2010-12-09 14:00:33 +0800 10) * create node J.

二分查找：\ :command:`git bisect`
------------------------------------

前面的文件追溯是建立在问题（Bug）已经定位（到代码上）的基础之上，然后才\
能通过错误的行（代码）找到人（提交者），打板子（教育或惩罚）。那么如何定\
位问题呢？Git的二分查找命令可以提供帮助。

二分查找并不神秘，也不是万灵药，是建立在测试的基础之上的。实际上每个进行\
过软件测试的人都曾经使用过：“最新的版本出现Bug了，但是在给某某客户的版本\
却没有这个问题，所以问题肯定出在两者之间的某次代码提交上”。


Git提供的\ :command:`git bisect`\ 命令是基于版本库的，自动化的问题查找和\
定位工作流程。取代传统软件测试中粗放式的、针对软件发布版本的、无法定位到\
代码的测试。

执行二分查找，在发现问题后，首先要找到一个正确的版本，如果所发现的问题从\
软件最早的版本就是错的，那么就没有必要执行二分查找了，还是老老实实的\
Debug吧。但是如果能够找到一个正确的版本，即在这个正确的版本上问题没有发生，\
那么就可以开始使用\ :command:`git bisect`\ 命令在版本库中进行二分查找了：

1. 工作区切换到已知的“好版本”和“坏版本”的中间的一个版本。
2. 执行测试，问题重现，将版本库当前版本库为“坏版本”，如果问题没有重现，\
   将当前版本标记为“好版本”。
3. 重复1-2，直至最终找到第一个导致问题出现的版本。

下面是示例版本库标记了提交ID后的示意图，在这个示例版本库中试验二分查找流\
程：首先标记最新提交（HEAD）是“坏的”，G提交是好的，然后通过查找最终定位\
到坏提交（B）。

.. figure:: /images/git-solo/commit-tree-bisect.png
   :scale: 100

在下面的试验中定义坏提交的依据很简单，如果在\ :file:`doc/`\ 目录中包含文\
件\ :file:`B.txt`\ ，则此版本是“坏”的。（这个示例太简陋，不要见笑，聪明\
的读者可以直接通过\ :file:`doc/B.txt`\ 文件就可追溯到B提交。）

下面开始通过手动测试（查找\ :file:`doc/B.txt`\ 存在与否），借助Git二分查\
找定位“问题”版本。

* 首先确认工作在master分支。

  ::

    $ cd /path/to/my/workspace/gitdemo-commit-tree/
    $ git checkout master
    Already on 'master'

* 开始二分查找。

  ::

    $ git bisect start

* 已经当前版本是“坏提交”，因为存在文件\ :file:`doc/B.txt`\ 。而G版本是\
  “好提交”，因为不存在文件\ :file:`doc/B.txt`\ 。

  ::

    $ git cat-file -t master:doc/B.txt
    blob
    $ git cat-file -t G:doc/B.txt
    fatal: Not a valid object name G:doc/B.txt

* 将当前版本（HEAD）标记为“坏提交”，将G版本标记为“好提交”。

  ::

    $ git bisect bad
    $ git bisect good G
    Bisecting: 5 revisions left to test after this (roughly 2 steps)
    [0cd7f2ea245d90d414e502467ac749f36aa32cc4] commit C.

* 自动定位到C提交。没有文件\ :file:`doc/B.txt`\ ，也是一个好提交。

  ::
    
    $ git describe
    C
    $ ls doc/B.txt
    ls: 无法访问doc/B.txt: 没有那个文件或目录

* 标记当前版本（C提交）为“好提交”。

  ::

    $ git bisect good
    Bisecting: 3 revisions left to test after this (roughly 2 steps)
    [212efce1548795a1edb08e3708a50989fcd73cce] Commit D: merge G with H

* 现在定位到D版本，这也是一个“好提交”。

  ::

    $ git describe
    D
    $ ls doc/B.txt
    ls: 无法访问doc/B.txt: 没有那个文件或目录

* 标记当前版本（D提交）为“好提交”。

  ::

    $ git bisect good
    Bisecting: 1 revision left to test after this (roughly 1 step)
    [776c5c9da9dcbb7e463c061d965ea47e73853b6e] Commit B: merge D with E and F

* 现在定位到B版本，这是一个“坏提交”。

  ::

    $ git bisect bad
    Bisecting: 0 revisions left to test after this (roughly 0 steps)
    [83be36956c007d7bfffe13805dd2081839fd3603] commit E.

* 现在定位到E版本，这是一个“好提交”。当标记E为好提交之后，输出显示已经成\
  功定位到引入坏提交的最接近的版本。

  ::

    $ git bisect good
    776c5c9da9dcbb7e463c061d965ea47e73853b6e is the first bad commit

* 最终定位的坏提交用引用\ :file:`refs/bisect/bad`\ 标识。可以如下方法切\
  换到该版本。

  ::

    $ git checkout bisect/bad
    Previous HEAD position was 83be369... commit E.
    HEAD is now at 776c5c9... Commit B: merge D with E and F

* 当对“Bug”定位和修复后，撤销二分查找在版本库中遗留的临时文件和引用。

  撤销二分查找后，版本库切换回执行二分查找之前所在的分支。

  ::

    $ git bisect reset
    Previous HEAD position was 776c5c9... Commit B: merge D with E and F
    Switched to branch 'master'

**把“好提交”标记成了“坏提交”该怎么办？**

在执行二分查找的过程中，一不小心就有可能犯错，将“好提交”标记为“坏提交”，\
或者相反。这将导致前面的查找过程也前功尽弃。Git的二分查找提供一个恢复查\
找进度的办法。

* 例如对E提交，本来是一个“好版本”却被错误的标记为“坏版本”。

  ::

    $ git bisect bad
    83be36956c007d7bfffe13805dd2081839fd3603 is the first bad commit

* 用\ :command:`git bisect log`\ 命令查看二分查找的日志记录。

  把二分查找的日志保存在一个文件中。

  ::

    $ git bisect log > logfile

* 编辑这个文件，删除记录了错误动作的行。

  以井号（#）开始的行是注释。

  ::

    $ cat logfile
    # bad: [6652a0dce6a5067732c00ef0a220810a7230655e] Add Images for git treeview.
    # good: [e80aa7481beda65ae00e35afc4bc4b171f9b0ebf] commit G.
    git bisect start 'master' 'G'
    # good: [0cd7f2ea245d90d414e502467ac749f36aa32cc4] commit C.
    git bisect good 0cd7f2ea245d90d414e502467ac749f36aa32cc4
    # good: [212efce1548795a1edb08e3708a50989fcd73cce] Commit D: merge G with H
    git bisect good 212efce1548795a1edb08e3708a50989fcd73cce
    # bad: [776c5c9da9dcbb7e463c061d965ea47e73853b6e] Commit B: merge D with E and F
    git bisect bad 776c5c9da9dcbb7e463c061d965ea47e73853b6e

* 结束上一次出错的二分查找。

  ::

    $ git bisect reset
    Previous HEAD position was 83be369... commit E.
    Switched to branch 'master'

* 通过日志文件恢复进度。

  ::

    $ git bisect replay logfile
    We are not bisecting.
    Bisecting: 5 revisions left to test after this (roughly 2 steps)
    [0cd7f2ea245d90d414e502467ac749f36aa32cc4] commit C.
    Bisecting: 0 revisions left to test after this (roughly 0 steps)
    [83be36956c007d7bfffe13805dd2081839fd3603] commit E.

* 再一次回到了提交E，这一次不要标记错了。

  ::

    $ git describe
    E
    $ git bisect good
    776c5c9da9dcbb7e463c061d965ea47e73853b6e is the first bad commit

**二分查找使用自动化测试**

Git的二分查找命令支持\ ``run``\ 子命令，可以运行一个自动化测试脚本。

* 如果脚本的退出码是0，正在测试的版本是一个“好版本”。
* 如果脚本的退出码是125，正在测试的版本被跳过。
* 如果脚本的退出码是1到127（125除外），正在测试的版本是一个“坏版本”。

对于本例写一个自动化测试太简单了，无非就是判断文件是否存在，存在返回错误\
码1，不存在返回错误码0。

测试脚本\ :file:`good-or-bad.sh`\ 如下：

  ::

    #!/bin/sh

    [ -f doc/B.txt ] && exit 1
    exit 0

用此自动化脚本执行二分查找就非常简单了。

* 从已知的坏版本master和好版本G，开始新一轮的二分查找。

  ::

    $ git bisect start master G
    Bisecting: 5 revisions left to test after this (roughly 2 steps)
    [0cd7f2ea245d90d414e502467ac749f36aa32cc4] commit C.

* 自动化测试，使用脚本\ :file:`good-or-bad.sh`\ 。

  ::

    $ git bisect run sh good-or-bad.sh
    running sh good-or-bad.sh
    Bisecting: 3 revisions left to test after this (roughly 2 steps)
    [212efce1548795a1edb08e3708a50989fcd73cce] Commit D: merge G with H
    running sh good-or-bad.sh
    Bisecting: 1 revision left to test after this (roughly 1 step)
    [776c5c9da9dcbb7e463c061d965ea47e73853b6e] Commit B: merge D with E and F
    running sh good-or-bad.sh
    Bisecting: 0 revisions left to test after this (roughly 0 steps)
    [83be36956c007d7bfffe13805dd2081839fd3603] commit E.
    running sh good-or-bad.sh
    776c5c9da9dcbb7e463c061d965ea47e73853b6e is the first bad commit
    bisect run success

* 定位到的“坏版本”是B。

  ::

    $ git describe refs/bisect/bad
    B


获取历史版本
------------

提取历史提交中的文件无非就是下面表格中的操作，在之前的实践中多次用到，\
不再赘述。

  +----------------------------------+---------------------------------------+-------------------------------------------+
  | 动作                             | 命令格式                              | 示例                                      |
  +==================================+=======================================+===========================================+
  | 查看历史提交的目录树             | git ls-tree <tree-ish> <paths>        |* git ls-tree 776c5c9 README               |
  |                                  |                                       |* git ls-tree -r refs/tags/D doc           |
  +----------------------------------+---------------------------------------+-------------------------------------------+
  | 整个工作区切换到历史版本         | git checkout <commit>                 |* git checkout HEAD^^                      |
  +----------------------------------+---------------------------------------+-------------------------------------------+
  | 检出某文件的历史版本             | git checkout <commit> -- <paths>      |* git checkout refs/tags/D -- README       |
  |                                  |                                       |* git checkout 776c5c9 -- doc              |
  +----------------------------------+---------------------------------------+-------------------------------------------+
  | 检出某文件的历史版本到其他文件名 | git show <commit>:<file> > new_name   |* git show 887113d:README > README.OLD     |
  +----------------------------------+---------------------------------------+-------------------------------------------+

