Git对象
********

在上一章学习了Git的一个最重要的概念：暂存区（stage，亦称index）。暂存区\
是一个介于工作区和版本库的中间状态，当执行提交时实际上是将暂存区的内容\
提交到版本库中，而且Git很多命令都会涉及到暂存区的概念，例如：\
:command:`git diff`\ 命令。

但是上一章还是留下了很多疑惑，例如什么是HEAD？什么是master？为什么它们二\
者（在上一章）可以相互替换使用？为什么Git中的很多对象像提交、树、文件内容\
等都用40位的SHA1哈希值来表示？这一章的内容将会揭开这些奥秘，并且还会画出\
一个更为精确的版本库结构图。

Git对象库探秘
=====================

在前面刻意回避了对提交ID的说明，现在是时候来揭开由40位十六进制数字组成的\
“魔幻数字”的奥秘了。

通过查看日志的详尽输出，会惊讶的看到非常多的“魔幻数字”，这些“魔幻数字”\
实际上是SHA1哈希值。

::

  $ git log -1 --pretty=raw 
  commit e695606fc5e31b2ff9038a48a3d363f4c21a3d86
  tree f58da9a820e3fd9d84ab2ca2f1b467ac265038f9
  parent a0c641e92b10d8bcca1ed1bf84ca80340fdefee6
  author Jiang Xin <jiangxin@ossxp.com> 1291022581 +0800
  committer Jiang Xin <jiangxin@ossxp.com> 1291022581 +0800

      which version checked in?

一个提交中居然包含了三个SHA1哈希值表示的对象ID。

* \ ``commit e695606fc5e31b2ff9038a48a3d363f4c21a3d86``

  这是本次提交的唯一标识。

* \ ``tree f58da9a820e3fd9d84ab2ca2f1b467ac265038f9``

  这是本次提交所对应的目录树。

* \ ``parent a0c641e92b10d8bcca1ed1bf84ca80340fdefee6``

  这是本地提交的父提交（上一次提交）。

研究Git对象ID的一个重量级武器就是\ :command:`git cat-file`\ 命令。用下面\
的命令可以查看一下这三个ID的类型。

::

  $ git cat-file -t e695606
  commit
  $ git cat-file -t f58d
  tree
  $ git cat-file -t a0c6
  commit

在引用对象ID的时候，没有必要把整个40位ID写全，只需要从头开始的几位不冲突即可。

下面再用\ :command:`git cat-file`\ 命令查看一下这几个对象的内容。

* commit对象\ ``e695606fc5e31b2ff9038a48a3d363f4c21a3d86``

  ::

    $ git cat-file -p e695606
    tree f58da9a820e3fd9d84ab2ca2f1b467ac265038f9
    parent a0c641e92b10d8bcca1ed1bf84ca80340fdefee6
    author Jiang Xin <jiangxin@ossxp.com> 1291022581 +0800
    committer Jiang Xin <jiangxin@ossxp.com> 1291022581 +0800

    which version checked in?


* tree对象\ ``f58da9a820e3fd9d84ab2ca2f1b467ac265038f9``

  ::

    $ git cat-file -p f58da9a
    100644 blob fd3c069c1de4f4bc9b15940f490aeb48852f3c42    welcome.txt


* commit对象\ ``a0c641e92b10d8bcca1ed1bf84ca80340fdefee6``

  ::

    $ git cat-file -p a0c641e
    tree 190d840dd3d8fa319bdec6b8112b0957be7ee769
    parent 9e8a761ff9dd343a1380032884f488a2422c495a
    author Jiang Xin <jiangxin@ossxp.com> 1290999606 +0800
    committer Jiang Xin <jiangxin@ossxp.com> 1290999606 +0800

    who does commit?

在上面目录树（tree）对象中看到了一个新的类型的对象：blob对象。这个对象保存\
着文件\ :file:`welcome.txt`\ 的内容。用\ :command:`git cat-file`\ 研究一下。

* 该对象的类型为blob。

  ::

    $ git cat-file -t fd3c069c1de4f4bc9b15940f490aeb48852f3c42
    blob

* 该对象的内容就是\ :file:`welcome.txt`\ 文件的内容。

  ::

    $ git cat-file -p fd3c069c1de4f4bc9b15940f490aeb48852f3c42
    Hello.
    Nice to meet you.

