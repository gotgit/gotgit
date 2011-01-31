Windows 下安装和使用 Git（msysGit篇）
=====================================

运行在 Cygwin 下的 Git 不是直接使用 Windows 的系统调用，而是通过二传手 `cygwin1.dll` 来进行，虽然 Cygwin 的 git 命令能够在 Windows 下的 `cmd.exe` 命令窗口中运行的非常好，但 Cygwin 下的 Git 并不能看作是 Windows 下的原生程序。相比 Cygwin 下的 Git，msysGit 是原生的 Windows 程序，msysGit 下运行的 Git 直接通过 Windows 的系统调用运行。

msysGit 的名字前面的四个字母来源于 MSYS 项目。MSYS 项目源自于 MinGW（Minimalist GNU for Windows，最简GNU工具集），通过增加了一个 bash 提供的shell 环境以及其他相关工具软件，组成了一个最简系统（Minimal SYStem），简称 MSYS。利用 MinGW 提供的工具，以及 Git 针对 MinGW 的一个分支版本，在 Windows 平台为 Git 编译出一个原生应用，接合 MSYS 就组成了 msysGit。

安装 msysGit
-------------

安装 msysGit 非常简单，访问 msysGit 的项目主页（http://code.google.com/p/msysgit/），下载 msysGit。最简单的方式是下载名为 `Git-<VERSION>-preview<DATE>.exe` 的软件包，如：`Git-1.7.3.1-preview20101002.exe` 。如果有时间和耐心，喜欢观察 Git 是如何在 Windows 上是编译为原生应用的，也可以下载带 `msysGit-fullinstall-` 前缀的软件包。

点击下载的安装程序（如 `Git-1.7.3.1-preview20101002.exe` ），开始安装，如图3-18。

.. figure:: images/windows/msysgit-1.png
   :scale: 80

   图3-18：启动 msysGit 安装

默认安装到 `C:\\Program Files\\Git` 目录中。

.. figure:: images/windows/msysgit-3.png
   :scale: 80

   图3-19：选择 msysGit 的安装目录

在安装过程中会询问是否修改环境变量，如图3-20。默认选择“Use Git Bash Only”，即只在 msysGit 提供的 shell 环境（类似 Cygwin）中使用 Git，不修改环境变量。注意如果选择最后一项，会将 msysGit 所有的可执行程序全部加入 Windows 的 PATH 路径中，有的命令会覆盖 Windows 相同文件名的程序（如 find.exe 和 sort.exe）。而且如果选择最后一项，还会为 Windows 添加 HOME 环境变量，如果安装有 Cygwin，Cygwin 会受到 msysGit 引入的 HOME 环境变量的影响（参见前面 3.3.3 节的相关讨论）。

.. figure:: images/windows/msysgit-6.png
   :scale: 80

   图3-20：是否修改系统的环境变量

如果系统中安装有 PuTTY，安装过程还会询问使用内置的 ssh 命令还是 PuTTY 提供的 `plink.exe` ，如图3-21。

.. figure:: images/windows/msysgit-7.png
   :scale: 80

   图3-21：选择 SSH 客户端


还会询问换行符的转换方式，使用默认设置就好。参见图3-22。关于换行符转换，参见本书第8篇相关章节。

.. figure:: images/windows/msysgit-8.png
   :scale: 80

   图3-22：换行符转换方式

根据提示，完成 msysGit 的安装。

msysGit 的配置和使用
---------------------

完成 msysGit 的安装后，点击 Git Bash 图标，启动 msysGit，如图3-23。会发现 Git Bash 的界面和 Cygwin 的非常相像。

.. figure:: images/windows/msysgit-startup.png
   :scale: 80

   图3-23：启动 Git Bash

如何访问 Windows 的磁符
^^^^^^^^^^^^^^^^^^^^^^^^

在 msysGit 下访问 Windows 的各个盘符，要比 Cygwin 简单，直接通过 "`/c`" 即可访问 Windows 的 C: 盘，用 "`/d`" 访问 Windows 的 D: 盘。

::

  $ ls -ld /c/Windows
  drwxr-xr-x  233 jiangxin Administ        0 Jan 31 00:44 /c/Windows

至于 msysGit 的根目录，实际上就是 msysGit 安装的目录，如：“C:\\Program Files\\Git”。

