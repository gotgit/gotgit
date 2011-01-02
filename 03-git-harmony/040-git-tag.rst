Git 里程碑
**********

里程碑即 Tag，是人为对提交进行的命名。这和 Git 的提交ID是否太长无关，使用任何数字都没有使用一个直观的表意的字符串表示提交来得方便。例如：用里程碑名称 "v2.1" 对应于软件的 2.1 发布版本就要比使用提交ID要直观的多。

里程碑实际上我们并不陌生，在第2部分的“Git基本操作”中，就介绍了使用里程碑来对工作进度“留影”纪念，并使用 `git describe` 命令显示里程碑和提交ID的组合来代表软件的版本号。本章将详细介绍里程碑的创建、删除、和共享，还会介绍里程碑存在的三种不同形式：轻量级里程碑、带注释的里程碑和带签名的里程碑。

接下来的三章，使用一个 `Hello, World` 示例程序的版本库进行研究，这个版本库不需要我们从头建立，可以直接从 Github 上克隆。先使用下面的方法在本地创建一个镜像，用做本地用户的共享版本库。

* 进入本地版本库根目录下。

  ::

    $ mkdir -p /path/to/repos/
    $ cd /path/to/repos/

* 从 Github 上镜像 `helloworld.git` 版本库。

  如果 Git 是 1.6.0 或更新的版本，使用下面的命令建立版本库镜像。

  ::

    $ git clone --mirror git://github.com/ossxp-com/helloworld.git 

  否则使用下面的命令建立版本库镜像。

  ::

    $ git clone --bare git://github.com/ossxp-com/helloworld.git helloworld.git 

完成上面操作后，就在本地建立了一个裸版本库 `/path/to/repos/helloworld.git` 。接下来用户 user1 和 user2 分别在各自工作区克隆这个裸版本库。使用如下命令即可：

::

  $ git clone file:///path/to/repos/helloworld.git \
              /path/to/user1/workspace/helloworld
  $ git clone file:///path/to/repos/helloworld.git \
              /path/to/user2/workspace/helloworld
  $ git --git-dir=/path/to/user1/workspace/helloworld/.git \
        config user.name user1
  $ git --git-dir=/path/to/user1/workspace/helloworld/.git \
        config user.email user1@sun.ossxp.com
  $ git --git-dir=/path/to/user2/workspace/helloworld/.git \
        config user.name user2
  $ git --git-dir=/path/to/user2/workspace/helloworld/.git \
        config user.email user2@moon.ossxp.com 


显示里程碑
=============

**命令 git tag**

不带任何参数执行 `git tag` 命令，即可显示当前版本库的里程碑列表。

::

  $ cd /path/to/user1/workspace/helloworld
  $ git tag
  jx/v1.0
  jx/v1.1
  jx/v1.2
  jx/v1.3
  jx/v2.0
  jx/v2.1
  jx/v2.2
  jx/v2.3

里程碑创建的时候可能包含一个说明。在显示里程碑的时候同时显示说明，使用 `-n<num>` 参数，显示最多 `<num>` 行里程碑的说明。

::

  $ git tag -n1 
  jx/v1.0         Version 1.0
  jx/v1.1         Version 1.1
  jx/v1.2         Version 1.2: allow spaces in username.
  jx/v1.3         Version 1.3: Hello world speaks in Chinese now.
  jx/v2.0         Version 2.0
  jx/v2.1         Version 2.1: fixed typo.
  jx/v2.2         Version 2.2: allow spaces in username.
  jx/v2.3         Version 2.3: Hello world speaks in Chinese now.

还可以使用通配符对显示进行过滤。只显示名称和通配符相符的里程碑。

::

  $ git tag -l jx/v1*
  jx/v1.0
  jx/v1.1
  jx/v1.2
  jx/v1.3

**命令 git log**

在查看日志时使用参数 `--decorate` 可以看到提交对应的里程碑以及其他引用。

::

  $ git log --pretty=oneline --decorate
  3e6070eb2062746861b20e1e6235fed6f6d15609 (HEAD, tag: v1.0, tag: jx/v1.0, origin/master, origin/HEAD, master) Show version.
  75346b3283da5d8117f3fe66815f8aaaf5387321 Hello world initialized.

