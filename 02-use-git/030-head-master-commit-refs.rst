实践三：版本库对象探秘
**********************

在“实践二”中，学习了 Git 的一个最重要的概念：暂存区（stage, index）。暂存区是一个介于工作区和版本库的中间状态，当执行提交时实际上是将暂存区的内容提交到版本库中，而且 Git 很多命令都会涉及到暂存区的概念，例如: "git diff" 命令。但是“实践二”还是留下了很多疑惑，例如什么是 HEAD？什么是 master？为什么在“实践二”中它们二者可以相互替换使用？为什么 Git 中的很多对象像提交、树、文件内容等都用 40位的 SHA1 哈希值来表示？这一章的内容将会揭开这些奥秘，并且还会画出一个更为精确的版本库结构图。

首先解决对 40 位 SHA1 哈希值的困惑。先看看在哪些地方包含 SHA1 哈希值：

::

  $ git log -1 --pretty=raw 
  commit e695606fc5e31b2ff9038a48a3d363f4c21a3d86
  tree f58da9a820e3fd9d84ab2ca2f1b467ac265038f9
  parent a0c641e92b10d8bcca1ed1bf84ca80340fdefee6
  author Jiang Xin <jiangxin@ossxp.com> 1291022581 +0800
  committer Jiang Xin <jiangxin@ossxp.com> 1291022581 +0800

      which version checked in?

一个提交中居然包含了三个哈希值表示的对象ID。

* commit e695606fc5e31b2ff9038a48a3d363f4c21a3d86

  这是本次提交的唯一标识。

* tree f58da9a820e3fd9d84ab2ca2f1b467ac265038f9

  这是本次提交所对应的目录树。

* parent a0c641e92b10d8bcca1ed1bf84ca80340fdefee6

  这是本地提交的父提交（上一次提交）。

研究 Git 对象Id 的一个重量级武器就是 "git cat-file" 命令。用下面的命令可以查看一下这三个Id的类型。

::

  $ git cat-file -t e695606
  commit
  $ git cat-file -t f58d
  tree
  $ git cat-file -t a0c6
  commit

在引用对象ID的时候，没有必要把整个40位ID写全，只需要从头开始的几位不冲突即可。

下面再用 "git cat-file" 命令查看一下这几个对象的内容。

* commit 对象 e695606fc5e31b2ff9038a48a3d363f4c21a3d86

  ::

    $ git cat-file -p e695606
    tree f58da9a820e3fd9d84ab2ca2f1b467ac265038f9
    parent a0c641e92b10d8bcca1ed1bf84ca80340fdefee6
    author Jiang Xin <jiangxin@ossxp.com> 1291022581 +0800
    committer Jiang Xin <jiangxin@ossxp.com> 1291022581 +0800

    which version checked in?


* tree 对象 f58da9a820e3fd9d84ab2ca2f1b467ac265038f9

  ::

    $ git cat-file -p f58da9a
    100644 blob fd3c069c1de4f4bc9b15940f490aeb48852f3c42    welcome.txt


* commit 对象 a0c641e92b10d8bcca1ed1bf84ca80340fdefee6

  ::

    $ git cat-file -p a0c641e
    tree 190d840dd3d8fa319bdec6b8112b0957be7ee769
    parent 9e8a761ff9dd343a1380032884f488a2422c495a
    author Jiang Xin <jiangxin@ossxp.com> 1290999606 +0800
    committer Jiang Xin <jiangxin@ossxp.com> 1290999606 +0800

    who does commit?

在上面目录树（tree）对象中看到了一个新的类型的对象：blob 对象。这个对象保存着文件 `welcome.txt` 的内容。用 "git cat-file" 研究一下。

::

  $ git cat-file -t fd3c069c1de4f4bc9b15940f490aeb48852f3c42
  blob
  $ git cat-file -p fd3c069c1de4f4bc9b15940f490aeb48852f3c42
  Hello.
  Nice to meet you.

这些对象保存在哪里？当然是 Git 库中的 objects 目录下了（ID的前2位作为目录名，后38位作为文件名）。用下面的命令可以看到这些对象在对象库中的实际位置。

::

  $ for id in e695606 f58da9a a0c641e fd3c069; do \
    ls .git/objects/${id:0:2}/${id:2}*; done
  .git/objects/e6/95606fc5e31b2ff9038a48a3d363f4c21a3d86
  .git/objects/f5/8da9a820e3fd9d84ab2ca2f1b467ac265038f9
  .git/objects/a0/c641e92b10d8bcca1ed1bf84ca80340fdefee6
  .git/objects/fd/3c069c1de4f4bc9b15940f490aeb48852f3c42

下面的图示更加清楚的显示了 Git 对象库中各个对象之间的关系。

  .. figure:: images/gitbook/git-objects.png
     :scale: 100

从上面的图示中很明显的看出提交（Commit）对象之间相互关联，很容易的识别出一条跟踪链。这条跟踪链可以在运行 "git log" 命令时，通过使用 "--graph" 参数看到。使用 "--pretty=raw" 参数以便显示每个提交对象的 parent 属性。

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

