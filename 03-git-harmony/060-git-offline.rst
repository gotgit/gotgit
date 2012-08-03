补丁文件交互
************

之前各个章节版本库间的交互都是通过\ :command:`git push`\ 和/或\
:command:`git pull`\ 命令实现的，这是Git最主要的交互模式，但并不是全部。\
使用补丁文件是另外一种交互方式，适用于参与者众多的大型项目进行分布式开发。\
例如Git项目本身的代码提交就主要由贡献者通过邮件传递补丁文件实现的。\
作者在写书过程中发现了Git的两个bug，就是以补丁形式通过邮件贡献给Git项目的，\
下面两个链接就是相关邮件的存档。

* 关于Git文档错误的bugfix：

  http://marc.info/?l=git&m=129248415230151

* 关于\ :command:`git-apply`\ 的一个bugfix：

  http://article.gmane.org/gmane.comp.version-control.git/162100


.. [PATCH v2] git apply: apply patches with -pN (N>1) properly for some 
.. http://marc.info/?l=git&m=129065393315504
.. http://article.gmane.org/gmane.comp.version-control.git/162100
.. [PATCH ] Fix typo in git-gc document.
.. http://marc.info/?l=git&m=129248415230151
.. http://article.gmane.org/gmane.comp.version-control.git/163804

这种使用补丁文件进行提交的方式可以提高项目的参与度。因为任何人都可以参与\
项目的开发，只要会将提交转化为补丁，会发邮件即可。

创建补丁
===========

Git提供了将提交批量转换为补丁文件的命令：\ :command:`git format-patch`\ 。\
该命令后面的参数是一个版本范围列表，会将包含在此列表中的提交一一转换为\
补丁文件，每个补丁文件包含一个序号并从提交说明中提取字符串作为文件名。

下面演示一下在user1工作区中，如何将\ ``master``\ 分支的最近3个提交转换为\
补丁文件。

* 进入user1工作区，切换到\ ``master``\ 分支。

  ::

    $ cd /path/to/user1/workspace/hello-world/
    $ git checkout master
    $ git pull

* 执行下面的命令将最近三个提交转换为补丁文件。

  ::

    $ git format-patch -s HEAD~3..HEAD
    0001-Fix-typo-help-to-help.patch
    0002-Add-I18N-support.patch
    0003-Translate-for-Chinese.patch

在上面的\ :command:`git format-patch`\ 命令中使用了\ ``-s``\ 参数，会在\
导出的补丁文件中添加当前用户的签名。这个签名并非GnuPG式的数字签名，不过\
是将作者姓名添加到提交说明中而已，和在本书第2篇开头介绍的\
:command:`git commit -s`\ 命令的效果相同。虽然签名很不起眼，但是对于以\
补丁方式提交数据却非常重要，因为以补丁方式提交可能因为合并冲突或其他原因\
使得最终提交的作者显示为管理员（提交者）的ID，在提交说明中加入原始作者的\
署名信息大概是作者唯一露脸的机会。如果在提交时忘了使用\ ``-s``\ 参数添加\
签名，可以在用\ :command:`git format-path`\ 命令创建补丁文件的时候补救。

看一下补丁文件的文件头，在下面代码中的第7行可以看到新增的签名。

::

   1 From d81896e60673771ef1873b27a33f52df75f70515 Mon Sep 17 00:00:00 2001
   2 From: user1 <user1@sun.ossxp.com>
   3 Date: Mon, 3 Jan 2011 23:48:56 +0800
   4 Subject: [PATCH 1/3] Fix typo: -help to --help.
   5 
   6 
   7 Signed-off-by: user1 <user1@sun.ossxp.com>
   8 ---
   9  src/main.c |    2 +-
  10  1 files changed, 1 insertions(+), 1 deletions(-)

补丁文件有一个类似邮件一样的文件头（第1-4行），提交日志的第一行作为邮件\
标题（Subject），其余提交说明作为邮件内容（如果有的话），文件补丁用三个\
横线和提交说明分开。

实际上这些补丁文件可以直接拿来作为邮件发送给项目的负责人。Git提供了一个\
辅助邮件发送的命令\ :command:`git send-email`\ 。下面用该命令将这三个补\
丁文件以邮件形式发送出去。

