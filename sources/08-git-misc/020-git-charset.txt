字符集问题
===========

在本书第1篇“第3章安装Git”中，就已经详细介绍了不同平台对本地字符集（如中\
文）的支持情况，本章再做以简单的概述。

Linux、Mac OS X以及Windows下的Cygwin缺省使用UTF-8字符集。Git运行这这些平\
台下，能够使用本地语言（如中文）写提交说明、命名文件，甚至使用本地语言命\
名分支和里程碑。在这些平台上唯一要做的就是对Git进行如下设置，以便使用了\
本地语言（如中文）命名文件时，能够在状态查看、差异比较时，正确显示文件名。

::

  $ git config --global core.quotepath false

但是如果在Windows平台使用msysGit或者其他平台使用了非UTF-8字符集，要想使\
用本地语言撰写提交说明、命名文件名和目录名就非常具有挑战性了。例如对于使\
用GBK字符集的中文Windows，需要为Git进行如下设置，以便能够在提交说明中正\
确使用中文。

::

  $ git config --system core.quotepath false
  $ git config --system i18n.commitEncoding gbk
  $ git config --system i18n.logOutputEncoding gbk

当像上面那样对\ ``i18n.commitEncoding``\ 进行设置后，如果执行提交，就会\
在提交对象中嵌入编码设置的指令。例如在Windows中使用msysGit执行一次提交，\
在Linux上使用\ :command:`git cat-file`\ 命令查看提交时会出现乱码，需要使\
用\ :command:`iconv`\ 命令对输出进行字符集转换才能正确查看该提交对象。下\
面输出的倒数第三行可以看到\ ``encoding gbk``\ 这条对字符集设置的指令。

::

  $ git cat-file -p HEAD | iconv -f gbk -t utf-8
  tree 00e814cda96ac016bcacabcf4c8a84156e304ac6
  parent 52e6454db3d99c85b1b5a00ef987f8fc6d28c020
  author Jiang Xin <jiangxin@ossxp.com> 1297241081 +0800
  committer Jiang Xin <jiangxin@ossxp.com> 1297241081 +0800
  encoding gbk

  添加中文说明。

因为在提交对象中声明了正确的字符集，因此Linux下可以用\ :command:`git log`\
命令正确显示msysGit生成的包含中文的提交说明。

但是对于非UTF-8字符集平台（如msysGit）下，使用本地字符（如中文）命名文件\
或目录，Git当前版本（1.7.4）的支持尚不完善。文件名和目录名实际上是写在树\
对象中的，Git没能在创建树对象时，将本地字符转换为UTF-8字符进行保存，因而\
在跨平台时造成文件名乱码。例如下面的示例显示的是在Linux平台（UTF-8字符集）\
下查看由msysGit提交的包含中文文件的树对象。注意要在\
:command:`git cat-file`\ 命令的后面通过管道符号调用\ :command:`iconv`\
命令进行字符转换，否则不能正确地显示中文。如果直接在Linux平台检出，检出\
的文件名显示为乱码。

::

  $ git cat-file -p HEAD^{tree} | iconv -f gbk -t utf-8
  100644 blob 8c0b112f56b3b9897007031ea38c130b0b161d5a    说明.txt
