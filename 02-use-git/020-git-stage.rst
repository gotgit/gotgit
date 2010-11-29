实践二：修改为何无法提交？
==========================

在“实践一”中，我们主要学习了三个命令："git init", "git add" 和 "git commit"，这三条命令可以说是版本库创建的三部曲。同时我还通过对几个问题的思考，使读者能够了解 Git 版本库在工作区中的布局，Git 三个等级的配置文件以及 Git 的别名命令等内容。

在上一章的实践中，demo 工作区经历了两次提交，我们可以用 "git log" 查看提交日志（附加的 "--stat" 参数看到每次提交的文件变更统计）。

::

  $ cd /my/workspace/demo 
  $ git log --stat
  commit a0c641e92b10d8bcca1ed1bf84ca80340fdefee6
  Author: Jiang Xin <jiangxin@ossxp.com>
  Date:   Mon Nov 29 11:00:06 2010 +0800

      who does commit?

  commit 9e8a761ff9dd343a1380032884f488a2422c495a
  Author: Jiang Xin <jiangxin@ossxp.com>
  Date:   Sun Nov 28 12:48:26 2010 +0800

      initialized.

   welcome.txt |    1 +
   1 files changed, 1 insertions(+), 0 deletions(-)

我们可以看到第一次提交对文件 `welcome.txt` 有一行的变更，而第二次提交则是我们使用了 "--allow-empty" 的一次空提交，不包含任何实质内容的修改。

下面我们仍在这个工作区，继续我们的实践。

首先我们更改 `welcome.txt` 文件，在这个文件后面追加一行。可以使用下面的命令实现内容的追加：

::

  $ echo "Nice to meet you." >> welcome.txt

这时候我们可以通过执行 "git diff" 命令看到我们修改后的文件和版本库中文件的差异。（实际上我这句话有问题，和本地比较的不是版本库中的文件，而是一个中间状态的文件）

::

  $ git diff
  diff --git a/welcome.txt b/welcome.txt
  index 18832d3..fd3c069 100644
  --- a/welcome.txt
  +++ b/welcome.txt
  @@ -1 +1,2 @@
   Hello.
  +Nice to meet you.

差异输出是不是很熟悉？在之前介绍版本库“黑暗的史前时代”的时候，我们展示了 "diff" 命令的输出，两者的格式是一样的。

既然文件修改了，我们就提交吧。提交能够成功么？

::

  $ git commit -m "Append a nice line."
  # On branch master
  # Changes not staged for commit:
  #   (use "git add <file>..." to update what will be committed)
  #   (use "git checkout -- <file>..." to discard changes in working directory)
  #
  #       modified:   welcome.txt
  #
  no changes added to commit (use "git add" and/or "git commit -a")

提交成功了么？好像？我们再来看看日志，是否有新的提交了？

::

  $ git log --pretty=oneline
  a0c641e92b10d8bcca1ed1bf84ca80340fdefee6 who does commit?
  9e8a761ff9dd343a1380032884f488a2422c495a initialized.

我使用了精简输出来显示日志，但是大家仍然能够看出来版本库中只有两个提交，都是在“实践一”中完成的。也就是说刚才针对修改文件的提交没有成功！

这是为什么呢？我们回过头来再仔细看看刚才 "git commit" 命令的输出：

::

  # On branch master
  # Changes not staged for commit:
  #   (use "git add <file>..." to update what will be committed)
  #   (use "git checkout -- <file>..." to discard changes in working directory)
  #
  #       modified:   welcome.txt
  #
  no changes added to commit (use "git add" and/or "git commit -a")

我把它翻译成中文普通话：

::

  # 位于您当前工作的分支 master 上
  # 下列的修改还没有加入到提交任务（提交暂存区，stage）中，不会被提交：
  #   (使用 "git add <file>..." 命令后，改动就会加入到提交任务中，在下次的提交操作中被提交)
  #   (使用 "git checkout -- <file>..." 命令，工作区当前您不打算提交的修改会被彻底清除！！！)
  #
  #       已修改:   welcome.txt
  #
  警告：提交任务是空的噻，您不要再搔扰我啦 (除非使用 "git add" 和/或 "git commit -a" 命令)

此时如果您执行 "git diff" 可以看到和之前相同的差异输出，也说明了我们的提交没有成功。

现在我们执行 "git status" 查看文件状态，也可以看到文件处于未提交的状态。

::

  $ git status
  # On branch master
  # Changes not staged for commit:
  #   (use "git add <file>..." to update what will be committed)
  #   (use "git checkout -- <file>..." to discard changes in working directory)
  #
  #       modified:   welcome.txt
  #
  no changes added to commit (use "git add" and/or "git commit -a")

