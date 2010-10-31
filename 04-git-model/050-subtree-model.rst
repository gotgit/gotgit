子树合并
================

使用子树合并，同样可以实现在一个项目中引用其它项目的数据。但是和子模组方式不同的是，使用子树合并，外部的版本库整个复制到本版本库中并建立跟踪关联。使用子树合并模型，使得对源自外部版本库的数据的访问和本版本库数据的访问没有区别，也可以对其进行本地的修改，并且能够通过子树合并的方式将对源自外部版本库的改动和本地的修改相合并。

引入外部版本库
---------------

为演示子树合并，我们需要至少准备两个版本库，一个是将被作为子目录引入的版本库 util.git ，另外一个是主版本库 main.git 。

::

  $ git --git-dir=/path/to/util.git init --bare
  $ git --git-dir=/path/to/main.git init --bare

在本地检出这两个版本库：

::

  $ git clone /path/to/util.git
  $ git clone /path/to/main.git

我们需要为这两个空版本库添加些数据。非常简单，每个版本库下我们只创建两个文件： Makefile 和 version。当执行 make 命令时显示 version 文件的内容。

例如 Makefile 文件的内容如下。

::

  all:
      @cat version

我们之前尝试的 git fetch 命令都是获取同一项目的版本库的内容。其实命令 git fetch 并不禁止你用它获取不同项目的版本库数据。当然你也可以用 git pull，但是那样将把两个项目的文件彻底混杂在一起，对于我们这个示例来说，因为两个项目具有同样的文件 Makefile 和 version，使用 git pull 将导致冲突，是我们不愿意出现的。

为了便于以后对外部版本库的跟踪，在使用 git fetch 时，最好先在 main 版本库中注册远程版本库 util.git。

::

  $ git remote add util /path/to/util.git

  $ git remote -v
  origin  /path/to/main.git/ (fetch)
  origin  /path/to/main.git/ (push)
  util    /path/to/util.git (fetch)
  util    /path/to/util.git (push)

  $ git fetch util

  $ git branch -a
  * master
    remotes/origin/master
    remotes/util/master

我们基于 remotes/util/master 创建一个本地分支，我们会看到根目录的 Makefile 和 version 属于原 util.git 版本库，而非 main.git 版本库。

::

  $ make
  main v2010.1

  $ git checkout -b util-branch util/master
  Branch util-branch set up to track remote branch master from util.
  Switched to a new branch 'util-branch'

  $ git branch -a
    master
  * util-branch
    remotes/origin/master
    remotes/util/master

  $ make
  util v3.0

像这样在 main.git 中引入 util.git 显然不能满足我们需要，因为在包含 main 版本库数据的 master 分支访问不到只有在 util-branch 分支中才出现的 util 版本库数据。我们需要做进一步的工作，将两个版本库的内容合并到一个分支中。

子目录方式合并外部版本库
-------------------------

下面我们就用 git 的 read-tree, write-tree, commit-tree 子命令实现将 util-branch 分支所包含的 util.git 版本库的目录树以子目录（lib/）型式添加到 master 分支。

我们先来看看 util-branch 分支当前最新提交所包含的目录树。

::

  $ git cat-file -p util-branch
  tree 0c743e49e11019678c8b345e667504cb789431ae
  parent f21f9c10cc248a4a28bf7790414baba483f1ec15
  author Jiang Xin <jiangxin@ossxp.com> 1288494998 +0800
  committer Jiang Xin <jiangxin@ossxp.com> 1288494998 +0800

  util v2.0 -> v3.0

这是 util-branch 分支中最新提交所包含的信息。我们记住该提交对应的 tree id 为： 0c743e4 。

查看 tree 0c743e4 所包含的内容。

::

  $ git cat-file -p 0c743e4
  100644 blob 07263ff95b4c94275f4b4735e26ea63b57b3c9e3    Makefile
  100644 blob bebe6b10eb9622597dd2b641efe8365c3638004e    version

我们切换到 master 分支，如下方式调用 git read-tree 将 util-branch 的目录树读取到当前分支 lib 目录下。

