如果不是要和他人协同开发，Git 根本就不需要架设服务器。Git 在本地可以直接使用本地版本库的路径完成 git 版本库间的操作。

但是如果需要和他人分享版本库、协作开发，就需要能够通过特定的网络协议操作 Git 库。

Git 支持的协议很丰富，但不同的协议实现有着各自的优缺点。

HTTP 协议
=========

Http 协议实现 Git 服务非常简单，如果提供只读服务，即不用于提供 push 服务，直接把 git 库放在 Web 服务器某个目录下就可以了。例如如下的 Apache 配置:

::

  Alias /gitroot /opt/dvcs/gitroot

  <Directory /opt/dvcs/gitroot>
      Options FollowSymLinks
      AllowOverride None
      Order allow,deny
      allow from all
  </Directory>


需要注意的是，需要对 Git 库执行下面的命令，以便 .git/info/refs 文件可以反映当前 Git 库分支的最新指向。

::

  $ git update-server-info


如果需要提供可写的 Git 库服务，即允许远程客户端 Push，就需要在 Apache 中为版本库一一设置 WebDAV。例如 Apache 中的如下配置：

::

  Alias /gitroot /opt/dvcs/gitroot

  <Directory /opt/dvcs/gitroot>
      Options FollowSymLinks
      AllowOverride None
      Order allow,deny
      allow from all
  </Directory>

  <Location /gitroot/myrepos.git>
      DAV on
      AuthType Basic
      AuthName "Git"
      AuthBasicProvider ldap
      AuthUserFile /opt/dvcs/conf/passwd

      AuthGroupFile /opt/dvcs/conf/group
      Require group git

      Satisfy All
  </Location>


HTTP 协议实现 Git 服务的缺点也是明显的：

* 哑协议：在 Git 操作过程不能像其他协议那样显示进度，在操作大的版本库，非常不便
* 缺乏类似 Subversion 的 WebDAV 插件，使得需要为每个 Git 库一一设置
* 不能为尚不存在的版本库进行预先配置，只能在服务器端手工创建版本库，而不能通过远程push 由客户端发起创建
* Git 客户端不像 Subversion 提供口令缓存机制，如果要避免每次操作频繁输入口令，需要在 URL 中记录明文口令

  ::

    git clone https://username:password@server/path/to/repo.git

基于上面的原因，HTTP 协议一般只用于提供只读的 Git 服务。而作为只读 Git
服务的提供者，下面介绍的 git-daemon 可能更适合。