这些对象保存在哪里？当然是Git库中的\ :file:`objects`\ 目录下了（ID的前两\
位作为目录名，后38位作为文件名）。用下面的命令可以看到这些对象在对象库中\
的实际位置。

::

  $ for id in e695606 f58da9a a0c641e fd3c069; do \
    ls .git/objects/${id:0:2}/${id:2}*; done
  .git/objects/e6/95606fc5e31b2ff9038a48a3d363f4c21a3d86
  .git/objects/f5/8da9a820e3fd9d84ab2ca2f1b467ac265038f9
  .git/objects/a0/c641e92b10d8bcca1ed1bf84ca80340fdefee6
  .git/objects/fd/3c069c1de4f4bc9b15940f490aeb48852f3c42

下面的图示更加清楚的显示了Git对象库中各个对象之间的关系。

  .. figure:: /images/git-solo/git-objects.png
     :scale: 100

从上面的图示中很明显的看出提交（Commit）对象之间相互关联，通过相互之间的\
关联则很容易的识别出一条跟踪链。这条跟踪链可以在运行\ :command:`git log`\
命令时，通过使用\ ``--graph``\ 参数看到。下面的命令还使用了\ ``--pretty=raw``\
参数以便显示每个提交对象的parent属性。

::

  $ git log --pretty=raw --graph e695606
  * commit e695606fc5e31b2ff9038a48a3d363f4c21a3d86
  | tree f58da9a820e3fd9d84ab2ca2f1b467ac265038f9
  | parent a0c641e92b10d8bcca1ed1bf84ca80340fdefee6
  | author Jiang Xin <jiangxin@ossxp.com> 1291022581 +0800
  | committer Jiang Xin <jiangxin@ossxp.com> 1291022581 +0800
  | 
  |     which version checked in?
  |  
  * commit a0c641e92b10d8bcca1ed1bf84ca80340fdefee6
  | tree 190d840dd3d8fa319bdec6b8112b0957be7ee769
  | parent 9e8a761ff9dd343a1380032884f488a2422c495a
  | author Jiang Xin <jiangxin@ossxp.com> 1290999606 +0800
  | committer Jiang Xin <jiangxin@ossxp.com> 1290999606 +0800
  | 
  |     who does commit?
  |  
  * commit 9e8a761ff9dd343a1380032884f488a2422c495a
    tree 190d840dd3d8fa319bdec6b8112b0957be7ee769
    author Jiang Xin <jiangxin@ossxp.com> 1290919706 +0800
    committer Jiang Xin <jiangxin@ossxp.com> 1290919706 +0800
    
        initialized.

最后一个提交没有parent属性，所以跟踪链到此终结，这实际上就是提交的起点。

**现在来看看HEAD和master的奥秘吧**

因为在上一章的最后执行了\ :command:`git stash`\ 将工作区和暂存区的改动\
全部封存起来，所以执行下面的命令会看到工作区和暂存区中没有改动。

::

  $ git status -s -b
  ## master

说明：上面在显示工作区状态时，除了使用了\ ``-s``\ 参数以显示精简输出外，\
还使用了\ ``-b``\ 参数以便能够同时显示出当前工作分支的名称。这个\ ``-b``\
参数是在Git 1.7.2以后加入的新的参数。

下面的\ :command:`git branch`\ 是分支管理的主要命令，也可以显示当前的\
工作分支。

::

  $ git branch
  * master

在master分支名称前面出现一个星号表明这个分支是当前工作分支。至于为什么没\
有其他分支以及什么叫做分支，会在本书后面的章节揭晓。

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

也就是说在当前版本库中，HEAD、master和refs/heads/master具有相同的指向。\
现在到版本库（\ :file:`.git`\ 目录）中一探它们的究竟。

::

  $ find .git -name HEAD -o -name master 
  .git/HEAD
  .git/logs/HEAD
  .git/logs/refs/heads/master
  .git/refs/heads/master

找到了四个文件，其中在\ :file:`.git/logs`\ 目录下的文件稍后再予以关注，\
现在把目光锁定在\ :file:`.git/HEAD`\ 和\ :file:`.git/refs/heads/master`\
上。

显示一下\ :file:`.git/HEAD`\ 的内容：

::

  $ cat .git/HEAD 
  ref: refs/heads/master

