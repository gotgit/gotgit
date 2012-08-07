使用HTTP协议
********************

HTTP协议是版本控制非常重要的一种协议，具有安全（HTTPS），方便（跨越防火\
墙）等优点。Git在 1.6.6版本之前对HTTP协议支持有限，是哑协议，访问效率低，\
但是在1.6.6之后，通过一个CGI实现了智能的HTTP协议支持。

哑传输协议
===========

在Git 1.6.6之前，通过HTTP协议提供Git服务，基本上把Git版本库作为Web服务器\
的一个目录开放出来就好了。

例如如下的Apache配置:

::

  Alias /git /path/to/repos

  <Directory /opt/dvcs/gitroot>
      Options FollowSymLinks
      AllowOverride None
      Order allow,deny
      allow from all
  </Directory>

当用户执行\ :command:`git clone http://server/git/myrepo.git`\ ，实际访\
问的是服务器端\ :file:`/path/to/repos/myrepo.git`\ 路径中的版本库。

要求版本库目录下必须存在文件\ :file:`.git/info/refs`\ ，该文件中包含了\
版本库中所有的引用列表，且引用都指向正确的SHA1哈希值。而且还要存在文件\
:file:`.git/objects/info/packs`\ ，以便对象库打包后，能够通过该文件定位\
到打包文件。

* 这是因为Git命令（相当于web客户端），无法通过其他方法获得Git库的版本库\
  的分支列表和指向。版本库分支记录在\ :file:`.git/refs/`\ 下的单独的文件\
  中，如果Web服务器不允许目录浏览，是看不到这些文件的。

* 通过执行\ :command:`git update-server-info`\ 命令，能够创建和更新\
  :file:`.git/info/refs`\ 和\ :file:`.git/objects/info/packs`\ 这几个专为\
  HTTP哑协议准备的文件。可以通过版本库的\ :file:`post-update`\ 脚本，自动\
  执行更新相关索引文件的命令。Git版本库缺省的\ :file:`post-update.sample`\
  示例脚本内容：

  ::

    #!/bin/sh
    #
    # An example hook script to prepare a packed repository for use over
    # dumb transports.
    #
    # To enable this hook, rename this file to "post-update".
    
    exec git update-server-info


如果需要提供可写的Git库服务，即允许远程客户端推送，还需要在Apache中为版\
本库一一设置WebDAV。例如Apache中的如下配置：

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


这种哑传输协议实现Git服务的缺点非常明显：

* 数据传输效率低。

  当版本库经过整理，各个散在的提交文件被打包后，获取某个单独的文件也需要\
  对整个打包文件进行传输！

* 传输过程无进度显示。

  哑协议，在Git操作过程不能像其他协议那样显示进度，在操作大的版本库，\
  非常不便。

* 为提供版本库写操作，需要对每个版本库进行单独配置。

  缺乏类似Subversion的WebDAV插件，使得需要为每个Git库一一设置。

* 不能为尚不存在的版本库进行预先配置，只能在服务器端手工创建版本库，而不\
  能通过远程push由客户端发起创建。

* Git客户端不像Subversion提供口令缓存机制，如果要避免每次操作频繁输入口令，\
  需要在URL中记录明文口令。

  ::

    git clone https://username:password@server/path/to/repos/myrepo.git


智能HTTP协议
===============

Git 1.6.6之后的版本，提供了针对HTTP协议的CGI程序\ :file:`git-http-backend`\ ，\
实现了智能的HTTP协议支持。同时也要求Git客户端的版本也不低于1.6.6。

查看文件\ :file:`git-http-backend`\ 的安装位置，可以用如下命令。

:: 

  $ ls $(git --exec-path)/git-http-backend
  /usr/lib/git-core/git-http-backend

在Apache2中为Git配置智能HTTP协议如下。

::

  SetEnv GIT_PROJECT_ROOT /var/www/git
  SetEnv GIT_HTTP_EXPORT_ALL
  ScriptAlias /git/ /usr/lib/git-core/git-http-backend/

说明：

* 第一行设置版本库的根目录为\ :file:`/var/www/git`\ 。

* 第二行设置所有版本库均可访问，无论是否在版本库中存在\
  :file:`git-daemon-export-ok`\ 文件。

  缺省只有在版本库目录中存在文件\ :file:`git-daemon-export-ok`\ ，\
  该版本库才可以访问。这个文件是git-daemon服务的一个特性。

* 第三行，就是使用\ :file:`git-http-backend`\ CGI脚本来相应客户端的请求。

  当用地址\ ``http://server/git/path/to/repos/myrepo.git``\ 访问时，即\
  由此CGI提供服务。

**写操作授权**

上面的配置只能提供版本库的读取服务，若想提供基于HTTP协议的写操作，必须添\
加认证的配置指令。当用户通过认证后，才能对版本库进行写操作。

下面的Apache配置，在前面配置的基础上，为Git写操作提供授权：

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

如果需要对读操作也进行授权，那就更简单了，一个\ ``Location``\ 语句就够了。

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

如果对静态文件的访问不经过CGI程序，直接由Apache提供服务，会提高访问性能。

下面的设置对Git版本库中的\ :file:`objects`\ 目录下文件的访问，不经过CGI。

::

  SetEnv GIT_PROJECT_ROOT /var/www/git

  AliasMatch ^/git/(.*/objects/[0-9a-f]{2}/[0-9a-f]{38})$          /var/www/git/$1
  AliasMatch ^/git/(.*/objects/pack/pack-[0-9a-f]{40}.(pack|idx))$ /var/www/git/$1
  ScriptAlias /git/ /usr/libexec/git-core/git-http-backend/


