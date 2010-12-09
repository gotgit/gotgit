历史穿梭（实践八）
******************

经过了之前众多的实践，版本库中已经积累了很多次提交了，从下面的命令可以看出来有14次提交。

::

  $ git rev-list HEAD | wc -l
  14

有很多工具可以研究和分析Git的历史提交，在前面的实践中已经用过很多相关的Git命令进行查看历史提交、查看文件的历史版本、进行差异比较等。本章除了对之前用到的相关Git命令作以总结外，还要再介绍几款图形化的客户端。

图形工具：gitk
==============

gitk 是最早实现的一个图形化的Git版本库浏览器软件，基于 tcl/tk 实现，因此 gitk 非常简洁，本身就是一个1万多行的tcl脚本写成的。gitk 的代码已经和Git的代码放在同一个版本库中，gitk 随 Git 一同发布，不用特别的安装即可运行。gitk 可以显示提交的分支图，可以显示提交，文件，版本间差异等。

在版本库中调用 gitk，就会浏览该版本库，显示其提交分支图。gitk 可以像命令行工具一样使用不同的参数进行调用。

* 显示所有的分支。

  ::

    $ gitk --all

* 显示2周以来的提交。

  ::

    $ gitk --since="2 weeks ago"

* 显示某个里程碑（v2.6.12）以来，针对某些目录和文件（include/scsi 目录和 drivers/scsi 目录）的提交。

  ::

    $ gitk v2.6.12.. include/scsi drivers/scsi

下面的图示就是在我们的试验版本库中运行 "gitk --all" 的显示。

.. figure:: images/git-gui/gitk.png
   :scale: 80

在上图中可见不同颜色和形状区分的引用：

* 绿色的 master 分支。
* 黄色的 hello_1.0 和 old_practice 里程碑。
* 灰色的 stash。

gitk 使用 tcl/tk 开发，在显示上没有系统中原生图形应用那么漂亮的界面，甚至可以用丑陋来形容，下面介绍的 gitg 和 qgit 在易用性上比 gitk 进步了不少。

图形工具：gitg
==============

gitg 是使用 GTK+ 图形库实现的一个 Git 版本库浏览器软件。Linux 下最著名的 Gnome 桌面环境使用的就是 GTK+，因此在 Linux 下 gitg 有着非常漂亮的原生的图形界面。gitg 不但能够实现 gitk 的全部功能：浏览提交历史和文件，还能帮助执行提交。

在 Linux 上安装 gitg 很简单，例如在 Debian 或 Ubuntu 上，直接运行下面的命令就可以进行安装。

::

  $ sudo aptitude install gitg

安装完毕就可以在可执行路径中找到 gitg。

::

  $ which gitg
  /usr/bin/gitg

为了演示 gitg 具备提交功能，先在工作区作出一些修改。

* 删除没有用到的 `hello.h` 文件。

  ::
  
    $ cd /my/workspace/demo
    $ rm src/hello.h

* 在 README 文件后面追加一行。

  ::

    $ echo "Wait..." >> README

* 当前工作区的状态。

  ::

    $ git status -s
     M README
     D src/hello.h

现在可以在工作区下执行 gitg 命令。

::

  $ gitg &

下图就是 gitg 的缺省界面，显示了提交分支图，以及选中提交的提交信息和变更文件列表等。

  .. figure:: images/git-gui/gitg-history.png
     :scale: 75

在上图中可以看见用不同颜色的标签显示的状态标识（包括引用）：

* 橙色的 master 分支。
* 黄色的 hello_1.0 和 old_practice 里程碑。
* 粉色的 stash 标签。
* 以及白色的显示工作区非暂存状态的标签。

点击 gitg 下方窗口的标签 “tree”，会显示此提交的目录树。

  .. figure:: images/git-gui/gitg-tree.png
     :scale: 75

提交功能是 gitg 的一大特色。点击 gitg 顶部窗口的 commit 标签，显示下面的界面。

  .. figure:: images/git-gui/gitg-commit-1-all-unstaged.png
     :scale: 75

