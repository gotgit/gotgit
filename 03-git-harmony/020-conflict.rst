冲突解决
********

上一章介绍了 Git 协议，并且使用本地协议来模拟一个远程的版本库，两个不同的用户检出该版本库，和该远程版本库进行交互，交换数据、协同工作。在上一章的协同中只遇到了一个小小的麻烦 —— 非快进式推送，可以通过先执行 PULL（拉回）操作，成功完成合并后再推送。

但是在真实的运行环境中，用户间协同并不总是会一帆风顺，只要有合并就可能会有冲突。本章就重点介绍冲突解决机制。

拉回操作中的合并
================

为了降低难度，上一章实践中用户 user1 执行 `git pull` 操作解决非快进式推送问题非常简单，就好像直接把共享式版本库中更新的提交直接拉回本地，然后就可以推送了，其它事情好像什么都没有发生一样。真的是这样么？

* 用户 user1 向共享版本库推送时，因为 user2 强制推送已经改变了共享版本库中的提交状态，导致 user1 推送失败。

  .. figure:: images/gitbook/git-merge-pull-1.png
     :scale: 100

* 用户 user1 执行 PULL 操作的第一阶段，将共享版本库 master 分支的最新提交拉回到本地，并更新本地版本库特定的引用中 `refs/remotes/origin/master` （简称为 `origin/master` ）。

  .. figure:: images/gitbook/git-merge-pull-2.png
     :scale: 100

* 用户 user1 执行 PULL 操作的第二阶段，将本地分支 master 和共享版本库本地关联分支 `origin/master` 进行合并操作。

  .. figure:: images/gitbook/git-merge-pull-3.png
     :scale: 100

* 用户 user1 执行 PUSH 操作，将本地提交推送到共享版本库中。

  .. figure:: images/gitbook/git-merge-pull-4.png
     :scale: 100

实际上拉回（PULL）操作是由两个步骤组成的，一个是获取（FETCH）操作，一个是合并（MERGE）操作。即：

::

  git pull = git fetch + git merge

获取（FETCH）操作从上面的示意图中看似很简单，实际上要到后面介绍远程版本库的章节才能够讲明白，现在只需要根据图示将获取操作理解为将远程的共享版本库的对象（提交、里程碑、分支等）复制到本地即可。

合并（MERGE）操作是本章要介绍的重点。合并操作可以由上面介绍的拉回操作（git pull）隐式的执行，将其它版本库的提交和本地版本库的提交进行合并，还可以针对本版本库中的其它分支（下一章介绍）进行显示的合并操作，将其它分支的提交和当前分支的提交进行合并。

合并操作的命令行格式如下：

::

  git merge [选项...] <commit>...

合并操作的大多数情况，只需提供一个 `<commit>` （提交ID或者对应的引用：分支、里程碑等）作为参数，合并操作将 `<commit>` 对应的目录树和当前工作分支的目录树的内容进行合并，合并后的提交以当前分支的提交作为第一个父提交，以 `<commit>` 为第二个父提交。合并操作还支持将多个 `<commit>` 代表的分支和当前分支进行合并，过程类似。合并操作的选项很多，会在本章以及后面子树合并的章节予以介绍。

如果不提供 `--no-commit` 选项，合并后的结果会自动提交，否则合并后的结果放入暂存区，用户可以对合并结果进行检查、更改，然后手动提交。

合并操作并非总会成功，因为合并的不同提交可能同时修改同一文件的相同区域的内容，导致冲突。冲突会造成合并操作的中断，冲突的文件被标识，用户可以在对标识为冲突的文件进行冲突解决操作，然后更新暂存区，再提交最终完成合并操作。

根据合并操作是否遇到冲突，以及不同的冲突类型，可以分为以下几种情况：成功的自动合并，逻辑冲突，真正的冲突，树冲突。下面分别予以介绍。

合并一：自动合并
================

Git 的合并操作非常智能，大多数情况下会自动完成合并。不管是修改不同的文件，还是修改相同的文件（文件的不同位置），或者文件名变更。

修改不同的文件
--------------

当用户 user1 和 user2 的本地提交中修改了不同的文件，当一个用户将改动推送到服务器后，另外一个用户推送就需要先合并再推送。因两个用户修改了不同的文件，合并不会遇到麻烦。

在之前的操作中，两个用户的本地版本库和共享版本库不一致，为确保版本库状态的一致性以便下面的实践能够正常执行，分别在两个用户的本地版本库中执行下面的操作。

::

  $ git pull
  $ git reset --hard origin/master

下面的实践两个用户分别修改不同的文件，其中一个用户要尝试合并操作将本地提交和另外一个用户的提交合并。