**命令 git describe**

使用命令 `git describe` 将提交显示为一个易记的名称。这个易记的名称来自于建立在该提交上的里程碑，若该提交没有里程碑则使用该提交历史版本上的里程碑并加上可理解的寻址信息。

* 如果该提交恰好被打上一个里程碑，则显示该里程碑的名字。

  ::

    $ git describe
    jx/v1.0
    $ git describe 384f1e0
    jx/v2.2

* 若提交没有对应的里程碑，但是在某个历史提交上建有里程碑，则使用类似 `<tag>-<num>-g<commit>` 的格式显示。

  其中 `<tag>` 是最接近的历史提交的里程碑名字， `<num>` 是该里程碑和提交之间的距离， `<commit>` 是该提交的精简提交ID。

  ::

    $ git describe 610e78fc95bf2324dc5595fa684e08e1089f5757
    jx/v2.2-1-g610e78f

* 如果工作区对文件有修改，还可以通过后缀 `-dirty` 表示出来。

  ::

    $ echo hacked >> README; git describe --dirty; git checkout -- README
    jx/v1.0-dirty

* 如果提交本身没有包含里程碑，可以通过传递 `--always` 参数显示精简提交ID，否则出错。

  ::

    $ git describe master^ --always
    75346b3

命令 `git describe` 是非常有用的命令，可以将显示的版本描述信息作为软件的版本号显示。在之前曾经演示过这个应用，马上还会看到。

**命令 git name-rev**

命令 `git name-rev` 和 `git describe` 类似，会显示提交ID 及其对应的一个引用。缺省优先使用分支名，除非使用 `--tags` 参数。还有一个显著的不同是，如果提交上没有引用相对应，会使用最新提交上的引用名称加上向后回溯符号 `~<num>` 。

* 缺省优先显示分支名。

  ::

    $ git name-rev HEAD
    HEAD master

* 使用 `--tags` 优先使用里程碑。

  之所以对应的里程碑引用名称后面加上后缀 `^0` ，是因为该引用指向的是一个 tag 对象而非提交。用 `^0` 后缀指向对应的提交。

  ::

    $ git name-rev HEAD --tags
    HEAD tags/jx/v1.0^0

* 如果提交上没有引用名称对应，会使用新提交上的引用名称并加上后缀 `~<num>` 。后缀的含义是第 `<num>` 个祖先提交。

  ::

    $ git name-rev --tags 610e78fc95bf2324dc5595fa684e08e1089f5757
    610e78fc95bf2324dc5595fa684e08e1089f5757 tags/jx/v2.3~1

* 命令 `git name-rev` 可以对标准输入中的提交 ID 进行改写，使用管道符号对前一个命令的输出进行改写，会显示神奇的效果。

  ::

    $ git log --pretty=oneline origin/helper/master | git name-rev --tags --stdin
    bb4fef88fee435bfac04b8389cf193d9c04105a6 (tags/jx/v2.3^0) Translate for Chinese.
    610e78fc95bf2324dc5595fa684e08e1089f5757 (tags/jx/v2.3~1) Add I18N support.
    384f1e0d5106c9c6033311a608b91c69332fe0a8 (tags/jx/v2.2^0) Bugfix: allow spaces in username.
    e5e62107f8f8d0a5358c3aff993cf874935bb7fb (tags/jx/v2.1^0) fixed typo: -help to --help
    5d7657b2f1a8e595c01c812dd5b2f67ea133f456 (tags/jx/v2.0^0) Parse arguments using getopt_long.
    3e6070eb2062746861b20e1e6235fed6f6d15609 (tags/jx/v1.0^0) Show version.
    75346b3283da5d8117f3fe66815f8aaaf5387321 (tags/jx/v1.0~1) Hello world initialized.

创建里程碑
=============

创建里程碑依然是使用 `git tag` 命令。创建里程碑的用法有如下几种：

::

  用法1： git tag             <tagname> [<commit>]
  用法2： git tag -a          <tagname> [<commit>]
  用法3： git tag -m <msg>    <tagname> [<commit>]
  用法4： git tag -s          <tagname> [<commit>]
  用法5： git tag -u <key-id> <tagname> [<commit>]

其中：

