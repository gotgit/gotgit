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

msysGit 缺省已经安装了 Git 的命令补齐功能，并且在对文件名命令补齐时忽略大小写。这是因为 msysGit 已经在配置文件 `/etc/inputrc` 中包含了下列的设置:

::

  set completion-ignore-case on

多用户使用 HOME 环境问题
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



msysGit shell 环境的中文支持
--------------------------------

在介绍 Cygwin 的章节中曾经提到过，msysGit 的 shell 环境的中文支持相当于老版本的 Cygwin，需要配置才能够实现录入中文和显示中文。

中文录入问题
^^^^^^^^^^^^^

缺省安装的 msysGit 的 shell 环境无法输入中文。为了能在 shell 界面中输入中文，需要修改配置文件 `/etc/inputrc` ，增加或修改相关配置如下：

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

分页器中文输出问题
^^^^^^^^^^^^^^^^^^^

当对 `/etc/inputrc` 进行正确的配置之后，能够在 shell 下输入中文，但是执行下面的命令会显示乱码。这显然是 `less` 分页器命令导致的问题。

::

  $ echo 您好 | less
  <C4><FA><BA><C3>

通过管道符调用分页器命令 `less` 后，原本的中文输出变成了乱码显示。这将会导致 Git 很多命令的输出都会出险中文乱码问题，因为 Git 大量的使用 `less` 命令做为分页器。之所以 `less` 命令出险乱码，是因为该命令没有把中文当作正常的字符，可以通过设置 LESSCHARSET 环境变量，将 utf-8 编码字符视为正规字符显示，则中文就能正常显示了。下面的操作，可以在 `less` 分页器中正常显示中文。

::

  $ export LESSCHARSET=utf-8
  $ echo 您好 | less
  您好  

编辑配置文件 `/etc/profile` ，将对环境变量 LESSCHARSET 的设置加入其中，以便 msysGit 的 shell 环境一启动即加载。

::

  declare -x LESSCHARSET=utf-8

ls 命令对中文文件名的显示
^^^^^^^^^^^^^^^^^^^^^^^^^^

最常用的显示目录和文件名列表的命令 `ls` 对中文文件名的显示有问题。下面的命令创建了一个中文文件名的文件，显示文件内容中的中文没有问题，但是显示文件名本身会显示为一串问号。

::

  $ echo 您好 > 您好.txt

  $ cat \*.txt
  您好

  $ ls \*.txt
  ????.txt

实际上只要在 `ls` 命令后添加参数 `--show-control-chars` 即可正确显示中文。

::

  $ ls --show-control-chars *.txt
  您好.txt

为方便起见，可以为 `ls` 命令设置一个别名，这样就不必在输入 `ls` 命令时输入长长的参数了。

::

  $ alias ls="ls --show-control-chars"

  $ ls \*.txt
  您好.txt

将上面的 alias 命令添加到配置文件 `/etc/profile` 中，实现在每次运行 Git Bash 时自动加载。

msysGit 中 Git 的中文支持
--------------------------------

非常遗憾的是 msysGit 中的 Git 对中文支持没有 Cygwin 中的 Git 做的那么好，msysGit 中的 Git 对中文支持的程度，就相当于前面讨论过的 Linux 使用了 GBK 字符集时 Git 的情况。

* 未经配置的 msysGit 提交时，如果在提交说明中输入中文，从 Linux 平台或其他 UTF-8 字符集平台上查看提交说明显示乱码。
* 同样从 Linux 平台或者其他使用 UTF-8 字符集平台进行的提交，若提交说明包含中文，在未经配置的 msysGit 中也显示乱码。
* 如果使用 msysGit 向版本库中添加带有中文文件名的文件，在 Linux（或其他 utf-8）平台检出文件名显示为乱码。反之亦然。
* 不能创建带有中文字符的引用（里程碑、分支等）。

如果希望版本库中出现使用中文文件名的文件，最好不要使用 msysGit，而是使用 Cygwin 下的 Git。而如果只是想在提交说明中使用中文，经过一定的设置 msysGit 还是可以实现的。

为了解决日志显示乱码问题，msysGit 要为 Git 设置参数 i18n.logOutputEncoding，将日志输出编码设置为 gbk。

::

  $ git config --system i18n.logOutputEncoding gbk

Git 在提交时并不会对提交说明进行从 GBK 字符集到 UTF-8 的转换，但是可以在提交说明中标注所使用的字符集，因此在非 UTF-8 字符集的平台录入中文，需要用下面指令设置录入提交说明的字符集，以便在 commit 对象中嵌入正确的编码说明。为了使 msysGit 提交时输入的中文说明能够在 Linux 或其他使用 UTF-8 编码的平台中正确显示，还必须对参数 i18n.commitEncoding 设置。

::

  $ git config --system i18n.commitEncoding gbk


同样，为了能够让带有中文文件名的文件，在工作区状态输出，查看历史更改概要，以及在补丁文件中，能够正常显示，要为 Git 配置 core.quotepath 变量，将其设置为 false。但是要注意在 msysGit 中添加中文文件名的文件，只能在 msysGit 环境中正确显示，而在其他环境（Linux, Mac OS X, Cygwin）中文件名会出现乱码。

::

  $ git config --system core.quotepath false
  $ git status -s
  ?? 说明.txt

注意：如果同时安装了 Cygwin 和 msysGit 时，为 msysGit 配置的上述 Git 环境变量，不要影响到 Cygwin 环境中的 Git。幸好 Cygwin 和 msysGit 环境中的 Git 的系统配置文件位置不同，所以上面为 msysGit 设置 Git 环境时使用了系统级配置文件。

使用 SSH 协议
------------------


TortoiseGit 的安装和使用
-------------------------

