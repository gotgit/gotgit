恢复进度
*********

在之前“Git暂存区”一章的结尾，曾经以终结者（The Terminator）的口吻说：\
“我会再回来”，会继续对暂存区的探索。经过了前面三章对Git对象、重置命令、\
检出命令的探索，现在已经拥有了足够多的武器，是时候“回归”了。

本章“回归”之后，再看Git状态输出中关于\ :command:`git reset`\ 或者\
:command:`git checkout`\ 的指示，有了前面几章的基础已经会觉得很亲切和易如\
反掌了。本章还会重点介绍“回归”使用的\ :command:`git stash`\ 命令。

继续暂存区未完成的实践
==============================

经过了前面的实践，现在DEMO版本库应该处于master分支上，看看是不是这样。

::

  $ cd /path/to/my/workspace/demo
  $ git status -sb       # Git 1.7.2 及以上版本才支持 -b 参数哦
  ## master
  $ git log --graph --pretty=oneline --stat
  *   2b31c199d5b81099d2ecd91619027ab63e8974ef Merge commit 'acc2f69'
  |\  
  | * acc2f69cf6f0ae346732382c819080df75bb2191 commit in detached HEAD mode.
  | |  0 files changed, 0 insertions(+), 0 deletions(-)
  * | 4902dc375672fbf52a226e0354100b75d4fe31e3 does master follow this new commit?
  |/  
  |    0 files changed, 0 insertions(+), 0 deletions(-)
  * e695606fc5e31b2ff9038a48a3d363f4c21a3d86 which version checked in?
  |  welcome.txt |    1 +
  |  1 files changed, 1 insertions(+), 0 deletions(-)
  * a0c641e92b10d8bcca1ed1bf84ca80340fdefee6 who does commit?
  * 9e8a761ff9dd343a1380032884f488a2422c495a initialized.
     welcome.txt |    1 +
     1 files changed, 1 insertions(+), 0 deletions(-)

还记得在之前“Git暂存区”一章的结尾，是如何保存进度的么？翻回去看一下，用\
的是\ :command:`git stash`\ 命令。这个命令用于保存当前进度，也是恢复进度\
要用的命令。

查看保存的进度用命令\ :command:`git stash list`\ 。

::

  $ git stash list
  stash@{0}: WIP on master: e695606 which version checked in?

现在就来恢复进度。使用\ :command:`git stash pop`\ 从最近保存的进度进行恢复。

::

  $ git stash pop
  # On branch master
  # Changes to be committed:
  #   (use "git reset HEAD <file>..." to unstage)
  #
  #       new file:   a/b/c/hello.txt
  #
  # Changes not staged for commit:
  #   (use "git add <file>..." to update what will be committed)
  #   (use "git checkout -- <file>..." to discard changes in working directory)
  #
  #       modified:   welcome.txt
  #
  Dropped refs/stash@{0} (c1bd56e2565abd64a0d63450fe42aba23b673cf3)

先不要管\ :command:`git stash pop`\ 命令的输出，后面会专题介绍\
:command:`git stash`\ 命令。通过查看工作区的状态，可以发现进度已经找回了\
（状态和进度保存前稍有不同）。

::

  $ git status
  # On branch master
  # Changes to be committed:
  #   (use "git reset HEAD <file>..." to unstage)
  #
  #       new file:   a/b/c/hello.txt
  #
  # Changes not staged for commit:
  #   (use "git add <file>..." to update what will be committed)
  #   (use "git checkout -- <file>..." to discard changes in working directory)
  #
  #       modified:   welcome.txt
  #

此时再看Git状态输出，是否别有一番感觉呢？有了前面三章的基础，现在可以游\
刃有余的应对各种情况了。

* 以当前暂存区状态进行提交，即只提交\ :file:`a/b/c/hello.txt`\ ，不提交\
  :file:`welcome.txt`\ 。

  - 执行提交：

    ::

      $ git commit -m "add new file: a/b/c/hello.txt, but leave welcome.txt alone."
      [master 6610d05] add new file: a/b/c/hello.txt, but leave welcome.txt alone.
       1 files changed, 2 insertions(+), 0 deletions(-)
       create mode 100644 a/b/c/hello.txt

  - 查看提交后的状态：

    ::

      $ git status -s 
       M welcome.txt