命令行补齐和忽略文件大小写
^^^^^^^^^^^^^^^^^^^^^^^^^^

msysGit 缺省已经安装了 Git 的命令补齐功能。要想实现对文件名命令补齐时忽略大小写，可以修改配置文件 `/etc/inputrc` 。在其中添加设置:

::

  set completion-ignore-case on

msysGit shell 环境的中文支持
--------------------------------

在介绍 Cygwin 的章节中曾经提到过，msysGit 的中文支持相当于老版本的 Cygwin，需要配置才能够实现在 Git Bash 环境下录入中文和显示中文。

为了能在 shell 界面中输入中文，需要修改配置文件 `/etc/inputrc` ，增加或修改相关配置如下：

::

  # disable/enable 8bit input
  set meta-flag on
  set input-meta on
  set output-meta on
  set convert-meta off

关闭 Git Bash 再重启，就可以在 msysGit 的 shell 环境中输入中文了。

::

  $ echo 您好
  您好

但现在最常用的 `ls` 命令的输出对中文支持有问题。下面的命令创建了一个中文文件名的文件，显示文件内容中的中文没有问题，但是显示文件名本身会显示为一串问号。

::

  $ echo 您好 > 您好.txt

  $ cat \*.txt
  您好

  $ ls \*.txt
  ????.txt

实际上 `ls` 命令只要增加参数 `--show-control-chars` 即可正确显示中文。

::

  $ ls --show-control-chars *.txt
  您好.txt

为方便起见，为 `ls` 命令设置一个别名。

::

  $ alias ls="ls --show-control-chars"

  $ ls \*.txt
  您好.txt

将上面的 alias 命令添加到配置文件 `/etc/profile` 中，实现在每次运行 Git Bash 时自动加载。

msysGit 中 Git 的中文支持
--------------------------------

非常遗憾的是 msysGit 中的 Git 对中文支持没有 Cygwin 中的 Git 做的那么好。msysGit 中的 Git 对中文支持的程度，就相当于前面讨论过的 Linux 使用了 GBK 字符集时 Git 的情况。

* 使用 msysGit 提交时，如果在提交说明中输入中文，从 Linux 平台或其他 UTF-8 字符集平台上查看提交说明显示乱码。
* 同样从 Linux 平台或者其他使用 UTF-8 字符集平台进行的提交若提交说明包含中文，在 msysGit 中也显示乱码。
* 如果 msysGit 中添加中文文件名的文件，在 Linux（或其他 utf-8）平台检出文件名显示为乱码。
* 反之亦然。
* 不能创建带有文字符的里程碑名称。


为解决日志显示乱码问题，msysGit 要为 Git 设置参数 i18n.logOutputEncoding，将该参数


以设置提交说明显示所使用的字符集为 gbk，这样使用 `git log` 查看提交说明才能够正确显示其中的中文。

  ::

    $ git config --system i18n.logOutputEncoding gbk

还要为 Git 设置参数 i18n.commitEncoding，设置录入提交说明时所使用的字符集，以便在 commit 对象中对字符集正确标注。

Git 在提交时并不会对提交说明进行从 GBK 字符集到 UTF-8 的转换，但是可以在提交说明中标注所使用的字符集，因此在非 UTF-8 字符集的平台录入中文，需要用下面指令设置录入提交说明的字符集，以便在 commit 对象中嵌入正确的编码说明。

  ::

    $ git config --system i18n.commitEncoding gbk

同样，为了能够让带有中文文件名的文件，在工作区状态输出，查看历史更改概要，以及在补丁文件中，能够正常显示，要为 Git 配置 core.quotepath 变量，将其设置为 false。

  ::

    $ git config --system core.quotepath false
    $ git status -s
    ?? 说明.txt

说明：上面为 Git 配置环境变量时，注意不要影响到 Cygwin 中 Git 的运行。因为 Cygwin 的 Git 和 msysGit 的系统配置文件位置不同，所以上面更改 Git 环境使用了系统级配置文件。


Cygwin/Git 访问 SSH 服务
---------------------------

在本书第5篇第29章介绍的公钥认证方式访问 Git 服务，是 Git 写操作最重要的服务。公钥认证方式访问 SSH 协议的 Git 服务器时无需输入口令，而且更为安全。使用公钥认证就涉及到创建公钥-私钥对，以及在 SSH 连接时选择哪一个私钥的问题（如果建立有多个私钥）。

