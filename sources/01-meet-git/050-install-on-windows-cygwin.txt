Windows下安装和使用Git（Cygwin篇）
=====================================

在Windows下安装和使用Git有两个不同的方案，通过安装msysGit或者通过安装\
Cygwin来使用Git。在这两种不同的方案下，Git的使用和在Linux下使用完全一致。\
再有一个就是基于msysGit的图形界面工具——TortoiseGit，也就是在CVS和SVN时代\
就已经广为人知的Tortoise系列软件的Git版本。TortoiseGit提供和资源管理器的\
整合，提供Git操作的图形化界面。

先介绍通过Cygwin来使用Git的原因，不是因为这是最便捷的方法，如果需要在\
Windows快速安装和使用Git，下节介绍的msysGit才是。之所以将Cygwin放在前面\
介绍是因为本书在介绍Git原理部分以及介绍其他Git相关软件时用到了大量的开源\
工具，这些开源工具在Cygwin下很容易获得，而msysGit的MSYS（Minimal SYStem，\
最简系统）则不能满足我们的需要。因此我建议使用Windows平台的读者在跟随本书\
学习Git的过程中，首选Cygwin，当完成Git的学习后，无论是msysGit或者\
TortoiseGit也都会应对自足。

Cygwin是一款伟大的软件，通过一个小小的DLL（cygwin1.dll）建立Linux和Windows\
系统调用及API之间的转换，实现了Linux下绝大多数软件到Windows的迁移。Cygwin\
通过cygwin1.dll所建立的中间层和诸如VMWare、VirtualBox等虚拟机软件完全不同，\
不会对系统资源进行独占。像VMWare等虚拟机，只要启动一个虚拟机（操作系统），\
即使不在其中执行任何命令，同样会占用大量的系统资源：内存、CPU时间等等。

Cygwin还提供了一个强大易用的包管理工具（setup.exe），实现了几千个开源\
软件包在Cygwin下便捷的安装和升级，Git就是Cygwin下支持的几千个开源软件中\
的一员。

我对Cygwin有着深厚的感情，Cygwin让我在Windows平台能用Linux的方式更有效率\
的做事，使用Linux风格的控制台替换Windows黑乎乎的、冰冷的、由\
:command:`cmd.exe`\ 提供的命令行。Cygwin帮助我逐渐摆脱对Windows的依赖，\
当我完全转换到Linux平台时，没有感到一丝的障碍。


安装Cygwin
-------------

安装Cygwin非常简单，访问其官方网站\ ``http://www.cygwin.com/``\ ，下载\
安装程序——一个只有几百KB的\ :program:`setup.exe`\ ，即可开始安装。

安装过程会让用户选择安装模式，可以选择网络安装、仅下载，或者通过本地软件\
包缓存（在安装过程自动在本地目录下建立软件包缓存）进行安装。如果是第一次\
安装Cygwin，因为本地尚没有软件包缓存，当然只能选择从网络安装，如图3-4所示。


.. figure:: /images/windows/cygwin-2.png
   :scale: 80

   图3-4：选择安装模式

接下来，Cygwin询问安装目录，默认为\ :file:`C:\\cygwin`\ ，如图3-5所示。\
这个目录将作为Cygwin shell环境的根目录（根卷），Windows的各个盘符将挂载\
在根卷一个特殊目录之下。

.. figure:: /images/windows/cygwin-3.png
   :scale: 80

   图3-5：选择安装目录

询问本地软件包缓存目录，默认是\ :program:`setup.exe`\ 所处的目录，\
如图3-6所示。

.. figure:: /images/windows/cygwin-4.png
   :scale: 80

   图3-6：选择本地软件包缓存目录

询问网络连接方式，是否使用代理等，如图3-7所示。默认会选择第一项：“直接网\
络连接”。如果一个团队有很多人要使用Cygwin，架设一个能够提供软件包缓存的\
HTTP代理服务器会节省大量的网络带宽和节省大把的时间。用Debian的apt-cacher-ng\
就可以非常简单的搭建一个软件包代理服务器。图3-7显示的就是我在公司内网安装\
Cygwin时使用了我们公司内网的服务器\ ``bj.ossxp.com``\ 做为HTTP代理的截图，\
端口设置为9999，因为这是apt-cacher-ng的默认端口。

.. figure:: /images/windows/cygwin-5-mirror.png
   :scale: 80

   图3-7：是否使用代理下载Cygwin软件包

