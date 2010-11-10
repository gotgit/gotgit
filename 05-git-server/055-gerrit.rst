Gerrit 代码审核服务器
=====================

谷歌 Android 开源项目在 Git 的使用上有两个重要的创新，一个是为多版本库协同而引入的 repo，这在之前我们已经详细讨论过。另外一个重要的创新就是 Gerrit —— 代码审核服务器。Gerrit 为 Git 引入的代码审核是强制性的，就是说除非特别的授权设置，向 Git 版本库的推送（Push）必须要经过 Gerrit 服务器，修订必须经过代码审核的一套工作流之后，才可能经批准并纳入正式代码库中。

首先贡献者的代码通过 git 命令（或 repo 封装）推送到 Gerrit 管理下的 Git 版本库，推送的提交转化为一个一个的代码审核任务，审核任务可以通过 `refs/changes/` 下的引用访问到。代码审核者可以通过 Web 界面查看审核任务、代码变更，通过 Web 界面做出通过代码审核或者打回等决定。测试者也可以通过 `refs/changes/` 之下的引用获取（fetch）修订对其进行测试，如果测试通过就可以将该评审任务设置为校验通过（verified）。最后经过了审核和校验的修订可以通过 Gerrit 界面中提交动作合并到版本库对应的分支中。

在 Android 项目的网站的代码贡献流程图更为详细的介绍了 Gerrit 代码审核服务器的工作流程。

  .. figure:: images/gerrit-workflow.png
     :scale: 80

     Gerrit 代码审核工作流

Gerrit 的实现原理
-----------------

**SSH 协议的 Git 服务器**

Gerrit 本身基于 SSH 协议实现了一套 Git 服务器，这样就可以对 Git 数据推送进行更为精确的控制，为强制审核的实现建立了基础。

Gerrit 提供的 Git 服务的端口并非标准的 22 端口，缺省是 29418 端口。可以访问 Gerrit 的 Web 界面得到这个端口。对 Android 项目的代码审核服务器，访问 https://review.source.android.com/ssh_info 就可以查看到 Git 服务的服务器域名和开放的端口。下面我们用 curl 命令查看网页的输出。

::

  $ curl -L -k http://review.source.android.com/ssh_info
  review.source.android.com 29418

**特殊引用 refs/for/<branch-name> 和 refs/changes/nn/<task-id>/m**

Gerrit 的 Git 服务器，禁止用户向 `refs/heads` 命名空间下的引用执行推送（除非特别的授权），即不允许用户直接向分支进行提交。为了让开发者能够向 Git 服务器提交修订，Gerrit 的 Git 服务器只允许用户向特殊的引用 `refs/for/<branch-name>` 下执行推送，其中 `<branch-name>` 即为开发者的工作分支。向 `refs/for/<branch-name>` 命名空间下推送并不会在其中创建引用，而是为新的提交分配一个 ID，称为 task-id ，并为该 task-id 的访问建立如下格式的引用 `refs/changes/nn/<task-id>/m` ，其中：

* task-id 为 Gerrit 为评审任务顺序分配的全局唯一的号码。
* nn 为 task-id 的后两位数，位数不足用零补齐。即 nn 为 task-id 除以 100 的余数。
* m 为修订号，该 task-id 的首次提交修订号为 1，如果该修订被打回，重新提交修订号会自增。

**Git 库的钩子脚本 hooks/commit-msg**

为了保证已经提交审核的修订通过审核入库后，被别的分支 cherry-pick 后再推送至服务器时不会产生新的重复的评审任务，Gerrit 设计了一套方法，即要求每个提交包含唯一的 Change-Id，这个 Change-Id 因为出现在日志中，当执行 cherry-pick 时也会保持，Gerrit 一旦发现新的提交包含了已经处理过的 `Change-Id` ，就不再为该修订创建新的评审任务和 task-id，而直接将提交入库。

为了实现 Git 提交中包含唯一的 Change-Id，Gerrit 提供了一个钩子脚本，放在开发者本地 Git 库中（hooks/commit-msg）。这个钩子脚本在用户提交时自动在提交说明中创建以 "Change-Id: " 及包含 `git hash-object` 命令产生的哈希值的唯一标识。当 Gerrit 获取到用户向 `refs/for/<branch-name>` 推送的提交中包含 "Change-Id: I..." 的变更 ID，如果该 Change-Id 之前没有见过，会创建一个新的评审任务并分配新的 task-id，并在 Gerrit 的数据库中保存 Change-Id 和 Task-Id 的关联。