* 用法1是创建轻量级里程碑。
* 用法2和用法3相同，都是创建带说明的里程碑。其中用法3直接通过 `-m` 参数提供里程碑创建说明。
* 用法4和用法5相同，都是创建带GPG签名的里程碑。其中用法5用 `-u` 参数选择指定的私钥进行签名。
* 创建里程碑需要输入里程碑的名字 `<tagname>` 和一个可选的提交ID `<commit>` 。如果没有提供提交ID，则基于头指针 `HEAD` 创建里程碑。

轻量级里程碑
------------

轻量级里程碑最简单，创建时无须输入描述信息。

* 先创建一个空提交。

  ::

    $ git commit --allow-empty -m "blank commit."
    [master 60a2f4f] blank commit.

* 在刚刚创建的空提交上创建一个轻量级里程碑，名为 `mytag` 。

  省略了 `<commit>` 参数，相当于在 `HEAD` 上即最新的空提交上创建里程碑。

  ::

    $ git tag mytag

* 查看里程碑，可以看到该里程碑已经创建。

  ::

    $ git tag -l my*
    mytag

**轻量级里程碑的奥秘**

当创建了里程碑 `mytag` 后，会在版本库的 `.git/refs/tags` 目录下创建了一个新文件。查看一下这个引用文件的内容：

::

  $ cat .git/refs/tags/mytag 
  60a2f4f31e5dddd777c6ad37388fe6e5520734cb

用 `git cat-file` 命令检查轻量级里程碑指向的对象。

* 轻量级里程碑指向的是一个提交。

  ::

    $ git cat-file -t mytag
    commit

* 查看该提交的内容，发现就是刚刚进行的空提交。

  ::

    $ git cat-file -p mytag
    tree 1d902fedc4eb732f17e50f111dcecb638f10313e
    parent 3e6070eb2062746861b20e1e6235fed6f6d15609
    author user1 <user1@sun.ossxp.com> 1293790794 +0800
    committer user1 <user1@sun.ossxp.com> 1293790794 +0800

    blank commit.

**轻量级里程碑的缺点**

轻量级里程碑的创建过程没有记录，因此无法知道是谁创建的里程碑，是何时创建的里程碑。在团队协同开发时，尽量不要采用此种偷懒的方式创建里程碑，而是采用后两种方式。

还有 `git describe` 命令缺省不使用轻量级里程碑生成版本描述字符串。

* 执行 `git describe` 命令，发现生成的版本描述字符串，使用的是前一个的版本上的里程碑名称。

  ::

    $ git describe
    jx/v1.0-1-g60a2f4f

* 使用 `--tags` 参数，也可以将轻量级里程碑用做版本描述符。

  ::

    $ git describe --tags
    mytag

带说明的里程碑
--------------

带说明的里程碑，就是使用参数 `-a` 或者 `-m <msg>` 调用 `git tag` 命令，在创建里程碑的时候提供一个关于该里程碑的说明。

* 还是先创建一个空提交。

  ::

    $ git commit --allow-empty -m "blank commit for annotated tag test."
    [master 8a9f3d1] blank commit for annotated tag test.

* 在刚刚创建的空提交上创建一个带说明的里程碑，名为 `mytag2` 。

  下面的命令使用了 `-m <msg>` 参数在命令行给出了新建里程碑的说明。

  ::

    $ git tag -m "My first annotated tag." mytag2

* 查看里程碑，可以看到该里程碑已经创建。

  ::

    $ git tag -l my* -n1
    mytag           blank commit.
    mytag2          My first annotated tag.

**带说明里程碑的奥秘**

当创建了带说明的里程碑 `mytag2` 后，会在版本库的 `.git/refs/tags` 目录下创建了一个新的引用文件。查看一下这个引用文件的内容：

::

  $ cat .git/refs/tags/mytag2
  149b6344e80fc190bda5621cd71df391d3dd465e

下面用 `git cat-file` 命令检查该里程碑（带说明里程碑）指向的对象。

* 带说明里程碑指向的不再是一个提交，而是一个 tag 对象。

  ::

    $ git cat-file -t mytag2
    tag

