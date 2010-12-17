Git库管理
*********

版本库管理？那不是管理员要干的事情么，怎么放在“Git独奏”这一部分了？

没有错，这是因为对于 Git，每个用户都是自己版本库的管理员，所以在“Git独奏”的最后一章，来谈一谈 Git 版本库管理的问题。如果下面的问题您没有遇到或者不感兴趣，读者大可以放心的跳过这一章。

* 从网上克隆来的版本库，可是为什么对象库中找不到对象文件？而且引用目录里也看不到所有的引用文件？
* 不小心添加了一个大文件到 Git 库中，用重置命令丢弃了包含大文件的提交，可是版本库不见小，大文件仍在对象库中。
* 本地版本库的对象库里文件越来越多，这可能导致 Git 性能的降低。

对象和引用哪里去了？
====================

从 Github 上克隆一个示例版本库，这个版本库在“实践八：历史穿梭”中已经克隆过一次了，现在要重新克隆一份。为了和原来的克隆相区别，克隆到另外的目录。执行下面的命令。

::

  $ cd /my/workspace/
  $ git clone git://github.com/ossxp-com/gitdemo-commit-tree.git i-am-admin
  Cloning into i-am-admin...
  remote: Counting objects: 65, done.
  remote: Compressing objects: 100% (53/53), done.
  remote: Total 65 (delta 8), reused 0 (delta 0)
  Receiving objects: 100% (65/65), 78.14 KiB | 42 KiB/s, done.
  Resolving deltas: 100% (8/8), done.

进入克隆的版本，看看版本库包含的引用。

::

  $ cd /my/workspace/i-am-admin
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

其中以 `refs/heads/` 开头的是分支；以 `refs/remotes/` 开头的是远程版本库分支在本地的映射，会在后面章节介绍；以 `refs/tags/` 开头的是里程碑。按照之前的经验，在 `.git/refs` 目录下应该有相应引用对应的文件才是。看看都在么？

::

  $ find .git/refs/ -type f
  .git/refs/remotes/origin/HEAD
  .git/refs/heads/master

为什么才有两个文件？实际上当运行下面的命令后，引用目录下的文件会更少：

::

  $ git pack-refs --all
  $ find .git/refs/ -type f
  .git/refs/remotes/origin/HEAD

那么本应该出现在 `.git/refs/` 目录下的引用文件都到哪里去了呢？实际上这些文件被打包了，放到一个文本文件 `.git/packed-refs` 中了。

::

  $ head -5 .git/packed-refs 
  # pack-refs with: peeled 
  6652a0dce6a5067732c00ef0a220810a7230655e refs/heads/master
  6652a0dce6a5067732c00ef0a220810a7230655e refs/remotes/origin/master
  c9b03a208288aebdbfe8d84aeb984952a16da3f2 refs/tags/A
  ^81993234fc12a325d303eccea20f6fd629412712

再来看看 Git 的对象（commit, blob, tree, tag）在对象库中的存储。通过下面的命令，可以看到也不是原来熟悉的模样了。

::

  $ find .git/objects/ -type f
  .git/objects/pack/pack-969329578b95057b7ea1208379a22c250c3b992a.idx
  .git/objects/pack/pack-969329578b95057b7ea1208379a22c250c3b992a.pack

只有两个文件，本应该一个一个独立保存的对象都不见了。读者应该能够猜到，所有的对象文件都被打包到这两个文件中了，其中以 `.pack` 结尾的文件是打包文件，以 `.idx` 结尾的是索引文件。打包文件和对应的索引文件只是扩展名不同，都保存于 `.git/objects/pack/` 目录下。Git 对于以 SHA1 哈希值作为目录名和文件名保存的对象有一个术语，称为松散对象。松散对象打包后会提高访问效率，而且不同的对象可以通过增量存储节省磁盘空间。

可以通过 Git 的底层命令可以查看索引中包含的对象：

::

  $ git show-index < .git/objects/pack/pack-*.idx | head -5
  661 0cd7f2ea245d90d414e502467ac749f36aa32cc4 (0793420b)
  63020 1026d9416d6fc8d34e1edfb2bc58adb8aa5a6763 (ed77ff72)
  3936 15328fc6961390b4b10895f39bb042021edd07ea (13fb79ef)
  3768 1a588ca36e25f58fbeae421c36d2c39e38e991ef (86e3b0bd)
  2022 1a87782f8853c6e11aacba463af04b4fa8565713 (e269ed74)