::

  $ git checkout master

  $ git read-tree --prefix=lib util-branch

  $ git status
  # On branch master
  # Changes to be committed:
  #   (use "git reset HEAD <file>..." to unstage)
  #
  #       new file:   lib/Makefile
  #       new file:   lib/version
  #
  # Changed but not updated:
  #   (use "git add/rm <file>..." to update what will be committed)
  #   (use "git checkout -- <file>..." to discard changes in working directory)
  #
  #       deleted:    lib/Makefile
  #       deleted:    lib/version
  #

  $ git checkout -- lib

  $ git status
  # On branch master
  # Changes to be committed:
  #   (use "git reset HEAD <file>..." to unstage)
  #
  #       new file:   lib/Makefile
  #       new file:   lib/version
  #

调用 git read-tree 只是更新了 index，所以上面我们还用一条 `git checkout -- lib` 命令更新了工作区 lib 目录的内容。

现在我们还不能提交，因为现在提交体现不出来两个分支的合并关系。

我们调用 `git write-tree` 将 index （暂存区）的目录树保存下来。

::

  $ git write-tree
  2153518409d218609af40babededec6e8ef51616
  
  $ git cat-file -p 2153518409d218609af40babededec6e8ef51616
  100644 blob 07263ff95b4c94275f4b4735e26ea63b57b3c9e3    Makefile
  040000 tree 0c743e49e11019678c8b345e667504cb789431ae    lib
  100644 blob 638c7b7c6bdbde1d29e0b55b165f755c8c4332b5    version

我们要记住调用 `git write-tree` 后形成的新的 tree id： 2153518。同时我们也注意到，该 treeid 指向的目录树中包含的 lib 目录的 treeid 和之前我们查看过的 util-branch 分支最新提交对应的 treeid 一样是 0c743e4。

然后要调用 git commit-tree 来产生新的提交。之所以不用 `git commit` 而使用底层命令，是因为我们要为此新的提交指定两个 parents，让这个提交看起来是两棵树的合并。这两棵树分别是 master 分支和 util-branch 分支。

::

  $ git rev-parse HEAD
  911b1af2e0c95a2fc1306b8dea707064d5386c2e
  $ git rev-parse util-branch
  12408a149bfa78a4c2d4011f884aa2adb04f0934

就以上面两个 revid 为 parents，我们对树 2153518409d218609af40babededec6e8ef51616 执行提交。

::

  $ echo "subtree merge" | git commit-tree 2153518409d218609af40babededec6e8ef51616 \
  > -p 911b1af2e0c95a2fc1306b8dea707064d5386c2e \
  > -p 12408a149bfa78a4c2d4011f884aa2adb04f0934
  62ae6cc3f9280418bdb0fcf6c1e678905b1fe690

提交之后产生一个新的 commit id。我们需要把当前的 master 分支重置到此 commitid。

::
  
  $ git reset 62ae6cc3f9280418bdb0fcf6c1e678905b1fe690

我们查看一下提交日记及分支图，我们可以看到我们通过复杂的 git read-tree, git write-tree 和 git commit-tree 制造的提交，的确将两个不同版本库合并到一起了。

::

  $ git log --graph --pretty=oneline
  *   62ae6cc3f9280418bdb0fcf6c1e678905b1fe690 subtree merge
  |\  
  | * 12408a149bfa78a4c2d4011f884aa2adb04f0934 util v2.0 -> v3.0
  | * f21f9c10cc248a4a28bf7790414baba483f1ec15 util v1.0 -> v2.0
  | * 76db0ad729db9fdc5be043f3b4ed94ddc945cd7f util v1.0
  * 911b1af2e0c95a2fc1306b8dea707064d5386c2e main v2010.1

我们看看现在的 master 分支。

::

  $ git cat-file -p HEAD
  tree 2153518409d218609af40babededec6e8ef51616
  parent 911b1af2e0c95a2fc1306b8dea707064d5386c2e
  parent 12408a149bfa78a4c2d4011f884aa2adb04f0934
  author Jiang Xin <jiangxin@ossxp.com> 1288498186 +0800
  committer Jiang Xin <jiangxin@ossxp.com> 1288498186 +0800

  subtree merge

  $ git cat-file -p 2153518409d218609af40babededec6e8ef51616
  100644 blob 07263ff95b4c94275f4b4735e26ea63b57b3c9e3    Makefile
  040000 tree 0c743e49e11019678c8b345e667504cb789431ae    lib
  100644 blob 638c7b7c6bdbde1d29e0b55b165f755c8c4332b5    version


