Git初始化
**********

创建版本库及第一次提交
========================

您当前使用的是1.5.6或更高版本的Git么？

::

  $ git --version
  git version 1.7.11.2

Git是一个活跃的项目，仍在不断的进化之中，不同Git版本的功能不尽相同。本书\
对Git的介绍涵盖了1.5.6到1.7.11版本，这也是目前Git的主要版本。如果您使用\
的Git版本低于1.5.6，那么请升级到1.5.6或更高的版本。本书示例使用的是1.7.11.2\
版本的Git，我们会尽可能地指出那些低版本不兼容的命令及参数。

在开始Git之旅之前，我们需要设置一下Git的环境变量，这个设置是一次性的工作。\
即这些设置会在全局文件（用户主目录下的\ :file:`.gitconfig`\ ）或系统文件\
（\ :file:`/etc/gitconfig`\ ）中做永久的记录。

* 告诉Git当前用户的姓名和邮件地址，配置的用户名和邮件地址将在版本库提交\
  时作为提交者的用户名和邮件地址。

  注意下面的两条命令不要照抄照搬，而是用您自己的用户名和邮件地址代替这里\
  的用户名和邮件地址，否则您的劳动成果（提交内容）可要算到作者的头上了。

  ::

    $ git config --global user.name "Jiang Xin"
    $ git config --global user.email jiangxin@ossxp.com

