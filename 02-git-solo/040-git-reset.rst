Git重置
********

在上一章了解了版本库中对象的存储方式以及分支master的实现。即master分支在\
版本库的引用目录（.git/refs）中体现为一个引用文件\
:file:`.git/refs/heads/master`\ ，其内容就是分支中最新提交的提交ID。

::

  $ cat .git/refs/heads/master
  e695606fc5e31b2ff9038a48a3d363f4c21a3d86

上一章还通过对提交本身数据结构的分析，看到提交可以通过到父提交的关联实现\
对提交历史的追溯。注意：下面的\ :command:`git log`\ 命令中使用了\
``--oneline``\ 参数，类似于\ ``--pretty=oneline``\ ，但是可以显示更短小的\
提交ID。参数\ ``--oneline``\ 在Git 1.6.3 及以后版本提供，老版本的Git可以\
使用参数\ ``--pretty=oneline --abbrev-commit``\ 替代。

::

  $ git log --graph --oneline
  * e695606 which version checked in?
  * a0c641e who does commit?
  * 9e8a761 initialized.

那么是不是有新的提交发生的时候，代表master分支的引用文件的内容会改变呢？\
代表master分支的引用文件的内容可以人为的改变么？本章就来探讨用\
:command:`git reset`\ 命令改变分支引用文件内容，即实现分支的重置。

分支游标master的探秘
=============================

先来看看当有新的提交发生的时候，文件\ :file:`.git/refs/heads/master`\
的内容如何改变。首先在工作区创建一个新文件，姑且叫做\
:file:`new-commit.txt`\，然后提交到版本库中。

::

  $ touch new-commit.txt
  $ git add new-commit.txt
  $ git commit -m "does master follow this new commit?"
  [master 4902dc3] does master follow this new commit?
   0 files changed, 0 insertions(+), 0 deletions(-)
   create mode 100644 new-commit.txt

此时工作目录下会有两个文件，其中文件\ :file:`new-commit.txt`\ 是新增的。

::

  $ ls
  new-commit.txt  welcome.txt

来看看master分支指向的提交ID是否改变了。

* 先看看在版本库引用空间（.git/refs/目录）下的\ ``master``\ 文件内容的确\
  更改了，指向了新的提交。

  ::

    $ cat .git/refs/heads/master 
    4902dc375672fbf52a226e0354100b75d4fe31e3

* 再用\ :command:`git log`\ 查看一下提交日志，可以看到刚刚完成的提交。

  ::

    $ git log --graph --oneline
    * 4902dc3 does master follow this new commit?
    * e695606 which version checked in?
    * a0c641e who does commit?
    * 9e8a761 initialized.

引用\ ``refs/heads/master``\ 就好像是一个游标，在有新的提交发生的时候指\
向了新的提交。可是如果只可上、不可下，就不能称为“游标”。Git提供了\
:command:`git reset`\ 命令，可以将“游标”指向任意一个存在的提交ID。下面的\
示例就尝试人为的更改游标。（注意下面的命令中使用了\ ``--hard``\ 参数，\
会破坏工作区未提交的改动，慎用。）

::

  $ git reset --hard HEAD^
  HEAD is now at e695606 which version checked in?

还记得上一章介绍的\ ``HEAD^``\ 代表了\ ``HEAD``\ 的父提交么？所以这条命令\
就相当于将master重置到上一个老的提交上。来看一下master文件的内容是否更改了。

::

  $ cat .git/refs/heads/master
  e695606fc5e31b2ff9038a48a3d363f4c21a3d86

果然master分支的引用文件的指向更改为前一次提交的ID了。而且通过下面的命令\
可以看出新添加的文件\ :file:`new-commit.txt`\ 也丢失了。

::

  $ ls
  welcome.txt

重置命令不仅仅可以重置到前一次提交，重置命令可以直接使用提交ID重置到任何\
一次提交。

* 通过\ :command:`git log`\ 查询到最早的提交ID。

::

  $ git log --graph --oneline
  * e695606 which version checked in?
  * a0c641e who does commit?
  * 9e8a761 initialized.

* 然后重置到最早的一次提交。

::

  $ git reset --hard 9e8a761
  HEAD is now at 9e8a761 initialized.