选择一个Cygwin源，如图3-8所示。如果在上一个步骤选择了使用HTTP代理服务器，\
就必须选择HTTP协议的Cygwin源。

.. figure:: /images/windows/cygwin-6.png
   :scale: 80

   图3-8：选择Cygwin源

接下来就会从所选的Cygwin源下载软件包索引文件，然后显示软件包管理器界面，\
如图3-9所示。

.. figure:: /images/windows/cygwin-8.png
   :scale: 80

   图3-9：Cygwin软件包管理器

Cygwin的软件包管理器非常强大和易用（如果习惯了其界面）。软件包归类于各个\
分组中，点击分组前的加号就可以展开分组。在展开的Admin分组中，如图3-10所示\
（这个截图不是首次安装Cygwin的截图），有的软件包如\ :program:`libattr1`\
已经安装过了，因为没有新版本而标记为“Keep”（保持）。至于没有安装过并且\
不准备安装的软件包则标记为“Skip”（跳过）。

.. figure:: /images/windows/cygwin-8-expand-admin-group.png
   :scale: 80

   图3-10：Cygwin 软件包管理器展开分组

鼠标点击分组名称后面动作名称（文字“Default”），会进行软件包安装动作的\
切换。例如图3-11，将Admin分组的安装动作由“Default”（默认）切换为“Install”\
（安装），会看到Admin分组下的所有软件包都标记为安装（显示具体要安装的\
软件包版本号）。也可以通过鼠标点击，单独的为软件包进行安装动作的设定，\
可以强制重新安装、安装旧版本、或者不安装。

.. figure:: /images/windows/cygwin-8-expand-admin-group-install.png
   :scale: 80

   图3-11：Cygwin软件包管理器展开分组

当通过软件包管理器对要安装的软件包定制完毕后，点击下一步，开始下载软件包、\
安装软件包和软件包后处理，直至完成安装。根据选择的软件包的多少，网络情况\
以及是否架设有代理服务器，首次安装Cygwin的时间可能从几分钟到几个小时不等。

安装Git
-------------

默认安装的Cygwin没有安装Git软件包。如果在首次安装过程中忘记通过包管理器\
选择安装Git或其他相关软件包，可以在安装后再次运行Cygwin的安装程序\
:program:`setup.exe`\ 。当再次进入Cygwin包管理器界面时，在搜索框中输入git。\
如图3-12所示。

.. figure:: /images/windows/cygwin-8-search-git.png
   :scale: 80

   图3-12：Cygwin软件包管理器中搜索git

从图3-12中看出在Cygwin中包含了很多和Git相关的软件包，把这些Git相关的软件包\
都安装吧，如图3-13所示。

.. figure:: /images/windows/cygwin-8-search-git-install.png
   :scale: 80

   图3-13：Cygwin软件包管理器中安装git

需要安装的其他软件包：

* git-completion:提供Git命令自动补齐功能。安装该软件包会自动安装依赖的\
  bash-completion软件包。

* openssh：SSH客户端，提供Git访问ssh协议的版本库。

* vim：是Git缺省的编辑器。


Cygwin的配置和使用
---------------------

运行Cygwin，就会进入shell环境中，见到熟悉的Linux提示符。如图3-14所示。

.. figure:: /images/windows/cygwin-startup.png
   :scale: 80

   图3-14：运行 Cygwin

显示Cygwin中安装的软件包的版本，可以通过执行\ :program:`cygcheck`\
命令来查看，例如查看cygwin软件包本身的版本：

::

  $ cygcheck -c cygwin
  Cygwin Package Information
  Package              Version        Status
  cygwin               1.7.7-1        OK

如何访问Windows的磁符
^^^^^^^^^^^^^^^^^^^^^^^^

刚刚接触Cygwin的用户遇到的头一个问题就是Cygwin如何访问Windows的各个磁盘\
目录，以及在Windows平台如何访问Cygwin中的目录？

执行\ :program:`mount`\ 命令，可以看到Windows下的盘符映射到\ :file:`/cyg
drive`\ 特殊目录下。

::

  $ mount
  C:/cygwin/bin on /usr/bin type ntfs (binary,auto)
  C:/cygwin/lib on /usr/lib type ntfs (binary,auto)
  C:/cygwin on / type ntfs (binary,auto)
  C: on /cygdrive/c type ntfs (binary,posix=0,user,noumount,auto)
  D: on /cygdrive/d type ntfs (binary,posix=0,user,noumount,auto)