这个输出怎么和 "git commit" 提交失败的输出信息一模一样！对于习惯了像 CVS 和 Subversion 那样简练的状态输出的用户，可以在执行 "git status" 时附加上 "-s" 参数，如下：

::

  $ git status -s
   M welcome.txt

好了，现在我们按照前面 "git commit" 输出信息或者 "git status" 输出信息中的指示去操作，执行 "git add"，将修改了的 `welcome.txt` 文件增加到提交任务中。

::

  $ git add welcome.txt

然后我们再执行 "git status" 命令，看看输出：

::

  $ git status
  # On branch master
  # Changes to be committed:
  #   (use "git reset HEAD <file>..." to unstage)
  #
  #       modified:   welcome.txt
  #

我再做一回翻译：

::

  $ git status
  # 位于分支 master 上
  # 下列的修改将被提交：
  #   (如果你后悔了，可以使用 "git reset HEAD <file>..." 命令
  #    将下列改动撤出提交任务（提交暂存区, stage），否则执行提交命令可真的要提交喽)
  #
  #       已修改:   welcome.txt
  #

我真的要说，Git 太人性化了，它把各种情况你可以使用到的命令都告诉你了，虽然这显得有点罗嗦。如果不要这么罗嗦，可以用简洁方式显示状态：

::

  $ git status -s
  M  welcome.txt

上面的输出与执行 "git add" 之前的精简状态输出相比，有细微的差别。虽然都是 M（Modified）标识，但是位置不一样。在执行 "git add" 命令之前，这个 "M" 位于第二列（第一列是一个空格），在执行完 "git add" 之后，字符 "M" 位于第一列（第二列是空白）。

位于第一列的字符 "M" 的含义是：版本库中的文件和处于中间状态 —— 提交任务（提交暂存区, stage）中的文件相比有改动，位于第二列的字符 "M" 的含义是：工作区当前的文件和处于中间状态 —— 提交任务（提交暂存区, stage）中的文件相比也有改动。如果能够理解这句话的含义，下面的现象就好解释了。

* 执行 "git diff" 没有输出：

  ::

    $ git diff

* 执行 "git diff master" 或者执行 "git diff HEAD"，拿工作区和当前工作分支 master 进行比较，会发现包含差异输出：

  ::

    $ git diff master
    diff --git a/welcome.txt b/welcome.txt
    index 18832d3..fd3c069 100644
    --- a/welcome.txt
    +++ b/welcome.txt
    @@ -1 +1,2 @@
     Hello.
    +Nice to meet you.

我们不忙着执行提交，我们继续修改一下 `welcome.txt` 文件（在文件后面再追加一行）。

::

  $ echo "Bye-Bye." >> welcome.txt 

然后执行 "git status"，查看一下状态：

::

  $ git status
  # On branch master
  # Changes to be committed:
  #   (use "git reset HEAD <file>..." to unstage)
  #
  #       modified:   welcome.txt
  #
  # Changes not staged for commit:
  #   (use "git add <file>..." to update what will be committed)
  #   (use "git checkout -- <file>..." to discard changes in working directory)
  #
  #       modified:   welcome.txt
  #

状态输出中居然是之前出现的两种不同状态输出的附体。如果显示精简的状态输出，也会看到前面两种精简输出的混合体：

::

  $ git status -s
  MM welcome.txt



这就说明：版本库中的文件和处于中间状态 —— 提交任务（提交暂存区, stage）中的文件相比有改动，而且工作区当前的文件和处于中间状态 —— 提交任务（提交暂存区, stage）中的文件相比也有改动。我们通过不同格式的 "git diff" 命令可以看到这些不同。

* 不带任何选项和参数调用 "git diff" 显示工作区最新改动，即工作区和 提交任务/提交暂存区/stage 中相比。

  ::

    $ git diff
    diff --git a/welcome.txt b/welcome.txt
    index fd3c069..51dbfd2 100644
    --- a/welcome.txt
    +++ b/welcome.txt
    @@ -1,2 +1,3 @@
     Hello.
     Nice to meet you.
    +Bye-Bye.

* 将工作区和 HEAD（当前工作分支）相比，我们会看到更多的差异。

  ::

    $ git diff HEAD
    diff --git a/welcome.txt b/welcome.txt
    index 18832d3..51dbfd2 100644
    --- a/welcome.txt
    +++ b/welcome.txt
    @@ -1 +1,3 @@
     Hello.
    +Nice to meet you.
    +Bye-Bye.

* 通过参数 "--cached" 或者 "--staged" 参数调用 "git diff" 命令，看到的是提交暂存区（提交任务，stage）和版本库中文件的对比。

  ::

    $ git diff --cached
    diff --git a/welcome.txt b/welcome.txt
    index 18832d3..fd3c069 100644
    --- a/welcome.txt
    +++ b/welcome.txt
    @@ -1 +1,2 @@
     Hello.
    +Nice to meet you.