为什么克隆远程版本库就可以产生对象库打包以及引用打包的效果呢？这是因为克隆远程版本库时，使用了“智能”的通讯协议，远程 Git 服务器将对象打包后传输给本地，形成本地版本库的对象库中的一个包含所有对象的包以及索引文件。无疑这样的传输方式 —— 按需传输、打包传输，效率最高。

克隆之后的版本库在日常的提交中，产生的新的对象仍旧以松散对象存在，而不是以打包的形式，日积月累会在本地版本库的对象库中形成大量的松散文件。松散对象只是进行了压缩，而没有（打包文件才有的）增量存储的功能，会浪费磁盘空间，也会降低访问效率。更为严重的是一些非正式的临时对象（暂存区操作中产生的临时对象）也以松散对象的形式保存在对象库中，造成磁盘空间的浪费。下一节就着手处理临时对象的问题。

暂存区操作引入的临时对象
========================

暂存区操作有可能在对象库中产生临时对象，如果这些对象没有被提交或者撤销，就会成为垃圾数据占用磁盘空间。为了说明临时对象的问题，需要准备一个大的压缩文件，10MB即可。

在 Linux 上与内核匹配的 initrd 文件就是一个大的压缩文件，可以用于此节的示例。将大的压缩文件放在版本库外的一个位置上，因为这个文件会多次用到。

::

  $ cp /boot/initrd.img-2.6.32-5-amd64 /tmp/bigfile
  $ du -sh bigfile
  11M     bigfile

将这个大的压缩文件复制到工作区中，拷贝两份。

::

  $ cd /my/workspace/i-am-admin
  $ cp /tmp/bigfile bigfile
  $ cp /tmp/bigfile bigfile.dup

然后将工作区中两个内容完全一样的大文件加入暂存区。

::

  $ git add bigfile bigfile.dup

查看一下磁盘空间占用：

* 工作区连同版本库共占用 33MB。

  ::

    $ du -sh .
    33M     .

* 其中版本库只占用了 11MB。版本库空间占用是工作区的一半。

  如果再有谁说版本库空间占用一定比工作区大，可以用这个例子回击他。

  ::

    $ du -sh .git/
    11M     .git/

看看版本库中对象库内的文件，会发现多出了一个松散对象。之所以添加两个文件而只有一个松散对象，是因为 Git 对于文件的保存是将内容保存为一个 blob 对象中，和文件名无关。

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

文件撤出暂存区后，在对象库中产生的 blob 松散对象仍然存在，通过查看版本库的磁盘占用就可以看出来。

::

  $ du -sh .git/
  11M     .git/

Git 提供了 git fsck 命令，可以查看到版本库中包含的没有被任何引用关联松散对象。

::

  $ git fsck
  dangling blob 2ebcd92d0dda2bad50c775dc662c6cb700477aff

标识为 dangling 的对象就是没有被任何引用直接或者间接关联到的对象。这个对象就是前面通过暂存区操作引入的大文件的内容。如何将这个文件从版本库中彻底删除呢？Git 提供了一个清理的命令：

::

  $ git prune

用 git prune 清理之后，会发现：

* 用 git fsck 查看，没有未被关联到的松散对象。

  ::

    $ git fsck

* 版本库的空间占用也小了 10MB，证明大的临时对象文件已经从版本库中删除了。

  ::

    $ du -sh .git/
    236K    .git/

重置操作引入的对象
==================

上一节用 `git prune` 命令清除的是因为暂存区操作引入的临时对象，但是如果是用重置命令抛弃的提交却不会轻易的被清除。下面仍旧用大文件提交到版本库中试验一下。

::

  $ cd /my/workspace/i-am-admin
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

* 这三个松散对象分别对应于撤销的提交，目录树，以及大文件对应的 blob 对象。

  ::

    $ git cat-file -t 2ebcd92
    blob
    $ git cat-file -t d938dee
    tree
    $ git cat-file -t 51519c7
    commit

向上一节一样，执行 `git prune` 命令，期待版本库空间占用会变小。可是：

* 版本库空间占用没有变化！

  ::

    $ git prune
    $ du -sh .git/
    11M     .git/

* 执行 git fsck 也看不到未被关联到的对象。

  ::

    $ git fsck

* 除非像下面这样执行。

  ::

    $ git fsck --no-reflogs
    dangling commit 51519c7d8d60e0f958e135e8b989a78e84122591

还记得前面章节中介绍的 reflog 么？是防止误操作的最后一道闸门。

::

  $ git reflog 
  6652a0d HEAD@{0}: HEAD^: updating HEAD
  51519c7 HEAD@{1}: commit: add bigfiles.

正因为 reflog 中还引用了被重置命令抛弃的对象，所以无法用 `git prune` 命令删除那个不想要的大文件。