也就是说在Windows下的\ :file:`C:\\Windows`\ 目录，在Cygwin以路径\
:file:`/cygdrive/c/Windows`\ 进行访问。实际上Cygwin提供一个命令\
:program:`cygpath`\ 实现Windows平台和Cygwin之间目录名称的变换。如下：

::

  $ cygpath -u C:\\Windows
  /cygdrive/c/Windows

  $ cygpath -w ~/
  C:\cygwin\home\jiangxin\

从上面的示例也可以看出，Cygwin下的用户主目录（即\
:file:`/home/jiangxin/`\ ）相当于Windows下的\
:file:`C:\\cygwin\\home\\jiangxin\\`\ 目录。

用户主目录不一致的问题
^^^^^^^^^^^^^^^^^^^^^^^^

如果其他某些软件（如msysGit）为Windows设置了HOME环境变量，会影响到Cygwin\
中用户主目录的设置，甚至造成在Cygwin中不同命令有不同的用户主目录的设置。\
例如：Cygwin下Git的用户主目录设置为“/cygdrive/c/Documents and Settings/jiangxin”，\
而SSH客户端软件的主目录为“/home/jiangxin”，这会造成用户的困惑。

出现这种情况，是因为Cygwin确定用户主目录有几个原则，依照顺序确定主目录。\
首先查看系统的HOME环境变量，其次查看\ :file:`/etc/passwd`\ 中为用户设置\
的主目录。有的软件遵照这个原则，而有些Cygwin应用如ssh，却没有使用HOME\
环境变量而直接使用\ :file:`/etc/passwd`\ 中的的设置。要想避免在同一个\
Cygwin环境下有两个不同的用户主目录设置，可以采用下面两种方法。

* 方法1：修改Cygwin启动的批处理文件（如：\
  :file:`C:\\cygwin\\Cygwin.bat`\ ），在批处理的开头添加如下的一行，\
  就可以清除其他软件为Windows引入的HOME环境变量。

  ::

    set HOME=

* 方法2：如果希望使用HOME环境变量指向的主目录，则通过手工编辑\
  :file:`/etc/passwd`\ 文件，将其中用户主目录修改成HOME环境变量\
  所指向的目录。

命令行补齐忽略文件大小写
^^^^^^^^^^^^^^^^^^^^^^^^^

Windows的文件系统忽略文件名大小写，在Cygwin下最好对命令行补齐进行相关\
设置以忽略大小写，这样使用起来更方便。

编辑文件\ :file:`~/.inputrc`\ ，在其中添加设置\
``set completion-ignore-case on``\ ，或者取消已有相关设置前面的井号注释符。\
修改完毕后，再重新进入Cygwin，就可以实现文件名补齐对大小写的忽略。

忽略文件权限的可执行位
^^^^^^^^^^^^^^^^^^^^^^^^^

Linux、Unix、Mac OS X下的可执行文件在文件权限有特殊的设置（设置文件的\
可执行位），Git可以跟踪文件的可执行位，即在添加文件时会把文件的权限也\
记录其中。在Windows上，缺乏对文件可执行位的支持和需要，虽然Cygwin可以模拟\
Linux下的文件授权并对文件的可执行位进行支持，但一来为支持文件权限而调用\
Cygwin的stat()和lstat()函数会比Windows自身的Win32API要慢两倍，二来对于\
非跨平台项目也没有必要对文件权限位进行跟踪，还有其他Windows下的工具及\
操作可能会破坏文件的可执行位，导致Cygwin下的Git认为文件的权限更改需要\
重新提交。通过下面的配置，可以禁止Git对文件权限的跟踪：

::

  $ git config --system core.fileMode false

在此模式下，当已添加到版本库中的文件其权限的可执行位改变时，该文件不会\
显示有改动。新增到版本库的文件，都以\ ``100644``\ 的权限添加（忽略可执行位），\
无论文件本身是否设置为可执行。

关于Cygwin的更多定制和帮助，参见网址：\
``http://www.cygwin.com/cygwin-ug-net/``\ 。

Cygwin下Git的中文支持
-------------------------

Cygwin当前版本1.7.x，对中文的支持非常好。无需任何配置就可以在Cygwin的\
窗口内输入中文，以及执行\ :program:`ls`\ 命令显示中文文件名。这与我记忆\
中的6、7年前的Cygwin 1.5.x完全不一样了。老版本的Cygwin还需要做一些工作\
才能在控制台输入中文和显示中文，但是最新的Cygwin已经完全不需要了。反倒是\
后面要介绍的msysGit的shell环境仍然需要做出类似（老版本Cygwin）的改动才\
能够正常显示和输入中文。

