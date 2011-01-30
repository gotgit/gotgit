Windows 下的安装和使用
======================

在 Windows 下安装和使用 Git 同样非常简单，可以通过 mSysGit 或者 Cygwin 来安装 Git，使用方法和在 Linux 下一样。还有在 CVS 和 SVN 时代就已经广为人知的 Tortoise 系列软件也有了 Git 的版本 —— TortoiseGit，提供和资源管理器的整合，提供 Git 操作的图形化界面。

Cygwin 下 Git 的安装和使用
---------------------------

Cygwin 是一款伟大的软件，通过一个小小的DLL（cygwin1.dll）建立 Linux 和 Windows 系统调用及API之间的转换，实现了 Linux 下绝大多数软件到 Windows 的迁移。Cygwin 通过 cygwin1.dll 所建立的中间层和诸如 VMWare、VirtualBox 等虚拟机软件完全不同，不会对系统资源进行独占。像 VMWare 等虚拟机，只要启动一个虚拟机（操作系统），即使不在其中执行任何命令，同样会占用大量的系统资源：内存、CPU时间等等。

Cygwin 还提供了一个强大易用的包管理工具（setup.exe），实现 Cygwin 下便捷的软件包的安装和升级。

使用 Cygwin 安装 Git 不是最快捷的方法，下节介绍的 msysgit 才是。但是之所以将 Cygwin 放在前面介绍是因为本书在介绍 Git 过程中还涉及到其他相关的开源软件，使用 Cygwin 可以在 Windows 平台下对本书大部分内容加以实践，而使用 msysgit 会遇到挑战。再有一个原因就是我对 Cygwin 的深厚感情：Cygwin 让我在 Windows 平台能用 Linux 的方式做事、更有效率，并最终帮助我逐渐的脱离 Window 平台。

安装 Cygwin
^^^^^^^^^^^^^

安装 Cygwin 非常简单，访问其官方网站 http://www.cygwin.com/ ，下载安装程序 —— 一个只有几百KB的 `setup.exe` ，即可开始安装。

安装过程会让用户选择安装模式，可以选择网络安装、仅下载，或者通过本地已经包含Cygwin软件包缓存的本地目录进行安装。如果是第一次安装 Cygwin，本地尚没有软件包缓存，只能选择从网络安装，如图3-4所示。


.. figure:: images/windows/cygwin-2.png
   :scale: 80

   图3-4：选择网络安装或是本地安装

询问安装目录，默认为 `C:\\cygwin` ，如图3-5所示。

.. figure:: images/windows/cygwin-3.png
   :scale: 80

   图3-5：选择安装目录

询问本地软件包缓存目录，默认是 `setup.exe` 所处的目录，如图3-6所示。

.. figure:: images/windows/cygwin-4.png
   :scale: 80

   图3-6：选择本地软件包缓存目录

询问网络连接方式，是否使用代理等，如图3-7所示。默认会选择第一项：“直接网络连接”。如果一个团队很多人都要安装 Cygwin，建议架设一个能够提供软件包缓存的代理服务器，用 Debian 的 apt-cacher-ng 就可以非常简单的实现。这样当下载一个其他人已经下载过的软件包，就可以以本地网络速度获取到。图3-7中就选择了运行在我们公司内网的服务器 `bj.ossxp.com` 的代理服务器，端口为 9999 （apt-cacher-ng的默认端口）。

.. figure:: images/windows/cygwin-5-mirror.png
   :scale: 80

   图3-7：是否使用代理下载 Cygwin 软件包

选择一个 Cygwin 源，如图3-8所示。如果在上一个步骤选择了使用本地代理服务器，就必须选择 HTTP 协议的 Cygwin 源。

.. figure:: images/windows/cygwin-6.png
   :scale: 80

   图3-8：选择 Cygwin 源

接下来就会从所选的 Cygwin 源下载软件包索引文件，然后显示软件包管理器界面，如图3-9所示。

.. figure:: images/windows/cygwin-8.png
   :scale: 80

   图3-9：Cygwin 软件包管理器

Cygwin 的软件包管理器非常强大和易用（如果习惯了其界面）。软件包归类于各个分组中，点击分组前的加号就可以展开分组。如图3-10所示。可以看到展开的 Admin 分组，有的软件包如 `libattr1` 已经安装且没有新版本库（Cygwin 再次安装/升级过程的截图），会显示为 “Keep”。至于没有安装过且不准备安装的软件包则标记为 “Skip”。

.. figure:: images/windows/cygwin-8-expand-admin-group.png
   :scale: 80

   图3-10：Cygwin 软件包管理器展开分组

鼠标点击分组名称后面动作名称，如字符“Default”，会进行软件包安装动作的切换。例如图3-11，将 Admin 分组的安装动作由缺省（Default）切换为安装（Install），会看到 Admin 分组下的所有软件包都标记为安装（显示具体要安装的软件包版本号）。也可以通过鼠标点击单独设置软件包的安装动作。

.. figure:: images/windows/cygwin-8-expand-admin-group-install.png
   :scale: 80

   图3-11：Cygwin 软件包管理器展开分组

当对安装的软件包内容定制完毕后，点击下一步，开始下载软件包、安装软件包和软件包后处理，直至完成安装。

安装 Git
^^^^^^^^^^^^^

默认安装的 Cygwin 没有安装 Git 软件包。如果在首次安装过程中没有在包管理器中选择安装 Git，可以在安装后再次运行 Cygwin 的安装程序 `setup.exe` 。当再次进入 Cygwin 包管理器界面时，在搜索框中输入 git。如图3-12所示。

.. figure:: images/windows/cygwin-8-search-git.png
   :scale: 80

   图3-12：Cygwin 软件包管理器中搜索 git

从图3-12中看出在 Cygwin 中包含了很多和 Git 相关的软件包，把这些 Git 相关的软件包都安装吧，如图3-13所示。

.. figure:: images/windows/cygwin-8-search-git-install.png
   :scale: 80

   图3-13：Cygwin 软件包管理器中安装 git



msysgit 的安装和使用
-------------------------

TortoiseGit 的安装和使用
-------------------------

帮助
===========

* git help <subcommand>
* git help -w <subcommand>

