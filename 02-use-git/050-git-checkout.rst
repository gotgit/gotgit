Git 检出
********


在“实践四”中，学习了重置命令（git reset）。重置命令的一个用途就是修改引用（如 master）的游标。实际上重置时修改的是 HEAD，但是因为 HEAD 指向了 refs/heads/master，所以是通过分支“游标”的改变来体现出重置的变化的，HEAD 本身一直指向的是 refs/heads/master，并没有改变。本章学习的检出命令（git checkout）则会修改 HEAD 本身的指向，并不会影响分支“游标”。

实践五：HEAD 的重置和检出
=========================

HEAD 可以理解为“头指针”，是当前工作区的“基础版本”，当执行提交时，HEAD 指向的提交将作为新提交的父提交。看看当前 HEAD 的指向。

:: 

  $ cat .git/HEAD 
  ref: refs/heads/master

可以看出 HEAD 指向了分支 master。此时执行 git branch 会看到当前处于 master 分支。

::

  $ git branch -v
  * master 4902dc3 does master follow this new commit?
  
现在使用提交ID作为参数执行 git checkout 检出命令，看看会怎样。

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

出现了大段的输出！翻译一下，Git 肯定又是在提醒我们了。

::

  $ git checkout 4902dc3
  注意: 正检出 '4902dc3^'.

  您现在处于 '分离头指针' 状态。您可以检查、测试和提交，而不影响任何分支。
  通过执行另外的一个 checkout 检出指令丢弃在此状态下的修改和提交。

  如果想保留在此状态下的修改和提交，使用 -b 参数调用 checkout 检出指令以
  创建新的跟踪分支。如：

    git checkout -b new_branch_name

  头指针现在指向 e695606... 提交说明为： which version checked in?

什么叫做“分离头指针”状态？查看一下此时 HEAD 的内容就明白了。

::

  $ cat .git/HEAD 
  e695606fc5e31b2ff9038a48a3d363f4c21a3d86

查看最新提交的 reflog 也可以看到当针对提交执行 git checkout 命令时，HEAD 头指针被更改了：由指向 master 分支变成了指向一个提交ID。

::

  $ git reflog -1
  e695606 HEAD@{0}: checkout: moving from master to 4902dc3^

注意上面的 reflog 是 HEAD 头指针的变迁记录，而非 master 分支。

查看一下 HEAD 和 master 对应的提交ID，会发现现在它们指向的不一样。

::

  $ git rev-parse HEAD master
  e695606fc5e31b2ff9038a48a3d363f4c21a3d86
  4902dc375672fbf52a226e0354100b75d4fe31e3

前一个是 HEAD 头指针的指向，后一个是 master 分支的指向。而且还可以看到执行 git checkout 命令并不像 git reset 命令，不会改变分支引用的指向。

现在版本库的 HEAD 是基于 e695606 提交的。再做一次提交，HEAD 会如何变化呢？

* 先做一次提交：添加一个新文件 `detached-commit.txt` ，添加到暂存区中。

  ::

    $ touch detached-commit.txt
    $ git add detached-commit.txt

* 看一下状态，会发现其中有：“当前不处于任何分支”的字样，显然这是因为 HEAD 处于“分离头指针”模式。

  ::

    $ git status
    # Not currently on any branch.
    # Changes to be committed:
    #   (use "git reset HEAD <file>..." to unstage)
    #
    #       new file:   detached-commit.txt
    #

* 执行提交。在提交输出中也会出现 "detached HEAD" 的字样。

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


记下新的提交ID（acc2f69），然后以 master 分支名作为参数执行 git checkout 切换到分支上。

* 切换到 master 分支。没有之前大段的文字警告。

  ::

    $ git checkout master
    Previous HEAD position was acc2f69... commit in detached HEAD mode.
    Switched to branch 'master'

* 因为 HEAD 头指针重新指向了分支，而不是处于“断头模式”（分离头指针模式）。

  ::

    $ cat .git/HEAD 
    ref: refs/heads/master

* 切换之后，之前本地建立的新文件 `detached-commit.txt` 不见了。

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

刚才的提交在版本库的对象库中还存在么？

::

  $ git show acc2f69
  commit acc2f69cf6f0ae346732382c819080df75bb2191
  Author: Jiang Xin <jiangxin@ossxp.com>
  Date:   Sun Dec 5 15:43:24 2010 +0800

      commit in detached HEAD mode.

  diff --git a/detached-commit.txt b/detached-commit.txt
  new file mode 100644
  index 0000000..e69de29