Cygwin默认使用UTF-8字符集，并巧妙的和Windows系统的字符集之间进行转换。\
在Cygwin下执行\ :program:`locale`\ 命令查看Cygwin下正在使用的字符集。

::

  $ locale
  LANG=C.UTF-8
  LC_CTYPE="C.UTF-8"
  LC_NUMERIC="C.UTF-8"
  LC_TIME="C.UTF-8"
  LC_COLLATE="C.UTF-8"
  LC_MONETARY="C.UTF-8"
  LC_MESSAGES="C.UTF-8"
  LC_ALL=

正因如此，Cygwin下的Git对中文支持非常出色，虽然中文Windows本身使用GBK字\
符集，但是在Cygwin下Git的行为就如同工作在UTF-8字符集的Linux下，对中文的\
支持非常的好。

* 在提交时，可以在提交说明中输入中文。
* 显示提交历史，能够正常显示提交说明中的中文字符。
* 可以添加中文文件名的文件，并可以在使用utf-8字符集的Linux环境中克隆及\
  检出。
* 可以创建带有中文字符的里程碑名称。

但是和Linux平台一样，在默认设置下，带有中文文件名的文件，在工作区状态\
输出、查看历史更改概要、以及在补丁文件中，文件名不能正确显示为中文，而是\
用若干8进制编码来显示中文，如下：

::

  $ git status -s
  ?? "\350\257\264\346\230\216.txt"

通过设置变量\ ``core.quotepath``\ 为\ ``false``\ ，就可以解决中文文件名\
在这些Git命令输出中的显示问题。

::

  $ git config --global core.quotepath false
  $ git status -s
  ?? 说明.txt

Cygwin下Git访问SSH服务
----------------------------

在本书第5篇第29章介绍的公钥认证方式访问Git服务，是Git写操作最重要的服务。\
公钥认证方式访问SSH协议的Git服务器时无需输入口令，而且更为安全。使用公钥\
认证就涉及到创建公钥/私钥对，以及在SSH连接时选择哪一个私钥的问题（如果\
建立有多个私钥）。

Cygwin下的openssh软件包提供的ssh命令和Linux下的没有什么区别，也提供\
ssh-keygen命令管理SSH公钥/私钥对。但是Cygwin当前的openssh（版本号：5.7p1-1）\
有一个Bug，偶尔在用Git克隆使用SSH协议的版本库时会中断，无法完成版本库克隆。\
如下：

::

  $ git clone git@bj.ossxp.com:ossxp/gitbook.git
  Cloning into gitbook...
  remote: Counting objects: 3486, done.
  remote: Compressing objects: 100% (1759/1759), done.
  fatal: The remote end hung up unexpectedly MiB | 3.03 MiB/s
  fatal: early EOFs:  75% (2615/3486), 13.97 MiB | 3.03 MiB/s
  fatal: index-pack failed

如果读者也遇到同样的问题，建议使用PuTTY提供的\ :command:`plink.exe`\
做为SSH客户端，替代存在问题的Cygwin自带的ssh命令。

安装PuTTY
^^^^^^^^^^

PuTTY是Windows下一个开源软件，提供SSH客户端服务，还包括公钥管理相关工具。\
访问PuTTY的主页（http://www.chiark.greenend.org.uk/~sgtatham/putty/），\
下载并安装PuTTY。安装完毕会发现PuTTY软件包包含了好几个可执行程序，对于\
和Git整合，下面几个命令会用到。

* Plink：即\ :file:`plink.exe`\ ，是命令行的SSH客户端，用于替代ssh命令。\
  默认安装于\ :file:`C:\\Program Files\\PuTTY\\plink.exe`\ 。

* PuTTYgen：用于管理PuTTY格式的私钥，也可以用于将openssh格式的私钥转换为\
  PuTTY格式的私钥。

* Pageant：是SSH认证代理，运行于后台，负责为SSH连接提供私钥访问服务。

PuTTY格式的私钥
^^^^^^^^^^^^^^^^^

PuTTY使用自定义格式的私钥文件（扩展名为\ :file:`.ppk`\ ），而不能直接使\
用openssh格式的私钥。即用openssh的ssh-keygen命令创建的私钥不能直接被\
PuTTY拿过来使用，必需经过转换。程序PuTTYgen可以实现私钥格式的转换。

