Git 初始化
**********

通过前面的章节了解了版本控制系统的历史、来龙去脉，也学习了 Git 的安装。从这一章开始，就真正的进入到 Git 的学习中。Git 的学习有着陡峭的学习曲线，即使是有着其他版本控制工具经验的老手也不例外。因为有经验的老手会按照在他们在其他版本控制系统中遗留的习惯去想当然的操作 Git，努力的在 Git 中寻找对应物，最终会因为 Git 的“别扭”而放弃使用。这也是作者的亲身经历。

Git 是开源社区送给每一个人的宝贝，用好它可以实现个人的知识积累，保护好自己的数据，以及和他人分享自己的成果。这在其他的很多版本控制系统中是不可想象的。试问能够让个人花费少则几万美金去购买商业版本控制工具么？能够让个人去使用必需搭建额外的服务器才能使用的版本控制系统么？能够让个人把“鸡蛋”放在具有单点故障、服务器软硬件存在崩溃可能的唯一的“篮子”里么？选择 Git，一定是个人最明智的选择。

在本书的这一部分不会涉及到团队如何使用 Git，而是以个人的视角去研究如何用好 Git，而且还会揭示 Git 的原理和奥秘。本部分是全书最重要的部分，是下一步进行团队协作必需的知识准备，也是理解全书其余各个部分内容的基础。本部分各个章节的组织采用实践，思考，再实践的方式，循序渐进的学习 Git。到本部分的结尾，读者会发现通过“Git 独奏”也可以演绎出美妙的“乐曲”。

那么就进入第一个实践。

创建版本库及第一次提交
========================

您当前使用的是 1.5.6 或更高版本的 Git 么？

::

  $ git --version
  git version 1.7.3.3

Git 是一个活跃的项目，仍在不断的进化之中，不同的 Git 版本功能不尽相同。本书对 Git 的介绍涵盖了 1.5.6 到 1.7.3 版本，这也是目前 Git 的主要版本。如果使用的 Git 版本低于 1.5.6，那么应该升级到 1.5.6 或更高的版本。本书示例使用的是 1.7.3.3 版本的 Git，对于那些低版本不兼容的命令及参数，会尽可能的指出。

在开始 Git 之旅之前，需要对 Git 的环境变量进行一下设置，这个设置是一次性的工作。就是说这些设置会在全局文件（用户主目录下的 .gitconfig）或者系统文件（/etc/gitconfig）中做永久的记录。

* 告诉 Git 当前用户的姓名和邮件地址，配置的用户名和邮件地址将在版本库提交时作为提交者的用户名和地址。

  注意下面的两条命令不要照抄照搬，而是用您的用户名和邮件地址代替这里的用户名和邮件地址，否则您的劳动成果（提交）可要算到作者的头上了。

  ::

    $ git config --global user.name "Jiang Xin"
    $ git config --global user.email jiangxin@ossxp.com

* 设置一些 Git 别名，以便可以使用更为简洁的子命令。

  例如: 输入 `git ci` 即相当于 `git commit` ，输入 `git st` 即相当于 `git status` 。

  - 如果拥有系统管理员权限（可以执行 sudo 命令），希望注册的命令别名能够被所有用户使用，可以执行：

    ::

      $ sudo git config --system alias.st status
      $ sudo git config --system alias.ci commit
      $ sudo git config --system alias.co checkout
      $ sudo git config --system alias.br branch

  - 也可以运行下面的命令，只在本用户的全局配置中添加 Git 命令别名：

    ::

      $ git config --global alias.st status
      $ git config --global alias.ci commit
      $ git config --global alias.co checkout
      $ git config --global alias.br branch

Git 的所有操作，包括版本库创建等管理操作都用 `git` 一个命令完成，不像其他有的版本控制系统（如 Subversion），一些涉及管理的操作要使用另外的命令（如 `svnadmin` ）。创建 Git 版本库，可以直接进入到包含数据（文件和子目录）的目录下，通过执行 `git init` 完成版本库的初始化。

