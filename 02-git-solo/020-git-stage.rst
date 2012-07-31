Git暂存区
**********

上一章主要学习了三个命令：\ :command:`git init`\ 、\ :command:`git add`\
和\ :command:`git commit`\ ，这三条命令可以说是版本库创建的三部曲。\
同时还通过对几个问题的思考，使读者能够了解Git版本库在工作区中的布局，\
Git三个等级的配置文件以及Git的别名命令等内容。

在上一章的实践中，DEMO版本库经历了两次提交，可以用\ :command:`git log`\
查看提交日志（附加的\ ``--stat``\ 参数看到每次提交的文件变更统计）。

::

  $ cd /path/to/my/workspace/demo 
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

可以看到第一次提交对文件\ :file:`welcome.txt`\ 有一行的变更，而第二次\
提交因为是使用了\ ``--allow-empty``\ 参数进行的一次空提交，所以提交说明中\
看不到任何对实质内容的修改。

下面仍在这个工作区，继续新的实践。通过新的实践学习Git一个最重要的概念：\
“暂存区”。

修改不能直接提交？
==========================

首先更改\ :file:`welcome.txt`\ 文件，在这个文件后面追加一行。可以使用\
下面的命令实现内容的追加。

::

  $ echo "Nice to meet you." >> welcome.txt

这时可以通过执行\ :command:`git diff`\ 命令看到修改后的文件和版本库中\
文件的差异。（实际上这句话有问题，和本地比较的不是版本库中的文件，而是\
一个中间状态的文件）

::

  $ git diff
  diff --git a/welcome.txt b/welcome.txt
  index 18832d3..fd3c069 100644
  --- a/welcome.txt
  +++ b/welcome.txt
  @@ -1 +1,2 @@
   Hello.
  +Nice to meet you.

差异输出是不是很熟悉？在之前介绍版本库“黑暗的史前时代”的时候，曾经展示了\
:command:`diff`\ 命令的输出，两者的格式是一样的。

既然文件修改了，那么就提交吧。提交能够成功么？

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

提交成功了么？好像没有！

提交没有成功的证据：

* 先来看看提交日志，如果提交成功，应该有新的提交记录出现。

  下面使用了精简输出来显示日志，以便更简洁和清晰的看到提交历史。在其中\
  能够看出来版本库中只有两个提交，都是在上一章的实践中完成的。也就是说\
  刚才针对修改文件的提交没有成功！

  ::

    $ git log --pretty=oneline
    a0c641e92b10d8bcca1ed1bf84ca80340fdefee6 who does commit?
    9e8a761ff9dd343a1380032884f488a2422c495a initialized.

* 执行\ :command:`git diff`\ 可以看到和之前相同的差异输出，这也说明了\
  之前的提交没有成功。

* 执行\ :command:`git status`\ 查看文件状态，也可以看到文件处于未提交的\
  状态。

  而且\ :command:`git status`\ 命令的输出和\ :command:`git commit`\ 提交\
  失败的输出信息一模一样！

* 对于习惯了像 CVS 和 Subversion 那样简练的状态输出的用户，可以在执行\
  :command:`git status` 时附加上\ ``-s``\ 参数，显示精简格式的状态输出。

  ::

    $ git status -s
     M welcome.txt


提交为什么会失败呢？再回过头来仔细看看刚才\ :command:`git commit`\ 命令\
提交失败后的输出：

  ::

    # On branch master
    # Changes not staged for commit:
    #   (use "git add <file>..." to update what will be committed)
    #   (use "git checkout -- <file>..." to discard changes in working directory)
    #
    #       modified:   welcome.txt
    #
    no changes added to commit (use "git add" and/or "git commit -a")

把它翻译成中文普通话：

  ::

    # 位于您当前工作的分支 master 上
    # 下列的修改还没有加入到提交任务（提交暂存区，stage）中，不会被提交：
    #   (使用 "git add <file>..." 命令后，改动就会加入到提交任务中，
    #    要在下一次提交操作时才被提交)
    #   (使用 "git checkout -- <file>..." 命令，工作区当前您不打算提交的
    #    修改会被彻底清除！！！)
    #
    #       已修改:   welcome.txt
    #
    警告：提交任务是空的噻，您不要再搔扰我啦 
    (除非使用 "git add" 和/或 "git commit -a" 命令)

