Windows下安装和使用Git（msysGit篇）
=====================================

运行在Cygwin下的Git不是直接使用Windows的系统调用，而是通过二传手\
:file:`cygwin1.dll`\ 来进行，虽然Cygwin的git命令能够在Windows下的\
:program:`cmd.exe`\ 命令窗口中运行的非常好，但Cygwin下的Git并不能看作是\
Windows下的原生程序。相比Cygwin下的Git，msysGit是原生的Windows程序，\
msysGit下运行的Git直接通过Windows的系统调用运行。

msysGit的名字前面的四个字母来源于MSYS项目。MSYS项目源自于MinGW\
（Minimalist GNU for Windows，最简GNU工具集），通过增加了一个bash提供的\
shell环境以及其他相关工具软件，组成了一个最简系统（Minimal SYStem），\
简称MSYS。利用MinGW提供的工具，以及Git针对MinGW的一个分支版本，在Windows\
平台为Git编译出一个原生应用，结合MSYS就组成了msysGit。

安装msysGit
-------------

安装msysGit非常简单，访问msysGit的项目主页（http://code.google.com/p/msysgit/），\
下载msysGit。最简单的方式是下载名为\ :file:`Git-<VERSION>-preview<DATE>.exe`\
的软件包，如：\ :file:`Git-1.7.3.1-preview20101002.exe`\ 。\
如果有时间和耐心，喜欢观察Git是如何在Windows上是编译为原生应用的，\
也可以下载带\ :file:`msysGit-fullinstall-`\ 前缀的软件包。

点击下载的安装程序（如\ :file:`Git-1.7.3.1-preview20101002.exe`\ ），\
开始安装，如图3-18。

.. figure:: /images/windows/msysgit-1.png
   :scale: 80

   图3-18：启动msysGit安装

默认安装到\ :file:`C:\\Program Files\\Git`\ 目录中。

.. figure:: /images/windows/msysgit-3.png
   :scale: 80

   图3-19：选择msysGit的安装目录

在安装过程中会询问是否修改环境变量，如图3-20。默认选择“Use Git Bash Only”，\
即只在msysGit提供的shell环境（类似Cygwin）中使用Git，不修改环境变量。\
注意如果选择最后一项，会将msysGit所有的可执行程序全部加入Windows的PATH\
路径中，有的命令会覆盖Windows相同文件名的程序（如\ :command:`find.exe`\
和\ :command:`sort.exe`\ ）。而且如果选择最后一项，还会为Windows添加HOME\
环境变量，如果安装有Cygwin，Cygwin会受到msysGit引入的HOME环境变量的影响\
（参见前面3.3.3节的相关讨论）。

.. figure:: /images/windows/msysgit-6.png
   :scale: 80

   图3-20：是否修改系统的环境变量

还会询问换行符的转换方式，使用默认设置就好。参见图3-21。关于换行符转换，\
参见本书第8篇相关章节。

.. figure:: /images/windows/msysgit-8.png
   :scale: 80

   图3-21：换行符转换方式

根据提示，完成msysGit的安装。

msysGit的配置和使用
---------------------

完成msysGit的安装后，点击Git Bash图标，启动msysGit，如图3-22。会发现\
Git Bash 的界面和Cygwin的非常相像。

.. figure:: /images/windows/msysgit-startup.png
   :scale: 80

   图3-22：启动Git Bash

如何访问Windows的磁符
^^^^^^^^^^^^^^^^^^^^^^^^

在msysGit下访问Windows的各个盘符，要比Cygwin简单，直接通过\ :file:`/c`\
即可访问Windows的C:盘，用\ :file:`/d`\ 访问Windows的D:盘。

::

  $ ls -ld /c/Windows
  drwxr-xr-x  233 jiangxin Administ        0 Jan 31 00:44 /c/Windows

至于msysGit的根目录，实际上就是msysGit安装的目录，如：“C:\\Program Files\\Git”。

命令行补齐和忽略文件大小写
^^^^^^^^^^^^^^^^^^^^^^^^^^

msysGit缺省已经安装了Git的命令补齐功能，并且在对文件名命令补齐时忽略大小写。\
这是因为msysGit已经在配置文件\ :file:`/etc/inputrc`\ 中包含了下列的设置：

::

  set completion-ignore-case on

msysGit的shell环境的中文支持
--------------------------------

在介绍Cygwin的章节中曾经提到过，msysGit的shell环境的中文支持相当于老版本\
的Cygwin，需要配置才能够实现录入中文和显示中文。

中文录入问题
^^^^^^^^^^^^^

缺省安装的msysGit的shell环境无法输入中文。为了能在shell界面中输入中文，\
需要修改配置文件\ :file:`/etc/inputrc`\ ，增加或修改相关配置如下：

::

  # disable/enable 8bit input
  set meta-flag on
  set input-meta on
  set output-meta on
  set convert-meta off

