Git库管理
*********

版本库管理？那不是管理员要干的事情么，怎么放在“Git独奏”这一部分了？

没有错，这是因为对于 Git，每个用户都是自己版本库的管理员。所以在“Git独奏”的最后一章，来谈一谈 Git 版本库管理的问题。如果下面的问题您没有遇到或者不感兴趣，读者大可以放心的跳过这一章。

* 不小心添加了一个大文件到 Git 库中，用重置命令丢弃了包含大文件的提交，可是版本库不见小，大文件仍在对象库中。
* 从网上克隆来的版本库，可是为什么对象库中找不到对象文件？而且引用目录里也看不见文件？
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

其中以 `refs/heads/` 开头的是分支；以 `refs/remotes/` 开头的是远程版本库分支在本地的映射，会在后面章节介绍；以 `refs/tags/` 开头的是里程碑。按照之前的经验，在 `.git/refs` 目录下应该有相应引用对应的文件才是。

::

  $ find .git/refs/ -type f
  .git/refs/remotes/origin/HEAD
  .git/refs/heads/master

为什么才有两个文件？实际上当运行下面的命令后，文件会更少：

::

  $ git pack-refs --all
  $ find .git/refs/ -type f
  .git/refs/remotes/origin/HEAD

实际上本应该出现在 `.git/refs/` 目录下的引用文件都被打包了，放到一个文本文件 `.git/packed-refs` 文件下了。

::

  $ head -5 .git/packed-refs 
  # pack-refs with: peeled 
  6652a0dce6a5067732c00ef0a220810a7230655e refs/heads/master
  6652a0dce6a5067732c00ef0a220810a7230655e refs/remotes/origin/master
  c9b03a208288aebdbfe8d84aeb984952a16da3f2 refs/tags/A
  ^81993234fc12a325d303eccea20f6fd629412712

看看对象库中的存储，也不是熟悉的模样了。

::

  $ find .git/objects/ -type f
  .git/objects/pack/pack-969329578b95057b7ea1208379a22c250c3b992a.idx
  .git/objects/pack/pack-969329578b95057b7ea1208379a22c250c3b992a.pack

其中以 `.pack` 结尾的文件是打包文件，以 `.idx` 结尾的是索引文件。打包文件和对应的索引文件只是扩展名不同，文件名的其它部分相同，且文件保存于 `.git/objects/pack/` 目录下。

可以用一个命令查看索引中包含的对象：

::

  $ git show-index < .git/objects/pack/pack-*.idx  | head -5
  661 0cd7f2ea245d90d414e502467ac749f36aa32cc4 (0793420b)
  63020 1026d9416d6fc8d34e1edfb2bc58adb8aa5a6763 (ed77ff72)
  3936 15328fc6961390b4b10895f39bb042021edd07ea (13fb79ef)
  3768 1a588ca36e25f58fbeae421c36d2c39e38e991ef (86e3b0bd)
  2022 1a87782f8853c6e11aacba463af04b4fa8565713 (e269ed74)

之所以在克隆版本库时会形成这样的版本库结构，是因为克隆的远程服务器使用了“智能”的通讯协议，将对象打包传输给本地，形成本地版本库的对象库中的一个包含所有对象的包。无疑这样的传输方式 —— 按需传输、打包传输，效率最高。对象库中的对象以及引用文件打包后，会提高访问效率。

暂存区操作引入的大文件
=======================

找一个大的压缩包文件，10MB左右。

::

  $ cp /boot/initrd.img-2.6.32-5-amd64 bigfile
  $ du -sh bigfile
  11M     bigfile

再将 bigfile 复制一份。

::

  $ cp bigfile bigfile.dup


::

  $ git add bigfile bigfile.dup

  $ du -sh .
  33M     .
  $ du -sh .git/
  11M     .git/

  $ find .git/objects/ -type f
  .git/objects/2e/bcd92d0dda2bad50c775dc662c6cb700477aff
  .git/objects/pack/pack-969329578b95057b7ea1208379a22c250c3b992a.idx
  .git/objects/pack/pack-969329578b95057b7ea1208379a22c250c3b992a.pack

  $ git status -s
  A  bigfile
  A  bigfile.dup

  $ git reset HEAD

  $ git status -s
  ?? bigfile
  ?? bigfile.dup

  $ du -sh .git/
  11M     .git/

  $ git fsck
  dangling blob 2ebcd92d0dda2bad50c775dc662c6cb700477aff

  $ git prune
  $ git fsck
  $ du -sh .git/
  236K    .git/

重置操作引入的大文件
====================

::

  $ git add bigfile bigfile.dup
  $ git commit -m "add bigfiles."
  [master 51519c7] add bigfiles.
   2 files changed, 0 insertions(+), 0 deletions(-)
   create mode 100644 bigfile
   create mode 100644 bigfile.dup
  $ du -sh .git/
  11M     .git/

::

  $ git reset --hard HEAD^
  $ du -sh .git/
  11M     .git/

  $ find .git/objects/ -type f
  .git/objects/info/packs
  .git/objects/2e/bcd92d0dda2bad50c775dc662c6cb700477aff
  .git/objects/d9/38dee8fde4e5053b12406c66a19183a24238e1
  .git/objects/51/519c7d8d60e0f958e135e8b989a78e84122591
  .git/objects/pack/pack-969329578b95057b7ea1208379a22c250c3b992a.idx
  .git/objects/pack/pack-969329578b95057b7ea1208379a22c250c3b992a.pack

::

  $ git cat-file -t 2ebcd92
  blob
  $ git cat-file -t d938dee
  tree
  $ git cat-file -t 51519c7
  commit

::

  $ git fsck

::

  $ git fsck --no-reflogs
  dangling commit 51519c7d8d60e0f958e135e8b989a78e84122591