也就是说要对修改的\ :file:`welcome.txt`\ 文件执行\ :command:`git add`\
命令，将修改的文件添加到“提交任务”中，然后才能提交！

这个行为真的很奇怪，因为\ ``add``\ 操作对于其他版本控制系统来说是向版本库\
添加新文件用的，修改的文件（已被版本控制跟踪的文件）在下次提交时会直接被\
提交。Git的这个古怪的行为会在下面的介绍中找到答案，读者会逐渐习惯并喜欢\
Git的这个设计。

好了，现在就将修改的文件“添加”到提交任务中吧：

::

  $ git add welcome.txt

现在再执行一些Git命令，看看当执行文“添加”动作后，Git库发生了什么变化：

* 执行\ :command:`git diff`\ 没有输出，难道是被提交了？可是只是执行了\
  “添加” 到提交任务的操作，相当于一个“登记”的命令，并没有执行提交哇？

  ::

    $ git diff

* 这时如果和HEAD（当前版本库的头指针）或者master分支（当前工作分支）\
  进行比较，会发现有差异。这个差异才是正常的，因为尚未真正提交么。

  ::

    $ git diff HEAD
    diff --git a/welcome.txt b/welcome.txt
    index 18832d3..fd3c069 100644
    --- a/welcome.txt
    +++ b/welcome.txt
    @@ -1 +1,2 @@
     Hello.
    +Nice to meet you.

* 执行\ :command:`git status`\ 命令，状态输出和之前的不一样了。

  ::

    $ git status
    # On branch master
    # Changes to be committed:
    #   (use "git reset HEAD <file>..." to unstage)
    #
    #       modified:   welcome.txt
    #

再对新的Git状态输出做一回翻译：

  ::

    $ git status
    # 位于分支 master 上
    # 下列的修改将被提交：
    #   (如果你后悔了，可以使用 "git reset HEAD <file>..." 命令
    #    将下列改动撤出提交任务（提交暂存区, stage），否则
    #    执行提交命令可真的要提交喽)
    #
    #       已修改:   welcome.txt
    #

不得不说，Git太人性化了，它把各种情况下可以使用到的命令都告诉给用户了，\
虽然这显得有点罗嗦。如果不要这么罗嗦，可以用简洁方式显示状态：

::

  $ git status -s
  M  welcome.txt

上面精简的状态输出与执行\ :command:`git add`\ 之前的精简状态输出相比，\
有细微的差别，发现了么？

* 虽然都是 M（Modified）标识，但是位置不一样。在执行\ :command:`git add`\
  命令之前，这个\ ``M``\ 位于第二列（第一列是一个空格），在执行完\
  :command:`git add`\ 之后，字符\ ``M``\ 位于第一列（第二列是空白）。

* 位于第一列的字符\ ``M``\ 的含义是：版本库中的文件和处于中间状态——\
  提交任务（提交暂存区，即stage）中的文件相比有改动。

* 位于第二列的字符\ ``M``\ 的含义是：工作区当前的文件和处于中间状态——\
  提交任务（提交暂存区，即stage）中的文件相比也有改动。

是不是还有一些不明白？为什么Git的状态输出中提示了那么多让人不解的命令？\
为什么存在一个提交任务的概念而又总是把它叫做暂存区（stage）？不要紧，\
马上就会专题讲述“暂存区”的概念。当了解了Git版本库的设计原理之后，理解\
相关Git命令就易如反掌了。

这时如果直接提交（\ :command:`git commit`\ ），加入提交任务的\
:file:`welcome.txt`\ 文件的更改就被提交入库了。但是先不忙着执行提交，\
再进行一些操作，看看能否被彻底的搞糊涂。

* 继续修改一下\ :file:`welcome.txt`\ 文件（在文件后面再追加一行）。

  ::

    $ echo "Bye-Bye." >> welcome.txt 

