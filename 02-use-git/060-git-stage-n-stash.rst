恢复进度
*********

在“实践二”的结尾，曾经以终结者（The Terminator）的口吻说：“我会再回来”，会继续对暂存区的探索。经过了前面三章对Git对象、重置命令、检出命令的探索，现在已经拥有了足够多的武器，是时候“回归”了。

实践六：继续暂存区未完成的实践
==============================

经过了前面的实践，现在试验版本库应该处于 master 分支上，看看是不是这样。

::

  $ git status -sb
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

还记得在“实践二”的结尾，是如何保存进度的么？翻回去看一下，用的是 `git stash` 命令。这个命令用于保存当前进度，也是恢复进度要用的命令。

查看保存的进度用命令 `git stash list` 。

::

  $ git stash list
  stash@{0}: WIP on master: e695606 which version checked in?

现在就来恢复进度。使用 `git stash pop` 从最近保存的进度进行恢复。

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

先不要管 `git stash pop` 命令的输出，后面会专题介绍 `git stash` 命令。通过查看工作区的状态，可以发现进度已经找回了。

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

此时再看Git状态输出，是否别有一番感觉呢？有了前面三章的基础，现在可以游刃有余的应对各种情况了。

* 以当前暂存区状态进行提交，即只提交 `a/b/c/hello.txt` ，不提交 `welcome.txt` 。

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

* 想将 `welcome.txt` 提交。

  再简单不过了。

  ::

    $ git add welcome.txt
    $ git status -s
    A  a/b/c/hello.txt
    M  welcome.txt

* 想将 a/b/c/hello.txt 撤出暂存区。

  也是用重置命令。

  ::

    $ git reset HEAD a/b/c
    $ git status -s
    M  welcome.txt
    ?? a/

* 想将剩下的文件（welcome.txt）从暂存区撤出，就是说不想提交任何东西了。

  还是使用重置命令，甚至可以不使用任何参数。

  ::

    $ git reset 
    Unstaged changes after reset:
    M       welcome.txt

* 想将本地工作区所有的修改清除。即清除 `welcome.txt` 的改动，删除添加的目录 `a` 即下面的子目录和文件。

  - 清除 `welcome.txt` 的改动用检出命令。

    实际对于此例执行 `git checkout .` 也可以。

    ::

      $ git checkout -- welcome.txt

  - 工作区显示还有一个多余的目录 `a` 。

    ::

      $ git status
      # On branch master
      # Untracked files:
      #   (use "git add <file>..." to include in what will be committed)
      #
      #       a/

  - 删除本地多余的目录和文件，可以使用 `git clean` 命令。先来测试运行以便看看哪些文件和目录会被删除，以免造成误删。

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

探秘 git stash
==============

看看 git stash 安装在哪里了。如果是高版本库的 Debian 或者 Ubuntu 可以使用下面的命令：

::

  $ dpkg -L git |grep "stash$"
  /usr/lib/git-core/git-stash

低版本的 Debian 或者 Ubuntu，Git 软件包为了避免和 GNUit 重名而使用 git-core 的软件包名称：

::

  $ dpkg -L git-core |grep "stash$"
  /usr/lib/git-core/git-stash

在 RedHat 或者类似系统，可以使用下面的命令从 git 安装文件列表中查找 git-stash 。

::

  $ rpm -ql git |grep "stash$"
  /usr/libexec/git-core/git-stash

如果查看一下这个保存 `git-stash` 文件的目录，会震惊的。

::

  $ ls /usr/lib/git-core/
  git                   git-clone             git-fsck               git-mailinfo         git-pack-redundant       git-remote-testgit  git-status
  git-add               git-commit            git-fsck-objects       git-mailsplit        git-pack-refs            git-repack          git-stripspace
  git-add--interactive  git-commit-tree       git-gc                 git-merge            git-parse-remote         git-replace         git-submodule
  git-am                git-config            git-get-tar-commit-id  git-merge-base       git-patch-id             git-repo-config     git-subtree
  git-annotate          git-count-objects     git-grep               git-merge-file       git-peek-remote          git-request-pull    git-svn
  git-apply             git-daemon            git-gui                git-merge-index      git-prune                git-rerere          git-symbolic-ref
  git-archive           git-describe          git-hash-object        git-merge-octopus    git-prune-packed         git-reset           git-tag
  git-bisect            git-diff              git-help               git-merge-one-file   git-pull                 git-rev-list        git-tar-tree
  git-bisect--helper    git-diff-files        git-http-backend       git-merge-ours       git-push                 git-rev-parse       git-unpack-file
  git-blame             git-diff-index        git-http-fetch         git-merge-recursive  git-quiltimport          git-revert          git-unpack-objects
  git-branch            git-diff-tree         git-http-push          git-merge-resolve    git-read-tree            git-rm              git-update-index
  git-bundle            git-difftool          git-imap-send          git-merge-subtree    git-rebase               git-send-pack       git-update-ref
  git-cat-file          git-difftool--helper  git-index-pack         git-merge-tree       git-rebase--interactive  git-sh-setup        git-update-server-info
  git-check-attr        git-fast-export       git-init               git-mergetool        git-receive-pack         git-shell           git-upload-archive
  git-check-ref-format  git-fast-import       git-init-db            git-mergetool--lib   git-reflog               git-shortlog        git-upload-pack
  git-checkout          git-fetch             git-instaweb           git-mktag            git-relink               git-show            git-var
  git-checkout-index    git-fetch-pack        git-log                git-mktree           git-remote               git-show-branch     git-verify-pack
  git-cherry            git-filter-branch     git-lost-found         git-mv               git-remote-ftp           git-show-index      git-verify-tag
  git-cherry-pick       git-fmt-merge-msg     git-ls-files           git-name-rev         git-remote-ftps          git-show-ref        git-web--browse
  git-citool            git-for-each-ref      git-ls-remote          git-notes            git-remote-http          git-stage           git-whatchanged
  git-clean             git-format-patch      git-ls-tree            git-pack-objects     git-remote-https         git-stash           git-write-tree

实际上在 1.5.4 之前的版本，Git 会安装一百多个以 `git-<cmd>` 格式命名的程序到可执行路径中。这样做的唯一好处就是不用借助任何扩展机制就可以实现命令行补齐：即键入 `git-` 后，连续两次键入 <Tab> 键，就可以把这一百多个命令显示出来。这种方式随着Git子命令的增加越来越显得混乱，因此在 1.5.4 版本开始，不再提供 `git-<cmd>` 格式的命令，而是用唯一的 `git` 命令，之前的名为 `git-<cmd>` 的子命令保存在非可执行目录下，由Git负责加载。

在后面的章节中偶尔会看到形如 `git-<cmd>` 字样的名称，以及同时存在的 `git <cmd>` 命令。可以这样理解 `git-<cmd>` 作为软件本身的名称，而其命令行为 `git <cmd>` 。

至少在 Git 1.7.3.2 版本，git-stash 还是使用 Shell 脚本开发的，研究它会比研究用 C 写的命令要简单的多。

::

  $ file /usr/lib/git-core/git-stash 
  /usr/lib/git-core/git-stash: POSIX shell script text executable