现在我们执行 "git commit" 命令进行提交，文件 `welcome.txt` 的哪个版本会被提交呢？

::

  $ git commit -m "which version checked in?"
  [master e695606] which version checked in?
   1 files changed, 1 insertions(+), 0 deletions(-)

通过查看提交日志，我们看到了新的提交。

::

  $ git log --pretty=oneline
  e695606fc5e31b2ff9038a48a3d363f4c21a3d86 which version checked in?
  a0c641e92b10d8bcca1ed1bf84ca80340fdefee6 who does commit?
  9e8a761ff9dd343a1380032884f488a2422c495a initialized.

精简的状态输出，我们看到了一个 "M"，即只位于第二列的 "M"。

::

  $ git status -s
   M welcome.txt

那么第一列的 "M" 哪里去了？被提交了呗。即提交任务（提交暂存区, stage）中的内容被提交到版本库中，所以第一列因为提交暂存区（提交任务, stage）和版本库中的状态一致，所以显示一个空白。

执行 "git diff" 或者 "git diff HEAD" 命令，虽然比较的过程并不不同（可以通过 strace 命令跟踪命令执行过程中的文件访问），但是我们都会看到下面相同的差异输出结果。

::

  $ git diff
  diff --git a/welcome.txt b/welcome.txt
  index fd3c069..51dbfd2 100644
  --- a/welcome.txt
  +++ b/welcome.txt
  @@ -1,2 +1,3 @@
   Hello.
   Nice to meet you.
  +Bye-Bye.

理解 Git 暂存区（stage）
-------------------------

把上面的“实践二”从头至尾走一遍，不知道您的感想如何？

* —— “被眼花缭乱的 Git 魔法彻底搞糊涂了？”
* —— “Git 为什么这么折磨人，修改的文件直接提交不就完了么？”
* —— “看不出 Git 这么做有什么好处？”

在“实践二”的过程中，我有意无意的透漏了“暂存区”的概念，为了避免用户被新概念吓坏，在暂存区出现的地方用同时使用了“提交任务”这一更易理解的概念，但是暂存区（stage, 或称为 index）才是其真正的名称。我认为 Git 暂存区（stage, 或称为 index）的设计是 Git 最成功的设计之一，也是最难理解的一个设计。

在版本库（.git）目录下，有一个 index 文件，我们针对这个文件做一个有趣的试验。

首先我们执行 "git checkout" 命令撤销工作区中 `welcome.txt` 文件尚未提交的修改。

::

  $ git checkout -- welcome.txt
  $ git status -s

我们通过状态输出，看以看到工作区已经没有改动了。我们查看一下 `.git/index` 文件，注意该文件的时间戳：

::

  $ ls --full-time .git/index 
  -rw-r--r-- 1 jiangxin jiangxin 112 2010-11-29 19:37:44.625246224 +0800 .git/index

我们再次执行 "git status" 命令，然后显示 `.git/index` 文件的时间戳，和上面的一样。

::

  $ git status -s
  $ ls --full-time .git/index 
  -rw-r--r-- 1 jiangxin jiangxin 112 2010-11-29 19:37:44.625246224 +0800 .git/index

现在我们更改一下 welcome.txt 的时间戳，但是不改变它的内容。然后再执行 "git status" 命令，然后查看 `.git/index` 文件时间戳。

::

  $ touch welcome.txt
  $ git status -s
  $ ls --full-time .git/index 
  -rw-r--r-- 1 jiangxin jiangxin 112 2010-11-29 19:42:06.980243216 +0800 .git/index

看到了么，时间戳改变了！

这个试验说明当执行 "git status" 命令扫描工作区改动的时候，先依据 `.git/index` 文件中记录的（工作区跟踪文件的）时间戳、长度等信息判断工作区文件是否改变。如果工作区的文件时间戳改变，会读取文件，如果文件内容没有改变，则将该文件新的时间戳记录到 `.git/index` 文件中。这样的实现可以实现更高的工作区状态扫描速度，这也是 Git 速度快的因素之一。

文件 `.git/index` 就像是一个虚拟的工作区，记录了文件名、文件的状态信息（时间戳、文件长度等），而且还记录了在 Git 对象库（.git/objects）中对应的对象ID。当对修改（或新增）的文件执行 "git add" 命令，修改（或新增）的文件内容被写入到对象库（.git/objects）下的一个新的对象中，而该对象的ID被记录在 `.git/index` 文件中。当执行提交操作（git commit）时，这个虚拟的工作区作为一个新的目录树（tree）写入 Git 库中。这个机制就好像是存在一个提交的暂存区（stage），这就是暂存区的奥秘。


思考：如何将文件添加至暂存区？
-------------------------------


思考：如何撤销暂存区中的文件？
--------------------------------


