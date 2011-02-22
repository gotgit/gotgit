Git 评注
================

从 1.6.6 版本开始，Git 提供了一个 `git notes` 命令可以为提交添加评注，实现在不改变提交对象的情况下在提交说明的后面附加评注。图41-1展示了 Github 利用 `git notes` 实现的在提交显示界面中显示评注（如果存在的话）和添加评注的界面。

.. figure:: images/git-misc/github-notes.png
   :scale: 70

   图41-1：Github 上显示和添加评注

评注的奥秘
----------

实际上 Git 评注可以针对任何对象，而且评注的内容也不限于文字，因为评注的内容是保存在 Git 对象库中的一个 blob 对象中。不过评注目前最主要的应用还是在提交说明后添加评注。

在第2篇“第11.4.6节二分查找”中用到的 `gitdemo-commit-tree` 版本库实际上就包含了提交评注，只不过之前尚未将评注获取到本地版本库而已。如果工作区中的 `gitdemo-commit-tree` 版本库已经不存在，可以使用下面的命令从 Github 上再克隆一个：

::

  $ git clone -q git://github.com/ossxp-com/gitdemo-commit-tree.git 
  $ cd gitdemo-commit-tree

执行下面的命令，查看最后一次提交的提交说明：

::

  $ git log -1
  commit 6652a0dce6a5067732c00ef0a220810a7230655e
  Author: Jiang Xin <jiangxin@ossxp.com>
  Date:   Thu Dec 9 16:07:11 2010 +0800

      Add Images for git treeview.
      
      Signed-off-by: Jiang Xin <jiangxin@ossxp.com>

下面为默认的 origin 远程版本库再添加一个引用获取表达式，以便在执行 `git fetch` 命令时能够同步评注相关的引用。命令如下：

