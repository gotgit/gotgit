使用HTTP协议
********************

HTTP协议是版本控制工具普遍采用的协议，具有安全（HTTPS），方便（跨越防火\
墙）等优点。Git在 1.6.6版本之前对HTTP协议支持有限，是哑协议，访问效率低，\
但是在1.6.6之后，通过一个CGI实现了智能的HTTP协议支持。

哑传输协议
===============

所谓的哑传输协议（dumb protocol）就是在Git服务器和Git客户端的会话过程中\
只使用了相关协议提供的基本传输功能，而未针对Git的传输特点进行相关优化设计。\
采用哑协议，Git客户端和服务器间的通讯缺乏效率，用户使用时最直观的体验之一\
就是在操作过程没有进度提示，应用会一直停在那里直到整个通讯过程处理完毕。

但是哑传输协议配置起来却非常的简单。通过哑HTTP协议提供Git服务，\
基本上就是把包含Git版本库的目录通过HTTP服务器共享出来。下面的Apache\
配置片段就将整个目录\ ``/path/to/repos``\ 共享，然后就可以通过地址\
``http://<服务器名称>/git/<版本库名称>``\ 访问该共享目录下所有的Git版本库。

::

  Alias /git /path/to/repos

  <Directory /path/to/repos>
      Options FollowSymLinks
      AllowOverride None
      Order Allow,Deny
      Allow from all
  </Directory>

如果以为直接把现存的Git版本库移动到该目录下就可以直接用HTTP协议访问，\
可就大错特错了。因为哑协议下的Git版本库需要包含两个特殊的文件，并且\
这两个文件要随Git版本库更新。例如将一个包含提交数据的裸版本库复制到\
路径\ ``/path/to/repos/myrepos.git``\ 中，然后使用下面命令克隆该版本库\
（服务器名称为\ ``server``\），可能会看到如下错误：

::

  $ git clone http://server/git/myrepos.git
  正克隆到 'myrepos'...
  fatal: repository 'http://server/git/myrepos.git/' not found

这时，您仅需在Git版本库目录下执行\ ``git update-server-info``\ 命令\
即可在Git版本库中创建哑协议需要的相关文件。

::

  $ git update-server-info

然后该Git版本库即可正常访问了。如下：

::

  $ git clone http://server/git/myrepos.git
  正克隆到 'myrepos'...
  检查连接... 完成。

从上面的介绍中可以看出在使用哑HTTP协议时，服务器端运行\ ``git update-server-info``\
的重要性。运行该命令会产生或更新两个文件：

* 文件\ :file:`.git/info/refs`\ ：该文件中包含了版本库中所有的引用列表，\
  每一个引用都指向正确的SHA1哈希值。

* 文件\ :file:`.git/objects/info/packs`\ ：该文件记录Git对象库中打包文件列表。

正是通过这两个文件，Git客户端才检索到版本库的引用列表和对象库的包列表，从而实现\
对版本库的读取操作。

为支持哑HTTP协议，必须在版本库更新后及时更新上述两个文件。幸好Git版本库的\
钩子脚本\ :file:`post-update`\ 可以帮助完成这个无聊的工作。在版本库的\ ``hooks``\
目录下创建可执行脚本文件\ :file:`post-update`\ ，内容如下：

::

  #!/bin/sh
  #
  # An example hook script to prepare a packed repository for use over
  # dumb transports.
  #
  # To enable this hook, rename this file to "post-update".

  exec git update-server-info

哑HTTP协议也可以对版本库写操作提供支持，即允许客户端向服务器推送。这需要在Apache中\
为版本库设置WebDAV，并配置口令认证。例如下面的Apache配置片段：

::

  Alias /git /path/to/repos

  <Directory /path/to/repos>
      Options FollowSymLinks
      AllowOverride None
      Order Allow,Deny
      Allow from all

      # 启用 WebDAV
      DAV on

      # 简单口令认证
      AuthType Basic
      AuthName "Git Repository"
      AuthBasicProvider file
      # 该口令文件用 htpasswd 命令进行管理
      AuthUserFile /path/to/git-passwd
      Require valid-user

      # 基于主机IP的认证和基于口令的认证必须同时满足
      Satisfy All
  </Directory>

配置了口令认证后，最好使用HTTPS协议访问服务器，以避免因为口令在网络中明文传输\
造成口令泄露。还可以在URL地址中加上用户名，以免在连接过程中的重复输入。下面的示例\
中以特定用户（如：jiangxin）身份访问版本库：

* 如果版本库尚未克隆，使用如下命令克隆：

  ::

    $ git clone https://jiangxin@server/git/myrepo.git

* 如果已经克隆了版本库，可以执行下面命令修改远程\ ``origin``\ 版本库的URL地址：

  ::

    $ cd myrepos
    $ git remote set-url origin https://jiangxin@server/git/myrepo.git
    $ git pull

第一次连接服务器，会提示输入口令。正确输入口令后，完成克隆或版本库的更新。\
试着在版本库中添加新的提交，然后执行\ ``git push``\ 推送到HTTP服务器。

如果推送失败，可能是WebDAV配置的问题，或者是版本库的文件、目录的权限不正确\
（需要能够被执行Apache进程的用户可以读写）。一个诊断Apache的小窍门是查看\
和跟踪Apache的配置文件\ [#]_\ 。如下：

::

  $ tail -f /var/www/error.log

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

  当用地址\ ``http://server/git/myrepo.git``\ 访问时，即\
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


.. [#] Apache日志文件的位置参见Apache配置文件中\ ``ErrorLog``\ 指令的设定。
