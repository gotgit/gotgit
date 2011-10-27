Git 和 SVN 协同模型
*******************

在本篇的最后，将会在另外的一个角度上看 Git 版本库的协同。不是不同的用户在使用 Git 版本库时如何协同，也不是一个项目包含多个 Git 版本库时如何协同，而是当版本控制系统不是 Git （如 Subversion）时，如何能够继续使用 Git 的方式进行操作。

Subversion 会在商业软件开发中占有一席之地，只要商业软件公司严格封闭源代码的策略不改变。对于熟悉了 Git 的用户，一定会对 Subversion 的那种一旦脱离网络、脱离服务器便寸步难行的工作模式厌烦透顶。实际上对 Subversion 的集中式版本控制的不满和改进在 Git 诞生之前就发生了，这就是 SVK。

在 2003 年（Git 诞生的前两年），台湾的高嘉良就开发了 SVK，用分布式版本控制的方法操作 SVN。其设计思想非常朴素，既然 SVN 的用户可以看到有访问权限数据的全部历史，那么也应该能够依据历史重建一个本地的 SVN 版本库，这样很多 SVN 操作都可以通过本地的 SVN 进行，从而脱离网络。当对本地版本库的修改感到满意后，通过本地SVN版本和服务器SVN版本库之间的双向同步，将改动归并到服务器上。这种工作方式真的非常酷。

不必为 SVK 的文档缺乏以及不再维护而感到惋惜，因为有更强的工具登场了，这就是 git-svn。git-svn 是 Git 软件包的一部分，用 Perl 语言开发。它的工作原理是：

* 将 Subversion 版本库在本地转换为一个 Git 库。
* 转换可以基于 Subversion 的某个目录，或者基于某个分支，或者整个 Subversion 代码库的所有分支和里程碑。
* 远程的 Subversion 版本库可以和本地的 Git 双向同步。Git 本地库修改推送到远程 Subversion 版本库，反之亦然。

git-svn 作为 Git 软件包的一部分，当 Git 从源码包进行安装时会默认安装，提供 `git svn` 命令。而几乎所有的 Linux 发行版都将 git-svn 作为一个独立的软件单独发布，因此需要单独安装。例如 Debian 和 Ubuntu 运行下面命令安装 git-svn 。

::

  $ sudo aptitude install git-svn

将 git-svn 独立安装是因为 git-svn 软件包有着特殊的依赖，即依赖 Subversion 的 perl 语言绑定接口，Debian/Ubuntu 上由 libsvn-perl 软件包提供。

当 git-svn 正确安装后，就可以使用 `git svn` 命令了。但如果在执行 `git svn --version` 时遇到下面的错误，则说明 Subversion 的 perl 语言绑定没有正确安装。

::

  $ git svn --version
  Can't locate loadable object for module SVN::_Core in @INC (@INC contains: /usr/share/perl/5.10.1 /etc/perl /usr/local/lib/perl/5.10.1 /usr/local/share/perl/5.10.1 /usr/lib/perl5 /usr/share/perl5 /usr/lib/perl/5.10 /usr/share/perl/5.10 /usr/local/lib/site_perl /usr/local/lib/perl/5.10.0 /usr/local/share/perl/5.10.0 .) at /usr/lib/perl5/SVN/Base.pm line 59
  BEGIN failed--compilation aborted at /usr/lib/perl5/SVN/Core.pm line 5.
  Compilation failed in require at /usr/lib/git-core/git-svn line 41.

遇到上面的情况，需要检查本机是否正确安装了 Subversion 以及 Subversion 的 perl 语言绑定。

为了便于对 git-svn 的介绍和演示，需要有一个 Subversion 版本库，并且需要有提交权限以便演示用 Git 向 Subversion 进行提交。最好的办法是在本地创建一个 Subversion 版本库。

::

  $ svnadmin create /path/to/svn/repos/demo

  $ svn co file:///path/to/svn/repos/demo svndemo
  取出版本 0
  
  $ cd svndemo
  
  $ mkdir trunk tags branches
  $ svn add *
  A         branches
  A         tags
  A         trunk

  $ svn ci -m "initialized."
  增加           branches
  增加           tags
  增加           trunk
  
  提交后的版本为 1。

再向 Subversion 开发主线 trunk 中添加些数据。

::

  $ echo hello > trunk/README
  $ svn add trunk/README
  A         trunk/README
  $ svn ci -m "hello"
  增加           trunk/README
  传输文件数据.
  提交后的版本为 2。

建立分支：

::

  $ svn up
  $ svn cp trunk branches/demo-1.0
  A         branches/demo-1.0
  $ svn ci -m "new branch: demo-1.0"
  增加           branches/demo-1.0

  提交后的版本为 3。