* 查看该提交的内容，发现 mytag2 对象的内容不是之前我们熟悉的提交对象，而是包含了创建里程碑时的说明，以及对应的提交ID等信息。

  ::

    $ git cat-file -p mytag2
    object 8a9f3d16ce2b4d39b5d694de10311207f289153f
    type commit
    tag mytag2
    tagger user1 <user1@sun.ossxp.com> Sun Jan 2 14:10:07 2011 +0800

    My first annotated tag.

由此可见使用带说明的里程碑，会在版本库中建立一个新的对象（tag 对象），这个对象会记录创建里程碑的用户（tagger），创建里程碑的时间以及为什么要创建里程碑。这就避免了轻量级里程碑匿名创建的风险。既然带说明的里程碑是一个 tag 对象，那么就和前面介绍的 commit 对象、tree 对象、blob 对象一样，也采用类似的方式确立其40位SHA1 哈希值ID。

::

  $ git cat-file tag mytag2 | wc -c
  148
  $ (printf "tag 148\000"; git cat-file tag mytag2) | sha1sum
  149b6344e80fc190bda5621cd71df391d3dd465e  -

虽然 mytag2 本身是一个 tag 对象，但在很多 Git 命令中，可以直接将其视为一个提交。下面的 `git log` 命令，显示 mytag2 指向的提交日志。

::

  $ git log -1 --pretty=oneline mytag2
  8a9f3d16ce2b4d39b5d694de10311207f289153f blank commit for annotated tag test.

有时，需要得到里程碑指向的提交对象的 SHA1 哈希值。

* 直接用 `git rev-parse` 命令查看 mytag2 得到的是 tag 对象的ID，并非提交对象的ID。

  ::

    $ git rev-parse mytag2
    149b6344e80fc190bda5621cd71df391d3dd465e

* 使用下面几种不同的表示法，都可以获得 mytag2 对象所指向的提交对象的ID。

  ::

    $ git rev-parse mytag2^{commit}
    8a9f3d16ce2b4d39b5d694de10311207f289153f
    $ git rev-parse mytag2^{}
    8a9f3d16ce2b4d39b5d694de10311207f289153f
    $ git rev-parse mytag2^0
    8a9f3d16ce2b4d39b5d694de10311207f289153f
    $ git rev-parse mytag2~0
    8a9f3d16ce2b4d39b5d694de10311207f289153f

带签名的里程碑
--------------

带签名的里程碑和上面介绍的带说明的里程碑本质上是一样的，都是在创建里程碑的时候在 Git 对象库中生成一个 tag 对象，只不过带签名的里程碑多做了一个工作：为里程碑对象签名。

创建带签名的里程碑也非常简单，使用参数 `-s` 或 `-u <key-id>` 即可。还可以使用 `-m <msg>` 参数直接在命令行中提供里程碑的描述。但一个前提是需要安装 GnuPG，以及创建公钥-私钥对。

在 Debian 上安装 GnuPG 非常简单，执行：

::

  $ sudo aptitude install gnupg

为了演示创建带签名的里程碑，还是事先创建一个空提交。

::

  $ git commit --allow-empty -m "blank commit for GnuPG-signed tag test."
  [master ebcf6d6] blank commit for GnuPG-signed tag test.

直接在刚刚创建的空提交上创建一个带签名的里程碑 `mytag2` 很可能会失败。

::

  $ git tag -s -m "My first GPG-signed tag." mytag3
  gpg: “user1 <user1@sun.ossxp.com>”已跳过：私钥不可用
  gpg: signing failed: 私钥不可用
  error: gpg failed to sign the tag
  error: unable to sign the tag

之所以签名失败，是因为找不到签名可用的公钥-私钥对。使用下面的命令可以查看可用的 GnuPG 公钥。

::

  $ gpg --list-keys
  /home/jiangxin/.gnupg/pubring.gpg
  ---------------------------------
  pub   1024D/FBC49D01 2006-12-21 [有效至：2016-12-18]
  uid                  Jiang Xin <worldhello.net@gmail.com>
  uid                  Jiang Xin <jiangxin@ossxp.com>
  sub   2048g/448713EB 2006-12-21 [有效至：2016-12-18]

可以看到 GnuPG 的公钥链（pubring）中只包含了 `Jiang Xin` 用户的公钥，尚没有 `uesr1` 用户的公钥。

