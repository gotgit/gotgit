如果不是要和他人协同开发，Git 根本就不需要架设服务器。Git 在本地可以直接使用本地版本库的路径完成 git 版本库间的操作。

但是如果需要和他人分享版本库、协作开发，就需要能够通过特定的网络协议操作 Git 库。

Git 支持的协议很丰富，架设服务器的选择也很多，不同的方案有着各自的优缺点。

  +----------------------------+---------------------+-------------------+----------------------+---------------------+
  |                            | HTTP                | Git-daemon        | SSH                  | Gitosis, Gitolite   |
  +============================+=====================+===================+======================+=====================+
  | 服务架设难易度             | 简单                | 中等              | 简单                 | 复杂                |
  +----------------------------+---------------------+-------------------+----------------------+---------------------+
  | 匿名读取                   | 支持                | 支持              | 否*                  | 否*                 |
  +----------------------------+---------------------+-------------------+----------------------+---------------------+
  | 身份认证                   | 支持                | 否                | 支持                 | 支持                |
  +----------------------------+---------------------+-------------------+----------------------+---------------------+
  | 版本库写操作               | 支持                | 否                | 支持                 | 支持                |
  +----------------------------+---------------------+-------------------+----------------------+---------------------+
  | 企业级授权支持             | 否                  | 否                | 否                   | 支持                |
  +----------------------------+---------------------+-------------------+----------------------+---------------------+
  | 是否支持远程建库           | 否                  | 否                | 否                   | 支持                |
  +----------------------------+---------------------+-------------------+----------------------+---------------------+

注：

* SSH 协议和基于 SSH 的 Gitolite 等可以通过空口令帐号实现匿名访问。

使用 HTTP 协议
********************

HTTP 协议是版本控制系统实现非常重要的协议，具有安全（HTTPS），方便（跨越防火墙）等优点。Git 在 1.6.6 版本之前对 HTTP 协议支持有限，是哑协议，访问效率低，但是在 1.6.6 之后，通过一个 CGI 实现了智能的 HTTP 协议支持。

哑传输协议
===========

在 Git 1.6.6 之前，通过 HTTP 协议提供 Git 服务，基本上把 Git 版本库作为 Web 服务器的一个目录开放出来就好了。

例如如下的 Apache 配置:

::

  Alias /git /path/to/repos

  <Directory /opt/dvcs/gitroot>
      Options FollowSymLinks
      AllowOverride None
      Order allow,deny
      allow from all
  </Directory>

当用户执行 `git clone http://server/git/myrepo.git` ，实际访问的是服务器端 `/path/to/repos/myrepo.git` 路径中的版本库。

要求版本库目录下必须存在文件 `info/refs` ，并且该文件涵盖了版本库所有的分支，且分支指向正确的 SHA 摘要。

* 这是因为 git 命令（相当于web客户端），无法通过其他方法获得 Git 库的版本库的分支列表和指向。

  版本库分支记录在 `refs/` 下的单独的文件中，如果 Web 服务器不允许目录浏览，是看不到这些文件的。

* 必须执行 `git update-server-info` 命令，才能创建和更新 `info/refs` 这个专为 HTTP 哑协议准备的文件。

  可以通过版本库的 `post-update` 脚本，自动执行更新 `info/refs` 文件的命令。Git 版本库缺省的 `post-update.sample` 示例脚本内容：

  ::

    #!/bin/sh
    #
    # An example hook script to prepare a packed repository for use over
    # dumb transports.
    #
    # To enable this hook, rename this file to "post-update".
    
    exec git update-server-info


如果需要提供可写的 Git 库服务，即允许远程客户端 Push，就需要在 Apache 中为版本库一一设置 WebDAV。例如 Apache 中的如下配置：

::

  Alias /git /opt/dvcs/gitroot

  <Directory /opt/dvcs/gitroot>
      Options FollowSymLinks
      AllowOverride None
      Order allow,deny
      allow from all
  </Directory>

  <Location /git/myrepos.git>
      DAV on
      AuthType Basic
      AuthName "Git"
      AuthBasicProvider ldap
      AuthUserFile /opt/dvcs/conf/passwd

      AuthGroupFile /opt/dvcs/conf/group
      Require group git

      Satisfy All
  </Location>


这种哑传输协议实现 Git 服务的缺点非常明显：

* 数据传输效率低。

  当版本库经过整理，各个散在的提交文件被打包后，获取某个单独的文件也需要对整个打包文件进行传输！