可以看出这个提交现在版本库中，但是由于这个提交没有被任何分支跟踪到，因此并不能保证这个提交会永久存在。实际上当 reflog 中含有该提交的日志过期后，这个提交随时都会从版本库中彻底清除。

如果这个位于“分离头指针”模式下进行的测试提交（acc2f69）在 master 分支中也需要，那么怎么办呢？如果使用上一章介绍的 git reset 命令，的确可以将 master 分支指向刚才的试验提交（acc2f69），但是如果那样就会丢掉提交 4902dc3，这是因为在“分离头指针”模式下的提交是基于 4902dc3^（4902dc3父提交）进行的。使用合并操作就可以实现两者的兼顾：将提交（acc2f69）合并到 master 分支中来。

* 确认当前处于 master 分支。

  ::

    $ git branch -v
    * master 4902dc3 does master follow this new commit?

* 执行合并操作，将 acc2f69 提交合并到当前分支。

  ::

    $ git merge acc2f69
    Merge made by recursive.
     0 files changed, 0 insertions(+), 0 deletions(-)
     create mode 100644 detached-commit.txt

* 工作区中多了一个 `detached-commit.txt` 文件。

  ::

    $ ls 
    detached-commit.txt  new-commit.txt  welcome.txt

* 查看日志，会看到不一样的分支图。即在 e695606 提交开始出现了开发分支，而分支在最新的 2b31c19 提交发生了合并。

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

深入了解 git checkout 命令
===========================

检出命令（git checkout）是 Git 最常用的命令之一，同样也很危险，因为这条命令会重写工作区。

::

  用法一： git checkout [-q] [<commit>] [--] <paths>...
  用法二： git checkout [<branch>]
  用法三： git checkout [-m] [[-b|--orphan] <new_branch>] [<start_point>]


上面列出的第一种用法和第二种用法的区别在于，第一种用法在命令中包含路径 `<paths>` 。为了避免路径和引用（或者提交ID）同名而冲突，可以在 `<paths>` 前用两个连续的短线（减号）作为分隔。

第一种用法的 <commit> 是可选项，如果省略则相当于从暂存区（index）进行检出。这和上一章的重置命令大不相同：重置的缺省值是 HEAD，而检出的缺省值是暂存区。因此重置一般用于重置暂存区（除非使用 --hard 参数，否则不重置工作区），而检出命令主要是覆盖工作区（如果 <commit> 不省略，也会替换暂存区中相应的文件）。

第一种用法不会改变 HEAD 头指针，主要是用于指定版本的文件覆盖工作区中对应的文件。如果省略 <commit> ，会拿暂存区的文件覆盖工作区的文件，否则用指定提交中的文件覆盖暂存区和工作区中对应的文件。

第二种用法会改变 HEAD 头指针。之所以后面的参数写作 <branch>，是因为只有 HEAD 切换到一个分支才可以对提交进行跟踪，否则会进入“分离头指针”的状态，提交不能被引用关联到而可能会丢失。所以用法二最主要的作用就是切换到分支。如果省略 <branch> 则相当于对工作区进行状态检查。

第三种用法主要是创建和切换到新的分支（<new_branch>），新的分支从 <start_point> 指定的提交开始创建。新分支和我们熟悉的 master 分支没有什么实质的不同，都是在 `refs/heads` 命名空间下的引用。我们会在后面的章节对分支做具体的介绍。

下面的版本库模型图描述了 git checkout 实际完成的操作。

  .. figure:: images/gitbook/git-checkout.png
     :scale: 80

下面通过一些示例，具体的看一下检出命令的不同用法。

* 命令: git checkout

  汇总显示工作区、暂存区与 HEAD 的差异。

* 命令: git checkout HEAD

  同上。

* 命令: git checkout -- filename

  用暂存区中 `filename` 文件来覆盖工作区中的 `filename` 文件。相当于取消自上次执行 "git add filename" 以来（如果执行过）本地的修改。

  这个命令很危险，因为对于本地的修改会悄无声息的覆盖，毫不留情。

* 命令: git checkout .

  注意: git checkout 命令后的参数为一个点（"."）。这条命令最危险！会取消所有本地的修改（相对于暂存区）。相当于将暂存区的所有文件直接覆盖本地文件，不给用户任何确认的机会！

* 命令: git checkout master

  检出 master 分支。
