Gerrit 代码审核服务器
=====================

谷歌 Android 开源项目在 Git 的使用上有两个重要的创新，一个是为多版本库协同而引入的 repo，这在之前我们已经详细讨论过。另外一个重要的创新就是 Gerrit —— 代码审核服务器。Gerrit 为 Git 引入的代码审核是强制性的，就是说除非特别的授权设置，向 Git 版本库的推送（Push）必须要经过 Gerrit 服务器，修订必须经过代码审核的一套工作流之后，才可能经批准并纳入正式代码库中。

首先贡献者的代码通过 git 命令（或 repo 封装）推送到 Gerrit 管理下的 Git 版本库，推送的提交转化为一个一个的代码审核任务，审核任务可以通过 `refs/changes/` 下的引用访问到。代码审核者可以通过 Web 界面查看审核任务、代码变更，通过 Web 界面做出通过代码审核或者打回等决定。测试者也可以通过 `refs/changes/` 之下的引用获取（fetch）修订对其进行测试，如果测试通过就可以将该评审任务设置为校验通过（verified）。最后经过了审核和校验的修订可以通过 Gerrit 界面中提交动作合并到版本库对应的分支中。

在 Android 项目的网站的代码贡献流程图更为详细的介绍了 Gerrit 代码审核服务器的工作流程。

  .. figure:: images/gerrit/gerrit-workflow.png
     :scale: 80

     Gerrit 代码审核工作流

Gerrit 的实现原理
-----------------

Gerrit 更准确的说应该称为 Gerrit2。因为 Android 项目最早使用的评审服务器 Gerrit 不是今天这个样子，最早版本的 Gerrit 是用 Python 开发运行于 Google App Engine 上，是从 Python 之父 Guido van Rossum 开发的 Rietveld 分支而来。我们这里讨论的 Gerrit 实为 Gerrit2，是用 Java 语言实现的。从 `这里 <http://code.google.com/p/gerrit/wiki/Background>`_ 可以看到 Gerrit 更为详尽的发展历史。

**SSH 协议的 Git 服务器**

Gerrit 本身基于 SSH 协议实现了一套 Git 服务器，这样就可以对 Git 数据推送进行更为精确的控制，为强制审核的实现建立了基础。

Gerrit 提供的 Git 服务的端口并非标准的 22 端口，缺省是 29418 端口。可以访问 Gerrit 的 Web 界面得到这个端口。对 Android 项目的代码审核服务器，访问 https://review.source.android.com/ssh_info 就可以查看到 Git 服务的服务器域名和开放的端口。下面我们用 curl 命令查看网页的输出。

::

  $ curl -L -k http://review.source.android.com/ssh_info
  review.source.android.com 29418

**特殊引用 refs/for/<branch-name> 和 refs/changes/nn/<review-id>/m**

Gerrit 的 Git 服务器，禁止用户向 `refs/heads` 命名空间下的引用执行推送（除非特别的授权），即不允许用户直接向分支进行提交。为了让开发者能够向 Git 服务器提交修订，Gerrit 的 Git 服务器只允许用户向特殊的引用 `refs/for/<branch-name>` 下执行推送，其中 `<branch-name>` 即为开发者的工作分支。向 `refs/for/<branch-name>` 命名空间下推送并不会在其中创建引用，而是为新的提交分配一个 ID，称为 review-id ，并为该 review-id 的访问建立如下格式的引用 `refs/changes/nn/<review-id>/m` ，其中：

* review-id 为 Gerrit 为评审任务顺序分配的全局唯一的号码。
* nn 为 review-id 的后两位数，位数不足用零补齐。即 nn 为 review-id 除以 100 的余数。
* m 为修订号，该 review-id 的首次提交修订号为 1，如果该修订被打回，重新提交修订号会自增。

**Git 库的钩子脚本 hooks/commit-msg**

为了保证已经提交审核的修订通过审核入库后，被别的分支 cherry-pick 后再推送至服务器时不会产生新的重复的评审任务，Gerrit 设计了一套方法，即要求每个提交包含唯一的 Change-Id，这个 Change-Id 因为出现在日志中，当执行 cherry-pick 时也会保持，Gerrit 一旦发现新的提交包含了已经处理过的 `Change-Id` ，就不再为该修订创建新的评审任务和 review-id，而直接将提交入库。

为了实现 Git 提交中包含唯一的 Change-Id，Gerrit 提供了一个钩子脚本，放在开发者本地 Git 库中（hooks/commit-msg）。这个钩子脚本在用户提交时自动在提交说明中创建以 "Change-Id: " 及包含 `git hash-object` 命令产生的哈希值的唯一标识。当 Gerrit 获取到用户向 `refs/for/<branch-name>` 推送的提交中包含 "Change-Id: I..." 的变更 ID，如果该 Change-Id 之前没有见过，会创建一个新的评审任务并分配新的 review-id，并在 Gerrit 的数据库中保存 Change-Id 和 review-id 的关联。

如果当用户的提交因为某种原因被要求打回重做，开发者修改之后重新推送到 Gerrit 时就要注意在提交说明中使用相同的 “Change-Id” （使用 --amend 提交即可保持提交说明），以免创建新的评审任务，还要在推送时将当前分支推送到 `refs/changes/nn/review-id/m` 中。其中 `nn` 和 `review-id` 和之前提交的评审任务的修订相同，m 则要人工选择一个新的修订号。

以上说起来很复杂，但是在实际操作中只要使用 repo 这一工具，就相对容易多了。

**其余一切交给 Web**

Gerrit 另外一个重要的组件就是 Web 服务器，通过 Web 服务器实现对整个评审工作流的控制。关于 Gerrit 工作流，参见在本章开头出现的 Gerrit 工作流程图。

感受一下 Gerrit 的魅力？直接访问 Android 项目的 Gerrit 网站： https://review.source.android.com/ 。

  .. figure:: images/gerrit/android-gerrit-merged.png
     :scale: 70

     Android 项目代码审核网站

Android 项目的评审网站，匿名即可访问。点击菜单中的 “Merged” 显示了已经通过评审合并到代码库中的审核任务。下面的一个界面就是 Andorid 一个已经合并到代码库中的历史评审任务。

  .. figure:: images/gerrit/android-gerrit-16993.png
     :scale: 70

     Android 项目的 16993 号评审

在该界面我们可以看到：

