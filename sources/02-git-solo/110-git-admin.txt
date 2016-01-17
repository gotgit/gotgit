Git库管理
*********

版本库管理？那不是管理员要干的事情么，怎么放在“Git独奏”这一部分了？

没有错，这是因为对于Git，每个用户都是自己版本库的管理员，所以在“Git独奏”\
的最后一章，来谈一谈Git版本库管理的问题。如果下面的问题您没有遇到或者不\
感兴趣，读者大可以放心的跳过这一章。

* 从网上克隆来的版本库，为什么对象库中找不到对象文件？而且引用目录里也看\
  不到所有的引用文件？

* 不小心添加了一个大文件到Git库中，用重置命令丢弃了包含大文件的提交，可\
  是版本库不见小，大文件仍在对象库中。

* 本地版本库的对象库里文件越来越多，这可能导致Git性能的降低。

对象和引用哪里去了？
====================

从GitHub上克隆一个示例版本库，这个版本库在“历史穿梭”一章就已经克隆过一次\
了，现在要重新克隆一份。为了和原来的克隆相区别，克隆到另外的目录。执行下\
面的命令。

::

  $ cd /path/to/my/workspace/
  $ git clone git://github.com/ossxp-com/gitdemo-commit-tree.git i-am-admin
  Cloning into i-am-admin...
  remote: Counting objects: 65, done.
  remote: Compressing objects: 100% (53/53), done.
  remote: Total 65 (delta 8), reused 0 (delta 0)
  Receiving objects: 100% (65/65), 78.14 KiB | 42 KiB/s, done.
  Resolving deltas: 100% (8/8), done.

进入克隆的版本库，使用\ :command:`git show-ref`\ 命令看看所含的引用。

::

  $ cd /path/to/my/workspace/i-am-admin
  $ git show-ref
  6652a0dce6a5067732c00ef0a220810a7230655e refs/heads/master
  6652a0dce6a5067732c00ef0a220810a7230655e refs/remotes/origin/HEAD
  6652a0dce6a5067732c00ef0a220810a7230655e refs/remotes/origin/master
  c9b03a208288aebdbfe8d84aeb984952a16da3f2 refs/tags/A
  1a87782f8853c6e11aacba463af04b4fa8565713 refs/tags/B
  9f8b51bc7dd98f7501ade526dd78c55ee4abb75f refs/tags/C
  887113dc095238a0f4661400d33ea570e5edc37c refs/tags/D
  6decd0ad3201ddb3f5b37c201387511059ac120c refs/tags/E
  70cab20f099e0af3f870956a3fbbbda50a17864f refs/tags/F
  96793e37c7f1c7b2ddf69b4c1e252763c11a711f refs/tags/G
  476e74549047e2c5fbd616287a499cc6f07ebde0 refs/tags/H
  76945a15543c49735634d58169b349301d65524d refs/tags/I
  f199c10c3f1a54fa3f9542902b25b49d58efb35b refs/tags/J

其中以\ ``refs/heads/``\ 开头的是分支；以\ ``refs/remotes/``\ 开头的是远\
程版本库分支在本地的映射，会在后面章节介绍；以\ ``refs/tags/``\ 开头的是\
里程碑。按照之前的经验，在\ :file:`.git/refs`\ 目录下应该有这些引用所对\
应的文件才是。看看都在么？

::

  $ find .git/refs/ -type f
  .git/refs/remotes/origin/HEAD
  .git/refs/heads/master

为什么才有两个文件？实际上当运行下面的命令后，引用目录下的文件会更少：

::

  $ git pack-refs --all
  $ find .git/refs/ -type f
  .git/refs/remotes/origin/HEAD

那么本应该出现在\ :file:`.git/refs/`\ 目录下的引用文件都到哪里去了呢？\
答案是这些文件被打包了，放到一个文本文件\ :file:`.git/packed-refs`\
中了。查看一下这个文件中的内容。

::

  $ head -5 .git/packed-refs 
  # pack-refs with: peeled 
  6652a0dce6a5067732c00ef0a220810a7230655e refs/heads/master
  6652a0dce6a5067732c00ef0a220810a7230655e refs/remotes/origin/master
  c9b03a208288aebdbfe8d84aeb984952a16da3f2 refs/tags/A
  ^81993234fc12a325d303eccea20f6fd629412712

再来看看Git的对象（commit、blob、tree、tag）在对象库中的存储。通过下面的\
命令，会发现对象库也不是原来熟悉的模样了。

