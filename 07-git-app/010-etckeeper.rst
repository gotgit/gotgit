Git 的伟大之处，还在于它不仅仅是作为版本库控制系统。Linus 在设计 Git 之初甚至根本不认为它是个版本控制系统。相反，Tolvars 说 Git 是一系列的低端工具用于内容的追踪，基于 Git 可以实现一个版本控制系统。现在 Git 已经是一个最成功的版本控制系统了。

后面几个章节介绍的内容，将使你零略到 Git 的神奇。

etckeeper
=========

Linux / Unix 的用户对 `/etc` 目录都是再熟悉不过了，在这个最重要的目录中保存了大部分软件的配置信息，借以实现软件的配置以及整个系统的启动过程控制。如果你是 Windows 的用户，你可以把 `/etc` 目录视为 Windows 中的注册表，只不过文件化了，可管理了。

这么重要的 `/etc` 目录，如果其中的文件被错误编辑或者删除，将会损失惨重。 `etckeeper` 这个软件可以帮助实现 `/etc` 目录的持续备份，借用分布式版本控制工具，如: git, mercurial, bazaar, darcs 。

那么 etckeeper 是如何实现的呢？我们以 git 作为 etckeeper 的后端为例进行说明，其它的分布式版本控制系统大同小异。

* 将 `/etc` 目录 git 化。将会创建 Git 库于目录 `/etc/.git` 中，`/etc` 目录作为工作区。
* 与系统的包管理器，如 Debian/Ubuntu 的 apt，Redhat 上的 yum 等整合。一旦有软件包安装或删除，对 `/etc` 目录下的改动执行提交操作。
* 除了能够记录 `/etc` 目录中的文件内容，还可以记录文件属性等元信息。因为 `/etc` 目录下的文件的权限设置往往是非常重要和致命的。
* 因为 `/etc` 目录已经是一个版本库了，可以用 git 命令对 `/etc` 下的文件进行操作：查看历史，回退到历史版本...
* 也可以将 `/etc` 克隆到另外的主机中，实现双机备份。

安装 etckeeper
---------------

安装 etckeeper 是一个最简单的活，因为 etckeeper 在主流的 Linux 发行版都有自己的安装包。使用相应 Linux 平台的包管理工具（apt, yum）即可安装。

在 Debian / Ubuntu 上安装 etckeeper 如下：

::

  $ sudo aptitude install etckeeper

安装 etckeeper 软件包，会自动安装上一个分布式版本控制系统工具，除非你已经安装了。这是因为 etckeeper 需要使用一个分布式版本控制系统作为存储管理后端。在 Debian / Ubuntu 上会依据下面的优先级进行安装： `git` > `mercurial` > `bzr` > `darcs` 。

在 Debian / Ubuntu 上，使用 `dpkg -s` 命令查看 etckeeper 的软件包依赖，就会看到这个优先级。

::

  $ dpkg -s etckeeper | grep "^Depends"
  Depends: git-core (>= 1:1.5.4) | git (>= 1:1.7) | mercurial | bzr (>= 1.4~) | darcs, debconf (>= 0.5) | debconf-2.0

配置 etckeeper
---------------

配置 etckeeper 就是要选择好某一分布式版本库控制系统，如 Git；初始化 /etc 目录，并做一次提交。

* 编辑配置文件 `/etc/etckeeper/etckeeper.conf` 。

  只要有下面一条配置就够了。告诉 etckeeper 使用 git 作为数据管理后端。

  ::
  
    VCS="git"

* 初始化 `/etc` 目录。即将其 git 化。

  执行下面的命令（需要以 root 用户身份），会将 `/etc` 目录 git 化。

  ::

    $ sudo etckeeper init

  整个过程可能会比较慢，因为要对 /etc 下的文件执行 `git add` ，因为文件太多，会慢一些。

* 执行第一次提交。

  用 etckeeper 命令而非 git 命令进行提交。

  ::

    $ sudo etckeeper commit "this is the first etckeeper commit..."


  整个过程可能会比较慢，主要是因为 etckeeper 要扫描 `/etc` 下非 root 用户的文件以及特殊权限的文件并进行记录。别忘了 git 本身并不能记录文件属主以及文件权限等信息。

使用 etckeeper
---------------




揭密 etckeeper
---------------