::

  $ git send-email *.patch
  0001-Fix-typo-help-to-help.patch
  0002-Add-I18N-support.patch
  0003-Translate-for-Chinese.patch
  The following files are 8bit, but do not declare a Content-Transfer-Encoding.
      0002-Add-I18N-support.patch
      0003-Translate-for-Chinese.patch
  Which 8bit encoding should I declare [UTF-8]? 
  Who should the emails appear to be from? [user1 <user1@sun.ossxp.com>]
 
  Emails will be sent from: user1 <user1@sun.ossxp.com>  
  Who should the emails be sent to? jiangxin
  Message-ID to be used as In-Reply-To for the first email? 
  ...
  Send this email? ([y]es|[n]o|[q]uit|[a]ll): a
  ...

命令\ :command:`git send-email`\ 提供交互式字符界面，输入正确的收件人地\
址，邮件就批量地发送出去了。

应用补丁
========

在前面通过\ :command:`git send-email`\ 命令发送邮件给\ ``jiangxin``\ 用\
户。现在使用 Linux 上的\ :command:`mail`\ 命令检查一下邮件。

::

  $ mail
  Mail version 8.1.2 01/15/2001.  Type ? for help.
  "/var/mail/jiangxin": 3 messages 3 unread
  >N  1 user1@sun.ossxp.c  Thu Jan 13 18:02   38/1120  [PATCH 1/3] Fix typo: -help to --help.
   N  2 user1@sun.ossxp.c  Thu Jan 13 18:02  227/6207  =?UTF-8?q?=5BPATCH=202/3=5D=20Add=20I18N=20support=2E?=
   N  3 user1@sun.ossxp.c  Thu Jan 13 18:02   95/2893  =?UTF-8?q?=5BPATCH=203/3=5D=20Translate=20for=20Chinese=2E?=
  &

如果邮件不止这三封，需要将三个包含补丁的邮件挑选出来保存到另外的文件中。
在 mail 命令的提示符(`&`)下输入命令。

::

  & s 1-3 user1-mail-archive
  "user1-mail-archive" [New file]
  & q

上面的操作在本地创建了一个由开发者user1的补丁邮件组成的归档文件\
``user1-mail-archive``\ ，这个文件是mbox格式的，可以用\ :command:`mail`\
命令打开。

::

  $ mail -f user1-mail-archive 
  Mail version 8.1.2 01/15/2001.  Type ? for help.
  "user1-mail-archive": 3 messages
  >   1 user1@sun.ossxp.c  Thu Jan 13 18:02   38/1121  [PATCH 1/3] Fix typo: -help to --help.
      2 user1@sun.ossxp.c  Thu Jan 13 18:02  227/6208  =?UTF-8?q?=5BPATCH=202/3=5D=20Add=20I18N=20support=2E?=
      3 user1@sun.ossxp.c  Thu Jan 13 18:02   95/2894  =?UTF-8?q?=5BPATCH=203/3=5D=20Translate=20for=20Chinese=2E?=
  & q

保存在mbox中的邮件可以批量的应用在版本库中，使用\ :command:`git am`\
命令。\ ``am``\ 是\ ``apply email``\ 的缩写。下面就演示一下如何应用补丁。

* 基于\ ``HEAD~3``\ 版本创建一个本地分支，以便在该分支下应用补丁。

  ::

    $ git checkout -b user1 HEAD~3
    Switched to a new branch 'user1'

* 将mbox文件\ ``user1-mail-archive``\ 中的补丁全部应用在当前分支上。

  ::

    $ git am user1-mail-archive
    Applying: Fix typo: -help to --help.
    Applying: Add I18N support.
    Applying: Translate for Chinese.

