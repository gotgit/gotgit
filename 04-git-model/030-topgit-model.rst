Topgit 协同模型
===============

如果没有 Topgit ，就不会有此书。因为发现了 Topgit，才让我下定决心在公司大范围推广；因为 Topgit，激发了我对 Git 的好奇之心。

**我的版本控制系统三个里程碑**

定制开发版本管理的独特问题
---------------------------

从2005年开始我专心于开源软件的研究、二次开发和整合，


在2008 年当我把所有的版本库迁移到 Mercurial（水银，又称为 Hg），并工作在 "Hg + MQ" 模式下，我自以为找到了定制开发版本控制的终极解决方案，那时我们已被 Subversion 的卖主分支折磨的太久了。

TopGit 的项目名称是来自于 Topic Git 的简写，是用于管理多个 Git 的特性分支的工具。如果您对 Hg 的 MQ 有所了解的话，我可以告诉你，TopGit 是用 Git 维护补丁列表的工具；TopGit 就是 MQ 在 Git 中的等价物 ，而且做的更好。 Yes

Subversion 卖主分支是如何解决的。

Hg + MQ 是如何解决的。

Hg + MQ 的问题。

Topgit 原理
------------

Topgit 的安装
-------------------

Topgit 的使用
-------------------


用 Topgit 模式改进 Topgit
---------------------------



群英汇 TopGit 改进 (1): tg push 全部分支
-----------------------------------------

TopGit 的项目名称是来自于 Topic Git 的简写，是用于管理多个 Git 的特性分支的工具。如果您对 Hg 的 MQ 有所了解的话，我可以告诉你，TopGit 是用 Git 维护补丁列表的工具；TopGit 就是 MQ 在 Git 中的等价物 ，而且做的更好。 Yes

   1. 什么是 TopGit？参见 TopGit 手册
   2. TopGit 代码库：http://repo.or.cz/w/topgit.git

群英汇终于决定采用 Git 作为公司内部的代码管理工具，就是因为我们发现了 TopGit。参见：《群英汇版本控制系统的选择：subversion, hg, git》。

在每日的使用过程中，我们也发现了 TopGit 的一些问题，不断的挠到我们的痒处。遵循 ESR的理论 ，我们决定对 TopGit 进行改进，于是就有了我们在 Github 上的 TopGit 版本库： http://github.com/ossxp-com/topgit

最近，我又感觉到 TopGit 一个不便利的地方，今天终于临时决定 Hack。Hack 结束之后，就有了写一个系列文章的想法，于是这个系列文章，就从今天这个最新的 Hack 写起。
为 tg push 命令增加 –all 参数

我之前的一篇文章：《Git 如何拆除核弹起爆码，以及 topgit 0.7到0.8的变迁》，曾经提到过，TopGit 0.7 到 0.8 的一个非常大的改变，就是取消了在 .git/config 中的 强制 non-fast-forward 更新的 push 参数。

在 TopGit 0.7 以及之前的版本，可以通过执行一个简单的 git push 命令，就可以将所有的 TopGit 分支以及相关的 top-bases 分支 PUSH 到服务器上。

但是 TopGit 0.8 版本之后，不再向 .git/config 中添加相关 PUSH 指令，因为强制 non-fast-forward 的 PUSH 会导致多人协同工作时，互相覆盖对方改动！！！但是这么做的结果，也就失去了使用 git push 向远程服务器同步 TopGit 分支的便利。

TopGit 0.8 版本提供了一个新命令 tg push，用于向服务器 PUSH TopGit 分支以及关联的 top-bases 分支。这样，就弥补了不能再使用 git push 和服务器同步 TopGit 以及 top-bases 分支的遗憾了。

一个让人痒痒的问题产生了：

    * tg push 只能 push 当前工作的 TopGit 分支；
    * 或者 tg push 后面加上各个分支的名字，实现对分支的 PUSH
    * 但是 tg push 没有一个 –all 选项，必须一个一个的将需要 PUSH 的 tg 分支罗列出来
    * 我们有的项目的分支有上百个！！！如果改动的多的话，要一个一个切换或者一个一个写在命令行中，太恐怖了。 Sweat

