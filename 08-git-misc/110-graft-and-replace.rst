嫁接和替换
================

提交嫁接
----------------

提交嫁接可以实现在本地版本库上将两条完全不同提交线（分支）嫁接（连接）到一起。对于一些项目将版本控制系统迁移到 Git 上，该技术会非常有帮助。例如 Linux 本身的源代码控制在转移到 Git 上时，尚没有任何工具可以将 Linux 的提交历史从旧的 Bitkeeper 版本控制系统中导出，后来 Linux 旧的代码通过 bkcvs 导入到 Git 中，如何将新旧两条开发线连接到一起呢？于是发明了提交嫁接，实现新旧两条开发线的合并，这样 Linux 开发者就可以在一个开发分支中由最新的提交追踪到原来位于 Bitkeeper 中的提交。

提交嫁接是通过在版本库中创建 `.git/info/grafts` 文件实现的。该文件每一行的格式为：

::

  <commit sha1> <parent sha1> [<parent sha1>]*

用空格分开各个字段，其中第一个字段是一个提交的 SHA1 哈希值，而后面用空格分开的其他 SHA1 哈希值则作为该提交的父提交。当把一个提交线的根节点作为第一个字段，将第二个提交线顶节点作为第二个字段，就实现了两个提交线的嫁接，看起来像是一条提交线了。

在本书第6篇“第35.4节Git版本库整理”中介绍的 `git filter-branch` 命令在对版本库整理时，如果发现存在 `.git/info/grafts` 则会在物理上完成提交的嫁接，实现嫁接的永久生效。


提交替换
----------------

提交替换和提交嫁接类似，不过不是用一个提交来伪成装另外一个提交的父提交，而是直接替换另外的提交，实现在不影响其他提交的基础上实现对历史提交的修改。

提交替换是通过在特殊命名空间 `.git/refs/replace/` 下定义引用来实现的。引用的名称是要被替换掉的提交SHA1哈希值，而引用内容（所指向的提交）就是用于替换的（正确的）提交SHA1哈希值。因为提交替换是通过引用进行定义，因此可以在不同的版本库之间传递，而不像提交嫁接只能在本地版本库中使用。

Git 提供 `git replace` 命令来管理提交替换，用法如下：

::

  用法1： git replace [-f] <object> <replacement>
  用法2： git replace -d <object>...
  用法3： git replace -l [<pattern>]

其中：

* 用法1用于创建提交替换，即在 `.git/refs/replace` 目录下创建名为 `<object>` 的引用，其内容为 `<replacement>` 。如果使用 `-f` 参数，还允许级联替换，用于替换的提交来可以是另外一个已经在 `.git/refs/replace` 中定义的替换。
* 用法2用于删除定义的替换。
* 用法3显示已经存在的提交替换。

提交替换可以被大部分 Git 命令理解，除了一些命令针对被替换的提交使用 `--no-replace-objects` 参数。例如：

* 当提交 `foo` 被提交 `bar` 替换后，显示未被替换前的 `foo` 提交：

  ::

    $ git --no-replace-objects cat-file commit foo

* 显示为替换后的 `bar` 提交：

  ::

    $ git cat-file commit foo

提交替换使用引用进行定义，因此可以通过 `git fetch` 和 `git push` 在版本库之间传递。但因为缺省 Git 只同步引用中的里程碑和分支，因此需要在命令中显式的给出提交替换的引用名称，如：

::

  git fetch origin refs/replace/*
  git push  origin refs/replace/*

提交替换也可以实现两个分支的嫁接。例如要将分支A嫁接到B上，就相当于将分支A的根提交 `<BRANCH_A_ROOT>` 的父提交设置为分支B的最新提交 `<BRANCH_B_CURRENT>` 。可以先创建一个新提交 `<BRANCH_A_NEW_ROOT>` ，其父提交设置为 `<BRANCH_B_CURRENT>` 而提交的其他字段完全和 `<BRANCH_A_ROOT>` 一致。然后设置提交替换，用 `<BRANCH_A_NEW_ROOT>` 替换 `<BRANCH_A_ROOT>` 即可。

创建 `<BRANCH_A_NEW_ROOT>` 可以使用下面的方法：其中 `git cat-file commit` 命令用于显示提交的原始信息， `sed` 命令用于向原始提交中插入一条 `parent SHA1...` 的语句，而命令 `git hash-object` 是一个 Git 底层命令，可以将来自标准输入的内容创建一个新的提交对象。

::

  $ git cat-file commit <BRANCH_A_ROOT> |
    sed -e "/^tree / a \
            parent $(git rev-parse <BRANCH_B_CURRENT>)" |
    git hash-object -t commit -w --stdin

上面命令的输出即是 `<BRANCH_A_NEW_ROOT>` 的值。执行下面的替换命令，完成两个分支的嫁接。

::

  $ git replace <BRANCH_A_ROOT> <BRANCH_A_NEW_ROOT>
