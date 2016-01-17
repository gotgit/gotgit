Git检出
********

在上一章学习了重置命令（\ :command:`git reset`\ ）。重置命令的一个用途就\
是修改引用（如master）的游标。实际上在执行重置命令的时候没有使用任何参数\
对所要重置的分支名进行设置，这是因为重置命名实际上所针对的是头指针HEAD。\
之所以没有改变HEAD的内容是因为HEAD指向了一个引用\ ``refs/heads/master``\，\
所以重置命令体现为分支“游标”的变更，HEAD本身一直指向的是refs/heads/master，\
并没有在重置时改变。

如果HEAD的内容不能改变而一直都指向master分支，那么Git如此精妙的分支设计\
岂不浪费？如果HEAD要改变该如何改变呢？本章将学习检出命令\
（\ :command:`git checkout`\ ），该命令的实质就是修改HEAD本身的指向，\
该命令不会影响分支“游标”（如master）。

HEAD的重置即检出
=========================

HEAD可以理解为“头指针”，是当前工作区的“基础版本”，当执行提交时，HEAD指向\
的提交将作为新提交的父提交。看看当前HEAD的指向。

::

  $ cat .git/HEAD
  ref: refs/heads/master

可以看出HEAD指向了分支 master。此时执行\ :command:`git branch`\ 会看到当\
前处于master分支。

::

  $ git branch -v
  * master 4902dc3 does master follow this new commit?
  
现在使用\ :command:`git checkout`\ 命令检出该ID的父提交，看看会怎样。

::

  $ git checkout 4902dc3^
  Note: checking out '4902dc3^'.

  You are in 'detached HEAD' state. You can look around, make experimental
  changes and commit them, and you can discard any commits you make in this
  state without impacting any branches by performing another checkout.

  If you want to create a new branch to retain commits you create, you may
  do so (now or later) by using -b with the checkout command again. Example:

    git checkout -b new_branch_name

  HEAD is now at e695606... which version checked in?

出现了大段的输出！翻译一下，Git肯定又是在提醒我们了。

::

  $ git checkout 4902dc3^
  注意: 正检出 '4902dc3^'.

  您现在处于 '分离头指针' 状态。您可以检查、测试和提交，而不影响任何分支。
  通过执行另外的一个 checkout 检出指令会丢弃在此状态下的修改和提交。

  如果想保留在此状态下的修改和提交，使用 -b 参数调用 checkout 检出指令以
  创建新的跟踪分支。如：

    git checkout -b new_branch_name

  头指针现在指向 e695606... 提交说明为： which version checked in?

什么叫做“分离头指针”状态？查看一下此时HEAD的内容就明白了。

::

  $ cat .git/HEAD
  e695606fc5e31b2ff9038a48a3d363f4c21a3d86

原来“分离头指针”状态指的就是HEAD头指针指向了一个具体的提交ID，而不是一个\
引用（分支）。

查看最新提交的reflog也可以看到当针对提交执行\ :command:`git checkout`\
命令时，HEAD头指针被更改了：由指向master分支变成了指向一个提交ID。

::

  $ git reflog -1
  e695606 HEAD@{0}: checkout: moving from master to 4902dc3^

注意上面的reflog是HEAD头指针的变迁记录，而非master分支。

查看一下HEAD和master对应的提交ID，会发现现在它们指向的不一样。

::

  $ git rev-parse HEAD master
  e695606fc5e31b2ff9038a48a3d363f4c21a3d86
  4902dc375672fbf52a226e0354100b75d4fe31e3

前一个是HEAD头指针的指向，后一个是master分支的指向。而且还可以看到执行\
:command:`git checkout`\ 命令并不像\ :command:`git reset`\ 命令，分支\
（master）的指向并没有改变，仍旧指向原有的提交ID。

现在版本库的HEAD是基于\ ``e695606``\ 提交的。再做一次提交，HEAD会如何\
变化呢？

* 先做一次修改：创建一个新文件\ :file:`detached-commit.txt`\ ，添加到\
  暂存区中。

  ::

    $ touch detached-commit.txt
    $ git add detached-commit.txt

* 看一下状态，会发现其中有：“当前不处于任何分支”的字样，显然这是因为HEAD\
  处于“分离头指针”模式。

  ::

    $ git status
    # Not currently on any branch.
    # Changes to be committed:
    #   (use "git reset HEAD <file>..." to unstage)
    #
    #       new file:   detached-commit.txt
    #

* 执行提交。在提交输出中也会出现\ ``[detached HEAD ...]``\ 的标识，也是\
  对用户的警示。

  ::

    $ git commit -m "commit in detached HEAD mode."
    [detached HEAD acc2f69] commit in detached HEAD mode.
     0 files changed, 0 insertions(+), 0 deletions(-)
     create mode 100644 detached-commit.txt