* 用户 user1 修改 `team/user1.txt` 文件，提交并推送到共享服务器。

  ::

    $ cd /path/to/user1/workspace/project/
    $ echo "hack by user1 at `date -R`" >> team/user1.txt 
    $ git add -u
    $ git commit -m "update team/user1.txt"
    $ git push

* 用户 user2 修改 `team/user2.txt` 文件，提交。

  ::

    $ cd /path/to/user2/workspace/project/
    $ echo "hack by user2 at `date -R`" >> team/user2.txt 
    $ git add -u
    $ git commit -m "update team/user2.txt"

* 用户 user2 在推送的时候，会遇到非快进式推进的错误而被终止。

  ::

    $ git push
    To file:///path/to/repos/shared.git
     ! [rejected]        master -> master (non-fast-forward)
    error: failed to push some refs to 'file:///path/to/repos/shared.git'
    To prevent you from losing history, non-fast-forward updates were rejected
    Merge the remote changes (e.g. 'git pull') before pushing again.  See the
    'Note about fast-forwards' section of 'git push --help' for details.

* 用户 user2 执行获取（git fetch）操作。获取到的提交更新到本地跟踪共享版本库 master 分支的本地引用 `origin/master` 中。

  ::

    $ git fetch
    remote: Counting objects: 7, done.
    remote: Compressing objects: 100% (4/4), done.
    remote: Total 4 (delta 0), reused 0 (delta 0)
    Unpacking objects: 100% (4/4), done.
    From file:///path/to/repos/shared
       bccc620..25fce74  master     -> origin/master

* 用户 user2 执行合并操作，完成自动合并。

  ::

    $ git merge origin/master
    Merge made by recursive.
     team/user1.txt |    1 +
     1 files changed, 1 insertions(+), 0 deletions(-)

* 用户 user2 推送合并后的本地版本库到共享版本库。

  ::

    $ git push
    Counting objects: 12, done.
    Delta compression using up to 2 threads.
    Compressing objects: 100% (7/7), done.
    Writing objects: 100% (7/7), 747 bytes, done.
    Total 7 (delta 0), reused 0 (delta 0)
    Unpacking objects: 100% (7/7), done.
    To file:///path/to/repos/shared.git
       25fce74..0855b86  master -> master
     
* 通过提交日志，可以看到成功合并的提交和其两个父提交的关系图。

  ::

    $ git log -3 --graph --stat
    *   commit 0855b86678d1cf86ccdd13adaaa6e735715d6a7e
    |\  Merge: f53acdf 25fce74
    | | Author: user2 <user2@moon.ossxp.com>
    | | Date:   Sat Dec 25 23:00:55 2010 +0800
    | | 
    | |     Merge remote branch 'origin/master'
    | |   
    | * commit 25fce74b5e73b960c42e4a463d03d462919b674d
    | | Author: user1 <user1@sun.ossxp.com>
    | | Date:   Sat Dec 25 22:54:53 2010 +0800
    | | 
    | |     update team/user1.txt
    | | 
    | |  team/user1.txt |    1 +
    | |  1 files changed, 1 insertions(+), 0 deletions(-)
    | |   
    * | commit f53acdf6a76e0552b562f5aaa4d40ff19e8e2f77
    |/  Author: user2 <user2@moon.ossxp.com>
    |   Date:   Sat Dec 25 22:56:49 2010 +0800
    |   
    |       update team/user2.txt
    |   
    |    team/user2.txt |    1 +
    |    1 files changed, 1 insertions(+), 0 deletions(-)


修改相同文件的不同区域
----------------------

当用户 user1 和 user2 的本地提交中修改相同的文件，但是修改的是文件的不同的位置，则两个用户的提交仍可成功合并。

* 为确保两个用户的本地版本库和共享版本库状态一致，对两个用户的本地版本库执行拉回操作。

  ::

    $ git pull

* 用户 user1 在自己的工作区，修改 `README` 文件，在文件的第一行插入内容，更改后的文件内容如下。

  ::

    User1 hacked.
    Hello.

* 用户 user1 对修改进行本地提交并推送到共享版本库。

  ::

    $ git add -u
    $ git commit -m "User1 hack at the beginning."
    $ git push

* 用户 user2 在自己的工作区，修改 `README` 文件，在文件的最后插入内容，更改后的文件内容如下。

  ::

    Hello.
    User2 hacked.


* 用户 user2 对修改进行本地提交。

  ::

    $ git add -u
    $ git commit -m "User2 hack at the end."

* 用户 user2 执行获取（git fetch）操作。获取到的提交更新到本地跟踪共享版本库 master 分支的本地引用 `origin/master` 中。

  ::

    $ git fetch
    remote: Counting objects: 5, done.
    remote: Compressing objects: 100% (2/2), done.
    remote: Total 3 (delta 0), reused 0 (delta 0)
    Unpacking objects: 100% (3/3), done.
    From file:///path/to/repos/shared
       0855b86..07e9d08  master     -> origin/master