* 补丁成功应用上了，看看提交日志。

  ::

    $ git log -3 --pretty=fuller
    commit 2d9276af9df1a2fdb71d1e7c9ac6dff88b2920a1
    Author:     Jiang Xin <jiangxin@ossxp.com>
    AuthorDate: Thu Jan 13 18:02:03 2011 +0800
    Commit:     user1 <user1@sun.ossxp.com>
    CommitDate: Thu Jan 13 18:21:16 2011 +0800

        Translate for Chinese.
        
        Signed-off-by: Jiang Xin <jiangxin@ossxp.com>
        Signed-off-by: user1 <user1@sun.ossxp.com>

    commit 41227f492ad37cdd99444a5f5cc0c27288f2bca4
    Author:     Jiang Xin <jiangxin@ossxp.com>
    AuthorDate: Thu Jan 13 18:02:02 2011 +0800
    Commit:     user1 <user1@sun.ossxp.com>
    CommitDate: Thu Jan 13 18:21:15 2011 +0800

        Add I18N support.
        
        Signed-off-by: Jiang Xin <jiangxin@ossxp.com>
        Signed-off-by: user1 <user1@sun.ossxp.com>

    commit 4a3380fb7ae90039633dec84acc2aab85398efad
    Author:     user1 <user1@sun.ossxp.com>
    AuthorDate: Thu Jan 13 18:02:01 2011 +0800
    Commit:     user1 <user1@sun.ossxp.com>
    CommitDate: Thu Jan 13 18:21:15 2011 +0800

        Fix typo: -help to --help.
        
        Signed-off-by: user1 <user1@sun.ossxp.com>

从提交信息上可以看出：

* 提交的时间信息使用了邮件发送的时间。

* 作者（Author）的信息被保留，和补丁文件中的一致。

* 提交者（Commit）全都设置为\ ``user1``\ ，因为提交是在\ ``user1``\
  的工作区完成的。

* 提交说明中的签名信息被保留。实际上\ :command:`git am`\ 命令也可以提供\
  ``-s``\ 参数，在提交说明中附加执行命令用户的签名。

对于不习惯在控制台用\ :command:`mail`\ 命令接收邮件的用户，可以通过邮件\
附件，U盘或其他方式获取\ :command:`git format-patch`\ 生成的补丁文件，\
将补丁文件保存在本地，通过管道符调用\ :command:`git am`\ 命令应用补丁。

::

  $ ls *.patch
  0001-Fix-typo-help-to-help.patch  0002-Add-I18N-support.patch  0003-Translate-for-Chinese.patch
  $ cat *.patch | git am
  Applying: Fix typo: -help to --help.
  Applying: Add I18N support.
  Applying: Translate for Chinese.

Git还提供一个命令\ :command:`git apply`\ ，可以应用一般格式的补丁文件，\
但是不能执行提交，也不能保持补丁中的作者信息。实际上\ :command:`git apply`\
命令和 GNU\ :command:`patch`\ 命令类似，细微差别在本书第7篇第38章\
“补丁中的二进制文件”予以介绍。

StGit和Quilt
================

一个复杂功能的开发一定是由多个提交来完成的，对于在以接收和应用补丁文件为\
开发模式的项目中，复杂的功能需要通过多个补丁文件来完成。补丁文件因为要经\
过审核才能被接受，因此针对一个功能的多个补丁文件一定要保证各个都是精品：\
补丁1用来完成一个功能点，补丁2用来完成第二个功能点，等等。一定不能出现这\
样的情况：补丁3用于修正补丁1的错误，补丁10改正了补丁7中的文字错误，等等。\
这样就带来补丁管理的难题。

实际上基于特性分支的开发又何尝不是如此？在将特性分支归并到开发主线前，要\
接受团队的评审，特性分支的开发者一定想将特性分支上的提交进行重整，把一些\
提交合并或者拆分。使用变基命令可以实现提交的重整，但是操作起来会比较困难，\
有什么好办法呢？

StGit
-------

Stacked Git（http://www.procode.org/stgit/）简称StGit就是解决上述两个难\
题的答案。实际上StGit在设计上参考了一个著名的补丁管理工具Quilt，并且可以\
输出Quilt兼容的补丁列表。在本节的后半部分会介绍Quilt。

StGit是一个Python项目，安装起来还是很方便的。在Debian/Ubuntu下，可以直接\
通过包管理器安装：

::

  $ sudo aptitude install stgit stgit-contrib

下面还是用\ ``hello-world``\ 版本库，进行StGit的实践。

* 首先检出\ ``hello-world``\ 版本库。

  ::

    $ cd /path/to/my/workspace/ 
    $ git clone file:///path/to/repos/hello-world.git stgit-demo
    $ cd stgit-demo