Cygwin 下的 openssh 软件包提供的 ssh 命令和 Linux 下的没有什么区别，也提供 ssh-keygen 命令管理 SSH 公钥-私钥对。但是 Cygwin 当前的 openssh（版本号：5.7p1-1）有一个 Bug，偶尔在用 Git 克隆使用 SSH 协议的版本库时会中断，无法完成版本库克隆。如下：

::

  $ git clone git@bj.ossxp.com:ossxp/gitbook.git
  Cloning into gitbook...
  The server's host key is not cached in the registry. You
  have no guarantee that the server is the computer you
  think it is.
  The server's rsa2 key fingerprint is:
  ssh-rsa 2048 49:eb:04:30:70:ab:b3:28:42:03:19:fe:82:f8:1a:00
  Connection abandoned.
  fatal: The remote end hung up unexpectedly

如果读者也遇到同样的问题，建议使用 PuTTY 提供的 plink.exe 做为 SSH 客户端，替代存在问题的 Cygwin 自带的 ssh 命令。

安装 PuTTY
^^^^^^^^^^^

PuTTY 是 Windows 下一个开源软件，提供 SSH 客户端服务，还包括公钥管理相关工具。访问 PuTTY 的主页（http://www.chiark.greenend.org.uk/~sgtatham/putty/），下载并安装 PuTTY。安装完毕会发现 PuTTY 软件包包含了好几个可执行程序，对于和 Git 整合，下面几个命令会用到。

* Plink： 即 plink.exe，是命令行的 SSH 客户端，用于替代 ssh 命令。默认安装于 `C:\\Program Files\\PuTTY\\plink.exe` 。
* PuTTYgen ：用于管理 PuTTY 格式的私钥，也可以用于将 openssh 格式的私钥转换为 PuTTY 格式的私钥。
* Pageant ：是 SSH 认证代理，运行于后台，负责为 SSH 连接提供私钥访问服务。

PuTTY 格式的私钥
^^^^^^^^^^^^^^^^^

PuTTY 使用自定义格式的私钥文件（扩展名为 `.ppk` ），而不能直接使用 openssh 格式的私钥。即用 openssh 的 ssh-keygen 命令创建的私钥不能直接被 PuTTY 拿过来使用，必需经过转换。程序 PuTTYgen 可以实现私钥格式的转换。

运行 PuTTYgen 程序，如图3-15所示。

.. figure:: images/windows/putty-keygen-1.png
   :scale: 80

   图3-15：运行 PuTTYgen 程序

PuTTYgen 既可以重新创建私钥文件，也可以通过点击加载按钮（load）读取 openssh 格式的私钥文件，从而可以将其转换为 PuTTY 格式私钥。点击加载按钮，会弹出文件选择对话框，选择 openssh 格式的私钥文件（如文件 id_rsa），如果转换成功，会显示如图3-16的界面。

.. figure:: images/windows/putty-keygen-2.png
   :scale: 80

   图3-16：PuTTYgen 完成私钥加载

然后点击 “Save private key”（保存私钥），就可以将私钥保存为 PuTTY 的 `.ppk` 格式的私钥。例如将私钥保存到文件 `~/.ssh/jiangxin-cygwin.ppk` 中。

Git 使用 Pageant 进行公钥认证
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Git 在使用命令行工具 Plink（ `plink.exe` ）做为 SSH 客户端访问 SSH 协议的版本库服务器时，如何选择公钥呢？使用 Pageant 是一个非常好的选择。Pageant 是 PuTTY 软件包中为各个 PuTTY 应用提供私钥请求的代理软件，当 Plink 连接 SSH 服务器需要请求公钥认证时，Pageant 就会提供给 Plink 相应的私钥。

运行 Pageant ，启动后显示为托盘区中的一个图标，在后台运行。当使用鼠标右键单击 Pageant 的图标，就会显示弹出菜单如图3-17所示。

.. figure:: images/windows/pageant.png
   :scale: 80

   图3-17：Pageant 的弹出菜单

点击弹出菜单中的 “Add Key”（添加私钥）按钮，弹出文件选择框，选择扩展名为 `.ppk` 的 PuTTY 格式的公钥，即完成了 Pageant 的私钥准备工作。

