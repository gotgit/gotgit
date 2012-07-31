Mac OS X下安装和使用Git
==========================

Mac OS X 被称为最人性化的操作系统，工作在Mac上是件非常惬意的事情，工作中\
怎能没有Git？

以二进制发布包的形式安装
-------------------------

Git在Mac OS X中也有好几种安装方法。最为简单的方式是安装\ :file:`.dmg`\
格式的安装包。

访问git-osx-installer的官方网站：\
``http://code.google.com/p/git-osx-installer/``\ ，下载Git安装包。\
安装包带有\ :file:`.dmg`\ 扩展名，是苹果磁盘镜像（Apple Disk Image）格式\
的软件发布包。从官方网站上下载文件名类似\
:file:`git-<version>-<arch>-leopard.dmg`\ 的安装包文件，例如：\
:file:`git-1.7.3.5-x86_64-leopard.dmg`\ 是64位的安装包，\
:file:`git-1.7.3.5-i386-leopard.dmg`\ 是32位的安装包。建议选择64位的软件包，\
因为Mac OS X 10.6 雪豹（或更新版本）完美的兼容32位和64位（开机按住键盘\
数字3和2进入32位系统，按住6和4进入64位系统），即使在核心处于32位架构下，\
也可以放心的运行64位软件包。

苹果的\ :file:`.dmg`\ 格式的软件包实际上是一个磁盘映像，安装起来非常方便，\
点击该文件就直接挂载到Finder中，并打开，如图3-1所示。

.. figure:: /images/meet-git/mac-install-1.png
   :scale: 100

   图3-1：在 Mac OS X 下打开 .dmg 格式磁盘镜像

其中带有一个正在解包图标的文件（扩展名为\ :file:`.pkg`\ ）是Git的安装程序，\
另外的两个脚本程序，一个用于应用的卸载（\ :file:`uninstall.sh`\ ），\
另外一个带有长长文件名的脚本可以在Git安装后执行的，为非终端应用注册Git的\
安装路径，因为Git部署在标准的系统路径之外\ :file:`/usr/local/git/bin`\ 。

点击扩展名为\ :file:`.pkg`\ 的安装程序，开始Git的安装，根据提示按步骤\
完成安装，如图3-2所示。

.. figure:: /images/meet-git/mac-install-2.png
   :scale: 100

   图3-2：在 Mac OS X 下安装 Git。

安装完毕，git会被安装到\ :file:`/usr/local/git/bin/`\ 目录下。重启终端\
程序，才能让\ :file:`/etc/paths.d/git`\ 文件为PATH环境变量中添加的新路径\
注册生效。然后就可以在终端中直接运行\ :program:`git`\ 命令了。

安装Xcode
-------------------------

App Store安装Xcode

安装完毕，可以运行下面命令查看Xcode安装路径。

::

  $ xcode-select --print-path
  /Applications/Xcode.app/Contents/Developer

路径并不在PATH中，可以运行\ :command:`xcrun`\ 调用在Xcode路径中的Git工具。

::

  $ xcrun git --version
  git version 1.7.9.6 (Apple Git-31.1)

为了方便在终端命令行下运行Git，可以用

::

  $ cat /etc/paths.d/xcode 
  /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin
  /Applications/Xcode.app/Contents/Developer/usr/bin

或者打开 Xcode，Preference -> Downloads -> Components -> Command Line Tools (install)

.. end new


Mac OS X基于Unix内核，因此也可以很方便的通过源码编译的方式进行安装，但是\
缺省安装的Mac OS X缺乏相应的开发工具，需要安装苹果提供的Xcode软件包。在\
Mac随机附送的光盘（Mac OS X Install DVD）的可选安装文件夹下就有Xcode的\
安装包（如图3-3所示），通过随机光盘安装Xcode可以省去了网络下载的麻烦，\
要知道Xcode有3GB以上。

.. figure:: /images/meet-git/xcode-install.png
   :scale: 100

   图3-3：在Mac OS X下安装Xcode。

使用Homebrew安装Git
-------------------------

Mac OS X有好几个包管理器实现对一些开源软件在Mac OS X上的安装和升级进行\
管理。有传统的MacPort、Fink，还有更为简单易用的Homebrew。下面就介绍一下\
如何通过Homebrew包管理器，以源码包编译的方式安装Git。

Homebrew用Ruby语言开发，支持千余种开源软件在Mac OS X中的部署和管理。\
Homebrew项目托管在Github上，网址为：\ ``https://github.com/mxcl/homebrew``\ 。

首先是安装Homebrew，执行下面的命令：

::

  $ ruby -e \
    "$(curl -fsSL https://gist.github.com/raw/323731/install_homebrew.rb)"

