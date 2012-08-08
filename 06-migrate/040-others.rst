通用版本库迁移
==============

如果读者的版本控制工具在前面的迁移方案没有涉及到，也不要紧，因为很可能通\
过搜索引擎就能找到一款合适的迁移工具。如果找不到相应的工具，可能是您使用\
的版本控制工具太冷门，或者是一款不提供迁移接口的商业版本控制工具。这时您\
可以通过手工检入的方式或者针对Git提供的版本库导入接口\
:command:`git fast-import`\ 实现版本库导入。

手工检入的方式适合于只有少数几个提交或者对大部分提交历史不关心而只需要对\
少数里程碑版本执行导入。这种版本库迁移方式非常简单，相当于在完成Git版本\
库初始化后，在工作区重复执行：工作区文件清理，文件复制，执行\
:command:`git add -A`\ 添加到暂存区，执行\ :command:`git commit`\ 提交。

但是如果需要将版本库完整的历史全部迁移到新的Git版本库中，手工检入方法就\
不可取了，采用针对\ :command:`git fast-import`\ 编程是一个可以考虑的方法\
。Git提供了一个通用的版本库导入解决方案，即通过向命令\
:command:`git fast-import`\ 传递特定格式的字节流，就可以实现Git版本库的创建。\
工具\ :command:`git fast-import`\ 的导入文件格式设计的相对比较简单，\
当理解了其格式约定后，可以相对容易的开发出针对特定版本库的迁移工具。

下面就是一个简单的导入文件，为说明方便前面标注了行号。将这个文件保存为\
:file:`/path/to/file/dump1.dat`\ 。

::

   1 commit refs/heads/master
   2 mark :1
   3 committer User1 <user1@ossxp.com> 1295312699 +0800
   4 data <<EOF
   5 My initial commit.
   6 EOF
   7 M 644 inline README
   8 data <<EOF
   9 Hello, world.
  10 EOF
  11 M 644 inline team/user1.txt
  12 data <<EOF
  13 I'm user1.
  14 EOF

上面这段文字应该这样理解：

* 第1行以\ ``commit``\ 开头，标记一个提交的开始。该提交会创建（或更新）\
  引用\ ``refs/heads/master``\ 。

* 第2行以\ ``mark``\ 开头，是一个标记指令，将这个提交用“\ ``:1``\ ”标示\
  以方便后面的提交参照。

* 第3行记录了这个提交的提交者是\ ``User1``\ ，邮件地址为\
  ``<user1@ossxp.com>``\ ，提交时间则采用Unix时间格式。

* 第4-6行是该提交的提交说明，提交说明用\ ``data``\ 数据块的方式进行定义。

* 第4行在\ ``data``\ 语句后紧接着的\ ``<<EOF``\ 含义为\ ``data``\ 的内容\
  到以\ ``EOF``\ 标记的行截止。这样的表示法称为“Here Documents”表示法。

* 第7行以字母\ ``M``\ 开头，含义是修改（或新建）了一个文件，文件名为\
  :file:`README`\ ，而文件的内容以\ ``inline``\ 的方式提供。

* 第8-10行则是以内联（inline）数据块的方式提供\ :file:`README`\ 文件的内容。

* 第11行定义了该提交修改的第二个文件\ :file:`team/user1.txt`\ 。该文件的\
  内容也是以内联（inline）的方式给出。

* 第12-14行给出文件\ :file:`team/user1.txt`\ 的内容。

下面初始化一个新的版本库，并通过导入文件\ :file:`/path/to/file/dump1.dat`\
的方式为版本库注入数据。

* 初始化版本库。

  ::

    $ mkdir -p /path/to/my/workspace/import
    $ cd /path/to/my/workspace/import
    $ git init

