使用 HTTP 协议
********************

HTTP 协议是版本控制非常重要的一种协议，具有安全（HTTPS），方便（跨越防火墙）等优点。Git 在 1.6.6 版本之前对 HTTP 协议支持有限，是哑协议，访问效率低，但是在 1.6.6 之后，通过一个 CGI 实现了智能的 HTTP 协议支持。

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

要求版本库目录下必须存在文件 `.git/info/refs` ，该文件中包含了版本库中所有的引用列表，且引用都指向正确的 SHA1哈希值。而且还要存在文件 `.git/objects/info/packs` ，以便对象库打包后，能够通过该文件定位到打包文件。

* 这是因为 git 命令（相当于web客户端），无法通过其他方法获得 Git 库的版本库的分支列表和指向。版本库分支记录在 `.git/refs/` 下的单独的文件中，如果 Web 服务器不允许目录浏览，是看不到这些文件的。

* 通过执行 `git update-server-info` 命令，能够创建和更新 `.git/info/refs` 和 `.git/objects/info/packs` 这几个专为 HTTP 哑协议准备的文件。可以通过版本库的 `post-update` 脚本，自动执行更新相关索引文件的命令。Git 版本库缺省的 `post-update.sample` 示例脚本内容：

  ::

    #!/bin/sh
    #
    # An example hook script to prepare a packed repository for use over
    # dumb transports.
    #
    # To enable this hook, rename this file to "post-update".
    
    exec git update-server-info


如果需要提供可写的 Git 库服务，即允许远程客户端 Push，还需要在 Apache 中为版本库一一设置 WebDAV。例如 Apache 中的如下配置：

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

  哑协议，在 Git 操作过程不能像其他协议那样显示进度，在操作大的版本库，非常不便。

* 为提供版本库写操作，需要对每个版本库进行单独配置。

  缺乏类似 Subversion 的 WebDAV 插件，使得需要为每个 Git 库一一设置。

* 不能为尚不存在的版本库进行预先配置，只能在服务器端手工创建版本库，而不能通过远程push 由客户端发起创建。

* Git 客户端不像 Subversion 提供口令缓存机制，如果要避免每次操作频繁输入口令，需要在 URL 中记录明文口令。

  ::

    git clone https://username:password@server/path/to/repos/myrepo.git


智能 HTTP 协议
===============

Git 1.6.6 之后的版本，提供了针对 HTTP 协议的 CGI 程序 `git-http-backend` ，实现了智能的 HTTP 协议支持。同时也要求 Git 客户端的版本也不低于 1.6.6。

查看文件 `git-http-backend` 的安装位置，可以用如下命令。

:: 

  $ ls $(git --exec-path)/git-http-backend
  /usr/lib/git-core/git-http-backend

在 Apache2 中为 Git 配置智能 HTTP 协议如下。

:: 

  SetEnv GIT_PROJECT_ROOT /var/www/git
  SetEnv GIT_HTTP_EXPORT_ALL
  ScriptAlias /git/ /usr/lib/git-core/git-http-backend/

说明：

* 第一行设置版本库的根目录为 /var/www/git

* 第二行设置所有版本库均可访问，无论是否在版本库中存在 `git-daemon-export-ok` 文件。

  缺省只有在版本库目录中存在文件 `git-daemon-export-ok` ，该版本库才可以访问。这个文件是 git-daemon 服务的一个特性。

* 第三行，就是使用 `git-http-backend` CGI 脚本来相应客户端的请求。

  当用地址 `http://server/git/path/to/repos/myrepo.git` 访问时，即由此 CGI 提供服务。

**写操作授权**

上面的配置只能提供版本库的读取服务，若想提供基于HTTP协议的写操作，必须添加认证的配置指令。当用户通过认证后，才能对版本库进行写操作。

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


Git 的智能HTTP服务彻底打破了以前哑传输协议给 HTTP 协议带来的恶劣印象，让 HTTP 协议成为 Git 服务的一个重要选项。但是在授权的管理上，智能 HTTP 服务仅仅依赖 Apache 自身的授权模型，相比后面要介绍的 Gitosis 和 Gitolite，可管理性要弱的多。

* 创建版本库只能在服务器端进行，不能通过远程客户端进行。
* 配置认证和授权，也只能在服务器端进行，不能在客户端远程配置。
* 版本库的写操作授权只能进行非零即壹的授权，不能针对分支甚至路径进行授权。

需要企业级的版本库管理，还需要考虑后面介绍的基于 SSH 协议的 Gitolite 或 Gitosis。


Gitweb 服务器
=============

前面介绍的 HTTP 哑协议和智能 HTTP 协议服务架设，都可以用于提供 Git 版本库的读写服务，而本节介绍的 Gitweb 作为一个 Web 应用，只提供版本库的图形化浏览功能，而不能提供版本库本身的读写。

