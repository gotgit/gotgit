Git 基本操作
************

之前的实践选取的示例都非常简单，基本上都是增加和修改文本文件，而现实情况要复杂的多，需要应对各种情况：文件删除，文件复制，文件移动，目录的组织，二进制文件，误删文件的恢复等等。本章会将工作区常用的操作一网打尽。

实践七：基本Git操作和文件忽略
==============================

本次实践要用一个更为真实的例子：用版本库来维护代码。首先会删除之前历次实践在版本库中留下的“垃圾”数据，然后再在其中创建一些真实的代码，并对其进行版本控制。

先来合个影
----------

马上就要和之前实践遗留的数据告别了，告别之前是不是要留个影呢？在 Git 里，“留影”用的命令叫做 `tag` ，更加专业的术语叫做“里程碑”（打tag，或打标签）。

::

  $ cd /my/workspace/demo
  $ git tag -m "Say bye-bye to all previous practice." practice-step-6

在本章还不打算详细介绍里程碑的奥秘，只要知道里程碑无非也是一个引用，通过记录提交ID（或者Tag对象）来为当前版本库状态进行“留影”。

::

  $ ls .git/refs/tags/practice-step-6
  .git/refs/tags/practice-step-6

  $ git rev-parse refs/tags/practice-step-6
  add85a442b531303629134de322e58c13ab1d288

留过影之后，可以执行 `git describe` 命令得到当前版本库的版本号。这个技术即将在示例代码中使用。

::

  $ git describe
  practice-step-6

删除文件
--------

看看版本库当前的状态，暂存区和工作区都包含修改。

::

  $ git status -s
  A  hack-1.txt
   M welcome.txt

在这个暂存区和工作区都包含文件修改的情况下，使用删除命令更具有挑战性。删除命令有多种使用方法，有的方法很巧妙，而有的方法需要更多的输入。为了分别介绍不同的删除方法，还要使用上一章介绍的进度保存（git-stash）命令。

::

  $ git stash
  Saved working directory and index state WIP on master: 2b31c19 Merge commit 'acc2f69'
  HEAD is now at 2b31c19 Merge commit 'acc2f69'
  $ git stash apply
  # On branch master
  # Changes to be committed:
  #   (use "git reset HEAD <file>..." to unstage)
  #
  #       new file:   hack-1.txt
  #
  # Changed but not updated:
  #   (use "git add <file>..." to update what will be committed)
  #   (use "git checkout -- <file>..." to discard changes in working directory)
  #
  #       modified:   welcome.txt
  #

本地删除不是真的删除
^^^^^^^^^^^^^^^^^^^^

当前工作区的文件有：

::

  $ git ls-files
  detached-commit.txt
  hack-1.txt
  new-commit.txt
  welcome.txt

直接在工作区删除这些文件，会如何呢？

::

  $ rm *.txt

通过下面的命令，可以看到在暂存区（版本库）中文件仍在，并未删除。

::

  $ git ls-files
  detached-commit.txt
  hack-1.txt
  new-commit.txt
  welcome.txt

通过文件的状态来看，文件只是在本地进行了删除，尚未加到暂存区（提交任务）中。也就是说： **直接在工作区删除，和在版本库中删除不是一个概念** 。

::

  $ git status
  # On branch master
  # Changes to be committed:
  #   (use "git reset HEAD <file>..." to unstage)
  #
  #       new file:   hack-1.txt
  #
  # Changed but not updated:
  #   (use "git add/rm <file>..." to update what will be committed)
  #   (use "git checkout -- <file>..." to discard changes in working directory)
  #
  #       deleted:    detached-commit.txt
  #       deleted:    hack-1.txt
  #       deleted:    new-commit.txt
  #       deleted:    welcome.txt
  #

从Git状态输出可以看出，本地删除如果要反映在暂存区中应该用 `git rm` 命令，对于不想删除的文件执行 `git checkout -- <file>` 可以让文件在工作区重现。

执行 git rm 命令删除文件
^^^^^^^^^^^^^^^^^^^^^^^^

好吧，按照上面状态输出的内容，将所有的文本文件删除。执行下面的命令。

::

  $ git rm detached-commit.txt hack-1.txt new-commit.txt welcome.txt
  rm 'detached-commit.txt'
  rm 'hack-1.txt'
  rm 'new-commit.txt'
  rm 'welcome.txt'

再看一看状态：

::

  $ git status
  # On branch master
  # Changes to be committed:
  #   (use "git reset HEAD <file>..." to unstage)
  #
  #       deleted:    detached-commit.txt
  #       deleted:    new-commit.txt
  #       deleted:    welcome.txt
  #

删除动作加入了暂存区。这时执行提交动作，就真正意义上执行了文件删除。

::

  $ git commit -m "delete trash files. (using: git rm)"
  [master 483493a] delete trash files. (using: git rm)
   1 files changed, 0 insertions(+), 2 deletions(-)
   delete mode 100644 detached-commit.txt
   delete mode 100644 new-commit.txt
   delete mode 100644 welcome.txt

不过不要担心，文件只是在版本库最新提交中删除了，在历史提交中尚在。可以通过下面命令查看文件列表。

::

  $ git ls-files --with-tree=HEAD^
  detached-commit.txt
  new-commit.txt
  welcome.txt

也可以查看删除文件的历史版本的内容。

