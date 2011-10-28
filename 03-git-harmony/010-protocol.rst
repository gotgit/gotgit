Git协议与工作协同
******************

要想团队协作使用Git，就需要用到Git协议。

Git 支持的协议
===================

首先来看看数据交换需要使用的协议。

Git 提供了丰富的协议支持，包括：SSH、GIT、HTTP、HTTPS、FTP、FTPS、RSYNC 及前面已经看到的本地协议等。各种不同协议的URL写法如表15-1所示。

表 15-1：Git支持的协议一览表

+---------------+------------------------------------------------------+--------------------------------------------------------------+
| 协议名称      | 语法格式                                             | 说明                                                         |
+===============+======================================================+==============================================================+
| SSH 协议（1） | `ssh://[user@]example.com[:port]/path/to/repo.git/`  | 可在URL中设置用户名和端口。                                  |
|               |                                                      | 默认端口 22。                                                |
+---------------+------------------------------------------------------+--------------------------------------------------------------+
| SSH 协议（2） | `[user@]example.com:path/to/repo.git/`               | 更为精简的 SCP 格式表示法，更简洁。                          |
|               |                                                      | 但是非默认端口需要通过其他方式（如地址别名方式）设定。       |
+---------------+------------------------------------------------------+--------------------------------------------------------------+
| GIT 协议      | `git://example.com[:port]/path/to/repo.git/`         | 最常用的只读协议。                                           |
+---------------+------------------------------------------------------+--------------------------------------------------------------+
| HTTP[S] 协议  | `http[s]://example.com[:port]/path/to/repo.git/`     | 兼有智能协议和哑协议。                                       |
+---------------+------------------------------------------------------+--------------------------------------------------------------+
| FTP[S] 协议   | `ftp[s]://example.com[:port]/path/to/repo.git/`      | 哑协议。                                                     |
+---------------+------------------------------------------------------+--------------------------------------------------------------+
| RSYNC 协议    | `rsync://example.com/path/to/repo.git/`              | 哑协议。                                                     |
+---------------+------------------------------------------------------+--------------------------------------------------------------+
| 本地协议（1） | `file:///path/to/repo.git`                           |                                                              |
+---------------+------------------------------------------------------+--------------------------------------------------------------+
| 本地协议（2） | :file:`/path/to/repo.git`                                  | 和 `file://` 格式的本地协议类似。但有细微差别。              |
|               |                                                      | 例如克隆时不支持浅克隆，且采用直接的硬连接实现克隆。         |
+---------------+------------------------------------------------------+--------------------------------------------------------------+

上面介绍的各种协议如果按照其聪明程度划分，可分为两类：智能协议和哑协议。

**1. 智能协议**

在通讯时使用智能协议，会在两个通讯的版本库的各自一端分别打开两个程序进行数据交换。使用智能协议最直观的印象就是在数据传输过程中会有清晰的进度显示，而且因为是按需传输所以传输量更小，速度更快。图 15-1 显示的就是在执行 PULL 和 PUSH 两个最常用的操作时，两个版本库各自启动辅助程序的情况。

.. figure:: /images/git-harmony/git-smart-protocol.png
   :scale: 80

   图 15-1：Git智能协议通讯示意图

上述协议中 SSH、GIT及本地协议（file://）属于智能协议。HTTP 协议需要特殊的配置（用 git-http-backend 配置 CGI），并且客户端需要使用 Git 1.6.6 或更高的版本才能够使用智能协议。

**2. 哑协议**

和智能协议相对的是哑协议。使用哑协议在访问远程版本库的时候，远程版本库不会运行辅助程序，而是完全依靠客户端去主动“发现”。客户端需要访问文件 `.git/info/refs` 获取当前版本库的引用列表，并根据引用对应的提交ID直接访问对象库目录下的文件。如果对象文件被打包而不以松散对象形式存在，则 Git 客户端还要去访问文件 `.git/objects/info/packs` 以获得打包文件列表，并据此读取完整的打包文件，从打包文件中获取对象。由此可见哑协议的效率非常之低，甚至会因为要获取一个对象而去访问整个 pack 包。

