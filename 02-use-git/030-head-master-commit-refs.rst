实践三：什么是 HEAD 和 master ？
================================

在“实践二”中，学习了 Git 的一个最重要的概念：暂存区（stage, index）。暂存区是一个介于工作区和版本库的中间状态，当执行提交时实际上是将暂存区的内容提交到版本库中，而且 Git 很多命令都会涉及到暂存区的概念，例如: "git diff" 命令。但是“实践二”还是留下了很多疑惑，例如什么是 HEAD？什么是 master？为什么在“实践二”中它们二者可以相互替换使用？40位的 ID 是什么？这一章的内容将会揭开这些奥秘，并且还会画出一个更为精确的版本库结构图。

因为在“实践二”的最后执行了 "git stash" 将工作区和暂存区的改动全部封存起来，所以执行下面的命令会看到工作区和暂存区中没有改动。

::

  $ git status -s -b
  ## master

在执行精简状态输出的命令行中使用了 "`-b`" 参数的含义是显示当前的工作分支，所以输出中显示了分支是 "master"。实际上有专用的命令来显示工作分支。

::

  $ git branch
  * master

在 master 分支名称前面出现一个星号表明这个分支是当前工作分支。至于为什么没有其它分支以及什么叫做分支，会在本书后面的章节揭晓。

现在连续执行下面的三个命令会看到相同的输出：

::

  $ git log -1 HEAD
  commit e695606fc5e31b2ff9038a48a3d363f4c21a3d86
  Author: Jiang Xin <jiangxin@ossxp.com>
  Date:   Mon Nov 29 17:23:01 2010 +0800

      which version checked in?
  $ git log -1 master
  commit e695606fc5e31b2ff9038a48a3d363f4c21a3d86
  Author: Jiang Xin <jiangxin@ossxp.com>
  Date:   Mon Nov 29 17:23:01 2010 +0800

      which version checked in?
  $ git log -1 refs/heads/master
  commit e695606fc5e31b2ff9038a48a3d363f4c21a3d86
  Author: Jiang Xin <jiangxin@ossxp.com>
  Date:   Mon Nov 29 17:23:01 2010 +0800

      which version checked in?

也就是说在当前版本库中，HEAD, "master" 和 "refs/heads/master" 具有相同的指向。现在到版本库（.git目录）中找一找它们的踪迹。

::

  $ find .git -name HEAD -o -name master 
  .git/HEAD
  .git/logs/HEAD
  .git/logs/refs/heads/master
  .git/refs/heads/master

找到了四个文件，其中在 ".git/logs" 目录下的文件稍后再予以关注，现在把目光锁定在 ".git/HEAD" 和 ".git/refs/heads/master" 上。

显示一下 ".git/HEAD" 的内容：

::

  $ cat .git/HEAD 
  ref: refs/heads/master

把 HEAD 的内容翻译过来就是：“指向一个引用：refs/heads/master”。这个引用在哪里？当然是文件 ".git/refs/heads/master" 了。

::

  $ cat .git/refs/heads/master 
  e695606fc5e31b2ff9038a48a3d363f4c21a3d86

仔细数一下共有40位数字和字母组成的 ID

显示 e695606fc5e31b2ff9038a48a3d363f4c21a3d86 所指为何物，在 Git 有一个底层命令 "git cat-file" 可以帮助破解奥秘。

* 显示 SHA1-ID 指代的数据类型。

  :: 

    $ git cat-file -t e695606fc5e31b2ff9038a48a3d363f4c21a3d86
    commit

* 显示 SHA1-ID 的内容。

  :: 

    $ git cat-file -p e695606fc5e31b2ff9038a48a3d363f4c21a3d86
    tree f58da9a820e3fd9d84ab2ca2f1b467ac265038f9
    parent a0c641e92b10d8bcca1ed1bf84ca80340fdefee6
    author Jiang Xin <jiangxin@ossxp.com> 1291022581 +0800
    committer Jiang Xin <jiangxin@ossxp.com> 1291022581 +0800

    which version checked in?


::

  $ (printf "commit 234\000"; git cat-file -p e695606fc5e31b2ff9038a48a3d363f4c21a3d86) | sha1sum