* 反悔了，回到之前的状态。

  - 用重置命令放弃最新的提交：

    ::

      $ git reset --soft HEAD^

  - 查看最新的提交日志，可以看到前面的提交被抛弃了。

    ::

      $ git log -1 --pretty=oneline
      2b31c199d5b81099d2ecd91619027ab63e8974ef Merge commit 'acc2f69'

  - 工作区和暂存区的状态也都维持原来的状态。

    ::

      $ git status -s
      A  a/b/c/hello.txt
       M welcome.txt

* 想将\ :file:`welcome.txt`\ 提交。

  再简单不过了。

  ::

    $ git add welcome.txt
    $ git status -s
    A  a/b/c/hello.txt
    M  welcome.txt

* 想将\ :file:`a/b/c/hello.txt`\ 撤出暂存区。

  也是用重置命令。

  ::

    $ git reset HEAD a/b/c
    $ git status -s
    M  welcome.txt
    ?? a/

* 想将剩下的文件（\ :file:`welcome.txt`\ ）从暂存区撤出，就是说不想提交\
  任何东西了。

  还是使用重置命令，甚至可以不使用任何参数。

  ::

    $ git reset 
    Unstaged changes after reset:
    M       welcome.txt

* 想将本地工作区所有的修改清除。即清除\ :file:`welcome.txt`\ 的改动，\
  删除添加的目录\ :file:`a`\ 即下面的子目录和文件。

  - 清除\ :file:`welcome.txt`\ 的改动用检出命令。

    实际对于此例执行\ :command:`git checkout .`\ 也可以。

    ::

      $ git checkout -- welcome.txt

  - 工作区显示还有一个多余的目录\ :file:`a`\ 。

    ::

      $ git status
      # On branch master
      # Untracked files:
      #   (use "git add <file>..." to include in what will be committed)
      #
      #       a/

  - 删除本地多余的目录和文件，可以使用\ :command:`git clean`\ 命令。先来\
    测试运行以便看看哪些文件和目录会被删除，以免造成误删。

    ::

      $ git clean -nd
      Would remove a/

  - 真正开始强制删除多余的目录和文件。

    ::

      $ git clean -fd
      Removing a/

  - 整个世界清净了。

    ::

      $ git status -s

使用\ :command:`git stash`
=============================

命令\ :command:`git stash`\ 可以用于保存和恢复工作进度，掌握这个命令对于\
日常的工作会有很大的帮助。关于这个命令的最主要的用法实际上通过前面的演示\
已经了解了。

* 命令：\ :command:`git stash`

  保存当前工作进度。会分别对暂存区和工作区的状态进行保存。

* 命令：\ :command:`git stash list`

  显示进度列表。此命令显然暗示了\ :command:`git stash`\ 可以多次保存工作\
  进度，并且在恢复的时候进行选择。

* 命令：\ :command:`git stash pop [--index] [<stash>]`

  如果不使用任何参数，会恢复最新保存的工作进度，并将恢复的工作进度从存储\
  的工作进度列表中清除。

  如果提供\ ``<stash>``\ 参数（来自于\ :command:`git stash list`\ 显示的\
  列表），则从该\ ``<stash>``\ 中恢复。恢复完毕也将从进度列表中删除\
  ``<stash>``\ 。
  
  选项\ ``--index``\ 除了恢复工作区的文件外，还尝试恢复暂存区。这也就是\
  为什么在本章一开始恢复进度的时候显示的状态和保存进度前略有不同。

实际上还有几个用法也很有用。

* 命令：\ :command:`git stash [save [--patch] [-k|--[no-]keep-index] [-q|--quiet] [<message>]]`

  - 这条命令实际上是第一条\ :command:`git stash`\ 命令的完整版。即如果需\
    要在保存工作进度的时候使用指定的说明，必须使用如下格式：

    ::
      
      git stash save "message..."

  - 使用参数\ ``--patch``\ 会显示工作区和HEAD的差异，通过对差异文件的编\
    辑决定在进度中最终要保存的工作区的内容，通过编辑差异文件可以在进度中\
    排除无关内容。

  - 使用\ ``-k``\ 或者\ ``--keep-index``\ 参数，在保存进度后不会将暂存区\
    重置。缺省会将暂存区和工作区强制重置。

* 命令：\ :command:`git stash apply [--index] [<stash>]`

  除了不删除恢复的进度之外，其余和\ :command:`git stash pop`\ 命令一样。

* 命令：\ :command:`git stash drop [<stash>]`

  删除一个存储的进度。缺省删除最新的进度。

* 命令：\ :command:`git stash clear`

  删除所有存储的进度。

