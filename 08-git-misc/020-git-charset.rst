字符集问题
===========

在本书第3章“安装Git”中，就已经详细介绍了不同平台对本地字符集（如中文）的支持情况，本章再做以简单的概述。

Linux、Mac OS X 以及 Windows 下的 Cygwin 缺省使用 UTF-8 字符集。Git 运行这这些平台下，能够使用本地语言（如中文）写提交说明、命名文件，甚至命名分支和里程碑。在这些平台上唯一要做的就是对 Git 进行如下设置，以便使用了本地语言（如中文）命名文件时，能够在状态查看、差异比较时，正确显示文件名。

::

  $ git config --global core.quotepath false

但是如果在 Windows 平台使用 msysGit 或者其他平台使用了非 UTF-8 字符集，要想使用本地语言撰写提交说明、命名文件名和目录名就非常具有挑战性了。例如对于使用 GBK 字符集的中文 Windows，需要为 Git 进行如下设置，以便能够在提交说明中正确使用中文。

::

  $ git config --system core.quotepath false
  $ git config --system i18n.commitEncoding gbk
  $ git config --system i18n.logOutputEncoding gbk

当像上面那样对 `i18n.commitEncoding` 进行设置后，如果执行提交，就会在提交对象中嵌入编码设置的指令。例如在 Windows 中使用 msysGit 执行一次提交，在 Linux 上使用 `git cat-file` 命令查看提交，需要使用 `iconv` 进行字符集转换才能正确查看提交对象中的中文，并且从中可以看到 `encoding gbk` 指令。

::

  $ git cat-file -p HEAD | iconv -f gbk -t utf-8
  tree 00e814cda96ac016bcacabcf4c8a84156e304ac6
  parent 52e6454db3d99c85b1b5a00ef987f8fc6d28c020
  author Jiang Xin <jiangxin@ossxp.com> 1297241081 +0800
  committer Jiang Xin <jiangxin@ossxp.com> 1297241081 +0800
  encoding gbk

  添加中文说明。

因为在提交对象中声明了正确的字符集，因此 Linux 下可以用 `git log` 命令正确显示 msysGit 生成的包含中文的提交说明。

但是对于非 UTF-8 字符集平台（如 msysGit）下，使用本地字符（如中文）命名文件或目录，Git（1.7.3.x 版本）的支持尚不完善。文件名和目录名实际上是写在树对象中的，Git 没能在创建树对象时，将本地字符转换为 UTF-8 字符进行保存，因而在跨平台时造成文件名乱码。例如下面的示例显示的是在 Linux 平台（UTF-8字符集）下查看由 msysGit 提交的包含中文文件的树对象，在命令的后面通过管道符号调用 `iconv` 命令进行字符转换，才能显示出正确中文。如果直接在 Linux 平台检出，会检出一个文件名显示为乱码的文件。

::

  $ git cat-file -p HEAD^{tree} | iconv -f gbk -t utf-8
  100644 blob 8c0b112f56b3b9897007031ea38c130b0b161d5a    说明.txt