Git的智能HTTP服务彻底打破了以前哑传输协议给HTTP协议带来的恶劣印象，让HTTP\
协议成为Git服务的一个重要选项。但是在授权的管理上，智能HTTP服务仅仅依赖\
Apache自身的授权模型，相比后面要介绍的Gitosis和Gitolite，可管理性要弱的多。

* 创建版本库只能在服务器端进行，不能通过远程客户端进行。
* 配置认证和授权，也只能在服务器端进行，不能在客户端远程配置。
* 版本库的写操作授权只能进行非零即壹的授权，不能针对分支甚至路径进行授权。

需要企业级的版本库管理，还需要考虑后面介绍的基于SSH协议的Gitolite或Gitosis。


Gitweb服务器
=============

前面介绍的HTTP哑协议和智能HTTP协议服务架设，都可以用于提供Git版本库的读\
写服务，而本节介绍的Gitweb作为一个Web应用，只提供版本库的图形化浏览功能，\
而不能提供版本库本身的读写。

Gitweb是用Perl语言开发的CGI脚本，架设比较方便。Gitweb支持多个版本库，可\
以对版本库进行目录浏览（包括历史版本），可以查看文件内容，查看提交历史，\
提供搜索以及RSS feed支持。也可以提供目录文件的打包下载等。图27-1就是\
kernel.org上的Gitweb示例。

.. figure:: /images/git-server/gitweb-kernel-org_full.png
   :scale: 80

   图27-1：Gitweb界面(kernel.org)

Gitweb安装
-----------
各个Linux平台都会提供Gitweb软件包。如在Debian/Ubuntu上安装Gitweb：

::

  $ sudo aptitude install gitweb

安装文件列表：

* 配置文件：\ :file:`/etc/gitweb.conf`\ 。

* Apache配置文件：\ :file:`/etc/apache2/conf.d/gitweb`\ 。默认设置用URL\
  地址\ ``/gitweb``\ 来访问Gitweb服务。

* CGI脚本：\ :file:`/usr/share/gitweb/index.cgi`\ 。

* 其他附属文件：\ :file:`/usr/share/gitweb/*`\ ，如：图片和css等。

Gitweb配置
------------

编辑\ :file:`/etc/gitweb.conf`\ ，更改Gitweb的默认设置。

* 版本库根目录的设置。

  ::

    $projectroot = "/var/cache/git";

* 访问版本库多种协议的地址设置。

  Gitweb可以为每个版本库显示访问的协议地址。可以在列表中填入多个地址。

  ::

    @git_base_url_list = ("git://bj.ossxp.com/git", "ssh://git\@bj.ossxp.com", "http://bj.ossxp.com/git");


* 增加 actions 菜单

  ::

    $feature{'actions'}{'default'} = [('git', 'git://bj.ossxp.com/git/%n', 'tree')];

* 在首页上显示自定义信息

  设定自定义HTML的文件名。

  ::

    $home_text = "indextext.html";

  在CGI脚本所在的目录下，创建\ :file:`indextext.html`\ 文件。下面是我们\
  公司（北京群英汇信息技术有限公司）内部gitweb自定义首页的内容。

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

  缺省扫描版本库根目录，查找版本库。如果版本库非常多，这个查找过程可能很\
  耗时，可以提供一个文本文件包含版本库的列表，会加速Gitweb显示初始化。

  ::

    # $projects_list = $projectroot;
    $projects_list = "/home/git/gitosis/projects.list";

  后面介绍的Gitosis和Gitolite都可以自动生成这么一个版本库列表，供Gitweb使用。

* Gitweb菜单定制。

  - 在tree view文件的旁边显示追溯（blame）链接。

    ::

      $feature{'blame'}{'default'} = [1];
      $feature{'blame'}{'override'} = 1;

  - 可以通过版本库的配置文件\ :file:`config`\ 对版本库进行单独设置。

    下面的设置覆盖Gitweb的全局设置，不对该项目显示blame菜单。

    ::

        [gitweb]
        blame = 0
    
  - 为每个tree添加快照（snapshot）下载链接。

    ::

      $feature{'pickaxe'}{'default'} = [1];
      $feature{'pickaxe'}{'override'} = 1;
      $feature{'snapshot'}{'default'} = ['zip', 'tgz'];
      $feature{'snapshot'}{'override'} = 1;


版本库的Gitweb相关设置
-------------------------

可以通过Git版本库下的配置文件，定制版本库在Gitweb下的显示。

* 文件\ :file:`description`\ 。

  提供一行简短的git库描述。显示在版本库列表中。

  也可以通过\ :file:`config`\ 配置文件中的\ ``gitweb.description``\
  进行设置。但是文件优先。

* 文件\ :file:`README.html`\ 。

  提供更详细的项目描述，显示在Gitweb项目页面中。

* 文件\ :file:`cloneurl`\ 。

  版本库访问的URL地址，一个一行。

* 文件\ :file:`config`\ 。

  通过\ ``[gitweb]``\ 小节的配置，覆盖Gitweb全局设置。

  - ``gitweb.owner``\ 用于显示版本库的创建者。

  - ``gitweb.description``\ 显示项目的简短描述，也可以通过\
    :file:`description`\ 文件来提供。（文件优先）

  - ``gitweb.url``\ 显示项目的URL列表，也可以通过\ ``cloneurl``\
    文件来提供。（文件优先）