安装完成后，Homebrew的主程序安装在\ :file:`/usr/local/bin/brew`\ ，\
在目录\ :file:`/usr/local/Library/Formula/`\ 下保存了所有Homebrew支持的\
软件的安装指引文件。

运行\ :command:`brew`\ 安装Git，使用下面的命令。

::

  $ brew install git

使用Homebrew方式安装，Git被安装在\ :file:`/usr/local/Cellar/git/1.7.3.5`\ ，\
可执行程序自动在\ :file:`/usr/local/bin`\ 目录下创建符号连接，可以直接\
在终端程序中访问。

通过\ :command:`brew list`\ 命令可以查看安装的开源软件包。

::

  $ brew list
  git

也可以查看某个软件包安装的详细路径和安装内容。

::

  $ brew list git
  /usr/local/Cellar/git/1.7.3.5/bin/gitk
  ...

从Git源码进行安装
-------------------------

如果需要安装历史版本的Git或是安装尚在开发中的未发布版本的Git，就需要从源\
码安装或通过克隆Git源码库进行安装。既然Homebrew就是通过源码编译方式安装\
Git的，那么也应该可以直接从源码进行安装，但是使用Homebrew安装Git和直接通\
过Git源码安装并不完全等同，例如Homebrew安装Git的过程中，是通过下载已经编\
译好的Git文档包进行安装，而非从头对文档进行编译。

直接通过源码安装Git包括文档，遇到主要的问题就是文档的编译，因为Git文档\
编译所需要的相关工具没有在Xcode中提供。但是这些工具可以通过Homebrew进行\
安装。下面工具软件的安装过程可能会遇到一些小麻烦，不过大多可以通过参考\
命令输出予以解决。

::

  $ brew install asciidoc
  $ brew install docbook2x
  $ brew install xmlto

当编译源码及文档的工具部署完全后，就可以通过源码编译Git。

::

  $ make prefix=/usr/local all doc info
  $ sudo make prefix=/usr/local install \
    install-doc install-html install-info

命令自动补齐
-------------------------

Git通过bash-completion软件包实现命令补齐，在Mac OS X下可以通过Homebrew\
进行安装。

::

  $ brew search completion
  bash-completion
  $ brew install bash-completion
  ...
  Add the following lines to your ~/.bash_profile file:
  if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
  fi
  ...

根据bash-completion安装过程中的提示，修改文件\ :file:`~/.bash_profile`\
文件，并在其中加入如下内容，以便在终端加载时自动启用命令补齐。

::

  if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
  fi

将Git的命令补齐脚本拷贝到bash-completion对应的目录中。

::

  $ cp contrib/completion/git-completion.bash \
       $(brew --prefix)/etc/bash_completion.d/

不用重启终端程序，只需要运行下面的命令，即可立即在当前的shell中加载命令补齐。

::

  . $(brew --prefix)/etc/bash_completion

其他辅助工具的安装
-------------------------

本书中还会用到一些常用的GNU或其他开源软件，在Mac OS X下也可以通过Homebrew\
进行安装。这些软件包有：

* gnupg：数字签名和加密工具。在为Git版本库建立签名里程碑时会用到。
* md5sha1sum：生成MD5或SHA1摘要。在研究Git版本库中的对象过程中会用到。
* cvs2svn：CVS版本库迁移到SVN或Git的工具。在版本库迁移时会用到。
* stgit：Git的补丁和提交管理工具。
* quilt：一种补丁管理工具。在介绍Topgit时用到。

在Mac OS X下能够使用到的Git图形工具除了Git软件包自带的\ :command:`gitk`\
 和\ :command:`git gui`\ 之外，还可以安装GitX。下载地址：

* GitX的原始版本：\ ``http://gitx.frim.nl/``\ 。
* 或GitX的一个分支版本，提供增强的功能：
  https://github.com/brotherbard/gitx/downloads

Git的图形工具一般需要在本地克隆版本库的工作区中执行，为了能和Mac OS X有\
更好的整合，可以安装插件实现和Finder的整合。在git-osx-installer的官方网站：\
``http://code.google.com/p/git-osx-installer/``\ ，有两个以\
:file:`OpenInGitGui-`\ 和\ :file:`OpenInGitX-`\ 为前缀的软件包，\
可以分别实现和\ :command:`git gui`\ 以及\ :command:`gitx`\ 的整合：在\
Finder\ 中进入工作区目录，点击对应插件的图标，启动\ :command:`git gui`\
或\ :command:`gitx`\ 。

中文支持
-------------------

由于Mac OS X采用Unix内核，在中文支持上和Linux相近，请参照前面介绍Git在\
Linux下安装中3.1.5节相关内容。