整个过程非常繁琐，但是不要担心，我们只需要对原理了解清楚，后面我会介绍一个 Git 插件实现子树合并操作的封装。

利用子树合并跟踪上游改动
------------------------

如果合并子树（lib 目录）的上游（即 util.git）包含了新的提交，如何将 util.git 的新提交合并过来呢？这就要用到名为 subtree 的合并策略。

在执行子树合并之前，我们先切换到 util-branch 分支，获取远程版本库改动。

::

  $ git checkout util-branch

  $ git pull
  remote: Counting objects: 8, done.
  remote: Compressing objects: 100% (4/4), done.
  remote: Total 6 (delta 0), reused 0 (delta 0)
  Unpacking objects: 100% (6/6), done.
  From /path/to/util
     12408a1..5aba14f  master     -> util/master
  Updating 12408a1..5aba14f
  Fast-forward
   version |    2 +-
   1 files changed, 1 insertions(+), 1 deletions(-)

  $ git checkout master

在切换回 master 分支后，如果这时我们执行 `git merge util-branch` ，会将 uitl-branch 的数据直接合并到 master 分支的根目录下，而我们希望合并发生在 lib 目录中，这就需要如下方式进行调用。

如果 git 的版本小于 1.7，直接使用 subtree 合并策略。

::

  $ git merge -s subtree util-branch

如果 git 的版本是 1.7 之后（含1.7）的版本，则可以使用缺省的 recursive 合并策略，通过参数 subtree=<prefix> 在合并时使用正确的子树进行匹配合并。避免了使用 subtree 合并策略时的猜测。

::

  $ git merge -Xsubtree=lib util-branch

我们再来看看执行子树合并之后的分支图示。

::

  $ git log --graph --pretty=oneline
  *   f1a33e55eea04930a500c18a24a8bd009ecd9ac2 Merge branch 'util-branch'
  |\  
  | * 5aba14fd347fc22cd8fbd086c9f26a53276f15c9 util v3.1 -> v3.2
  | * a6d53dfcf78e8a874e9132def5ef87a2b2febfa5 util v3.0 -> v3.1
  * |   62ae6cc3f9280418bdb0fcf6c1e678905b1fe690 subtree merge
  |\ \  
  | |/  
  | * 12408a149bfa78a4c2d4011f884aa2adb04f0934 util v2.0 -> v3.0
  | * f21f9c10cc248a4a28bf7790414baba483f1ec15 util v1.0 -> v2.0
  | * 76db0ad729db9fdc5be043f3b4ed94ddc945cd7f util v1.0
  * 911b1af2e0c95a2fc1306b8dea707064d5386c2e main v2010.1

子树拆分
----------

git subtree 子命令
-------------------

kernel.org > Pub > Software > Scm > Git > Docs > Howto > Using-merge-subtree <http://www.kernel.org/pub/software/scm/git/docs/howto/using-merge-subtree.html>



命令

::

    $ git remote add -f Bproject /path/to/B (1)
    $ git merge -s ours --no-commit Bproject/master (2)
    $ git read-tree --prefix=dir-B/ -u Bproject/master (3)
    $ git commit -m "Merge B project as our subdirectory" (4)
    $ git pull -s subtree Bproject master (5)

git subtree plugin from 
-------------------------------------------
    http://github.com/apenwarr/git-subtree/


git-subtree(1)
==============

-P <prefix> 是必选参数。除了 git subtree add 之外，其它子命令，该前缀指向的子目录必须存在。

如果命令是 merge 和 split，后面只跟 <commit> 参数，不能跟路径。
    die "Error: Use --prefix instead of bare filenames."

缓存目录：.git/subtree-cache/$$

NAME
----
git-subtree - Merge subtrees together and split repository into subtrees


