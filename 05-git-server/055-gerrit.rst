Gerrit 代码审核服务器
=====================

Gerrit 名字的由来。

Gerrit Code Review started as a simple set of patches to Rietveld, and was originally built to service AOSP. This quickly turned into a fork as we added access control features that Guido van Rossum did not want to see complicating the Rietveld code base. As the functionality and code were starting to become drastically different, a different name was needed. Gerrit calls back to the original namesake of Rietveld, Gerrit Rietveld, a Dutch architect.

Gerrit2 is a complete rewrite of the Gerrit fork, completely changing the implementation from Python on Google App Engine, to Java on a J2EE servlet container and a SQL database. 


Gerrit 的部署
--------------

从下面的地址下载 Gerrit ： http://code.google.com/p/gerrit/downloads/list 。

在下载页面会有一个类似 Gerrit-x.x.x.war 的 war 包，下载并另存为 Gerrit.war 。这个文件就是 Gerrit 的全部。为节约篇幅，就不介绍如何从源码编译 Gerrit 的 war 包了。

Gerrit 需要一个数据库，目前支持 PostgreSQL, MySQL 以及嵌入式的 H2 数据库。我们直接使用 H2 数据库就好了。

创建一个 gerrit 用户，并以该用户身份执行安装。

::

  $ sudo adduser gerrit
  $ sudo su gerrit
  $ cd ~gerrit
  $ java -jar gerrit.war init -d review_site

会提问一系列问题。

* 创建相关目录。

  ::

    *** Gerrit Code Review 2.1.5
    *** 
    
    Create '/home/gerrit/review_site' [Y/n]? 

    *** Git Repositories
    *** 
    
    Location of Git repositories   [git]: 
    
* 数据库类型。

  ::

    *** SQL Database
    *** 
    
    Database server type           [H2/?]: 
    
* 询问认证类型。

  输入问号可以查看其它可选的认证类型。

  ::

    *** User Authentication
    ***
    
    Authentication method          [OPENID/?]: ?
           Supported options are:
             openid
             http
             http_ldap
             ldap
             ldap_bind
             development_become_any_account
    Authentication method          [OPENID/?]: http
    
* 发送邮件设置。

  ::

    *** Email Delivery
    ***
    
    SMTP server hostname           [localhost]:
    SMTP server port               [(default)]: 
    SMTP encryption                [NONE/?]: 
    SMTP username                  : 
    
* Java 相关设置。

  ::

    *** Container Process
    *** 
    
    Run as                         [gerrit]: 
    Java runtime                   [/usr/lib/jvm/java-6-sun-1.6.0.21/jre]: 
    Copy gerrit.war to /home/gerrit/review_site/bin/gerrit.war [Y/n]? 
    Copying gerrit.war to /home/gerrit/review_site/bin/gerrit.war
    
* SSH 服务相关设置。

  ::

    *** SSH Daemon
    *** 
    
    Listen on address              [*]: 
    Listen on port                 [29418]: 
    
    Gerrit Code Review is not shipped with Bouncy Castle Crypto v144
      If available, Gerrit can take advantage of features
      in the library, but will also function without it.
    Download and install it now [Y/n]?
    Downloading http://www.bouncycastle.org/download/bcprov-jdk16-144.jar ...  OK
    Checksum bcprov-jdk16-144.jar OK
    Generating SSH host key ... rsa... dsa... done
    
