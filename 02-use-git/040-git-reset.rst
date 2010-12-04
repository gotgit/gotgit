实践四：master 分支游标的探秘
*****************************

在“实践三”中，了解了版本库中对象的存储方式以及分支master的实现。即 master 分支在版本库中体现为一个文件 `.git/refs/heads/master` ，其内容就是分支中最新提交的提交 ID。

::

  $ cat .git/refs/heads/master 
  e695606fc5e31b2ff9038a48a3d363f4c21a3d86

上一章还通过对提交本身数据结构的分析，看到提交可以通过到父提交的关联实现对提交历史的追溯。

::

  $ git log --graph --oneline
  * e695606 which version checked in?
  * a0c641e who does commit?
  * 9e8a761 initialized.

那么是不是有新的提交发生的时候，master 的内容会改变呢？现在就来试验一下。

首先在工作区创建一个新文件，姑且叫做 `new-commit.txt` ，然后提交到版本库中。

::

  $ touch new-commit.txt
  $ git add new-commit.txt
  $ git commit -m "does master follow this new commit?"
  [master 4902dc3] does master follow this new commit?
   0 files changed, 0 insertions(+), 0 deletions(-)
   create mode 100644 new-commit.txt

此时工作目录下会有两个文件，其中文件 `new-commit.txt` 是新增的。

::

  $ ls
  new-commit.txt  welcome.txt

来看看 master 分支指向的提交ID是否改变了。

* 先看看在版本库引用空间（.git/refs/目录）下的 master 文件内容的确更改了，指向了新的提交。

  ::

    $ cat .git/refs/heads/master 
    4902dc375672fbf52a226e0354100b75d4fe31e3

* 再用 "git log" 查看一下提交日志，可以看到刚刚完成的提交。

  ::

    $ git log --graph --oneline
    * 4902dc3 does master follow this new commit?
    * e695606 which version checked in?
    * a0c641e who does commit?
    * 9e8a761 initialized.

引用 `refs/heads/master` 就好像是一个游标，在有新的提交发生的时候指向了新的提交。可是如果只可上、不可下，就不能称为“游标”。Git 提供了 "git reset" 命令，可以将“游标”指向任意一个存在的提交ID。下面的示例就尝试人为的更改游标。（注意下面的命令中使用了 "--hard" 参数，会破坏工作区未提交的改动，慎用。）

::

  $ git reset --hard HEAD^
  HEAD is now at e695606 which version checked in?

还记得上一章介绍的 HEAD^ 代表了 HEAD 的父提交么？所以这条命令就相当于将 master 重置到上一个老的提交上。来看一下 master 文件的内容是否更改了。

::

  $ cat .git/refs/heads/master 
  e695606fc5e31b2ff9038a48a3d363f4c21a3d86

果然 master 分支的引用文件的指向更改为前一次提交的ID了。而且通过下面的命令可以看出新添加的文件 `new-commit.txt` 也丢失了。

::

  $ ls
  welcome.txt

重置命令不仅仅可以重置到前一次提交，重置命令可以直接使用提交ID重置到任何一次提交。

* 通过 "git log" 查询到最早的提交ID。

::

  $ git log --graph --oneline
  * e695606 which version checked in?
  * a0c641e who does commit?
  * 9e8a761 initialized.

* 然后重置到最早的一次提交。

::

  $ git reset --hard 9e8a761
  HEAD is now at 9e8a761 initialized.

* 重置后会发现 welcome.txt 也回退到原始版本库，曾经的修改都丢失了。

::

  $ cat welcome.txt 
  Hello.

使用重置命令很危险，会彻底的丢弃历史。那么还能够通过浏览提交历史的办法找到丢弃的提交ID，再使用重置命令恢复历史么？不可能！因为重置让提交历史也改变了。

::

  $ git log
  commit 9e8a761ff9dd343a1380032884f488a2422c495a
  Author: Jiang Xin <jiangxin@ossxp.com>
  Date:   Sun Nov 28 12:48:26 2010 +0800

      initialized.

如果没有记下重置前 master 分支指向的提交ID，想要重置回原来的提交真的是一件麻烦的事情（去对象库中一个一个去找）。幸好 Git 在 ".git/logs" 目录下的文件中记录了分支的变更历史。

查看一下文件 `.git/logs/refs/heads/master` 文件最后的几行。（为了排版的需要，将40位的SHA1提交ID缩短。）