* 此时头指针指向了新的提交。

  ::

    $ cat .git/HEAD
    acc2f69cf6f0ae346732382c819080df75bb2191

* 再查看一下日志会发现新的提交是建立在之前的提交基础上的。

  ::

    $ git log --graph --pretty=oneline
    * acc2f69cf6f0ae346732382c819080df75bb2191 commit in detached HEAD mode.
    * e695606fc5e31b2ff9038a48a3d363f4c21a3d86 which version checked in?
    * a0c641e92b10d8bcca1ed1bf84ca80340fdefee6 who does commit?
    * 9e8a761ff9dd343a1380032884f488a2422c495a initialized.


记下新的提交ID（acc2f69），然后以master分支名作为参数执行\
:command:`git checkout`\ 命令，会切换到master分支上。

* 切换到master分支。没有之前大段的文字警告。

  ::

    $ git checkout master
    Previous HEAD position was acc2f69... commit in detached HEAD mode.
    Switched to branch 'master'

* 因为HEAD头指针重新指向了分支，而不是处于“断头模式”（分离头指针模式）。

  ::

    $ cat .git/HEAD 
    ref: refs/heads/master

* 切换之后，之前本地建立的新文件\ :file:`detached-commit.txt`\ 不见了。

  ::

    $ ls
    new-commit.txt  welcome.txt

* 切换之后，刚才的提交日志也不见了。

  ::

    $ git log --graph --pretty=oneline
    * 4902dc375672fbf52a226e0354100b75d4fe31e3 does master follow this new commit?
    * e695606fc5e31b2ff9038a48a3d363f4c21a3d86 which version checked in?
    * a0c641e92b10d8bcca1ed1bf84ca80340fdefee6 who does commit?
    * 9e8a761ff9dd343a1380032884f488a2422c495a initialized.

刚才的提交在版本库的对象库中还存在么？看看刚才记下的提交ID。

::

  $ git show acc2f69
  commit acc2f69cf6f0ae346732382c819080df75bb2191
  Author: Jiang Xin <jiangxin@ossxp.com>
  Date:   Sun Dec 5 15:43:24 2010 +0800

      commit in detached HEAD mode.

  diff --git a/detached-commit.txt b/detached-commit.txt
  new file mode 100644
  index 0000000..e69de29

可以看出这个提交现在仍在版本库中。由于这个提交没有被任何分支跟踪到，因此\
并不能保证这个提交会永久存在。实际上当reflog中含有该提交的日志过期后，这\
个提交随时都会从版本库中彻底清除。

挽救分离头指针
===============

在“分离头指针”模式下进行的测试提交除了使用提交ID（acc2f69）访问之外，\
不能通过master分支或其他引用访问到。如果这个提交是master分支所需要的，\
那么该如何处理呢？如果使用上一章介绍的\ :command:`git reset`\ 命令，\
的确可以将master分支重置到该测试提交\ ``acc2f69``\ ，但是如果那样就会丢掉\
master分支原先的提交\ ``4902dc3``\ 。使用合并操作（\ :command:`git merge`\ ）\
可以实现两者的兼顾。

下面的操作会将提交\ ``acc2f69``\ 合并到master分支中来。

* 确认当前处于master分支。

  ::

    $ git branch -v
    * master 4902dc3 does master follow this new commit?

* 执行合并操作，将\ ``acc2f69``\ 提交合并到当前分支。

  ::

    $ git merge acc2f69
    Merge made by recursive.
     0 files changed, 0 insertions(+), 0 deletions(-)
     create mode 100644 detached-commit.txt

* 工作区中多了一个\ :file:`detached-commit.txt`\ 文件。

  ::

    $ ls 
    detached-commit.txt  new-commit.txt  welcome.txt

* 查看日志，会看到不一样的分支图。即在\ ``e695606``\ 提交开始出现了开发\
  分支，而分支在最新的\ ``2b31c19``\ 提交发生了合并。

  ::

    $ git log --graph --pretty=oneline
    *   2b31c199d5b81099d2ecd91619027ab63e8974ef Merge commit 'acc2f69'
    |\  
    | * acc2f69cf6f0ae346732382c819080df75bb2191 commit in detached HEAD mode.
    * | 4902dc375672fbf52a226e0354100b75d4fe31e3 does master follow this new commit?
    |/  
    * e695606fc5e31b2ff9038a48a3d363f4c21a3d86 which version checked in?
    * a0c641e92b10d8bcca1ed1bf84ca80340fdefee6 who does commit?
    * 9e8a761ff9dd343a1380032884f488a2422c495a initialized.

