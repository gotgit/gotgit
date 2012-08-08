补丁中的二进制文件
******************

有的时候，需要将对代码的改动以补丁文件的方式进行传递，最终合并入版本库。\
例如直接在软件部署目录内进行改动，再将改动传送到开发平台。或者是因为在某\
个开源软件的官方版本库中没有提交权限，需要将自己的改动以补丁文件的方式提\
供给官方。

关于补丁文件的格式，补丁的生成和应用在第3篇第20章“补丁文件交互”当中已经\
进行了介绍，使用的是\ :command:`git format-patch`\ 和\ :command:`git am`\
命令，但这两个命令仅对Git库有效。如果没有使用Git对改动进行版本控制，而仅\
仅是两个目录：一个改动前的目录和一个改动后的目录，大部分人会选择使用GNU\
的\ :command:`diff`\ 命令及\ :command:`patch`\ 命令实现补丁文件的生成和\
补丁的应用。

但是GNU的\ :command:`diff`\ 命令（包括很多版本控制系统，如SVN的\
:command:`svn diff`\ 命令）生成的差异输出有一个非常大的不足或者说漏洞。\
就是差异输出不支持二进制文件。如果生成了新的二进制文件（如图片），或者\
二进制文件发生了变化，在差异输出中无法体现，当这样的差异文件被导出，应用\
到代码树中，会发现二进制文件或二进制文件的改动丢失了！

Git突破了传统差异格式的限制，通过引入新的差异格式，实现了对二进制文件的\
支持。并且更为神奇的是，不必使用Git版本库对数据进行维护，可以直接对两个\
普通目录进行Git方式的差异比较和输出。

Git版本库中二进制文件变更的支持
================================

对Git工作区的修改进行差异比较（\ :command:`git diff --binary`\ ），可以\
输出二进制的补丁文件。包含二进制文件差异的补丁文件可以通过\
:command:`git apply`\ 命令应用到版本库中。可以通过下面的示例，看看Git的\
补丁文件是如何对二进制文件提供支持的。

* 首先建立一个空的Git版本库。

  ::

    $ mkdir /tmp/test
    $ cd /tmp/test
    $ git init
    initialized empty Git repository in /tmp/test/.git/

    $ git ci --allow-empty -m initialized
    [master (root-commit) 2ca650c] initialized

* 然后在工作区创建一个文本文件\ :file:`readme.txt`\ ，以及一个二进制文件\
  :file:`binary.data`\ 。

  二进制的数据读取自系统中的二进制文件\ :file:`/bin/ls`\ ，当然可以用任\
  何其他二进制文件代替。

  ::

    $ echo hello > readme.txt
    $ dd if=/bin/ls of=binary.data count=1 bs=32
    记录了1+0 的读入
    记录了1+0 的写出
    32字节(32 B)已复制，0.0001062 秒，301 kB/秒

  注：拷贝\ :file:`/bin/ls`\ 可执行文件（二进制）的前32个字节作为\
  :file:`binary.data`\ 文件。

* 如果执行\ :command:`git diff --cached`\ 看到的是未扩展的差异格式。

  ::

    $ git add .
    $ git diff --cached
    diff --git a/binary.data b/binary.data
    new file mode 100644
    index 0000000..dc2e37f
    Binary files /dev/null and b/binary.data differ
    diff --git a/readme.txt b/readme.txt
    new file mode 100644
    index 0000000..ce01362
    --- /dev/null
    +++ b/readme.txt
    @@ -0,0 +1 @@
    +hello

  可以看到对于\ :file:`binary.data`\ ，此差异文件没有给出差异内容，而只\
  是一行“\ ``Binary files ... and ... differ``\ ”。

* 再用\ :command:`git diff --cached --binary`\ 即增加了\ ``--binary``\
  参数试试。

  ::

    $ git diff --cached --binary
    diff --git a/binary.data b/binary.data
    new file mode 100644
    index 0000000000000000000000000000000000000000..dc2e37f81e0fa88308bec48cd5195b6542e61a20
    GIT binary patch
    literal 32
    bcmb<-^>JfjWMqH=CI&kO5HCR00W1UnGBE;C

    literal 0
    HcmV?d00001

    diff --git a/readme.txt b/readme.txt
    new file mode 100644
    index 0000000..ce01362
    --- /dev/null
    +++ b/readme.txt
    @@ -0,0 +1 @@
    +hello

  看到了么，此差异文件给出了二进制文件\ :file:`binary.data`\ 差异的内容，\
  并且差异内容经过\ ``base85``\ 文本化了。