::

  $ find .git/objects/ -type f
  .git/objects/pack/pack-969329578b95057b7ea1208379a22c250c3b992a.idx
  .git/objects/pack/pack-969329578b95057b7ea1208379a22c250c3b992a.pack

对象库中只有两个文件，本应该一个一个独立保存的对象都不见了。读者应该能够\
猜到，所有的对象文件都被打包到这两个文件中了，其中以\ :file:`.pack`\
结尾的文件是打包文件，以\ :file:`.idx`\ 结尾的是索引文件。打包文件和对应\
的索引文件只是扩展名不同，都保存于\ :file:`.git/objects/pack/`\ 目录下。\
Git对于以SHA1哈希值作为目录名和文件名保存的对象有一个术语，称为松散对象。\
松散对象打包后会提高访问效率，而且不同的对象可以通过增量存储节省磁盘空间。

可以通过Git一个底层命令可以查看索引中包含的对象：

::

  $ git show-index < .git/objects/pack/pack-*.idx | head -5
  661 0cd7f2ea245d90d414e502467ac749f36aa32cc4 (0793420b)
  63020 1026d9416d6fc8d34e1edfb2bc58adb8aa5a6763 (ed77ff72)
  3936 15328fc6961390b4b10895f39bb042021edd07ea (13fb79ef)
  3768 1a588ca36e25f58fbeae421c36d2c39e38e991ef (86e3b0bd)
  2022 1a87782f8853c6e11aacba463af04b4fa8565713 (e269ed74)

为什么克隆远程版本库就可以产生对象库打包以及引用打包的效果呢？这是因为克\
隆远程版本库时，使用了“智能”的通讯协议，远程Git服务器将对象打包后传输给\
本地，形成本地版本库的对象库中的一个包含所有对象的包以及索引文件。无疑这\
样的传输方式——按需传输、打包传输，效率最高。

克隆之后的版本库在日常的提交中，产生的新的对象仍旧以松散对象存在，而不是\
以打包的形式，日积月累会在本地版本库的对象库中形成大量的松散文件。松散对\
象只是进行了压缩，而没有（打包文件才有的）增量存储的功能，会浪费磁盘空间\
，也会降低访问效率。更为严重的是一些非正式的临时对象（暂存区操作中产生的\
临时对象）也以松散对象的形式保存在对象库中，造成磁盘空间的浪费。下一节就\
着手处理临时对象的问题。

暂存区操作引入的临时对象
========================

暂存区操作有可能在对象库中产生临时对象，例如文件反复的修改和反复的向暂存\
区添加，或者添加到暂存区后不提交甚至直接撤销，就会产生垃圾数据占用磁盘空\
间。为了说明临时对象的问题，需要准备一个大的压缩文件，10MB即可。

在Linux上与内核匹配的\ :file:`initrd`\ 文件（内核启动加载的内存盘）就是\
一个大的压缩文件，可以用于此节的示例。将大的压缩文件放在版本库外的一个位\
置上，因为这个文件会多次用到。

::

  $ cp /boot/initrd.img-2.6.32-5-amd64 /tmp/bigfile
  $ du -sh bigfile
  11M     bigfile

将这个大的压缩文件复制到工作区中，拷贝两份。

::

  $ cd /path/to/my/workspace/i-am-admin
  $ cp /tmp/bigfile bigfile
  $ cp /tmp/bigfile bigfile.dup

然后将工作区中两个内容完全一样的大文件加入暂存区。

::

  $ git add bigfile bigfile.dup

查看一下磁盘空间占用：

* 工作区连同版本库共占用33MB。

  ::

    $ du -sh .
    33M     .

* 其中版本库只占用了11MB。版本库空间占用是工作区的一半。

  如果再有谁说版本库空间占用一定比工作区大，可以用这个例子回击他。

  ::

    $ du -sh .git/
    11M     .git/

看看版本库中对象库内的文件，会发现多出了一个松散对象。之所以添加两个文件\
而只有一个松散对象，是因为Git对于文件的保存是将内容保存为blob对象中，和\
文件名无关，相同内容的不同文件会共享同一个blob对象。

::

  $ find .git/objects/ -type f
  .git/objects/2e/bcd92d0dda2bad50c775dc662c6cb700477aff
  .git/objects/pack/pack-969329578b95057b7ea1208379a22c250c3b992a.idx
  .git/objects/pack/pack-969329578b95057b7ea1208379a22c250c3b992a.pack

