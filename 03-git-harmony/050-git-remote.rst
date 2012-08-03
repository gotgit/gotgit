远程版本库
***********

Git作为分布式版本库控制系统，每个人都是本地版本库的主人，可以在本地的版\
本库中随心所欲地创建分支和里程碑。当需要多人协作时，问题就出现了：

* 如何避免因为用户把所有的本地分支都推送到共享版本库，从而造成共享版本库\
  上分支的混乱？

* 如何避免不同用户针对不同特性开发创建了相同名字的分支而造成分支名称的冲突？

* 如何避免用户随意在共享版本库中创建里程碑而导致里程碑名称上的混乱和冲突？

* 当用户向共享版本库及其他版本库推送时，每次都需要输入长长的版本库URL，\
  太不方便了。

* 当用户需要经常从多个不同的他人版本库中获取提交时，有没有办法不要总是输\
  入长长的版本库URL？

* 如果不带任何其他参数执行\ :command:`git fetch`\ 、\ :command:`git pull`\
  和\ :command:`git push`\ 到底是和哪个远程版本库及哪个分支进行交互？

本章介绍的\ :command:`git remote`\ 命令就是用于实现远程版本库的便捷访问，\
建立远程分支和本地分支的对应，使得\ :command:`git fetch`\ 、\
:command:`git pull`\ 和\ :command:`git push`\ 能够更为便捷地进行操作。

远程分支
==============

上一章介绍Git分支的时候，每一个版本库最多只和一个上游版本库（远程共享版\
本库）进行交互，实际上Git允许一个版本库和任意多的版本库进行交互。首先执\
行下面的命令，基于\ ``hello-world.git``\ 版本库再创建几个新的版本库。

::

  $ cd /path/to/repos/
  $ git clone --bare hello-world.git hello-user1.git
  Cloning into bare repository hello-user1.git...
  done.
  $ git clone --bare hello-world.git hello-user2.git
  Cloning into bare repository hello-user2.git...
  done.

现在有了三个共享版本库：\ ``hello-world.git``\ 、\ ``hello-user1.git``\
和\ ``hello-user2.git``\ 。现在有一个疑问，如果一个本地版本库需要和上面\
三个版本库进行互操作，三个共享版本库都存在一个\ ``master``\ 分支，会不会\
互相干扰、冲突或覆盖呢？

先来看看\ ``hello-world``\ 远程共享版本库中包含的分支有哪些：

::

  $ git ls-remote --heads file:///path/to/repos/hello-world.git
  8cffe5f135821e716117ee59bdd53139473bd1d8        refs/heads/hello-1.x
  bb4fef88fee435bfac04b8389cf193d9c04105a6        refs/heads/helper/master
  cf71ae3515e36a59c7f98b9db825fd0f2a318350        refs/heads/helper/v1.x
  c4acab26ff1c1125f5e585ffa8284d27f8ceea55        refs/heads/master

原来远程共享版本库中有四个分支，其中\ ``hello-1.x``\ 分支是开发者user1\
创建的。现在重新克隆该版本库，如下：

::

  $ cd /path/to/my/workspace/
  $ git clone file:///path/to/repos/hello-world.git
  ...
  $ cd /path/to/my/workspace/hello-world


执行\ :command:`git branch`\ 命令检查分支，会吃惊地看到只有一个分支\
``master``\ 。

::

  $ git branch
  * master

那么远程版本库中的其他分支哪里去了？为什么本地只有一个分支呢？执行\
:command:`git show-ref`\ 命令可以看到全部的本地引用。