把HEAD的内容翻译过来就是：“指向一个引用：refs/heads/master”。这个引用在\
哪里？当然是文件\ :file:`.git/refs/heads/master`\ 了。

看看文件\ :file:`.git/refs/heads/master`\ 的内容。
::

  $ cat .git/refs/heads/master 
  e695606fc5e31b2ff9038a48a3d363f4c21a3d86

显示的\ ``e695606...``\ 所指为何物？用\ :command:`git cat-file`\ 命令进\
行查看。

* 显示SHA1哈希值指代的数据类型。

  ::

    $ git cat-file -t e695606
    commit

* 显示该提交的内容。

  :: 

    $ git cat-file -p e695606fc5e31b2ff9038a48a3d363f4c21a3d86
    tree f58da9a820e3fd9d84ab2ca2f1b467ac265038f9
    parent a0c641e92b10d8bcca1ed1bf84ca80340fdefee6
    author Jiang Xin <jiangxin@ossxp.com> 1291022581 +0800
    committer Jiang Xin <jiangxin@ossxp.com> 1291022581 +0800

    which version checked in?

原来分支master指向的是一个提交ID（最新提交）。这样的分支实现是多么的巧妙\
啊：既然可以从任何提交开始建立一条历史跟踪链，那么用一个文件指向这个链条\
的最新提交，那么这个文件就可以用于追踪整个提交历史了。这个文件就是\
:file:`.git/refs/heads/master`\ 文件。

下面看一个更接近于真实的版本库结构图：

  .. figure:: /images/git-solo/git-repos-detail.png
     :scale: 100

目录\ :file:`.git/refs`\ 是保存引用的命名空间，其中\ :file:`.git/refs/heads`\
目录下的引用又称为分支。对于分支既可以使用正规的长格式的表示法，如\
:file:`refs/heads/master`\ ，也可以去掉前面的两级目录用\ ``master``\
来表示。Git 有一个底层命令\ :command:`git rev-parse`\ 可以用于显示引用\
对应的提交ID。

::

  $ git rev-parse master
  e695606fc5e31b2ff9038a48a3d363f4c21a3d86
  $ git rev-parse refs/heads/master
  e695606fc5e31b2ff9038a48a3d363f4c21a3d86
  $ git rev-parse HEAD
  e695606fc5e31b2ff9038a48a3d363f4c21a3d86

可以看出它们都指向同一个对象。为什么这个对象是40位，而不是更少或者更多？\
这些ID是如何生成的呢？

问题：SHA1哈希值到底是什么，如何生成的？
==========================================

哈希(hash)是一种数据摘要算法（或称散列算法），是信息安全领域当中重要的理\
论基石。该算法将任意长度的输入经过散列运算转换为固定长度的输出。固定长度\
的输出可以称为对应的输入的数字摘要或哈希值。例如SHA1摘要算法可以处理从零\
到一千多万个TB的输入数据，输出为固定的160比特的数字摘要。两个不同内容的\
输入即使数据量非常大、差异非常小，两者的哈希值也会显著不同。比较著名的摘\
要算法有：MD5和SHA1。Linux下\ :command:`sha1sum`\ 命令可以用于生成摘要。

::

  $ echo -n Git |sha1sum
  5819778898df55e3a762f0c5728b457970d72cae  -

可以看出字符串\ ``Git``\ 的SHA1哈希值为40个十六进制的数字组成。那么能不\
能找出另外一个字符串使其SHA1哈希值和上面的哈希值一样呢？下面看看难度有多\
大。

每个十六进制的数字用于表示一个4位的二进制数字，因此40位的SHA1哈希值的输\
出为实为160bit。拿双色球博彩打一个比喻，要想制造相同的SHA1哈希值就相当于\
要选出32个“红色球”，每个红球有1到32个（5位的二进制数字）选择，而且红球之\
间可以重复。相比“双色球博彩”总共只需选出7颗球，SHA1“中奖”的难度就相当于\
要连续购买五期“双色球”并且必须每一期都要中一等奖。当然由于算法上的问题，\
制造冲突（相同数字摘要）的几率没有那么小，但是已经足够小，能够满足Git对\
不同对象的进行区分和标识了。即使有一天像发现了类似MD5摘要算法漏洞那样，\
发现了SHA1算法存在人为制造冲突的可能，那么Git可以使用更为安全的SHA-256或\
者SHA-512的摘要算法。