* 在当前工作区初始化StGit。

  ::

    $ stg init

* 现在补丁列表为空。

  ::

    $ stg series

* 将最新的三个提交转换为StGit补丁。

  ::

    $ stg uncommit -n 3
    Uncommitting 3 patches ...
      Now at patch "translate-for-chinese"
    done

* 现在补丁列表中有三个文件了。

  第一列是补丁的状态符号。加号(+)代表该补丁已经应用在版本库中，大于号(>)\
  用于标识当前的补丁。

  ::

    $ stg ser
    + fix-typo-help-to-help
    + add-i18n-support
    > translate-for-chinese

* 现在查看\ ``master``\ 分支的日志，发现和之前没有两样。

  ::

    $ git log -3 --oneline
    c4acab2 Translate for Chinese.
    683448a Add I18N support.
    d81896e Fix typo: -help to --help.

* 执行StGit补丁出栈的命令，会将补丁撤出应用。使用\ ``-a``\ 参数会将所有\
  补丁撤出应用。

  ::

    $ stg pop
    Popped translate-for-chinese
    Now at patch "add-i18n-support"
    $ stg pop -a
    Popped add-i18n-support -- fix-typo-help-to-help
    No patch applied

* 再来看版本库的日志，会发现最新的三个提交都不见了。

  ::

    $ git log -3 --oneline
    10765a7 Bugfix: allow spaces in username.
    0881ca3 Refactor: use getopt_long for arguments parsing.
    ebcf6d6 blank commit for GnuPG-signed tag test.

* 查看补丁列表的状态，会看到每个补丁前都用减号(-)标识。

  ::

    $ stg ser
    - fix-typo-help-to-help
    - add-i18n-support
    - translate-for-chinese

* 执行补丁入栈，即应用补丁，使用命令\ :command:`stg push`\ 或者\
  :command:`stg goto`\ 命令，注意\ :command:`stg push`\ 命令和\
  :command:`git push`\ 命令风马牛不相及。

  ::

    $ stg push
    Pushing patch "fix-typo-help-to-help" ... done (unmodified)
    Now at patch "fix-typo-help-to-help"
    $ stg goto add-i18n-support
    Pushing patch "add-i18n-support" ... done (unmodified)
    Now at patch "add-i18n-support"

* 现在处于应用\ ``add-i18n-support``\ 补丁的状态。这个补丁有些问题，本地\
  化语言模板有错误，我们来修改一下。

  ::

    $ cd src/
    $ rm locale/helloworld.pot 
    $ make po
    xgettext -s -k_ -o locale/helloworld.pot main.c
    msgmerge locale/zh_CN/LC_MESSAGES/helloworld.po locale/helloworld.pot -o locale/temp.po
    . 完成。
    mv locale/temp.po locale/zh_CN/LC_MESSAGES/helloworld.po

* 现在查看工作区，发现工作区有改动。

  ::

    $ git status -s
     M locale/helloworld.pot
     M locale/zh_CN/LC_MESSAGES/helloworld.po

* 不要将改动添加暂存区，也不要提交，而是执行\ :command:`stg refresh`\
  命令，更新补丁。

  ::

    $ stg refresh
    Now at patch "add-i18n-support"

* 这时再查看工作区，发现本地修改不见了。

  ::

    $ git status -s

* 执行\ :command:`stg show`\ 会看到当前的补丁\ ``add-i18n-support``\
  已经更新。

  ::

    $ stg show
    ...

* 将最后一个补丁应用到版本库，遇到冲突。这是因为最后一个补丁是对中文本地\
  化文件的翻译，因为翻译前的模板文件被更改了所以造成了冲突。

  ::

    $ stg push
    Pushing patch "translate-for-chinese" ... done (conflict)
    Error: 1 merge conflict(s)
           CONFLICT (content): Merge conflict in
           src/locale/zh_CN/LC_MESSAGES/helloworld.po
    Now at patch "translate-for-chinese"

* 这个冲突文件很好解决，直接编辑冲突文件\ :file:`helloworld.po`\ 即可。\
  编辑好之后，注意一下第50行和第62行是否像下面写的一样。

  ::

    50 "    hello -h, --help\n"
    51 "            显示本帮助页。\n"
    ...
    61 msgid "Hi,"
    62 msgstr "您好,"  