SYNOPSIS
--------
[verse]
'git subtree' add -P <prefix> <commit>
'git subtree' pull -P <prefix> <repository> <refspec...>
'git subtree' push -P <prefix> <repository> <refspec...>
'git subtree' merge -P <prefix> <commit>
'git subtree' split -P <prefix> [OPTIONS] [<commit>]


DESCRIPTION
-----------
Subtrees allow subprojects to be included within a subdirectory
of the main project, optionally including the subproject's
entire history.

For example, you could include the source code for a library
as a subdirectory of your application.

Subtrees are not to be confused with submodules, which are meant for
the same task. Unlike submodules, subtrees do not need any special
constructions (like .gitmodule files or gitlinks) be present in
your repository, and do not force end-users of your
repository to do anything special or to understand how subtrees
work. A subtree is just a subdirectory that can be
committed to, branched, and merged along with your project in
any way you want.

They are also not to be confused with using the subtree merge
strategy. The main difference is that, besides merging
the other project as a subdirectory, you can also extract the
entire history of a subdirectory from your project and make it
into a standalone project. Unlike the subtree merge strategy
you can alternate back and forth between these
two operations. If the standalone library gets updated, you can
automatically merge the changes into your project; if you
update the library inside your project, you can "split" the
changes back out again and merge them back into the library
project.

For example, if a library you made for one application ends up being
useful elsewhere, you can extract its entire history and publish
that as its own git repository, without accidentally
intermingling the history of your application project.

[TIP]
In order to keep your commit messages clean, we recommend that
people split their commits between the subtrees and the main
project as much as possible. That is, if you make a change that
affects both the library and the main application, commit it in
two pieces. That way, when you split the library commits out
later, their descriptions will still make sense. But if this
isn't important to you, it's not *necessary*. git subtree will
simply leave out the non-library-related parts of the commit
when it splits it out into the subproject later.


COMMANDS
--------
add::
Create the <prefix> subtree by importing its contents
from the given <refspec> or <repository> and remote <refspec>.
A new commit is created automatically, joining the imported
project's history with your own. With '--squash', imports
only a single commit from the subproject, rather than its
entire history.

merge::
Merge recent changes up to <commit> into the <prefix>
subtree. As with normal 'git merge', this doesn't
remove your own local changes; it just merges those
changes into the latest <commit>. With '--squash',
creates only one commit that contains all the changes,
rather than merging in the entire history.

If you use '--squash', the merge direction doesn't
always have to be forward; you can use this command to
go back in time from v2.5 to v2.4, for example. If your
merge introduces a conflict, you can resolve it in the
usual ways.

pull::
Exactly like 'merge', but parallels 'git pull' in that
it fetches the given commit from the specified remote
repository.

push::
Does a 'split' (see above) using the <prefix> supplied
and then does a 'git push' to push the result to the
repository and refspec. This can be used to push your
subtree to different branches of the remote repository.

split::
Extract a new, synthetic project history from the
history of the <prefix> subtree. The new history
includes only the commits (including merges) that
affected <prefix>, and each of those commits now has the
contents of <prefix> at the root of the project instead
of in a subdirectory. Thus, the newly created history
is suitable for export as a separate git repository.

After splitting successfully, a single commit id is
printed to stdout. This corresponds to the HEAD of the
newly created tree, which you can manipulate however you
want.

Repeated splits of exactly the same history are
guaranteed to be identical (ie. to produce the same
commit ids). Because of this, if you add new commits
and then re-split, the new commits will be attached as
commits on top of the history you generated last time,
so 'git merge' and friends will work as expected.

Note that if you use '--squash' when you merge, you
should usually not just '--rejoin' when you split.


OPTIONS
-------
-q::
--quiet::
Suppress unnecessary output messages on stderr.

-d::
--debug::
Produce even more unnecessary output messages on stderr.

-P <prefix>::
--prefix=<prefix>::
Specify the path in the repository to the subtree you
want to manipulate. This option is mandatory
for all commands.

-m <message>::
--message=<message>::
This option is only valid for add, merge and pull (unsure).
Specify <message> as the commit message for the merge commit.