可是Git中的各种对象：提交（commit）、文件内容（blob）、目录树（tree）等\
（还有Tag）对象对应的SHA1哈希值是如何生成的呢？下面就来展示一下。

提交的SHA1哈希值生成方法。

* 看看HEAD对应的提交的内容。使用\ :command:`git cat-file`\ 命令。

  ::

    $ git cat-file commit HEAD
    tree f58da9a820e3fd9d84ab2ca2f1b467ac265038f9
    parent a0c641e92b10d8bcca1ed1bf84ca80340fdefee6
    author Jiang Xin <jiangxin@ossxp.com> 1291022581 +0800
    committer Jiang Xin <jiangxin@ossxp.com> 1291022581 +0800

    which version checked in?

* 提交信息中总共包含234个字符。

  ::

    $ git cat-file commit HEAD | wc -c
    234

* 在提交信息的前面加上内容\ ``commit 234<null>``\ （<null>为空字符），\
  然后执行SHA1哈希算法。

  ::

    $ ( printf "commit 234\000"; git cat-file commit HEAD ) | sha1sum
    e695606fc5e31b2ff9038a48a3d363f4c21a3d86  -

* 上面命令得到的哈希值和用\ :command:`git rev-parse`\ 看到的是一样的。

  ::

    $ git rev-parse HEAD
    e695606fc5e31b2ff9038a48a3d363f4c21a3d86

下面看一看文件内容的SHA1哈希值生成方法。

* 看看版本库中\ :file:`welcome.txt`\ 的内容。使用\ :command:`git cat-file`\
  命令。

  ::

    $ git cat-file blob HEAD:welcome.txt 
    Hello.
    Nice to meet you.

* 文件总共包含25字节的内容。

  ::

    $ git cat-file blob HEAD:welcome.txt | wc -c
    25

* 在文件内容的前面加上\ ``blob 25<null>``\ 的内容，然后执行SHA1哈希算法。

  ::

    $ ( printf "blob 25\000"; git cat-file blob HEAD:welcome.txt ) | sha1sum
    fd3c069c1de4f4bc9b15940f490aeb48852f3c42  -

* 上面命令得到的哈希值和用\ :command:`git rev-parse`\ 看到的是一样的。

  ::

    $ git rev-parse HEAD:welcome.txt
    fd3c069c1de4f4bc9b15940f490aeb48852f3c42

最后再来看看树的SHA1哈希值的形成方法。

* HEAD对应的树的内容共包含39个字节。

  ::

    $ git cat-file tree HEAD^{tree} | wc -c
    39

* 在树的内容的前面加上\ ``tree 39<null>``\ 的内容，然后执行SHA1哈希算法。

  ::

    $ ( printf "tree 39\000"; git cat-file tree HEAD^{tree} ) | sha1sum
    f58da9a820e3fd9d84ab2ca2f1b467ac265038f9  -

* 上面命令得到的哈希值和用\ :command:`git rev-parse`\ 看到的是一样的。

  ::

    $ git rev-parse HEAD^{tree}
    f58da9a820e3fd9d84ab2ca2f1b467ac265038f9

在后面学习里程碑（Tag）的时候，会看到Tag对象（轻量级Tag除外）也是采用类\
似方法在对象库中存储的。

问题：为什么不用顺序的数字来表示提交？
========================================

到目前为止所进行的提交都是顺序提交，这可能让读者产生这么一个想法，为什么\
Git的提交不依据提交顺序对提交进行编号呢？可以把第一次提交定义为提交1，依\
次递增。尤其是对于拥有像Subversion等集中式版本控制系统使用经验的用户更会\
有这样的体会和想法。

集中式版本控制系统因为只有一个集中式的版本库，可以很容易的实现依次递增的\
全局唯一的提交号，像Subversion就是如此。Git作为分布式版本控制系统，开发\
可以是非线性的，每个人可以通过克隆版本库的方式工作在不同的本地版本库当中\
，在本地做的提交可以通过版本库之间的交互（推送/push和拉回/pull操作）而互\
相分发，如果提交采用本地唯一的数字编号，在提交分发的时候不可避免的造成冲\
突。这就要求提交的编号不能仅仅是本地局部有效，而是要“全球唯一”。Git的提\
交通过SHA1哈希值作为提交ID，的确做到了“全球唯一”。