运行PuTTYgen程序，如图3-15所示。

.. figure:: /images/windows/putty-keygen-1.png
   :scale: 80

   图3-15：运行PuTTYgen程序

PuTTYgen既可以重新创建私钥文件，也可以通过点击加载按钮（load）读取openssh\
格式的私钥文件，从而可以将其转换为PuTTY格式私钥。点击加载按钮，会弹出文件\
选择对话框，选择openssh格式的私钥文件（如文件\ :file:`id_rsa`\ ），如果\
转换成功，会显示如图3-16的界面。

.. figure:: /images/windows/putty-keygen-2.png
   :scale: 80

   图3-16：PuTTYgen完成私钥加载

然后点击“Save private key”（保存私钥），就可以将私钥保存为PuTTY的\
:file:`.ppk`\ 格式的私钥。例如将私钥保存到文件\
:file:`~/.ssh/jiangxin-cygwin.ppk`\ 中。

Git使用Pageant进行公钥认证
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Git在使用命令行工具Plink（\ :program:`plink.exe`\ ）做为SSH客户端访问SSH\
协议的版本库服务器时，如何选择公钥呢？使用Pageant是一个非常好的选择。\
Pageant是PuTTY软件包中为各个PuTTY应用提供私钥请求的代理软件，当Plink连接\
SSH服务器需要请求公钥认证时，Pageant就会提供给Plink相应的私钥。

运行Pageant，启动后显示为托盘区中的一个图标，在后台运行。当使用鼠标右键\
单击Pageant的图标，就会显示弹出菜单如图3-17所示。

.. figure:: /images/windows/pageant.png
   :scale: 80

   图3-17：Pageant的弹出菜单

点击弹出菜单中的“Add Key”（添加私钥）按钮，弹出文件选择框，选择扩展名为\
:file:`.ppk`\ 的PuTTY格式的公钥，即完成了Pageant的私钥准备工作。

接下来，还需要对Git进行设置，设置Git使用\ :file:`plink.exe`\ 做为SSH客户端，\
而不是缺省的\ :program:`ssh`\ 命令。通过设置GIT_SSH环境变量即可实现。

::

  $ export GIT_SSH=/cygdrive/c/Program\ Files/PuTTY/plink.exe

上面在设置GIT_SSH环境变量的过程中，使用了Cygwin格式的路径，而非Windows\
格式，这是因为Git是在Cygwin的环境中调用\ :program:`plink.exe`\ 命令的，\
当然要使用Cygwin能够理解的路径。

然后就可以用Git访问SSH协议的Git服务器了。运行在后台的Pageant会在需要的\
时候为\ :command:`plink.exe`\ 提供私钥访问服务。但在首次连接一个使用SSH\
协议的Git服务器的时候，很可能会因为远程SSH服务器的公钥没有经过确认导致\
git命令执行失败。如下所示。

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

这是因为首次连接一个SSH服务器时，要对其公钥进行确认（以防止被钓鱼），而\
运行于Git下的\ :program:`plink.exe`\ 没有机会从用户那里获取输入以建立对\
该SSH服务器公钥的信任，因此Git访问失败。解决办法非常简单，就是直接运行\
:program:`plink.exe`\ 连接一次远程SSH服务器，对公钥确认进行应答。如下：

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

输入“y”，将公钥保存在信任链中，以后再次连接就不会弹出该确认应答了。\
当然执行Git命令，也就可以成功执行了。

使用自定义SSH脚本取代Pageant
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

使用Pageant还要在每次启动Pageant时手动选择私钥文件，比较的麻烦。实际上可\
以创建一个脚本对\ :program:`plink.exe`\ 进行封装，在封装的脚本中指定私钥\
文件，这样就可以不必使用Pageant而实现公钥认证了。

例如：创建脚本\ :file:`~/bin/ssh-jiangxin`\ ，文件内容如下了：

::

  #!/bin/sh

  /cygdrive/c/Program\ Files/PuTTY/plink.exe -i \
      c:/cygwin/home/jiangxin/.ssh/jiangxin-cygwin.ppk $*

设置该脚本为可执行。

::

  $ chmod a+x ~/bin/ssh-jiangxin

通过该脚本和远程SSH服务器连接，使用下面的命令：

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


设置GIT_SSH变量，使之指向新建立的脚本，然后就可以脱离Pageant来连接SSH\
协议的Git库了。

::

  $ export GIT_SSH=~/bin/ssh-jiangxin