最后一个提交没有 parent 属性，所以跟踪链到此终结，这实际上就是提交的起点。

**现在来看看 HEAD 和 master 的奥秘吧**

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

看看文件 ".git/refs/heads/master" 的内容。
::

  $ cat .git/refs/heads/master 
  e695606fc5e31b2ff9038a48a3d363f4c21a3d86

显示的 "e695606..." 所指为何物？用 "git cat-file" 命令进行查看。

* 显示 SHA1 哈希值指代的数据类型。

  :: 

    $ git cat-file -t e695606

* 显示 SHA1-ID 的内容。

  :: 

    $ git cat-file -p e695606fc5e31b2ff9038a48a3d363f4c21a3d86
    tree f58da9a820e3fd9d84ab2ca2f1b467ac265038f9
    parent a0c641e92b10d8bcca1ed1bf84ca80340fdefee6
    author Jiang Xin <jiangxin@ossxp.com> 1291022581 +0800
    committer Jiang Xin <jiangxin@ossxp.com> 1291022581 +0800

    which version checked in?

原来分支 master 指向的是一个提交ID（最新提交）。这样的分支实现是多么的巧妙啊，既然可以从任何提交开始建立一条历史跟踪链，那么用一个文件指向这个链条的最新提交，那么这个文件就可以用于追踪提交历史了。这个文件就是 ".git/refs/heads/master" 文件。

下面看一个更接近于真实的版本库结构图：

  .. figure:: images/gitbook/git-repos-detail.png
     :scale: 100

目录 ".git/refs" 是保存引用的命名空间，其中 ".git/refs/heads" 目录下的引用又称为分支。对于分支既可以使用正规的长格式的表示法，如 "refs/heads/master"，也可以去掉前面的两级目录用 "master" 来表示。Git 有一个底层命令 "git rev-parse" 可以用于显示引用对应的提交 ID。

::

  $ git rev-parse master
  e695606fc5e31b2ff9038a48a3d363f4c21a3d86
  $ git rev-parse refs/heads/master
  e695606fc5e31b2ff9038a48a3d363f4c21a3d86
  $ git rev-parse HEAD
  e695606fc5e31b2ff9038a48a3d363f4c21a3d86

可以看出它们都指向同一个对象。为什么这个对象是40位，而不是更少或者更多？这些 Id 是如何生成的呢？

问题：SHA1 哈希值到底是什么，如何生成的？
==========================================

哈希(hash)是一种数据摘要算法（或称散列算法），是信息安全领域当中重要的理论基石。该算法将任意长度的输入经过散列运算转换为固定长度的输出。固定长度的输出可以称为对应的输入的数字摘要或哈希值。例如 SHA1 摘要算法可以处理从零到一千多万个TB的输入数据，输出为固定的 160 比特的数字摘要。两个不同内容的输入即使数据量非常大、差异非常小，两者的哈希值也会显著不同。比较著名的摘要算法有：MD5 和 SHA1。Linux 下 `sha1sum` 命令可以用于生成摘要。

::

  $ echo -n Git |sha1sum
  5819778898df55e3a762f0c5728b457970d72cae  -

可以看出字符串 "Git" 的 SHA1 哈希值为 40 个十六进制的数字组成。那么能不能找出另外一个字符串使其 SHA1 哈希值和上面的哈希值一样呢？下面看看难度有多大。

每个十六进制的数字用于表示一个4位的二进制数字，因此此 SHA1 哈希值的输出为实为 160 bit。可以打一个比喻，要想制造相同的 SHA1 哈希值就相当于要选出32个“红色球”，每个红球有1到32个选择，而且红球之间可以重复。相比“双色球博彩”总共只需选出7颗球，SHA1 “中奖”的难度就相当于要连续买五期“双色球”而且每一期都要中一等奖。当然由于算法上的问题，制造冲突（重复）的摘要的几率没有那么小，但是已经足够小，能够满足 Git 对不同对象的进行区分和标识了。即使有一天真的发现了冲突的可能，Git 也可以使用更为安全的 SHA-256 或者 SHA-512 的摘要算法。

那么 Git 中的各种对象：提交（commit）、文件内容（blob）、目录树（tree）等（还有 Tag）对象对应的 SHA1 哈希值是如何生成的呢？下面就来展示一下。

提交的 SHA1 哈希值生成方法。

* 看看 HEAD 对应的提交的内容。使用 "git cat-file" 命令。

  ::

    $ git cat-file commit HEAD
    tree f58da9a820e3fd9d84ab2ca2f1b467ac265038f9
    parent a0c641e92b10d8bcca1ed1bf84ca80340fdefee6
    author Jiang Xin <jiangxin@ossxp.com> 1291022581 +0800
    committer Jiang Xin <jiangxin@ossxp.com> 1291022581 +0800

    which version checked in?

* 提交信息中总共包含 234 个字符。

  ::

    $ git cat-file commit HEAD | wc -c
    234