如果不想提交，想将文件撤出暂存区，则进行如下操作。

* 当前暂存区的状态。

  ::

    $ git status -s
    A  bigfile
    A  bigfile.dup

* 将添加的文件撤出暂存区。

  ::

    $ git reset HEAD

* 通过查看状态，看到文件被撤出暂存区了。

  ::

    $ git status -s
    ?? bigfile
    ?? bigfile.dup

文件撤出暂存区后，在对象库中产生的blob松散对象仍然存在，通过查看版本库的\
磁盘占用就可以看出来。

::

  $ du -sh .git/
  11M     .git/

Git提供了\ :command:`git fsck`\ 命令，可以查看到版本库中包含的没有被任何\
引用关联松散对象。

::

  $ git fsck
  dangling blob 2ebcd92d0dda2bad50c775dc662c6cb700477aff

标识为dangling的对象就是没有被任何引用直接或者间接关联到的对象。这个对象\
就是前面通过暂存区操作引入的大文件的内容。如何将这个文件从版本库中彻底删\
除呢？Git提供了一个清理的命令：

::

  $ git prune

用\ :command:`git prune`\ 清理之后，会发现：

* 用\ :command:`git fsck`\ 查看，没有未被关联到的松散对象。

  ::

    $ git fsck

* 版本库的空间占用也小了10MB，证明大的临时对象文件已经从版本库中删除了。

  ::

    $ du -sh .git/
    236K    .git/

重置操作引入的对象
==================

上一节用\ :command:`git prune`\ 命令清除暂存区操作时引入的临时对象，但是\
如果是用重置命令抛弃的提交和文件就不会轻易的被清除。下面用同样的大文件提\
交到版本库中试验一下。

::

  $ cd /path/to/my/workspace/i-am-admin
  $ cp /tmp/bigfile bigfile
  $ cp /tmp/bigfile bigfile.dup

将这两个大文件提交到版本库中。

* 添加到暂存区。

  ::

    $ git add bigfile bigfile.dup

* 提交到版本库。

  ::

    $ git commit -m "add bigfiles."
    [master 51519c7] add bigfiles.
     2 files changed, 0 insertions(+), 0 deletions(-)
     create mode 100644 bigfile
     create mode 100644 bigfile.dup

* 查看版本库的空间占用。

  ::

    $ du -sh .git/
    11M     .git/

做一个重置操作，抛弃刚刚针对两个大文件做的提交。

::

  $ git reset --hard HEAD^

重置之后，看看版本库的变化。

* 版本库的空间占用没有变化，还是那么“庞大”。

  ::

    $ du -sh .git/
    11M     .git/

* 查看对象库，看到三个松散对象。

  ::

    $ find .git/objects/ -type f
    .git/objects/info/packs
    .git/objects/2e/bcd92d0dda2bad50c775dc662c6cb700477aff
    .git/objects/d9/38dee8fde4e5053b12406c66a19183a24238e1
    .git/objects/51/519c7d8d60e0f958e135e8b989a78e84122591
    .git/objects/pack/pack-969329578b95057b7ea1208379a22c250c3b992a.idx
    .git/objects/pack/pack-969329578b95057b7ea1208379a22c250c3b992a.pack

* 这三个松散对象分别对应于撤销的提交，目录树，以及大文件对应的blob对象。

  ::

    $ git cat-file -t 51519c7
    commit
    $ git cat-file -t d938dee
    tree
    $ git cat-file -t 2ebcd92
    blob

向上一节一样，执行\ :command:`git prune`\ 命令，期待版本库空间占用会变小。可是：

* 版本库空间占用没有变化！

  ::

    $ git prune
    $ du -sh .git/
    11M     .git/

* 执行\ :command:`git fsck`\ 也看不到未被关联到的对象。

  ::

    $ git fsck

* 除非像下面这样执行。

  ::

    $ git fsck --no-reflogs
    dangling commit 51519c7d8d60e0f958e135e8b989a78e84122591

还记得前面章节中介绍的reflog么？reflog是防止误操作的最后一道闸门。

::

  $ git reflog 
  6652a0d HEAD@{0}: HEAD^: updating HEAD
  51519c7 HEAD@{1}: commit: add bigfiles.

可以看到撤销的操作仍然记录在reflog中，正因如此Git认为撤销的提交和大文件\
都还被可以被追踪到，还在使用着，所以无法用\ :command:`git prune`\ 命令删除。