关闭Git Bash再重启，就可以在msysGit的shell环境中输入中文了。

::

  $ echo 您好
  您好

分页器中文输出问题
^^^^^^^^^^^^^^^^^^^

当对\ :file:`/etc/inputrc`\ 进行正确的配置之后，能够在shell下输入中文，\
但是执行下面的命令会显示乱码。这显然是\ :program:`less`\ 分页器命令导致\
的问题。

::

  $ echo 您好 | less
  <C4><FA><BA><C3>

通过管道符调用分页器命令\ :program:`less`\ 后，原本的中文输出变成了乱码\
显示。这将会导致Git很多命令的输出都会出现中文乱码问题，因为Git大量的使用\
:program:`less`\ 命令做为分页器。之所以\ :program:`less`\ 命令出现乱码，\
是因为该命令没有把中文当作正常的字符，可以通过设置LESSCHARSET环境变量，\
将utf-8编码字符视为正规字符显示，则中文就能正常显示了。下面的操作，可以在\
:program:`less`\ 分页器中正常显示中文。

::

  $ export LESSCHARSET=utf-8
  $ echo 您好 | less
  您好  

编辑配置文件\ :file:`/etc/profile`\ ，将对环境变量LESSCHARSET的设置加入\
其中，以便msysGit的shell环境一启动即加载。

::

  declare -x LESSCHARSET=utf-8

ls命令对中文文件名的显示
^^^^^^^^^^^^^^^^^^^^^^^^^^

最常用的显示目录和文件名列表的命令\ :program:`ls`\ 对中文文件名的显示有\
问题。下面的命令创建了一个中文文件名的文件，显示文件内容中的中文没有问题，\
但是显示文件名本身会显示为一串问号。

::

  $ echo 您好 > 您好.txt

  $ cat \*.txt
  您好

  $ ls \*.txt
  ????.txt

实际上只要在\ :program:`ls`\ 命令后添加参数\ :command:`--show-control-chars`\
即可正确显示中文。

::

  $ ls --show-control-chars *.txt
  您好.txt

为方便起见，可以为\ :program:`ls`\ 命令设置一个别名，这样就不必在输入\
:program:`ls`\ 命令时输入长长的参数了。

::

  $ alias ls="ls --show-control-chars"

  $ ls \*.txt
  您好.txt

将上面的\ :command:`alias`\ 命令添加到配置文件\ :file:`/etc/profile`\
中，实现在每次运行Git Bash时自动加载。

msysGit中Git的中文支持
--------------------------------

非常遗憾的是msysGit中的Git对中文支持没有Cygwin中的Git做的那么好，msysGit\
中的Git对中文支持的程度，就相当于前面讨论过的Linux使用了GBK字符集时Git的\
情况。

* 未经配置的msysGit提交时，如果在提交说明中输入中文，从Linux平台或其他\
  UTF-8字符集平台上查看提交说明显示乱码。

* 同样从Linux平台或者其他使用UTF-8字符集平台进行的提交，若提交说明包含中\
  文，在未经配置的msysGit中也显示乱码。

* 如果使用msysGit向版本库中添加带有中文文件名的文件，在Linux（或其他utf-8）\
  平台检出文件名显示为乱码。反之亦然。

* 不能创建带有中文字符的引用（里程碑、分支等）。

如果希望版本库中出现使用中文文件名的文件，最好不要使用msysGit，而是使用\
Cygwin下的Git。而如果只是想在提交说明中使用中文，经过一定的设置msysGit\
还是可以实现的。

为了解决提交说明显示乱码问题，msysGit要为Git设置参数\ ``i18n.logOutputEncoding``\ ，\
将提交说明的输出编码设置为\ ``gbk``\ 。

::

  $ git config --system i18n.logOutputEncoding gbk

Git在提交时并不会对提交说明进行从GBK字符集到UTF-8的转换，但是可以在提交\
说明中标注所使用的字符集，因此在非UTF-8字符集的平台录入中文，需要用下面\
指令设置录入提交说明的字符集，以便在commit对象中嵌入正确的编码说明。为了\
使msysGit提交时输入的中文说明能够在Linux或其他使用UTF-8编码的平台中正确\
显示，还必须对参数\ ``i18n.commitEncoding``\ 设置。

::

  $ git config --system i18n.commitEncoding gbk


同样，为了能够让带有中文文件名的文件，在工作区状态输出、查看历史更改概要、\
以及在补丁文件中，能够正常显示，要为Git配置\ ``core.quotepath``\ 变量，\
将其设置为\ ``false``\ 。但是要注意在msysGit中添加中文文件名的文件，\
只能在msysGit环境中正确显示，而在其他环境（Linu、Mac OS X、Cygwin）中文件\
名会出现乱码。

::

  $ git config --system core.quotepath false
  $ git status -s
  ?? 说明.txt