左下方窗口显示的是未更新到暂存区的本地改动。鼠标右击，在弹出菜单中选择“Stage”。

  .. figure:: images/git-gui/gitg-commit-2-add-stage.png
     :scale: 75

当把文件 `README` 添加到暂存区后，可以看到 `README` 文件出现在右下方的窗口中。

  .. figure:: images/git-gui/gitg-commit-3-mixed-stage-unstage.png
     :scale: 75

此时如果回到提交历史查看界面，可以看到在“stash”标签的下方，同时出现了“staged”和“unstaged”两个标签分别表示暂存区和工作区的状态。

  .. figure:: images/git-gui/gitg-commit-4-history-stage-unstage.png
     :scale: 75

当通过 gitg 的界面选择好要提交的文件列表（加入暂存区）之后，执行提交。

  .. figure:: images/git-gui/gitg-commit-5-commit.png
     :scale: 75

上图的提交说明对话框的下方有两个选项，当选择了“Add signed-off-by”选项后，在提交日志中会自动增加相应的说明文字。下图可以看到刚刚的提交已经显示在提交历史的最顶端，在提交说明中出现了 "Signed-off-by" 文字说明。

  .. figure:: images/git-gui/gitg-commit-6-new-history.png
     :scale: 75

gitg 还是一个比较新的项目，在本文撰写的时候，gitg 才是 0.0.6 版本，相比下面要介绍的 qgit 还缺乏很多功能。例如 gitg 没有文件的 blame（追溯）界面，也不能直接将文件检出，但是 gitg 整体的界面风格，以及易用的提交界面给人的印象非常深刻。

图形工具：qgit
==============

前面介绍的 gitg 是基于 GTK+ 这一 Linux 标准的图形库，那么也许有读者已经猜到 qgit 是使用 Linux 另外一个著名的图形库 QT 实现的 Git 版本库浏览器软件。QT 的知名度不亚于 GTK+，是著名的 KDE 桌面环境用到的图形库，也是蓄势待发准备和 Android 一较高低的 MeeGo 的UI核心。qgit 目前的版本是 2.3，相比前面介绍的 gitg 其经历的开发周期要长了不少，因此也提供了更多的功能。

在 Linux 上安装 qgit 很简单，例如在 Debian 或 Ubuntu 上，直接运行下面的命令就可以进行安装。

::

  $ sudo aptitude install qgit

安装完毕就可以在可执行路径中找到 qgit。

::

  $ which qgit
  /usr/bin/qgit

qgit 和 gitg 一样不但能够浏览提交历史和文件，还能帮助执行提交。为了测试提交，将在上一节所做的提交回滚。

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
 
现在可以在工作区下执行 qgit 命令。

::

  $ qgit &

启动 qgit ，首先弹出一个对话框，提示对显示的提交范围和分支范围进行选择。

  .. figure:: images/git-gui/qgit-splash-select.png
     :scale: 100

对所有的选择打钩，显示下面的 qgit 的缺省界面，显示了提交分支图，以及选中提交的提交信息和变更文件列表等。

  .. figure:: images/git-gui/qgit-history.png
     :scale: 75

在上图中可以看见用不同颜色的标签显示的状态标识（包括引用）：

* 绿色的 master 分支。
* 黄色的 hello_1.0 和 old_practice 里程碑。
* 灰色的 stash 标签，显示在了创建时候的位置，并其包含的针对暂存区状态的提交也显示出来。
* 最顶端显示一行绿色背景的文件：工作区有改动。

qgit 的右键菜单非常丰富，上图显示了鼠标右击提交时显示的弹出菜单，可以创建、切换标签或分支，可以将提交导出为补丁文件。

点击 qgit 右下方变更文件列表窗口，可以选择将文件检出或者直接查看。

  .. figure:: images/git-gui/qgit-changefiles.png
     :scale: 75

要想显示目录树，键入大写字母 "T" ，或者鼠标单击工具条上的图标 |QGIT-TREE-TOGGLE| ，就会在左侧显示目录树窗口，如下。

  .. figure:: images/git-gui/qgit-tree-view.png
     :scale: 75

.. |QGIT-TREE-TOGGLE| image:: images/git-gui/qgit-icon-tree-toggle.png

