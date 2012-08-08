稀疏检出和浅克隆
================

稀疏检出
--------

从1.7.0版本开始Git提供稀疏检出的功能。所谓稀疏检出就是本地版本库检出时不\
检出全部，只将指定的文件从本地版本库检出到工作区，而其他未指定的文件则不\
予检出（即使这些文件存在于工作区，其修改也会被忽略）。

要想实现稀疏检出的功能，必须同时设置\ ``core.sparseCheckout``\ 配置变量，\
并存在文件\ :file:`.git/info/sparse-checkout`\ 。即首先要设置Git配置变量\
``core.sparseCheckout``\ 为\ ``true``\ ，然后编辑\
:file:`.git/info/sparse-checkout`\ 文件，将要检出的目录或文件的路径写入\
其中。其中文件\ :file:`.git/info/sparse-checkout`\ 的格式就和\
:file:`.gitignore`\ 文件格式一样，路径可以使用通配符。

稀疏检出是如何实现的呢？实际上Git在index（即暂存区）中为每个文件提供一个\
名为\ ``skip-worktree``\ 标志位，缺省这个标识位处于关闭状态。如果该标识\
位开启，则无论工作区对应的文件存在与否，或者是否被修改，Git都认为工作区\
该文件的版本是最新的、无变化。Git通过配置文件\
:file:`.git/info/sparse-checkout`\ 定义一个要检出的目录和/或文件列表，\
当前Git的\ :command:`git read-tree`\ 命令及其他基于合并的命令\
（\ :command:`git merge`\ ，\ :command:`git checkout`\ 等等）能够根据该\
配置文件更新index中文件的\ ``skip-worktree``\ 标志位，实现版本库文件的\
稀疏检出。

先来在工作区\ :file:`/path/to/my/workspace`\ 中创建一个示例版本库sparse1，\
创建后的sparse1版本库中包含如下内容：

::

  $ ls -F
  doc1/ doc2/ doc3/
  $ git ls-files -s -v
  H 100644 ce013625030ba8dba906f756967f9e9ca394464a 0     doc1/readme.txt
  H 100644 ce013625030ba8dba906f756967f9e9ca394464a 0     doc2/readme.txt
  H 100644 ce013625030ba8dba906f756967f9e9ca394464a 0     doc3/readme.txt

即版本库sparse1中包含三个目录\ :file:`doc1`\ 、\ :file:`doc2`\ 和\
:file:`doc3`\ 。命令\ :command:`git ls-files`\ 的\ ``-s``\ 参数用于显示\
对象的SHA1哈希值以及所处的暂存区编号。而\ ``-v``\ 参数则还会显示工作区文件\
的状态，每一行命令输出的第一个字符即是文件状态：字母\ ``H``\ 表示文件已被\
暂存，如果是字母\ ``S``\ 则表示该文件\ ``skip-worktree``\ 标志位已开启。

下面我们就来体验一下稀疏检出的功能。

* 修改版本库的Git配置变量\ ``core.sparseCheckout``\ ，将其设置为\
  ``true``\ 。

  ::

    $ git config core.sparseCheckout true

* 设置\ :file:`.git/info/sparse-checkout`\ 的内容，如下：

  ::

    $ printf "doc1\ndoc3\n" > .git/info/sparse-checkout
    $ cat .git/info/sparse-checkout
    doc1
    doc3

* 执行\ :command:`git checkout`\ 命令后，会发现工作区中\ :file:`doc2`\
  目录不见了。

  ::

    $ git checkout
    $ ls -F
    doc1/ doc3/

* 这时如果用\ :command:`git ls-files`\ 命令查看，会发现\ :file:`doc2`\
  目录下的文件被设置了\ ``skip-worktree``\ 标志。

  ::

    $ git ls-files -v
    H doc1/readme.txt
    S doc2/readme.txt
    H doc3/readme.txt

* 修改\ :file:`.git/info/sparse-checkout`\ 的内容，如下：

  ::

    $ printf "doc3\n" > .git/info/sparse-checkout 
    $ cat .git/info/sparse-checkout 
    doc3