如果确认真的要丢弃不想要的对象，需要对版本库的reflog做过期操作，相当于将\
:file:`.git/logs/`\ 下的文件清空。

* 使用下面的reflog过期命令做不到让刚刚撤销的提交过期，因为reflog的过期操\
  作缺省只会让90天前的数据过期。

  ::

    $ git reflog expire --all
    $ git reflog 
    6652a0d HEAD@{0}: HEAD^: updating HEAD
    51519c7 HEAD@{1}: commit: add bigfiles.

* 需要要为\ :command:`git reflog`\ 命令提供\ ``--expire=<date>``\ 参数，\
  强制\ ``<date>``\ 之前的记录全部过期。

  ::

    $ git reflog expire --expire=now --all
    $ git reflog

使用\ ``now``\ 作为时间参数，让 reflog 的全部记录都过期。没有了 reflog，\
即回滚的添加大文件的提交从 reflog 中看不到后，该提交对应的 commit 对象、\
tree 对象和 blob 对象就会成为未被关联的 dangling 对象，可以用\
:command:`git prune`\ 命令清理。下面可以看到清理后，版本库变小了。

::

  $ git prune
  $ du -sh .git/
  244K    .git/

Git管家：\ ``git gc``
==========================

前面两节介绍的是比较极端的情况，实际操作中会很少用到\ :command:`git prune`\
命令来清理版本库，而是会使用一个更为常用的命令\ :command:`git gc`\ 。\
命令\ :command:`git gc`\ 就好比Git版本库的管家，会对版本库进行一系列的\
优化动作。

* 对分散在\ :file:`.git/refs`\ 下的文件进行打包，打包到文件\
  :file:`.git/packed-refs`\ 中。

  如果没有将配置\ :file:`gc.packrefs`\ 关闭，就会执行命令：\
  :command:`git pack-refs --all --prune`\ 实现对引用的打包。

* 丢弃90天前的reflog记录。

  会运行使reflog过期命令：\ :command:`git reflog expire --all`\ 。\
  因为采用了缺省参数调用，因此只会清空reflog中90天前的记录。
 
* 对松散对象进行打包。

  运行\ :command:`git repack`\ 命令，凡是有引用关联的对象都被\
  打在包里，未被关联的对象仍旧以松散对象形式保存。

* 清除未被关联的对象。缺省只清除2周以前的未被关联的对象。

  可以向\ :command:`git gc`\ 提供\ ``--prune=<date>``\ 参数，其中的时间\
  参数传递给\ :command:`git prune --expire <date>`\ ，实现对指定日期\
  之前的未被关联的松散对象进行清理。

* 其他清理。

  如运行\ :command:`git rerere gc`\ 对合并冲突的历史记录进行过期操作。

从上面的描述中可见命令\ :command:`git gc`\ 完成了相当多的优化和清理工作，\
并且最大限度照顾了安全性的需要。例如像暂存区操作引入的没有关联的临时对象\
会最少保留2个星期，而因为重置而丢弃的提交和文件则会保留最少3个月。

下面就把前面的例子用\ :command:`git gc`\ 再执行一遍，不过这一次添加的两\
个大文件要稍有不同，以便看到\ :command:`git gc`\ 打包所实现的对象增量存\
储的效果。

复制两个大文件到工作区。

::

  $ cp /tmp/bigfile bigfile
  $ cp /tmp/bigfile bigfile.dup

在文件\ :file:`bigfile.dup`\ 后面追加些内容，造成\ :file:`bigfile`\ 和\
:file:`bigfile.dup`\ 内容不同。

::

  $ echo "hello world" >> bigfile.dup

将这两个稍有不同的文件提交到版本库。

::

  $ git add bigfile bigfile.dup
  $ git commit -m "add bigfiles."
  [master c62fa4d] add bigfiles.
   2 files changed, 0 insertions(+), 0 deletions(-)
   create mode 100644 bigfile
   create mode 100644 bigfile.dup

可以看到版本库中提交进来的两个不同的大文件是不同的对象。

::

  $ git ls-tree HEAD | grep bigfile
  100644 blob 2ebcd92d0dda2bad50c775dc662c6cb700477aff    bigfile
  100644 blob 9e35f946a30c11c47ba1df351ca22866bc351e7b    bigfile.dup

做版本库重置，抛弃最新的提交，即抛弃添加两个大文件的提交。