从上图也可以看到目录树的文件包含的右键菜单。当选择查看一个文件时，会显示此文件的追溯，即显示每一行是在哪个版本由谁修改的。追溯窗口见下图右下方窗口。

  .. figure:: images/git-gui/qgit-blame.png
     :scale: 75

qgit 也可以执行提交。选中 qgit 顶部窗口最上一行“Working dir changes”，鼠标右击，显示的弹出菜单包含了“Commit...”选项。

  .. figure:: images/git-gui/qgit-commit-1-revlist.png
     :scale: 75

点击弹出菜单中的“Commit...”，显示下面的对话框。

  .. figure:: images/git-gui/qgit-commit-2-dialog-unstaged.png
     :scale: 75

自动选中了所有的文件。上方窗口的选中文件目前状态是“Not updated in index”，就是说尚未添加到暂存区。

使用 qgit 做提交，只要选择好要提交的文件列表，即使未添加到暂存区，也可以直接提交。在下方的提交窗口写入提交日志，点击“Commit”按钮开始提交。

  .. figure:: images/git-gui/qgit-commit-3-commit-unstaged.png
     :scale: 75

提交完毕返回 qgit 主界面，在显示的提交列表的最上方，原来显示的“Working dir changes”已经更新为“Nothing to commit”，并且可以看到刚刚的提交已经显示在提交历史的最顶端。

  .. figure:: images/git-gui/qgit-commit-4-revlist.png
     :scale: 75


命令行工具
==============

上面介绍的几款图形界面的Git版本库浏览器最大的特色就是更好看的提交关系图，还能非常方便的浏览历史提交的目录树，并从历史提交的目录树中提取文件等。这些操作对于Git命令行同样可以完成。使用Git命令行探索版本库历史对于读者来说并不新鲜，因为在前几章的实践中已经用到了相关命令，展示了对历史记录的操作。本节对这些命令的部分要点进行强调和补充。

前面历次实践的提交基本上是线性的提交，研究起来没有挑战性。为了能够更加接近于实际又不失简洁，我构造了一个版本库，放在了 Github 上。通过如下操作在本地克隆这个示例版本库。

::

  $ cd /my/workspace/
  $ git clone git://github.com/ossxp-com/gitdemo-commit-tree.git
  Cloning into gitdemo-commit-tree...
  remote: Counting objects: 63, done.
  remote: Compressing objects: 100% (51/51), done.
  remote: Total 63 (delta 8), reused 0 (delta 0)
  Receiving objects: 100% (63/63), 65.95 KiB, done.
  Resolving deltas: 100% (8/8), done.
  $ cd gitdemo-commit-tree

运行 gitg 命令，显示其提交关系图。

.. figure:: images/git-gui/gitg-demo-commit-tree.png
   :scale: 100

是不是有点“乱花渐欲迷人眼”的感觉。如果把提交用里程碑来代表提交，稍加排列就会看到下面的更为直白的提交关系图。

.. figure:: images/gitbook/commit-tree.png 
   :scale: 100

git rev-parse 和 git rev-list
------------------------------

命令 "git rev-parse" 是Git的一个低端命令，其功能非常丰富（或者说杂乱），很多Git脚本或工具都会用到这条命令。

此命令的部分应用在实践一当中就已经看到。例如可以显示Git版本库的位置（--git-dir），当前工作区目录的深度（--show-cdup），甚至可以用于被Git无关应用用于解析命令行参数（--parseopt）。

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

  其中 `refs/remotes/` 目录下的引用成为远程分支（或远程引用），在后面的章节会予以介绍。

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

命令 "git rev-parse" 另外一个重要的功能就是将一个Git对象表达式表示为对应的SHA1哈希值。针对本节开始克隆的版本库 gitdemo-commit-tree，做如下操作。

* 显示 HEAD 对应的 SHA1哈希值。

  ::

    $ git rev-parse  HEAD
    6652a0dce6a5067732c00ef0a220810a7230655e

* 命令 git describe 的输出也可以显示为SHA1哈希值。

  ::

    $ git describe
    A-1-g6652a0d
    $ git rev-parse A-1-g6652a0d
    6652a0dce6a5067732c00ef0a220810a7230655e