* 然后执行\ :command:`git status`\ ，查看一下状态：

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

  状态输出中居然是之前出现的两种不同状态输出的灵魂附体。

* 如果显示精简的状态输出，也会看到前面两种精简输出的杂合体。

  ::

    $ git status -s
    MM welcome.txt

上面的更为复杂的 Git 状态输出可以这么理解：不但版本库中最新提交的文件和\
处于中间状态 —— 提交任务（提交暂存区, stage）中的文件相比有改动，而且工\
作区当前的文件和处于中间状态 —— 提交任务（提交暂存区, stage）中的文件相\
比也有改动。

即现在\ :file:`welcome.txt`\ 有三个不同的版本，一个在工作区，一个在等待\
提交的暂存区，还有一个是版本库中最新版本的\ :file:`welcome.txt`\ 。通过\
不同的参数调用\ :command:`git diff`\ 命令可以看到不同版本库\
:file:`welcome.txt`\ 文件的差异。

* 不带任何选项和参数调用\ :command:`git diff`\ 显示工作区最新改动，\
  即工作区和提交任务（提交暂存区，stage）中相比的差异。

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

* 将工作区和HEAD（当前工作分支）相比，会看到更多的差异。

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

* 通过参数\ ``--cached``\ 或者\ ``--staged``\ 参数调用\
  :command:`git diff`\ 命令，看到的是提交暂存区（提交任务，stage）\
  和版本库中文件的差异。

  ::

    $ git diff --cached
    diff --git a/welcome.txt b/welcome.txt
    index 18832d3..fd3c069 100644
    --- a/welcome.txt
    +++ b/welcome.txt
    @@ -1 +1,2 @@
     Hello.
    +Nice to meet you.

好了现在是时候\ **提交**\ 了。现在执行\ :command:`git commit`\
命令进行提交。


::

  $ git commit -m "which version checked in?"
  [master e695606] which version checked in?
   1 files changed, 1 insertions(+), 0 deletions(-)

这次提交终于成功了。如何证明提交成功了呢？

* 通过查看提交日志，看到了新的提交。

  ::

    $ git log --pretty=oneline
    e695606fc5e31b2ff9038a48a3d363f4c21a3d86 which version checked in?
    a0c641e92b10d8bcca1ed1bf84ca80340fdefee6 who does commit?
    9e8a761ff9dd343a1380032884f488a2422c495a initialized.

* 查看精简的状态输出。

  状态输出中文件名的前面出现了一个字母\ ``M``\ ，即只位于第二列的字母\
  ``M``\ 。

  ::

    $ git status -s
     M welcome.txt

那么第一列的\ ``M``\ 哪里去了？被提交了呗。即提交任务（提交暂存区，stage）\
中的内容被提交到版本库中，所以第一列因为提交暂存区（提交任务，stage）和\
版本库中的状态一致，所以显示一个空白。

提交的\ :file:`welcome.txt`\ 是哪个版本呢？可以通过执行\ :command:`git diff`\
或者\ :command:`git diff HEAD`\ 命令查看差异。虽然命令\ :command:`git diff`\
和\ :command:`git diff HEAD`\ 的比较过程并不不同（可以通过\ :command:`strace`\
命令跟踪命令执行过程中的文件访问），但是会看到下面相同的差异输出结果。

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
========================

把上面的实践从头至尾走一遍，不知道读者的感想如何？

* ——“被眼花缭乱的Git魔法彻底搞糊涂了？”
* ——“Git为什么这么折磨人，修改的文件直接提交不就完了么？”
* ——“看不出Git这么做有什么好处？”

在上面的实践过程中，有意无意的透漏了“暂存区”的概念。为了避免用户被新概念\
吓坏，在暂存区出现的地方用同时使用了“提交任务”这一更易理解的概念，但是\
暂存区（stage，或称为index）才是其真正的名称。我认为Git暂存区\
（stage，或称为index）的设计是Git最成功的设计之一，也是最难理解的一个设计。