如果当用户的提交因为某种原因被要求打回重做，开发者修改之后重新推送到 Gerrit 时就要注意在提交说明中使用相同的 “Change-Id” （使用 --amend 提交即可保持提交说明），以免创建新的评审任务，还要在推送时将当前分支推送到 `refs/changes/nn/task-id/m` 中。其中 `nn` 和 `task-id` 和之前提交的评审任务的修订相同，m 则要人工选择一个新的修订号。

以上说起来很复杂，但是在实际操作中只要使用 repo 这一工具，就相对容易多了。

**其余一切交给 Web**

Gerrit 另外一个重要的组件就是 Web 服务器，通过 Web 服务器实现对整个评审工作流的控制。关于 Gerrit 工作流，参见在本章开头出现的 Gerrit 工作流程图。

感受一下 Gerrit 的魅力？直接访问 Android 项目的 Gerrit 网站： https://review.source.android.com/ 。

  .. figure:: images/android-gerrit-merged.png
     :scale: 70

     Android 项目代码审核网站

Android 项目的评审网站，匿名即可访问。点击菜单中的 “Merged” 显示了已经通过评审合并到代码库中的审核任务。下面的一个界面就是 Andorid 一个已经合并到代码库中的历史评审任务。

  .. figure:: images/android-gerrit-16993.png
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

Android Review 服务器
----------------------




Gerrit 服务器的出现不是偶然的，


Gerrit 名字的由来。

Gerrit Code Review started as a simple set of patches to Rietveld, and was originally built to service AOSP. This quickly turned into a fork as we added access control features that Guido van Rossum did not want to see complicating the Rietveld code base. As the functionality and code were starting to become drastically different, a different name was needed. Gerrit calls back to the original namesake of Rietveld, Gerrit Rietveld, a Dutch architect.

Gerrit2 is a complete rewrite of the Gerrit fork, completely changing the implementation from Python on Google App Engine, to Java on a J2EE servlet container and a SQL database. 

Gerrit 是由 Java 开发的，封装为一个 jar 包: gerrit.jar 。提供 Git 代码审核功能，包括一个代码审核的 Web 界面，以及一个重新实现的 Git 服务器，以便强制 Git 必须使用 Gerrit 的代码审核工作流，即：每一个 Git 提交先转换为一个代码审核任务，经过检验和审核后，授权用户可以直接通过 Gerrit 的 Web 界面将审核通过的代码合并到Git 版本库中。

Android Review 服务器就是一个最典型的 Gerrit 应用，我们可以通过它一窥 Gerrit 的风采。

Gerrit 的 Web 服务
+++++++++++++++++++

Gerrit 的 Web 界面提供了 Git 代码审核功能，此外还包括与此相关的用户注册，授权管理，项目管理等功能。


Gerrit 的 SSH 服务
+++++++++++++++++++

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


架设 Gerrit 的服务器
---------------------

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

数据库操作
-----------

我们缺省以内置 H2 数据库方式进行部署，操作 H2 数据库 Gerrit 提供了两种方法。

通过 ssh 命令可以修改运行中的 Gerrit 数据库。因为是跨网络使用，需要进行公钥认证，只有管理员才有权限执行。

::

  $ ssh -p 29418 review.example.com gerrit gsql


而下面的命令，只能在 Gerrit 服务器停止的情况下使用，修改 Gerrit 数据库。因为是在服务器端直接操作数据库文件，因此无须认证。

::

  $ java -jar gerrit.war gsql

当连接上数据库管理接口后，便出现 "gerrit>" 提示符，在该提示符下可以输入 SQL 命令。

::

  gerrit> show databases;
   SCHEMA_NAME
   ------------------
   PUBLIC
   INFORMATION_SCHEMA
  (2 rows; 2 ms)

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

  gerrit> select * from system_config;
   REGISTER_EMAIL_PRIVATE_KEY           | SITE_PATH                | ADMIN_GROUP_ID | ANONYMOUS_GROUP_ID | REGISTERED_GROUP_ID | WILD_PROJECT_NAME  | BATCH_USERS_GROUP_ID | SINGLETON
   -------------------------------------+--------------------------+----------------+--------------------+---------------------+--------------------+----------------------+----------
   fsHu/uJUqI6gGCZLzbuE+cnK1ySB7sej6/E= | /home/gerrit/review_site | 1              | 2                  | 3                   | -- All Projects -- | 4                    | X
  (1 row; 3 ms)

  gerrit> select * from projects;
   DESCRIPTION                            | USE_CONTRIBUTOR_AGREEMENTS | USE_SIGNED_OFF_BY | SUBMIT_TYPE | PARENT_NAME | NAME
   ---------------------------------------+----------------------------+-------------------+-------------+-------------+-------------------
   Rights inherited by all other projects | N                          | N                 | M           | NULL        | -- All Projects --
   测试项目                                   | N                          | N                 | M           | NULL        | new/project
  (2 rows; 2 ms)