下面就从一个空目录开始初始化版本库，这个版本库命名为“DEMO版本库”，在本部分这个DEMO版本库将贯穿始终。为了说明方便，使用了名为 `/path/to/my/workspace` 的目录作为个人的工作区根目录，可以在磁盘中创建该目录并设置正确的权限。

首先建立一个新的工作目录，进入该目录后，执行 `git init` 完成版本库创建。

::

  $ cd /path/to/my/workspace
  $ mkdir demo
  $ cd demo
  $ git init
  Initialized empty Git repository in /path/to/my/workspace/demo/.git/

实际上，如果 Git 的版本是 1.6.5 或更新的版本，可以在 `git init` 命令的后面直接输入目录名称，自动完成目录的创建。

:: 

  $ cd /path/to/my/workspace
  $ git init demo 
  Initialized empty Git repository in /path/to/my/workspace/demo/.git/
  $ cd demo

从上面版本库初始化后的输出中，可以看到执行 `git init` 命令在工作区创建了隐藏目录 `.git` 。

::

  $ ls -aF
  ./  ../  .git/

这个隐藏的 `.git` 目录就是 Git 版本库（又叫仓库, repository ）。

`.git` 版本库目录所在的目录，即 `/path/to/my/workspace/demo` 目录称为 **工作区** ，目前工作区除了包含一个隐藏的 `.git` 版本库目录外，空无一物。

下面为工作区中加点料：在工作区中创建一个文件 `welcome.txt` ，内容就是一行 "Hello."。

::

  $ echo "Hello." > welcome.txt

为了将这个新建立的文件添加到版本库，需要执行下面的命令：

::

  $ git add welcome.txt

切记，到这里还没有完。Git 和大部分其他版本控制系统都需要再执行一次提交操作，对于Git来说就是执行 `git commit` 命令完成提交。在提交过程中需要输入提交说明，这个要求对于 Git 来说是强制性的，不像很多版本控制系统（如CVS，Subversion）允许空白的提交说明。在Git提交时，如果在命令行不提供提交说明（使用 `-m` 参数）会自动打开一个编辑器，在其中输入提交说明，输入完毕保存退出。需要说明的是，在 Linux 上会使用 vim 或者 emacs 风格的编辑器，也许读者需要找相关资料学习一下，否则保存退出也会成为问题。

下面进行提交。为了说明方便，使用 `-m` 参数直接给出了提交说明。

::

  $ git ci -m "initialized."
  [master (root-commit) 78cde45] initialized.
   1 files changed, 1 insertions(+), 0 deletions(-)
   create mode 100644 welcome.txt

从上面的命令及输出中，可以看出：

* 命令 `git ci` 实际上相当于使用了 `git commit` ，这是因为之前为 Git 设置了命令别名。
* 通过 `-m` 参数设置提交说明为："initialized." 。
* 命令输出的第一行，可以看出此次提交是提交在名为 `master` 的分支上，是该分支的第一个提交（root-commit），提交 ID 为 78cde45。

  读者实际操作中看到ID肯定和这里写的不一样，具体原因在后面“Git对象探秘”章节会予以介绍。如果碰巧读者的操作显示出了同样的ID（78cde45），那么我建议读者赶紧去买一张彩票。

* 命令输出的第二行，可以看出此次提交中，修改了一个文件，包含一行的插入。
* 命令输出的第三行，可以看出此次提交创建了新文件 `welcome.txt` 。

思考：为什么工作区下有一个 .git 目录？
======================================

Git 以及其他分布式版本控制系统（如 Mercurial/Hg, Bazaar）的一个显著特点是，版本库位于工作区的根目录下。对于 Git 来说，版本库位于工作区根目录下的 `.git` 目录中，且仅此一处，在工作区的子目录下则没有任何其他跟踪文件或目录。Git 的这个设计要比 CVS, Subversion 这些传统的集中式版本控制工具来说方便多了。

看看版本控制系统前辈们是如何对工作区的跟踪进行设计的。通过其各自设计的优缺点，会更加的体会到 Git 实现的必要和巧妙。