* 命令：\ :command:`git stash branch <branchname> <stash>`

  基于进度创建分支。对了，还没有讲到分支呢。;)
  
探秘\ :command:`git stash`
==============================

了解一下\ :command:`git stash`\ 的机理会有几个好处：当保存了多个进度的时\
候知道从哪个进度恢复；综合运用前面介绍的Git知识点；了解Git的源码，Git将\
不再神秘。

在执行\ :command:`git stash`\ 命令时，Git实际调用了一个脚本文件实现相关\
的功能，这个脚本的文件名就是\ :file:`git-stash`\ 。看看\
:file:`git-stash`\ 安装在哪里了。

::

  $ git --exec-path
  /usr/lib/git-core

如果检查一下这个目录，会震惊的。

::

  $ ls /usr/lib/git-core/
  git                    git-help                 git-reflog
  git-add                git-http-backend         git-relink
  git-add--interactive   git-http-fetch           git-remote
  git-am                 git-http-push            git-remote-ftp
  git-annotate           git-imap-send            git-remote-ftps
  git-apply              git-index-pack           git-remote-http
  ..................
  ... 省略40余行 ...
  ..................

实际上在1.5.4之前的版本，Git会安装这些一百多个以\ :command:`git-<cmd>`\
格式命名的程序到可执行路径中。这样做的唯一好处就是不用借助任何扩展机制就\
可以实现命令行补齐：即键入\ ``git-``\ 后，连续两次键入\ ``<Tab>``\ 键，\
就可以把这一百多个命令显示出来。这种方式随着Git子命令的增加越来越显得\
混乱，因此在1.5.4版本开始，不再提供\ :command:`git-<cmd>`\ 格式的命令，\
而是用唯一的\ :command:`git`\ 命令。而之前的名为\ :command:`git-<cmd>`\
的子命令则保存在非可执行目录下，由Git负责加载。

在后面的章节中偶尔会看到形如\ :command:`git-<cmd>`\ 字样的名称，以及同时\
存在的\ :command:`git <cmd>`\ 命令。可以这样理解：\ :command:`git-<cmd>`\
作为软件本身的名称，而其命令行为\ :command:`git <cmd>`\ 。

最早很多Git命令都是用Shell或者Perl脚本语言开发的，在Git的发展中一些对运\
行效率要求高的命令用C语言改写。而\ :file:`git-stash`\ （至少在Git 1.7.3.2版本）\
还是使用Shell脚本开发的，研究它会比研究用C写的命令要简单的多。

::

  $ file /usr/lib/git-core/git-stash 
  /usr/lib/git-core/git-stash: POSIX shell script text executable

解析\ :file:`git-stash`\ 脚本会比较枯燥，还是通过运行一些示例更好一些。

当前的进度保存列表是空的。

::

  $ git stash list

下面在工作区中做一些改动。

::

  $ echo Bye-Bye. >> welcome.txt
  $ echo hello. > hack-1.txt
  $ git add hack-1.txt
  $ git status -s
  A  hack-1.txt
   M welcome.txt

可见暂存区中已经添加了新增的\ :file:`hack-1.txt`\，修改过的\
:file:`welcome.txt`\ 并未添加到暂存区。执行\ :command:`git stash`\
保存一下工作进度。

::

  $ git stash save "hack-1: hacked welcome.txt, newfile hack-1.txt"
  Saved working directory and index state On master: hack-1: hacked welcome.txt, newfile hack-1.txt
  HEAD is now at 2b31c19 Merge commit 'acc2f69'

再来看工作区恢复了修改前的原貌（实际上用了 git reset --hard HEAD 命令），\
文件\ :file:`welcome.txt`\ 的修改不见了，文件\ :file:`hack-1.txt`\ 整个\
都不见了。

::

  $ git status -s
  $ ls
  detached-commit.txt  new-commit.txt  welcome.txt

再做一个修改，并尝试保存进度。

::

  $ echo fix. > hack-2.txt
  $ git stash
  No local changes to save

进度保存失败！可见本地没有被版本控制系统跟踪的文件并不能保存进度。因此\
本地新文件需要执行添加再执行\ :command:`git stash`\ 命令。

::

  $ git add hack-2.txt
  $ git stash
  Saved working directory and index state WIP on master: 2b31c19 Merge commit 'acc2f69'
  HEAD is now at 2b31c19 Merge commit 'acc2f69'

