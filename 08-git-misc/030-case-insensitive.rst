文件名大小写问题
=================

Linux 上使用的是大小写敏感的文件系统，而 Windows 和 Mac OS X（缺省安装，使用 HFS 文件系统）的文件系统则是大小写不敏感的文件系统。即用文件名 README 和 readme 进行访问，在 Linux 上访问的是两个不同的文件，而在 Windows 和 Mac OS X 则指向同一个文件。换句话说，两个不同文件 README 和 readme 在 Linux 上可以共存，而在 Windows 和 Mac OS X 上，这两个文件只能同时存在一个，另一个会被覆盖，因为在大小写不敏感的操作系统看来，这两个文件是同一个文件。

如果在 Linux 上为 Git 版本库添加了两个文件名仅大小写不同的文件（文件内容各不相同），如 `README` 和 `readme` ，当推送到服务器的共享版本库上，并在文件名大小写不敏感的操作系统中克隆或同步时，就会出现问题。例如在 Windows 和 Mac OS X 平台上执行 `git clone` 后，在本地工作区中出现两个同名文件中的一个，而另外一个文件被覆盖，这就会导致 Git 对工作区中文件造成误判，在提交时会导致文件内容被破坏。

为了避免这个问题，当一个项目存在跨平台开发的情况时，在文件系统大小写敏感的平台（Linux）中克隆版本库后，应立即对版本库进行如下设置，让版本库的行为好似对文件大小写不敏感。

::

  $ git config core.ignorecase true

Windows 和 Mac OS X 在初始化版本库或者克隆一个版本库时，会自动在版本库中包含相应的配置，除非版本库不是通过克隆而是直接从 Linux 上拷贝得来。

当版本库包含了 `core.ignorecase` 为 `true` 的配置后，文件名在添加时便被唯一确定。如果之后修改文件内容及修改文件名中字母的大小写，再提交亦不会改变文件名。如果对添加文件时设置的文件名的大小写不满意，需要对文件重命名，对于 Linux 来说非常简单。例如执行下面的命令就可以将 `changelog` 文件的文件名修改为 `ChangeLog` 。

::

  $ git mv changelog ChangeLog
  $ git commit

但是对于 Windows 和 Mac OS X，却不能这么操作，因为会拒绝这样的重命名操作：

::

  $ git mv changelog ChangeLog
  fatal: destination exists, source=changelog, destination=ChangeLog

而需要像下面这样，先将文件重命名为另外的一个名称，再执行一次重命名改回正确的文件名，如下：

::

  $ git mv changelog non-exist-filename
  $ git mv non-exist-filename ChangeLog
  $ git commit