* URL 中显示的评审任务编号为 16993。
* 该评审任务的 Change-Id 以字母 I 开头，包含了一个唯一的 40 位 SHA1 哈希。
* 整个评审任务有三个人参与，一个人进行了检查（verify），两个人进行了代码审核。
* 该评审任务的状态为已合并：“merged”。
* 该评审任务总共包含两个补丁集： Patch set 1 和 Patch set 2。
* 补丁集的下载方法是: `repo download platform/sdk 16993/2` 。

如果使用 repo 命令获取补丁集是非常方便的，因为封装后的 repo 屏蔽掉了 Gerrit 的一些实现细节，例如补丁集在 Git 库中的存在位置。如前所述，补丁集实际保存在 `refs/changes` 命名空间下。使用 `git ls-remote` 命令，从 Gerrit 维护的代码库中我们可以看到补丁集对应的引用名称。

::

  $ git ls-remote ssh://review.source.android.com:29418/platform/sdk refs/changes/93/16993*
  5fb1e79b01166f5192f11c5f509cf51f06ab023d        refs/changes/93/16993/1
  d342ef5b41f07c0202bc26e2bfff745b7c86d5a7        refs/changes/93/16993/2

接下来我们就来介绍一下 Gerrit 服务器的部署和使用方法。

架设 Gerrit 的服务器
---------------------

**下载 war 包**

Gerrit 是由 Java 开发的，封装为一个 war 包: gerrit.war ，安装非常简洁。如果需要从源码编译出 war 包，可以参照文档: http://gerrit.googlecode.com/svn/documentation/2.1.5/dev-readme.html 。不过最简单的就是从 Google Code 上直接下载编译号的 war 包。 

从下面的地址下载 Gerrit 的 war 包： http://code.google.com/p/gerrit/downloads/list 。在下载页面会有一个文件名类似 Gerrit-x.x.x.war 的 war 包，这个文件就是 Gerrit 的全部。我们使用的是 2.1.5.1 版本，把下载的 Gerrit-2.1.5.1.war 包重命名为 Gerrit.war 。我们下面的介绍就是基于这个版本。

**数据库选择**

Gerrit 需要数据库来维护账户信息、跟踪评审任务等。目前支持的数据库类型有 PostgreSQL, MySQL 以及嵌入式的 H2 数据库。

选择使用缺省的 H2 内置数据库是最简单的，因为这样无须任何设置。如果想使用更为熟悉的 PostgreSQL 或者 MySQL，则预先建立数据库。

对于 PostgreSQL，我们在数据库中创建一个用户 gerrit，并创建一个数据库 reviewdb。

::

  createuser -A -D -P -E gerrit
  createdb -E UTF-8 -O gerrit reviewdb

对于 MySQL，我们在数据库中创建一个用户 gerrit 并为其设置口令（不要真如下面的将口令置为 secret），并创建一个数据库 reviewdb。

::

  $ mysql -u root -p

  mysql> CREATE USER 'gerrit'@'localhost' IDENTIFIED BY 'secret';
  mysql> CREATE DATABASE reviewdb;
  mysql> ALTER DATABASE reviewdb charset=latin1;
  mysql> GRANT ALL ON reviewdb.* TO 'gerrit'@'localhost';
  mysql> FLUSH PRIVILEGES;

**以一个专用用户帐号执行安装**

在系统中创建一个专用的用户帐号如：gerrit。以该用户身份执行安装，将 Gerrit 的配置文件、内置数据库、war 包等都自动安装在该用户主目录下的特定目录中。

::

  $ sudo adduser gerrit
  $ sudo su gerrit
  $ cd ~gerrit
  $ java -jar gerrit.war init -d review_site

在安装过程中会提问一系列问题。

* 创建相关目录。

  缺省 Grerit 在安装用户主目录下创建 review_site 并把相关文件安装在这个目录之下。Git 版本库的根路径缺省位于此目录之下 的 git 目录中。
  ::

    *** Gerrit Code Review 2.1.5.1
    *** 
    
    Create '/home/gerrit/review_site' [Y/n]? 

    *** Git Repositories
    *** 
    
    Location of Git repositories   [git]: 
    
* 选择数据库类型。

  选择 H2 数据库是简单的选择，无须额外的配置。

  ::

    *** SQL Database
    *** 
    
    Database server type           [H2/?]: 
    