建立里程碑：

::

  $ svn cp -m "new tag: v1.0" trunk file:///path/to/svn/repos/demo/tags/v1.0 

  提交后的版本为 4。


使用 git-svn 的一般流程
========================

使用 git-svn 的一般流程参见图26-1。

.. figure:: /images/git-model/git-svn-workflow.png
   :scale: 80

   图26-1：git-svn工作流

首先用 git svn clone 命令对 Subversion 进行克隆，创建一个包含 git-svn 扩展的本地 Git 库。在下面的示例中，使用 Subversion 的本地协议(file://) 来访问之前创立的 Subversion 示例版本库，实际上 git-svn 可以使用任何 Subversion 可用的协议，并可以对远程版本库进行操作。

::

  $ git svn clone -s file:///path/to/svn/repos/demo git-svn-demo
  Initialized empty Git repository in /path/to/my/workspace/git-svn-demo/.git/
  r1 = 2c73d657dfc3a1ceca9d465b0b98f9e123b92bb4 (refs/remotes/trunk)
          A       README
  r2 = 1863f91b45def159a3ed2c4c4c9428c25213f956 (refs/remotes/trunk)
  Found possible branch point: file:///path/to/svn/repos/demo/trunk => file:///path/to/svn/repos/demo/branches/demo-1.0, 2
  Found branch parent: (refs/remotes/demo-1.0) 1863f91b45def159a3ed2c4c4c9428c25213f956
  Following parent with do_switch
  Successfully followed parent
  r3 = 1adcd5526976fe2a796d932ff92d6c41b7eedcc4 (refs/remotes/demo-1.0)
  Found possible branch point: file:///path/to/svn/repos/demo/trunk => file:///path/to/svn/repos/demo/tags/v1.0, 2
  Found branch parent: (refs/remotes/tags/v1.0) 1863f91b45def159a3ed2c4c4c9428c25213f956
  Following parent with do_switch
  Successfully followed parent
  r4 = c12aa40c494b495a846e73ab5a3c787ca1ad81e9 (refs/remotes/tags/v1.0)
  Checked out HEAD:
    file:///path/to/svn/repos/demo/trunk r2

从上面的输出可以看出，当执行了 git svn clone 之后，在本地工作目录创建了一个 Git 库 (git-svn-demo)，并将 Subversion 的每一个提交都转换为 Git 库中的提交。进入 git-svn-demo 目录，看看用 git-svn 克隆出来的版本库。

::

  $ cd git-svn-demo/
  $ git branch -a
  * master
    remotes/demo-1.0
    remotes/tags/v1.0
    remotes/trunk
  $ git log
  commit 1863f91b45def159a3ed2c4c4c9428c25213f956
  Author: jiangxin <jiangxin@f79726c4-f016-41bd-acd5-6c9acb7664b2>
  Date:   Mon Nov 1 05:49:41 2010 +0000
  
      hello
      
      git-svn-id: file:///path/to/svn/repos/demo/trunk@2 f79726c4-f016-41bd-acd5-6c9acb7664b2
  
  commit 2c73d657dfc3a1ceca9d465b0b98f9e123b92bb4
  Author: jiangxin <jiangxin@f79726c4-f016-41bd-acd5-6c9acb7664b2>
  Date:   Mon Nov 1 05:47:03 2010 +0000
  
      initialized.
      
      git-svn-id: file:///path/to/svn/repos/demo/trunk@1 f79726c4-f016-41bd-acd5-6c9acb7664b2

看到 Subversion 版本库的分支和里程碑都被克隆出来，并保存在 refs/remotes 下的引用中。在 `git log` 的输出中，可以看到 Subversion 的提交的确被转换为 Git 的提交。

下面就可以在 Git 库中进行修改，并在本地提交（用 git commit 命令）。

::

  $ cat README 
  hello
  $ echo "I am fine." >> README 
  $ git add -u
  $ git commit -m "my hack 1."
  [master 55e5fd7] my hack 1.
   1 files changed, 1 insertions(+), 0 deletions(-)
  $ echo "Thank you." >> README 
  $ git add -u
  $ git commit -m "my hack 2."
  [master f1e00b5] my hack 2.
   1 files changed, 1 insertions(+), 0 deletions(-)

对工作区中的 README 文件修改了两次，并进行了本地的提交。查看这时的提交日志，会发现最新两个只在本地 Subversion 版本库的提交和之前 Subversion 中的提交的不同。区别在于最新在 Git 中的提交没有用 `git-svn-id:` 标签标记的行。

::

  $ git log
  commit f1e00b52209f6522dd8135d27e86370de552a7b6
  Author: Jiang Xin <jiangxin@ossxp.com>
  Date:   Thu Nov 4 15:05:47 2010 +0800
  
      my hack 2.
  
  commit 55e5fd794e6208703aa999004ec2e422b3673ade
  Author: Jiang Xin <jiangxin@ossxp.com>
  Date:   Thu Nov 4 15:05:32 2010 +0800
  
      my hack 1.
  
  commit 1863f91b45def159a3ed2c4c4c9428c25213f956
  Author: jiangxin <jiangxin@f79726c4-f016-41bd-acd5-6c9acb7664b2>
  Date:   Mon Nov 1 05:49:41 2010 +0000
  
      hello
  
      git-svn-id: file:///path/to/svn/repos/demo/trunk@2 f79726c4-f016-41bd-acd5-6c9acb7664b2
  
  commit 2c73d657dfc3a1ceca9d465b0b98f9e123b92bb4
  Author: jiangxin <jiangxin@f79726c4-f016-41bd-acd5-6c9acb7664b2>
  Date:   Mon Nov 1 05:47:03 2010 +0000
  
      initialized.
  
      git-svn-id: file:///path/to/svn/repos/demo/trunk@1 f79726c4-f016-41bd-acd5-6c9acb7664b2

现在就可以向 Subversion 服务器推送改动了。但真实的环境中，往往在向服务器推送时，已经有其他用户已经在服务器上进行了提交，而且往往更糟的是，先于我们的提交会造成我们的提交冲突！现在就人为的制造一个冲突：使用 svn 命令在 Subversion 版本库中执行一次提交。

::

  $ svn checkout file:///path/to/svn/repos/demo/trunk demo
  A    demo/README
  取出版本 4。
  $ cd demo/
  $ cat README
  hello
  $ echo "HELLO." > README
  $ svn commit -m "hello -> HELLO."
  正在发送       README
  传输文件数据.
  提交后的版本为 5。

好的，已经模拟了一个用户先于我们更改了 Subversion 版本库。现在回到用 git-svn 克隆的本地版本库，执行 `git svn dcommit` 操作，将 Git 中的提交推送的 Subversion 版本库中。

::

  $ git svn dcommit
  Committing to file:///path/to/svn/repos/demo/trunk ...
  事务过时: 文件 “/trunk/README” 已经过时 at /usr/lib/git-core/git-svn line 572

显然，由于 Subversion 版本库中包含了新的提交，导致执行 `git svn dcommit` 出错。这时需执行 `git svn fetch` 命令，以从 Subversion 版本库获取更新。

::

  $ git svn fetch
          M       README
  r5 = fae6dab863ed2152f71bcb2348d476d47194fdd4 (refs/remotes/trunk)
  $ git st
  # On branch master
  nothing to commit (working directory clean)

当获取了新的 Subversion 提交之后，需要执行 `git svn rebase` 将 Git 中未推送到 Subversion 的提交通过变基（rebase）形成包含 Subversion 最新提交的线性提交。这是因为 Subversion 的提交都是线性的。

::

  $ git svn rebase
  First, rewinding head to replay your work on top of it...
  Applying: my hack 1.
  Using index info to reconstruct a base tree...
  Falling back to patching base and 3-way merge...
  Auto-merging README
  CONFLICT (content): Merge conflict in README
  Failed to merge in the changes.
  Patch failed at 0001 my hack 1.
  
  When you have resolved this problem run "git rebase --continue".
  If you would prefer to skip this patch, instead run "git rebase --skip".
  To restore the original branch and stop rebasing run "git rebase --abort".
  
  rebase refs/remotes/trunk: command returned error: 1

果不其然，变基时发生了冲突，这是因为 Subversion 中他人的修改和我们在 Git 库中的修改都改动了同一个文件，并且改动了相近的行。下面按照 `git rebase` 冲突解决的一般步骤进行，直到成功完成变基操作。

先编辑 README 文件，以解决冲突。

::

  $ git status
  # Not currently on any branch.
  # Unmerged paths:
  #   (use "git reset HEAD <file>..." to unstage)
  #   (use "git add/rm <file>..." as appropriate to mark resolution)
  #
  #       both modified:      README
  #
  no changes added to commit (use "git add" and/or "git commit -a")

  $ vi README 

处于冲突状态的 REAEME 文件内容。

::

  <<<<<<< HEAD
  HELLO.
  =======
  hello
  I am fine.
  >>>>>>> my hack 1.

下面是修改后的内容。保存退出。

::

  HELLO.
  I am fine.

执行 git add 命令解决冲突

::

  $ git add README

调用 `git rebase --continue` 完成变基操作。

::

  $ git rebase --continue
  Applying: my hack 1.
  Applying: my hack 2.
  Using index info to reconstruct a base tree...
  Falling back to patching base and 3-way merge...
  Auto-merging README

看看变基之后的 Git 库日志：

::

  $ git log 
  commit e382f2e99eca07bc3a92ece89f80a7a5457acfd8
  Author: Jiang Xin <jiangxin@ossxp.com>
  Date:   Thu Nov 4 15:05:47 2010 +0800
  
      my hack 2.
  
  commit 6e7e0c7dccf5a072404a28f06ce0c83d77988b0b
  Author: Jiang Xin <jiangxin@ossxp.com>
  Date:   Thu Nov 4 15:05:32 2010 +0800
  
      my hack 1.
  
  commit fae6dab863ed2152f71bcb2348d476d47194fdd4
  Author: jiangxin <jiangxin@f79726c4-f016-41bd-acd5-6c9acb7664b2>
  Date:   Thu Nov 4 07:15:58 2010 +0000
  
      hello -> HELLO.
      
      git-svn-id: file:///path/to/svn/repos/demo/trunk@5 f79726c4-f016-41bd-acd5-6c9acb7664b2
  
  commit 1863f91b45def159a3ed2c4c4c9428c25213f956
  Author: jiangxin <jiangxin@f79726c4-f016-41bd-acd5-6c9acb7664b2>
  Date:   Mon Nov 1 05:49:41 2010 +0000
  
      hello
      
      git-svn-id: file:///path/to/svn/repos/demo/trunk@2 f79726c4-f016-41bd-acd5-6c9acb7664b2
  
  commit 2c73d657dfc3a1ceca9d465b0b98f9e123b92bb4
  Author: jiangxin <jiangxin@f79726c4-f016-41bd-acd5-6c9acb7664b2>
  Date:   Mon Nov 1 05:47:03 2010 +0000
  
      initialized.
      
      git-svn-id: file:///path/to/svn/repos/demo/trunk@1 f79726c4-f016-41bd-acd5-6c9acb7664b2

当变基操作成功完成后，再执行 `git svn dcommit` 向 Subversion 推送 Git 库中的两个新提交。

::

  $ git svn dcommit
  Committing to file:///path/to/svn/repos/demo/trunk ...
          M       README
  Committed r6
          M       README
  r6 = d0eb86bdfad4720e0a24edc49ec2b52e50473e83 (refs/remotes/trunk)
  No changes between current HEAD and refs/remotes/trunk
  Resetting to the latest refs/remotes/trunk
  Unstaged changes after reset:
  M       README
          M       README
  Committed r7
          M       README
  r7 = 69f4aa56eb96230aedd7c643f65d03b618ccc9e5 (refs/remotes/trunk)
  No changes between current HEAD and refs/remotes/trunk
  Resetting to the latest refs/remotes/trunk

推送之后本地 Git 库中最新的两个提交的提交说明中也嵌入了 `git-svn-id:` 标签。这个标签的作用非常重要，在下一节会予以介绍。

::

  $ git log -2
  commit 69f4aa56eb96230aedd7c643f65d03b618ccc9e5
  Author: jiangxin <jiangxin@f79726c4-f016-41bd-acd5-6c9acb7664b2>
  Date:   Thu Nov 4 07:56:38 2010 +0000
  
      my hack 2.
      
      git-svn-id: file:///path/to/svn/repos/demo/trunk@7 f79726c4-f016-41bd-acd5-6c9acb7664b2
  
  commit d0eb86bdfad4720e0a24edc49ec2b52e50473e83
  Author: jiangxin <jiangxin@f79726c4-f016-41bd-acd5-6c9acb7664b2>
  Date:   Thu Nov 4 07:56:37 2010 +0000
  
      my hack 1.
      
      git-svn-id: file:///path/to/svn/repos/demo/trunk@6 f79726c4-f016-41bd-acd5-6c9acb7664b2

git-svn 的奥秘
==============

通过上面对 git-svn 的工作流程的介绍，相信读者已经能够体会到 git-svn 的强大。那么 git-svn 是怎么做到的呢？

git-svn 只是在本地 Git 库中增加了一些附加的设置，特殊的引用，和引入附加的可重建的数据库实现对 Subversion 版本库的跟踪。

Git 库配置文件的扩展及分支映射
------------------------------

当执行 `git svn init` 或者 `git svn clone` 时，git-svn 会通过在 Git 库的配置文件中增加一个小节，记录 Subversion 版本库的URL，以及 Subversion 分支/里程碑和本地 Git 库的引用之间的对应关系。

例如：当执行 `git svn clone -s file:///path/to/svn/repos/demo` 指令时，会在创建的本地 Git 库的配置文件 `.git/config` 中引入下面新的配置：

::

  [svn-remote "svn"]
          url = file:///path/to/svn/repos/demo
          fetch = trunk:refs/remotes/trunk
          branches = branches/*:refs/remotes/*
          tags = tags/*:refs/remotes/tags/*

缺省 svn-remote 的名字为 "svn"，所以新增的配置小节的名字为： `[svn-remote "svn"]` 。在 git-svn 克隆时，可以使用 `--remote` 参数设置不同的 svn-remote 名称，但是并不建议使用。因为一旦使用 `--remote` 参数更改 svn-remote 名称，必须在 git-svn 的其他命令中都使用 --remote 参数，否则报告 `[svn-remote "svn"]` 配置小节未找到。

在该小节中主要的配置有：

* url = <URL>

  设置 Subversion 版本库的地址

* fetch = <svn-path>:<git-refspec>

  Subversion 的开发主线和 Git 版本库引用的对应关系。

  在上例中 Subversion 的 trunk 目录对应于 Git 的 refs/remotes/trunk 引用。

* branches = <svn-path>:<git-refspec>

  Subversion 的开发分支和 Git 版本库引用的对应关系。可以包含多条 branches 的设置，以便将分散在不同目录下的分支汇总。

  在上例中 Subversion 的 branches 子目录下一级子目录（branches/\*）所代表的分支在 Git 的 refs/remotes/ 下建立引用。

* tags = <svn-path>:<git-refspec>

  Subversion 的里程碑和 Git 版本库引用的对应关系。可以包含多条 tags 的设置，以便将分散在不同目录下的里程碑汇总。

  在上例中 Subversion 的 tags 子目录下一级子目录（tags/\*）所代表的里程碑在 Git 的 refs/remotes/tags 下建立引用。

可以看到 Subversion 的主线和分支缺省都直接被映射到 `refs/remotes/` 下。如 trunk 主线对应于 `refs/remotes/trunk` ，分支 demo-1.0 对应于 `refs/remotes/demo-1.0` 。Subversion 的里程碑因为有可能和分支同名，因此被映射到 `refs/remotes/tags/` 之下，这样就里程碑和分支的映射放到不同目录下，不会互相影响。

Git 工作分支和 Subversion 如何对应？
------------------------------------

Git 缺省工作的分支是 master，而看到上例中的 Subversion 主线在 Git 中对应的远程分支为 `refs/remotes/trunk` 。那么在执行 `git svn rebase` 时，git-svn 是如何知道当前的 HEAD 对应的分支基于哪个 Subversion 跟踪分支进行变基？还有就是执行 `git svn dcommit` 时，当前的工作分支应该将改动推送到哪个 Subversion 分支中去呢？

很自然的会按照 Git 的方式进行思考，期望在 `.git/config` 配置文件中找到类似 `[branch master]` 之类的配置小节。实际上，在 git-svn 的 Git 库的配置文件中可能根本就不存在 `[branch ...]` 小节。那么 git-svn 是如何确定当前 Git 工作分支和远程 Subversion 版本库的分支建立对应的呢？

其实奥秘就在 Git 的日志中。当在工作区执行 `git log` 时，会看到包含 `git-svn-id:` 标识的特殊日志。发现的最近的一个 `git-svn-id:` 标识会确定当前分支提交的 Subversion 分支。

下面继续上一节的示例，先切换到分支，并将提交推送到 Subversion 的分支 demo-1.0 中。

首先在 Git 库中会看到有一个对应于 Subversion 分支的远程分支和一个对应于 Subversion 里程碑的远程引用。

::

  $ git branch -r
    demo-1.0
    tags/v1.0
    trunk

然后基于远程分支 `demo-1.0` 建立本地工作分支 `myhack` 。

::

  $ git checkout -b myhack refs/remotes/demo-1.0
  Switched to a new branch 'myhack'
  $ git branch
    master
  * myhack

在 `myhack` 分支做一些改动，并提交。

::

  $ echo "Git" >> README 
  $ git add -u
  $ git commit -m "say hello to Git."
  [myhack d391fd7] say hello to Git.
   1 files changed, 1 insertions(+), 0 deletions(-)

下面看看 Git 的提交日志。

::

  $ git log --first-parent
  commit d391fd75c33f62307c3add1498987fa3eb70238e
  Author: Jiang Xin <jiangxin@ossxp.com>
  Date:   Fri Nov 5 09:40:21 2010 +0800

      say hello to Git.

  commit 1adcd5526976fe2a796d932ff92d6c41b7eedcc4
  Author: jiangxin <jiangxin@f79726c4-f016-41bd-acd5-6c9acb7664b2>
  Date:   Mon Nov 1 05:54:19 2010 +0000

      new branch: demo-1.0
      
      git-svn-id: file:///path/to/svn/repos/demo/branches/demo-1.0@3 f79726c4-f016-41bd-acd5-6c9acb7664b2

  commit 1863f91b45def159a3ed2c4c4c9428c25213f956
  Author: jiangxin <jiangxin@f79726c4-f016-41bd-acd5-6c9acb7664b2>
  Date:   Mon Nov 1 05:49:41 2010 +0000

      hello
      
      git-svn-id: file:///path/to/svn/repos/demo/trunk@2 f79726c4-f016-41bd-acd5-6c9acb7664b2

  commit 2c73d657dfc3a1ceca9d465b0b98f9e123b92bb4
  Author: jiangxin <jiangxin@f79726c4-f016-41bd-acd5-6c9acb7664b2>
  Date:   Mon Nov 1 05:47:03 2010 +0000

      initialized.
      
      git-svn-id: file:///path/to/svn/repos/demo/trunk@1 f79726c4-f016-41bd-acd5-6c9acb7664b2


看到了上述 Git 日志中出现的第一个 `git-svn-id:` 标识的内容为：

::

  git-svn-id: file:///path/to/svn/repos/demo/branches/demo-1.0@3 f79726c4-f016-41bd-acd5-6c9acb7664b2

这就是说，当需要将 Git 提交推送给 Subversion 服务器时，需要推送到地址： `file:///path/to/svn/repos/demo/branches/demo-1.0` 。

执行 `git svn dcommit` ，果然是推送到 Subversion 的 demo-1.0 分支。

::

  $ git svn dcommit
  Committing to file:///path/to/svn/repos/demo/branches/demo-1.0 ...
          M       README
  Committed r8
          M       README
  r8 = a8b32d1b533d308bef59101c1f2c9a16baf91e48 (refs/remotes/demo-1.0)
  No changes between current HEAD and refs/remotes/demo-1.0
  Resetting to the latest refs/remotes/demo-1.0

其他辅助文件
-------------

在 Git 版本库中，git-svn 在 `.git/svn` 目录下保存了一些索引文件，便于 git-svn 更加快速的执行。

文件 `.git/svn/.metadata` 文件是类似于 `.git/config` 文件一样的 INI 文件，其中保存了版本库的 URL，版本库 UUID，分支和里程碑的最后获取的版本号等。

::

  ; This file is used internally by git-svn
  ; You should not have to edit it
  [svn-remote "svn"]
          reposRoot = file:///path/to/svn/repos/demo
          uuid = f79726c4-f016-41bd-acd5-6c9acb7664b2
          branches-maxRev = 8
          tags-maxRev = 8

在 `.git/svn/refs/remotes` 目录下以各个分支和里程碑为名的各个子目录下都包含一个 `.rev_map.<SVN-UUID>` 的索引文件，这个文件用于记录 Subversion 的提交 ID 和 Git 的提交 ID 的映射。

目录 `.git/svn` 的辅助文件由 git-svn 维护，不要手工修改否则会造成 git-svn 不能正常工作。
 
多样的 git-svn 克隆模式
========================

在前面的 git-svn 示例中，使用 `git svn clone` 命令完成对远程版本库的克隆，实际上 `git svn clone` 相当于两条命令，即：

::

  git svn clone = git svn init + git svn fetch

命令 `git svn init` 只完成两个工作。一个是在本地建立一个空的 Git 版本库，另外是修改 .git/config 文件，在其中建立 Subversion 和 Git 之间的分支映射关系。在实际使用中，我更喜欢使用 `git svn init` 命令，因为这样可以对 Subversion 和 Git 的分支映射进行手工修改。该命令的用法是：

::

  用法: git svn init [options] <subversion-url> [local-dir]
  
  可选的主要参数有：

      --stdlayout, -s 
      --trunk, -T <arg>
      --branches, --b=s@ 
      --tags, --t=s@ 
      --config-dir <arg>
      --ignore-paths <arg>
      --prefix <arg>
      --username <arg>

其中 `--username` 参数用于设定远程 Subversion 服务器认证时提供的用户名。参数 `--prefix` 用于设置在 Git 的 `refs/remotes` 下保存引用时使用的前缀。参数 `--ignore-paths` 后面跟一个正则表达式定义忽略的文件列表，这些文件将不予克隆。

最常用的参数是 `-s` 。该参数和前面演示的 `git clone` 命令中的一样，即使用标准的分支/里程碑部署方式克隆 Subversion 版本库。Subversion 约定俗成使用 trunk 目录跟踪主线的开发，使用 branches 目录保存各个分支，使用 tags 目录来记录里程碑。

即命令:

::

  $ git svn init -s file:///path/to/svn/repos/demo

和下面的命令等效：

::

  $ git svn init -T trunk -b branches -t tags file:///path/to/svn/repos/demo

有的 Subversion 版本库的分支可能分散于不同的目录下，例如有的位于 branches 目录，有的位于 sandbox 目录，则可以用下面命令：

::

  $ git svn init -T trunk -b branches -b sandbox -t tags file:///path/to/svn/repos/demo git-svn-test
  Initialized empty Git repository in /path/to/my/workspace/git-svn-test/.git/

查看本地克隆版本库的配置文件：

::

  $ cat git-svn-test/.git/config 
  [core]
          repositoryformatversion = 0
          filemode = true
          bare = false
          logallrefupdates = true
  [svn-remote "svn"]
          url = file:///path/to/svn/repos/demo
          fetch = trunk:refs/remotes/trunk
          branches = branches/*:refs/remotes/*
          branches = sandbox/*:refs/remotes/*
          tags = tags/*:refs/remotes/tags/*

可以看到在 `[svn-remote "svn"]` 小节中包含了两条 branches 配置，这就会实现将 Subversion 分散于不同目录的分支都克隆出来。如果担心 Subversion 的 branches 目录和 sandbox 目录下出现同名的分支导致在 Git 库的 `refs/remotes/` 下造成覆盖，可以在版本库尚未执行 `git svn fetch` 之前编辑 `.git/config` 文件，避免可能出现的覆盖。例如编辑后的 `[svn-remote "svn"]` 配置小节：

::

  [svn-remote "svn"]
          url = file:///path/to/svn/repos/demo
          fetch = trunk:refs/remotes/trunk
          branches = branches/*:refs/remotes/branches/*
          branches = sandbox/*:refs/remotes/sandbox/*
          tags = tags/*:refs/remotes/tags/*

如果项目的分支或里程碑非常多，也可以修改 `[svn-remote "svn"]` 配置小节中的版本号通配符，使得只获取部分分支或里程碑。例如下面的配置小节：

::

  [svn-remote "svn"]
          url = http://server.org/svn
          fetch = trunk/src:refs/remotes/trunk
          branches = branches/{red,green}/src:refs/remotes/branches/*
          tags = tags/{1.0,2.0}/src:refs/remotes/tags/*


如果只关心 Subversion 的某个分支甚至某个子目录，而不关心其他分支或目录，那就更简单了，不带参数的执行 `git svn init` 针对 Subversion 的某个具体路径执行初始化就可以了。

::

  $ git svn init file:///path/to/svn/repos/demo/trunk

有的情况下，版本库太大，而且对历史不感兴趣，可以只克隆最近的部分提交。这时可以通过 `git svn fetch` 命令的 `-r` 参数实现部分提交的克隆。

::

  $ git svn init file:///path/to/svn/repos/demo/trunk git-svn-test 
  Initialized empty Git repository in /path/to/my/workspace/git-svn-test/.git/
  $ cd git-svn-test
  $ git svn fetch -r 6:HEAD
          A       README
  r6 = 053b641b7edd2f1a59a007f27862d98fe5bcda57 (refs/remotes/git-svn)
          M       README
  r7 = 75c17ea61d8527334855a51e65ac98c981f545d7 (refs/remotes/git-svn)
  Checked out HEAD:
    file:///path/to/svn/repos/demo/trunk r7

当然也可以使用 `git svn clone` 命令实现部分克隆：

::

  $ git svn clone -r 6:HEAD \
        file:///path/to/svn/repos/demo/trunk git-svn-test 
  Initialized empty Git repository in /path/to/my/workspace/git-svn-test/.git/
          A       README
  r6 = 053b641b7edd2f1a59a007f27862d98fe5bcda57 (refs/remotes/git-svn)
          M       README
  r7 = 75c17ea61d8527334855a51e65ac98c981f545d7 (refs/remotes/git-svn)
  Checked out HEAD:
    file:///path/to/svn/repos/demo/trunk r7
  

共享 git-svn 的克隆库
=====================

当一个 Subversion 版本库非常庞大而且和不在同一个局域网内，执行 `git svn clone` 可能需要花费很多时间。为了避免因重复执行 `git svn clone` 导致时间上的浪费，可以将一个已经使用 git-svn 克隆出来的 Git 库共享，其他人基于此 Git 进行克隆，然后再用特殊的方法重建和 Subversion 的关联。还记得之前提到过，`.git/svn` 目录下的辅助文件可以重建么？

例如通过工作区中已经存在的 git-svn-demo 执行克隆。

::

  $ git clone git-svn-demo myclone
  Initialized empty Git repository in /path/to/my/workspace/myclone/.git/

进入新的克隆中，会发现新的克隆缺乏跟踪 Subversion 分支的引用，即 `refs/remotes/trunk` 等。

::

  $ cd myclone/
  $ git br -a
  * master
    remotes/origin/HEAD -> origin/master
    remotes/origin/master
    remotes/origin/myhack

这是因为 Git 克隆缺省不复制远程版本库的 `refs/remotes/` 下的引用。可以用 `git fetch` 命令获取 `refs/remotes` 的引用。

::

  $ git fetch origin refs/remotes/*:refs/remotes/*
  From /path/to/my/workspace/git-svn-demo
   * [new branch]      demo-1.0   -> demo-1.0
   * [new branch]      tags/v1.0  -> tags/v1.0
   * [new branch]      trunk      -> trunk

现在这个从 git-svn 库中克隆出来的版本库已经有了相同的 Subversion 跟踪分支，但是 `.git/config` 文件还缺乏相应的 `[svn-remote "svn"]` 配置。可以通过使用同样的 `git svn init` 命令实现。

::

  $ pwd
  /path/to/my/workspace/myclone

  $ git svn init -s file:///path/to/svn/repos/demo

  $ git config --get-regexp 'svn-remote.*'
  svn-remote.svn.url file:///path/to/svn/repos/demo
  svn-remote.svn.fetch trunk:refs/remotes/trunk
  svn-remote.svn.branches branches/*:refs/remotes/*
  svn-remote.svn.tags tags/*:refs/remotes/tags/*

但是克隆版本库相比用 git-svn 克隆的版本库还缺乏 `.git/svn` 下的辅助文件。实际上可以用 `git svn rebase` 命令重建，同时这条命令也可以变基到 Subversion 相应分支的最新提交上。

::

  $ git svn rebase 
  Rebuilding .git/svn/refs/remotes/trunk/.rev_map.f79726c4-f016-41bd-acd5-6c9acb7664b2 ...
  r1 = 2c73d657dfc3a1ceca9d465b0b98f9e123b92bb4
  r2 = 1863f91b45def159a3ed2c4c4c9428c25213f956
  r5 = fae6dab863ed2152f71bcb2348d476d47194fdd4
  r6 = d0eb86bdfad4720e0a24edc49ec2b52e50473e83
  r7 = 69f4aa56eb96230aedd7c643f65d03b618ccc9e5
  Done rebuilding .git/svn/refs/remotes/trunk/.rev_map.f79726c4-f016-41bd-acd5-6c9acb7664b2
  Current branch master is up to date.

如果执行 `git svn fetch` 则会对所有的分支都进行重建。

::

  $ git svn fetch
  Rebuilding .git/svn/refs/remotes/demo-1.0/.rev_map.f79726c4-f016-41bd-acd5-6c9acb7664b2 ...
  r3 = 1adcd5526976fe2a796d932ff92d6c41b7eedcc4
  r8 = a8b32d1b533d308bef59101c1f2c9a16baf91e48
  Done rebuilding .git/svn/refs/remotes/demo-1.0/.rev_map.f79726c4-f016-41bd-acd5-6c9acb7664b2
  Rebuilding .git/svn/refs/remotes/tags/v1.0/.rev_map.f79726c4-f016-41bd-acd5-6c9acb7664b2 ...
  r4 = c12aa40c494b495a846e73ab5a3c787ca1ad81e9
  Done rebuilding .git/svn/refs/remotes/tags/v1.0/.rev_map.f79726c4-f016-41bd-acd5-6c9acb7664b2

至此，从 git-svn 克隆库二次克隆的 Git 库，已经和原生的 git-svn 库一样使用 git-svn 命令了。

git-svn 的局限
==============

Subversion 和 Git 的分支实现有着巨大的不同。Subversion 的分支和里程碑，是用轻量级拷贝实现的，虽然创建分支和里程碑的速度也很快，但是很难维护。即使 Subversion 在 1.5 之后引入了 `svn:mergeinfo` 属性对合并过程进行标记，但是也不可能让 Subversion 的分支逻辑更清晰。git-svn 无须利用 svn:mergeinfo 属性也可实现对 Subversion 合并的追踪，在合并的时候也不会对 svn:mergeinfo 属性进行更改，因此在使用 git-svn 操作时，如果在不同分支间进行合并，会导致 Subversion 的 svn:mergeinfo 属性没有相应的更新，导致 Subversion 用户进行合并时因为重复合并导致冲突。

简而言之，在使用 git-svn 时尽量不要在不同的分支之间进行合并，而是尽量在一个分支下线性的提交。这种线性的提交会很好的推送到 Subversion 服务器中。

如果真的需要在不同的 Subversion 分支之间合并，尽量使用 Subversion 的客户端（svn 1.5 版本或以上）执行，因为这样可以正确的记录 svn:mergeinfo 属性。当 Subversion 完成分支合并后，在 git-svn 的克隆库中执行 `git svn rebase` 命令获取最新的 Subversion 提交并变基到相应的跟踪分支中。