* 执行\ :command:`git add`\ 命令完成冲突解决。

  ::

    $ git add locale/zh_CN/LC_MESSAGES/helloworld.po

* 不要提交，而是使用\ :command:`stg refresh`\ 命令更新补丁，同时更新提交。

  ::

    $ stg refresh
    Now at patch "translate-for-chinese"
    $ git status -s

* 看看修改后的程序，是不是都能显示中文了。

  ::

    $ ./hello 
    世界你好。
    (version: v1.0-5-g733c6ea)
    $ ./hello Jiang Xin
    您好, Jiang Xin.
    (version: v1.0-5-g733c6ea)
    $ ./hello -h
    ...

* 导出补丁，使用命令\ :command:`stg export`\ 。导出的是Quilt格式的补丁集。

  ::

    $ cd /path/to/my/workspace/stgit-demo/ 
    $ stg export -d patches
    Checking for changes in the working directory ... done

* 看看导出补丁的目标目录。

  ::

    $ ls patches/
    add-i18n-support  fix-typo-help-to-help  series  translate-for-chinese

* 其中文件\ :file:`series`\ 是补丁文件的列表，列在前面的补丁先被应用。

  ::

    $ cat patches/series 
    # This series applies on GIT commit d81896e60673771ef1873b27a33f52df75f70515
    fix-typo-help-to-help
    add-i18n-support
    translate-for-chinese

通过上面的演示可以看出StGit可以非常方便的对提交进行整理，整理提交时无需\
使用复杂的变基命令，而是采用：提交StGit化，修改文件，执行\ :command:`stg refresh`\
的工作流程即可更新补丁和提交。StGit还可以将补丁导出为补丁文件，\
虽然导出的补丁文件没有像\ :command:`git format-patch`\ 那样加上代表顺序\
的数字前缀，但是用文件\ :file:`series`\ 标注了补丁文件的先后顺序。实际\
上可以在执行\ :command:`stg export`\ 时添加\ ``-n``\ 参数为补丁文件添加\
数字前缀。

StGit还有一些功能，如合并补丁/提交，插入新补丁/提交等，请参照StGit帮助，\
恕不一一举例。

Quilt
-------

Quilt是一款补丁列表管理软件，用Shell语言开发，安装也很简单，在Debian/Ubuntu\
上直接用下面的命令即可安装：

::

  $ sudo aptitude install quilt

Quilt约定俗成将补丁集放在项目根目录下的子目录\ :file:`patches`\ 中，否则\
需要通过环境变量\ ``QUILT_PATCHES``\ 对路径进行设置。为了减少麻烦，在上\
面用\ :command:`stg export`\ 导出补丁的时候就导出到了\ :file:`patches`\
目录下。

简单说一下Quilt的使用，会发现真的和StGit很像，实际上是先有的Quilt，后有\
的StGit。

* 重置到三个提交前的版本，否则应用补丁的时候会失败。还不要忘了删除\
  :file:`src/locale`\ 目录。

  ::

    $ git reset --hard HEAD~3
    $ rm -rf src/locale/

* 显示补丁列表

  ::

    $ quilt series
    01-fix-typo-help-to-help
    02-add-i18n-support
    03-translate-for-chinese

* 应用一个补丁。

  ::

    $ quilt push
    Applying patch 01-fix-typo-help-to-help
    patching file src/main.c

    Now at patch 01-fix-typo-help-to-help

* 下一个补丁是什么？

  ::

    $ quilt next
    02-add-i18n-support

* 应用全部补丁。

  ::

    $ quilt push -a
    Applying patch 02-add-i18n-support
    patching file src/Makefile
    patching file src/locale/helloworld.pot
    patching file src/locale/zh_CN/LC_MESSAGES/helloworld.po
    patching file src/main.c

    Applying patch 03-translate-for-chinese
    patching file src/locale/zh_CN/LC_MESSAGES/helloworld.po

    Now at patch 03-translate-for-chinese

Quilt的功能还有很多，请参照Quilt的联机帮助，恕不一一举例。