问题的解决：

    * 增加了对 -a 以及 –all 参数的支持
    * 如果用户没有指定分支，并且提供了 -a | –all 参数，则将当前所有 topgit 分支加入同步的分支列表中
    * 创建新的分支，开始写代码：

      $ tg create t/tg_push_all tgmaster
      tg: Creating t/tg_push_all base from tgmaster...
      Switched to a new branch 't/tg_push_all'
      tg: Topic branch t/tg_push_all set up. Please fill .topmsg now and make initial commit.
      tg: To abort: git rm -f .top* && git checkout tgmaster && tg delete t/tg_push_all

      # Hack, Hack, Hack...
      # Test, Test, Test...

      $ git st
      # On branch t/tg_push_all
      # Changes to be committed:
      #   (use "git reset HEAD <file>..." to unstage)
      #
      #       new file:   .topdeps
      #       new file:   .topmsg
      #
      # Changed but not updated:
      #   (use "git add <file>..." to update what will be committed)
      #   (use "git checkout -- <file>..." to discard changes in working directory)
      #
      #       modified:   .topmsg
      #       modified:   tg-push.sh
      #

      $ git ci -a -m "add --all option support to tg_push"
      [t/tg_push_all 7df16a5] add --all option support to tg_push
       3 files changed, 22 insertions(+), 1 deletions(-)
       create mode 100644 .topdeps
       create mode 100644 .topmsg

    * 切换到 master (debian) 分支，编译新的 群英汇 软件包  topgit＋，并安装

      $ git co master
      $ git br
      * master
       t/debian_locations
       t/export_quilt_all
       t/fast_tg_summary
       t/tg_completion_bugfix
       t/tg_patch_cdup
       t/tg_push_all
       tgmaster
      $ make -f debian/rules  debian/patches
      rm -rf debian/patches
      tg export --quilt --all debian/patches
      Exporting t/debian_locations
      Exporting t/export_quilt_all
      Exporting t/fast_tg_summary
      Exporting t/tg_completion_bugfix
      Exporting t/tg_patch_cdup
      Exporting t/tg_push_all
      Exported topic branch  (total 6 topics) to directory debian/patches
      $ git st
      # On branch master
      # Changed but not updated:
      #   (use "git add <file>..." to update what will be committed)
      #   (use "git checkout -- <file>..." to discard changes in working directory)
      #
      #       modified:   debian/patches/series
      #
      # Untracked files:
      #   (use "git add <file>..." to include in what will be committed)
      #
      #       debian/patches/t/tg_push_all.diff
      no changes added to commit (use "git add" and/or "git commit -a")
      $ git add debian/patches/t/tg_patch_all.diff
      $ vi debian/changelog
      edit, edit, edit...
      $ head -5 debian/changelog
      topgit (0.8-1+ossxp7) unstable; urgency=low

       * add --all support to tg patch.

       -- Jiang Xin <jiangxin@ossxp.com>
      $ git ci -a -m "new patch: add --all option support to tg_push."
      [master c927b02] new patch: add --all option support to tg_push.
       3 files changed, 61 insertions(+), 0 deletions(-)
       create mode 100644 debian/patches/t/tg_push_all.diff

      $ dpkg-buildpackage -b -rfakeroot
      ...
      dpkg-deb：正在新建软件包“topgit”，包文件为“../topgit_0.8-1+ossxp7_all.deb”。
       dpkg-genchanges -b >../topgit_0.8-1+ossxp7_amd64.changes
      ...
      $ sudo dpkg -i ../topgit_0.8-1+ossxp7_all.deb
      ...

    * 改动 PUSH 到 Github

      $ git remote -v
      github  git@github.com:ossxp-com/topgit.git (fetch)
      github  git@github.com:ossxp-com/topgit.git (push)
      origin  git@bj.ossxp.com:users/jiangxin/topgit.git (fetch)
      origin  git@bj.ossxp.com:users/jiangxin/topgit.git (push)
      upstream        git://repo.or.cz/topgit.git (fetch)
      upstream        git://repo.or.cz/topgit.git (push)
      $ tg -r github summary
      r     t/debian_locations              [PATCH] make file locations Debian-compatible
      r     t/export_quilt_all              [PATCH] t/export_quilt_all
      r     t/fast_tg_summary               [PATCH] t/fast_tg_summary
      r     t/tg_completion_bugfix          [PATCH] t/tg_completion_bugfix
      r     t/tg_patch_cdup                 [PATCH] t/tg_patch_cdup
      l     t/tg_push_all                   [PATCH] t/tg_push_all
      $ tg -r github push --all
      Everything up-to-date
      Everything up-to-date
      Everything up-to-date
      Everything up-to-date
      Everything up-to-date
      Counting objects: 7, done.
      Delta compression using up to 2 threads.
      Compressing objects: 100% (4/4), done.
      Writing objects: 100% (5/5), 757 bytes, done.
      Total 5 (delta 2), reused 0 (delta 0)
      To git@github.com:ossxp-com/topgit.git
      * [new branch]      refs/top-bases/t/tg_push_all -> refs/top-bases/t/tg_push_all
      * [new branch]      t/tg_push_all -> t/tg_push_all

    * 改完，收工。