OPTIONS FOR add, merge, push, pull
----------------------------------
--squash::
This option is only valid for add, merge, push and pull
commands.

Instead of merging the entire history from the subtree
project, produce only a single commit that contains all
the differences you want to merge, and then merge that
new commit into your project.

Using this option helps to reduce log clutter. People
rarely want to see every change that happened between
v1.0 and v1.1 of the library they're using, since none of the
interim versions were ever included in their application.

Using '--squash' also helps avoid problems when the same
subproject is included multiple times in the same
project, or is removed and then re-added. In such a
case, it doesn't make sense to combine the histories
anyway, since it's unclear which part of the history
belongs to which subtree.

Furthermore, with '--squash', you can switch back and
forth between different versions of a subtree, rather
than strictly forward. 'git subtree merge --squash'
always adjusts the subtree to match the exactly
specified commit, even if getting to that commit would
require undoing some changes that were added earlier.

Whether or not you use '--squash', changes made in your
local repository remain intact and can be later split
and send upstream to the subproject.


OPTIONS FOR split
-----------------
--annotate=<annotation>::
This option is only valid for the split command.

When generating synthetic history, add <annotation> as a
prefix to each commit message. Since we're creating new
commits with the same commit message, but possibly
different content, from the original commits, this can help
to differentiate them and avoid confusion.

Whenever you split, you need to use the same
<annotation>, or else you don't have a guarantee that
the new re-created history will be identical to the old
one. That will prevent merging from working correctly.
git subtree tries to make it work anyway, particularly
if you use --rejoin, but it may not always be effective.

-b <branch>::
--branch=<branch>::
This option is only valid for the split command.

After generating the synthetic history, create a new
branch called <branch> that contains the new history.
This is suitable for immediate pushing upstream.
<branch> must not already exist.

--ignore-joins::
This option is only valid for the split command.

If you use '--rejoin', git subtree attempts to optimize
its history reconstruction to generate only the new
commits since the last '--rejoin'. '--ignore-join'
disables this behaviour, forcing it to regenerate the
entire history. In a large project, this can take a
long time.

--onto=<onto>::
This option is only valid for the split command.

If your subtree was originally imported using something
other than git subtree, its history may not match what
git subtree is expecting. In that case, you can specify
the commit id <onto> that corresponds to the first
revision of the subproject's history that was imported
into your project, and git subtree will attempt to build
its history from there.

If you used 'git subtree add', you should never need
this option.

--rejoin::
This option is only valid for the split command.

After splitting, merge the newly created synthetic
history back into your main project. That way, future
splits can search only the part of history that has
been added since the most recent --rejoin.

If your split commits end up merged into the upstream
subproject, and then you want to get the latest upstream
version, this will allow git's merge algorithm to more
intelligently avoid conflicts (since it knows these
synthetic commits are already part of the upstream
repository).

Unfortunately, using this option results in 'git log'
showing an extra copy of every new commit that was
created (the original, and the synthetic one).

If you do all your merges with '--squash', don't use
'--rejoin' when you split, because you don't want the
subproject's history to be part of your project anyway.


EXAMPLE 1. Add command
----------------------
Let's assume that you have a local repository that you would like
to add an external vendor library to. In this case we will add the
git-subtree repository as a subdirectory of your already existing
git-extensions repository in ~/git-extensions/:

$ git subtree add --prefix=git-subtree --squash \
git://github.com/apenwarr/git-subtree.git master

'master' needs to be a valid remote ref and can be a different branch
name

You can omit the --squash flag, but doing so will increase the number
of commits that are incldued in your local repository.

We now have a ~/git-extensions/git-subtree directory containing code
from the master branch of git://github.com/apenwarr/git-subtree.git
in our git-extensions repository.

EXAMPLE 2. Extract a subtree using commit, merge and pull
---------------------------------------------------------
Let's use the repository for the git source code as an example.
First, get your own copy of the git.git repository:

$ git clone git://git.kernel.org/pub/scm/git/git.git test-git
$ cd test-git

