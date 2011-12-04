---
layout: master
title: 操作回放
---

<a name="playback"></a>

## 操作回放

本书的部分操作用 ttyrec 录制，查看请访问：[《Git权威指南》——操作回放](screencast.html)。
读者除了可以看到“活”的操作外，还可以从回放当中复制操作的代码。

如果该网页不存在、无法访问，或是您想在本地回放，或者想在其中添加您自己的操作回放，
有两种方式：

方式一：你可以从 Github 上克隆本版本库，编译相关网页。

<a class="click-more"></a>

* 克隆版本库。

        $ git clone git://github.com/gotgit/gotgit.git

* 确认系统中安装了 ruby 和 perl，并通过 rubygems 安装 redcarpet。

        $ gem install redcarpet

* 执行编译。

        $ rake

* 点击生成的页面：[《Git权威指南》——操作回放](screencast.html)。

方式二：版本库中本来就保存了一份已编译文档，只不过缺省没有克隆出来。

> 如果您的系统上缺乏相应的工具软件而无法成功编译，
  在版本库中实际上保存了一份已经编译好的文件，可以通过Git下载，
  并检出到工作区。

<a class="click-more"></a>

* 克隆版本库。

        $ git clone git://github.com/gotgit/gotgit.git

* 添加新的配置，以便获取首次克隆未获取到的远程分支。

        $ git config --add remote.origin.fetch +refs/remotes/*:refs/remotes/*

* 执行获取操作。

        $ git fetch

* 检出分支 refs/remotes/compiled 分支中的内容到工作区。

        $ git checkout compiled -- .

* 执行重置，将已编译文档撤出暂存区，当然工作区中仍然保留。

        $ git reset

* 点击检出的页面：[《Git权威指南》——操作回放](screencast.html)。

如果您自己想把自己录制的操作与他人共享，可以将录制的文件以 ".ttyrec" 扩展名保存到 ttyrec 目录下。
执行 rake 命令，可以自动生成新的播放页面。