* 提交后，并用新的内容覆盖\ :file:`binary.data`\ 文件。

  ::

    $ git commit -m "new text file and binary file"
    [master 7ab2d01] new text file and binary file
     2 files changed, 1 insertions(+), 0 deletions(-)
     create mode 100644 binary.data
     create mode 100644 readme.txt

    $ dd if=/bin/ls of=binary.data count=1 bs=64
    记录了1+0 的读入
    记录了1+0 的写出
    64字节(64 B)已复制，0.00011264 秒，568 kB/秒

    $ git commit -a -m "change binary.data."
    [master a79bcbe] change binary.data.
     1 files changed, 0 insertions(+), 0 deletions(-)

* 看看更改二进制文件的新差异格式。

  ::

    $ git show HEAD --binary
    commit a79bcbe50c1d278db9c9db8e42d9bc5bc72bf031
    Author: Jiang Xin <jiangxin@ossxp.com>
    Date:   Sun Oct 10 19:22:30 2010 +0800

        change binary.data.

    diff --git a/binary.data b/binary.data
    index dc2e37f81e0fa88308bec48cd5195b6542e61a20..bf948689934caf2d874ff8168cb716fbc2a127c3 100644
    GIT binary patch
    delta 37
    hcmY#zn4qBGzyJX+<}pH93=9qo77QFfQiegA0RUZd1MdI;

    delta 4
    LcmZ=zn4kav0;B;E

* 更简单的，使用\ :command:`git format-patch`\ 命令，直接将最近的两次提\
  交导出为补丁文件。

  ::

    $ git format-patch HEAD^^
    0001-new-text-file-and-binary-file.patch
    0002-change-binary.data.patch


  毫无疑问，这两个补丁文件都包含了对二进制文件的支持。

  ::

    $ cat 0002-change-binary.data.patch 
    From a79bcbe50c1d278db9c9db8e42d9bc5bc72bf031 Mon Sep 17 00:00:00 2001
    From: Jiang Xin <jiangxin@ossxp.com>
    Date: Sun, 10 Oct 2010 19:22:30 +0800
    Subject: [PATCH 2/2] change binary.data.

    ---
     binary.data |  Bin 32 -> 64 bytes
     1 files changed, 0 insertions(+), 0 deletions(-)

    diff --git a/binary.data b/binary.data
    index dc2e37f81e0fa88308bec48cd5195b6542e61a20..bf948689934caf2d874ff8168cb716fbc2a127c3 100644
    GIT binary patch
    delta 37
    hcmY#zn4qBGzyJX+<}pH93=9qo77QFfQiegA0RUZd1MdI;

    delta 4
    LcmZ=zn4kav0;B;E

    --
    1.7.1

**那么如何将补丁合并入代码树呢？**

不能使用GNU\ :command:`patch`\ 命令，因为前面曾经说过GNU的\ :command:`diff`\
和\ :command:`patch`\ 不支持二进制文件的补丁。当然也不支持Git的新的补丁格式。\
将Git格式的补丁应用到代码树，只能使用git命令，即\ :command:`git apply`\ 命令。

接着前面的例子。首先将版本库重置到最近两次提交之前的状态，即丢弃最近的两\
次提交，然后将两个补丁都合并到代码树中。

* 重置版本库到两次提交之前。

  ::

    $ git reset --hard HEAD^^
    HEAD is now at 2ca650c initialized

    $ ls
    0001-new-text-file-and-binary-file.patch  0002-change-binary.data.patch

* 使用\ :command:`git apply`\ 应用补丁。

  ::

    $ git apply 0001-new-text-file-and-binary-file.patch 0002-change-binary.data.patch

* 可以看到64字节长度的\ :file:`binary.data`\ 又回来了。

  ::

    $ ls -l
    总用量 16
    -rw-r--r-- 1 jiangxin jiangxin 754 10月 10 19:28 0001-new-text-file-and-binary-file.patch
    -rw-r--r-- 1 jiangxin jiangxin 524 10月 10 19:28 0002-change-binary.data.patch
    -rw-r--r-- 1 jiangxin jiangxin  64 10月 10 19:34 binary.data
    -rw-r--r-- 1 jiangxin jiangxin   6 10月 10 19:34 readme.txt

* 最后不要忘了提交。

  ::

    $ git add readme.txt binary.data
    $ git commit -m "new text file and binary file from patch files."
    [master 7c1389f] new text file and binary file from patch files.
     2 files changed, 1 insertions(+), 0 deletions(-)
     create mode 100644 binary.data
     create mode 100644 readme.txt

Git对补丁文件的扩展，实际上不只是增加了二进制文件的支持，还提供了对文件\
重命名（\ ``rename from``\ 和\ ``rename to``\ 指令），文件拷贝（\
``copy from``\ 和\ ``copy to``\ 指令），文件删除（\ ``deleted file``\ 指令）\
以及文件权限（\ ``new file mode``\ 和\ ``new mode``\ 指令）的支持。

对非Git版本库中二进制文件变更的支持
=====================================

不在Git版本库中的文件和目录可以比较生成Git格式的补丁文件么，以及可以执行\
应用补丁（apply patch）的操作么？

