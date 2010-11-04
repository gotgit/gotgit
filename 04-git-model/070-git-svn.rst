Git 和 SVN 协同模型
===================

在Git 协同模型部分的最后，我们将会在另外的一个角度上看 Git 版本库的协同。不是不同的用户在使用 Git 版本库时如何协同，也不是一个项目包含多个 Git 版本库时如何协同，而是当版本控制系统不是 Git （如 Subversion）时，如何能够继续使用 Git 的方式进行操作。

Subversion 会一直在商业软件开发占据主导，只要商业软件公司封闭源代码的策略不改变。对于熟悉了 Git 的用户，一定会对 Subversion 的那种一旦脱离网络、脱离服务器便寸步难行的工作模式厌烦透顶。实际上对 Subversion 的集中式版本控制的不满和改进在 Git 诞生之前就发生了，这就是 SVK。

在 2003 年（Git 诞生的前两年），台湾的高嘉良就开发了 SVK，用分布式版本控制的方法操作 SVN。其设计思想非常朴素，既然 SVN 的用户可以看到有访问权限数据的全部历史，那么也应该能够依据历史重建一个本地的 SVN 版本库，这样很多 SVN 操作都可以通过本地的 SVN 进行从而脱离网络。当对本地版本库的修改感到满意后，通过本地SVN版本和服务器的SVN版本库的双向同步将改动归并到服务器上。这种工作方式真的非常酷。

我们不必为 SVK 的文档缺乏以及不再维护而感到惋惜，因为有更强的工具登场了，这就是 git-svn。Git-svn 是 Git 软件包的一部分，用 Perl 语言开发。它的工作原理是：

* 将 Subversion 版本库在本地转换为一个 Git 库。
* 转换可以基于 Subversion 的某个目录，或者基于某个分支，或者整个 Subversion 代码库的所有分支和里程碑。
* 远程的 Subversion 版本库可以和本地的 Git 双向同步。Git 本地库修改推送到远程 Subversion 版本库，反之亦然。

Git-svn 作为 Git 软件包的一部分，当 Git 从源码包进行安装时会默认安装，提供 `git svn` 命令。但一些 Linux 发行版 git-svn 作为一个独立的软件包，需要手动进行安装。例如 Debian 和 Ubuntu 运行下面命令安装 git-svn 。

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

为了便于对 git-svn 的介绍和演示，我们需要有一个 Subversion 版本库，并且需要有提交权限以便演示用 Git 向 Subversion 进行提交。最好的办法是在本地创建一个 Subversion 版本库。

::

  $ svnadmin create /path/to/svn/repos

  $ svn co file:///path/to/svn/repos svndemo
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

我们再向 Subversion 开发主线 trunk 中添加些数据。

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

  $ svn cp -m "new tag: v1.0" trunk file:///path/to/svn/repos/tags/v1.0 

  提交后的版本为 4。


使用 git-svn 的一般流程
------------------------

使用 git-svn 的一般流程为:

::

  git svn clone 
        |       
        v       
   (本地Git库) 
        |  
        v 
  +-> (hack...)
  |     |
  |     v
  |   git add
  |     |
  |     v
  |   git commit
  |     |
  +-----+
        |
        v
  git svn rebase
        |
        v
  git svn dcommit
      