* 用户 user2 执行合并操作，完成自动合并。

  ::

    $ git merge refs/remotes/origin/master
    Auto-merging README
    Merge made by recursive.
     README |    1 +
     1 files changed, 1 insertions(+), 0 deletions(-)

* 用户 user2 推送合并后的本地版本库到共享版本库。

  ::

    $ git push
    Counting objects: 10, done.
    Delta compression using up to 2 threads.
    Compressing objects: 100% (4/4), done.
    Writing objects: 100% (6/6), 607 bytes, done.
    Total 6 (delta 0), reused 3 (delta 0)
    Unpacking objects: 100% (6/6), done.
    To file:///path/to/repos/shared.git
       07e9d08..2a67e6f  master -> master

* 如果追溯一下 `README` 文件每一行的来源，可以看到分别是 user1 和 user2 更改的最前和最后的一行。

  ::

    $ git blame README
    07e9d082 (user1 2010-12-25 23:12:17 +0800 1) User1 hacked.
    ^5174bf3 (user1 2010-12-19 15:52:29 +0800 2) Hello.
    bb0c74fa (user2 2010-12-25 23:14:27 +0800 3) User2 hacked.

同时更改文件名和文件内容
------------------------

如果一个用户将文件移动到其它目录（修改文件名），另外一个用户针对重命名前的文件进行了修改，还能够实现自动合并么？这对于其它版本控制系统可能是一个难题，例如 Subversion 就不能很好的处理，还为此引入了一个“树冲突”的新名词。Git 对于此类冲突能够很好的处理，可以自动解决冲突实现合并的自动执行。

* 为确保两个用户的本地版本库和共享版本库状态一致，对两个用户的本地版本库执行拉回操作。

  ::

    $ git pull

* 用户 user1 在自己的工作区，将文件 `README` 文件进行重命名，本地提交并推送到共享版本库。

  ::

    $ cd /path/to/user1/workspace/project/
    $ mkdir doc
    $ git mv README doc/README.txt
    $ git commit -m "move document to doc/."
    $ git push

* 用户 user1 对修改进行本地提交并推送到共享版本库。

  ::

    $ git add -u
    $ git commit -m "User1 hack at the beginning."
    $ git push

* 用户 user2 在自己的工作区，修改 `README` 文件，在文件的最后插入内容，并本地提交。

  ::

    $ cd /path/to/user2/workspace/project/
    $ echo "User2 hacked again." >> README
    $ git add -u
    $ git commit -m "User2 hack README again."

* 用户 user2 执行获取（git fetch）操作。获取到的提交更新到本地跟踪共享版本库 master 分支的本地引用 `origin/master` 中。

  ::

    $ git fetch
    remote: Counting objects: 5, done.
    remote: Compressing objects: 100% (2/2), done.
    remote: Total 3 (delta 0), reused 0 (delta 0)
    Unpacking objects: 100% (3/3), done.
    From file:///path/to/repos/shared
       0855b86..07e9d08  master     -> origin/master

* 用户 user2 执行合并操作，完成自动合并。

  ::

    $ git merge refs/remotes/origin/master
    Merge made by recursive.
     README => doc/README.txt |    0
     1 files changed, 0 insertions(+), 0 deletions(-)
     rename README => doc/README.txt (100%)

* 用户 user2 推送合并后的本地版本库到共享版本库。

  ::

    $ git push
    Counting objects: 10, done.
    Delta compression using up to 2 threads.
    Compressing objects: 100% (5/5), done.
    Writing objects: 100% (6/6), 636 bytes, done.
    Total 6 (delta 0), reused 0 (delta 0)
    Unpacking objects: 100% (6/6), done.
    To file:///path/to/repos/shared.git
       9c51cb9..f73db10  master -> master
     
* 使用 `-m` 参数可以查看合并操作所作出的修改。

  ::

    $ git log -1 -m --stat
    commit f73db106c820f0c6d510f18ae8c67629af9c13b7 (from 887488eee19300c566c272ec84b236026b0303c6)
    Merge: 887488e 9c51cb9
    Author: user2 <user2@moon.ossxp.com>
    Date:   Sat Dec 25 23:36:57 2010 +0800

        Merge remote branch 'refs/remotes/origin/master'

     README         |    4 ----
     doc/README.txt |    4 ++++
     2 files changed, 4 insertions(+), 4 deletions(-)

    commit f73db106c820f0c6d510f18ae8c67629af9c13b7 (from 9c51cb91bfe12654e2de1d61d722161db0539644)
    Merge: 887488e 9c51cb9
    Author: user2 <user2@moon.ossxp.com>
    Date:   Sat Dec 25 23:36:57 2010 +0800

        Merge remote branch 'refs/remotes/origin/master'

     doc/README.txt |    1 +
     1 files changed, 1 insertions(+), 0 deletions(-)