使用哑协议最直观的感受是：传输速度非常慢，而且传输进度不可见，不知道什么时候才能够完成数据传输。上述协议中，像 FTP、RSYNC 都是哑协议，对于没有通过 git-http-backend 或类似CGI程序配置的 HTTP 服务器提供的也是哑协议。因为哑协议需要索引文件 `.git/info/refs` 和 `.git/objects/info/packs` 以获取引用和包列表，因此要在版本库的钩子脚本 `post-update` 中设置运行 `git update-server-info` 以确保及时更新哑协议需要的索引文件。不过如果不使用哑协议，运行 `git update-server-info` 就没有什么必要了。

以 Git 项目本身为例，看看如何使用不同的协议地址进行版本库克隆。

* GIT 协议（智能协议）：

  ::

    git clone git://git.kernel.org/pub/scm/git/git.git

* HTTP(S) 哑协议：

  ::

    git clone http://www.kernel.org/pub/scm/git/git.git

* HTTP(S) 智能协议：

  使用 Git 1.6.6 或更高版本访问。

  ::

    git clone https://github.com/git/git.git

多用户协同的本地模拟
====================

在本篇（“Git和声”）的学习过程中，需要一个能够提供多人访问的版本库，显然要找到一个公共服务器，并且能让所有人都尽情发挥不太容易，但幸好可以使用本地协议来模拟。在后面的内容中，会经常使用本地协议地址 `file:///path/to/repos/<project>.git` 来代表对某一公共版本库的访问，您可以把 `file://` 格式的URL（比直接使用路径方式更逼真）想象为 `git://` 或者 `http://` 格式，并且想象它是在一台远程的服务器上，而非本机。

同样的，为了模拟多人的操作，也不再使用 :file:`/path/to/my/workspace` 作为工作区，而是分别使用 :file:`/path/to/user1/workspace` 和 :file:`/path/to/user2/workspace` 等工作区来代表不同用户的工作环境。同样想象一下 :file:`/path/to/user1/` 和 :file:`/path/to/user2/` 是在不同的主机上，并由不同的用户进行操作。

下面就来演示一个共享版本库的搭建过程，以及两个用户 user1 和 user2 在各自的工作区中如何工作并进行数据交换的，具体过程如下。

* 创建一个共享的版本库，于 :file:`/path/to/repos/shared.git` 。

  别忘了在第2篇的第13章“Git克隆”一章中介绍的，以裸版本库方式创建。

  ::

    $ git init --bare /path/to/repos/shared.git
    Initialized empty Git repository in /path/to/repos/shared.git/

* 用户 user1 克隆版本库。

  克隆完成之后，在版本库级别设置 `user.name` 和 `user.email` 环境，以便和全局设置区分开，因为我们的模拟环境中所有用户都共享同一全局设置和系统设置。克隆及设置过程如下：

  ::

    $ cd /path/to/user1/workspace
    $ git clone file:///path/to/repos/shared.git project
    Cloning into project...
    warning: You appear to have cloned an empty repository.
    $ cd project
    $ git config user.name user1
    $ git config user.email user1@sun.ossxp.com

* 用户 user1 创建初始数据并提交。

  ::

    $ echo Hello. > README
    $ git add README
    $ git commit -m "initial commit."
    [master (root-commit) 5174bf3] initial commit.
     1 files changed, 1 insertions(+), 0 deletions(-)
     create mode 100644 README

* 用户 user1 将本地版本库的提交推送到上游。

  在下面的推送指令中使用了 origin 别名，其实际指向就是 `file:///path/to/repos/shared.git` 。可以从 `.git/config` 配置文件中看到是如何实现对 origin 远程版本库注册的。关于远程版本库的内容要在第19章介绍。
  ::

    $ git push origin master
    Counting objects: 3, done.
    Writing objects: 100% (3/3), 210 bytes, done.
    Total 3 (delta 0), reused 0 (delta 0)
    Unpacking objects: 100% (3/3), done.
    To file:///path/to/repos/shared.git
     * [new branch]      master -> master

* 用户 user2 克隆版本库。

  ::

    $ cd /path/to/user2/workspace
    $ git clone file:///path/to/repos/shared.git project
    Cloning into project...
    remote: Counting objects: 3, done.
    remote: Total 3 (delta 0), reused 0 (delta 0)
    Receiving objects: 100% (3/3), done.

* 同样在 user2 的本地版本库中，设置 `user.name` 和 `user.email` 环境，以区别全局环境设置。

  ::

    $ cd /path/to/user2/workspace/project
    $ git config user.name user2
    $ git config user.email user2@moon.ossxp.com