::

  $ git show-ref 
  c4acab26ff1c1125f5e585ffa8284d27f8ceea55 refs/heads/master
  c4acab26ff1c1125f5e585ffa8284d27f8ceea55 refs/remotes/origin/HEAD
  8cffe5f135821e716117ee59bdd53139473bd1d8 refs/remotes/origin/hello-1.x
  bb4fef88fee435bfac04b8389cf193d9c04105a6 refs/remotes/origin/helper/master
  cf71ae3515e36a59c7f98b9db825fd0f2a318350 refs/remotes/origin/helper/v1.x
  c4acab26ff1c1125f5e585ffa8284d27f8ceea55 refs/remotes/origin/master
  3171561b2c9c57024f7d748a1a5cfd755a26054a refs/tags/jx/v1.0
  aaff5676a7c3ae7712af61dfb9ba05618c74bbab refs/tags/jx/v1.0-i18n
  e153f83ee75d25408f7e2fd8236ab18c0abf0ec4 refs/tags/jx/v1.1
  83f59c7a88c04ceb703e490a86dde9af41de8bcb refs/tags/jx/v1.2
  1581768ec71166d540e662d90290cb6f82a43bb0 refs/tags/jx/v1.3
  ccca267c98380ea7fffb241f103d1e6f34d8bc01 refs/tags/jx/v2.0
  8a5b9934aacdebb72341dcadbb2650cf626d83da refs/tags/jx/v2.1
  89b74222363e8cbdf91aab30d005e697196bd964 refs/tags/jx/v2.2
  0b4ec63aea44b96d498528dcf3e72e1255d79440 refs/tags/jx/v2.3
  60a2f4f31e5dddd777c6ad37388fe6e5520734cb refs/tags/mytag
  5dc2fc52f2dcb84987f511481cc6b71ec1b381f7 refs/tags/mytag3
  51713af444266d56821fe3302ab44352b8c3eb71 refs/tags/v1.0

从\ :command:`git show-ref`\ 的输出中发现了几个不寻常的引用，这些引用以\
``refs/remotes/origin/``\ 为前缀，并且名称和远程版本库的分支名一一对应。\
这些引用实际上就是从远程版本库的分支拷贝过来的，称为远程分支。

Git 的\ :command:`git branch`\ 命令也能够查看这些远程分支，不过要加上\
``-r``\ 参数：

::

  $ git branch -r
    origin/HEAD -> origin/master
    origin/hello-1.x
    origin/helper/master
    origin/helper/v1.x
    origin/master

Git这样的设计是非常巧妙的，在向远程版本库执行获取操作时，不是把远程版本\
库的分支原封不动地复制到本地版本库的分支中，而是复制到另外的命名空间。\
如在克隆一个版本库时，会将远程分支都复制到目录\ :file:`.git/refs/remotes/origin/`\
下。这样向不同的远程版本库执行获取操作，因为远程分支相互隔离，所以就\
避免了相互的覆盖。

那么克隆操作产生的远程分支为什么都有一个名为“origin/”的前缀呢？奥秘就在\
配置文件\ :file:`.git/config`\ 中。下面的几行内容出自该配置文件，为了说\
明方便显示了行号。