是的，Git的diff命令和apply命令支持对非Git版本库/工作区进行操作。但是当前\
Git最新版本(1.7.3)的\ :command:`git apply`\ 命令有一个bug，这个bug导致目\
前的\ :command:`git apply`\ 命令只能应用patch level（补丁文件前缀级别）\
为1的补丁。我已经将改正这个Bug的补丁文件提交到Git开发列表中，但有其他人\
先于我修正了这个Bug。不管最终是谁修正的，在新版本的Git中，这个问题应该已\
经解决。参见我发给Git邮件列表的相关讨论。

* http://marc.info/?l=git&m=129058163119515&w=2

下面的示例演示一下如何对非Git版本库使用\ :command:`git diff`\ 和\
:command:`git patch`\ 命令。首先准备两个目录，一个为\ ``hello-1.0``\ 目录，\
在其中创建一个文本文件以及一个二进制文件。

::

  $ mkdir hello-1.0
  $ echo hello > hello-1.0/readme.txt
  $ dd if=/bin/ls of=hello-1.0/binary.dat count=1 bs=32
  记录了1+0 的读入
  记录了1+0 的写出
  32字节(32 B)已复制，0.0001026 秒，312 kB/秒

另外一个\ :file:`hello-2.0`\ 目录，其中的文本文件和二进制文件都有所更改。

::

  $ mkdir hello-2.0
  $ printf "hello\nworld\n" > hello-2.0/readme.txt
  $ dd if=/bin/ls of=hello-2.0/binary.dat count=1 bs=64
  记录了1+0 的读入
  记录了1+0 的写出
  64字节(64 B)已复制，0.0001022 秒，626 kB/秒

然后执行\ :command:`git diff`\ 命令。命令中的\ ``--no-index``\ 参数对于\
不在版本库中的目录/文件进行比较时可以省略。其中还用了\ ``--no-prefix``\
参数，这样就可以生成前缀级别（patch level）为1的补丁文件。

::

  $ git diff --no-index --binary --no-prefix \
        hello-1.0 hello-2.0 > patch.txt
  $ cat patch.txt
  diff --git hello-1.0/binary.dat hello-2.0/binary.dat
  index dc2e37f81e0fa88308bec48cd5195b6542e61a20..bf948689934caf2d874ff8168cb716fbc2a127c3 100644
  GIT binary patch
  delta 37
  hcmY#zn4qBGzyJX+<}pH93=9qo77QFfQiegA0RUZd1MdI;

  delta 4
  LcmZ=zn4kav0;B;E

  diff --git hello-1.0/readme.txt hello-2.0/readme.txt
  index ce01362..94954ab 100644
  --- hello-1.0/readme.txt
  +++ hello-2.0/readme.txt
  @@ -1 +1,2 @@
   hello
  +world

进入到\ :file:`hello-1.0`\ 目录，执行\ :command:`git apply`\ 应用补丁，\
即使\ :file:`hello-1.0`\ 不是一个Git库。

::

  $ cd hello-1.0
  $ git apply ../patch.txt

会惊喜的发现\ :file:`hello-1.0`\ 应用补丁后，已经变得和\ :file:`hello-2.0`\ 一样了。

::

  $ git diff --stat . ../hello-2.0

命令\ :command:`git apply`\ 也支持反向应用补丁。反向应用补丁后，\
:file:`hello-1.0`\ 中文件被还原，和\ :file:`hello-2.0`\ 比较又可以看到差异了。

::

  $ git apply -R ../patch.txt
  $ git diff --stat . ../hello-2.0
   {. => ../hello-2.0}/binary.dat |  Bin 32 -> 64 bytes
   {. => ../hello-2.0}/readme.txt |    1 +
   2 files changed, 1 insertions(+), 0 deletions(-)


其他工具对Git扩展补丁文件的支持
=================================

Git对二进制提供支持的扩展的补丁文件格式，已经成为补丁文件格式的新标准被\
其他一些应用软件所接受。例如Mercual/Hg就提供了对Git扩展补丁格式的支持。

为\ :command:`hg diff`\ 命令增加\ ``--git``\ 参数，实现Git扩展diff格式输出。

::

  $ hg diff --git

Hg的MQ插件提供对Git补丁的支持。

::

  $ cat .hg/patches/1.diff 
  # HG changeset patch
  # User Jiang Xin <worldhello.net AT gmail DOT com>
  # Date 1286711219 -28800
  # Node ID ba66b7bca4baec41a7d29c5cae6bea6d868e2c4b
  # Parent  0b44094c755e181446c65c16a8b602034e65efd7
  new data

  diff --git a/binary.data b/binary.data
  new file mode 100644
  index 0000000000000000000000000000000000000000..dc2e37f81e0fa88308bec48cd5195b6542e61a20
  GIT binary patch
  literal 32
  bc$}+u^>JfjWMqH=CI&kO5HCR00n7&gGBE;C
