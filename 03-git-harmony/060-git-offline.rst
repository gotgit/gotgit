补丁文件交互
************

之前各个章节版本库间的交互都是通过 `git push` 和/或 `git pull` 命令实现的，这种交互模式是Git使用中最主要的模式，但不是全部。使用补丁文件是另外一种交互方式，适用于参与者众多的大型项目的分布式开发。例如 Git 项目本身的代码提交就主要是由贡献者通过邮件传递补丁文件实现的。下面两个链接就是作者在写书过程中发现并解决的两个Git的Bug。

* 关于Git文档错误的Bugfix:

  http://marc.info/?l=git&m=129248415230151

* 关于git-apply的一个Bugfix:

  http://article.gmane.org/gmane.comp.version-control.git/162100

.. [PATCH v2] git apply: apply patches with -pN (N>1) properly for some 
..    http://marc.info/?l=git&m=129065393315504
..    http://article.gmane.org/gmane.comp.version-control.git/162100

.. [PATCH] Fix typo in git-gc document.
..    http://marc.info/?l=git&m=129248415230151
..    http://article.gmane.org/gmane.comp.version-control.git/163804

这种使用补丁文件进行提交可以提高项目的参与度。任何人都可以参与项目的开发，只要会将提交转化为补丁，会发邮件即可。

创建补丁
===========

Git 提供了将提交批量转换为补丁文件的命令： `git format-patch` 。该命令后面的参数是一个版本范围列表，会将包含在此列表中的提交一一转换为补丁文件，每个补丁文件包含一个序号并以提交说明的第一行作为文件名。

下面演示一下在 user1 工作区，将 master 分支的最近 3 个提交转换为补丁文件。

* 进入 user1 工作区，切换到 master 分支。

  ::

    $ cd /path/to/user1/workspace/hello-world/
    $ git checkout master
    $ git pull

* 执行下面命令将最近三个提交转换为补丁文件。

  ::

    $ git format-patch -s HEAD~3..HEAD
    0001-Fix-typo-help-to-help.patch
    0002-Add-I18N-support.patch
    0003-Translate-for-Chinese.patch

在上面的 `git format-patch` 命令中使用了 `-s` 参数，会在导出的补丁文件中添加当前用户的签名。这个签名并非 GnuPG 式的数字签名，不过是将作者姓名添加到提交说明中而已，和在本书第二篇开头介绍的 `git commit -s` （参见本书第TODO页）命令的效果相同。虽然签名很不起眼，但是对于以补丁方式提交数据却非常重要，因为以补丁方式提交可能因为合并冲突或其他原因使得最终提交的作者显示为管理员（提交者）的ID，在提交说明中加入原始作者的署名信息大概是作者唯一露脸的机会。如果在提交时忘了使用 `-s` 参数添加签名，可以在用 `git format-path` 命令创建补丁文件的时候补救。

看一下补丁文件的文件头，在下面内容中的第7行可以看到新增的签名。

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

补丁文件有一个类似邮件一样的文件头（第1-4行），提交日志的第一行作为邮件标题（Subject），其余提交说明作为邮件内容（如果有的话），文件补丁用三个横线和提交说明分开。

实际上这些补丁文件可以直接拿来作为邮件发送给项目的负责人。Git 提供了一个辅助邮件发送的命令 `git send-email` 。下面用该命令将这三个邮件发送出去。

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

命令 `git send-email` 提供交互式字符界面，输入正确的收件人地址，邮件就批量的发送出去了。

应用补丁
========

在前面通过 `git send-email` 命令发送邮件给 `jiangxin` 用户。现在使用 Linux 上的 `mail` 命令检查一下邮件。

::

  $ mail
  Mail version 8.1.2 01/15/2001.  Type ? for help.
  "/var/mail/jiangxin": 3 messages 3 unread
  >N  1 user1@sun.ossxp.c  Thu Jan 13 18:02   38/1120  [PATCH 1/3] Fix typo: -help to --help.
   N  2 user1@sun.ossxp.c  Thu Jan 13 18:02  227/6207  =?UTF-8?q?=5BPATCH=202/3=5D=20Add=20I18N=20support=2E?=
   N  3 user1@sun.ossxp.c  Thu Jan 13 18:02   95/2893  =?UTF-8?q?=5BPATCH=203/3=5D=20Translate=20for=20Chinese=2E?=
  &

如果邮件不止这三封，需要将三个包含补丁的邮件挑选出来保存到另外的文件中。在 mail 命令的提交符(`&`)下输入命令。

::

  & s 1-3 user1-patches
  "user1-patches" [New file]
  & q

现在就在本地创建了一个包含开发者 user1 的代码补丁邮件的归档文件 `user1-patches` ，这个文件时 mbox 格式的，可以用 `mail` 命令打开。

::

  $ mail -f user1-patches 
  Mail version 8.1.2 01/15/2001.  Type ? for help.
  "user1-patches": 3 messages
  >   1 user1@sun.ossxp.c  Thu Jan 13 18:02   38/1121  [PATCH 1/3] Fix typo: -help to --help.
      2 user1@sun.ossxp.c  Thu Jan 13 18:02  227/6208  =?UTF-8?q?=5BPATCH=202/3=5D=20Add=20I18N=20support=2E?=
      3 user1@sun.ossxp.c  Thu Jan 13 18:02   95/2894  =?UTF-8?q?=5BPATCH=203/3=5D=20Translate=20for=20Chinese=2E?=
  & q

保存在 mbox 中的邮件可以批量的应用在版本库中，使用 `git am` 命令。am 是 apply-email 的缩写。下面就演示一下如何应用补丁。

* 基于 HEAD~3 版本创建一个本地分支，以便在该分支下应用补丁。

  ::

    $ git checkout -b user1 HEAD~3
    Switched to a new branch 'user1'

* 将 mbox 文件 `user1-patches` 中的补丁全部应用在当前分支上。

  ::

    $ git am user1-patches
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
* 提交者（Commit）全都设置为 `user1` ，因为提交是在 `user1` 的工作区完成的。
* 提交说明中的签名信息被保留。实际上 `git am` 命令也可以提供 `-s` 参数，再附加应用补丁用户的签名。

对于不习惯在控制台用 `mail` 命令接收邮件的用户，可以将用户通过附件传递的用 `git format-patch` 命令生成的补丁保存成补丁文件，通过管道符调用 `git am` 命令。

::

  $ ls *.patch
  0001-Fix-typo-help-to-help.patch  0002-Add-I18N-support.patch  0003-Translate-for-Chinese.patch
  $ cat *.patch | git am
  Applying: Fix typo: -help to --help.
  Applying: Add I18N support.
  Applying: Translate for Chinese.

Git 还提供一个命令 `git apply` ，可以应用一般格式的补丁文件，但是不能执行提交，也不能保持补丁中的作者信息。实际上 `git apply` 命令和 GNU `patch` 命令类似，细微差别在本书第七篇第38章补丁中的二进制文件一章予以介绍。

quilt 和 stgit
==============