项目管理
-----------

All Git repositories under gerrit.basePath must be registered in the Gerrit database in order to be accessed through SSH, or through the web interface.


Create Through SSH

Creating a new repository over SSH is perhaps the easiest way to configure a new project:

::

  $ ssh -p 29418 review.example.com gerrit create-project --name new/project

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

::

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

版本库管理
------------

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

ACL
-----

上传改动
---------

Documentation/user-upload.html

Gerrit supports three methods of uploading changes:

    *

      Use repo upload, to create changes for review
    *

      Use git push, to create changes for review
    *

      Use git push, and bypass code review

Change-id
------------

通过钩子，提交自动在提交说明中生成 Change-id 。这个 Change-id 被用于确定变更集编号。


参见： Documentation/user-changeid.html


ACL
-----

http://gerrit.googlecode.com/svn/documentation/2.1.5/access-control.html#category_FORG

Gerrit Code Review - Access Controls
version 2.1.5
Table of Contents
System Groups
Administrators
Anonymous Users
Registered Users
Account Groups
Project Access Control Lists
OpenID Authentication
All Projects
Per-Project
Categories
Owner
Read Access
Upload Access
Push Tag
Push Branch
Forge Identity
Verified
Code Review
Submit
Your Category Here

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

Ownership over a particular branch subspace may be delegated by entering a branch pattern. To delegate control over all branches that begin with qa/ to the QA group, add Owner category for reference refs/heads/qa/*. Members of the QA group can further refine access, but only for references that begin with refs/heads/qa/.
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

    *

      +1 Create Signed Tag

      A new signed tag may be created. The tagger email address must be verified for the current user.
    *

      +2 Create Annotated Tag

      A new annotated (unsigned) tag may be created. The tagger email address must be verified for the current user.

To push tags created by users other than the current user (such as tags mirrored from an upstream project), Forge Identity +2 must be also granted in addition to Push Tag >= +1.

To push lightweight (non annotated) tags, grant Push Branch +2 Create Branch for reference name refs/tags/*, as lightweight tags are implemented just like branches in Git.

To delete or overwrite an existing tag, grant Push Branch +3 Force Push Branch; Delete Branch for reference name refs/tags/*, as deleting a tag requires the same permission as deleting a branch.
Push Branch

This category permits users to push directly into a branch over SSH, bypassing any code review process that would otherwise be used.

This category has several possible values:

    *

      +1 Update Branch

      Any existing branch can be fast-forwarded to a new commit. Creation of new branches is rejected. Deletion of existing branches is rejected. This is the safest mode as commits cannot be discarded.
    *

      +2 Create Branch

      Implies Update Branch, but also allows the creation of a new branch if the name does not not already designate an existing branch name. Like update branch, existing commits cannot be discarded.
    *

      +3 Force Push Branch; Delete Branch

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

    *

      -2 Do not submit

      The code is so horribly incorrect/buggy/broken that it must not be submitted to this project, or to this branch.

      Any -2 blocks submit.
    *

      -1 I would prefer that you didn't submit this

      The code doesn't look right, or could be done differently, but the reviewer is willing to live with it as-is if another reviewer accepts it, perhaps because it is better than what is currently in the project. Often this is also used by contributors who don't like the change, but also aren't responsible for the project long-term and thus don't have final say on change submission.

      Does not block submit.
    *

      0 No score

      Didn't try to perform the code review task, or glanced over it but don't have an informed opinion yet.
    *

      +1 Looks good to me, but someone else must approve

      The code looks right to this reviewer, but the reviewer doesn't have access to the +2 value for this category. Often this is used by contributors to a project who were able to review the change and like what it is doing, but don't have final approval over what gets submitted.
    *

      +2 Looks good to me, approved

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
Version 2.1.5
Last updated 24-Aug-2010 11:06:24 PDT



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