如果确认真的要丢弃不想要的对象，需要对版本库的 reflog 做过期操作，相当于将 `.git/logs/` 下的文件清空。

* 使用下面的命令做不到。因为 reflog 的过期操作缺省只会让90天前的数据过期。

  ::

    $ git reflog expire --all
    $ git reflog 
    6652a0d HEAD@{0}: HEAD^: updating HEAD
    51519c7 HEAD@{1}: commit: add bigfiles.

* 要为 `git reflog` 命令提供 `--expire=<date>` 参数，人为的强制过期才可以。

  ::

    $ git reflog expire --expire=now --all
    $ git reflog

当针对大文件的提交从 reflog 中看不到后，该提交对应的 commit 对象、tree 对象和 blob 对象才称为未被追踪的 dangling 对象，可以用 `git prune` 命令删除。

::

  $ git prune
  $ du -sh .git/
  244K    .git/

Git管家：git-gc
================

前面两节介绍的是比较极端的情况，实际操作中会很少用到 `git prune` 命令来清理版本库，而是会使用一个更为常用的命令 `git gc` 。命令 `git gc` 就好比 Git 版本库的管家，会对版本库进行一系列的优化动作。

* 对分散在 `.git/refs` 下的文件进行打包，打包到文件 `.git/packed-refs` 中。

  如果没有用配置文件 `gc.packrefs` 关闭，会执行命令： `git pack-refs --all --prune` 实现对引用的打包。

* 丢弃 90 天前的 reflog 记录。

  会运行 reflog 过期命令： `git reflog expire --all` 。因为采用了缺省参数调用，因此只会清空 90 天前的 reflog 日志。
 
* 对松散对象进行打包。

  运行 `git repack` 命令。

* 清除未被关联的对象，缺省清除 2 周未前的未被关联的对象。

  可以向 `git gc` 提供 `--prune=<date>` 参数，其中的时间参数传递给 `git prune --expire <date>` ，实现对指定日期之前的未被关联的松散对象进行清理。

* 其它清理。

  如运行 `git rerere gc` 对合并冲突历史进行过期操作。

从上面的描述中可见命令 `git gc` 完成了相当多的优化和清理工作，并且最大限度照顾了安全性的需要。例如像暂存区操作引入的没有关联的临时对象会最少保留2个星期，而因为重置而丢弃的提交和文件则会保留最少3个月。

下面就把前面的例子用 `git gc` 再执行一遍，不过这一次添加的两个大文件要稍有不同，以便看到 `git gc` 打包实现的对象增量存储。

复制两个大文件到工作区。

::

  $ cp /tmp/bigfile bigfile
  $ cp /tmp/bigfile bigfile.dup

在文件 `bigfile.dup` 后面追加些内容，造成 `bigfile` 和 `bigfile.dup` 内容不同。

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

做版本库重置，抛弃最新的添加两个大文件的提交。

::

  $ git reset --hard HEAD^
  HEAD is now at 6652a0d Add Images for git treeview.

此时的版本库有多大呢，还是像之前的操作暂用 11MB 空间么？

::

  $ du -sh .git/
  22M     .git/

版本库空间占用居然扩大了一倍！这显然是因为两个大文件分开存储造成的。可以用下面的命令在对象库中查看对象的大小。

::

  $ find .git/objects -type f -printf "%-20p\t%s\n"
  .git/objects/0c/844d2a072fd69e71638558216b69ebc57ddb64  233
  .git/objects/2e/bcd92d0dda2bad50c775dc662c6cb700477aff  11184682
  .git/objects/9e/35f946a30c11c47ba1df351ca22866bc351e7b  11184694
  .git/objects/c6/2fa4d6cb4c082fadfa45920b5149a23fd7272e  162
  .git/objects/info/packs 54
  .git/objects/pack/pack-969329578b95057b7ea1208379a22c250c3b992a.idx     2892
  .git/objects/pack/pack-969329578b95057b7ea1208379a22c250c3b992a.pack    80015

输出的每一行用空白分隔，前面是文件名，后面是以字节为单位的文件大小。从上面的输出可以看出来，打包文件很小，但是有两个大的文件各自占用了 11MB 左右的空间。

执行 `git gc` 并不会删除任何对象，因为这些对象都还没有过期。但是会发现版本库的占用变小了。

* 执行 `git gc` 对版本库进行整理。

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
    .git/objects/pack/pack-7cae010c1b064406cd6c16d5a6ab2f446de4076c.idx     3004
    .git/objects/pack/pack-7cae010c1b064406cd6c16d5a6ab2f446de4076c.pack    11263033

如果想将抛弃的历史数据彻底丢弃，如下操作。

