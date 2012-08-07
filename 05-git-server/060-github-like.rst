Git版本库托管
***************

想不想在互联网上为自己的Git版本库建立一个克隆？这样再也不必为数据的安全\
担忧（异地备份），还可以和他人数据共享、协同工作？但是这样做会不会很贵呢？\
比如要购买域名、虚拟主机、搭建Git服务器什么的？

实际上这种服务（Git版本库托管服务）可以免费获得！GitHub、Gitorious、Bitbucket\
等都可以免费提供这些服务。

Github
=======

如果读者是按部就班式的阅读本书，那么可能早就注意到本书的很多示例版本库都\
是放在GitHub上的。GitHub提供了Git版本库托管服务，即包括收费商业支持，也\
提供免费的服务，很多开源项目把版本库直接放在了GitHub上，如：jQuery、curl、\
Ruby on Rails等。

注册一个GitHub帐号非常简单，访问GitHub网站：\ ``https://github.com/``\ ，\
点击菜单中的“Pricing and Signup”就可以看到GitHub的服务列表（如图33-1）。\
会看到其中有一个免费的服务：“Free for open source” ，并且版本库托管的\
数量不受限制。当然免费的午餐是不管饱的，托管的空间只有300MB，而且不能\
创建私有版本库。

.. figure:: /images/git-server/github-plans.png
   :scale: 70

   图33-1：GitHub服务价目表

点击按钮“Create a free account”，就可以创建一个免费的帐号。GitHub的用法\
和前面介绍的Gerrit Web界面的用法很类似，一旦帐号创建，应该马上为新建立的\
帐号设置公钥，以便能够用SSH协议读写自己帐号下创建的版本库，如图33-2。

.. figure:: /images/git-server/github-whoru.png
   :scale: 70

   图33-2：GitHub上配置公钥


创建仓库的操作非常简单，首先点击菜单上的“主页”（Dashboard），再点击右侧\
边栏上的“新建仓库”按钮就可以创建新的版本库了，如图33-3。

.. figure:: /images/git-server/github-create-repo.png
   :scale: 70

   图33-3：GitHub页面上的新建版本库按钮

新建版本库会浪费本来就不多的托管空间，从GitHub上已有版本库派生（fork）\
一个克隆是一个好办法。首先通过GitHub搜索版本库名称，找到后点击“派生”按钮，\
就可以在自己的托管空间内建立相应版本库的克隆，如图33-4。

.. figure:: /images/git-server/github-fork-repo.png
   :scale: 70

   图33-4：自GitHub上的版本库派生

版本库建立后就可以用Git命令访问GitHub上托管的版本库了。GitHub提供三种\
协议可供访问，如图33-5。其中SSH协议和HTTP协议支持读写，Git-daemon提供\
只读访问。对于自己的版本库当然选择支持读写的服务方式了，其中SSH协议是首选。


.. figure:: /images/git-server/github-repo-url.png
   :scale: 70

   图33-5：版本库访问URL

Gitorious
==========

Gitorious是另外一个Git版本库托管提供商，网址为\ ``http://gitorious.org/``\ 。\
最酷的是Gitorious本身的架站软件也是开源的，可以通过Gitorious上的Gitorious\
项目访问。如果读者熟悉Ruby on Rails，可以架设一个本地的Gitorious服务。

.. figure:: /images/git-server/gitorious_full.png
   :scale: 70

   图33-6：Gitorious上的Gitorious项目