注意：如果同时安装了Cygwin和msysGit（可能配置了相同的用户主目录），或者\
因为中文支持问题而需要单独为TortoiseGit准备一套msysGit时，为了保证不同的\
msysGit之间，以及和Cygwin之间的配置不会互相影响，而在配置Git环境时使用\
:command:`--system`\ 参数。这是因为不同的msysGit安装以及Cygwin有着不同的\
系统配置文件，但是用户级配置文件位置却可能重合。

使用SSH协议
------------------

msysGit软件包包含的ssh命令和Linux下的没有什么区别，也提供ssh-keygen命令\
管理SSH公钥/私钥对。在使用msysGit的ssh命令时，没有遇到Cygwin中的ssh命令\
（版本号：5.7p1-1）不稳定的问题，即msysGit下的ssh命令可以非常稳定的工作。

如果需要和Windows有更好的整合，希望使用图形化工具管理公钥，也可以使用PuTTY\
提供的\ ``plink.exe``\ 做为SSH客户端。关于如何使用PuTTY可以参见3.3.5节\
Cygwin和PuTTY整合的相关内容。

TortoiseGit的安装和使用
-------------------------

TortoiseGit提供了Git和Windows资源管理器的整合，提供了Git的图形化操作界面。\
像其他Tortoise系列产品（TortoiseCVS、TortoiseSVN）一样，Git工作区的目录\
和文件的图标附加了标识版本控制状态的图像，可以非常直观的看到哪些文件被\
更改了需要提交。通过对右键菜单的扩展，可以非常方便的在资源管理器中操作\
Git版本库。

TortoiseGit是对msysGit命令行的封装，因此需要先安装msysGit。安装TortoiseGit\
非常简单，访问网站\ ``http://code.google.com/p/tortoisegit/``\ ，下载\
安装包，然后根据提示完成安装。

安装过程中会询问要使用的SSH客户端，如图3-23。缺省使用内置的TortoisePLink\
（来自PuTTY项目）做为SSH客户端。

.. figure:: /images/windows/tgit-3.png
   :scale: 80

   图3-23：启动Git Bash

TortoisePLink和TortoiseGit的整合性更好，可以直接通过对话框设置SSH私钥\
（PuTTY格式），而无需再到字符界面去配置SSH私钥和其他配置文件。如果安装\
过程中选择了OpenSSH，可以在安装完毕之后，通过TortoiseGit的设置对话框重新\
选择TortoisePLink做为缺省SSH客户端程序，如图3-24。

.. figure:: /images/windows/tgit-settings-network-plink.png
   :scale: 80

   图3-24：配置缺省SSH客户端

当配置使用TortoisePLink做为缺省SSH客户端时，在执行克隆操作时，在操作界面\
中可以选择一个PuTTY格式的私钥文件进行认证，如图3-25。

.. figure:: /images/windows/tgit-clone.png
   :scale: 80

   图3-25：克隆操作选择PuTTY格式私钥文件

如果连接一个服务器的SSH私钥需要更换，可以通过Git远程服务器配置界面对私钥\
文件进行重新设置。如图3-26。

.. figure:: /images/windows/tgit-settings-remote.png
   :scale: 80

   图3-26：更换连接远程SSH服务器的私钥

如果安装有多个msysGit拷贝，也可以通过TortoiseGit的配置界面进行选择，\
如图3-27。

.. figure:: /images/windows/tgit-settings-general.png
   :scale: 80

   图3-27：配置msysGit的可执行程序位置

TortoiseGit的中文支持
-------------------------

TortoiseGit虽然在底层调用了msysGit，但是TortoiseGit的中文支持和msysGit有\
区别，甚至前面介绍msysGit中文支持时所进行的配制会破坏TortoiseGit。

TortoiseGit在提交时，会将提交说明转换为UTF-8字符集，因此无须对\
:command:`i18n.commitEncoding`\ 变量进行设置。相反，如果设置了\
:command:`i18n.commitEncoding`\ 为\ ``gbk``\ 或其他，则在提交对象\
中会包含错误的编码设置，有可能为提交说明的显示带来麻烦。

TortoiseGit在显示提交说明时，认为所有的提交说明都是UTF-8编码，会转换为\
合适的Windows本地字符集显示，而无须设置\ ``i18n.logOutputEncoding``\
变量。因为当前版本的TortoiseGit没有对提交对象中的encoding设置进行检查，\
因此使用GBK字符集的提交说明中的中文不能正常显示。

因此，如果需要同时使用msysGit的文字界面Git Bash以及TortoiseGit，\
并需要在提交说明中使用中文，可以安装两套msysGit，并确保TortoiseGit关联\
的msysGit没有对\ ``i18n.commitEncoding``\ 进行设置。

TortoiseGit对使用中文命名的文件和目录的支持和msysGit一样，都存在缺陷，\
因此应当避免在msysGit和TortoiseGit中添加用中文命名的文件和目录，如果确实\
需要，可以使用Cygwin。