不用看就知道工作区再次恢复原状。如果这时执行\ :command:`git stash list`\
会看到有两次进度保存。

::

  $ git stash list
  stash@{0}: WIP on master: 2b31c19 Merge commit 'acc2f69'
  stash@{1}: On master: hack-1: hacked welcome.txt, newfile hack-1.txt

从上面的输出可以得出两个结论：

* 在用\ :command:`git stash`\ 命令保存进度时，提供说明更容易找到对应的\
  进度文件。
* 每个进度的标识都是\ ``stash@{<n>}``\ 格式，像极了前面介绍的reflog的\
  格式。

实际上，\ :command:`git stash`\ 的就是用到了前面介绍的引用和引用变更日志\
（reflog）来实现的。

::

  $ ls -l .git/refs/stash .git/logs/refs/stash 
  -rw-r--r-- 1 jiangxin jiangxin 364 Dec  6 16:11 .git/logs/refs/stash
  -rw-r--r-- 1 jiangxin jiangxin  41 Dec  6 16:11 .git/refs/stash

那么在“Git重置”一章中学习的reflog可以派上用场了。

::

  $ git reflog show refs/stash
  e5c0cdc refs/stash@{0}: WIP on master: 2b31c19 Merge commit 'acc2f69'
  6cec9db refs/stash@{1}: On master: hack-1: hacked welcome.txt, newfile hack-1.txt

对照\ :command:`git reflog`\ 的结果和前面\ :command:`git stash list`\
的结果，可以肯定用\ :command:`git stash`\ 保存进度，实际上会将进度保存在\
引用\ ``refs/stash``\ 所指向的提交中。多次的进度保存，实际上相当于引用\
``refs/stash``\ 一次又一次的变化，而\ ``refs/stash``\ 引用的变化由reflog\
（即\ :command:`.git/logs/refs/stash`\ ）所记录下来。这个实现是多么的简\
单而巧妙啊。

新的一个疑问又出现了，如何在引用\ ``refs/stash``\ 中同时保存暂存区的进度\
和工作区中的进度呢？查看一下引用\ ``refs/stash``\ 的提交历史能够看出端倪。

::

  $ git log --graph --pretty=raw  refs/stash -2
  *   commit e5c0cdc2dedc3e50e6b72a683d928e19a1d9de48
  |\  tree 780c22449b7ff67e2820e09a6332c360ddc80578
  | | parent 2b31c199d5b81099d2ecd91619027ab63e8974ef
  | | parent c5edbdcc90addb06577ff60f644acd1542369194
  | | author Jiang Xin <jiangxin@ossxp.com> 1291623066 +0800
  | | committer Jiang Xin <jiangxin@ossxp.com> 1291623066 +0800
  | | 
  | |     WIP on master: 2b31c19 Merge commit 'acc2f69'
  | |   
  | * commit c5edbdcc90addb06577ff60f644acd1542369194
  |/  tree 780c22449b7ff67e2820e09a6332c360ddc80578
  |   parent 2b31c199d5b81099d2ecd91619027ab63e8974ef
  |   author Jiang Xin <jiangxin@ossxp.com> 1291623066 +0800
  |   committer Jiang Xin <jiangxin@ossxp.com> 1291623066 +0800
  |   
  |       index on master: 2b31c19 Merge commit 'acc2f69'

可以看到在提交关系图可以看到进度保存的最新提交是一个合并提交。最新的提交\
说明中有\ ``WIP``\ 字样（是Work In Progess的简称），说明代表了工作区进度\
。而最新提交的第二个父提交（上图中显示为第二个提交）有\
``index on master``\ 字样，说明这个提交代表着暂存区的进度。

但是上图中的两个提交都指向了同一个树——tree \``780c224``\...，这是因为最\
后一次做进度保存时工作区相对暂存区没有改变，这让关于工作区和暂存区在引用\
\ ``refs/stash``\ 中的存储变得有些扑朔迷离。别忘了第一次进度保存工作区、\
暂存区和版本库都是不同的，可以用于验证关于\ ``refs/stash``\ 实现机制的判断。

第一次进度保存可以用reflog中的语法，即用\ ``refs/stash@{1}``\ 来访问，\
也可以用简称\ ``stash@{1}``\ 。下面就用第一次的进度保存来研究一下。