* 重置后会发现\ :file:`welcome.txt`\ 也回退到原始版本库，曾经的修改都丢失了。

::

  $ cat welcome.txt 
  Hello.

使用重置命令很危险，会彻底的丢弃历史。那么还能够通过浏览提交历史的办法找\
到丢弃的提交ID，再使用重置命令恢复历史么？不可能！因为重置让提交历史也改\
变了。

::

  $ git log
  commit 9e8a761ff9dd343a1380032884f488a2422c495a
  Author: Jiang Xin <jiangxin@ossxp.com>
  Date:   Sun Nov 28 12:48:26 2010 +0800

      initialized.

用reflog挽救错误的重置
=========================

如果没有记下重置前master分支指向的提交ID，想要重置回原来的提交真的是一件\
麻烦的事情（去对象库中一个一个地找）。幸好Git提供了一个挽救机制，通过\
:file:`.git/logs`\ 目录下日志文件记录了分支的变更。默认非裸版本库（带有\
工作区）都提供分支日志功能，这是因为带有工作区的版本库都有如下设置：

::

  $ git config core.logallrefupdates
  true

查看一下master分支的日志文件\ :file:`.git/logs/refs/heads/master`\ 中的\
内容。下面命令显示了该文件的最后几行。为了排版的需要，还将输出中的40位的\
SHA1提交ID缩短。

::

  $ tail -5 .git/logs/refs/heads/master 
  dca47ab a0c641e Jiang Xin <jiangxin@ossxp.com> 1290999606 +0800    commit (amend): who does commit?
  a0c641e e695606 Jiang Xin <jiangxin@ossxp.com> 1291022581 +0800    commit: which version checked in?
  e695606 4902dc3 Jiang Xin <jiangxin@ossxp.com> 1291435985 +0800    commit: does master follow this new commit?
  4902dc3 e695606 Jiang Xin <jiangxin@ossxp.com> 1291436302 +0800    HEAD^: updating HEAD
  e695606 9e8a761 Jiang Xin <jiangxin@ossxp.com> 1291436382 +0800    9e8a761: updating HEAD

可以看出这个文件记录了master分支指向的变迁，最新的改变追加到文件的末尾\
因此最后出现。最后一行可以看出因为执行了\ :command:`git reset --hard`\
命令，指向的提交ID由\ ``e695606``\ 改变为\ ``9e8a761``\ 。

Git提供了一个\ :command:`git reflog`\ 命令，对这个文件进行操作。使用\
``show``\ 子命令可以显示此文件的内容。

::

  $ git reflog show master | head -5
  9e8a761 master@{0}: 9e8a761: updating HEAD
  e695606 master@{1}: HEAD^: updating HEAD
  4902dc3 master@{2}: commit: does master follow this new commit?
  e695606 master@{3}: commit: which version checked in?
  a0c641e master@{4}: commit (amend): who does commit?

使用\ :command:`git reflog`\ 的输出和直接查看日志文件最大的不同在于显示\
顺序的不同，即最新改变放在了最前面显示，而且只显示每次改变的最终的SHA1\
哈希值。还有个重要的区别在于使用\ :command:`git reflog`\ 的输出中还提供\
一个方便易记的表达式：\ ``<refname>@{<n>}``\ 。这个表达式的含义是引用\
``<refname>``\ 之前第<n>次改变时的SHA1哈希值。

那么将引用master切换到两次变更之前的值，可以使用下面的命令。

* 重置master为两次改变之前的值。

  ::

    $ git reset --hard master@{2}
    HEAD is now at 4902dc3 does master follow this new commit?

* 重置后工作区中文件\ :file:`new-commit.txt`\ 又回来了。

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

此时如果再用\ :command:`git reflog`\ 查看，会看到恢复master的操作也记录\
在日志中了。

::
 
  $ git reflog show master | head -5
  4902dc3 master@{0}: master@{2}: updating HEAD
  9e8a761 master@{1}: 9e8a761: updating HEAD
  e695606 master@{2}: HEAD^: updating HEAD
  4902dc3 master@{3}: commit: does master follow this new commit?
  e695606 master@{4}: commit: which version checked in?

深入了解\ :command:`git reset`\ 命令
=====================================

重置命令（\ :command:`git reset`\ ）是Git最常用的命令之一，也是最危险，\
最容易误用的命令。来看看\ :command:`git reset`\ 命令的用法。