在版本库\ :file:`.git`\ 目录下，有一个\ :file:`index`\ 文件，下面针对\
这个文件做一个有趣的试验。要说明的是：这个试验是用1.7.3版本的Git进行的，\
低版本的Git因为没有针对\ :command:`git status`\ 命令进行优化设计，需要使用\
:command:`git diff`\ 命令，才能看到\ :file:`index`\ 文件的日期戳变化。

首先执行\ :command:`git checkout`\ 命令（后面会介绍此命令），撤销工作区\
中 `welcome.txt` 文件尚未提交的修改。

::

  $ git checkout -- welcome.txt
  $ git status -s     # 执行 git diff ，如果 git 版本号小于 1.7.3

通过状态输出，看以看到工作区已经没有改动了。查看一下\ :command:`.git/index`\
文件，注意该文件的时间戳为：19:37:44。

::

  $ ls --full-time .git/index 
  -rw-r--r-- 1 jiangxin jiangxin 112 2010-11-29 19:37:44.625246224 +0800.git/index

再次执行\ :command:`git status`\ 命令，然后显示\ :file:`.git/index`\
文件的时间戳为：19:37:44，和上面的一样。

::

  $ git status -s     # 执行 git diff ，如果 git 版本号小于 1.7.3
  $ ls --full-time .git/index 
  -rw-r--r-- 1 jiangxin jiangxin 112 2010-11-29 19:37:44.625246224 +0800 .git/index

现在更改一下 welcome.txt 的时间戳，但是不改变它的内容。然后再执行\ :command:`git status`\
命令，然后查看\ :file:`.git/index`\ 文件时间戳为：19:42:06。 

::

  $ touch welcome.txt
  $ git status -s     # 执行 git diff ，如果 git 版本号小于 1.7.3
  $ ls --full-time .git/index 
  -rw-r--r-- 1 jiangxin jiangxin 112 2010-11-29 19:42:06.980243216 +0800 .git/index

看到了么，时间戳改变了！

这个试验说明当执行\ :command:`git status`\ 命令（或者\ :command:`git diff`\
命令）扫描工作区改动的时候，先依据\ :file:`.git/index`\ 文件中记录的\
（工作区跟踪文件的）时间戳、长度等信息判断工作区文件是否改变。如果工作区\
的文件时间戳改变，说明文件的内容\ **可能**\ 被改变了，需要要打开文件，\
读取文件内容，和更改前的原始文件相比较，判断文件内容是否被更改。如果文件\
内容没有改变，则将该文件新的时间戳记录到\ :file:`.git/index`\ 文件中。\
因为判断文件是否更改，使用时间戳、文件长度等信息进行比较要比通过文件内容\
比较要快的多，所以Git这样的实现方式可以让工作区状态扫描更快速的执行，\
这也是Git高效的因素之一。

文件\ :file:`.git/index`\ 实际上就是一个包含文件索引的目录树，像是一个\
虚拟的工作区。在这个虚拟工作区的目录树中，记录了文件名、文件的状态信息\
（时间戳、文件长度等）。文件的内容并不存储其中，而是保存在Git对象库\
:file:`.git/objects`\ 目录中，文件索引建立了文件和对象库中对象实体之间\
的对应。下面这个图展示了工作区、版本库中的暂存区和版本库之间的关系。

  .. figure:: /images/git-solo/git-stage.png
     :scale: 80

     工作区、版本库、暂存区原理图

在这个图中，可以看到部分Git命令是如何影响工作区和暂存区（stage，\
亦称index）的。下面就对这些命令进行简要的说明，而要彻底揭开这些命令\
的面纱要在接下来的几个章节。

* 图中左侧为工作区，右侧为版本库。在版本库中标记为\ ``index``\ 的区域是\
  暂存区（stage，亦称index），标记为\ ``master``\ 的是master分支所代表的\
  目录树。

* 图中可以看出此时HEAD实际是指向master分支的一个“游标”。所以图示的\
  命令中出现HEAD的地方可以用master来替换。

* 图中的objects标识的区域为Git的对象库，实际位于\ :file:`.git/objects`\
  目录下，会在后面的章节重点介绍。