* 传输过程无进度显示。

  哑协议。在 Git 操作过程不能像其他协议那样显示进度，在操作大的版本库，非常不便。

* 为提供版本库写操作，需要对每个版本库进行单独配置。

  缺乏类似 Subversion 的 WebDAV 插件，使得需要为每个 Git 库一一设置。

* 不能为尚不存在的版本库进行预先配置，只能在服务器端手工创建版本库，而不能通过远程push 由客户端发起创建

* Git 客户端不像 Subversion 提供口令缓存机制，如果要避免每次操作频繁输入口令，需要在 URL 中记录明文口令

  ::

    git clone https://username:password@server/path/to/repos/myrepo.git


智能 HTTP 协议
===============

Git 1.6.6 之后的版本，提供了针对 HTTP 协议的 CGI 程序 `git-http-backend` ，实现了智能的 HTTP 协议支持。同时也要求 Git 客户端的版本也不低于 1.6.6。

不同的 Linux 平台该文件的位置可能不尽相同，用各个平台对应的包管理命令（dpkg, rpm）查询该 CGI 程序的位置。在 Debian/Ubuntu 平台可以通过如下命令查询：

:: 

  $ dpkg -L git | grep git-http-backend
  /usr/lib/git-core/git-http-backend

在 Apache2 中为 Git 配置智能 HTTP 协议如下。

:: 

  SetEnv GIT_PROJECT_ROOT /var/www/git
  SetEnv GIT_HTTP_EXPORT_ALL
  ScriptAlias /git/ /usr/lib/git-core/git-http-backend/

说明：

* 第一行设置版本库的根目录为 /var/www/git

* 第二行设置所有版本库均可访问，无论是否在版本库中存在 `git-daemon-export-ok` 文件。

  缺省只有在版本库目录中存在文件 `git-daemon-export-ok` ，该版本库才可以访问。这个文件是 Gitdaemon 服务的一个特性。

* 第三行，就是使用 `git-http-backend` CGI 脚本来相应客户端的请求。

  当用地址 `http://server/git/path/to/repos/myrepo.git` 访问时，即由此 CGI 提供服务。

**写操作授权**

上面的配置只能提供版本库的读取服务，必须添加认证。当用户通过认证后，才能对版本库进行写操作。

下面的 Apache 配置，在前面配置的基础上，为 Git 写操作提供授权：

::

  <LocationMatch "^/git/.*/git-receive-pack$">
    AuthType Basic
    AuthName "Git Access"
    AuthType Basic
    AuthBasicProvider file
    AuthUserFile /path/to/passwd/file
    ...
  </LocationMatch>


**读和写均需授权**

如果需要对读操作也进行授权，那就更简单了，一个 Location 语句就够了。

::

  <Location /git/private>
    AuthType Basic
    AuthName "Git Access"
    AuthType Basic
    AuthBasicProvider file
    AuthUserFile /path/to/passwd/file
    ...
  </Location>

**对静态文件的直接访问**

如果对静态文件的访问不经过 CGI 程序，直接由 Apache 提供服务，会提高访问性能。

下面的设置对 Git 版本库中的 objects 目录下文件的访问，不经过 CGI。

::

  SetEnv GIT_PROJECT_ROOT /var/www/git

  AliasMatch ^/git/(.*/objects/[0-9a-f]{2}/[0-9a-f]{38})$          /var/www/git/$1
  AliasMatch ^/git/(.*/objects/pack/pack-[0-9a-f]{40}.(pack|idx))$ /var/www/git/$1
  ScriptAlias /git/ /usr/libexec/git-core/git-http-backend/


Git 的智能的HTTP服务彻底打破了以前哑传输对 HTTP 协议造成的恶劣印象，让 HTTP 协议成为 Git 服务的一个重要选项。但是在授权的管理上，相比后面要介绍的 Gitosis 和 Gitolite，智能 HTTP 服务仅仅依赖 Apache 自身的授权模型，可管理性要弱的多。

* 创建版本库只能在服务器端进行，不能通过远程客户端进行。
* 配置认证和授权，也只能在服务器端进行，不能进行远程配置。
* 版本库的写操作授权只能进行非零即壹的授权，不能针对分支甚至路径进行授权。

需要企业级的版本库管理，还需要考虑后面介绍的基于 SSH 协议的 Gitosis 或者 Gitolite。