::

  $ git prune
  $ du -sh .git/
  11M     .git/

::

  $ git reflog 
  6652a0d HEAD@{0}: HEAD^: updating HEAD
  51519c7 HEAD@{1}: commit: add bigfiles.

::

  $ git reflog expire --all
  $ git reflog 
  6652a0d HEAD@{0}: HEAD^: updating HEAD
  51519c7 HEAD@{1}: commit: add bigfiles.

::

  $ git reflog expire --expire=now --all
  $ git reflog

::

  $ git prune
  $ du -sh .git/
  244K    .git/

Git管家：git-gc
====================

忘记上面介绍的 git prune 命令，因为 Git 有一个管家命令 git-gc。

::

  $ cp /boot/initrd.img-2.6.32-5-amd64  bigfile
  $ cp bigfile bigfile.dup

::

  $ echo "hello world" >> bigfile.dup 

  $ git add bigfile bigfile.dup
  $ git commit -m "add bigfiles."
  [master c62fa4d] add bigfiles.
   2 files changed, 0 insertions(+), 0 deletions(-)
   create mode 100644 bigfile
   create mode 100644 bigfile.dup

  $ git ls-tree HEAD
  100644 blob 53e51bf8580e9660f66bdda68ccee4bb52875cc8    README
  100644 blob 2ebcd92d0dda2bad50c775dc662c6cb700477aff    bigfile
  100644 blob 9e35f946a30c11c47ba1df351ca22866bc351e7b    bigfile.dup
  040000 tree 37c7859cb49d816c94ea29ab39bdd9d2e9347644    doc
  100644 blob fc58966ccc1e5af24c2c9746196550241bc01c50    gitg.png
  040000 tree f994c1bdd1884e4d34a7dde2daccf0eab5ec8667    src
  100644 blob a756d12ece93452e20e95738befa80a26e842894    treeview.png


  $ git reset --hard HEAD^
  HEAD is now at 6652a0d Add Images for git treeview.


  $ du -sh .git/
  22M     .git/

::

  $ find .git/objects -type f -printf "%-20p\t%s\n"
  .git/objects/0c/844d2a072fd69e71638558216b69ebc57ddb64  233
  .git/objects/2e/bcd92d0dda2bad50c775dc662c6cb700477aff  11184682
  .git/objects/9e/35f946a30c11c47ba1df351ca22866bc351e7b  11184694
  .git/objects/c6/2fa4d6cb4c082fadfa45920b5149a23fd7272e  162
  .git/objects/info/packs 54
  .git/objects/pack/pack-969329578b95057b7ea1208379a22c250c3b992a.idx     2892
  .git/objects/pack/pack-969329578b95057b7ea1208379a22c250c3b992a.pack    80015

::

  $ git gc
  Counting objects: 69, done.
  Delta compression using up to 2 threads.
  Compressing objects: 100% (49/49), done.
  Writing objects: 100% (69/69), done.
  Total 69 (delta 11), reused 63 (delta 8)

::

  $ du -sh .git/
  11M     .git/

  $ find .git/objects -type f -printf "%-20p\t%s\n" | sort
  .git/objects/info/packs 54
  .git/objects/pack/pack-7cae010c1b064406cd6c16d5a6ab2f446de4076c.idx     3004
  .git/objects/pack/pack-7cae010c1b064406cd6c16d5a6ab2f446de4076c.pack    11263033

  $ git reflog
  6652a0d HEAD@{0}: HEAD^: updating HEAD
  c62fa4d HEAD@{1}: commit: add bigfiles.

  $ git reflog expire --expire=now --all

  $ git fsck
  dangling commit c62fa4d6cb4c082fadfa45920b5149a23fd7272e

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

::

  $ git gc
  Counting objects: 65, done.
  Delta compression using up to 2 threads.
  Compressing objects: 100% (45/45), done.
  Writing objects: 100% (65/65), done.
  Total 65 (delta 8), reused 63 (delta 8)

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

::

  $ git gc --prune=now
  Counting objects: 65, done.
  Delta compression using up to 2 threads.
  Compressing objects: 100% (45/45), done.
  Writing objects: 100% (65/65), done.
  Total 65 (delta 8), reused 65 (delta 8)

  $ du -sh .git/
  240K    .git/

运行步骤:

* 如果没有关闭 gc.packrefs，执行： `git pack-refs --all --prune`
* 运行 reflog 过期命令 `git reflog expire --all` # 缺省过期90天的内容。
* 运行 repack。如果设置 `--prune=now` ，则 执行 `repack -d -l -a` ，否则执行 `repack -d -l -A`
* 运行 prune： `git prune --expire xxx` # 缺省两周，如果传递 --prune 参数则使用该参数的值。
* 运行 `rerere gc`
* 如果是运行 `--auto` ，并且未追踪松散对象太多，警告运行 `git prune` 删除。这些对象是应该是两周内的，因为之前已经运行 prune 了。

Git自动管家：git-gc --auto
===========================

哪些命令自动执行 git gc --auto ？

* merge 操作
* receive-pack 操作
* rebase --interactive 操作
* am 操作

真正执行 git-gc 的条件：

* 只在必要的时候进行整理工作。只当有太多松散对象的时候和太多的包的时候才进行整理。
* 如果松散对象数量超过 gc.auto （大于0）的数量，则进行整理（git repack -d -l）。如果 gc.auto 设置为0 ，则不对松散对象打包。
* 如果pack包的数量超过 gc.autopacklimit，则执行 git repack -A 合并为一个包。如果 gc.autopacklimit 为0,则不进行多个包的合并工作。
* Git 是通过检查 objects/17 目录下的松散文件数量，估算出总共有多少松散文件，如果恰好 17 目录没有，或者估算的对象少于 6700，则不会进行。