* 当对工作区修改（或新增）的文件执行\ :command:`git add`\ 命令时，暂存区\
  的目录树被更新，同时工作区修改（或新增）的文件内容被写入到对象库中的\
  一个新的对象中，而该对象的ID被记录在暂存区的文件索引中。

* 当执行提交操作（\ :command:`git commit`\ ）时，暂存区的目录树写到版本库\
  （对象库）中，master分支会做相应的更新。即master最新指向的目录树就是\
  提交时原暂存区的目录树。

* 当执行\ :command:`git reset HEAD`\ 命令时，暂存区的目录树会被重写，被\
  master分支指向的目录树所替换，但是工作区不受影响。

* 当执行\ :command:`git rm --cached <file>`\ 命令时，会直接从暂存区删除\
  文件，工作区则不做出改变。

* 当执行\ :command:`git checkout .`\ 或者\ :command:`git checkout -- <file>`\
  命令时，会用暂存区全部或指定的文件替换工作区的文件。这个操作很危险，\
  会清除工作区中未添加到暂存区的改动。

* 当执行\ :command:`git checkout HEAD .`\ 或者\ :command:`git checkout HEAD <file>`\
  命令时，会用HEAD指向的master分支中的全部或者部分文件替换暂存区和以及\
  工作区中的文件。这个命令也是极具危险性的，因为不但会清除工作区中未提交\
  的改动，也会清除暂存区中未提交的改动。


Git Diff魔法
=============

在本章的实践中展示了具有魔法效果的命令：\ :command:`git diff`\ 。在不同\
参数的作用下，\ :command:`git diff`\ 的输出并不相同。在理解了Git中的工作区、\
暂存区、和版本库最新版本（当前分支）分别是三个不同的目录树后，就非常好理解\
:command:`git diff`\ 魔法般的行为了。

**暂存区目录树的浏览**

有什么办法能够像查看工作区一样的，直观的查看暂存区以及HEAD当中的目录树么？

对于HEAD（版本库中当前提交）指向的目录树，可以使用Git底层命令\
:command:`git ls-tree`\ 来查看。

::

  $ git ls-tree -l HEAD
  100644 blob fd3c069c1de4f4bc9b15940f490aeb48852f3c42      25    welcome.txt

其中:

* 使用\ ``-l``\ 参数，可以显示文件的大小。上面\ :file:`welcome.txt`\
  大小为25字节。

* 输出的\ :file:`welcome.txt`\ 文件条目从左至右，第一个字段是文件的属性\
  (rw-r--r--)，第二个字段说明是Git对象库中的一个blob对象（文件），第三个\
  字段则是该文件在对象库中对应的ID——一个40位的SHA1哈希值格式的ID\
  （这个会在后面介绍），第四个字段是文件大小，第五个字段是文件名。

在浏览暂存区中的目录树之前，首先清除工作区当中的改动。通过\
:command:`git clean -fd`\ 命令清除当前工作区中没有加入版本库的文件和目录\
（非跟踪文件和目录），然后执行\ :command:`git checkout .`\ 命令，\
用暂存区内容刷新工作区。

::

  $ cd /path/to/my/workspace/demo 
  $ git clean -fd
  $ git checkout .

然后开始在工作区中做出一些修改（修改\ :file:`welcome.txt`\ ，\
增加一个子目录和文件），然后添加到暂存区。最后再对工作区做出修改。

::

  $ echo "Bye-Bye." >> welcome.txt
  $ mkdir -p a/b/c
  $ echo "Hello." > a/b/c/hello.txt
  $ git add .
  $ echo "Bye-Bye." >> a/b/c/hello.txt
  $ git status -s
  AM a/b/c/hello.txt
  M  welcome.txt

上面的命令运行完毕后，通过精简的状态输出，可以看出工作区、暂存区、\
和版本库当前分支的最新版本（HEAD）各不相同。先来看看工作区中文件的大小：

::

  $ find . -path ./.git -prune -o -type f -printf "%-20p\t%s\n"
  ./welcome.txt           34
  ./a/b/c/hello.txt       16