* 用户 user2 的本地版本库现在拥有和 user1 用户同样的提交。
  
  ::

    $ git log
    commit 5174bf33ab31a3999a6242fdcb1ec237e8f3f91a
    Author: user1 <user1@sun.ossxp.com>
    Date:   Sun Dec 19 15:52:29 2010 +0800

        initial commit.

强制非快进式推送
=================

现在用户 user1 和 user2 的工作区是相同的。思考一个问题：如果两人各自在本地版本库中进行独立的提交，然后再分别向共享版本库推送，会互相覆盖么？为了回答这个问题，进行下面的实践。

首先，用户 user1 先在本地版本库中进行提交，然后将本地的提交推送到“远程”共享版本库中。操作步骤如下：

* 用户 user1 创建 `team/user1.txt` 文件。

  假设这个项目约定：每个开发者在 `team` 目录下写一个自述文件。于是用户 user1 创建文件 `team/user1.txt` 。

  ::

    $ cd /path/to/user1/workspace/project/
    $ mkdir team
    $ echo "I'm user1." > team/user1.txt
    $ git add team
    $ git commit -m "user1's profile."
    [master b4f3ae0] user1's profile.
     1 files changed, 1 insertions(+), 0 deletions(-)
     create mode 100644 team/user1.txt

* 用户 user1 将本地提交推送到服务器上。

  ::

    $ git push
    Counting objects: 5, done.
    Delta compression using up to 2 threads.
    Compressing objects: 100% (2/2), done.
    Writing objects: 100% (4/4), 327 bytes, done.
    Total 4 (delta 0), reused 0 (delta 0)
    Unpacking objects: 100% (4/4), done.
    To file:///path/to/repos/shared.git
       5174bf3..b4f3ae0  master -> master

* 当前 user1 版本库中的日志

  ::

    $ git log --oneline --graph
    * b4f3ae0 user1's profile.
    * 5174bf3 initial commit.

通过上面的操作步骤，可以看到用户 user1 成功的更新了“远程”共享版本库。如果用户 user2在不知道用户 user1 所做的上述操作的前提下，在基于“远程”版本库旧的数据同步过来的本地版本库中进行改动，然后用户 user2 向“远程”共享版本库推送会有什么结果呢？用下面的操作验证一下。

* 用户 user2 创建 `team/user2.txt` 文件。

  ::

    $ cd /path/to/user2/workspace/project/
    $ mkdir team
    $ echo "I'm user1?" > team/user2.txt
    $ git add team
    $ git commit -m "user2's profile."
    [master 8409e4c] user2's profile.
     1 files changed, 1 insertions(+), 0 deletions(-)
     create mode 100644 team/user2.txt

* 用户 user2 将本地提交推送到服务器时出错。

  ::

    $ git push
    To file:///path/to/repos/shared.git
     ! [rejected]        master -> master (non-fast-forward)
    error: failed to push some refs to 'file:///path/to/repos/shared.git'
    To prevent you from losing history, non-fast-forward updates were rejected
    Merge the remote changes (e.g. 'git pull') before pushing again.  See the
    'Note about fast-forwards' section of 'git push --help' for details.

* 用户 user2 的推送失败了。错误日志翻译如下：

  ::

    到版本库 file:///path/to/repos/shared.git
     ! [被拒绝]        master -> master (非快进)
    错误：部分引用向 'file:///path/to/repos/shared.git' 推送失败
    为防止您丢失历史，非快进式更新被拒绝。
    在推送前请先合并远程改动，例如执行 'git pull'。

推送失败了。但这不是坏事情，反倒是一件好事情，因为这避免了用户提交的相互覆盖。Git 通过对推送操作是否是“快进式”操作进行检查，从而保证用户的提交不会相互覆盖。一般情况下，推送只允许“快进式”推送。所谓快进式推送，就是要推送的本地版本库的提交是建立在远程版本库相应分支的现有提交基础上的，即远程版本库相应分支的最新提交是本地版本库最新提交的祖先提交。但现在用户 user2 执行的推送并非如此，是一个非快进式的推送。

* 此时用户 user2 本地版本库的最新提交及其历史提交可以用 `git rev-list` 命令显示，如下所示：

  ::

    $ git rev-list HEAD
    8409e4c72388a18ea89eecb86d68384212c5233f
    5174bf33ab31a3999a6242fdcb1ec237e8f3f91a