* 可以同时显示多个表达式的SHA1哈希值。

  下面的操作可以看出 master 和 refs/heads/master 都可以用于指代 master 分支。

  ::

    $ git rev-parse  master  refs/heads/master
    6652a0dce6a5067732c00ef0a220810a7230655e
    6652a0dce6a5067732c00ef0a220810a7230655e

* 可以用哈希值的前几位指代整个哈希值。

  ::

    $ git rev-parse  6652  6652a0d
    6652a0dce6a5067732c00ef0a220810a7230655e
    6652a0dce6a5067732c00ef0a220810a7230655e

* 里程碑的两种表示法均指向相同的对象（不一定是提交，见下一项操作）。

  ::

    $ git rev-parse  A  refs/tags/A
    c9b03a208288aebdbfe8d84aeb984952a16da3f2
    c9b03a208288aebdbfe8d84aeb984952a16da3f2

* 里程碑A指向了一个Tag对象而非提交的时候，用下面的三个表示法都可以指向里程碑对应的提交。

  ::

    $ git rev-parse  A^{}  A^0  A^{commit}
    81993234fc12a325d303eccea20f6fd629412712
    81993234fc12a325d303eccea20f6fd629412712
    81993234fc12a325d303eccea20f6fd629412712

* A 的第一个父提交就是 B。

  ::

    $ git rev-parse  A^  A^1  B^0
    776c5c9da9dcbb7e463c061d965ea47e73853b6e
    776c5c9da9dcbb7e463c061d965ea47e73853b6e
    776c5c9da9dcbb7e463c061d965ea47e73853b6e

* 更为复杂的表示法。

  ::

    $ git rev-parse  A^^3^2  F^2  J^{}
    3252fcce40949a4a622a1ac012cb120d6b340ac8
    3252fcce40949a4a622a1ac012cb120d6b340ac8
    3252fcce40949a4a622a1ac012cb120d6b340ac8

* 记号 ~<n> 就相当于连续 <n> 个符号"^"。

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

* 暂存区里的文件和 HEAD 中的文件相同。

  ::

    $ git rev-parse  :gitg.png  HEAD:gitg.png
    fc58966ccc1e5af24c2c9746196550241bc01c50
    fc58966ccc1e5af24c2c9746196550241bc01c50

* 还可以通过在提交日志中查找字串的方式显示提交。

  ::

    $ git rev-parse :/"Commit A"
    81993234fc12a325d303eccea20f6fd629412712

git log
--------

命令 "git log" 是老朋友了，在前面的章节中曾经大量的出现，用于显示提交历史。


**分支图显示**

通过 `--graph` 参数调用 git log 可以显示字符界面的提交关系图，而且不同的分支还可以用不同的颜色来表示。如果希望每次查看日志的时候都看到提交关系图，可以设置一个别名，用别名来调用。

::

  $ git config --global alias.glog "log --graph"

定义别名之后，每次希望自动显示提交关系图，就可以使用别名命令：

::

  $ git glog

**显示最近的几条日志**

可以使用参数 "-<n>" （<n>为数字），显示最近的 <n> 条日志。例如下面的命令显示最近的5条日志。

::

  $ git log -5 --pretty=oneline
  822b4aeed5de74f949c9faa5b281001eb5439444 测试使用 qgit 提交。
  613486c17842d139871e0f1b0e9191d2b6177c9f 偷懒了，直接用 -a 参数直接提交。
  48456abfaeab706a44880eabcd63ea14317c0be9 add hello.h
  3488f2cc78c8fb68f8b24efa683176c53523618e move .gitignore outside also works.
  b3af7282919d46204fc9d58f9a939e0d5112a7df ignore object files.


**使用一个版本作为参数**

.. figure:: images/gitbook/commit-tree.png
   :scale: 100



**使用多个版本作为参数**

**使用版本范围作为参数**

如果使用多个版本作为参数，


关于版本和显示日志的版本范围**

可以显示某两个版本之间的日志，就要用到用两个连续的点（点点）来表示版本范围： `<commit-id>..<commit-id>` 。