::

  $ git cat-file -p HEAD^:welcome.txt
  Hello.
  Nice to meet you.

命令 git add -u 快速标记删除
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

在前面执行 `git rm` 命令时，一一写下了所有要删除的文件名，好长的命令啊！能不能简化些？实际上 `git add` 可以，即使用 "-u" 参数调用 "git add" 命令，含义是将本地有改动（包括添加和删除）的文件标记为删除。为了重现刚才的场景，先使用重置命令抛弃最新的提交，再使用进度恢复到之前的状态。

::

  $ git reset --hard HEAD^
  HEAD is now at 2b31c19 Merge commit 'acc2f69'
  $ git stash apply
  # On branch master
  # Changes to be committed:
  #   (use "git reset HEAD <file>..." to unstage)
  #
  #       new file:   hack-1.txt
  #
  # Changed but not updated:
  #   (use "git add <file>..." to update what will be committed)
  #   (use "git checkout -- <file>..." to discard changes in working directory)
  #
  #       modified:   welcome.txt
  #

然后删除本地文件，状态依然显示只在本地删除了文件，暂存区文件仍在。

::

  $ rm *.txt
  $ git status -s
   D detached-commit.txt
  AD hack-1.txt
   D new-commit.txt
   D welcome.txt

执行 `git add -u` 命令可以将（被版本库追踪的）本地文件的变更（修改、删除）全部记录到暂存区中。

::

  $ git add -u

查看状态，可以看到工作区删除的文件全部被标记为下次提交时删除。

::

  $ git status -s
  D  detached-commit.txt
  D  new-commit.txt
  D  welcome.txt

执行提交，在版本库最新的提交中删除文件。

::

  $ git commit -m "delete trash files. (using: git add -u)"
  [master 7161977] delete trash files. (using: git add -u)
   1 files changed, 0 insertions(+), 2 deletions(-)
   delete mode 100644 detached-commit.txt
   delete mode 100644 new-commit.txt
   delete mode 100644 welcome.txt

移动文件
--------

经过了上面的文件删除，工作区已经没有文件了。为了说明文件移动，现在恢复一个删除的文件。前面已经说过执行了文件删除并提交，只是在最新的提交中删除了文件，历史提交中文件仍然保留，可以从历史提交中提取文件。执行下面的命令可以从历史（前一次提交）中恢复 `welcome.txt` 文件。

::

  $ git cat-file -p HEAD~1:welcome.txt > welcome.txt

上面命令中出现的 `HEAD~1` 即相当于 `HEAD^` 都指的是 HEAD 的上一次提交。执行 "`git add -A`" 命令会对工作区中所有改动以及新增文件添加到暂存区，也是一个常用的技巧。执行下面的命令后，将恢复过来的 `welcome.txt` 文件添加回暂存区。

::

  $ git add -A
  $ git status -s
  A  welcome.txt

执行提交操作，文件 `welcome.txt` 又回来了。

::

  $ git commit -m "restore file: welcome.txt"
  [master 63992f0] restore file: welcome.txt
   1 files changed, 2 insertions(+), 0 deletions(-)
   create mode 100644 welcome.txt

现在需要将 `welcome.txt` 改名为 `README` 文件。Git 提供了 `git mv` 命令完成改名操作。

::

$ git mv welcome.txt README

可以从暂存区的状态中看到改名的操作。

::

  $ git status
  # On branch master
  # Changes to be committed:
  #   (use "git reset HEAD <file>..." to unstage)
  #
  #       renamed:    welcome.txt -> README
  #

提交改名操作，在提交输出可以看到改名前后文件变化的百分比。

::

  $ git commit -m "改名测试"
  [master 7aa5ac1] 改名测试
   1 files changed, 0 insertions(+), 0 deletions(-)
   rename welcome.txt => README (100%)

**可以不同 git mv 命令实现改名**

从提交日志中的文件相似度百分比可以看出 Git 的改名实际上源自于 Git 对文件追踪的强大支持（文件内容作为 blob 对象保存在对象库中）。改名操作实际上相当于对旧文件执行删除，对新文件执行添加，即完全可以不使用 `git mv` 操作，而是代之以 `git rm` 和一个 `git add` 操作。

重置上一次提交：

::

  $ git reset --hard HEAD^
  HEAD is now at 63992f0 restore file: welcome.txt
  $ git status -s
  $ git ls-files
  welcome.txt

本地移动文件，将 welcome.txt 移动到 README。

::

  $ mv welcome.txt README
  $ git status -s
   D welcome.txt
  ?? README

为了考验一下 Git 的内容追踪，再修改一下改名后的 README 文件，在文件末尾追加一行。

::

  $ echo "Bye-Bye." >> README 

可以使用前面介绍的 `git add -A` 相当于对修改文件执行 `git add` ，对删除文件执行 `git rm` ，而且对本地新增文件也执行 `git add` 。

::

  $ git add -A

查看状态，也可以看到文件重命名。

::

  $ git status
  # On branch master
  # Changes to be committed:
  #   (use "git reset HEAD <file>..." to unstage)
  #
  #       renamed:    welcome.txt -> README
  #

::

  $ git commit -m "README is from welcome.txt."
  [master c024f34] README is from welcome.txt.
   1 files changed, 1 insertions(+), 0 deletions(-)
   rename welcome.txt => README (73%)

这次提交中也看到了重命名操作，但是重命名相似度不是 100%，而是 73%。