* 用 `git ls-remote` 命令显示远程版本库的引用对应的 SHA1 哈希值，会发现远程版本库所包含的最新提交的 SHA1 哈希值是b4f3ae0...，而不是本地最新提交的祖先提交。

  ::

    $ git ls-remote origin
    b4f3ae0fcadce8c343f3cdc8a69c33cc98c98dfd        HEAD
    b4f3ae0fcadce8c343f3cdc8a69c33cc98c98dfd        refs/heads/master

实际上当用户 user2 执行推送的时候，Git就是利用类似方法判断出当前的推送不是一个快进式推送，于是产生警告并终止。

那么如何才能成功推送呢？一个不见得正确的解决方案称为： **强制推送** 。

在推送命令的后面使用 `-f` 参数可以进行强制推送，即使是非快进式的推送也会成功执行。用户 user2 执行强制推送，会强制涮新服务器中的版本。

::

  $ git push -f
  Counting objects: 7, done.
  Delta compression using up to 2 threads.
  Compressing objects: 100% (3/3), done.
  Writing objects: 100% (7/7), 503 bytes, done.
  Total 7 (delta 0), reused 3 (delta 0)
  Unpacking objects: 100% (7/7), done.
  To file:///path/to/repos/shared.git
   + b4f3ae0...8409e4c master -> master (forced update)

注意到了么，在强制推送的最后一行输出中显示了“强制更新（forced update）”字样。这样用户 user1 向版本库推送的提交由于用户 user2 的强制推送被覆盖了。实际上在这种情况下user1 也可以强制的推送，从而用自己（user1）的提交再去覆盖用户 user2 的提交。这样的工作模式不是协同，而是战争！

**合理使用非快进式推送**

在上面用户 user2 使用非快进式推送强制更新版本库，实际上是危险和错误的。滥用非快进式推送可能造成提交覆盖大战（战争是霸权的滥用）。正确地使用非快进式推送，应该是在不会造成提交覆盖“战争”的前提下，对历史提交进行修补。

下面的操作也许是一个使用非快进式推送更好的例子。

* 用户 user2 改正之前错误的录入。

  细心的读者可能已经发现，用户 user2 在创建的个人描述文件中把自己的名字写错了。假设用户 user2 在刚刚完成向服务器的推送操作后也发现了这个错误，于是 user2 进行了下面的更改。

  ::

    $ echo "I'm user2." > team/user2.txt
    $ git diff
    diff --git a/team/user2.txt b/team/user2.txt
    index 27268e2..2dcb7b6 100644
    --- a/team/user2.txt
    +++ b/team/user2.txt
    @@ -1 +1 @@
    -I'm user1?
    +I'm user2.

* 然后用户 user2 将修改好的文件提交到本地版本库中。

  采用直接提交还是使用修补式提交，这是一个问题。因为前次提交已经被推送到共享版本库中，如果采用修补提交会造成前一次提交被新提交抹掉，从而在下次推送操作时造成非快进式推送。这时用户 user2 就要评估“战争”的风险：“我刚刚推送的提交，有没有可能被其他人获取了（通过 `git pull` 、`git fetch` 或 `git clone` 操作）？”如果确认不会有他人获取，例如现在公司里只有user2自己一个人在加班，那么可以放心的进行修补操作。

  ::

    $ git add -u
    $ git commit --amend -m "user2's profile."    
    [master 6b1a7a0] user2's profile.
     1 files changed, 1 insertions(+), 0 deletions(-)
     create mode 100644 team/user2.txt

* 采用强制推送，更新远程共享版本库中的提交。这个操作越早越好，在他人还没有来得及和服务器同步前将修补提交强制更新到服务器上。

  ::

    $ git push -f
    Counting objects: 5, done.
    Delta compression using up to 2 threads.
    Compressing objects: 100% (2/2), done.
    Writing objects: 100% (4/4), 331 bytes, done.
    Total 4 (delta 0), reused 0 (delta 0)
    Unpacking objects: 100% (4/4), done.
    To file:///path/to/repos/shared.git
     + 8409e4c...6b1a7a0 master -> master (forced update)

合并后推送
===============

理性的工作协同要避免非快进式推送。一旦向服务器推送后，如果发现错误，不要使用会更改历史的操作（变基、修补提交），而是采用不会改变历史提交的反转提交等操作。

如果在向服务器推送过程中遇到了非快进式推送的警告，应该进行如下操作才更为理性：执行 `git pull` 获取服务器端最新的提交并和本地提交进行合并，合并成功后再向服务器提交。

