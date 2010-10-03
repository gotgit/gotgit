Gitweb
=======

Gitweb 本身不能提供 Git 版本库的读写服务。Gitweb 是用 Perl 语言开发的 CGI 脚本，只是一个提供 Git 版本库的 Web 浏览工具。

Gitweb 支持多个版本库，可以对版本库进行目录浏览（包括历史版本），可以查看文件内容，查看提交历史，提供搜索以及 RSS feed 支持。也可以提供目录文件的打包下载等。

TODO: 插入 gitweb 示例图片。

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
-----------

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

  在 CGI 脚本所在的目录下，创建 `indextext.html` 文件。下面是我们公司内部 gitweb 自定义首页的内容。

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

* Gitweb 菜单定制

  - 在 tree view 文件的旁边显示 blame 链接

    ::

      $feature{'blame'}{'default'} = [1];
      $feature{'blame'}{'override'} = 1;

  - 可以通过版本库的配置文件 `config` 对版本库进行单独设置。

    下面的设置覆盖 gitweb 的全局设置，不对该项目显示 blame 菜单。

    ::

        [gitweb]
        blame = 0
    
  - 为每个tree 添加 snapshot 链接

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

