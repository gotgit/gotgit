文件名大小写问题
=================

Linux、Solaris、BSD及其他类Unix操作系统使用的是大小写敏感的文件系统，而\
Windows和Mac OS X（默认安装）的文件系统则是大小写不敏感的文件系统。即用\
文件名\ :file:`README`\ 、\ :file:`readme`\ 以及\ :file:`Readme`\ （混合\
大小写）进行访问，在Linux等操作系统上访问的是不同的文件，而在Windows和\
Mac OS X上则指向同一个文件。换句话说，两个不同文件\ :file:`README`\ 和\
:file:`readme`\ 在Linux等操作系统上可以共存，而在Windows和Mac OS X上，\
这两个文件只能同时存在一个，另一个会被覆盖，因为在大小写不敏感的操作系统\
看来，这两个文件是同一个文件。

如果在Linux上为Git版本库添加了两个文件名仅大小写不同的文件（文件内容各不\
相同），如\ :file:`README`\ 和\ :file:`readme`\ 。当推送到服务器的共享版\
本库上，并在文件名大小写不敏感的操作系统中克隆或同步时，就会出现问题。例\
如在Windows和Mac OS X平台上执行\ :command:`git clone`\ 后，在本地工作区\
中出现两个同名文件中的一个，而另外一个文件被覆盖，这就会导致Git对工作区\
中文件造成误判，在提交时会导致文件内容被破坏。

当一个项目存在跨平台开发的情况时，为了避免这类问题的发生，在一个文件名大\
小写敏感的操作系统（如Linux）中克隆版本库后，应立即对版本库进行如下设置，\
让版本库的行为好似对文件大小写不敏感。

::

  $ git config core.ignorecase true

Windows和Mac OS X在初始化版本库或者克隆一个版本库时，会自动在版本库中包\
含配置变量\ ``core.ignorecase``\ 为\ ``true``\ 的设置，除非版本库不是通\
过克隆而是直接从Linux上拷贝而来。

当版本库包含了\ ``core.ignorecase``\ 为\ ``true``\ 的配置后，文件名在添\
加时便被唯一确定。如果之后修改文件内容及修改文件名中字母的大小写，再提交\
亦不会改变文件名。如果对添加文件时设置的文件名的大小写不满意，需要对文件\
重命名，对于Linux来说非常简单。例如执行下面的命令就可以将\ :file:`changelog`\
文件的文件名修改为\ :file:`ChangeLog`\ 。

::

  $ git mv changelog ChangeLog
  $ git commit

但是对于Windows和Mac OS X，却不能这么操作，因为会拒绝这样的重命名操作：

::

  $ git mv changelog ChangeLog
  fatal: destination exists, source=changelog, destination=ChangeLog

而需要像下面这样，先将文件重命名为另外的一个名称，再执行一次重命名改回正\
确的文件名，如下：

::

  $ git mv changelog non-exist-filename
  $ git mv non-exist-filename ChangeLog
  $ git commit