* 调用\ :command:`git fast-import`\ 命令。

  ::

    $ git fast-import < /path/to/file/dump1.dat
    git-fast-import statistics:
    ---------------------------------------------------------------------
    Alloc'd objects:       5000
    Total objects:            5 (         0 duplicates                  )
          blobs  :            2 (         0 duplicates          0 deltas)
          trees  :            2 (         0 duplicates          0 deltas)
          commits:            1 (         0 duplicates          0 deltas)
          tags   :            0 (         0 duplicates          0 deltas)
    Total branches:           1 (         1 loads     )
          marks:           1024 (         1 unique    )
          atoms:              3
    Memory total:          2344 KiB
           pools:          2110 KiB
         objects:           234 KiB
    ---------------------------------------------------------------------
    pack_report: getpagesize()            =       4096
    pack_report: core.packedGitWindowSize = 1073741824
    pack_report: core.packedGitLimit      = 8589934592
    pack_report: pack_used_ctr            =          1
    pack_report: pack_mmap_calls          =          1
    pack_report: pack_open_windows        =          1 /          1
    pack_report: pack_mapped              =        323 /        323
    ---------------------------------------------------------------------

* 看看提交日志。

  ::

    $ git log --pretty=fuller --stat
    commit 18f4310580ca915d7384b116fcb2e2ca0b833714
    Author:     User1 <user1@ossxp.com>
    AuthorDate: Tue Jan 18 09:04:59 2011 +0800
    Commit:     User1 <user1@ossxp.com>
    CommitDate: Tue Jan 18 09:04:59 2011 +0800

        My initial commit.

     README         |    1 +
     team/user1.txt |    1 +
     2 files changed, 2 insertions(+), 0 deletions(-)

再来看一个导入文件。将下面的内容保存到文件\ :file:`/path/to/file/dump2.dat`\ 中。

::

   1 blob
   2 mark :2
   3 data 25
   4 Hello, world.
   5 Hi, user2.
   6 blob
   7 mark :3
   8 data <<EOF
   9 I'm user2.
  10 EOF 
  11 commit refs/heads/master
  12 mark :4
  13 committer User2 <user2@ossxp.com> 1295312799 +0800
  14 data <<EOF
  15 User2's test commit.
  16 EOF
  17 from :1
  18 M 644 :2 README
  19 M 644 :3 team/user2.txt

上面的内容标注了行号，注意不要把行号也代入文件中。其中：

* 第1-5行定义了编号为“\ ``:2``\ ”的文件内容。该文件的内容共有25字节，第3\
  行开始的\ ``data``\ 文字块就通过在后面跟上一个表示文件长度的十进制数字\
  界定了内容的起止。

* 第6-10行定义了编号为“\ ``:3``\ ”的文件内容。第8行界定该文件内容使用了\
  “Here Documents”的语法，该语法对于文本内容比较适合，使用内容长度标示\
  内容起止对于二进制文件更为适合。

* 第11行开始定义了一个新的提交。

* 第12行设定该提交的编号为“\ ``:4``\ ”。

* 第17行以\ ``from``\ 开头，定义了该提交的父提交为编号为“\ ``:1``\ ”的\
  提交，即在\ :file:`/path/to/file/dump1.dat`\ 中定义的提交。

* 第18行和第19行设定了该提交更改的两个文件，这两个文件的内容不像之前的\
  导出文件\ ``dump1.dat``\ 那样使用内联方式定义内容，而是采用引用方式引用\
  前面定义的二进制数据流（blob）作为文件的内容。

如果以增量方式导入\ :file:`dump2.dat`\ 会报错，因为在第17行引用的\
“\ ``:1``\ ”没有定义。

::

  $ git fast-import < /path/to/file/dump2.dat
  fatal: mark :1 not declared
  fast-import: dumping crash report to .git/fast_import_crash_21772

如果将文件\ :file:`/path/to/file/dump2.dat`\ 的第17行的引用修改为提交ID，\
是可以增量导入的。不过为了说明的方便，还是通过将两个导入文件一次性传递给\
:command:`git fast-import`\ 创建一个新版本库。

* 初始化版本库\ ``import2``\ 。

  ::

    $ mkdir -p /path/to/my/workspace/import2
    $ cd /path/to/my/workspace/import2
    $ git init