::

   6 [remote "origin"]
   7   fetch = +refs/heads/*:refs/remotes/origin/*
   8   url = file:///path/to/repos/hello-world.git

这个小节可以称为\ ``[remote]``\ 小节，该小节以origin为名注册了一个远程版\
本库。该版本库的URL地址由第8行给出，会发现这个URL地址就是执行\
:command:`git clone`\ 命令时所用的地址。最具魔法的配置是第7行，这一行\
设置了执行\ :command:`git fetch origin`\ 操作时使用的默认引用表达式。

* 该引用表达式以加号（+）开头，含义是强制进行引用的替换，即使即将进行的\
  替换是非快进式的。

* 引用表达式中使用了通配符，冒号前面的含有通配符的引用指的是远程版本库的\
  所有分支，冒号后面的引用含义是复制到本地的远程分支目录中。

正因为有了上面的\ ``[remote]``\ 配置小节，当执行\ :command:`git fetch origin`\
操作时，就相当于执行了下面的命令，将远程版本库的所有分支复制为本地\
的远程分支。

::

  git fetch origin +refs/heads/*:refs/remotes/origin/*


远程分支不是真正意义上的分支，是类似于里程碑一样的引用。如果针对远程分支\
执行检出命令，会看到大段的错误警告。

::

  $ git checkout origin/hello-1.x
  Note: checking out 'origin/hello-1.x'.

  You are in 'detached HEAD' state. You can look around, make experimental
  changes and commit them, and you can discard any commits you make in this
  state without impacting any branches by performing another checkout.

  If you want to create a new branch to retain commits you create, you may
  do so (now or later) by using -b with the checkout command again. Example:

    git checkout -b new_branch_name

  HEAD is now at 8cffe5f... Merge branch 'hello-1.x' of file:///path/to/repos/hello-world into hello-1.x

上面的大段的错误信息实际上告诉我们一件事，远程分支类似于里程碑，如果检出\
就会使得头指针\ ``HEAD``\ 处于分离头指针状态。实际上除了以\ ``refs/heads``\
为前缀的引用之外，如果检出任何其他引用，都将使工作区处于分离头指针状态。\
如果对远程分支进行修改就需要创建新的本地分支。

分支追踪
================

为了能够在远程分支\ ``refs/remotes/origin/hello-1.x``\ 上进行工作，需要\
基于该远程分支创建本地分支。远程分支可以使用简写\ ``origin/hello-1.x``\ 。\
如果Git的版本是1.6.6或者更新的版本，可以使用下面的命令同时完成分支的创建和切换。

::

  $ git checkout hello-1.x
  Branch hello-1.x set up to track remote branch hello-1.x from origin.
  Switched to a new branch 'hello-1.x'

如果Git的版本比较老，或注册了多个远程版本库，因此存在多个名为\ ``hello-1.x``\
的远程分支，就不能使用上面简洁的分支创建和切换命令，而需要使用在上一章\
中学习到的分支创建命令，显式地从远程分支中创建本地分支。

::

  $ git checkout -b hello-1.x origin/hello-1.x
  Branch hello-1.x set up to track remote branch hello-1.x from origin.
  Switched to a new branch 'hello-1.x'

在上面基于远程分支创建本地分支的过程中，命令输出的第一行说的是建立了本地\
分支和远程分支的跟踪。和远程分支建立跟踪后，本地分支就具有下列特征：

* 检查工作区状态时，会显示本地分支和被跟踪远程分支提交之间的关系。

* 当执行\ :command:`git pull`\ 命令时，会和被跟踪的远程分支进行合并\
  （或者变基），如果两者出现版本偏离的话。

* 当执行\ :command:`git push`\ 命令时，会推送到远程版本库的同名分支中。

下面就在基于远程分支创建的本地跟踪分支中进行操作，看看本地分支是如何与\
远程分支建立关联的。

* 先将本地\ ``hello-1.x``\ 分支向后重置两个版本。

  ::

    $ git reset --hard HEAD^^
    HEAD is now at ebcf6d6 blank commit for GnuPG-signed tag test.

* 然后查看状态，显示当前分支相比跟踪分支落后了3个版本。

  之所以落后三个版本而非两个版本是因为\ ``hello-1.x``\ 的最新提交是一个\
  合并提交，包含两个父提交，因此上面的重置命令丢弃掉三个提交。

  ::

    $ git status
    # On branch hello-1.x
    # Your branch is behind 'origin/hello-1.x' by 3 commits, and can be fast-forwarded.
    #
    nothing to commit (working directory clean)

* 执行\ :command:`git pull`\ 命令，会自动与跟踪的远程分支进行合并，相当于\
  找回最新的3个提交。

  ::

    $ git pull
    Updating ebcf6d6..8cffe5f
    Fast-forward
     src/main.c |   11 +++++++++--
     1 files changed, 9 insertions(+), 2 deletions(-)

但是如果基于本地分支创建另外一个本地分支则没有分支跟踪的功能。下面就从\
本地的\ ``hello-1.x``\ 分支中创建\ ``hello-jx``\ 分支。

* 从\ ``hello-1.x``\ 分支中创建新的本地分支\ ``hello-jx``\ 。

  下面的创建分支操作只有一行输出，看不到分支间建立跟踪的提示。

  ::

    $ git checkout -b hello-jx hello-1.x
    Switched to a new branch 'hello-jx'

* 将\ ``hello-jx``\ 分支重置。

  ::

    $ git reset --hard HEAD^^
    HEAD is now at ebcf6d6 blank commit for GnuPG-signed tag test.

* 检查状态看不到分支间的跟踪信息。

  ::

    $ git status
    # On branch hello-jx
    nothing to commit (working directory clean)

* 执行\ :command:`git pull`\ 命令会报错。

  ::

    $ git pull
    You asked me to pull without telling me which branch you
    want to merge with, and 'branch.hello-jx.merge' in
    your configuration file does not tell me, either. Please
    specify which branch you want to use on the command line and
    try again (e.g. 'git pull <repository> <refspec>').
    See git-pull(1) for details.

    If you often merge with the same branch, you may want to
    use something like the following in your configuration file:

        [branch "hello-jx"]
        remote = <nickname>
        merge = <remote-ref>

        [remote "<nickname>"]
        url = <url>
        fetch = <refspec>

    See git-config(1) for details.

* 将上面命令执行中的错误信息翻译过来，就是：

  ::

    $ git pull
    您让我执行拉回操作，但是没有告诉我您希望与哪个远程分支进行合并，
    而且也没有通过配置 'branch.hello-jx.merge' 来告诉我。

    请在命令行提供足够的参数，如 'git pull <repository> <refspec>' 。
    或者如果您经常与同一个分支进行合并，可以和该分支建立跟踪。在配置
    中添加如下配置信息：

        [branch "hello-jx"]
        remote = <nickname>
        merge = <remote-ref>

        [remote "<nickname>"]
        url = <url>
        fetch = <refspec>

为什么用同样方法建立的分支\ ``hello-1.x``\ 和\ ``hello-jx``\ ，差距咋就\
那么大呢？奥秘就在于从远程分支创建本地分支，自动建立了分支间的跟踪，而从\
一个本地分支创建另外一个本地分支则没有。看看配置文件\ :file:`.git/config`\
中是不是专门为分支\ ``hello-1.x``\ 创建了相应的配置信息？

::

   9 [branch "master"]
  10   remote = origin
  11   merge = refs/heads/master
  12 [branch "hello-1.x"]
  13   remote = origin
  14   merge = refs/heads/hello-1.x

其中第9-11行是针对\ ``master``\ 分支设置的分支间跟踪，是在版本库克隆的时\
候自动建立的。而第12-14行是前面基于远程分支创建本地分支时建立的。至于分支\
``hello-jx``\ 则没有建立相关配置。

如果希望在基于一个本地分支创建另外一个本地分支时也能够使用分支间的跟踪功\
能，就要在创建分支时提供\ ``--track``\ 参数。下面实践一下。

* 删除之前创建的\ ``hello-jx``\ 分支。

  ::

    $ git checkout master
    Switched to branch 'master'
    $ git branch -d hello-jx
    Deleted branch hello-jx (was ebcf6d6).
  
* 使用参数\ ``--track``\ 重新基于\ ``hello-1.x``\ 创建\ ``hello-jx``\ 分支。


  ::

    $ git checkout --track -b hello-jx hello-1.x
    Branch hello-jx set up to track local branch hello-1.x.
    Switched to a new branch 'hello-jx'

* 从Git库的配置文件中会看到为\ ``hello-jx``\ 分支设置的跟踪。

  因为跟踪的是本版本库的本地分支，所以第16行设置的远程版本库的名字为一个点。

  ::

    15 [branch "hello-jx"]
    16   remote = .
    17   merge = refs/heads/hello-1.x

远程版本库
==============

名为\ ``origin``\ 的远程版本库是在版本库克隆时注册的，那么如何注册新的远\
程版本库呢？下面将版本库\ ``file:///path/to/repos/hello-user1.git``\ 以\
``new-remote``\ 为名进行注册。

::

  $ git remote add new-remote file:///path/to/repos/hello-user1.git

如果再打开版本库的配置文件\ :file:`.git/config`\ 会看到新的配置。

::

  12 [remote "new-remote"]
  13   url = file:///path/to/repos/hello-user1.git
  14   fetch = +refs/heads/*:refs/remotes/new-remote/*

执行\ :command:`git remote`\ 命令，可以更为方便地显示已经注册的远程版本库。

::

  $ git remote -v
  new-remote      file:///path/to/repos/hello-user1.git (fetch)
  new-remote      file:///path/to/repos/hello-user1.git (push)
  origin  file:///path/to/repos/hello-world.git (fetch)
  origin  file:///path/to/repos/hello-world.git (push)

现在执行\ :command:`git fetch`\ 并不会从新注册的 new-remote 远程版本库获\
取，因为当前分支设置的默认远程版本库为 origin。要想从 new-remote 远程版\
本库中获取，需要为\ :command:`git fetch`\ 命令增加一个参数\ ``new-remote``\ 。

::

  $ git fetch new-remote
  From file:///path/to/repos/hello-user1
   * [new branch]      hello-1.x  -> new-remote/hello-1.x
   * [new branch]      helper/master -> new-remote/helper/master
   * [new branch]      helper/v1.x -> new-remote/helper/v1.x
   * [new branch]      master     -> new-remote/master

从上面的命令输出中可以看出，远程版本库的分支复制到本地版本库前缀为\
``new-remote``\ 的远程分支中去了。用\ :command:`git branch -r`\
命令可以看到新增了几个远程分支。

::

  $ git branch -r
    new-remote/hello-1.x
    new-remote/helper/master
    new-remote/helper/v1.x
    new-remote/master
    origin/HEAD -> origin/master
    origin/hello-1.x
    origin/helper/master
    origin/helper/v1.x
    origin/master

**更改远程版本库的地址**

如果远程版本库的URL地址改变，需要更换，该如何处理呢？手工修改\
:file:`.git/config`\ 文件是一种方法，用\ :command:`git config`\
命令进行更改是第二种方法，还有一种方法是用\ :command:`git remote`\
命令，如下：

::

  $ git remote set-url new-remote file:///path/to/repos/hello-user2.git

可以看到注册的远程版本库的URL地址已经更改。

::

  $ git remote -v
  new-remote      file:///path/to/repos/hello-user2.git (fetch)
  new-remote      file:///path/to/repos/hello-user2.git (push)
  origin  file:///path/to/repos/hello-world.git (fetch)
  origin  file:///path/to/repos/hello-world.git (push)

从上面的输出中可以发现每一个远程版本库都有两个URL地址，分别是执行\
:command:`git fetch`\ 和\ :command:`git push`\ 命令时用到的URL地址。\
既然有两个地址，就意味着这两个地址可以不同，用下面的命令可以为推送操作\
设置单独的URL地址。

::

  $ git remote set-url --push new-remote /path/to/repos/hello-user2.git
  $ git remote -v
  new-remote      file:///path/to/repos/hello-user2.git (fetch)
  new-remote      /path/to/repos/hello-user2.git (push)
  origin  file:///path/to/repos/hello-world.git (fetch)
  origin  file:///path/to/repos/hello-world.git (push)

当单独为推送设置了URL后，配置文件\ :file:`.git/config`\ 的对应\ ``[remote]``\
小节也会增加一条新的名为\ ``pushurl``\ 的配置。如下：

::

  12 [remote "new-remote"]
  13   url = file:///path/to/repos/hello-user2.git
  14   fetch = +refs/heads/*:refs/remotes/new-remote/*
  15   pushurl = /path/to/repos/hello-user2.git

**更改远程版本库的名称**

如果对远程版本库的注册名称不满意，也可以进行修改。例如将new-remote名称修\
改为user2，使用下面的命令：

::

  $ git remote rename new-remote user2

完成改名后，不但远程版本库的注册名称更改过来了，就连远程分支名称都会自动\
进行相应的更改。可以通过执行\ :command:`git remote`\ 和\
:command:`git branch -r`\ 命令查看。

::

  $ git remote
  origin
  user2
  $ git branch -r
    origin/HEAD -> origin/master
    origin/hello-1.x
    origin/helper/master
    origin/helper/v1.x
    origin/master
    user2/hello-1.x
    user2/helper/master
    user2/helper/v1.x
    user2/master

**远程版本库更新**

当注册了多个远程版本库并希望获取所有远程版本库的更新时，Git提供了一个简\
单的命令。

::

  $ git remote update
  Fetching origin
  Fetching user2

如果某个远程版本库不想在执行\ :command:`git remote update`\ 时获得更新，\
可以通过参数关闭自动更新。例如下面的命令关闭远程版本库user2的自动更新。

::

  $ git config remote.user2.skipDefaultUpdate true 
  $ git remote update
  Fetching origin

**删除远程版本库**

如果想要删除注册的远程版本库，用\ :command:`git remote`\ 的\
:command:`rm`\ 子命令可以实现。例如删除注册的user2版本库。

::

  $ git remote rm user2

PUSH和PULL操作与远程版本库
===============================

在Git分支一章，已经介绍过对于新建立的本地分支（没有建立和远程分支的追踪），\
执行\ :command:`git push`\ 命令是不会被推送到远程版本库中，这样的设置是\
非常安全的，避免了因为误操作将本地分支创建到远程版本库中。当不带任何参数\
执行\ :command:`git push`\ 命令，实际的执行过程是：

* 如果为当前分支设置了\ ``<remote>``\ ，即由配置\ ``branch.<branchname>.remote``\
  给出了远程版本库代号，则不带参数执行\ :command:`git push`\ 相当于执行了\
  :command:`git push <remote>`\ 。

* 如果没有为当前分支设置\ ``<remote>``\ ，则不带参数执行\ :command:`git push`\
  相当于执行了\ :command:`git push origin`\ 。

* 要推送的远程版本库的URL地址由\ ``remote.<remote>.pushurl``\ 给出。如果\
  没有配置，则使用\ ``remote.<remote>.url``\ 配置的URL地址。

* 如果为注册的远程版本库设置了\ ``push``\ 参数，即通过\ ``remote.<remote>.push``\
  配置了一个引用表达式，则使用该引用表达式执行推送。

* 否则使用“:”作为引用表达式。该表达式的含义是同名分支推送，即对所有在远程\
  版本库有同名分支的本地分支执行推送。
  
  这也就是为什么在一个本地新建分支中执行\ :command:`git push`\ 推送操作\
  不会推送也不会报错的原因，因为远程不存在同名分支，所以根本就没有对该分支\
  执行推送，而推送的是其他分支（如果远程版本库有同名分支的话）。

在Git分支一章中就已经知道，如果需要在远程版本库中创建分支，则执行命令：\
:command:`git push <remote> <new_branch>`\ 。即通过将本地分支推送到远程\
版本库的方式在远程版本库中创建分支。但是在接下来的使用中会遇到麻烦：不能\
执行\ :command:`git pull`\ 操作（不带参数）将远程版本库中其他人推送的提\
交获取到本地。这是因为没有建立本地分支和远程分支的追踪，即没有设置\
``branch.<branchname>.remote``\ 的值和\ ``branch.<branchname>.merge``\
的值。

关于不带参数执行\ :command:`git pull`\ 命令解释如下：

* 如果为当前分支设置了\ ``<remote>``\ ，即由配置\ ``branch.<branchname>.remote``\
  给出了远程版本库代号，则不带参数执行\ :command:`git pull`\ 相当于执行了\
  :command:`git pull <remote>`\ 。

* 如果没有为当前分支设置\ ``<remote>``\ ，则不带参数执行\ :command:`git pull`\
  相当于执行了\ :command:`git pull origin`\ 。

* 要获取的远程版本库的URL地址由\ ``remote.<remote>.url``\ 给出。

* 如果为注册的远程版本库设置了\ ``fetch``\ 参数，即通过\ ``remote.<remote>.fetch``\
  配置了一个引用表达式，则使用该引用表达式执行获取操作。

* 接下来要确定合并的分支。如果设定了\ ``branch.<branchname>.merge``\ ，\
  则对其设定的分支执行合并，否则报错退出。

在执行\ :command:`git pull`\ 操作的时候可以通过参数\ ``--rebase``\ 设置\
使用变基而非合并操作，将本地分支的改动变基到跟踪分支上。为了避免因为忘记\
使用\ ``--rebase``\ 参数导致分支的合并，可以执行如下命令进行设置。注意将\
``<branchname>``\ 替换为对应的分支名称。

::

  $ git config branch.<branchname>.rebase true

有了这个设置之后，如果是在\ ``<branchname>``\ 工作分支中执行\
:command:`git pull`\ 命令，在遇到冲突（本地和远程分支出现偏离）的情况下，\
会采用变基操作，而不是默认的合并操作。

如果为本地版本库设置参数\ ``branch.autosetuprebase``\ ，值为\ ``true``\ ，\
则在基于远程分支建立本地追踪分支时，会自动配置\ ``branch.<branchname>.rebase``\
参数，在执行\ :command:`git pull`\ 命令时使用变基操作取代默认的合并操作。

里程碑和远程版本库
====================

远程版本库中的里程碑同步到本地版本库，会使用同样的名称，而不会像分支那样\
移动到另外的命名空间（远程分支）中，这可能会给本地版本库中的里程碑带来混\
乱。当和多个远程版本库交互时，这个问题就更为严重。

前面的Git里程碑一章已经介绍了当执行\ :command:`git push`\ 命令推送时，默\
认不会将本地创建的里程碑带入远程版本库，这样可以避免远程版本库上里程碑的\
泛滥。但是执行\ :command:`git fetch`\ 命令从远程版本库获取分支的最新提交\
时，如果获取的提交上建有里程碑，这些里程碑会被获取到本地版本库。当删除注\
册的远程版本库时，远程分支会被删除，但是该远程版本库引入的里程碑不会被删\
除，日积月累本地版本库中的里程碑可能会变得愈加混乱。

可以在执行\ :command:`git fetch`\ 命令的时候，设置不获取里程碑只获取分支\
及提交。通过提供\ ``-n``\ 或\ ``--no-tags``\ 参数可以实现。示例如下：

::

  $ git fetch --no-tags file:///path/to/repos/hello-world.git \
        refs/heads/*:refs/remotes/hello-world/*

在注册远程版本库的时候，也可以使用\ ``--no-tags``\ 参数，避免将远程版本\
库的里程碑引入本地版本库。例如：

::

  $ git remote add --no-tags hell-world \
        file:///path/to/repos/hello-world.git


分支和里程碑的安全性
====================

通过前面章节的探讨，会感觉到Git的使用真的是太方便、太灵活了，但是需要掌\
握的知识点和窍门也太多了。为了避免没有经验的用户在团队共享的Git版本库中\
误操作，就需要对版本库进行一些安全上的设置。本书第5篇Git服务器搭建的相关\
章节会具体介绍如何配置用户授权等版本库安全性设置。

实际上Git版本库本身也提供了一些安全机制避免对版本库的破坏。

* 用reflog记录对分支的操作历史。

  默认创建的带工作区的版本库都会包含\ ``core.logallrefupdates``\ 为\
  ``true``\ 的配置，这样在版本库中建立的每个分支都会创建对应的 reflog。\
  但是创建的裸版本库默认不包含这个设置，也就不会为每个分支设置 reflog。\
  如果团队的规模较小，可能因为分支误操作导致数据丢失，可以考虑为裸版本库添加\
  ``core.logallrefupdates``\ 的相关配置。

* 关闭非快进式提交。

  如果将配置\ ``receive.denyNonFastForwards``\ 设置为\ ``true``\ ，则\
  禁止一切非快进式推送。但这个配置有些矫枉过正，更好的方法是搭建基于SSH协议\
  的Git服务器，通过钩子脚本更灵活的进行配置。例如：允许来自某些用户的强制\
  提交，而其他用户不能执行非快进式推送。

* 关闭分支删除功能。

  如果将配置\ ``receive.denyDeletes``\ 设置为\ ``true``\ ，则禁止删除分支。\
  同样更好的方法是通过架设基于SSH协议的Git服务器，配置分支删除的用户权限。