* 在提交信息的前面加上内容 "commit 234<null>" （<null>为空字符），然后执行 SHA1 哈希算法。

  ::

    $ ( printf "commit 234\000"; git cat-file commit HEAD ) | sha1sum
    e695606fc5e31b2ff9038a48a3d363f4c21a3d86  -

* 上面命令得到的哈希值和用 "git rev-parse" 看到的是一样的。

  ::

    $ git rev-parse HEAD
    e695606fc5e31b2ff9038a48a3d363f4c21a3d86

下面看一看文件内容的 SHA1 哈希值生成方法。

* 看看版本库中 welcome.txt 的内容。使用 "git cat-file" 命令。

  ::

    $ git cat-file blob HEAD:welcome.txt 
    Hello.
    Nice to meet you.

* 文件总共包含 25 字节的内容。

  ::

    $ git cat-file blob HEAD:welcome.txt | wc -c
    25

* 在文件内容的前面加上 "blob 25<null>" 的内容，然后执行 SHA1 哈希算法。

  ::

    $ ( printf "blob 25\000"; git cat-file blob HEAD:welcome.txt ) | sha1sum
    fd3c069c1de4f4bc9b15940f490aeb48852f3c42  -

* 上面命令得到的哈希值和用 "git rev-parse" 看到的是一样的。

  ::

    $ git rev-parse HEAD:welcome.txt
    fd3c069c1de4f4bc9b15940f490aeb48852f3c42

最后再来看看树的 SHA1 哈希值的形成方法。

* HEAD 对应的树的内容共包含 39 个字节。

  ::

    $ git cat-file tree HEAD^{tree} | wc -c
    39

* 在树的内容的前面加上 "tree 39<null>" 的内容，然后执行 SHA1 哈希算法。

  ::

    $ ( printf "tree 39\000"; git cat-file tree HEAD^{tree} ) | sha1sum
    f58da9a820e3fd9d84ab2ca2f1b467ac265038f9  -

* 上面命令得到的哈希值和用 "git rev-parse" 看到的是一样的。

  ::

    $ git rev-parse HEAD^{tree}
    f58da9a820e3fd9d84ab2ca2f1b467ac265038f9

在后面学习 Tag 的时候，会看到注释Tag也是采用类似方法在对象库中存储的。

问题：为什么不用顺序的数字来表示提交？
========================================

到目前为止进行的提交都是顺序提交，这可能让读者产生这么一个想法，为什么 Git 的提交不依据提交顺序对提交进行编号呢？可以把第一次提交为提交1，依次递增。尤其是对于拥有像 Subversion 等集中式版本控制系统使用经验的用户更会有这样的体会和想法。

集中式版本控制系统因为只有一个集中式的版本库，可以很容易的实现全局唯一的提交号，像 Subversion 就是如此。Git 作为分布式版本控制系统，开发可以是非线性的，每个人可以通过克隆工作在不同的本地版本库当中，在本地做的提交可以通过版本库之间的交互而互相分发，如果提交采用本地唯一的数字编号，在提交分发的时候不可避免的造成冲突。这就要求提交的编号不能仅仅是本地局部有效，而是要“全球唯一”。Git 的提交通过 SHA1 哈希值作为提交ID，的确做到了“全球唯一”。

Mercurial(Hg) 是另外一个著名的分布式版本控制系统，它的提交Id非常有趣：同时使用了顺序的数字编号和“全球唯一”的SHA1哈希值。但实际上顺序的数字编号只是本地有效，对于克隆版本库来说没有意义，只有SHA1哈希值才是通用的编号。

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

Hg的设计使得本地使用版本库更为方便，但是要在Git中做类似实现却很难，这是因为Git相比Hg拥有真正的分支管理功能。在Git中会存在当前分支中看不到的其他分支的提交，如何进行提交编号的管理十分的复杂。

幸好Git提供很多方法可以方便的访问Git库中的对象。

* 采用部分的 SHA1 哈希值。不必写全40位的哈希值，只采用开头的部分，不和现有其他的冲突即可。
* 使用 `master` 代表分支 `master` 中最新的提交，使用全称 `refs/heads/master` 亦可。
* 使用 `HEAD` 代表版本库中最近的一次提交。
* 符号 ^ 可以用于指代父提交。例如：

  - `HEAD^` 代表版本库中上一次提交，即最近一次提交的父提交。
  - `HEAD^^` 则代表 `HEAD^` 的父提交。
  - 如果提交 `a573106` 是多个分支的合并，则该提及会包含多个父提交。用 `a573106^2` 指代其第二个父提交。
  
* 符号 ~<n> 也可以用于指代祖先提交。例如：

  `a573106~5` 即相当于 `a573106^^^^^` 。

* 提交所对应的树对象，可以用类似如下的语法访问。

  `a573106^{tree}`

* 某一此提交对应的文件对象，可以用如下的语法访问。

  `a573106:path/to/file`

* 暂存区中的文件对象，可以用如下的语法访问。

  `:path/to/file`

读者可以对本地版本库练习一下：

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

在后面的介绍中，还会了解更多访问Git对象的技巧。例如使用 tag 和日期访问版本库对象。