::

  $ git log --graph --pretty=raw  stash@{1} -3
  *   commit 6cec9db44af38d01abe7b5025a5190c56fd0cf49
  |\  tree 7250f186c6aa3e2d1456d7fa915e529601f21d71
  | | parent 2b31c199d5b81099d2ecd91619027ab63e8974ef
  | | parent 4560d76c19112868a6a5692bf9379de09c0452b7
  | | author Jiang Xin <jiangxin@ossxp.com> 1291622767 +0800
  | | committer Jiang Xin <jiangxin@ossxp.com> 1291622767 +0800
  | | 
  | |     On master: hack-1: hacked welcome.txt, newfile hack-1.txt
  | |   
  | * commit 4560d76c19112868a6a5692bf9379de09c0452b7
  |/  tree 5d4dd328187e119448c9171f99cf2e507e91a6c6
  |   parent 2b31c199d5b81099d2ecd91619027ab63e8974ef
  |   author Jiang Xin <jiangxin@ossxp.com> 1291622767 +0800
  |   committer Jiang Xin <jiangxin@ossxp.com> 1291622767 +0800
  |   
  |       index on master: 2b31c19 Merge commit 'acc2f69'
  |    
  *   commit 2b31c199d5b81099d2ecd91619027ab63e8974ef
  |\  tree ab676f92936000457b01507e04f4058e855d4df0
  | | parent 4902dc375672fbf52a226e0354100b75d4fe31e3
  | | parent acc2f69cf6f0ae346732382c819080df75bb2191
  | | author Jiang Xin <jiangxin@ossxp.com> 1291535485 +0800
  | | committer Jiang Xin <jiangxin@ossxp.com> 1291535485 +0800
  | | 
  | |     Merge commit 'acc2f69'

果然上面显示的三个提交对应的三棵树各不相同。查看一下差异。用“原基线”代表\
进度保存时版本库的状态，即提交\ ``2b31c199``\ ；用“原暂存区”代表进度保存\
时暂存区的状态，即提交\ ``4560d76``\ ；用“原工作区”代表进度保存时工作区\
的状态，即提交\ ``6cec9db``\ 。

* 原基线和原暂存区的差异比较。

  ::

    $ git diff stash@{1}^2^ stash@{1}^2
    diff --git a/hack-1.txt b/hack-1.txt
    new file mode 100644
    index 0000000..25735f5
    --- /dev/null
    +++ b/hack-1.txt
    @@ -0,0 +1 @@
    +hello.
 
* 原暂存区和原工作区的差异比较。

  ::

    $ git diff stash@{1}^2 stash@{1}
    diff --git a/welcome.txt b/welcome.txt
    index fd3c069..51dbfd2 100644
    --- a/welcome.txt
    +++ b/welcome.txt
    @@ -1,2 +1,3 @@
     Hello.
     Nice to meet you.
    +Bye-Bye.

* 原基线和原工作区的差异比较。

  ::

    $ git diff stash@{1}^1 stash@{1}
    diff --git a/hack-1.txt b/hack-1.txt
    new file mode 100644
    index 0000000..25735f5
    --- /dev/null
    +++ b/hack-1.txt
    @@ -0,0 +1 @@
    +hello.
    diff --git a/welcome.txt b/welcome.txt
    index fd3c069..51dbfd2 100644
    --- a/welcome.txt
    +++ b/welcome.txt
    @@ -1,2 +1,3 @@
     Hello.
     Nice to meet you.
    +Bye-Bye.

从\ ``stash@{1}``\ 来恢复进度。

::

  $ git stash apply stash@{1}
  # On branch master
  # Changes to be committed:
  #   (use "git reset HEAD <file>..." to unstage)
  #
  #       new file:   hack-1.txt
  #
  # Changes not staged for commit:
  #   (use "git add <file>..." to update what will be committed)
  #   (use "git checkout -- <file>..." to discard changes in working directory)
  #
  #       modified:   welcome.txt
  #

显示进度列表，然后删除进度列表。

::

  $ git stash list
  stash@{0}: WIP on master: 2b31c19 Merge commit 'acc2f69'
  stash@{1}: On master: hack-1: hacked welcome.txt, newfile hack-1.txt
  $ git stash clear

删除进度列表之后，会发现stash相关的引用和reflog也都不见了。

::

  $ ls -l .git/refs/stash .git/logs/refs/stash 
  ls: cannot access .git/refs/stash: No such file or directory
  ls: cannot access .git/logs/refs/stash: No such file or directory

通过上面的这些分析，有一定Shell编程基础的读者就可以尝试研究\
``git-stash``\ 的代码了，可能会有新的发现。