要显示暂存区的目录树，可以使用\ :command:`git ls-files`\ 命令。

::

  $ git ls-files -s
  100644 18832d35117ef2f013c4009f5b2128dfaeff354f 0       a/b/c/hello.txt
  100644 51dbfd25a804c30e9d8dc441740452534de8264b 0       welcome.txt

注意这个输出和之前使用\ :command:`git ls-tree`\ 命令输出不一样，如果想要\
使用\ :command:`git ls-tree`\ 命令，需要先将暂存区的目录树写入Git对象库\
（用\ :command:`git write-tree`\ 命令），然后在针对\ :command:`git write-tree`\
命令写入的 tree 执行\ :command:`git ls-tree`\ 命令。

::

  $ git write-tree
  9431f4a3f3e1504e03659406faa9529f83cd56f8
  $ git ls-tree -l 9431f4a
  040000 tree 53583ee687fbb2e913d18d508aefd512465b2092       -    a
  100644 blob 51dbfd25a804c30e9d8dc441740452534de8264b      34    welcome.txt

从上面的命令可以看出：

* 到处都是40位的SHA1哈希值格式的ID，可以用于指代文件内容（blob），\
  用于指代目录树（tree），还可以用于指代提交。但什么是SHA1哈希值ID，\
  作用是什么，这些疑问暂时搁置，下一章再揭晓。

* 命令\ :command:`git write-tree`\ 的输出就是写入Git对象库中的Tree ID，\
  这个ID将作为下一条命令的输入。

* 在\ :command:`git ls-tree`\ 命令中，没有把40位的ID写全，而是使用了\
  前几位，实际上只要不和其他的对象ID冲突，可以随心所欲的使用缩写ID。

* 可以看到\ :command:`git ls-tree`\ 的输出显示的第一条是一个tree对象，\
  即刚才创建的一级目录\ :file:`a`\ 。

如果想要递归显示目录内容，则使用\ ``-r``\ 参数调用。使用参数\ ``-t``\
可以把递归过程遇到的每棵树都显示出来，而不只是显示最终的文件。下面执行\
递归操作显示目录树的内容。

::

  $ git write-tree | xargs git ls-tree -l -r -t
  040000 tree 53583ee687fbb2e913d18d508aefd512465b2092       -    a
  040000 tree 514d729095b7bc203cf336723af710d41b84867b       -    a/b
  040000 tree deaec688e84302d4a0b98a1b78a434be1b22ca02       -    a/b/c
  100644 blob 18832d35117ef2f013c4009f5b2128dfaeff354f       7    a/b/c/hello.txt
  100644 blob 51dbfd25a804c30e9d8dc441740452534de8264b      34    welcome.txt


好了现在工作区，暂存区和HEAD三个目录树的内容各不相同。下面的表格总结了\
不同文件在三个目录树中的文件大小。


  +-----------------+----------+----------+----------+
  | 文件名          | 工作区   | 暂存区   | HEAD     |
  +=================+==========+==========+==========+
  | welcome.txt     | 34 字节  | 34 字节  | 25 字节  |
  +-----------------+----------+----------+----------+
  | a/b/c/hello.txt | 16 字节  |  7 字节  |  0 字节  |
  +-----------------+----------+----------+----------+

**Git diff魔法**

通过使用不同的参数调用\ :command:`git diff`\ 命令，可以对工作区、暂存区、\
HEAD中的内容两两比较。下面的这个图，展示了不同的\ :command:`git diff`\
命令的作用范围。

  .. figure:: /images/git-solo/git-diff.png
     :scale: 80

通过上面的图，就不难理解下面\ :command:`git diff`\ 命令不同的输出结果了。

* 工作区和暂存区比较。

  ::

    $ git diff
    diff --git a/a/b/c/hello.txt b/a/b/c/hello.txt
    index 18832d3..e8577ea 100644
    --- a/a/b/c/hello.txt
    +++ b/a/b/c/hello.txt
    @@ -1 +1,2 @@
     Hello.
    +Bye-Bye.