* 调用\ :command:`git fast-import`\ 命令。

  ::

    $ cat /path/to/file/dump1.dat \
          /path/to/file/dump2.dat | git fast-import

* 导入之后的日志显示：

  ::

    $ git log --graph --stat
    * commit 73a6f2742f9da7c1b4bb8748e018a2becad39dd6
    | Author: User2 <user2@ossxp.com>
    | Date:   Tue Jan 18 09:06:39 2011 +0800
    | 
    |     User2's test commit.
    | 
    |  README         |    1 +
    |  team/user2.txt |    1 +
    |  2 files changed, 2 insertions(+), 0 deletions(-)
    |  
    * commit 18f4310580ca915d7384b116fcb2e2ca0b833714
      Author: User1 <user1@ossxp.com>
      Date:   Tue Jan 18 09:04:59 2011 +0800
      
          My initial commit.
      
       README         |    1 +
       team/user1.txt |    1 +
       2 files changed, 2 insertions(+), 0 deletions(-)

下面再来看一个导入文件，在这个导入文件中，包含了合并提交以及创建里程碑。

::

   1 blob
   2 mark :5
   3 data 25
   4 Hello, world.
   5 Hi, user1.
   6 blob
   7 mark :6
   8 data 35
   9 Hello, world.
  10 Hi, user1 and user2.
  11 commit refs/heads/master
  12 mark :7
  13 committer User1 <user1@ossxp.com> 1295312899 +0800
  14 data <<EOF
  15 Say helo to user1.
  16 EOF
  17 from :1
  18 M 644 :5 README
  19 commit refs/heads/master
  20 mark :8
  21 committer User2 <user2@ossxp.com> 1295312900 +0800
  22 data <<EOF
  23 Say helo to both users.
  24 EOF
  25 from :4
  26 merge :7
  27 M 644 :6 README
  28 tag refs/tags/v1.0
  29 from :8
  30 tagger Jiang Xin <jiangxin@ossxp.com> 1295312901 +0800
  31 data <<EOF
  32 Version v1.0
  33 EOF

将这个文件保存到\ :file:`/path/to/file/dump3.dat`\ 。下面针对该文件内容\
进行简要的说明：

* 第1-5行和第6-10行定义了两个blob对象，代表了两个对\ :file:`README`\
  文件的不同修改。

* 第11行开始定义了编号为“\ ``:7``\ ”的提交。从第17行可以看出该提交的父提\
  交也是由\ :file:`dump1.dat`\ 导入的第一个提交。

* 第19行开始定义了编号为“\ :8``\ ”的提交。该提交为一个合并提交，除了在第\
  25行设定了第一个父提交外，还由第26行给出了第二个父提交。

* 第28行开始定义了一个里程碑。里程碑的名字为\ ``refs/tags/v1.0``\ 。第29\
  行指定了该里程碑对应的提交。里程碑说明由第31-33行指令给出。

* 初始化版本库\ ``import3``\ 。

  ::

    $ mkdir -p /path/to/my/workspace/import3
    $ cd /path/to/my/workspace/import3
    $ git init

* 调用\ :command:`git fast-import`\ 命令。

  ::

    $ cat /path/to/file/dump1.dat /path/to/file/dump2.dat \
          /path/to/file/dump3.dat | git fast-import

* 查看创建的版本库的日志。

  从日志中可以看出里程碑\ ``v1.0``\ 已经建立在最新的提交上了。

  ::

    $ git log --oneline --graph --decorate
    *   a47790e (HEAD, tag: refs/tags/v1.0, master) Say helo to both users.
    |\  
    | * f486a44 Say helo to user1.
    * | 73a6f27 User2's test commit.
    |/  
    * 18f4310 My initial commit.

理解了\ ``git fast-import``\ 的导入文件格式，针对特定的版本控制系统开发\
一个新的迁移工具不是难事。Hg的迁移工具\ :command:`fast-export`\ 是一个很\
好的参照。