首先用 git svn clone 命令对 Subversion 进行克隆，创建一个包含 git-svn 扩展的本地 Git 库。在下面的示例中，我们使用 Subversion 的本地协议(file://) 来访问之前创立的 Subversion 示例版本库，实际上 git-svn 可以使用任何 Subversion 可用的协议，并可以对远程版本库进行操作。

::

  $ git svn clone -s file:///path/to/svn/repos git-svn-demo
  Initialized empty Git repository in /my/workspace/git-svn-demo/.git/
  r1 = 2c73d657dfc3a1ceca9d465b0b98f9e123b92bb4 (refs/remotes/trunk)
          A       README
  r2 = 1863f91b45def159a3ed2c4c4c9428c25213f956 (refs/remotes/trunk)
  Found possible branch point: file:///path/to/svn/repos/trunk => file:///path/to/svn/repos/branches/demo-1.0, 2
  Found branch parent: (refs/remotes/demo-1.0) 1863f91b45def159a3ed2c4c4c9428c25213f956
  Following parent with do_switch
  Successfully followed parent
  r3 = 1adcd5526976fe2a796d932ff92d6c41b7eedcc4 (refs/remotes/demo-1.0)
  Found possible branch point: file:///path/to/svn/repos/trunk => file:///path/to/svn/repos/tags/v1.0, 2
  Found branch parent: (refs/remotes/tags/v1.0) 1863f91b45def159a3ed2c4c4c9428c25213f956
  Following parent with do_switch
  Successfully followed parent
  r4 = c12aa40c494b495a846e73ab5a3c787ca1ad81e9 (refs/remotes/tags/v1.0)
  Checked out HEAD:
    file:///path/to/svn/repos/trunk r2

从上面的输出我们看到，当执行了 git svn clone 之后，在本地工作目录创建了一个 Git 库 (git-svn-demo)，并将 Subversion 的每一个提交都转换为 Git 库中的提交。我们进入 git-svn-demo 目录，看看我们用 git-svn 克隆出来的版本库。

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
      
      git-svn-id: file:///path/to/svn/repos/trunk@2 f79726c4-f016-41bd-acd5-6c9acb7664b2
  
  commit 2c73d657dfc3a1ceca9d465b0b98f9e123b92bb4
  Author: jiangxin <jiangxin@f79726c4-f016-41bd-acd5-6c9acb7664b2>
  Date:   Mon Nov 1 05:47:03 2010 +0000
  
      initialized.
      
      git-svn-id: file:///path/to/svn/repos/trunk@1 f79726c4-f016-41bd-acd5-6c9acb7664b2

我们看到 Subversion 版本库的分支和里程碑都被克隆出来，并保存在 refs/remotes 下的引用中。在 `git log` 的输出中，我们可以看到 Subversion 的提交的确被转换为 Git 的提交。

下面我们就可以在 Git 库中进行修改，并在本地提交（用 git commit 命令）。

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

我们对工作区中的 README 文件修改了两次，并进行了本地的提交。我们查看这时的提交日志，会发现最新两个只在本地 Subversion 版本库的提交和之前 Subversion 中的提交的不同。区别在于最新在 Git 中的提交没有用 `git-svn-id:` 标签标记的行。

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
  
      git-svn-id: file:///path/to/svn/repos/trunk@2 f79726c4-f016-41bd-acd5-6c9acb7664b2
  
  commit 2c73d657dfc3a1ceca9d465b0b98f9e123b92bb4
  Author: jiangxin <jiangxin@f79726c4-f016-41bd-acd5-6c9acb7664b2>
  Date:   Mon Nov 1 05:47:03 2010 +0000
  
      initialized.
  
      git-svn-id: file:///path/to/svn/repos/trunk@1 f79726c4-f016-41bd-acd5-6c9acb7664b2

现在我们就可以向 Subversion 服务器推送我们的改动了。但真实的环境中，往往在我们向服务器推送时，已经有其它用户先于我们在服务器上进行了提交。而且往往更糟的是，先于我们的提交会造成我们的提交冲突！我们现在就人为的制造一个冲突：使用 svn 命令在 Subversion 版本库中执行一次提交。

::

  $ svn checkout file:///path/to/svn/repos/trunk demo
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

好的，我们已经模拟了一个用户先于我们更改了 Subversion 版本库。现在回到我们用 git-svn 克隆的本地版本库，执行 `git svn dcommit` 操作，将我们在 Git 中的提交推送的 Subversion 版本库中。

::

  $ git svn dcommit
  Committing to file:///path/to/svn/repos/trunk ...
  事务过时: 文件 “/trunk/README” 已经过时 at /usr/lib/git-core/git-svn line 572

显然，由于 Subversion 版本库中包含了新的提交，导致我们执行 `git svn dcommit` 出错。这时我们需执行 `git svn fetch` 命令，以从 Subversion 版本库获取更新。

::

  $ git svn fetch
          M       README
  r5 = fae6dab863ed2152f71bcb2348d476d47194fdd4 (refs/remotes/trunk)
  15:37:08 jiangxin@hp:/my/workspace/git-svn-demo$ git st
  # On branch master
  nothing to commit (working directory clean)

当我们获取了新的 Subversion 提交之后，我们需要执行 `git svn rebase` 将我们 Git 中未推送到 Subversion 的提交通过变基（rebase）形成包含 Subversion 最新提交的线性提交。这是因为 Subversion 的提交都是线性的。

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
  15:49:30 jiangxin@hp:/my/workspace/git-svn-demo$ vi README 

处于冲突状态的 REAEME 文件内容。

::

  <<<<<<< HEAD
  HELLO.
  =======
  hello
  I am fine.
  >>>>>>> my hack 1.

下面是我们修改后的内容。保存退出。

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
      
      git-svn-id: file:///path/to/svn/repos/trunk@5 f79726c4-f016-41bd-acd5-6c9acb7664b2
  
  commit 1863f91b45def159a3ed2c4c4c9428c25213f956
  Author: jiangxin <jiangxin@f79726c4-f016-41bd-acd5-6c9acb7664b2>
  Date:   Mon Nov 1 05:49:41 2010 +0000
  
      hello
      
      git-svn-id: file:///path/to/svn/repos/trunk@2 f79726c4-f016-41bd-acd5-6c9acb7664b2
  
  commit 2c73d657dfc3a1ceca9d465b0b98f9e123b92bb4
  Author: jiangxin <jiangxin@f79726c4-f016-41bd-acd5-6c9acb7664b2>
  Date:   Mon Nov 1 05:47:03 2010 +0000
  
      initialized.
      
      git-svn-id: file:///path/to/svn/repos/trunk@1 f79726c4-f016-41bd-acd5-6c9acb7664b2

当变基操作成功完成后，我们再执行 `git svn dcommit` 向 Subversion 推送我们在 Git 库中的两个新提交。

::

  $ git svn dcommit
  Committing to file:///path/to/svn/repos/trunk ...
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

推送之后本地 Git 库中最新的两个提交的提交说明中也嵌入了 `git-svn-id:` 标签。这个标签的作用非常重要，我们在下一节予以介绍。

::

  $ git log -2
  commit 69f4aa56eb96230aedd7c643f65d03b618ccc9e5
  Author: jiangxin <jiangxin@f79726c4-f016-41bd-acd5-6c9acb7664b2>
  Date:   Thu Nov 4 07:56:38 2010 +0000
  
      my hack 2.
      
      git-svn-id: file:///path/to/svn/repos/trunk@7 f79726c4-f016-41bd-acd5-6c9acb7664b2
  
  commit d0eb86bdfad4720e0a24edc49ec2b52e50473e83
  Author: jiangxin <jiangxin@f79726c4-f016-41bd-acd5-6c9acb7664b2>
  Date:   Thu Nov 4 07:56:37 2010 +0000
  
      my hack 1.
      
      git-svn-id: file:///path/to/svn/repos/trunk@6 f79726c4-f016-41bd-acd5-6c9acb7664b2
  