gitweb (commit 1130ef3) was merged into git as of commit
0a8f4f0, after which it was no longer maintained separately.
But imagine it had been maintained separately, and we wanted to
extract git's changes to gitweb since that time, to share with
the upstream. You could do this:

$ git subtree split --prefix=gitweb --annotate='(split) ' \
         0a8f4f0^.. --onto=1130ef3 --rejoin \
         --branch gitweb-latest
        $ gitk gitweb-latest
        $ git push git@github.com:whatever/gitweb.git gitweb-latest:master
        
(We use '0a8f4f0^..' because that means "all the changes from
0a8f4f0 to the current version, including 0a8f4f0 itself.")

If gitweb had originally been merged using 'git subtree add' (or
a previous split had already been done with --rejoin specified)
then you can do all your splits without having to remember any
weird commit ids:

$ git subtree split --prefix=gitweb --annotate='(split) ' --rejoin \
--branch gitweb-latest2

And you can merge changes back in from the upstream project just
as easily:

$ git subtree pull --prefix=gitweb \
git@github.com:whatever/gitweb.git master

Or, using '--squash', you can actually rewind to an earlier
version of gitweb:

$ git subtree merge --prefix=gitweb --squash gitweb-latest~10

Then make some changes:

$ date >gitweb/myfile
$ git add gitweb/myfile
$ git commit -m 'created myfile'

And fast forward again:

$ git subtree merge --prefix=gitweb --squash gitweb-latest

And notice that your change is still intact:

$ ls -l gitweb/myfile

And you can split it out and look at your changes versus
the standard gitweb:

git log gitweb-latest..$(git subtree split --prefix=gitweb)

EXAMPLE 3. Extract a subtree using branch
-----------------------------------------
Suppose you have a source directory with many files and
subdirectories, and you want to extract the lib directory to its own
git project. Here's a short way to do it:

First, make the new repository wherever you want:

$ <go to the new location>
$ git init --bare

Back in your original direWritten by Avery Pennarun <apenwarr@gmail.com>


GIT
---
Part of the linkgit:git[1] suite



subtree from kernel.org
--------------------------------------------

http://www.kernel.org/pub/software/scm/git/docs/howto/using-merge-subtree.html

How to use the subtree merge strategy

There are situations where you want to include contents in your project from an independently developed project. You can just pull from the other project as long as there are no conflicting paths.

The problematic case is when there are conflicting files. Potential candidates are Makefiles and other standard filenames. You could merge these files but probably you do not want to. A better solution for this problem can be to merge the project as its own subdirectory. This is not supported by the recursive merge strategy, so just pulling won't work.

What you want is the subtree merge strategy, which helps you in such a situation.

In this example, let's say you have the repository at /path/to/B (but it can be an URL as well, if you want). You want to merge the master branch of that repository to the dir-B subdirectory in your current branch.

Here is the command sequence you need:

$ git remote add -f Bproject /path/to/B (1)
$ git merge -s ours --no-commit Bproject/master (2)
$ git read-tree --prefix=dir-B/ -u Bproject/master (3)
$ git commit -m "Merge B project as our subdirectory" (4)

$ git pull -s subtree Bproject master (5)

   1.

      name the other project "Bproject", and fetch.
   2.

      prepare for the later step to record the result as a merge.
   3.

      read "master" branch of Bproject to the subdirectory "dir-B".
   4.

      record the merge result.
   5.

      maintain the result with subsequent merges using "subtree"

The first four commands are used for the initial merge, while the last one is to merge updates from B project.
Comparing subtree merge with submodules

    *

      The benefit of using subtree merge is that it requires less administrative burden from the users of your repository. It works with older (before Git v1.5.2) clients and you have the code right after clone.
    *

      However if you use submodules then you can choose not to transfer the submodule objects. This may be a problem with the subtree merge.
    *

      Also, in case you make changes to the other project, it is easier to submit changes if you just use submodules.

Additional tips

    *

      If you made changes to the other project in your repository, they may want to merge from your project. This is possible using subtree — it can shift up the paths in your tree and then they can merge only the relevant parts of your tree.
    *

      Please note that if the other project merges from you, then it will connects its history to yours, which can be something they don't want to.


progit's subtree
--------------------------------------------------

http://progit.org/book/ch6-7.html

Subtree Merging

Now that you’ve seen the difficulties of the submodule system, let’s look at an alternate way to solve the same problem. When Git merges, it looks at what it has to merge together and then chooses an appropriate merging strategy to use. If you’re merging two branches, Git uses a recursive strategy. If you’re merging more than two branches, Git picks the octopus strategy. These strategies are automatically chosen for you because the recursive strategy can handle complex three-way merge situations — for example, more than one common ancestor — but it can only handle merging two branches. The octopus merge can handle multiple branches but is more cautious to avoid difficult conflicts, so it’s chosen as the default strategy if you’re trying to merge more than two branches.

However, there are other strategies you can choose as well. One of them is the subtree merge, and you can use it to deal with the subproject issue. Here you’ll see how to do the same rack embedding as in the last section, but using subtree merges instead.

The idea of the subtree merge is that you have two projects, and one of the projects maps to a subdirectory of the other one and vice versa. When you specify a subtree merge, Git is smart enough to figure out that one is a subtree of the other and merge appropriately — it’s pretty amazing.

You first add the Rack application to your project. You add the Rack project as a remote reference in your own project and then check it out into its own branch:

$ git remote add rack_remote git@github.com:schacon/rack.git
$ git fetch rack_remote
warning: no common commits
remote: Counting objects: 3184, done.
remote: Compressing objects: 100% (1465/1465), done.
remote: Total 3184 (delta 1952), reused 2770 (delta 1675)
Receiving objects: 100% (3184/3184), 677.42 KiB | 4 KiB/s, done.
Resolving deltas: 100% (1952/1952), done.
From git@github.com:schacon/rack
 * [new branch]      build      -> rack_remote/build
 * [new branch]      master     -> rack_remote/master
 * [new branch]      rack-0.4   -> rack_remote/rack-0.4
 * [new branch]      rack-0.9   -> rack_remote/rack-0.9
$ git checkout -b rack_branch rack_remote/master
Branch rack_branch set up to track remote branch refs/remotes/rack_remote/master.
Switched to a new branch "rack_branch"

Now you have the root of the Rack project in your rack_branch branch and your own project in the master branch. If you check out one and then the other, you can see that they have different project roots:

$ ls
AUTHORS        KNOWN-ISSUES   Rakefile      contrib        lib
COPYING        README         bin           example        test
$ git checkout master
Switched to branch "master"
$ ls
README

You want to pull the Rack project into your master project as a subdirectory. You can do that in Git with git read-tree. You’ll learn more about read-tree and its friends in Chapter 9, but for now know that it reads the root tree of one branch into your current staging area and working directory. You just switched back to your master branch, and you pull the rack branch into the rack subdirectory of your master branch of your main project:

$ git read-tree --prefix=rack/ -u rack_branch

When you commit, it looks like you have all the Rack files under that subdirectory — as though you copied them in from a tarball. What gets interesting is that you can fairly easily merge changes from one of the branches to the other. So, if the Rack project updates, you can pull in upstream changes by switching to that branch and pulling:

$ git checkout rack_branch
$ git pull

Then, you can merge those changes back into your master branch. You can use git merge -s subtree and it will work fine; but Git will also merge the histories together, which you probably don’t want. To pull in the changes and prepopulate the commit message, use the --squash and --no-commit options as well as the -s subtree strategy option:

$ git checkout master
$ git merge --squash -s subtree --no-commit rack_branch
Squash commit -- not updating HEAD
Automatic merge went well; stopped before committing as requested

All the changes from your Rack project are merged in and ready to be committed locally. You can also do the opposite — make changes in the rack subdirectory of your master branch and then merge them into your rack_branch branch later to submit them to the maintainers or push them upstream.

To get a diff between what you have in your rack subdirectory and the code in your rack_branch branch — to see if you need to merge them — you can’t use the normal diff command. Instead, you must run git diff-tree with the branch you want to compare to:

$ git diff-tree -p rack_branch

Or, to compare what is in your rack subdirectory with what the master branch on the server was the last time you fetched, you can run

$ git diff-tree -p rack_remote/master