::

  $ tail -5 .git/logs/refs/heads/master 
  dca47ab a0c641e Jiang Xin <jiangxin@ossxp.com> 1290999606 +0800    commit (amend): who does commit?
  a0c641e e695606 Jiang Xin <jiangxin@ossxp.com> 1291022581 +0800    commit: which version checked in?
  e695606 4902dc3 Jiang Xin <jiangxin@ossxp.com> 1291435985 +0800    commit: does master follow this new commit?
  4902dc3 e695606 Jiang Xin <jiangxin@ossxp.com> 1291436302 +0800    HEAD^: updating HEAD
  e695606 9e8a761 Jiang Xin <jiangxin@ossxp.com> 1291436382 +0800    9e8a761: updating HEAD

可以看出这个文件记录了 master 分支的指向的变迁，最新的改变追加到文件的末尾因此最后出现。最后一行可以看出因为执行了 "git reset --hard" 命令，指向的提交ID由 e695606 改变为 9e8a761。

Git 提供了一个 "git reflog" 命令，对这个文件进行操作。使用 show 子命令可以显示此文件的内容。

::

  $ git reflog show master | head -5
  9e8a761 master@{0}: 9e8a761: updating HEAD
  e695606 master@{1}: HEAD^: updating HEAD
  4902dc3 master@{2}: commit: does master follow this new commit?
  e695606 master@{3}: commit: which version checked in?
  a0c641e master@{4}: commit (amend): who does commit?

使用 "git reflog" 的输出和直接查看日志文件最大的不同是最新的改变放在了最前面显示，而且只显示每次改变的最终的SHA1哈希值，还提供一个方便易记的表达式： `<refname>@{<n>}` 。这个表达式的含义是引用 `<refname>` 之前第 <n> 次改变时的SHA1哈希值。

那么将引用 master 切换到两次变更之前的值，可以使用下面的命令。

* 重置 master 为两次改变之前的值。

  ::

    $ git reset --hard master@{2}
    HEAD is now at 4902dc3 does master follow this new commit?

* 重置后工作区中文件 `new-commit.txt` 又回来了。

  ::

    $ ls
    new-commit.txt  welcome.txt

* 提交历史也回来了。

  ::

    $ git log --oneline
    4902dc3 does master follow this new commit?
    e695606 which version checked in?
    a0c641e who does commit?
    9e8a761 initialized.

此时如果再用 "git reflog" 查看，会看到恢复 master 的操作也记录在日志中了。

::
 
  $ git reflog show master | head -5
  4902dc3 master@{0}: master@{2}: updating HEAD
  9e8a761 master@{1}: 9e8a761: updating HEAD
  e695606 master@{2}: HEAD^: updating HEAD
  4902dc3 master@{3}: commit: does master follow this new commit?
  e695606 master@{4}: commit: which version checked in?

深入了解 git reset 命令
=======================

重置命令（git reset）是 Git 最常用的命令之一，也是最危险，最容易误用的命令。来看看 git reset 命令的用法。

::

  git reset [-q] [<commit>] [--] <paths>...
  git reset [--soft | --mixed | --hard | --merge | --keep] [-q] [<commit>]

上面列出了两个用法，其中 <commit> 都是可选项，可以使用引用或者提交ID，如果省略 <commit> 则相当于使用了 HEAD 的指向作为提交ID。

上面列出的两种用法的区别在于，第一种用法在命令中包含路径 <paths>，为了避免路径和引用（或者提交ID）同名而冲突，可以在 <paths> 前用两个连续的短线（减号）作为分隔。

第一种 git reset 用法不会重置引用，更不会改变工作区，而是将指定提交状态下的文件替换掉暂存区中的文件。例如命令 "git reset HEAD <paths>" 相当于取消之前执行的 "git add <paths>" 命令。

第二种 git reset 用法则会重置引用，根据选项的不同可能会对暂存区和工作区进行重置。参照下面的版本库模型图，介绍一下不同参数对第二种 git reset 用法的影响。

  .. figure:: images/gitbook/git-reset.png
     :scale: 80

* 使用参数 "--hard"，如: `git reset --hard <commit>` 。

  会执行上图中的 1, 2, 3 全部的三个动作。即：

  1. 更新引用的指向。指向新的 Commit ID。
  2. 更新暂存区。暂存区的内容和引用最新指向的目录树一致。
  3. 更新工作区。工作区和暂存区的内容都被引用最新指向的内容所替换。

* 使用参数 "--soft"，如: `git reset --soft <commit>` 。

  会执行上图中的操作1。即只更改引用的指向，不改变暂存区和工作区。

* 使用参数 "--mixed" 或者不使用参数（缺省即为 --mixed），如: `git reset <commit>` 。

  会执行上图中的操作1和操作2。即更改引用的指向以及重置暂存区，但是不改变工作区。




思考：重置命令除了 `--hard` 还有其他参数么？
=============================================


如果历史提交没有其他的分支引用或者用标签标记（分支和标签留在后面单独介绍），

7天。版本库没有整理。

历史提交看不到 id，也没有其他分支和标签标记。

reflog