::

  用法一： git reset [-q] [<commit>] [--] <paths>...
  用法二： git reset [--soft | --mixed | --hard | --merge | --keep] [-q] [<commit>]

上面列出了两个用法，其中 <commit> 都是可选项，可以使用引用或者提交ID，\
如果省略 <commit> 则相当于使用了HEAD的指向作为提交ID。

上面列出的两种用法的区别在于，第一种用法在命令中包含路径\
:file:`<paths>`\ 。为了避免路径和引用（或者提交ID）同名而冲突，可以在\
:file:`<paths>`\ 前用两个连续的短线（减号）作为分隔。

第一种用法（包含了路径\ :file:`<paths>`\ 的用法）\ **不会**\ 重置引用，\
更不会改变工作区，而是用指定提交状态（<commit>）下的文件（<paths>）替换\
掉暂存区中的文件。例如命令\ :command:`git reset HEAD <paths>`\ 相当于取\
消之前执行的\ :command:`git add <paths>`\ 命令时改变的暂存区。

第二种用法（不使用路径\ :file:`<paths>`\ 的用法）则会\ **重置引用**\ 。\
根据不同的选项，可以对暂存区或者工作区进行重置。参照下面的版本库模型图，\
来看一看不同的参数对第二种重置语法的影响。

  .. figure:: /images/git-solo/git-reset.png
     :scale: 80

命令格式: git reset [--soft | --mixed | --hard ] [<commit>]

* 使用参数\ ``--hard``\ ，如：\ :command:`git reset --hard <commit>`\ 。

  会执行上图中的1、2、3全部的三个动作。即：

  1. 替换引用的指向。引用指向新的提交ID。
  2. 替换暂存区。替换后，暂存区的内容和引用指向的目录树一致。
  3. 替换工作区。替换后，工作区的内容变得和暂存区一致，也和HEAD所指向的\
     目录树内容相同。

* 使用参数\ ``--soft``\ ，如:\ :command:`git reset --soft <commit>`\ 。

  会执行上图中的操作1。即只更改引用的指向，不改变暂存区和工作区。

* 使用参数\ ``--mixed``\ 或者不使用参数（缺省即为\ ``--mixed``\ ），如:\
  :command:`git reset <commit>`\ 。

  会执行上图中的操作1和操作2。即更改引用的指向以及重置暂存区，但是不改变\
  工作区。

下面通过一些示例，看一下重置命令的不同用法。

* 命令：\ :command:`git reset`

  仅用HEAD指向的目录树重置暂存区，工作区不会受到影响，相当于将之前用\
  :command:`git add`\ 命令更新到暂存区的内容撤出暂存区。引用也未改变，\
  因为引用重置到HEAD相当于没有重置。

* 命令：\ :command:`git reset HEAD`

  同上。

* 命令：\ :command:`git reset -- filename`

  仅将文件\ :file:`filename`\ 撤出暂存区，暂存区中其他文件不改变。相当于\
  对命令\ :command:`git add filename`\ 的反向操作。

* 命令：\ :command:`git reset HEAD filename`

  同上。

* 命令：\ :command:`git reset --soft HEAD^`

  工作区和暂存区不改变，但是引用向前回退一次。当对最新提交的提交说明或者\
  提交的更改不满意时，撤销最新的提交以便重新提交。

  在之前曾经介绍过一个修补提交命令\ :command:`git commit --amend`\ ，用\
  于对最新的提交进行重新提交以修补错误的提交说明或者错误的提交文件。修补\
  提交命令实际上相当于执行了下面两条命令。（注：文件\
  :file:`.git/COMMIT_EDITMSG`\ 保存了上次的提交日志）

  ::
  
    $ git reset --soft HEAD^
    $ git commit -e -F .git/COMMIT_EDITMSG 

* 命令：\ :command:`git reset HEAD^`

  工作区不改变，但是暂存区会回退到上一次提交之前，引用也会回退一次。

* 命令：\ :command:`git reset --mixed HEAD^`

  同上。

* 命令：\ :command:`git reset --hard HEAD^`

  彻底撤销最近的提交。引用回退到前一次，而且工作区和暂存区都会回退到上一\
  次提交的状态。自上一次以来的提交全部丢失。