对于 CVS，工作区的根目录以及每一个子目录下都有一个 `CVS` 目录， `CVS` 目录中包含几个配置文件，建立了对版本库的追踪。如 `CVS` 目录下的 `Entries` 文件记录了从版本库检出到工作区的文件的名称、版本和时间戳等，这样就可以通过对工作区文件时间戳的改变来判断文件是否更改。这样设计的好处是，可以将工作区移动到任何其他目录中，而工作区和版本控制服务器的映射关系保持不变，这样工作区依然能够正常工作。甚至还将工作区的某个子目录移动到其他位置，形成新的工作区，在新的工作区下仍然可以完成版本控制相关操作。但是缺点也很多，例如工作区文件修改了，因为没有原始文件做比对，因此向服务器提交修改的时候只能对整个文件进行传输而不能仅针对文件的改动部分传输，导致从客户端到服务器的网络传输效率低。还有一个风险是造成信息泄漏。例如 Web 服务器的目录下如果包含了 `CVS` 目录，黑客就可以通过扫描 `CVS/Entries` 文件得到目录下的文件列表，由此造成信息泄漏。

对于 Subversion 来说，工作区的根目录和每一个子目录下都有一个 `.svn` 目录。目录 `.svn` 中不但包含了类似 CVS 的跟踪目录下的配置文件，还包含了当前工作区下每一个文件的拷贝。多出的文件原始拷贝让某些 svn 命令可以脱离版本库执行，还可以在由客户端向服务器提交时，仅仅对文件改动的内容进行提交，因为改动的文件可以和原始拷贝进行差异比较。但是这么做的缺点除了像 CVS 因为引入 `CVS` 跟踪目录造成的信息泄漏的风险外，还导致了工作区空间占用的加倍。再有一个不方便的地方就是当在工作区目录下针对文件内容进行搜索的时候，会因为 `.svn` 目录下文件的原始拷贝，导致搜索的结果加倍，出新混乱的搜索结果。

有的版本控制系统，在工作区根本就没有任何跟踪文件，例如一款版本控制的商业软件（就不点名字了），工作区就非常干净没有任何的配置文件和配置目录。但是这样的设计更加糟糕，因为它实际上是由服务器端建立的文件跟踪，在服务器端的数据库中保存了一个表格：哪台客户端，在哪个本地目录检出了哪个版本的版本库文件。这样做的后果是，如果客户端将工作区移动或者改名会导致文件的跟踪状态丢失，出现文件状态未知的问题。客户端操作系统重装，也会导致文件跟踪状态丢失。

Git 的这种设计，将版本库放在工作区根目录下，所有的版本控制操作（除了和其他远程版本库之间的互操作）都在本地即可完成，不像 Subversion 只有寥寥无几的几个命令才能脱离网络执行。而且 Git 也没有 CVS 和 Subversion 的安全泄漏问题（只要保护好 .git 目录），也没有 Subversion 在本地文件搜索时搜索结果混乱的问题，甚至
Git 提供了一条 `git grep` 命令来实现更好的工作区文件内容搜索。

例如作者在本书的 Git 库中执行下面的命令对版本库中的文件进行内容搜索：

::

  $ git grep "工作区文件内容搜索"
  02-git-solo/010-git-init.rst:Git 提供了一条 `git grep` 命令来实现更好的工作区文件内容搜索。

**当工作区中包含了子目录，在子目录中执行 Git 命令时，如何定位版本库位置呢？**

实际上当在 Git 工作区目录下执行操作的时候，会对目录依次向上递归查找 `.git` 目录，找到的 `.git` 目录就是工作区对应的版本库， `.git` 所在的目录就是工作区的根目录，文件 `.git/index` 记录了工作区文件的状态（实际上是暂存区的状态）。

例如在非 Git 工作区执行 git 命令，会因为找不到 `.git` 目录而报错。

::

  $ cd /path/to/my/workspace/
  $ git status
  fatal: Not a git repository (or any of the parent directories): .git