* 执行\ :command:`git checkout`\ 命令后，会发现工作区中\ :file:`doc1`\
  目录也不见了。

  ::

    $ git checkout
    $ ls -F
    doc3/

* 这时如果用\ :command:`git ls-files`\ 命令查看，会发现\ :file:`doc1`\
  和\ :file:`doc2`\ 目录下的文件都被设置了\ ``skip-worktree``\ 标志。

  ::

    $ git ls-files -v
    S doc1/readme.txt
    S doc2/readme.txt
    H doc3/readme.txt

* 修改\ :file:`.git/info/sparse-checkout`\ 的内容，使之包含一个星号，即\
  在工作区检出所有的内容。

  ::

    $ printf "*\n" > .git/info/sparse-checkout 
    $ cat .git/info/sparse-checkout 
    *

* 执行\ :command:`git checkout`\ ，会发现所有目录又都回来了。

  ::

    $ git checkout
    $ ls -F
    doc1/ doc2/ doc3/

文件\ :file:`.git/info/sparse-checkout`\ 的文件格式类似于\
:file:`.gitignore`\ 的格式，也支持用感叹号实现反向操作。例如不检出目录\
:file:`doc2`\ 下的文件，而检出其他文件，可以使用下面的语法（注意顺序不能写反）：

::

  *
  !doc2/

注意如果使用命令\ :command:`git checkout -- <file>...`\ ，即不是切换分支\
而是用分支中的文件替换暂存区和工作区的话，则忽略\ ``skip-worktree``\ 标\
志。例如下面的操作中，虽然\ :file:`doc2`\ 被设置为不检出，但是执行\
:command:`git checkout .`\ 命令后，还是所有的目录都被检出了。

::

  $ git checkout .
  $ ls -F
  doc1/ doc2/ doc3/
  $ git ls-files -v
  H doc1/readme.txt
  S doc2/readme.txt
  H doc3/readme.txt
 
如果修改\ :file:`doc2`\ 目录下的文件，或者在\ :file:`doc2`\ 目录下添加新\
文件，Git会视而不见。

::

  $ echo hello >> doc2/readme.txt 
  $ git status
  # On branch master
  nothing to commit (working directory clean)

若此时通过取消\ ``core.sparseCheckout``\ 配置变量的设置而关闭稀疏检出，\
也不会改变目录\ :file:`doc2`\ 下的文件的\ ``skip-worktree``\ 标志。这种\
情况或者通过\ :command:`git update-index --no-skip-worktree -- <file>...`\
来更改index中对应文件的\ ``skip-worktree``\ 标志，或者重新启用稀疏检出\
更改相应文件的检出状态。

在克隆一个版本库时只希望检出部分文件或目录，可以在执行克隆操作的时候使用\
``--no-checkout``\ 或\ ``-n``\ 参数，不进行工作区文件的检出。例如下面的\
操作从前面示例的sparse1版本库克隆到sparse2中，不进行工作区文件的检出。

::

  $ git clone -n sparse1 sparse2
  Cloning into sparse2...
  done.

检出完成后可以发现sparse2的工作区是空的，而且版本库中也不存在\
:file:`index`\ 文件。如果执行\ :command:`git status`\ 命令会看到所有文件\
都被标识为删除。

::

  $ cd sparse2
  $ git status -s
  D  doc1/readme.txt
  D  doc2/readme.txt
  D  doc3/readme.txt

如果希望通过稀疏检出的功能，只检出其中一个目录如\ :file:`doc2`\ ，可以用\
如下方法实现：

::

  $ git config core.sparseCheckout true
  $ printf "doc2\n" > .git/info/sparse-checkout 
  $ git checkout

之后看到工作区中检出了\ :file:`doc2`\ 目录，而其他文件被设置了\
``skip-worktree``\ 标志。

::

  $ ls -F
  doc2/
  $ git ls-files -v
  S doc1/readme.txt
  H doc2/readme.txt
  S doc3/readme.txt


浅克隆
------

上一节介绍的稀疏检出，可以部分检出版本库中的文件，但是版本库本身仍然包含\
所有的文件和历史。如果只对一个大的版本库的最近的部分历史提交感兴趣，而不\
想克隆整个版本库，稀疏检出是解决不了的，而是要采用本节介绍的浅克隆。

