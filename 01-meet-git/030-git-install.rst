安装Git
**********

Git 源自 Linux，现在已经可以部署在所有的主流平台之上，包括 Linux, Windows 和 Mac OS X。在开始我们 Git 之旅之前，首先要做的就是安装 Git。

Linux 下的安装
===============

Git 诞生于 Linux 平台并服务于 Linux 核心的版本控制。因此在 Linux 安装 Git 是最方便的。可以通过不同的方式在 Linux 上安装 Git。一种方法是通过 Linux 发行版的包管理器安装已经编译好的二进制格式的 Git 软件包。另外一种方式就是从 Git 源码开始安装。

**包管理器方式安装**

用 Linux 发行版的包管理器形式安装 Git，最为简单，但安装的 Git 可能不是最新的版本。还有一点要注意，就是 Git 在有的 Linux 发行版中可能不叫做 git，而叫做 git-core。这是因为有一款 GNU 软件叫做 GNU 交互工具（GNU Interactive Tools）在有的 Linux 发行版（Deian Lenny版本）中已经占用了 git 的名称，为了以示区分，后来者即作为版本控制系统的 Git ，其软件包在这些平台就被命名为 git-core。不过因为作为版本控制系统的 Git 太有名了，最终导致在一些 Linux 发行版的最新版本中，将 GNU Interactive Tools 软件包改名为 gnuit，将 git-core 改名为 git。所以在下面不同的 Linux 发行版安装 Git 的操作中，会同时看到 git 和 git-core。

* Ubuntu 10.10 (maverick) 或更新版本, Debian (squeeze) 或更新版本：

  其中 git 软件包包含了大部分 Git 命令，是必装的软件包。软件包 git-svn, git-email, gitk 本来也是 Git 软件包的一部分，但是因为有对更多软件包的依赖（如更多 perl 模组，tk等）所以单独作为软件包发布。git-doc 软件包则包含了 Git 的 HTML 格式文档，可以选择安装。
  
  ::

    $ sudo aptitude install git
    $ sudo aptitude install git-doc git-svn git-email gitk 

* Ubuntu 10.04 (lucid) 或更老版本, Debian (lenny) 或更老版本：
 
  在老版本的 Debian 中，软件包 git 实际上是 Gnu Interactive Tools，而非作为版本控制系统的 Git。 

  ::

    $ sudo aptitude install git-core
    $ sudo aptitude install git-doc git-svn git-email gitk 

* RHEL, Fedora, CentOS:

  ::

    $ yum install git
    $ yum install git-svn git-email gitk 

其它发行版安装也与之类似，Git 的软件包成为 git-core 或者直接称为 git。还有相关的几个命令扩展被作为独力软件包发布。

**从源代码开始安装**

访问 Git 的官方网站： http://git-scm.com/ 。下载 Git 源码包，例如: git-1.7.3.5.tar.bz2 。

* 展开源码包，并进入到相应的目录中。

  ::

    $ tar -jxvf git-1.7.3.5.tar.bz2
    $ cd git-1.7.3.5/

* 安装方法写在 INSTALL 文件当中，参照其中的指示完成安装。下面的命令将 Git 安装在 /usr/local/bin 中。

  ::

    $ make prefix=/usr/local all
    $ sudo make prefix=/usr install

* 安装 Git 文档（可选）。编译文档依赖 asciidoc，并且文档编译需要一些时间。

  ::

    $ make prefix=/usr/local doc info
    $ sudo make prefix=/usr/local install-doc install-html install-info

安装完毕之后，就可以在 `/usr/local/bin` 下找到 `git` 命令。

**从Git版本库进行安装**

如果在本地克隆一个 Git 版本库，可以直接通过 Git 版本库同步获得最新的 Git 版本，在下载 Git 源代码时不用等待更多的时间。当然这种方法的前提是已经用其他方法安装好了 Git。

* 克隆 Git 版本库到本地。

  ::

    $ git clone git://git.kernel.org/pub/scm/git/git.git
    $ cd git

* 如果本地已经克隆了一个 Git 版本库，执行在工作区中更新，以获得最新版本的 Git。

  ::

    $ git pull

* 执行清理工作，避免前一次编译的遗留文件造成影响。注意下面的操作将丢弃本地对 Git 代码的改动。

  ::

    $ git clean -fdx
    $ git reset --hard

* 查看 Git 的里程碑，选择最新的版本进行安装。例如当前的正式发布版为 v1.7.3.5 。

  ::

    $ git tag
    ...
    v1.7.3.5

* 检出该版本的代码。

  ::

    $ git checkout v1.7.3.5

* 执行安装。例如安装到 /usr/local 目录下。

  ::

    $ make prefix=/usr/local all doc info
    $ sudo make prefix=/usr/local install install-doc install-html install-info

我在撰写本书的过程中，就通过 Git 版本库的方式安装。在 /opt/git 目录下安装了多个不同版本的 Git，以测试 Git 的兼容性。使用类似下面的脚本。

::

  #!/bin/sh

  for ver in      \
      v1.5.0      \
      v1.7.3.5    \
      v1.7.4-rc1  \
  ; do
      echo "Begin install Git $ver.";
      git reset --hard
      git clean -fdx
      git checkout $ver || exit 1
      make prefix=/opt/git/$ver all && sudo make prefix=/opt/git/$ver install || exit 1
      echo "Installed Git $ver."
  done

Windows 下的安装
=================

Mac 下的安装
==============


帮助
===========

* git help <subcommand>
* git help -w <subcommand>