::

  $ git reset --hard HEAD^
  HEAD is now at 6652a0d Add Images for git treeview.

此时的版本库有多大呢，还是像之前添加两个相同的大文件时占用11MB空间么？

::

  $ du -sh .git/
  22M     .git/

版本库空间占用居然扩大了一倍！这显然是因为两个大文件分开存储造成的。可以\
用下面的命令在对象库中查看对象的大小。

::

  $ find .git/objects -type f -printf "%-20p\t%s\n"
  .git/objects/0c/844d2a072fd69e71638558216b69ebc57ddb64  233
  .git/objects/2e/bcd92d0dda2bad50c775dc662c6cb700477aff  11184682
  .git/objects/9e/35f946a30c11c47ba1df351ca22866bc351e7b  11184694
  .git/objects/c6/2fa4d6cb4c082fadfa45920b5149a23fd7272e  162
  .git/objects/info/packs 54
  .git/objects/pack/pack-969329578b95057b7ea1208379a22c250c3b992a.idx   2892
  .git/objects/pack/pack-969329578b95057b7ea1208379a22c250c3b992a.pack  80015

输出的每一行用空白分隔，前面是文件名，后面是以字节为单位的文件大小。从上\
面的输出可以看出来，打包文件很小，但是有两个大的文件各自占用了11MB左右的\
空间。

执行\ :command:`git gc`\ 并不会删除任何对象，因为这些对象都还没有过期。\
但是会发现版本库的占用变小了。

* 执行\ :command:`git gc`\ 对版本库进行整理。

  ::

    $ git gc
    Counting objects: 69, done.
    Delta compression using up to 2 threads.
    Compressing objects: 100% (49/49), done.
    Writing objects: 100% (69/69), done.
    Total 69 (delta 11), reused 63 (delta 8)

* 版本库空间占用小了一半！

  ::

    $ du -sh .git/
    11M     .git/

* 原来是因为对象库重新打包，两个大文件采用了增量存储使得版本库变小。

  ::

    $ find .git/objects -type f -printf "%-20p\t%s\n" | sort
    .git/objects/info/packs 54
    .git/objects/pack/pack-7cae010c1b064406cd6c16d5a6ab2f446de4076c.idx 3004
    .git/objects/pack/pack-7cae010c1b064406cd6c16d5a6ab2f446de4076c.pack 11263033

如果想将抛弃的历史数据彻底丢弃，如下操作。

* 不再保留90天的reflog，而是将所有reflog全部即时过期。

  ::

    $ git reflog expire --expire=now --all

* 通过\ :command:`git fsck`\ 可以看到有提交成为了未被关联的提交。

  ::

    $ git fsck
    dangling commit c62fa4d6cb4c082fadfa45920b5149a23fd7272e

* 这个未被关联的提交就是删除大文件的提交。

  ::

    $ git show c62fa4d6cb4c082fadfa45920b5149a23fd7272e
    commit c62fa4d6cb4c082fadfa45920b5149a23fd7272e
    Author: Jiang Xin <jiangxin@ossxp.com>
    Date:   Thu Dec 16 20:18:38 2010 +0800

        add bigfiles.

    diff --git a/bigfile b/bigfile
    new file mode 100644
    index 0000000..2ebcd92
    Binary files /dev/null and b/bigfile differ
    diff --git a/bigfile.dup b/bigfile.dup
    new file mode 100644
    index 0000000..9e35f94
    Binary files /dev/null and b/bigfile.dup differ

* 不带参数调用\ :command:`git gc`\ 虽然不会清除尚未过期（未到2周）的大文\
  件，但是会将未被关联的对象从打包文件中移出，成为松散文件。

  ::

    $ git gc
    Counting objects: 65, done.
    Delta compression using up to 2 threads.
    Compressing objects: 100% (45/45), done.
    Writing objects: 100% (65/65), done.
    Total 65 (delta 8), reused 63 (delta 8)

* 未被关联的对象重新成为松散文件，所以\ :file:`.git`\ 版本库的空间占用又\
  反弹了。

  ::

    $ du -sh .git/
    22M     .git/
    $ find .git/objects -type f -printf "%-20p\t%s\n" | sort
    .git/objects/0c/844d2a072fd69e71638558216b69ebc57ddb64  233
    .git/objects/2e/bcd92d0dda2bad50c775dc662c6cb700477aff  11184682
    .git/objects/9e/35f946a30c11c47ba1df351ca22866bc351e7b  11184694
    .git/objects/c6/2fa4d6cb4c082fadfa45920b5149a23fd7272e  162
    .git/objects/info/packs 54
    .git/objects/pack/pack-969329578b95057b7ea1208379a22c250c3b992a.idx 2892
    .git/objects/pack/pack-969329578b95057b7ea1208379a22c250c3b992a.pack 80015