* 设置一些Git别名，以便可以使用更为简洁的子命令。

  例如：输入\ :command:`git ci`\ 即相当于\ :command:`git commit -s`\ [#]_\ ，输入\
  :command:`git st`\ 即相当于\ :command:`git -p status`\ [#]_\ 。

  - 如果拥有系统管理员权限（可以执行\ :command:`sudo`\ 命令），希望注册\
    的命令别名能够被所有用户使用，可以执行如下命令：

    ::

      $ sudo git config --system alias.br branch
      $ sudo git config --system alias.ci "commit -s"
      $ sudo git config --system alias.co checkout
      $ sudo git config --system alias.st "-p status"

  - 也可以运行下面的命令，只在本用户的全局配置中添加Git命令别名：

    ::

      $ git config --global alias.st status
      $ git config --global alias.ci "commit -s"
      $ git config --global alias.co checkout
      $ git config --global alias.br branch

Git的所有操作，包括创建版本库等管理操作都用\ :command:`git`\ 一个命令即\
可完成，不像其他有的版本控制系统（如Subversion），一些涉及管理的操作要\
使用另外的命令（如\ :command:`svnadmin`\ ）。创建Git版本库，可以直接进入\
到包含数据（文件和子目录）的目录下，通过执行\ :command:`git init`\ 完成\
版本库的初始化。

下面就从一个空目录开始初始化版本库，这个版本库命名为“demo”，这个DEMO版本库\
将贯穿本篇始终。为了方便说明，使用了名为\ :file:`/path/to/my/workspace`\
的目录作为个人的工作区根目录，您可以在磁盘中创建该目录并设置正确的权限。

首先建立一个新的工作目录，进入该目录后，执行\ :command:`git init`\ 创建\
版本库。

::

  $ cd /path/to/my/workspace
  $ mkdir demo
  $ cd demo
  $ git init
  初始化空的 Git 版本库于 /path/to/my/workspace/demo/.git/

实际上，如果Git的版本是1.6.5或更新的版本，可以在\ :command:`git init`\
命令的后面直接输入目录名称，自动完成目录的创建。

:: 

  $ cd /path/to/my/workspace
  $ git init demo 
  初始化空的 Git 版本库于 /path/to/my/workspace/demo/.git/
  $ cd demo

从上面版本库初始化后的输出中，可以看到执行\ :command:`git init`\ 命令在\
工作区创建了隐藏目录\ :file:`.git`\ 。

::

  $ ls -aF
  ./  ../  .git/

这个隐藏的\ :file:`.git`\ 目录就是Git版本库（又叫仓库，repository）。

:file:`.git`\ 版本库目录所在的目录，即\ :file:`/path/to/my/workspace/demo`\
目录称为\ **工作区**\ ，目前工作区除了包含一个隐藏的\ file:`.git`\ 版本库\
目录外空无一物。

下面为工作区中加点料：在工作区中创建一个文件\ :file:`welcome.txt`\ ，\
内容就是一行“\ ``Hello.``\ ”。

::

  $ echo "Hello." > welcome.txt

为了将这个新建立的文件添加到版本库，需要执行下面的命令：

::

  $ git add welcome.txt

切记，到这里还没有完。Git和大部分其他版本控制系统都需要再执行一次提交\
操作，对于Git来说就是执行\ :command:`git commit`\ 命令完成提交。在提交\
过程中需要输入提交说明，这个要求对于Git来说是强制性的，不像其他很多\
版本控制系统（如CVS、Subversion）允许空白的提交说明。在Git提交时，\
如果在命令行不提供提交说明（没有使用\ ``-m``\ 参数），Git会自动打开\
一个编辑器，要求您在其中输入提交说明，输入完毕保存退出。需要说明的是，\
读者要在一定程度上掌握vim或emacs这两种Linux下常用编辑器的编辑技巧，\
否则保存退出也会成为问题。

下面进行提交。为了说明方便，使用\ ``-m``\ 参数直接给出了提交说明。

::

  $ git ci -m "initialized"
  [master（根提交） 7e749cc] initialized
   1 个文件被修改，插入 1 行(+)
   create mode 100644 welcome.txt

从上面的命令及输出可以看出：

* 使用了Git命令别名，即\ :command:`git ci`\ 相当于执行\ :command:`git commit`\ 。\
  在本节的一开始就进行了Git命令别名的设置。

* 通过\ ``-m``\ 参数设置提交说明为："initialized"。该提交说明也显示在命\
  令输出的第一行中。

* 命令输出的第一行还显示了当前处于名为\ ``master``\ 的分支上，提交ID为\
  7e749cc\ [#]_\ ，且该提交是该分支的第一个提交，即根提交（root-commit）。\
  根提交和其他提交的区别在于没有关联的父提交，这会在后面的章节中加以讨论。

* 命令输出的第二行开始显示本次提交所做修改的统计：修改了一个文件，包含一行的插入。

思考：为什么工作区下有一个\ :file:`.git`\ 目录？
==================================================

Git及其他分布式版本控制系统（如Mercurial/Hg、Bazaar）的一个显著特点是，\
版本库位于工作区的根目录下。对于Git来说，版本库位于工作区根目录下的\
:file:`.git`\ 目录中，且仅此一处，在工作区的子目录下则没有任何其他\
跟踪文件或目录。Git的这个设计要比CVS、Subversion这些传统的集中式\
版本控制工具来说方便多了。

看看版本控制系统前辈们是如何对工作区的跟踪进行设计的。通过其各自设计的\
优缺点，我们会更加深刻地体会到Git实现的必要和巧妙。

对于CVS，工作区的根目录及每一个子目录下都有一个\ :file:`CVS`\ 目录，\
:file:`CVS`\ 目录中包含几个配置文件，建立了对版本库的追踪。如\
:file:`CVS`\ 目录下的\ :file:`Entries`\ 文件记录了从版本库检出到工作区的\
文件的名称、版本和时间戳等，这样就可以通过对工作区文件时间戳的改变来判断\
文件是否更改。这样设计的好处是，可以将工作区移动到任何其他目录中，而工作区\
和版本控制服务器的映射关系保持不变，这样工作区依然能够正常工作。甚至还将\
工作区的某个子目录移动到其他位置，形成新的工作区，在新的工作区下仍然可以\
完成版本控制相关的操作。但是缺点也很多，例如工作区文件修改了，因为没有\
原始文件做比对，因此向服务器提交修改的时候只能对整个文件进行传输而不能\
仅传输文件的改动部分，导致从客户端到服务器的网络传输效率降低。还有一个\
风险是信息泄漏。例如Web服务器的目录下如果包含了\ :file:`CVS`\ 目录，\
黑客就可以通过扫描\ :file:`CVS/Entries`\ 文件得到目录下的文件列表，\
由此造成信息泄漏。

对于Subversion来说，工作区的根目录和每一个子目录下都有一个\ :file:`.svn`\
目录。目录\ :file:`.svn`\ 中不但包含了类似CVS的跟踪目录下的配置文件，还\
包含了当前工作区下每一个文件的拷贝。多出文件的原始拷贝让某些svn命令可以\
脱离版本库执行，还可以在由客户端向服务器提交时，仅仅对文件改动的内容进行\
提交，因为改动的文件可以和原始拷贝进行差异比较。但是这么做的缺点除了像CVS\
因为引入\ :file:`CVS`\ 跟踪目录而造成的信息泄漏的风险外，还导致了加倍占用\
工作区的空间。再有一个不方便的地方就是，当在工作区目录下针对文件内容进行\
搜索的时候，会因为\ :file:`.svn`\ 目录下文件的原始拷贝，导致搜索的结果加倍，\
而出现混乱的搜索结果。

有的版本控制系统，在工作区根本就没有任何跟踪文件，例如，某款版本控制的\
商业软件（就不点名了），工作区就非常干净没有任何的配置文件和配置目录。\
但是这样的设计更加糟糕，因为它实际上是由服务器端建立的文件跟踪，在服务器\
端的数据库中保存了一个表格：哪台客户端，在哪个本地目录检出了哪个版本的\
版本库文件。这样做的后果是，如果客户端将工作区移动或改名会导致文件的跟踪\
状态丢失，出现文件状态未知的问题。客户端操作系统重装，也会导致文件跟踪状态\
丢失。

Git的这种设计，将版本库放在工作区根目录下，所有的版本控制操作（除了和\
其他远程版本库之间的互操作）都在本地即可完成，不像Subversion只有寥寥无几\
的几个命令才能脱离网络执行。而且Git也没有CVS和Subversion的安全泄漏问题\
（只要保护好\ :file:`.git`\ 目录），也没有Subversion在本地文件搜索时出现\
搜索结果混乱的问题，甚至Git还提供了一条\
:command:`git grep`\ 命令来更好地搜索工作区的文件内容。

例如作者在本书的Git库中执行下面的命令对版本库中的文件进行内容搜索：

::

  $ git grep "工作区文件内容搜索"
  02-git-solo/010-git-init.rst::command:`git grep`\ 命令来更好地搜索工作区的文件内容。

**当工作区中包含了子目录，在子目录中执行Git命令时，如何定位版本库呢？**

实际上，当在Git工作区目录下执行操作的时候，会对目录依次向上递归查找\
:file:`.git` 目录，找到的\ :file:`.git`\ 目录就是工作区对应的版本库，\
:file:`.git`\ 所在的目录就是工作区的根目录，文件\ :file:`.git/index`\
记录了工作区文件的状态（实际上是暂存区的状态）。

例如在非Git工作区执行\ :command:`git`\ 命令，会因为找不到\ :file:`.git`\
目录而报错。

::

  $ cd /path/to/my/workspace/
  $ git status
  fatal: Not a git repository (or any of the parent directories): .git

如果跟踪一下执行\ :command:`git status`\ 命令时的磁盘访问\ [#]_\ ，\
会看到沿目录依次向上递归的过程。

::

  $ strace -e 'trace=file' git status
  ...
  getcwd("/path/to/my/workspace", 4096)           = 14
  ...
  access(".git/objects", X_OK)            = -1 ENOENT (No such file or directory)
  access("./objects", X_OK)               = -1 ENOENT (No such file or directory)
  ...
  chdir("..")                             = 0
  ...
  access(".git/objects", X_OK)            = -1 ENOENT (No such file or directory)
  access("./objects", X_OK)               = -1 ENOENT (No such file or directory)
  ...
  chdir("..")                             = 0
  ...
  access(".git/objects", X_OK)            = -1 ENOENT (No such file or directory)
  access("./objects", X_OK)               = -1 ENOENT (No such file or directory)
  fatal: Not a git repository (or any of the parent directories): .git

**那么有什么办法知道Git版本库的位置，以及工作区的根目录在哪里呢？**

当在工作区执行\ :command:`git`\ 命令时，上面查找版本库的操作总是默默地执行，\
就好像什么也没有发生的一样。如果希望显示工作区的根目录，Git有一个底层命令\
可以实现。

* 在工作区下建立目录\ :file:`a/b/c`\ ，进入到该目录中。

  ::

    $ cd /path/to/my/workspace/demo/
    $ mkdir -p a/b/c
    $ cd /path/to/my/workspace/demo/a/b/c

* 显示版本库\ :file:`.git`\ 目录所在的位置。

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


**把版本库\ :file:`.git`\ 目录放在工作区，是不是太不安全了？**

从存储安全的角度上来讲，将版本库放在工作区目录下，有点“把鸡蛋装在一个\
篮子里”的味道。如果忘记了工作区中还有版本库，直接从工作区的根执行目录\
删除就会连版本库一并删除，这个风险的确是蛮高的。将版本库和工作区拆开似乎\
更加安全，但是不要忘了之前的讨论，将版本库和工作区拆开，就要引入其他机制\
以便实现版本库对工作区的追踪。

Git克隆可以降低因为版本库和工作区混杂在一起导致的版本库被破坏的风险。\
可以通过克隆版本库，在本机另外的磁盘/目录中建立Git克隆，并在工作区有改动\
提交时，手动或自动地执行向克隆版本库的推送（\ :file:`git push`\ ）操作。\
如果使用网络协议，还可以实现在其他机器上建立克隆，这样就更安全了（双机备份）。\
对于使用Git做版本控制的团队，每个人都是一个备份，因此团队开发中的Git版本库\
更安全，管理员甚至根本无须顾虑版本库存储安全问题。

思考：\ :command:`git config`\ 命令参数的区别？
========================================================

在之前出现的\ :command:`git config`\ 命令，有的使用了\ ``--global``\
参数，有的使用了\ ``--system``\ 参数，这两个参数有什么区别么？执行\
下面的命令，您就明白\ :command:`git config`` 命令实际操作的文件了。

* 执行下面的命令，将打开\ :file:`/path/to/my/workspace/demo/.git/config`\
  文件进行编辑。

  ::

    $ cd /path/to/my/workspace/demo/
    $ git config -e 

* 执行下面的命令，将打开\ :file:`/home/jiangxin/.gitconfig`\
  （用户主目录下的\ :file:`.gitconfig`\ 文件）全局配置文件进行编辑。

  ::

    $ git config -e --global

* 执行下面的命令，将打开\ :file:`/etc/gitconfig`\ 系统级配置文件进行编辑。

  如果Git安装在\ :file:`/usr/local/bin`\ 下，这个系统级的配置文件也可能是在\
  :file:`/usr/local/etc/gitconfig`\ 。

  ::

    $ git config -e --system

Git的三个配置文件分别是版本库级别的配置文件、全局配置文件（用户主目录下）\
和系统级配置文件（\ :file:`/etc`\ 目录下）。其中版本库级别配置文件的\
优先级最高，全局配置文件其次，系统级配置文件优先级最低。这样的优先级\
设置就可以让版本库\ :file:`.git`\ 目录下的\ :file:`config`\ 文件中的\
配置可以覆盖用户主目录下的Git环境配置。而用户主目录下的配置也可以覆盖\
系统的Git配置文件。

执行前面的三个\ :command:`git config`\ 命令，会看到这三个级别配置文件的\
格式和内容，原来Git配置文件采用的是INI文件格式。示例如下：

::

  $ cat /path/to/my/workspace/demo/.git/config
  [core]
          repositoryformatversion = 0
          filemode = true
          bare = false
          logallrefupdates = true

命令\ :command:`git config`\ 可以用于读取和更改INI配置文件的内容。使用命令\
:command:`git config <section>.<key>`\ ，来读取INI配置文件中某个配置的键值。\
例如读取\ ``[core]``\ 小节的\ ``bare``\ 的属性值，可以用如下命令：

::

  $ git config core.bare
  false

如果想更改或设置INI文件中某个属性的值也非常简单，命令格式是：\
:command:`git config <section>.<key> <value>`\ 。可以用如下操作：

::

  $ git config a.b something
  $ git config x.y.z others

如果打开\ :file:`.git/config`\ 文件，会看到如下内容：

::

  [a]
          b = something

  [x "y"]
          z = others

对于类似\ ``[x "y"]``\ 一样的配置小节，会在本书第三篇介绍远程版本库的\
章节中经常遇到。

从上面的介绍中，可以看到使用\ :command:`git config`\ 命令可以非常方便地\
操作INI文件，实际上可以用\ :command:`git config`\ 命令操作任何其他的INI文件。

* 向配置文件\ :file:`test.ini`\ 中添加配置。

  ::

    $ GIT_CONFIG=test.ini git config a.b.c.d "hello, world"

* 从配置文件\ :file:`test.ini`\ 中读取配置。

  ::

    $ GIT_CONFIG=test.ini git config a.b.c.d
    hello, world

后面介绍的git-svn软件，就使用这个技术读写git-svn专有的配置文件。


思考：是谁完成的提交？
=======================

在本章的一开始，先为Git设置了\ ``user.name``\ 和\ ``user.email``\
全局环境变量，如果不设置会有什么结果呢？

执行下面的命令，删除Git全局配置文件中关于\ ``user.name``\ 和\
``user.email``\ 的设置：

::

  $ git config --unset --global user.name
  $ git config --unset --global user.email


这下关于用户姓名和邮件的设置都被清空了，执行下面的命令将看不到输出。

::

  $ git config user.name
  $ git config user.email

下面再尝试进行一次提交，看看提交的过程会有什么不同，以及提交之后\
显示的提交者是谁？

在下面的命令中使用了\ ``--allow-empty``\ 参数，这是因为没有对工作区\
的文件进行任何修改，Git默认不会执行提交，使用了\ ``--allow-empty``\
参数后，允许执行空白提交。

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

喔，因为没有设置\ ``user.name``\ 和\ ``user.email``\ 变量，提交输出\
乱得一塌糊涂。仔细看看上面执行\ ``git commit``\ 命令的输出，原来Git\
提供了详细的帮助指引来告诉如何设置必需的变量，以及如何修改之前提交中\
出现的错误的提交者信息。

看看此时版本库的提交日志，会看到有两次提交。

注意：下面的输出和您的输出肯定会有所不同，一个是提交时间会不一样，再有就\
是由40位十六进制数字组成的提交ID也不可能一样，甚至本书中凡是您亲自完成的\
提交，相关的40位魔幻般的数字ID都会不一样（原因会在后面的章节看到）。因此\
凡是涉及数字ID和作者示例不一致的时候，以读者自己的数字ID为准，作者提供的\
仅是示例和参考，切记切记。

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

最早的提交（下面的提交），提交者的信息是由之前设置的环境变量\ ``user.name``\
和\ ``user.email``\ 给出的。而最新的提交（上面第一个提交）因为删除了\
``user.name``\ 和\ ``user.email``\ ，提交时Git对提交者的用户名和邮件地址\
做了大胆的猜测，这个猜测可能是错的。

为了保证提交时提交者和作者信息的正确性，重新恢复\ ``user.name``\ 和\
``user.email``\ 的设置。记住不要照抄照搬下面的命令，请使用您自己的用户名\
和邮件地址。

::

  $ git config --global user.name "Jiang Xin"
  $ git config --global user.email jiangxin@ossxp.com


然后执行下面的命令，重新修改最新的提交，改正作者和提交者的错误信息。

::

  $ git commit --amend --allow-empty --reset-author

说明：

* 参数\ ``--amend``\ 是对刚刚的提交进行修补，这样就可以改正前面错误的提交\
  （用户信息错误），而不会产生另外的新提交。

* 参数\ ``--allow-empty``\ 是因为要进行修补的提交实际上是一个空白提交，Git\
  默认不允许空白提交。

* 参数\ ``--reset-author``\ 的含义是将Author（提交者）的ID重置，否则只会\
  影响最新的Commit（提交者）的ID。这条命令也会重置\ ``AuthorDate``\ 信息。

通过日志，可以看到最新提交的作者和提交者的信息已经改正了。

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

使用过CVS、Subversion等集中式版本控制系统的用户会知道，每次提交的时候\
须要认证，认证成功后，登录ID就作为提交者ID出现在版本库的提交日志中。\
很显然，对于CVS或Subversion这样的版本控制系统，很难冒充他人提交。那么像\
Git这样的分布式版本控制系统，可以随心所欲的设定提交者，这似乎太不安全了。

Git可以随意设置提交的用户名和邮件地址信息，这是分布式版本控制系统的特性\
使然，每个人都是自己版本库的主人，很难也没有必要进行身份认证从而使用经过\
认证的用户名作为提交的用户名。

在进行“独奏”的时候，还要为自己强制加上一个“指纹识别”实在是太没有必要了。\
但是团队合作时授权就成为必需了。不过一般来说，设置的Git服务器只会在个人\
向服务器版本库执行推送操作（推送其本地提交）的时候进行身份认证，并不对\
所推送的提交本身所包含的用户名作出检查。但Android项目是个例外。

Android项目为了更好的使用Git实现对代码的集中管理，开发了一套叫做Gerrit\
的审核服务器来管理Git提交，对提交者的邮件地址进行审核。例如下面的示例中\
在向Gerrit服务器推送的时候，提交中的提交者邮件地址为\
``jiangxin@ossxp.com``\ ，但是在Gerrit中注册用户时使用的邮件地址为\
``jiangxin@moon.ossxp.com``\ 。因为两者不匹配，从而导致推送失败。

::

  $ git push origin master
  Counting objects: 3, done.
  Writing objects: 100% (3/3), 222 bytes, done.
  Total 3 (delta 0), reused 0 (delta 0)
  To ssh://localhost:29418/new/project.git
   ! [remote rejected] master -> master (you are not committer jiangxin@ossxp.com)
  error: failed to push some refs to 'ssh://localhost:29418/new/project.git'

即使没有使用类似Gerrit的服务，作为提交者也不应该随意改变\ ``user.name``\
和\ ``user.email``\ 的环境变量设置，因为当多人协同时这会给他人造成迷惑，\
也会给一些项目管理软件造成麻烦。

例如Redmine是一款实现需求管理和缺陷跟踪的项目管理软件，可以和Git版本库\
实现整合。Git的提交可以直接关闭Redmine上的Bug，还有Git的提交可以反映出\
项目成员的工作进度。Redmine中的用户（项目成员）是用一个ID做标识，而Git\
的提交者则用一个包含用户名和邮件地址的字符串，如何将Redmine的用户和Git\
提交者相关联呢？Redmine提供了一个配置界面用于设置二者之间的关系，\
如图4-1所示。

  .. figure:: /images/git-solo/redmine-user-config.png
     :scale: 70

     图 4‑1：Redmine中用户ID和Git提交者关联
 
显然如果在Git提交时随意变更提交者的姓名和邮件地址，会破坏Redmine软件\
中设置好的用户对应关系。

思考：命令别名是干什么的？
==========================

在本章的一开始，通过对\ ``alias.ci``\ 等Git环境变量的设置，为Git设置了\
命令别名。命令别名可以帮助用户解决从其他版本控制系统迁移到Git后的使用\
习惯问题。像CVS和Subversion在提交的时候，一般习惯使用\ ``ci``\
（check in）子命令，在检出的时候则习惯使用\ ``co``\ （check out）子命令。\
如果Git不能提供对\ ``ci``\ 和\ ``co``\ 这类简洁命令的支持，对于拥有其他\
版本控制系统使用经验的用户来说，Git的用户体检就会打折扣。幸好聪明的Git\
提供了别名机制，可以满足用户特殊的使用习惯。

本章前面列出的四条别名设置指令，创建的是最常用的几个Git别名。实际上别名\
还可以包含命令参数。例如下面的别名设置指令：

::

  $ git config --global alias.ci "commit -s"

如上设置后，当使用\ ``git ci``\ 命令提交的时候，会自动带上\ ``-s``\ 参数，\
这样会在提交的说明中自动添加上包含提交者姓名和邮件地址的签名标识，类似于\
``Signed-off-by: User Name <email@address>``\ 。这对于一些项目\
（Git、Linux kernel、Android等）来说是必要甚至是必须的。

不过在本书会尽量避免使用别名命令，以免由于读者因为尚未设置别名而造成学习\
上的困惑。

备份本章的工作成果
===================

执行下面的命令，算是对本章工作成果的备份。

::

  $ cd /path/to/my/workspace
  $ git clone demo demo-step-1
  Cloning into demo-step-1...
  done.

----

.. [#] 命令\ :command:`git commit -s`\ 中的参数\ ``-s``\ 含义为在提交\
   说明的最后添加“Signed-off-by:”签名。

.. [#] 命令\ :command:`git -p status`\ 中的参数\ ``-p``\ 含义是为\
   :command:`git status`\ 命令的输出添加分页器。

.. [#] 大家实际操作中看到的ID肯定和这里写的不一样，具体原因会在后面的\
   “6.1 Git对象库探秘”一节中予以介绍。如果碰巧您的操作显示出了同样的ID\
   （78cde45），那么我建议您赶紧去买一张彩票。;)

.. [#] 示例中使用了Linux下的\ :command:`strace`\ 命令跟踪系统调用，在\
   Mac OS X下则可使用\ :command:`sudo dtruss git status`\ 命令跟踪相关Git\
   操作的系统调用。
