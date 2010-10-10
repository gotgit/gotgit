补丁中的二进制文件
==================

有的时候，需要将对代码的改动以补丁文件的方式进行传递，最终合并入版本库。例如直接在软件部署目录内进行改动，再将改动传送到开发平台。或者是因为在某个开源软件的官方版本库中没有提交权限，需要将自己的改动以补丁文件的方式提供给官方。

关于补丁文件的格式，补丁的生成和应用在我们第一章 TODO 已经进行了介绍，使用的是 Gnu diff 和 patch 命令。很多版本控制系统也可以生成 GNU 兼容的 diff 文件，例如 `svn diff` 命令。但是 GNU 的 diff 格式有一个不足：不支持二进制文件。即如果有二进制文件发生了变化或者增加了新的二进制文件，在差异文件中无法体现，这样的差异文件应用到代码树中，二进制文件丢失了！

Git 突破了传统 DIFF 格式的限制，通过引入新的 DIFF 格式，实现了对二进制文件的支持。

我们可以通过下面的示例，看看 Git 是如何对二进制文件进行支持的。

* 首先我们建立一个空的 Git 版本库

  ::

    $ mkdir /tmp/test
    $ cd /tmp/test
    $ git init
    initialized empty Git repository in /tmp/test/.git/

    $ git ci --allow-empty -m initialized
    [master (root-commit) 2ca650c] initialized

* 然后我们在工作区创建一个文本文件 `readme.txt` ，以及一个二进制文件 `binary.data`

  ::

    $ echo hello > readme.txt
    $ dd if=/bin/ls of=binary.data count=1 bs=32
    记录了1+0 的读入
    记录了1+0 的写出
    32字节(32 B)已复制，0.0001062 秒，301 kB/秒

  注：我们拷贝 `/bin/ls` 可执行文件（二进制）的前32个字节作为 `binary.data` 文件。

* 如果我们执行 `git diff --cached` 我们看到的是未扩展的 DIFF 格式。

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

  我们可以看到对于 `binary.data` ，此差异文件没有给出差异内容，而只是一行 "Binary files ... and ... differ"。

* 我们再用 `git diff --cached --binary` 即增加了 --binary 参数试试。

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

  看到了么，此差异文件给出了二进制文件 `binary.data` 差异的内容，并且差异内容经过 base85 文本化了。

* 提交后，并用新的内容覆盖 `binary.data` 文件。

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

* 我们看看更改二进制文件的新 DIFF 格式

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

* 更简单的，我们使用 `git format-patch` 命令，直接将最近的两次提交导出为补丁文件。

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

**那么如何将补丁合并如代码树呢？**

不能使用 GNU `patch` 命令，因为前面我们说过 GNU 的 `diff` 和 `patch` 不支持二进制文件的补丁。当然也不支持 Git 的新的补丁格式。将 git 格式的补丁应用到代码树，只能使用 git 命令，即 `git apply` 命令。

我们可以接着前面的例子。首先我们将版本库重置到最近两次提交之前的状态，即丢弃最近的两次提交，然后将两个补丁都合并到代码树中。

* 重置版本库到两次提交之前。

  ::

    $ git reset --hard HEAD^^
    HEAD is now at 2ca650c initialized

    $ ls
    0001-new-text-file-and-binary-file.patch  0002-change-binary.data.patch

* 使用 `git apply` 应用补丁。

  ::

    $ git apply 0001-new-text-file-and-binary-file.patch 0002-change-binary.data.patch

* 可以看到 64 字节长度的 `binary.data` 又回来了。

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

Git 对补丁文件的扩展，实际上不只是增加了二进制文件的支持，还提供了对文件重命名（rename from 和 rename to 指令），文件拷贝（copy from 和 copy to 指令），文件删除（deleted file 指令）以及文件权限（new file mode 和 new mode 指令）的支持。

**其它工具对 Git 扩展补丁文件的支持**

遗憾的是，至今(2010/10) GNU 的 diff 和 patch 命令都没有提供对 Git 扩展补丁格式的支持。不过有其它工具已经提供了对 Git 扩展补丁格式的支持。

Mercual/Hg 支持 Git 扩展补丁格式。

* 为 `hg diff` 命令增加 `--git` 参数，实现 Git 扩展 diff 格式输出。

  ::

    $ hg diff --git

* Hg 的 MQ 插件提供对 Git 补丁的支持。

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