可以在创建带签名的里程碑时，使用 `-u <key-id>` 参数，对于此类可以使用 `Jiang Xin` 用户的 key-id: FBC49D01 。但如果希望使用 `-s` 参数创建带签名的里程碑，就需要为而当前工作区提交者: `user1 <user1@sun.ossxp.com>` ，创建对应的公钥-私钥对。

使用命令 `gpg --gen-key` 来创建公钥私钥对。

::

  $ gpg --gen-key

按照提示一步一步操作即可。需要注意的有：

* 在创建公钥-私钥对时，在提示输入用户名时输入 `User1` ，在提示输入邮件地址时输入 `user1@sun.ossxp.com` ，其他可以采用缺省值。
* 在提示输入密码时，为了简单起见可以直接按下回车，即使用空口令。
* 在生成公钥私钥对过程，会提示用户做些操作以便产生更好的随机数，这时狂晃鼠标就可以了。

创建完毕，再查看一下公钥链。

::

  $ gpg --list-keys
  /home/jiangxin/.gnupg/pubring.gpg
  ---------------------------------
  pub   1024D/FBC49D01 2006-12-21 [有效至：2016-12-18]
  uid                  Jiang Xin <worldhello.net@gmail.com>
  uid                  Jiang Xin <jiangxin@ossxp.com>
  sub   2048g/448713EB 2006-12-21 [有效至：2016-12-18]

  pub   2048R/37379C67 2011-01-02
  uid                  User1 <user1@sun.ossxp.com>
  sub   2048R/2FCFB3E2 2011-01-02

很显然用户 user1 的公钥私钥对已经建立。现在就可以直接使用 `-s` 参数来创建带签名里程碑了。

::

  $ git tag -s -m "My first GPG-signed tag." mytag3

查看里程碑，可以看到该里程碑已经创建。

::

  $ git tag -l my* -n1
  mytag           blank commit.
  mytag2          My first annotated tag.
  mytag3          My first GPG-signed tag.

和带说明里程碑一样，也在Git对象库中建立了一个 tag 对象。查看该 tag 对象可以看到其中包含了 GnuPG 签名。

::

  $ git cat-file -p mytag3
  object ebcf6d6b06545331df156687ca2940800a3c599d
  type commit
  tag mytag3
  tagger user1 <user1@sun.ossxp.com> Sun Jan 2 17:35:36 2011 +0800

  My first GPG-signed tag.
  -----BEGIN PGP SIGNATURE-----
  Version: GnuPG v1.4.10 (GNU/Linux)

  iQEcBAABAgAGBQJNIEboAAoJEO9W1fg3N5xn42gH/jFDEKobqlupNKFvmkI1t9d6
  lApDFUdcFMPWvxo/eq8VjcQyRcb1X1bGJj+pxXk455fDL1NWonaJa6HE6RLu868x
  CQIWqWelkCelfm05GE9FnPd2SmJsiDkTPZzINya1HylF5ZbrExH506JyCFk//FC2
  8zRApSbrsj3yAWMStW0fGqHKLuYq+sdepzGnnFnhhzkJhusMHUkTIfpLwaprhMsm
  1IIxKNm9i0Zf/tzq4a/R0N8NiFHl/9M95iV200I9PuuRWedV0tEPS6Onax2yT3JE
  I/w9gtIBOeb5uAz2Xrt5AUwt9JJTk5mmv2HBqWCq5wefxs/ub26iPmef35PwAgA=
  =jdrN
  -----END PGP SIGNATURE-----

创建里程碑。

::

  $ git tag -v mytag3
  object ebcf6d6b06545331df156687ca2940800a3c599d
  type commit
  tag mytag3
  tagger user1 <user1@sun.ossxp.com> 1293960936 +0800

  My first GPG-signed tag.
  gpg: 于 2011年01月02日 星期日 17时35分36秒 CST 创建的签名，使用 RSA，钥匙号 37379C67


删除里程碑
=============

不要随意更改里程碑
==================


共享里程碑
==========

创建的里程碑，缺省只在本地版本库中可见，不会因为对分支执行推送而将里程碑也推送到远程版本库。这样的设计显然更

里程碑管理规范
===============