如果跟踪一下执行 git status 命令时的磁盘访问，会看到沿目录依次向上递归的过程。

::

  $ strace -e 'trace=file' git status
  ...
  getcwd("/path/to/my/workspace", 4096)           = 14
  stat(".", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
  stat(".git", 0x7fffdf1288d0)            = -1 ENOENT (No such file or directory)
  access(".git/objects", X_OK)            = -1 ENOENT (No such file or directory)
  access("./objects", X_OK)               = -1 ENOENT (No such file or directory)
  stat("..", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
  chdir("..")                             = 0
  stat(".git", 0x7fffdf1288d0)            = -1 ENOENT (No such file or directory)
  access(".git/objects", X_OK)            = -1 ENOENT (No such file or directory)
  access("./objects", X_OK)               = -1 ENOENT (No such file or directory)
  stat("..", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
  chdir("..")                             = 0
  stat(".git", 0x7fffdf1288d0)            = -1 ENOENT (No such file or directory)
  access(".git/objects", X_OK)            = -1 ENOENT (No such file or directory)
  access("./objects", X_OK)               = -1 ENOENT (No such file or directory)
  fatal: Not a git repository (or any of the parent directories): .git

**那么有什么办法知道 Git 版本库的位置，以及工作区的根目录在哪里么？**

当在工作区执行 git 命令时，上面的查找版本库的操作总是默默的执行就好像没有发生的一样。如果希望显示工作区的根，Git 有一个底层命令可以实现。

* 在工作区下建立目录 `a/b/c` ，进入到该目录中。

  ::

    $ cd /path/to/my/workspace/demo/
    $ mkdir -p a/b/c
    $ cd /path/to/my/workspace/demo/a/b/c

* 显示版本库 `.git` 目录所在的位置。

  ::

    $ git rev-parse --git-dir
    /path/to/my/workspace/demo/.git

* 显示工作区根目录。

  ::

    $ git rev-parse --show-toplevel
    /path/to/my/workspace/demo

* 相对于工作区根目录的相对目录。

  ::

    $ git rev-parse --show-prefix
    a/b/c/

* 显示从当前目录（cd）后退（up）到工作区的根的深度。

  ::

    $ git rev-parse --show-cdup
    ../../../


**把版本库 .git 目录放在工作区，是不是太不安全了？**

从存储安全的角度上来讲，将版本库放在工作区目录下，有点“把鸡蛋装在一个篮子里”的味道。如果忘记了工作区中还有版本库，直接从工作区的根执行目录删除就会连版本库一并删除，这个风险的确是蛮高的。将版本库和工作区拆开似乎更加安全，但是不要忘了之前的讨论，将版本库和工作区拆开，就要引入其他机制以便实现版本库对工作区的追踪。

Git 克隆可以降低因为版本库和工作区混杂一起导致版本库被破坏的风险。可以通过版本库克隆，在本机另外的磁盘/目录建立 Git 克隆，并在工作区有改动提交时手动或自动的执行向克隆版本库的推送（git push）操作。如果使用网络协议，还可以实现在其他机器上建立克隆，这样就更安全了（双机备份）。对于团队开发使用 Git 做版本控制，每个人都是一个备份，因此团队开发中的 Git 版本库更安全，管理员甚至根本无须顾虑版本库存储安全问题。

思考：git config 命令参数的区别？
========================================================

在之前出现的 `git config` 命令，有的使用了 `--global` 参数，有的使用了 `--system` 参数，有什么区别么？执行下面的命令，就明白 `git config` 命令实际操作的文件了。

* 执行下面的命令，将打开 `/path/to/my/workspace/demo/.git/config` 文件进行编辑。

  ::

    $ cd /path/to/my/workspace/demo/
    $ git config -e 

* 执行下面的命令，将打开 `/home/jiangxin/.gitconfig` （用户主目录下的 .gitconfig 文件）全局配置文件进行编辑。

  ::

    $ git config -e --global

* 执行下面的命令，将打开 `/etc/gitconfig` 系统级配置文件进行编辑。

  如果 Git 安装在 /usr/local/bin 下，这个系统级的配置文件也可能是在 "/usr/local/etc/gitconfig" 。

  ::

    $ git config -e --system

Git 的三个配置文件分别是版本库级别的配置文件，全局配置文件（用户主目录下），和系统级配置文件（/etc 目录下）。其中版本库级别配置文件的优先级最高，全局配置文件其次，系统级配置文件优先级最低。这样的优先级设置就可以让版本库 .git 目录下的 config 文件中的配置可以覆盖用户主目录下的 Git 环境配置。而用户主目录下的配置也可以覆盖系统的 Git 配置文件。

执行前面的三个 `git config` 命令，会看到这三个级别配置文件的格式和内容，原来 Git 配置文件采用的是 INI 文件格式。示例如下：

::

  $ cat /path/to/my/workspace/demo/.git/config 
  [core]
          repositoryformatversion = 0
          filemode = true
          bare = false
          logallrefupdates = true

命令 `git config` 可以用于读取和更改 INI 配置文件的内容。读取 INI 配置文件中某个配置的键值，使用命令 `git config <section>.<key>` 。例如读取 `[core]` 小节的 `bare` 属性的值，可以用如下命令：

::

  $ git config core.bare
  false

如果想更改或设置 INI 文件中某个属性值也非常简单，命令格式是： `git config <section>.<key> <value>` 。可以如下操作：

::

  $ git config a.b something
  $ git config x.y.z others

如果打开 .git/config 文件，会看到如下内容：

::

  [a]
          b = something

  [x "y"]
          z = others

对于类似 `[x "y"]` 一样的配置小节，在本书下一个部分介绍远程版本库的章节会经常遇到。

从上面的介绍中，可以看到使用 `git config` 命令可以非常方便的操作 INI 文件，实际上可以用 `git config` 命令操作任何其他的 INI 文件。

* 向配置文件 `test.ini` 中添加配置。

  ::

    $ GIT_CONFIG=test.ini git config a.b.c.d "hello, world"

* 从配置文件 `test.ini` 中读取配置。

  ::

    $ GIT_CONFIG=test.ini git config a.b.c.d
    hello, world

后面介绍的 git-svn 软件，就使用这个技术读写 git-svn 专有的配置文件。


思考：是谁完成的提交？
=======================

在本章的一开始，先为 Git 设置了 `user.name` 和 `user.email` 全局环境变量，如果不设置会有什么结果呢？

执行下面的命令，删除 Git 全局配置文件中关于 `user.name` 和 `user.email` 的设置：

::

  $ git config --unset --global user.name
  $ git config --unset --global user.email


这下关于用户姓名和邮件的设置都被清空了，执行下面的命令将看不到输出。

::

  $ git config user.name
  $ git config user.email

下面再尝试进行一次提交，看看提交的过程会有什么不同，以及提交之后显示的提交者是谁？

在下面的命令中使用了 `--allow-empty` 参数，这是因为没有对工作区的文件进行任何修改，Git 缺省不会提交，使用了 `--allow-empty` 参数后，允许执行空白提交。

::

  $ cd /path/to/my/workspace/demo
  $ git commit --allow-empty -m "who does commit?"
  [master 252dc53] who does commit?
   Committer: JiangXin <jiangxin@hp.moon.ossxp.com>
  Your name and email address were configured automatically based
  on your username and hostname. Please check that they are accurate.
  You can suppress this message by setting them explicitly:

      git config --global user.name "Your Name"
      git config --global user.email you@example.com

  If the identity used for this commit is wrong, you can fix it with:

      git commit --amend --author='Your Name <you@example.com>'

喔，因为没有设置 `user.name` 和 `user.email` 变量，提交输出乱的一塌糊涂。仔细看看上面执行 `git commit` 命令的输出，原来 Git 提供了详细的帮助指引，告诉如何设置必需的变量，还告诉如何修改之前提交中出现的错误的提交者信息。

看看此时版本库的提交日志，会看到有两次提交。

注意：下面的输出和您的输出肯定会有不同，一个是提交时间会不一样，再有由40位十六进制数字组成的提交ID也不可能一样，甚至本书中凡是您亲自完成的提交，相关的40位魔幻般的数字ID都会不一样（原因会在后面的章节看到）。因此凡是涉及到数字ID和作者示例不一致的时候，以读者自己数字ID为准，作者提供的仅是示例和参考，切记切记。

::

  $ git log --pretty=fuller
  commit 252dc539b5b5f9683edd54849c8e0a246e88979c
  Author:     JiangXin <jiangxin@hp.moon.ossxp.com>
  AuthorDate: Mon Nov 29 10:39:35 2010 +0800
  Commit:     JiangXin <jiangxin@hp.moon.ossxp.com>
  CommitDate: Mon Nov 29 10:39:35 2010 +0800

      who does commit?

  commit 9e8a761ff9dd343a1380032884f488a2422c495a
  Author:     Jiang Xin <jiangxin@ossxp.com>
  AuthorDate: Sun Nov 28 12:48:26 2010 +0800
  Commit:     Jiang Xin <jiangxin@ossxp.com>
  CommitDate: Sun Nov 28 12:48:26 2010 +0800

      initialized.

最早的提交（下面的提交），提交者信息是由之前设置的环境变量 `user.name` 和 `user.email` 给出的。而最新的提交（上面第一个提交）因为删除了 `user.name` 和 `user.email` ，提交时 Git 对提交者的用户名和邮件地址做了大胆的猜测，这个猜测可能是错的。

为了保证提交时的提交者和作者信息的正确性，重新恢复 `user.name` 和 `user.email` 的设置。记住不要照抄照搬下面的命令，使用您自己的用户名和邮件地址。

::

  $ git config --global user.name "Jiang Xin"
  $ git config --global user.email jiangxin@ossxp.com


然后执行下面的命令，可以对最新的提交重新修改，改正错误的作者和提交者信息。

::

  $ git commit --amend --allow-empty --reset-author

说明：

* 参数 `--amend` 含义是对刚刚的提交进行修补，这样就可以改正前面错误的提交（用户信息错误），而不会产生另外的新提交。
* 参数 `--allow-empty` 是因为要进行修补的提交实际上是一个空白提交，Git 缺省不允许空白提交。
* 参数 `--reset-author` 的含义是将 Author（提交者）的 ID 重置，否则只会影响最新的 Commit（提交者）的 ID。这条命令也会重置 `AuthorDate` 信息。

通过日志，可以看到最新的提交的作者和提交者的信息已经改正了。

::

  $ git log --pretty=fuller
  commit a0c641e92b10d8bcca1ed1bf84ca80340fdefee6
  Author:     Jiang Xin <jiangxin@ossxp.com>
  AuthorDate: Mon Nov 29 11:00:06 2010 +0800
  Commit:     Jiang Xin <jiangxin@ossxp.com>
  CommitDate: Mon Nov 29 11:00:06 2010 +0800

      who does commit?

  commit 9e8a761ff9dd343a1380032884f488a2422c495a
  Author:     Jiang Xin <jiangxin@ossxp.com>
  AuthorDate: Sun Nov 28 12:48:26 2010 +0800
  Commit:     Jiang Xin <jiangxin@ossxp.com>
  CommitDate: Sun Nov 28 12:48:26 2010 +0800

      initialized.

思考：随意设置提交者姓名，是否太不安全？
============================================

使用 CVS, Subversion 等集中式版本控制系统的用户会知道，每次提交的时候需要认证，认证成功后，登录ID就作为提交者ID出现在版本库的提交日志中。很显然，对于 CVS 或 Subversion 这样的版本控制系统，很难冒充他人提交。那么像 Git 这样的分布版本控制系统，可以随心所欲的设定提交者，这似乎太不安全了。

Git 可以随意设置提交的用户名和邮件地址信息，这是因为分布式版本控制系统的特性使然，每个人都是自己版本库的主人，很难也没有必要进行身份认证从而使用经过认证的用户名作为提交的用户名。

在进行“独奏”的时候，还要为自己强制加上一个“指纹识别”实在是太没有必要了。但是团队合作时授权就成为必需了。不过一般来说，设置的 Git 服务器只会在个人向服务器版本库执行推送操作（推送其本地提交）的时候进行身份认证，并不对所推送的提交本身所包含的用户名作出检查。但 Android 项目是个例外。

Android 项目为了更好的使用 Git 实现对代码的集中管理，开发了一套叫做 Gerrit 的审核服务器来管理 Git 提交，对提交者的邮件地址进行审核。例如下面的示例中在向 Gerrit 服务器推送的时候，提交中的提交者邮件地址为 `jiangxin@ossxp.com` ，但是在 Gerrit 中注册用户时使用的邮件地址为 `jiangxin@moon.ossxp.com` 。因为两者不匹配，导致推送失败。

::

  $ git push origin master
  Counting objects: 3, done.
  Writing objects: 100% (3/3), 222 bytes, done.
  Total 3 (delta 0), reused 0 (delta 0)
  To ssh://localhost:29418/new/project.git
   ! [remote rejected] master -> master (you are not committer jiangxin@ossxp.com)
  error: failed to push some refs to 'ssh://localhost:29418/new/project.git'

即使没有使用类似 Gerrit 的服务，作为提交者也不应该随意改变 `user.name` 和 `user.email` 环境变量设置，因为当多人协同时这会给他人造成迷惑，也会给一些项目管理软件造成麻烦。

例如 Redmine 是一款实现需求管理管理和缺陷跟踪的项目管理软件，可以和 Git 版本库实现整合。Git 的提交可以直接关闭 Redmine 上的 Bug，还有 Git 的提交可以反映出项目成员的工作进度。Redmine 中用户（项目成员）是用一个ID做标识，而Git的提交者则表示为一个包含用户名和邮件地址的字符串，如何将 Redmine 的用户和 Git 提交者相关联呢？Redmine 提供了一个配置界面用于设置二者之间的关系。

  .. figure:: images/git-solo/redmine-user-config.png
     :scale: 70
 
显然如果在 Git 提交时随意变更提交者姓名和邮件地址，会破坏 Redmine 软件中设置好的用户对应关系。

思考：命令别名是干什么的？
==========================

在本章的一开始，通过对 `alias.ci` 等 Git 环境变量的设置，为 Git 设置了命令别名。命令别名可以帮助用户解决从其他版本控制系统迁移到 Git 后的使用习惯问题。像 CVS 和 Subversion 在提交的时候，一般习惯使用 `ci` （check in）子命令，在检出的时候则习惯使用 `co` （check out）子命令。如果 Git 不能提供对 `ci` 和 `co` 这类简洁命令的支持，对于拥有其他版本控制系统使用经验的用户来说，Git 的用户体检就会打折扣。幸好聪明的 Git 提供了别名机制，可以满足用户特殊的使用习惯。

本章前面列出的四条别名设置指令，创建的是最常用的几个 Git 别名。实际上别名还可以包含命令参数。例如下面的别名设置指令：

::

  $ git config --global alias.ci "commit -s"

如上设置后，当使用 `git ci` 命令提交的时候，会自动带上 `-s` 参数，这样会在提交的说明中自动添加上包含提交者姓名和邮件地址的签名标识，类似于 `Signed-off-by: User Name <email@address>` 。这对于一些项目（Git, Linux kernel, Android 等）来说是必要甚至是必须的。

不过在本书中会尽量避免使用别名命令，以免由于读者因为尚未设置别名而造成学习上的困惑。

备份本章的工作成果
===================

执行下面的命令，算是对本章工作成果的备份。

::

  $ cd /path/to/my/workspace
  $ git clone demo demo-step-1
  Cloning into demo-step-1...
  done.