* 仔细看看最新提交，会看到这个提交有两个父提交。这就是合并的奥秘。

  ::

    $ git cat-file -p HEAD
    tree ab676f92936000457b01507e04f4058e855d4df0
    parent 4902dc375672fbf52a226e0354100b75d4fe31e3
    parent acc2f69cf6f0ae346732382c819080df75bb2191
    author Jiang Xin <jiangxin@ossxp.com> 1291535485 +0800
    committer Jiang Xin <jiangxin@ossxp.com> 1291535485 +0800

    Merge commit 'acc2f69'

深入了解\ :command:`git checkout`\ 命令
==========================================

检出命令（\ :command:`git checkout`\ ）是Git最常用的命令之一，同样也很危\
险，因为这条命令会重写工作区。

::

  用法一： git checkout [-q] [<commit>] [--] <paths>...
  用法二： git checkout [<branch>]
  用法三： git checkout [-m] [[-b|--orphan] <new_branch>] [<start_point>]


上面列出的第一种用法和第二种用法的区别在于，第一种用法在命令中包含路径\
:file:`<paths>`\ 。为了避免路径和引用（或者提交ID）同名而冲突，可以在\
:file:`<paths>`\ 前用两个连续的短线（减号）作为分隔。

第一种用法的\ ``<commit>``\ 是可选项，如果省略则相当于从暂存区（index）\
进行检出。这和上一章的重置命令大不相同：重置的默认值是 HEAD，而检出的默\
认值是暂存区。因此重置一般用于重置暂存区（除非使用\ ``--hard``\ 参数，\
否则不重置工作区），而检出命令主要是覆盖工作区（如果\ ``<commit>``\ 不省略，\
也会替换暂存区中相应的文件）。

第一种用法（包含了路径\ :file:`<paths>`\ 的用法）\ **不会**\ 改变HEAD\
头指针，主要是用于指定版本的文件覆盖工作区中对应的文件。如果省略\
``<commit>``\ ，会拿暂存区的文件覆盖工作区的文件，否则用指定提交中的文件\
覆盖暂存区和工作区中对应的文件。

第二种用法（不使用路径\ :file:`<paths>`\ 的用法）则会\ **改变**\ HEAD\
头指针。之所以后面的参数写作\ ``<branch>``\ ，是因为只有HEAD切换到一个\
分支才可以对提交进行跟踪，否则仍然会进入“分离头指针”的状态。在“分离头指针”\
状态下的提交不能被引用关联到而可能会丢失。所以用法二最主要的作用就是切换\
到分支。如果省略\ ``<branch>``\ 则相当于对工作区进行状态检查。

第三种用法主要是创建和切换到新的分支（\ ``<new_branch>``\ ），新的分支从\
``<start_point>``\ 指定的提交开始创建。新分支和我们熟悉的master分支没有\
什么实质的不同，都是在\ ``refs/heads``\ 命名空间下的引用。关于分支和\
:command:`git checkout`\ 命令的这个用法会在后面的章节做具体的介绍。

下面的版本库模型图描述了\ :command:`git checkout`\ 实际完成的操作。

  .. figure:: /images/git-solo/git-checkout.png
     :scale: 80

下面通过一些示例，具体的看一下检出命令的不同用法。

* 命令：\ :command:`git checkout branch`

  检出branch分支。要完成如图的三个步骤，更新HEAD以指向branch分支，\
  以branch指向的树更新暂存区和工作区。

* 命令：\ :command:`git checkout`

  汇总显示工作区、暂存区与HEAD的差异。

* 命令：\ :command:`git checkout HEAD`

  同上。

* 命令：\ :command:`git checkout -- filename`

  用暂存区中\ :file:`filename`\ 文件来覆盖工作区中的\ :file:`filename`\
  文件。相当于取消自上次执行\ :command:`git add filename`\ 以来\
  （如果执行过）本地的修改。

  这个命令很危险，因为对于本地的修改会悄无声息的覆盖，毫不留情。

* 命令：\ :command:`git checkout branch -- filename`

  维持HEAD的指向不变。将branch所指向的提交中的\ :file:`filename`\
  替换暂存区和工作区中相应的文件。注意会将暂存区和工作区中的\
  :file:`filename`\ 文件直接覆盖。

* 命令：\ :command:`git checkout -- . 或写做 git checkout .`

  注意：\ :command:`git checkout`\ 命令后的参数为一个点（“.”）。这条命令\
  最危险！会取消所有本地的修改（相对于暂存区）。相当于将暂存区的所有文件\
  直接覆盖本地文件，不给用户任何确认的机会！