合并二：逻辑冲突
================

自动合并如果成功的执行，则大多数情况下意味着完事大吉，但是某些特殊情况下，合并后的结果虽然在 Git 看来是完美的合并，实际上却存在着逻辑冲突。

一个典型的逻辑冲突是一个用户修改了一个文件的文件名，而另外的用户在其它文件中引用旧的文件名，这样的合并虽然能够成功但是包含着逻辑冲突。例如：

* 一个 C 语言的项目中存在头文件 `hello.h` ，该头文件定义了一些函数声明。
* 用户 user1 将 `hello.h` 文件改名为 `api.h` 。
* 用户 user2 写了一个新的源码文件 `foo.c` 并在该文件中包含了 `hello.h` 文件。
* 两个用户的提交合并后，会因为源码文件 `foo.c` 中包含 `hello.h` 找不到而导致项目编译失败。

再举一个逻辑冲突的示例。这个示例中的逻辑冲突是因为一个用户修改了函数返回值而另外的用户使用旧的函数返回值，虽然成功合并但是存在逻辑冲突。

* 函数 `compare(obj1, obj2)` 用于比较两个对象 obj1 和 obj2 。返回 1 代表比较的两个对象相同，返回 0 代表比较的两个对象不同。
* 用户 user1 修改了该函数的返回值，返回 0 代表两个对象相同，返回 1 代表 obj1 大于 obj2 ，返回 -1 则代表 obj1 小于 obj2。
* 用户 user2 不知道 user1 对该函数的改动，仍以该函数原返回值判断两个对象的异同。
* 两个用户的提交合并后，不会出现编译错误，但是软件中会潜藏着重大的 Bug。

上面的两个逻辑冲突的示例，尤其是最后一个非常难以捕捉。如果因此而贬低 Git 的自动合并，或者对每次自动合并的结果疑神疑鬼，进而花费大量精力去分析合并的结果是得不尝试的，是因噎废食。一个好的项目实践是每个开发人员都为自己的代码编写可运行的单元测试，项目每次编译时都要执行自动化测试，捕捉潜藏的 Bug。

合并三：冲突解决
================

如果两个用户修改了同一文件的同一区域，则在合并的时候 Git 并不能越俎代庖的替用户作出决定，而是把决定权交给用户。在这种情况下，Git 显示为合并冲突，等待用户对冲突作出抉择。

下面的实践非常简单，两个用户都修改 `doc/README.txt` 文件，将第二行 "Hello." 的后面加上自己的名字。

* 用户 user1 在自己的工作区修改 `doc/README.txt` 文件。修改后内容如下：

  ::

    User1 hacked.
    Hello, user1.
    User2 hacked.
    User2 hacked again.

* 用户 user1 对修改进行本地提交并推送到共享版本库。

  ::

    $ git add -u
    $ git commit -m "Say hello to user1."
    ...
    $ git push
    ...

* 用户 user2 在自己的工作区修改 `doc/README.txt` 文件。修改后内容如下：

  ::

    User1 hacked.
    Hello, user2.
    User2 hacked.
    User2 hacked again.

* 用户 user2 对修改进行本地提交。

  ::

    $ git add -u
    $ git commit -m "Say hello to user2."
    ...

* 用户 user2 执行拉回操作，遇到冲突。

  git pull 操作相当于 git fetch 和 git merge 两个操作。

  ::

    $ git pull
    remote: Counting objects: 7, done.
    remote: Compressing objects: 100% (3/3), done.
    remote: Total 4 (delta 0), reused 0 (delta 0)
    Unpacking objects: 100% (4/4), done.
    From file:///path/to/repos/shared
       f73db10..a123390  master     -> origin/master
    Auto-merging doc/README.txt
    CONFLICT (content): Merge conflict in doc/README.txt
    Automatic merge failed; fix conflicts and then commit the result.



$ git status
# On branch master
# Your branch and 'refs/remotes/origin/master' have diverged,
# and have 1 and 1 different commit(s) each, respectively.
#
# Unmerged paths:
#   (use "git add/rm <file>..." as appropriate to mark resolution)
#
#       both modified:      doc/README.txt
#
no changes added to commit (use "git add" and/or "git commit -a")

冲突解决（手动）

冲突解决（mergetool）

    kdiff3

合并四：树冲突
==============

两个用户都对同一文件执行改名操作，该如何呢？

合并策略
========
merge 操作的策略

    ours
    theirs
    recursive
    ocutpus