例如用户 user1 在推送时遇到了非快进式推送错误，可以通过如下操作将本地版本库的修改和远程版本库的最新提交进行合并。

* 用户 user1 发现推送遇到了非快进式推送。

  ::

    $ cd /path/to/user1/workspace/project/
    $ git push
    To file:///path/to/repos/shared.git
     ! [rejected]        master -> master (non-fast-forward)
    error: failed to push some refs to 'file:///path/to/repos/shared.git'
    To prevent you from losing history, non-fast-forward updates were rejected
    Merge the remote changes (e.g. 'git pull') before pushing again.  See the
    'Note about fast-forwards' section of 'git push --help' for details.

* 执行 `git pull` 实现获取远程版本库的最新提交，以及实现获取到的远程版本库提交与本地提交的合并。

  ::

    $ git pull
    remote: Counting objects: 5, done.
    remote: Compressing objects: 100% (2/2), done.
    remote: Total 4 (delta 0), reused 0 (delta 0)
    Unpacking objects: 100% (4/4), done.
    From file:///path/to/repos/shared
     + b4f3ae0...6b1a7a0 master     -> origin/master  (forced update)
    Merge made by recursive.
     team/user2.txt |    1 +
     1 files changed, 1 insertions(+), 0 deletions(-)
     create mode 100644 team/user2.txt

* 合并之后，看看版本库的提交关系图。

  合并之后远程服务器中的最新提交 `6b1a7a0` 成为当前最新提交（合并提交）的父提交。如果再推送，则不再是非快进式的了。

  ::

    $ git log --graph --oneline
    *   bccc620 Merge branch 'master' of file:///path/to/repos/shared
    |\  
    | * 6b1a7a0 user2's profile.
    * | b4f3ae0 user1's profile.
    |/  
    * 5174bf3 initial commit.

* 执行推送，成功完成到远程版本库的推送。

  ::

    $ git push
    Counting objects: 10, done.
    Delta compression using up to 2 threads.
    Compressing objects: 100% (5/5), done.
    Writing objects: 100% (7/7), 686 bytes, done.
    Total 7 (delta 0), reused 0 (delta 0)
    Unpacking objects: 100% (7/7), done.
    To file:///path/to/repos/shared.git
       6b1a7a0..bccc620  master -> master

禁止非快进式推送
==================

非快进式推送如果被滥用，会成为项目的灾难：

* 团队成员之间的提交战争取代了本应的相互协作。
* 造成不必要的冲突，为他人造成麻烦。
* 在提交历史中引入包含修补提交前后两个版本的怪异的合并提交。

Git 提供了至少两种方式对非快进式推送进行限制。一个是通过版本库的配置，另一个是通过版本库的钩子脚本。

将版本库的参数 `receive.denyNonFastForwards` 设置为 `true` 可以禁止任何用户进行非快进式推送。下面的示例中，可以看到针对一个已经预先设置为禁止非快进式推送的版本库执行非快进式推送操作，将会被禁止，即使使用强制推送操作。

* 更改服务器版本库 :file:`/path/to/repos/shared.git` 的配置。

  ::

    $ git --git-dir=/path/to/repos/shared.git config receive.denyNonFastForwards true

* 在用户 user1 的工作区执行重置操作。

  ::

    $ git reset --hard HEAD^1
    $ git log --graph --oneline
    * b4f3ae0 user1's profile.
    * 5174bf3 initial commit.

* 用户 user1 使用强制推送也会失败。

  在出错信息中看到服务器端拒绝执行： `[remote rejected]` 。

  ::

    $ git push -f
    Total 0 (delta 0), reused 0 (delta 0)
    remote: error: denying non-fast-forward refs/heads/master (you should pull first)
    To file:///path/to/repos/shared.git
     ! [remote rejected] master -> master (non-fast-forward)
    error: failed to push some refs to 'file:///path/to/repos/shared.git'

另外一个方法是通过钩子脚本进行设置，可以仅对某些情况下的非快进式推送进行限制，而不是不分青红皁白地一概拒绝。例如：只对部分用户进行限制，而允许特定用户执行非快进式推送，或者允许某些分支可以进行强制提交而其他分支不可以。第5篇第30章会介绍Gitolite服务架设，通过授权文件（实际上通过版本库的 `update` 钩子脚本实现）对版本库非快进式推送做出更为精细的授权控制。