* 暂存区和HEAD比较。

  ::

    $ git diff --cached
    diff --git a/a/b/c/hello.txt b/a/b/c/hello.txt
    new file mode 100644
    index 0000000..18832d3
    --- /dev/null
    +++ b/a/b/c/hello.txt
    @@ -0,0 +1 @@
    +Hello.
    diff --git a/welcome.txt b/welcome.txt
    index fd3c069..51dbfd2 100644
    --- a/welcome.txt
    +++ b/welcome.txt
    @@ -1,2 +1,3 @@
     Hello.
     Nice to meet you.
    +Bye-Bye.

* 工作区和HEAD比较。

  ::

    $ git diff HEAD    
    diff --git a/a/b/c/hello.txt b/a/b/c/hello.txt
    new file mode 100644
    index 0000000..e8577ea
    --- /dev/null
    +++ b/a/b/c/hello.txt
    @@ -0,0 +1,2 @@
    +Hello.
    +Bye-Bye.
    diff --git a/welcome.txt b/welcome.txt
    index fd3c069..51dbfd2 100644
    --- a/welcome.txt
    +++ b/welcome.txt
    @@ -1,2 +1,3 @@
     Hello.
     Nice to meet you.
    +Bye-Bye.

不要使用\ :command:`git commit -a`
======================================

实际上Git的提交命令（\ :command:`git commit`\ ）可以带上\ ``-a``\ 参数，\
对本地所有变更的文件执行提交操作，包括本地修改的文件，删除的文件，\
但不包括未被版本库跟踪的文件。

这个命令的确可以简化一些操作，减少用\ :command:`git add`\ 命令标识\
变更文件的步骤，但是如果习惯了使用这个“偷懒”的提交命令，就会丢掉Git\
暂存区带给用户最大的好处：对提交内容进行控制的能力。

有的用户甚至通过别名设置功能，创建指向命令\ :command:`git commit -a`\
的别名\ ``ci``\ ，这更是不可取的行为，应严格禁止。在本书会很少看到使用\
:command:`git commit -a`\ 命令。

搁置问题，暂存状态
===================

查看一下当前工作区的状态。

::

  $ git status
  # On branch master
  # Changes to be committed:
  #   (use "git reset HEAD <file>..." to unstage)
  #
  #       new file:   a/b/c/hello.txt
  #       modified:   welcome.txt
  #
  # Changes not staged for commit:
  #   (use "git add <file>..." to update what will be committed)
  #   (use "git checkout -- <file>..." to discard changes in working directory)
  #
  #       modified:   a/b/c/hello.txt
  #

在状态输出中Git体贴的告诉了用户如何将加入暂存区的文件从暂存区撤出以便\
让暂存区和HEAD一致（这样提交就不会发生），还告诉用户对于暂存区更新后在\
工作区所做的再一次的修改有两个选择：或者再次添加到暂存区，或者取消工作区\
新做出的改动。但是涉及到的命令现在理解还有些难度，一个是\
:command:`git reset`\ ，一个是\ :command:`git checkout`\ 。\
需要先解决什么是HEAD，什么是master分支以及Git对象存储的实现机制等问题，\
才可以更好的操作暂存区。

为此，我作出一个非常艰难的决定\ [#]_\ ：就是保存当前的工作进度，在研究了HEAD\
和master分支的机制之后，继续对暂存区的探索。命令\ :command:`git stash`\
就是用于保存当前工作进度的。

::

  $ git stash
  Saved working directory and index state WIP on master: e695606 which version checked in?
  HEAD is now at e695606 which version checked in?

运行完\ :command:`git stash`\ 之后，再查看工作区状态，会看见工作区尚未\
提交的改动（包括暂存区的改动）全都不见了。

::

  $ git status
  # On branch master
  nothing to commit (working directory clean)

"I'll be back" ——  施瓦辛格, 《终结者》, 1984.

.. [#] 此句式模仿2010年11月份发生的“3Q大战”。参见：\ http://zh.wikipedia.org/wiki/奇虎360与腾讯QQ争斗事件\ 。