* HTTP 服务相关设置。

  ::

    *** HTTP Daemon
    ***

    Behind reverse proxy           [y/N]? y
    Proxy uses SSL (https://)      [y/N]? 
    Subdirectory on proxy server   [/]: /gerrit 
    Listen on address              [*]: 
    Listen on port                 [8080]: 8888
    
* 启动 Gerrit 服务器。

  ::

    Initialized /home/gerrit/review_site
    Executing /home/gerrit/review_site/bin/gerrit.sh start
    
    Starting Gerrit Code Review: OK
    Waiting for server to start ... OK
    Opening browser ...

* 设置服务自动启动。

  Gerrit 服务的启动脚本支持 start, stop, restart 参数，可以作为 init 脚本开机自动执行。

  ::

    $ sudo ln -snf /home/gerrit/review_site/bin/gerrit.sh /etc/init.d/gerrit.sh
    $ sudo ln -snf ../init.d/gerrit.sh /etc/rc2.d/S90gerrit
    $ sudo ln -snf ../init.d/gerrit.sh /etc/rc3.d/S90gerrit

* 创建服务自启动的配置文件。

  服务启动脚本 /etc/init.d/gerrit.sh 需要通过 /etc/default/gerritcodereview 提供一些缺省配置。以下面内容创建该文件。

  ::

    GERRIT_SITE=/home/gerrit/review_site
    NO_START=0

Gerrit 的配置
--------------

编辑 Gerrit 的配置文件 /home/gerrit/review_site/etc/gerrit.config 可以修改上面的配置。

::

  [gerrit]
    basePath = git
  [database]
    type = H2
    database = db/ReviewDB
  [auth]
    type = HTTP
  [sendemail]
    smtpServer = localhost
  [container]
    user = gerrit
    javaHome = /usr/lib/jvm/java-6-sun-1.6.0.21/jre
  [sshd]
    listenAddress = *:29418
  [httpd]
    listenUrl = proxy-http://*:8888/gerrit
  [cache]
    directory = cache

配置 Apache 的反向代理：

::

  <VirtualHost *:80>
    ServerName review.moon.ossxp.com

    ProxyRequests Off
    ProxyVia Off
    ProxyPreserveHost On

    <Proxy *>
          Order deny,allow
          Allow from all
    </Proxy>

    <Location /gerrit/login/>
      AuthType Basic
      AuthName "Gerrit Code Review"
      Require valid-user
      AuthUserFile /home/gerrit/review_site/etc/gerrit.passwd
    </Location>

    ProxyPass /gerrit/ http://127.0.0.1:8888/gerrit/
  </VirtualHost> 

在上面的 Apache 配置中，我们为 Gerrit 增加了口令认证的设置，口令文件保存在 /home/gerrit/review_site/etc/gerrit.passwd 中。我们可以用 htpasswd 命令维护该口令文件。

::

  $ htpasswd -c -m /home/gerrit/review_site/etc/gerrit.passwd jiangxin
  New password: 
  Re-type new password: 
  Adding password for user jiangxin

打开浏览器，弹出认证对话框，输入正确的用户名和口令，显示管理界面。第一个用户是默认的管理员。

TODO: 截图：邮件地址确认对话框。

邮件地址确认后，进入管理界面。

配置公钥。 TODO 

查看用户的分组。

项目管理
-----------

All Git repositories under gerrit.basePath must be registered in the Gerrit database in order to be accessed through SSH, or through the web interface.


Create Through SSH

Creating a new repository over SSH is perhaps the easiest way to configure a new project:

ssh -p 29418 review.example.com gerrit create-project --name new/project

Manual Creation

Projects may also be manually registered with the database.
Create Git Repository

Create a Git repository under gerrit.basePath:

git --git-dir=$base_path/new/project.git init

Tip
  By tradition the repository directory name should have a .git suffix.

To also make this repository available over the anonymous git:// protocol, don’t forget to create a git-daemon-export-ok file:

touch $base_path/new/project.git/git-daemon-export-ok

Register Project

One insert is needed to register a project with Gerrit.
Note
  Note that the .git suffix is not typically included in the project name, as it looks cleaner in the web when not shown. Gerrit automatically assumes that project.git is the Git repository for a project named project.

INSERT INTO projects
(use_contributor_agreements
 ,submit_type
 ,name)
VALUES
('N'
,'M'
,'new/project');

Change Submit Action

The method Gerrit uses to submit a change to a project can be modified by any project owner through the project console, Admin > Projects. The following methods are supported:

    *

      Fast Forward Only

      This method produces a strictly linear history. All merges must be handled on the client, prior to uploading to Gerrit for review.

      To submit a change, the change must be a strict superset of the destination branch. That is, the change must already contain the tip of the destination branch at submit time.
    *

      Merge If Necessary

      This is the default for a new project (and why \'M' is suggested above in the insert statement).

      If the change being submitted is a strict superset of the destination branch, then the branch is fast-forwarded to the change. If not, then a merge commit is automatically created. This is identical to the classical git merge behavior, or git merge \--ff.
    *

      Always Merge

      Always produce a merge commit, even if the change is a strict superset of the destination branch. This is identical to the behavior of git merge \--no-ff, and may be useful if the project needs to follow submits with git log \--first-parent.
    *

      Cherry Pick

      Always cherry pick the patch set, ignoring the parent lineage and instead creating a brand new commit on top of the current branch head.

      When cherry picking a change, Gerrit automatically appends onto the end of the commit message a short summary of the change’s approvals, and a URL link back to the change on the web. The committer header is also set to the submitter, while the author header retains the original patch set author.

Registering Additional Branches

Branches can be created over the SSH port by any git push client, if the user has been granted the Push Branch > Create Branch (or higher) access right.

Additional branches can also be created through the web UI, assuming at least one commit already exists in the project repository. A project owner can create additional branches under Admin > Projects > Branches. Enter the new branch name, and the starting Git revision. Branch names that don’t start with refs/ will automatically have refs/heads/ prefixed to ensure they are a standard Git branch name. Almost any valid SHA-1 expression can be used to specify the starting revision, so long as it resolves to a commit object. Abbreviated SHA-1s are not supported.


版本库钩子
-----------

版本库复制
-----------
创建 '$site_path'/replication.config 文件

[remote "host-one"]
  url = gerrit2@host-one.example.com:/some/path/${name}.git

[remote "pubmirror"]
  url = mirror1.us.some.org:/pub/git/${name}.git
  url = mirror2.us.some.org:/pub/git/${name}.git
  url = mirror3.us.some.org:/pub/git/${name}.git
  push = +refs/heads/*
  push = +refs/tags/*
  threads = 3
  authGroup = Public Mirror Group
  authGroup = Second Public Mirror Group


定制 Gerrit 界面
------------------

At startup Gerrit reads the following files (if they exist) and uses them to customize the HTML page it sends to clients:

    * '$site_path'/etc/GerritSiteHeader.html

      HTML is inserted below the menu bar, but above any page content. This is a good location for an organizational logo, or links to other systems like bug tracking.

    * '$site_path'/etc/GerritSiteFooter.html

      HTML is inserted at the bottom of the page, below all other content, but just above the footer rule and the "Powered by Gerrit Code Review (v….)" message shown at the extreme bottom.

    * '$site_path'/etc/GerritSite.css

      The CSS rules are inlined into the top of the HTML page, inside of a <style> tag. These rules can be used to support styling the elements within either the header or the footer.
  
The *.html files must be valid XHTML, with one root element, typically a single <div> tag. The server parses it as XML, and then inserts the root element into the host page. If a file has more than one root level element, Gerrit will not start.

静态图片可以放到 /static 目录下。

Static image files can also be served from '$site_path'/static, and may be referenced in GerritSite{Header,Footer}.html or GerritSite.css by the relative URL static/$name (e.g. static/logo.png).


Gitweb 整合
-----------

内置的 Git web 整合

In the internal configuration, Gerrit inspects the request, enforces its project level access controls, and directly executes gitweb.cgi if the user is authorized to view the page.

To enable the internal configuration, set gitweb.cgi with the path of the installed CGI. This defaults to /usr/lib/cgi-bin/gitweb.cgi, which is a common installation path for the gitweb package on Linux distributions.

git config --file $site_path/etc/gerrit.config gitweb.cgi /usr/lib/cgi-bin/gitweb.cgi

After updating '$site_path'/etc/gerrit.config, the Gerrit server must be restarted and clients must reload the host page to see the change.

Configuration

Most of the gitweb configuration file is handled automatically by Gerrit Code Review. Site specific overrides can be placed in '$site_path'/etc/gitweb_config.perl, as this file is loaded as part of the generated configuration file.

Logo and CSS

If the package-manager installed CGI (/usr/lib/cgi-bin/gitweb.cgi) is being used, the stock CSS and logo files will be served from either /usr/share/gitweb or /var/www.

Otherwise, Gerrit expects gitweb.css and git-logo.png to be found in the same directory as the CGI script itself. This matches with the default source code distribution, and most custom installations.
Access Control

Access controls for internally managed gitweb page views are enforced using the standard project READ +1 permission.


外部的 Git web 整合

External/Unmanaged gitweb

In the external configuration, gitweb runs under the control of an external web server, and Gerrit access controls are not enforced.

To enable the external gitweb integration, set gitweb.url with the URL of your gitweb CGI.

The CGI’s $projectroot should be the same directory as gerrit.basePath, or a fairly current replica. If a replica is being used, ensure it uses a full mirror, so the refs/changes/* namespace is available.

git config --file $site_path/etc/gerrit.config gitweb.url http://example.com/gitweb.cgi

After updating '$site_path'/etc/gerrit.config, the Gerrit server must be restarted and clients must reload the host page to see the change.


命令行式管理
-------------

用户命令：

$ ssh -p 29418 review.example.com gerrit ls-projects


管理员命令：

gerrit create-account

    Create a new batch/role account.

    $ cat ~/.ssh/id_watcher.pub | ssh -p 29418 review.example.com gerrit create-account --ssh-key - watcher

gerrit create-group

    Create a new account group.

gerrit create-project

    Create a new project and associated Git repository.

gerrit flush-caches

    Flush some/all server caches from memory.

gerrit gsql

    Administrative interface to active database.

    数据库管理

$ java -jar gerrit.war gsql
Welcome to Gerrit Code Review v2.0.25
(PostgreSQL 8.3.8)

Type '\h' for help.  Type '\r' to clear the buffer.

gerrit> update accounts set ssh_user_name = 'alice' where account_id=1;
UPDATE 1; 1 ms
gerrit> \q
Bye



gerrit set-project-parent

    Change the project permissions are inherited from.

gerrit show-caches

    Display current cache statistics.
gerrit show-connections

    Display active client SSH connections.
gerrit show-queue

    Display the background work queues, including replication.
gerrit replicate

    Manually trigger replication, to recover a node.
kill

    Kills a scheduled or running task.
ps

    Alias for gerrit show-queue.
suexec

    Execute a command as any registered user account.