* 不再保留 90 天的 reflog，而是将所有 reflog 全部即时过期。

  ::

    $ git reflog expire --expire=now --all

* 通过 `git fsck` 可以看到有提交成为了未被关联的提交。

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

* 不带参数调用 `git gc` 虽然不会清除尚未过期（未到2周）的大文件，但是会将未被关联的文件从打包文件中移出，成为松散文件。

  ::

    $ git gc
    Counting objects: 65, done.
    Delta compression using up to 2 threads.
    Compressing objects: 100% (45/45), done.
    Writing objects: 100% (65/65), done.
    Total 65 (delta 8), reused 63 (delta 8)

* 因为未被关联文件重新成为松散文件，所以 `.git` 版本库的空间占用又反弹了。

  ::

    $ du -sh .git/
    22M     .git/
    $ find .git/objects -type f -printf "%-20p\t%s\n" | sort
    .git/objects/0c/844d2a072fd69e71638558216b69ebc57ddb64  233
    .git/objects/2e/bcd92d0dda2bad50c775dc662c6cb700477aff  11184682
    .git/objects/9e/35f946a30c11c47ba1df351ca22866bc351e7b  11184694
    .git/objects/c6/2fa4d6cb4c082fadfa45920b5149a23fd7272e  162
    .git/objects/info/packs 54
    .git/objects/pack/pack-969329578b95057b7ea1208379a22c250c3b992a.idx     2892
    .git/objects/pack/pack-969329578b95057b7ea1208379a22c250c3b992a.pack    80015

* 实际上如果使用立即过期参数 `--prune=now` 调用 `git gc` ，直接就可以实现对未关联的对象的清理。

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

对于老版本库的 Git，会看到帮助手册中建议用户对版本库进行周期性的整理，以便获得更好的性能，尤其是对于规模比较大的项目，但是对于整理的周期都语焉不详。

实际上对于 1.6.6 及以后版本的 Git 已经基本上不需要手动执行 `git gc` 命令了，因为部分 Git 命令会自动调用 `git gc --auto` 命令，在版本库确实需要整理的情况下自动开始整理操作。

目前有如下 Git 命令会自动执行 `git gc --auto` 命令，实现对版本库的按需整理。

* 执行命令 `git merge` 进行合并操作（非压缩合并）后，对版本库进行按需整理。
* 执行命令 `git receive-pack` ，即版本库接收其它版本库 PUSH 来的提交后，版本库会做按需整理操作。

  当版本库接收到其它版本库的 PUSH 请求时，会调用 `git receive-pack` 命令以接收请求。在接收到推送的提交后，对版本库进行按需整理。

* 执行命令 `git rebase -i` 进行交互式变基操作后，会对版本库进行按需整理。
* 执行命令 `git am` 对 mbox 邮箱中通过邮件提交的补丁在版本库中进行应用的操作后，会对版本库做按需整理操作。

对于提供“写操作”的Git版本库，可以免维护。因为对于用做集中式版本控制服务器的 Git 版本库，团队成员会经常向其执行 PUSH（推送）操作进行，而每一次推送都会触发 `git gc --auto` 命令，进行版本库的按需整理。

对于非独立工作的本地工作区，也可以免维护。因为和他人协同工作的本地工作区会经常执行 `git pull` 操作从他人版本库或者集中式版本库拉回新提交，执行 `git pull` 操作会，会触发 `git merge` 操作，因此也会对本地版本库进行按需整理。

Git管家命令使用 `--auto` 参数调用，会进行按需整理。版本库整理操作对于大的项目可能会非常费时，因此按需整理被设计为不会经常触发整理操作，而是具有非常苛刻的触发条件。想要观察到触发版本库整理操作是非常不容易的事情。

松散对象只有超过一定的数量时才会执行。在统计松散对象数量时，为了降低在 `.git/objects/` 目录下搜索松散对象对系统造成的负担，实际上只会对 `.git/objects/17` 目录进行搜索。缺省只有该目录中的对象数目超过27，才会执行搜索。至于为什么只在对象库下选择了一个目录进行松散对象的搜索，这是因为 SHA1 哈希值的前两位组成的目录下面的文件差不多是平均分配的。至于为什么选择 `17` ，不知道对于作者 Junio C Hamano 有什么特殊意义，也许是向 Linus Torvalds 被评选为二十世纪有影响的100人中排名第17进行的致敬。

可以通过设置 `gc.auto` 的值，调整Git管家自动执行时触发版本库整理的频度，但是主要不要将 `gc.auto` 设置为 0，否则 `git gc --auto` 命令永远不会触发版本库的整理。