* 设置 Gerrit Web 界面认证的类型。

  缺省为 openid，即使用任何支持 OpenID 的认证源（如 Google, Yahoo）进行身份认证。此模式支持用户自建帐号，当用户通过 OpenID 认证源的认证后，Gerrit 会自动从认证源获取相关属性如用户全名和邮件地址等信息创建帐号。Android 项目的 Gerrit 服务器即采用此认证模式。
  
  如果有可用的 LDAP 服务器，那么 ldap 或者 ldap_bind 也是非常好的认证方式，可以直接使用 LDAP 中的已有帐号进行认证，不过此认证方式下 Gerrit 的自建帐号功能关闭。此安装示例我们选择的就是 LDAP 认证方式。
  
  http 认证也是可选的认证方式，此认证方式需要配置 Apache 的反向代理并在 Apache 中配置 Web 站点的口令认证，通过口令认证后 Gerrit 在创建帐号的过程中会询问用户的邮件地址并发送确认邮件。

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
    Authentication method          [OPENID/?]: ldap
    LDAP server                    [ldap://localhost]: 
    LDAP username                  : 
    Account BaseDN                 : dc=foo,dc=bar
    Group BaseDN                   [dc=foo,dc=bar]: 
    
* 发送邮件设置。

  缺省使用本机的 SMTP 发送邮件。

  ::

    *** Email Delivery
    ***
    
    SMTP server hostname           [localhost]:
    SMTP server port               [(default)]: 
    SMTP encryption                [NONE/?]: 
    SMTP username                  : 
    
* Java 相关设置。

  使用 OpenJava 和 Sun Java 均可。Gerrit 的 war 包要复制到 review_site/bin 目录中。

  ::

    *** Container Process
    *** 
    
    Run as                         [gerrit]: 
    Java runtime                   [/usr/lib/jvm/java-6-sun-1.6.0.21/jre]: 
    Copy gerrit.war to /home/gerrit/review_site/bin/gerrit.war [Y/n]? 
    Copying gerrit.war to /home/gerrit/review_site/bin/gerrit.war
    
* SSH 服务相关设置。

  Gerrit 的基于 SSH 协议的 Git 服务非常重要，缺省的端口为 29418。换做其它端口也无妨，因为 repo 可以自动探测到该端口。

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

  缺省启用内置的 HTTP 服务器，端口为 8080，如果该端口被占用（如 Tomcat），则需要更换为其它端口，否则服务启动失败。如下例就换做了 8888 端口。

  ::

    *** HTTP Daemon
    ***

    Behind reverse proxy           [y/N]? y
    Proxy uses SSL (https://)      [y/N]? y
    Subdirectory on proxy server   [/]: /gerrit
    Listen on address              [*]: 
    Listen on port                 [8081]: 
    Canonical URL                  [https://localhost/gerrit]:         

    Initialized /home/gerrit/review_site

**启动 Gerrit 服务**

Gerrit 服务正确安装后，运行 Gerrit 启动脚本启动 Gerrit 服务。

  ::

    $ /home/gerrit/review_site/bin/gerrit.sh start
    Starting Gerrit Code Review: OK

服务正确启动之后，我们会看到 Gerrit 服务打开两个端口，这两个端口是我们在 Gerrit 安装时指定的。您的输出和下面的示例可能略有不同。

::

  $ sudo netstat -ltnp | grep -i gerrit
  tcp        0      0 0.0.0.0:8081            0.0.0.0:*               LISTEN      26383/GerritCodeRev
  tcp        0      0 0.0.0.0:29418           0.0.0.0:*               LISTEN      26383/GerritCodeRev

**设置 Gerrit 服务开机自动启动**

Gerrit 服务的启动脚本支持 start, stop, restart 参数，可以作为 init 脚本开机自动执行。

::

  $ sudo ln -snf /home/gerrit/review_site/bin/gerrit.sh /etc/init.d/gerrit.sh
  $ sudo ln -snf ../init.d/gerrit.sh /etc/rc2.d/S90gerrit
  $ sudo ln -snf ../init.d/gerrit.sh /etc/rc3.d/S90gerrit

服务自动启动脚本 /etc/init.d/gerrit.sh 需要通过 /etc/default/gerritcodereview 提供一些缺省配置。以下面内容创建该文件。

::

  GERRIT_SITE=/home/gerrit/review_site
  NO_START=0

**Gerrit 认证方式的选择**

如果是开放服务的 Gerrit 服务，使用 OpenId 认证是最好的方法，就像谷歌 Android 项目的代码审核服务器配置的那样。任何人只要在具有 OpenId provider 的网站上（如 Google，Yahoo 等）具有帐号，就可以直接通过 OpenId 注册，Gerrit 会在您登录 OpenId provider 网站成功后，自动获取（经过您的确认）您在 OpenId provider 站点上的部分注册信息（如用户全名或者邮件地址）在 Gerrit 上自动为您创建帐号。

如果架设有 LDAP 服务器，并且用户帐号都在 LDAP 中进行管理，那么采用 LDAP 认证也是非常好的方法。登录时提供的用户名和口令通过 LDAP 服务器验证之后，Gerrit 会自动从 LDAP 服务器中获取相应的字段属性，为用户创建帐号。创建的帐号的用户全名和邮件地址因为来自于 LDAP，因此不能在 Gerrit 更改，但是用户可以注册新的邮件地址。我配置 LDAP 认证时遇到了一个问题就是创建帐号的用户全名是空白，这是因为在 LDAP 相关的字段没有填写的原因。如果 LDAP 服务器使用的是 OpenLDAP，Gerrit 会从 displayName 字段获取用户全名，如果使用 Active Directory 则用 givenName 和 sn 字段的值拼接形成用户全名。

Gerrit 还支持使用 HTTP 认证，这种认证方式需要架设 Apache 反向代理，在 Apache 中配置 HTTP 认证。当用户访问 Gerrit 网站首先需要通过 Apache 配置的 HTTP Basic Auth 认证，当 Gerrit 发现用户已经登录后，会要求用户确认邮件地址。当用户邮件地址确认后，再填写其它必须的字段完成帐号注册。HTTP 认证方式的缺点除了在口令文件管理上需要管理员手工维护比较麻烦之外，还有一个缺点就是用户一旦登录成功后，想退出登录或者更换其它用户帐号登录变得非常麻烦，除非关闭浏览器。关于切换用户有一个小窍门：例如 Gerrit 登录 URL 为 https://server/gerrit/login/ ，则用浏览器访问 https://nobody:wrongpass@server/gerrit/login/ ，即用错误的用户名和口令覆盖掉浏览器缓存的认证用户名和口令，这样就可以重新认证了。

在后面的 Gerrit 演示和介绍中，为了设置帐号的方便，我们使用了 HTTP 认证，因此下面再介绍一下 HTTP 认证的配置方法。

**配置 Apache 代理访问 Gerrit**

缺省 Gerrit 的 Web 服务端口为 8080 或者 8081，通过 Apache 的反向代理就可以使用标准的 80 (http) 或者 443 (https) 来访问 Gerrit 的 Web 界面。

::

  ProxyRequests Off
  ProxyVia Off
  ProxyPreserveHost On

  <Proxy *>
        Order deny,allow
        Allow from all
  </Proxy>

  ProxyPass /gerrit/ http://127.0.0.1:8081/gerrit/

如果要配置 Gerrit 的 http 认证，则还需要在上面的配置中插入 Http Base 认证的设置。

::

  <Location /gerrit/login/>
    AuthType Basic
    AuthName "Gerrit Code Review"
    Require valid-user
    AuthUserFile /home/gerrit/review_site/etc/gerrit.passwd
  </Location>

在上面的配置中，我们指定了口令文件的位置：/home/gerrit/review_site/etc/gerrit.passwd 。我们可以用 htpasswd 命令维护该口令文件。

::

  $ touch /home/gerrit/review_site/etc/gerrit.passwd

  $ htpasswd -m /home/gerrit/review_site/etc/gerrit.passwd jiangxin
  New password: 
  Re-type new password: 
  Adding password for user jiangxin

至此为止，Gerrit 服务安装完成。在正式使用 Gerrit 之前，我们先来研究一下 Gerrit 的配置文件，以免安装过程中遗漏或错误的设置影响使用。

Gerrit 的配置文件
-----------------

Gerrit 的配置文件保存在部署目录下的 `etc/gerrit.conf` 文件中。如果对安装时的配置不满意，可以手工修改配置文件，重启 Gerrit 服务即可。

全部采用缺省配置时的配置文件：

::

  [gerrit]
          basePath = git
          canonicalWebUrl = http://localhost:8080/
  [database]
          type = H2
          database = db/ReviewDB
  [auth]
          type = OPENID
  [sendemail]
          smtpServer = localhost
  [container]
          user = gerrit
          javaHome = /usr/lib/jvm/java-6-openjdk/jre
  [sshd]
          listenAddress = *:29418
  [httpd]
          listenUrl = http://*:8080/
  [cache]
          directory = cache

如果采用 LDAP 认证，下面的配置文件片断配置了一个支持匿名绑定的 LDAP 服务器配置。

::

  [auth]
    type = LDAP
  [ldap]
    server = ldap://localhost
    accountBase = dc=foo,dc=bar
    groupBase = dc=foo,dc=bar

如果采用 MySQL 而非缺省的 H2 数据库，下面的配置文件显示了相关配置。

::

  [database]
          type = MYSQL
          hostname = localhost
          database = reviewdb
          username = gerrit

LDAP 绑定或者数据库连接的用户口令保存在 etc/secure.config 文件中。

::

  [database]
    password = secret

下面的配置将 Web 服务架设在 Apache 反向代理的后面。

::

  [httpd]
          listenUrl = proxy-https://*:8081/gerrit

Gerrit 的数据库访问
--------------------

之所以要对数据库访问多说几句，是因为一些对 Gerrit 的设置往往在 Web 界面无法配置，需要我们直接修改数据库，而大部分用户在安装 Gerrit 时都会选用内置的 H2 数据库，如何操作 H2 数据库可能大部分用户并不了解。

实际上无论选择何种数据库，Gerrit 都提供了两种数据库操作的命令行接口。第一种方法是在服务器端调用 gerrit.war 包中的命令入口，另外一种方法是远程 SSH 调用接口。

对于第一种方法，需要在服务器端执行，而且如果使用的是 H2 内置数据库还需要先将 Gerrit 服务停止。先以安装用户身份进入 Gerrit 部署目录下，在执行命令调用 gerrit.war 包，如下：

::

  $ java -jar bin/gerrit.war gsql
  Welcome to Gerrit Code Review 2.1.5.1
  (H2 1.2.134 (2010-04-23))

  Type '\h' for help.  Type '\r' to clear the buffer.

  gerrit> 

当出现 "gerrit>" 提示符时，就可以输入 SQL 语句操作数据库了。

第一种方式需要登录到服务器上，而且操作 H2 数据库时还要预先停止服务，显然很不方便。但是这种方法也有存在的必要，就是不需要认证，尤其是在管理员帐号尚未建立之前就可以查看和更改数据库。

当在 Gerrit 上注册了第一个帐号，即拥有了管理员帐号，正确为该帐号配置公钥之后，就可以访问 Gerrit 提供的 SSH 登录服务。Gerrit 的 SSH 协议提供第二个访问数据库的接口。下面的命令就是用管理员公钥登录 Gerrit 的 SSH 服务器，操作数据库。我们演示用的是本机地址（localhost），操作远程服务器也可以，只要拥有管理员授权。

::

  $ ssh -p 29418 localhost gerrit gsql


即连接 Gerrit 的 SSH 服务，运行命令 `gerrit gsql` 。当连接上数据库管理接口后，便出现 "gerrit>" 提示符，在该提示符下可以输入 SQL 命令。下面的示例中使用的数据库后端为 H2 内置数据库。

我们可以输入 `show tables` 命令显示数据库列表。

::

  gerrit> show tables;
   TABLE_NAME                  | TABLE_SCHEMA
   ----------------------------+-------------
   ACCOUNTS                    | PUBLIC
   ACCOUNT_AGREEMENTS          | PUBLIC
   ACCOUNT_DIFF_PREFERENCES    | PUBLIC
   ACCOUNT_EXTERNAL_IDS        | PUBLIC
   ACCOUNT_GROUPS              | PUBLIC
   ACCOUNT_GROUP_AGREEMENTS    | PUBLIC
   ACCOUNT_GROUP_MEMBERS       | PUBLIC
   ACCOUNT_GROUP_MEMBERS_AUDIT | PUBLIC
   ACCOUNT_GROUP_NAMES         | PUBLIC
   ACCOUNT_PATCH_REVIEWS       | PUBLIC
   ACCOUNT_PROJECT_WATCHES     | PUBLIC
   ACCOUNT_SSH_KEYS            | PUBLIC
   APPROVAL_CATEGORIES         | PUBLIC
   APPROVAL_CATEGORY_VALUES    | PUBLIC
   CHANGES                     | PUBLIC
   CHANGE_MESSAGES             | PUBLIC
   CONTRIBUTOR_AGREEMENTS      | PUBLIC
   PATCH_COMMENTS              | PUBLIC
   PATCH_SETS                  | PUBLIC
   PATCH_SET_ANCESTORS         | PUBLIC
   PATCH_SET_APPROVALS         | PUBLIC
   PROJECTS                    | PUBLIC
   REF_RIGHTS                  | PUBLIC
   SCHEMA_VERSION              | PUBLIC
   STARRED_CHANGES             | PUBLIC
   SYSTEM_CONFIG               | PUBLIC
   TRACKING_IDS                | PUBLIC
  (27 rows; 65 ms)

输入 `show columns` 命令显示数据库的表结构。

::

  gerrit> show columns from system_config;
   FIELD                      | TYPE         | NULL | KEY | DEFAULT
   ---------------------------+--------------+------+-----+--------
   REGISTER_EMAIL_PRIVATE_KEY | VARCHAR(36)  | NO   |     | ''
   SITE_PATH                  | VARCHAR(255) | YES  |     | NULL
   ADMIN_GROUP_ID             | INTEGER(10)  | NO   |     | 0
   ANONYMOUS_GROUP_ID         | INTEGER(10)  | NO   |     | 0
   REGISTERED_GROUP_ID        | INTEGER(10)  | NO   |     | 0
   WILD_PROJECT_NAME          | VARCHAR(255) | NO   |     | ''
   BATCH_USERS_GROUP_ID       | INTEGER(10)  | NO   |     | 0
   SINGLETON                  | VARCHAR(1)   | NO   | PRI | ''
  (8 rows; 52 ms)

关于 H2 数据库更多的 SQL 语法，参考： http://www.h2database.com/html/grammar.html 。

下面我们开始介绍 Gerrit 的使用。

第一个注册帐号：Gerrit 管理员
------------------------------

第一个 Gerrit 账户自动成为权限最高的管理员，因此 Gerrit 安装完毕后的第一件事情就是立即注册或者登录，以便初始化管理员帐号。下面我们的示例是在本机(localhost) 以 HTTP 认证方式架设的 Gerrit 审核服务器。当我们第一次访问的时候，会弹出非常眼熟的 HTTP Basic Auth 认证界面：

.. figure:: images/gerrit/gerrit-account-http-auth.png
   :scale: 80

   Http Basic Auth 认证界面

输入正确的用户名和口令登录后，系统自动创建 ID 为 1000000 的帐号，该帐号是第一个注册的帐号，会自动该被赋予管理员身份。因为使用的是 HTTP 认证，用户的邮件地址等个人信息尚未确定，因此登录后首先进入到个人信息设置界面。

.. figure:: images/gerrit/gerrit-account-init-1.png
   :scale: 80

   Gerrit 第一次登录后的个人信息设置界面
   
在上面我们可以看到在菜单中有 “Admin” 菜单项，说明当前登录的用户被赋予了管理员权限。在下面的联系方式确认对话框中有一个注册新邮件地址的按钮，点击该按钮弹出邮件地址录入对话框。

.. figure:: images/gerrit/gerrit-account-init-2.png
   :scale: 80

   输入个人的邮件地址

必须输入一个有效的邮件地址以便能够收到确认邮件。这个邮件地址非常重要，因为 Git 代码提交时在提交说明中出现的邮件地址需要和这个地址一致。当填写了邮件地址后，会收到一封确认邮件，点击邮件中的确认链接会重新进入到 Gerrit 界面。

.. figure:: images/gerrit/gerrit-account-init-4-settings-username.png
   :scale: 80

   邮件地址确认后进入 Gerrit 界面

我们在 Full Name 字段输入用户名，点击保存更改后，右上角显示的 “Anonymous Coward” 就会显示为登录用户的姓名和邮件地址。

接下来需要做的最重要的一件事就是配置公钥。通过该公钥，注册用户可以通过 SSH 协议向 Gerrit 的 Git 服务器提交，如果具有管理员权限还能够远程管理 Gerrit 服务器。

.. figure:: images/gerrit/gerrit-account-init-5-settings-ssh-pubkey.png
   :scale: 80

   Gerrit 的SSH公钥设置界面

在文本框中粘贴公钥。关于如何生成和管理公钥，可以参见 SSH 服务架设相关章节。TODO

点击 “Add” 按钮，完成公钥的添加。添加的公钥就会显示在列表中。一个用户可以添加多个公钥。

.. figure:: images/gerrit/gerrit-account-init-6-settings-ssh-pubkey-added.png
   :scale: 80

   用户的公钥列表

我们点击左侧的 “Groups” （用户组）菜单项，可以看到当前用户所属的分组。


.. figure:: images/gerrit/gerrit-account-init-7-settings-groups.png
   :scale: 80

   Gerrit 用户所属的用户组

管理员访问 SSH 的管理接口
--------------------------

用户命令：

$ ssh -p 29418 review.example.com gerrit ls-projects


我们看看 Android 的代码审核服务器。

::

  $ curl -L -k http://review.source.android.com/ssh_info
  review.source.android.com 29418

含义是 Gerrit 服务器打开的 SSH 服务位于 review.source.android.com 服务器的 29418 端口。

Gerrit 提供的 SSH 服务最主要的就是 Git 相关操作，如 git fetch, git pull, git fetch 等。我们会在后面进行演示。

可以从 Gerrit 的 SSH 服务器中通过 scp 命令拷贝文件。

::

  $ scp -P 29418 -p -r review.source.android.com:/ gerrit-files

  $ find gerrit-files -type f
  gerrit-files/bin/gerrit-cherry-pick
  gerrit-files/hooks/commit-msg


可以向 SSH 服务器输入 gerrit 命令。例如显示项目列表。

::

  $ ssh -p 29418 review.source.android.com gerrit ls-projects
  device/common
  device/htc/common
  ...

除此之外，还可以执行 Gerrit 相关的管理命令，如创建项目、数据库操作等。具体参见文档： Documentation/cmd-index.html 。


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


用户组管理
-----------
Access controls in Gerrit are group based. Every user account is a member of one or more groups, and access and privileges are granted to those groups. Groups cannot be nested, and access rights cannot be granted to individual users.
System Groups

Gerrit comes with 3 system groups, with special access privileges and membership management. The identity of these groups is set in the system_config table within the database, so the groups can be renamed after installation if desired.
Administrators

This is the Gerrit "root" identity.

Users in the Administrators group can perform any action under the Admin menu, to any group or project, without further validation of any other access controls. In most installations only those users who have direct filesystem and database access would be placed into this group.

Membership in the Administrators group does not imply any other access rights. Administrators do not automatically get code review approval or submit rights in projects. This is a feature designed to permit administrative users to otherwise access Gerrit as any other normal user would, without needing two different accounts.
Anonymous Users

All users are automatically a member of this group. Users who are not signed in are a member of only this group, and no others.

Any access rights assigned to this group are inherited by all users.

Administrators and project owners can grant access rights to this group in order to permit anonymous users to view project changes, without requiring sign in first. Currently it is only worthwhile to grant Read Access to this group as Gerrit requires an account identity for all other operations.
Registered Users

All signed-in users are automatically a member of this group (and also Anonymous Users, see above).

Any access rights assigned to this group are inherited by all users as soon as they sign-in to Gerrit. If OpenID authentication is being employed, moving from only Anonymous Users into this group is very easy. Caution should be taken when assigning any permissions to this group.

It is typical to assign Code Review -1..+1 to this group, allowing signed-in users to vote on a change, but not actually cause it to become approved or rejected.

Registered users are always permitted to make and publish comments on any change in any project they have Read Access to.
Account Groups

Account groups contain a list of zero or more user account members, added individually by a group owner. Any user account listed as a group member is given any access rights granted to the group.

To keep the schema simple to manage, groups cannot be nested. Only individual user accounts can be added as a member.

Every group has one other group designated as its owner. Users who are members of the owner group can:

    *

      Add users to this group
    *

      Remove users from this group
    *

      Change the name of this group
    *

      Change the description of this group
    *

      Change the owner of this group, to another group

It is permissible for a group to own itself, allowing the group members to directly manage who their peers are.

Newly created groups are automatically created as owning themselves, with the creating user as the only member. This permits the group creator to add additional members, and change the owner to another group if desired.

It is somewhat common to create two groups at the same time, for example Foo and Foo-admin, where the latter group Foo-admin owns both itself and also group Foo. Users who are members of Foo-admin can thus control the membership of Foo, without actually having the access rights granted to Foo. This configuration can help prevent accidental submits when the members of Foo have submit rights on a project, and the members of Foo-admin typically do not need to have such rights.




用户授权管理
---------------

http://gerrit.googlecode.com/svn/documentation/2.1.5/access-control.html#category_FORG

Project Access Control Lists

A system wide access control list affecting all projects is stored in project "-- All Projects --". This inheritance can be configured through gerrit set-project-parent.

Per-project access control lists are also supported.

Users are permitted to use the maximum range granted to any of their groups in an approval category. For example, a user is a member of Foo Leads, and the following ACLs are granted on a project:
Group   Reference Name  Category  Range
Anonymous Users   refs/heads/*  Code Review   -1..+1
Registered Users  refs/heads/*  Code Review   -1..+2
Foo Leads   refs/heads/*  Code Review   -2..0

Then the effective range permitted to be used by the user is -2..+2, as the user is a member of all three groups (see above about the system groups) and the maximum range is chosen (so the lowest value granted to any group, and the highest value granted to any group).

Reference-level access control is also possible.

Permissions can be set on a single reference name to match one branch (e.g. refs/heads/master), or on a reference namespace (e.g. refs/heads/*) to match any branch starting with that prefix. So a permission with refs/heads/* will match refs/heads/master and refs/heads/experimental, etc.

Reference names can also be described with a regular expression by prefixing the reference name with ^. For example ^refs/heads/[a-z]{1,8} matches all lower case branch names between 1 and 8 characters long. Within a regular expression . is a wildcard matching any character, but may be escaped as \..

References can have the current user name automatically included, creating dynamic access controls that change to match the currently logged in user. For example to provide a personal sandbox space to all developers, refs/heads/sandbox/${username}/* allowing the user joe to use refs/heads/sandbox/joe/foo.

When evaluating a reference-level access right, Gerrit will use the full set of access rights to determine if the user is allowed to perform a given action. For example, if a user is a member of Foo Leads, they are reviewing a change destined for the refs/heads/qa branch, and the following ACLs are granted on the project:
Group   Reference Name  Category  Range
Registered Users  refs/heads/*  Code Review   -1..+1
Foo Leads   refs/heads/*  Code Review   -2..+2
QA Leads  refs/heads/qa   Code Review   -2..+2

Then the effective range permitted to be used by the user is -2..+2, as the user's membership of Foo Leads effectively grant them access to the entire reference space, thanks to the wildcard.

Gerrit also supports exclusive reference-level access control.

It is possible to configure Gerrit to grant an exclusive ref level access control so that only users of a specific group can perform an operation on a project/reference pair. This is done by prefixing the reference specified with a -.

For example, if a user who is a member of Foo Leads tries to review a change destined for branch refs/heads/qa in a project, and the following ACLs are granted:
Group   Reference Name  Category  Range
Registered Users  refs/heads/*  Code Review   -1..+1
Foo Leads   refs/heads/*  Code Review   -2..+2
QA Leads  -refs/heads/qa  Code Review   -2..+2

Then this user will not have Code Review rights on that change, since there is an exclusive access right in place for the refs/heads/qa branch. This allows locking down access for a particular branch to a limited set of users, bypassing inherited rights and wildcards.

In order to grant the ability to Code Review to the members of Foo Leads, in refs/heads/qa then the following access rights would be needed:
Group   Reference Name  Category  Range
Registered Users  refs/heads/*  Code Review   -1..+1
Foo Leads   refs/heads/*  Code Review   -2..+2
QA Leads  -refs/heads/qa  Code Review   -2..+2
Foo Leads   refs/heads/qa   Code Review   -2..+2
OpenID Authentication

If the Gerrit instance is configured to use OpenID authentication, an account's effective group membership will be restricted to only the Anonymous Users and Registered Users groups, unless all of its OpenID identities match one or more of the patterns listed in the auth.trustedOpenID list from gerrit.config.
All Projects

Any access right granted to a group within -- All Projects -- is automatically inherited by every other project in the same Gerrit instance. These rights can be seen, but not modified, in any other project's Access administration tab.

Only members of the group Administrators may edit the access control list for -- All Projects --.

Ownership of this project cannot be delegated to another group. This restriction is by design. Granting ownership to another group gives nearly the same level of access as membership in Administrators does, as group members would be able to alter permissions for every managed project.
Per-Project

The per-project ACL is evaluated before the global -- All Projects -- ACL, permitting some limited override capability to project owners. This behavior is generally only useful on the Read Access category when granting -1 No Access within a specific project to deny access to a group.
Categories

Gerrit comes pre-configured with several default categories that can be granted to groups within projects, enabling functionality for that group's members.
Owner

The Owner category controls which groups can modify the project's configuration. Users who are members of an owner group can:

    *

      Change the project description
    *

      Create/delete a branch through the web UI (not SSH)
    *

      Grant/revoke any access rights, including Owner

Note that project owners implicitly have branch creation or deletion through the web UI, but not through SSH. To get SSH branch access project owners must grant an access right to a group they are a member of, just like for any other user.

Ownership over a particular branch subspace may be delegated by entering a branch pattern. To delegate control over all branches that begin with qa/ to the QA group, add Owner category for reference `refs/heads/qa/*` . Members of the QA group can further refine access, but only for references that begin with refs/heads/qa/.
Read Access

The Read Access category controls visibility to the project's changes, comments, code diffs, and Git access over SSH or HTTP. A user must have Read Access +1 in order to see a project, its changes, or any of its data.

This category has a special behavior, where the per-project ACL is evaluated before the global all projects ACL. If the per-project ACL has granted Read Access -1, and does not otherwise grant Read Access +1, then a Read Access +1 in the all projects ACL is ignored. This behavior is useful to hide a handful of projects on an otherwise public server.

For an open source, public Gerrit installation it is common to grant Read Access +1 to Anonymous Users in the -- All Projects -- ACL, enabling casual browsing of any project's changes, as well as fetching any project's repository over SSH or HTTP. New projects can be temporarily hidden from public view by granting Read Access -1 to Anonymous Users and granting Read Access +1 to the project owner's group within the per-project ACL.

For a private Gerrit installation using a trusted HTTP authentication source, granting Read Access +1 to Registered Users may be more typical, enabling read access only to those users who have been able to authenticate through the HTTP access controls. This may be suitable in a corporate deployment if the HTTP access control is already restricted to the correct set of users.


Upload Access

The Read Access +2 permits the user to upload a commit to the project's refs/for/BRANCH namespace, creating a new change for code review.

Rather than place this permission in its own category, its chained into the Read Access category as a higher level of access. A user must be able to clone or fetch the project in order to create a new commit on their local system, so in practice they must also have Read Access +1 to even develop a change. Therefore upload access implies read access by simply being a higher level of it.

For an open source, publlation, it is common to grant Read Access +1..+2 to Registered Users in the -- All Projects -- ACL. For more private installations, its common to simply grant Read Access +1..+2 to all users of a project.
Push Tag

This category permits users to push an annotated tag object over SSH into the project's repository. Typically this would be done with a command line such as:

git push ssh://USER@HOST:PORT/PROJECT tag v1.0

Tags must be annotated (created with git tag -a or git tag -s), should exist in the refs/tags/ namespace, and should be new.

This category is intended to be used to publish tags when a project reaches a stable release point worth remembering in history.

The range of values is:

    * +1 Create Signed Tag

      A new signed tag may be created. The tagger email address must be verified for the current user.

    * +2 Create Annotated Tag

      A new annotated (unsigned) tag may be created. The tagger email address must be verified for the current user.

To push tags created by users other than the current user (such as tags mirrored from an upstream project), Forge Identity +2 must be also granted in addition to Push Tag >= +1.

To push lightweight (non annotated) tags, grant Push Branch +2 Create Branch for reference name `refs/tags/*`, as lightweight tags are implemented just like branches in Git.

To delete or overwrite an existing tag, grant Push Branch +3 Force Push Branch; Delete Branch for reference name `refs/tags/*`, as deleting a tag requires the same permission as deleting a branch.
Push Branch

This category permits users to push directly into a branch over SSH, bypassing any code review process that would otherwise be used.

This category has several possible values:

    * +1 Update Branch

      Any existing branch can be fast-forwarded to a new commit. Creation of new branches is rejected. Deletion of existing branches is rejected. This is the safest mode as commits cannot be discarded.

    * +2 Create Branch

      Implies Update Branch, but also allows the creation of a new branch if the name does not not already designate an existing branch name. Like update branch, existing commits cannot be discarded.

    * +3 Force Push Branch; Delete Branch

      Implies both Update Branch and Create Branch, but also allows an existing branch to be deleted. Since a force push is effectively a delete immediately followed by a create, but performed atomically on the server and logged, this level also permits forced push updates to branches. This level may allow existing commits to be discarded from a project history.

This category is primarily useful for projects that only want to take advantage of Gerrit's access control features and do not need its code review functionality. Projects that need to require code reviews should not grant this category.
Forge Identity

Normally Gerrit requires the author and the committer identity lines in a Git commit object (or tagger line in an annotated tag) to match one of the registered email addresses of the uploading user. This permission allows users to bypass that validation, which may be necessary when mirroring changes from an upstream project.

    *

      +1 Forge Author Identity

      Permits the use of an unverified author line in commit objects. This can be useful when applying patches received by email from 3rd parties, when cherry-picking changes written by others across branches, or when amending someone else's commit to fix up a minor problem before submitting.

      By default this is granted to Registered Users in all projects, but a site administrator may disable it if verified authorship is required.
    *

      +2 Forge Committer or Tagger Identity

      Implies Forge Author Identity, but also allows the use of an unverified committer line in commit objects, or an unverified tagger line in annotated tag objects. Typically this is only required when mirroring commits from an upstream project repository.
    *

      +3 Forge Gerrit Code Review Server Identity

      Implies Forge Committer or Tagger Identity as well as Forge Author Identity, but additionally allows the use of the server's own name and email on the committer line of a new commit object. This should only be necessary when force pushing a commit history which has been rewritten by git filter-branch and that contains merge commits previously created by this Gerrit Code Review server.

Verified

The verified category can have any meaning the project desires. It was originally invented by the Android Open Source Project to mean compiles, passes basic unit tests.

The range of values is:

    *

      -1 Fails

      Tried to compile, but got a compile error, or tried to run tests, but one or more tests did not pass.

      Any -1 blocks submit.
    *

      0 No score

      Didn't try to perform the verification tasks.
    *

      +1 Verified

      Compiled (and ran tests) successfully.

      Any +1 enables submit.

In order to submit a change, the change must have a +1 Verified in this category from at least one authorized user, and no -1 Fails from an authorized user. Thus, -1 Fails can block a submit, while +1 Verified enables a submit.

If a Gerrit installation does not wish to use this category in any project, it can be deleted from the database:

DELETE FROM approval_categories      WHERE category_id = 'VRIF';
DELETE FROM approval_category_values WHERE category_id = 'VRIF';

If a Gerrit installation wants to modify the description text associated with these category values, the text can be updated in the name column of the category_id = 'VRIF' rows in the approval_category_values table.

Additional values could also be added to this category, to allow it to behave more like Code Review (below). Insert -2 and +2 value rows into the approval_category_values with category_id set to VRIF to get the same behavior.

Note

  A restart is required after making database changes. See below.

Code Review

The code review category can have any meaning the project desires. It was originally invented by the Android Open Source Project to mean I read the code and it seems reasonably correct.

The range of values is:

    * -2 Do not submit

      The code is so horribly incorrect/buggy/broken that it must not be submitted to this project, or to this branch.

      Any -2 blocks submit.

    * -1 I would prefer that you didn't submit this

      The code doesn't look right, or could be done differently, but the reviewer is willing to live with it as-is if another reviewer accepts it, perhaps because it is better than what is currently in the project. Often this is also used by contributors who don't like the change, but also aren't responsible for the project long-term and thus don't have final say on change submission.

      Does not block submit.

    * 0 No score

      Didn't try to perform the code review task, or glanced over it but don't have an informed opinion yet.

    * +1 Looks good to me, but someone else must approve

      The code looks right to this reviewer, but the reviewer doesn't have access to the +2 value for this category. Often this is used by contributors to a project who were able to review the change and like what it is doing, but don't have final approval over what gets submitted.

    * +2 Looks good to me, approved

      Basically the same as +1, but for those who have final say over how the project will develop.

      Any +2 enables submit.

In order to submit a change, the change must have a +2 Looks good to me, approved in this category from at least one authorized user, and no -2 Do not submit from an authorized user. Thus -2 can block a submit, while +2 can enable it.

If a Gerrit installation does not wish to use this category in any project, it can be deleted from the database:

DELETE FROM approval_categories      WHERE category_id = 'CRVW';
DELETE FROM approval_category_values WHERE category_id = 'CRVW';

If a Gerrit installation wants to modify the description text associated with these category values, the text can be updated in the name column of the category_id = 'CRVW' rows in the approval_categogories table. The default values VRIF and CVRF used for the categories described above are simply that, defaults, and have no special meaning to Gerrit. The other standard category_id values like OWN, READ, SUBM, pTAG and pHD have special meaning and should not be modified or reused.

The position column of approval_categories controls which column of the Approvals table the category appears in, providing some layout control to the administrator.

All MaxWithBlock categories must have at least one positive value in the approval_category_values table, or else submit will never be enabled.

To permit blocking submits, ensure a negative value is defined for your new category. If you do not wish to have a blocking submit level for your category, do not define values less than 0.

Keep in mind that category definitions are currently global to the entire Gerrit instance, and affect all projects hosted on it. Any change to a category definition affects everyone.

For example, to define a new 3-valued category that behaves exactly like Verified, but has different names/labels:

::

  INSERT INTO approval_categories
    (name
    ,position
    ,function_name
    ,category_id)

  VALUES
    ('Copyright Check'
    ,3
    'MaxWithBlock'
    ,'copy');

  INSERT INTO approval_category_values
    (category_id,value,name)

  VALUES
    ('copy', -1, 'Do not have copyright');

  INSERT INTO approval_category_values
    (category_id,value,name)

  VALUES
    ('copy', 0, 'No score');

  INSERT INTO approval_category_values
    (category_id,value,name)

  VALUES
    ('copy', 1, 'Copyright clear');

The new column will appear at the end of the table (in position 3), and -1 Do not have copyright will block submit, while +1 Copyright clear is required to enable submit.

Note

  Restart the Gerrit web application and reload all browsers after making any database changes to approval categories. Browsers are sent the list of known categories when they first visit the site, and don't notice changes until the page is closed and opened again, or is reloaded.

Part of Gerrit Code Review
Version 2.1.5.1
Last updated 24-Aug-2010 11:06:24 PDT




项目的创建
-----------

创建项目
++++++++++

用 Web 界面创建

Create Through SSH

Creating a new repository over SSH is perhaps the easiest way to configure a new project:

::

  $ ssh -p 29418 review.example.com gerrit create-project --name new/project

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


从已有版本库创建新项目
++++++++++++++++++++++++

All Git repositories under gerrit.basePath must be registered in the Gerrit database in order to be accessed through SSH, or through the web interface.

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

::

  INSERT INTO projects
  (use_contributor_agreements
   ,submit_type
   ,name)
  VALUES
  ('N'
  ,'M'
  ,'new/project');

注册分支
++++++++++++

Branches can be created over the SSH port by any git push client, if the user has been granted the Push Branch > Create Branch (or higher) access right.

Additional branches can also be created through the web UI, assuming at least one commit already exists in the project repository. A project owner can create additional branches under Admin > Projects > Branches. Enter the new branch name, and the starting Git revision. Branch names that don’t start with refs/ will automatically have refs/heads/ prefixed to ensure they are a standard Git branch name. Almost any valid SHA-1 expression can be used to specify the starting revision, so long as it resolves to a commit object. Abbreviated SHA-1s are not supported.


版本库数据库的初始化
----------------------

如何用 git push 导入项目内容。而不是要对提交一一审核？

Go into the '-- All Projects ---' entry under Admin>Projects and grant the
following:

  Category: Push Branch
  Group: Administrators
  Min: +1
  Max: +3

  Category: Push Annotated Tag
  Group: Administrators
  Min: +1
  Max: +3

After doing those two grants, you can then push the branches directly using
git push, e.g.:

  git push --all ssh://you@gerrit:29418/project.git

Once all projects are pushed, you can delete the two grants you had given
Administrators.  The advantage of pushing through Gerrit's SSHD like this is
the branches table will be automatically populated in the database, so
unlike what Simon Wilkinson describes, you won't need to manually insert
each branch for each project. 

No, use:

  git push ssh://user@gerrit:29418/project1 HEAD:refs/heads/master

since you want to directly push into the branch, rather than create code
reviews.  Pushing to prefix "refs/for/" creates code reviews which must be
approved and then submitted.  Pushing to "refs/heads/" bypasses review
entirely, and just enters the commits directly into the branch.  The latter
path does not check committer identity, and is designed for the case you are
trying to work through right now.  :-) 


审核工作流管理
--------------------

Documentation/user-upload.html

Gerrit supports three methods of uploading changes:

    *

      Use repo upload, to create changes for review
    *

      Use git push, to create changes for review
    *

      Use git push, and bypass code review


Gerrit 下开发者的工作方式
--------------------------

本地版本库的钩子设置

通过钩子，提交自动在提交说明中生成 Change-id 。这个 Change-id 被用于确定变更集编号。


参见： Documentation/user-changeid.html

Gerrit 下审核者的工作方式
--------------------------

Gerrit 下确认者的工作方式
--------------------------





版本库复制
-----------
创建 '$site_path'/replication.config 文件

[remote "host-one"]
  url = gerrit@host-one.example.com:/some/path/${name}.git

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
  
The `*.html` files must be valid XHTML, with one root element, typically a single <div> tag. The server parses it as XML, and then inserts the root element into the host page. If a file has more than one root level element, Gerrit will not start.

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