* 实际上如果使用立即过期参数\ ``--prune=now``\ 调用\ :command:`git gc`\ ，\
  就不用再等2周了，直接就可以完成对未关联的对象的清理。

  ::

    $ git gc --prune=now
    Counting objects: 65, done.
    Delta compression using up to 2 threads.
    Compressing objects: 100% (45/45), done.
    Writing objects: 100% (65/65), done.
    Total 65 (delta 8), reused 65 (delta 8)

* 清理过后，版本库的空间占用降了下来。

  ::

    $ du -sh .git/
    240K    .git/

Git管家的自动执行
=================

对于老版本库的Git，会看到帮助手册中建议用户对版本库进行周期性的整理，以\
便获得更好的性能，尤其是对于规模比较大的项目，但是对于整理的周期都语焉不详。

实际上对于1.6.6及以后版本的Git已经基本上不需要手动执行\ :command:`git gc`\
命令了，因为部分Git命令会自动调用\ :command:`git gc --auto`\ 命令，在\
版本库确实需要整理的情况下自动开始整理操作。

目前有如下Git命令会自动执行\ :command:`git gc --auto`\ 命令，实现对版本\
库的按需整理。

* 执行命令\ :command:`git merge`\ 进行合并操作后，对版本库进行按需整理。

* 执行命令\ :command:`git receive-pack`\ ，即版本库接收其他版本库推送\
  （push）的提交后，版本库会做按需整理操作。

  当版本库接收到其他版本库的推送（push）请求时，会调用\
  :command:`git receive-pack`\ 命令以接收请求。在接收到推送的提交后，\
  对版本库进行按需整理。

* 执行命令\ :command:`git rebase -i`\ 进行交互式变基操作后，会对版本库进\
  行按需整理。

* 执行命令\ :command:`git am`\ 对mbox邮箱中通过邮件提交的补丁在版本库中\
  进行应用的操作后，会对版本库做按需整理操作。

对于提供共享式“写操作”的Git版本库，可以免维护。所谓的共享式写操作，就是\
版本库作为一个裸版本库放在服务器上，团队成员可以通过推送（push）操作将提\
交推送到共享的裸版本中。每一次推送操作都会触发\ :command:`git gc --auto`\
命令，对版本库进行按需整理。

对于非独立工作的本地工作区，也可以免维护。因为和他人协同工作的本地工作区\
会经常执行\ :command:`git pull`\ 操作从他人版本库或者从共享的版本库拉回\
新提交，执行\ :command:`git pull`\ 操作会，会触发\ :command:`git merge`\
操作，因此也会对本地版本库进行按需整理。

Git管家命令使用\ ``--auto``\ 参数调用，会进行按需整理。因为版本库整理操\
作对于大的项目可能会非常费时，因此实际的整理并不会经常被触发，即有着非常\
苛刻的触发条件。想要观察到触发版本库整理操作是非常不容易的事情。

主要的触发条件是：松散对象只有超过一定的数量时才会执行。而且在统计松散对\
象数量时，为了降低在\ :file:`.git/objects/`\ 目录下搜索松散对象对系统造\
成的负担，实际采取了取样搜索，即只会对对象库下一个子目录\
:file:`.git/objects/17`\ 进行文件搜索。在缺省的配置下，只有该目录中对象\
数目超过27个，才会触发版本库的整理。至于为什么只在对象库下选择了一个子\
目录进行松散对象的搜索，这是因为SHA1哈希值是完全随机的，文件在由前两位\
哈希值组成的目录中差不多是平均分布的。至于为什么选择\ ``17``\ ，不知道\
对于作者Junio C Hamano有什么特殊意义，也许是向Linus Torvalds被评选为二十\
世纪最有影响力的100人中排名第17位而进行致敬。

可以通过配置\ :command:`gc.auto`\ 的值，调整Git管家自动运行时触发版本库\
整理操作的频率，但是注意不要将\ :command:`gc.auto`\ 设置为0，否则\
:command:`git gc --auto`\ 命令永远不会触发版本库的整理。