相关代码提交：

    * http://github.com/ossxp-com/topgit/commit/7df16a56c0fff942e731d1831332ba7216162c2a



Topgit 分支图显示
------------------

使用 Git + topgit 做版本控制，当 topgit分支（功能分支）非常多并且相互依赖比较复杂时，非常需要有一个直观的图形化的分支依赖图。

联想到我们使用 git 经常用到的 git glog 命令输出，如果 topgit 分支图能够有类似的显示就太好了：

| | * t/unittest
| |/
| *---.   t/message_localize
| |\ \ \
| * | | | t/auth_log_for_fail2ban
|/ / / /
| * | | t/factor_invite
|/ / /
| * | t/factor_ldap
|/ /
| * t/include_macro_for_templates
| * t/multi_language
|/
* master

正在冥思苦想如何实现时，忽然发现 topgit 的 tg-summary 中原来已经有图形输出的实现，是借用 graphviz 工具进行图形化输出…


tg summary 命令的 graphviz 输出

原来 tg summary 命令已经包含了分支关系图的输出，只不过输出的是 graphviz 的 .dot 格式文件。

使用下面的命令可以输出 topgit 分支图：

$ tg summary --graphviz

下面是我们改进后的 tg summary –graphviz 命令的输出

# GraphViz output; pipe to:
#   | dot -Tpng -o
# or
#   | dot -Txlib

digraph G {

  graph [
    rankdir = RL
    label="TopGit Layout\n\n\n"
    fontsize = 14
    labelloc=top
    pad = "0.5,0.5"
  ];

  node [
    shape=box
    fontsize = 12
    fontcolor= blue
    color= blue
  ];

  edge [
    color= green
  ];

  "t/add_know_user_support_for_autoadmingroup" -> "master";
  "t/attach_default_action" -> "master";
  "t/attach_dl_content_type" -> "master";
  "t/auth_actions" -> "t/wikiutil_d";
  "t/auth_by_category_hierarchic" -> "master";
  "t/auth_by_category_hierarchic" -> "t/macro_showcategory";
   ...
}

GraphViz 格式输出文件解说：

    * 头几行已经暗示了如何使用本输出，只要通过管道输入给graphviz的 dot 命令，就可以生成相应的图片
    * graph 小节的 rankdir = RL 指令设置节点的方向。这里是从右至左
    * node 小节的 shape=box 指令，设定输出图片中节点的形状是长方形
    * edge 小节的 color= green 指令，设定输出图片中连接线的颜色为绿色
    * 后面的是数据。即分支的依赖关系，将根据此依赖关系画图

使用 graphviz 显示分支图

首先确认已经安装了 graphviz 软件包。该软件包有30多个命令，其中我们将用到的有：

    * dot：画直连图。将 topgit 的 graphviz 格式输出数据转换为图片。
    * ccomps：对节点进行过滤，如忽略孤立节点，或者只显示当前节点所在的图，而忽略之外的节点。
    * gvpr：图片流编辑器，可以嵌入脚本实现定制的输出。

示例，针对 cosign 的topgit 分支，显示分支图。

命令：

$ tg summary --graphviz | dot -Tpng -o topgit.png

输出的分支图：
分支图的文本输出

还记得本文一开始设置的目标么？类似 git glog 命令的文本分支图显示。

非常令人惊奇的是，居然找到同样有此需求的人，并且已经实现。参见：  http://kerneltrap.org/mailarchive/git/2009/5/20/2922

    * 惊奇一：相同的需求。都是希望获取类似 git glog 的文本分支图显示，或者称为 ascii art 输出。
      文本格式输出的好处除了简单易用外，还可以拷贝粘贴，而图像就不行了。
    * 惊奇二：实现思路相似。都想到了利用 git 现有代码，主要就是 graph.c
    * 惊奇三：作者竟然这么简单就实现了。利用 graphviz 的 gvpr 非常简单的就实现了，重用了 topgit 的 graphviz 输出和 git 的相关代码。

采用拿来主义，最终也实现了文本显示 topgit 分支图的目标。示例：

$ tg graph --header
* t/bugfix_cosign_httponly_quirk
| From: Jiang Xin <worldhello.net@gmail.com>
| Subject: [PATCH] t/bugfix_cosign_httponly_quirk
|
| * t/bugfix_no_retry_report
|/  From: Jiang <jiangxin@ossxp.com>
|   Subject: [PATCH] t/bugfix_no_retry_report
|   
| * t/factor_admin
|/  From: Jiang <jiangxin@ossxp.com>
|   Subject: [PATCH] t/factor_admin
|   
| *   t/message_translation
| |\  From: Jiang <jiangxin@ossxp.com>
| | | Subject: [PATCH] t/message_translation