接下来，还需要对 Git 进行设置，设置 Git 使用 `plink.exe` 做为 SSH 客户端，而不是缺省的 `ssh`  命令。通过设置 GIT_SSH 环境变量即可实现。

::

  $ export GIT_SSH=/cygdrive/c/Program\ Files/PuTTY/plink.exe

上面在设置 GIT_SSH 环境变量的过程中，使用了 Cygwin 格式的路径，而非 Windows 格式，这是因为 Git 是在 Cygwin 的环境中调用 `plink.exe` 命令的，当然要使用 Cygwin 能够理解的路径。

然后就可以用 Git 访问 SSH 协议的 Git 服务器了。运行在后台的 Pageant 会在需要的时候为 plink.exe 提供私钥访问服务。但在首次连接一个使用 SSH 协议的 Git 服务器的时候，很可能会因为远程SSH服务器的公钥没有经过确认导致 git 命令执行失败。如下所示。

::

  $ git clone git@bj.ossxp.com:ossxp/gitbook.git
  Cloning into gitbook...
  The server's host key is not cached in the registry. You
  have no guarantee that the server is the computer you
  think it is.
  The server's rsa2 key fingerprint is:
  ssh-rsa 2048 49:eb:04:30:70:ab:b3:28:42:03:19:fe:82:f8:1a:00
  Connection abandoned.
  fatal: The remote end hung up unexpectedly

这是因为首次连接一个 SSH 服务器时，要对其公钥进行确认（以防止被钓鱼），而运行于 Git 下的 `plink.exe` 没有机会从用户那里获取输入以建立对该SSH服务器公钥的信任，因此 Git 访问失败。解决办法非常简单，就是直接运行 `plink.exe` 连接一次远程 SSH 服务器，对公钥确认进行应答。如下：

::

  $ /cygdrive/c/Program\ Files/PuTTY/plink.exe git@bj.ossxp.com
  The server's host key is not cached in the registry. You
  have no guarantee that the server is the computer you
  think it is.
  The server's rsa2 key fingerprint is:
  ssh-rsa 2048 49:eb:04:30:70:ab:b3:28:42:03:19:fe:82:f8:1a:00
  If you trust this host, enter "y" to add the key to
  PuTTY's cache and carry on connecting.
  If you want to carry on connecting just once, without
  adding the key to the cache, enter "n".
  If you do not trust this host, press Return to abandon the
  connection.
  Store key in cache? (y/n)

输入 “y”，将公钥保存在信任链中，以后再次连接就不会弹出该确认应答了。当然执行 Git 命令，也就可以成功执行了。

使用自定义 SSH 脚本取代 Pageant
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

使用 Pageant 还要在每次启动 Pageant 时手动选择私钥文件，比较的麻烦。实际上可以创建一个脚本对 `plink.exe` 进行封装，在封装的脚本中指定私钥文件，这样就可以不必使用 Pageant 而实现公钥认证了。

例如：创建脚本 `~/bin/ssh-jiangxin` ，文件内容如下了：

::

  #!/bin/sh

  /cygdrive/c/Program\ Files/PuTTY/plink.exe -i c:/cygwin/home/jiangxin/.ssh/jiangxin-cygwin.ppk $*

设置该脚本可执行。

::

  $ chmod a+x ~/bin/ssh-jiangxin

通过该脚本和远程 SSH 服务器连接，使用下面的命令：

::

  $ ~/bin/ssh-jiangxin git@bj.ossxp.com
  Using username "git".
  Server refused to allocate pty
  hello jiangxin, the gitolite version here is v1.5.5-9-g4c11bd8
  the gitolite config gives you the following access:
       R          gistore-bj.ossxp.com/.*$
       R          gistore-ossxp.com/.*$
    C  R  W       ossxp/.*$
       R  W       test/repo1
       R  W       test/repo2
       R  W       test/repo3
      @R @W       test/repo4
   @C @R  W       users/jiangxin/.+$


设置 GIT_SSH 变量，使之指向新建立的脚本，然后就可以使用 Git 来连接 SSH 协议的 Git 库了。

::

  $ export GIT_SSH=~/bin/ssh-jiangxin




TortoiseGit 的安装和使用
-------------------------