::

  $ git config --add remote.origin.fetch refs/notes/*:refs/notes/*

执行 `git fetch` 会获取到一个新的引用 `refs/notes/commits` ，如下：

::

  $ git fetch
  remote: Counting objects: 6, done.
  remote: Compressing objects: 100% (5/5), done.
  remote: Total 6 (delta 0), reused 0 (delta 0)
  Unpacking objects: 100% (6/6), done.
  From git://github.com/ossxp-com/gitdemo-commit-tree
   * [new branch]      refs/notes/commits -> refs/notes/commits

当获取到新的评注相关的引用之后，再来查看最后一次提交的提交说明，会看到下面的命令输出中提交说明的最后两行就是附加的提交评注。

::

  $ git log -1
  commit 6652a0dce6a5067732c00ef0a220810a7230655e
  Author: Jiang Xin <jiangxin@ossxp.com>
  Date:   Thu Dec 9 16:07:11 2010 +0800

      Add Images for git treeview.
      
      Signed-off-by: Jiang Xin <jiangxin@ossxp.com>

  Notes:
      Bisect test: Bad commit, for doc/B.txt exists.

附加的提交评注来自于哪里呢？显然应该和刚刚获取到的引用相关。查看一下获取到的最新引用，会发现引用 `refs/notes/commits` 指向的是一个提交对象。

::

  $ git show-ref refs/notes/commits
  6f01cdc59004892741119318ceb2330d6dc0cef1 refs/notes/commits
  $ git cat-file -t refs/notes/commits
  commit

既然新获取的评注引用是一个提交对象，那么就应该能够查看评注引用的提交日志：

::

  $ git log --stat refs/notes/commits
  commit 6f01cdc59004892741119318ceb2330d6dc0cef1
  Author: Jiang Xin <jiangxin@ossxp.com>
  Date:   Tue Feb 22 09:32:10 2011 +0800

      Notes added by 'git notes add'

   6652a0dce6a5067732c00ef0a220810a7230655e |    1 +
   1 files changed, 1 insertions(+), 0 deletions(-)

  commit 9771e1076d2218922acc9800f23d5e78d5894a9f
  Author: Jiang Xin <jiangxin@ossxp.com>
  Date:   Tue Feb 22 09:31:54 2011 +0800

      Notes added by 'git notes add'

   e80aa7481beda65ae00e35afc4bc4b171f9b0ebf |    1 +
   1 files changed, 1 insertions(+), 0 deletions(-)

从上面的评注引用的提交日志可以看出，存在两次提交，并且从提交说明可以看出是使用 `git notes add` 命令添加的。至于每次提交添加的文件却很让人困惑，所添加文件的文件名居然是40位的哈希值。您当然可以通过 `git checkout -b` 命令检出该引用来研究其中所包含的文件，不过也可以运用我们已经学习到的 Git 命令直接对其进行研究。

* 用 `git show` 命令显示目录树。

  ::

    $ git show -p refs/notes/commits^{tree}
    tree refs/notes/commits^{tree}

    6652a0dce6a5067732c00ef0a220810a7230655e
    e80aa7481beda65ae00e35afc4bc4b171f9b0ebf

* 用 `git ls-tree` 命令查看文件大小及对应的 blob 对象的 SHA1 哈希值。

  ::

    $ git ls-tree -l refs/notes/commits
    100644 blob 80b1d249069959ce5d83d52ef7bd0507f774c2b0      47    6652a0dce6a5067732c00ef0a220810a7230655e
    100644 blob e894f2164e77abf08d95d9bdad4cd51d00b47845      56    e80aa7481beda65ae00e35afc4bc4b171f9b0ebf

* 文件名既然是一个40位的SHA1哈希值，那么文件名一定有意义，通过下面的命令可以看到文件名包含的40位哈希值实际对应于一个提交。

  ::

    $ git cat-file -p 6652a0dce6a5067732c00ef0a220810a7230655e
    tree e33be9e8e7ca5f887c7d5601054f2f510e6744b8
    parent 81993234fc12a325d303eccea20f6fd629412712
    author Jiang Xin <jiangxin@ossxp.com> 1291882031 +0800
    committer Jiang Xin <jiangxin@ossxp.com> 1291882892 +0800

    Add Images for git treeview.

    Signed-off-by: Jiang Xin <jiangxin@ossxp.com>

* 用 `git cat-file` 命令查看该文件的内容，可以看到其内容就是附加在相应提交上的评注。

  ::

    $ git cat-file -p refs/notes/commits:6652a0dce6a5067732c00ef0a220810a7230655e
    Bisect test: Bad commit, for doc/B.txt exists.

综上所述，评注记录在一个 blob 对象中，并且以所评注对象的SHA1哈希值命名。因为对象SHA1哈希值的唯一性，所以可以将评注都放在同一个文件系统下而不会发生覆盖。针对包含评注的特殊的文件系统的更改被提交到一个特殊的引用 `refs/notes/commits` 当中。

评注相关命令
-------------

Git 提供了 `git notes` 命令，对评注进行管理。如果执行 `git notes list` 或者像下面这样不带任何参数进行调用，会显示和上面 `git ls-tree` 类似的输出：

::

  $ git notes
  80b1d249069959ce5d83d52ef7bd0507f774c2b0 6652a0dce6a5067732c00ef0a220810a7230655e
  e894f2164e77abf08d95d9bdad4cd51d00b47845 e80aa7481beda65ae00e35afc4bc4b171f9b0ebf

右边的一列是要评注的提交对象，而左边一列是附加在对应提交上的包含评注内容的 blob 对象。显示附加在某个提交上的评注可以使用 `git notes show` 命令。如下：

::

  $ git notes show G^0
  Bisect test: Good commit, for doc/B.txt does not exist.

注意上面的命令中使用 `G^0` 而非 `G` ，是因为 `G` 是一个里程碑对象，而评注是建立在里程碑对象所指向的提交对象上。

添加评注可以使用下面的 `git notes add` 和 `git notes append` 子命令：

::

  用法1：git notes add [-f] [-F <file> | -m <msg> | (-c | -C) <object>] [<object>]
  用法2：git notes append [-F <file> | -m <msg> | (-c | -C) <object>] [<object>]

用法1是添加评注，而用法2是在已有评注后面追加。两者的命令行格式和 `git commit` 非常类似，可以用类似写提交说明的方法写提交评注。如果省略最后一个 `<object>` 参数，则意味着向头指针 HEAD 添加评注。子命令 `git notes add` 中的参数 `-f` 意味着强制添加，会覆盖对象已有的评注。

使用 `git notes copy` 子命令可以将一个对象的评注拷贝到另外一个对象上。

::

  用法：git notes copy [-f] ( --stdin | <from-object> <to-object> )

修改评注可以使用下面的 `git notes edit` 子命令：

::

  用法：git notes edit [<object>]

删除评注可以使用的 `git notes remote` 子命令，而 `git notes prune` 则可以清除已经不存在的对象上的评注。用法如下：

::

  用法1：git notes remove [<object>]
  用法2：git notes prune [-n | -v]

评注以文件形式保存在特殊的引用中，如果该引用被共享并且出现多人撰写评注时，有可能出现该引用的合并冲突。可以用 `git notes merge` 命令来解决合并冲突。评注引用也可以使用其他的引用名称，合并其他的评注引用也可以使用本命令。下面是 `git notes merge` 命令的用法：

::

  用法1：git notes merge [-v | -q] [-s <strategy> ] <notes_ref>
  用法2：git notes merge --commit [-v | -q]
  用法3：git notes merge --abort [-v | -q]

评注相关配置
------------

默认提交评注保存在引用 `refs/notes/commits` 中，这个默认的设置可以通过 `core.notesRef` 配置变量修改。如须更改，要在 `core.notesRef` 配置变量中使用引用的全称而不能使用缩写。

在执行 `git log` 命令显示提交评注的时候，如果配置了 `notes.displayRef` 配置变量（可以使用通配符，并且可以配置多个），则在显示提交评注时，除了会参考 `core.notesRef` 设定的引用（或默认的 `refs/notes/commits` 引用）外，还会显示 `notes.displayRef` 指向的引用（一个或多个）。

配置变量 `notes.rewriteRef` 用于配置哪个/哪些引用中的提交评注会随着提交的修改而复制到新的提交之上。这个配置变量可以使用多次，或者使用通配符，但该配置变量没有缺省值，因此为了使得提交评注能够随着提交的修改（修补提交、变基等）继续保持，必须对该配置变量进行设定。如：

::

  $ git config --global notes.rewriteRef refs/notes/*

还有 `notes.rewrite.amend` 和 `notes.rewrite.rebase` 配置变量可以分别对两种提交修改模式（amend 和 rebase）是否启用评注复制进行设置，默认启用。配置变量 `notes.rewriteMode` 默认设置为 `concatenate` ，即提交评注复制到修改后的提交时，如果已有评注则对评注进行合并操作。