Mercurial(Hg)是另外一个著名的分布式版本控制系统，它的提交ID非常有趣：同\
时使用了顺序的数字编号和“全球唯一”的SHA1哈希值。但实际上顺序的数字编号只\
是本地有效，对于克隆版本库来说没有意义，只有SHA1哈希值才是通用的编号。

::

  $ hg log --limit 2
  修改集:      3009:2f1a3a7e8eb0
  标签:        tip
  用户:        Daniel Neuhäuser <dasdasich@gmail.com>
  日期:        Wed Dec 01 23:13:31 2010 +0100
  摘要:        "Fixed" the CombinedHTMLDiff test

  修改集:      3008:2fd3302ca7e5
  用户:        Daniel Neuhäuser <dasdasich@gmail.com>
  日期:        Wed Dec 01 22:54:54 2010 +0100
  摘要:        #559 Add `html_permalink_text` confval

Hg的设计使得本地使用版本库更为方便，但是要在Git中做类似实现却很难，这是\
因为Git相比Hg拥有真正的分支管理功能。在Git中会存在当前分支中看不到的其他\
分支的提交，如何进行提交编号的管理十分的复杂。

幸好Git提供很多方法可以方便的访问Git库中的对象。

* 采用部分的SHA1哈希值。不必写全40位的哈希值，只采用开头的部分，不和现有\
  其他的冲突即可。

* 使用\ ``master``\ 代表分支\ ``master``\ 中最新的提交，使用全称\
  ``refs/heads/master``\ 亦可。

* 使用\ ``HEAD``\ 代表版本库中最近的一次提交。

* 符号` ``^``\ 可以用于指代父提交。例如：

  - ``HEAD^``\ 代表版本库中上一次提交，即最近一次提交的父提交。
  - ``HEAD^^``\ 则代表\ ``HEAD^``\ 的父提交。
  
* 对于一个提交有多个父提交，可以在符号\ ``^``\ 后面用数字表示是第几个父\
  提交。例如：

  - ``a573106^2``\ 含义是提交\ ``a573106``\ 的多个父提交中的第二个父提交。
  - ``HEAD^1``\ 相当于\ ``HEAD^``\ 含义是HEAD多个父提交中的第一个。
  - ``HEAD^^2``\ 含义是\ ``HEAD^``\ （HEAD父提交）的多个父提交中的第二个。

* 符号\ ``~<n>``\ 也可以用于指代祖先提交。下面两个表达式效果等同：

  ::
  
    a573106~5
    a573106^^^^^

* 提交所对应的树对象，可以用类似如下的语法访问。

  ::

    a573106^{tree}

* 某一此提交对应的文件对象，可以用如下的语法访问。

  ::

    a573106:path/to/file

* 暂存区中的文件对象，可以用如下的语法访问。

  ::

    :path/to/file

读者可以使用\ :command:`git rev-parse`\ 命令在本地版本库中练习一下：

::

  $ git rev-parse HEAD
  e695606fc5e31b2ff9038a48a3d363f4c21a3d86
  $ git cat-file -p e695
  tree f58da9a820e3fd9d84ab2ca2f1b467ac265038f9
  parent a0c641e92b10d8bcca1ed1bf84ca80340fdefee6
  author Jiang Xin <jiangxin@ossxp.com> 1291022581 +0800
  committer Jiang Xin <jiangxin@ossxp.com> 1291022581 +0800

  which version checked in?
  $ git cat-file -p e695^
  tree 190d840dd3d8fa319bdec6b8112b0957be7ee769
  parent 9e8a761ff9dd343a1380032884f488a2422c495a
  author Jiang Xin <jiangxin@ossxp.com> 1290999606 +0800
  committer Jiang Xin <jiangxin@ossxp.com> 1290999606 +0800

  who does commit?
  $ git rev-parse e695^{tree}
  f58da9a820e3fd9d84ab2ca2f1b467ac265038f9
  $ git rev-parse e695^^{tree}
  190d840dd3d8fa319bdec6b8112b0957be7ee769

在后面的介绍中，还会了解更多访问Git对象的技巧。例如使用tag和日期访问版本\
库对象。