实现版本库的浅克隆的非常简单，只需要在执行\ :command:`git clone`\ 或者\
:command:`git fetch`\ 操作时用\ ``--depth <depth>``\ 参数设定要获取的历\
史提交的深度（\ ``<depth>``\ 大于0），就会把源版本库分支上最近的\
``<depth> + 1``\ 个历史提交作为新版本库的全部历史提交。

通过浅克隆方式克隆出来的版本库，每一个提交的SHA1哈希值和源版本库的相同，\
包括提交的根节点也是如次，但是Git通过特殊的实现，使得浅克隆的根节点提交\
看起来没有父提交。正因为浅克隆的提交对象的SHA1哈希值和源版本库一致，所以\
浅克隆版本库可以执行\ :command:`git fetch`\ 或者\ :command:`git pull`\
从源版本库获取新的提交。但是浅克隆版本库也存在着很多限制，如：

* 不能从浅克隆版本库克隆出新的版本库。

* 其他版本库不能从浅克隆获取提交。

* 其他版本库不能推送提交到浅克隆版本库。

* 不要从浅克隆版本库推送提交至其他版本库，除非确认推送的目标版本库包含\
  浅克隆版本库中缺失的全部历史提交，否则会造成目标版本库包含不完整的提交\
  历史导致版本库无法操作。

* 在浅克隆版本库中执行合并操作时，如果所合并的提交出现在浅克隆历史中，则\
  可以顺利合并，否则会出现大量的冲突，就好像和无关的历史进行合并一样。

由于浅克隆包含上述限制，因此浅克隆一般用于对远程版本库的查看和研究，如果\
在浅克隆版本库中进行了提交，最好通过\ :command:`git format-patch`\ 命令\
导出为补丁文件再应用到远程版本库中。

下面的操作使用\ :command:`git clone`\ 命令创建一个浅克隆。注意：源版本库\
如果是本地版本库要使用\ ``file://``\ 协议，若直接接使用本地路径则不会实\
现浅克隆。

::

  $ git clone --depth 2 file:///path/to/repos/hello-world.git shallow1

然后进入到本地克隆目录中，会看到当前分支上只有3个提交。

::

  $ git log  --oneline
  c4acab2 Translate for Chinese.
  683448a Add I18N support.
  d81896e Fix typo: -help to --help.

查看提交的根节点\ ``d81896e``\ ，则会看到该提交实际上也包含父提交。

::

  $ git cat-file -p HEAD^^
  tree f9d7f6b0af6f3fffa74eb995f1d781d3c4876b25
  parent 10765a7ef46981a73d578466669f6e17b73ac7e3
  author user1 <user1@sun.ossxp.com> 1294069736 +0800
  committer user2 <user2@moon.ossxp.com> 1294591238 +0800

  Fix typo: -help to --help.

而查看该提交的父提交，Git会报错。

::

  $ git log 10765a7ef46981a73d578466669f6e17b73ac7e3
  fatal: bad object 10765a7ef46981a73d578466669f6e17b73ac7e3

对于正常的Git版本库来说，如果对象库中一个提交丢失绝对是大问题，版本库不\
可能被正常使用。而浅克隆之所以看起来一切正常，是因为Git使用了类似嫁接\
（下一节即将介绍）的技术。

在浅克隆版本库中存在一个文件\ :file:`.git/shallow`\ ，这个文件中罗列了应\
该被视为提交根节点的提交SHA1哈希值。查看这个文件会看到提交\ ``d81896e``\
正在其中：

::

  $ cat .git/shallow 
  b56bb510a947651e4717b356587945151ac32166
  d81896e60673771ef1873b27a33f52df75f70515
  e64f3a216d346669b85807ffcfb23a21f9c5c187

列在\ :file:`.git/shallow`\ 文件中的提交会构建出对应的嫁接提交，使用类似\
嫁接文件\ :file:`.git/info/grafts`\ （下节讨论）的机制，当Git访问这些对\
象时就好像这些对象是没有父提交的根节点一样。