Gitweb 是用 Perl 语言开发的 CGI 脚本，架设比较方便。Gitweb 支持多个版本库，可以对版本库进行目录浏览（包括历史版本），可以查看文件内容，查看提交历史，提供搜索以及 RSS feed 支持。也可以提供目录文件的打包下载等。图27-1就是kernel.org上的Gitweb示例。

.. figure:: /images/git-server/gitweb-kernel-org_full.png
   :scale: 80

   图27-1：Gitweb 界面(kernel.org)

Gitweb 安装
-----------
各个 Linux 平台都会提供 gitweb 软件包。如在 Debian/Ubuntu 上安装 Gitweb：

::

  $ sudo aptitude install gitweb

安装文件列表：

* 配置文件： `/etc/gitweb.conf`

* Apache 配置文件： `/etc/apache2/conf.d/gitweb`

  通过地址 `/gitweb` 提供 gitweb 服务器。

* CGI 脚本： `/usr/share/gitweb/index.cgi`

* 其他附属文件： `/usr/share/gitweb/*`

  图片和 css 等。

Gitweb 配置
------------

编辑 `/etc/gitweb.conf` ，更改 gitweb 的缺省设置。

* 版本库的根目录

  ::

    $projectroot = "/var/cache/git";

* 设置版本库访问 URL。

  Gitweb 可以为每个版本库显示访问的 URL 地址。可以在列表中填入多个地址。

  ::

    @git_base_url_list = ("git://bj.ossxp.com/git", "http://bj.ossxp.com/git");


    增加 actions 菜单
        $feature{'actions'}{'default'} = [('git', 'git://bj.ossxp.com/git/%n', 'tree')];

* 在首页上显示自定义信息

  设定自定义HTML的文件名。

  ::

    $home_text = "indextext.html";

  在 CGI 脚本所在的目录下，创建 `indextext.html` 文件。下面是我们公司（北京群英汇信息技术有限公司）内部 gitweb 自定义首页的内容。

  ::

    <html>
    <head>
    </head>
    <body>
    <h2>群英汇 - git 代码库</h2>
    <ul>
      <li>点击版本库，进入相应的版本库页面，有 URL 指向一个 git://... 的检出链接</li>
      <li>使用命令 git clone git://... 来克隆一个版本库</li>
      <li>对于名称中含有 <i>-gitsvn</i> 字样的代码库, 是用 git-svn 从 svn 代码库镜像而来的。对于它们的镜像，需要做进一步的工作。
        <ul>
          <li>要将 git 库的远程分支(.git/ref/remotes/*) 也同步到本地！
            <pre>
            $ git config --add remote.origin.fetch '+refs/remotes/*:refs/remotes/*'
            $ git fetch
            </pre>
          </li>
          <li>如果需要克隆库和 Subversion 同步。用 git-svn 初始化代码库，并使得相关配置和源保持一致 </li>
        </ul>
      </li>
    </ul>
    </body>
    </html>

* 版本库列表。

  缺省扫描版本库根目录，查找版本库。如果版本库非常多，这个查找过程可能很耗时，可以提供一个文本文件包含版本库的列表，会加速 Gitweb 显示初始化。

  ::

    # $projects_list = $projectroot;
    $projects_list = "/home/git/gitosis/projects.list";

  后面介绍的 Gitosis 和 Gitolite 都可以自动生成这么一个版本库列表，供 gitweb 使用。

* Gitweb 菜单定制。

  - 在 tree view 文件的旁边显示追溯（blame）链接。

    ::

      $feature{'blame'}{'default'} = [1];
      $feature{'blame'}{'override'} = 1;

  - 可以通过版本库的配置文件 `config` 对版本库进行单独设置。

    下面的设置覆盖 gitweb 的全局设置，不对该项目显示 blame 菜单。

    ::

        [gitweb]
        blame = 0
    
  - 为每个tree 添加快照（snapshot）下载链接。

    ::

      $feature{'pickaxe'}{'default'} = [1];
      $feature{'pickaxe'}{'override'} = 1;
      $feature{'snapshot'}{'default'} = ['zip', 'tgz'];
      $feature{'snapshot'}{'override'} = 1;


版本库的 gitweb 相关设置
-------------------------

可以通过 Git 版本库下的配置文件，定制版本库在 gitweb 下的显示。

* 文件 `description` 。

  提供一行简短的 git 库描述。显示在版本库列表中。

  也可以通过 `config` 配置文件中的 `gitweb.description` 进行设置。但是文件优先。

* 文件 `README.html` 。

  提供更详细的项目描述，显示在 gitweb 项目页面中。

* 文件 `cloneurl` 。

  版本库访问的 URL 地址，一个一行。

* 文件 `config` 。

  通过 `[gitweb]` 小节的配置，覆盖 gitweb 全局设置。

  - `gitweb.owner` 用于显示版本库的创建者。

  - `gitweb.description` 显示项目的简短描述，也可以通过 `description` 文件来提供。（文件优先）

  - `gitweb.url` 显示项目的URL 列表，也可以通过 `cloneurl` 文件来提供。（文件优先）

