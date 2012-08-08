etckeeper
*********

Linux/Unix的用户对\ :file:`/etc`\ 目录都是再熟悉不过了，在这个最重要的目\
录中保存了大部分软件的配置信息，借以实现软件的配置以及整个系统的启动过程\
控制。对于Windows用户来说，可以把\ :file:`/etc`\ 目录视为Windows中的注册\
表，只不过文件化了，可管理了。

这么重要的\ :file:`/etc`\ 目录，如果其中的文件被错误编辑或者删除，将会损\
失惨重。\ ``etckeeper``\ 这个软件可以帮助实现\ :file:`/etc`\ 目录的持续\
备份，借用分布式版本控制工具，如：git、mercurial、bazaar、darcs。

那么etckeeper是如何实现的呢？以git作为etckeeper的后端为例进行说明，其他\
的分布式版本控制系统大同小异。

* 将\ :file:`/etc`\ 目录Git化。将会创建Git库于目录\ :file:`/etc/.git`\
  中，\ :file:`/etc`\ 目录作为工作区。

* 与系统的包管理器，如Debian/Ubuntu的apt，Redhat上的yum等整合。一旦有软\
  件包安装或删除，对\ :file:`/etc`\ 目录下的改动执行提交操作。

* 除了能够记录\ :file:`/etc`\ 目录中的文件内容，还可以记录文件属性等元信\
  息。因为\ :file:`/etc`\ 目录下的文件的权限设置往往是非常重要和致命的。

* 因为\ :file:`/etc`\ 目录已经是一个版本库了，可以用git命令对\
  :file:`/etc`\ 下的文件进行操作：查看历史，回退到历史版本...

* 也可以将\ :file:`/etc`\ 克隆到另外的主机中，实现双机备份。

安装etckeeper
===============

安装etckeeper是一个最简单的活，因为etckeeper在主流的Linux发行版都有对应\
的安装包。使用相应Linux平台的包管理器（apt、yum）即可安装。

在Debian/Ubuntu上安装etckeeper如下：

::

  $ sudo aptitude install etckeeper

安装etckeeper软件包，会自动安装上一个分布式版本控制系统工具，除非已经安\
装了。这是因为etckeeper需要使用一个分布式版本控制系统作为存储管理后端。\
在Debian/Ubuntu上会依据下面的优先级进行安装：git > mercurial > bzr > darcs。

在Debian/Ubuntu上，使用\ :command:`dpkg -s`\ 命令查看etckeeper的软件包依\
赖，就会看到这个优先级。

::

  $ dpkg -s etckeeper | grep "^Depends"
  Depends: git-core (>= 1:1.5.4) | git (>= 1:1.7) | mercurial | bzr (>= 1.4~) | darcs, debconf (>= 0.5) | debconf-2.0

配置etckeeper
===============

配置etckeeper首先要选择好某一分布式版本库控制工具，如Git，然后用相应的版\
本控制工具初始化\ :file:`/etc`\ 目录，并做一次提交。

* 编辑配置文件\ :file:`/etc/etckeeper/etckeeper.conf`\ 。

  只要有下面一条配置就够了。告诉etckeeper使用git作为数据管理后端。

  ::
  
    VCS="git"

* 初始化\ :file:`/etc`\ 目录。即将其Git化。执行下面的命令（需要以root用\
  户身份），会将\ :file:`/etc`\ 目录Git化。

  整个过程可能会比较慢，因为要对\ :file:`/etc`\ 下的文件执行\
  :command:`git add`\ ，因为文件太多，会慢一些。

  ::

    $ sudo etckeeper init

* 执行第一次提交。注意使用etckeeper命令而非git命令进行提交。

  ::

    $ sudo etckeeper commit "this is the first etckeeper commit..."


  整个过程可能会比较慢，主要是因为etckeeper要扫描\ :file:`/etc`\ 下不属\
  于root用户的文件以及特殊权限的文件并进行记录。这是为了弥补Git本身不能\
  记录文件属主、权限信息等。

使用etckeeper
===============

实际上由于etckeeper已经和系统的包管理工具进行了整合（如Debian/Ubuntu的\
apt，Redhat上的yum等），etckeeper可以免维护运行。即一旦有软件包安装或\
删除，对\ :file:`/etc`\ 目录下的改动会自动执行提交操作。

当然也可以随时以\ ``root``\ 用户身份调用\ :command:`etckeeper commit`\
命令对\ :file:`/etc`\ 目录的改动手动进行提交。

剩下的工作就交给Git了。可以在\ :file:`/etc`\ 目录执行\ :command:`git log`\ 、\
:command:`git show`\ 等操作。但要注意以root用户身份运行，因为\
:file:`/etc/.git`\ 目录的权限不允许普通用户操作。
