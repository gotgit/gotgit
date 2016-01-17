Git里程碑
**********

里程碑即Tag，是人为对提交进行的命名。这和Git的提交ID是否太长无关，使用任\
何数字版本号无论长短，都没有使用一个直观的表意的字符串来得方便。例如：用\
里程碑名称“v2.1”对应于软件的2.1发布版本就比使用提交ID要直观得多。

对于里程碑，实际上我们并不陌生，在第2篇的“第10章 Git基本操作”中，就介绍\
了使用里程碑来对工作进度“留影”纪念，并使用\ :command:`git describe`\ 命令\
显示里程碑和提交ID的组合来代表软件的版本号。本章将详细介绍里程碑的创建、\
删除和共享，还会介绍里程碑存在的三种不同形式：轻量级里程碑、带注释的\
里程碑和带签名的里程碑。

接下来的三章，将对一个使用\ ``Hello, World``\ 作为示例程序的版本库进行研\
究，这个版本库不需要我们从头建立，可以直接从Github上克隆。先使用下面的方\
法在本地创建一个镜像，用作本地用户的共享版本库。

* 进入本地版本库根目录下。

  ::

    $ mkdir -p /path/to/repos/
    $ cd /path/to/repos/

* 从Github上镜像\ ``hello-world.git``\ 版本库。

  如果Git是1.6.0或更新的版本，可以使用下面的命令建立版本库镜像。

  ::

    $ git clone --mirror git://github.com/ossxp-com/hello-world.git

  否则使用下面的命令建立版本库镜像。

  ::

    $ git clone --bare \
          git://github.com/ossxp-com/hello-world.git \
          hello-world.git 

完成上面操作后，就在本地建立了一个裸版本库\
:file:`/path/to/repos/hello-world.git`\ 。接下来用户user1和user2\
分别在各自工作区克隆这个裸版本库。使用如下命令即可：

::

  $ git clone file:///path/to/repos/hello-world.git \
              /path/to/user1/workspace/hello-world
  $ git clone file:///path/to/repos/hello-world.git \
              /path/to/user2/workspace/hello-world
  $ git --git-dir=/path/to/user1/workspace/hello-world/.git \
        config user.name user1
  $ git --git-dir=/path/to/user1/workspace/hello-world/.git \
        config user.email user1@sun.ossxp.com
  $ git --git-dir=/path/to/user2/workspace/hello-world/.git \
        config user.name user2
  $ git --git-dir=/path/to/user2/workspace/hello-world/.git \
        config user.email user2@moon.ossxp.com


显示里程碑
=============

里程碑可以使用\ :command:`git tag`\ 命令来显示，里程碑还可以在其他命令的\
输出中出现，下面分别对这些命令加以介绍。

1. 命令\ :command:`git tag`
-----------------------------

不带任何参数执行\ :command:`git tag`\ 命令，即可显示当前版本库的里程碑列表。

::

  $ cd /path/to/user1/workspace/hello-world
  $ git tag
  jx/v1.0
  jx/v1.0-i18n
  jx/v1.1
  jx/v1.2
  jx/v1.3
  jx/v2.0
  jx/v2.1
  jx/v2.2
  jx/v2.3

里程碑创建的时候可能包含一个说明。在显示里程碑的时候同时显示说明，使用\
``-n<num>``\ 参数，显示最多\ ``<num>``\ 行里程碑的说明。

::

  $ git tag -n1
  jx/v1.0         Version 1.0
  jx/v1.0-i18n    i18n support for v1.0
  jx/v1.1         Version 1.1
  jx/v1.2         Version 1.2: allow spaces in username.
  jx/v1.3         Version 1.3: Hello world speaks in Chinese now.
  jx/v2.0         Version 2.0
  jx/v2.1         Version 2.1: fixed typo.
  jx/v2.2         Version 2.2: allow spaces in username.
  jx/v2.3         Version 2.3: Hello world speaks in Chinese now.

还可以使用通配符对显示进行过滤。只显示名称和通配符相符的里程碑。

::

  $ git tag -l jx/v2*
  jx/v2.0
  jx/v2.1
  jx/v2.2
  jx/v2.3

2. 命令\ :command:`git log`
-----------------------------

在查看日志时使用参数\ ``--decorate``\ 可以看到提交对应的里程碑及其他引用。

::

  $ git log --oneline --decorate
  3e6070e (HEAD, tag: jx/v1.0, origin/master, origin/HEAD, master) Show version.
  75346b3 Hello world initialized.

3. 命令\ :command:`git describe`
-----------------------------------

使用命令\ :command:`git describe`\ 将提交显示为一个易记的名称。这个易记\
的名称来自于建立在该提交上的里程碑，若该提交没有里程碑则使用该提交历史版\
本上的里程碑并加上可理解的寻址信息。

* 如果该提交恰好被打上一个里程碑，则显示该里程碑的名字。

  ::

    $ git describe
    jx/v1.0
    $ git describe 384f1e0
    jx/v2.2

* 若提交没有对应的里程碑，但是在其祖先版本上建有里程碑，则使用类似\
  ``<tag>-<num>-g<commit>``\ 的格式显示。

  其中\ ``<tag>``\ 是最接近的祖先提交的里程碑名字，\ ``<num>``\ 是该里程碑\
  和提交之间的距离，\ ``<commit>``\ 是该提交的精简提交ID。

  ::

    $ git describe 610e78fc95bf2324dc5595fa684e08e1089f5757
    jx/v2.2-1-g610e78f

* 如果工作区对文件有修改，还可以通过后缀\ ``-dirty``\ 表示出来。

  ::

    $ echo hacked >> README; git describe --dirty; git checkout -- README
    jx/v1.0-dirty

* 如果提交本身没有包含里程碑，可以通过传递\ ``--always``\ 参数显示精简\
  提交ID，否则出错。

  ::

    $ git describe master^ --always
    75346b3

命令\ :command:`git describe`\ 是非常有用的命令，可以将该命令的输出用作\
软件的版本号。在之前曾经演示过这个应用，马上还会看到。

4. 命令\ :command:`git name-rev`
-----------------------------------

命令\ :command:`git name-rev`\ 和\ :command:`git describe`\ 类似，会显示\
提交ID及其对应的一个引用。默认优先使用分支名，除非使用\
:command:`--tags`\ 参数。还有一个显著的不同是，如果提交上没有相对应的引用，\
则会使用最新提交上的引用名称并加上向后回溯的符号\ :command:`~<num>`\ 。

* 默认优先显示分支名。

  ::

    $ git name-rev HEAD
    HEAD master

* 使用\ ``--tags``\ 优先使用里程碑。

  之所以对应的里程碑引用名称后面加上后缀\ ``^0``\ ，是因为该引用指向的是\
  一个tag对象而非提交。用\ ``^0``\ 后缀指向对应的提交。

  ::

    $ git name-rev HEAD --tags
    HEAD tags/jx/v1.0^0

* 如果提交上没有对应的引用名称，则会使用新提交上的引用名称并加上后缀\
  :command:`~<num>`\ 。后缀的含义是第<num>个祖先提交。

  ::

    $ git name-rev --tags 610e78fc95bf2324dc5595fa684e08e1089f5757
    610e78fc95bf2324dc5595fa684e08e1089f5757 tags/jx/v2.3~1

* 命令\ :command:`git name-rev`\ 可以对标准输入中的提交ID进行改写，使用\
  管道符号对前一个命令的输出进行改写，会显示神奇的效果。

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

创建里程碑依然是使用\ :command:`git tag`\ 命令。创建里程碑的用法有以下几种：

::

  用法1： git tag             <tagname> [<commit>]
  用法2： git tag -a          <tagname> [<commit>]
  用法3： git tag -m <msg>    <tagname> [<commit>]
  用法4： git tag -s          <tagname> [<commit>]
  用法5： git tag -u <key-id> <tagname> [<commit>]

其中：

* 用法1是创建轻量级里程碑。

* 用法2和用法3相同，都是创建带说明的里程碑。其中用法3直接通过\ ``-m``\
  参数提供里程碑创建说明。

* 用法4和用法5相同，都是创建带GPG签名的里程碑。其中用法5用\ ``-u``\ 参数\
  选择指定的私钥进行签名。

* 创建里程碑需要输入里程碑的名字\ ``<tagname>``\ 和一个可选的提交ID\
  ``<commit>``\ 。如果没有提供提交ID，则基于头指针\ ``HEAD``\ 创建里程碑。

轻量级里程碑
------------

轻量级里程碑最简单，创建时无须输入描述信息。我们来看看如何创建轻量级里程碑：

* 先创建一个空提交。

  ::

    $ git commit --allow-empty -m "blank commit."
    [master 60a2f4f] blank commit.

* 在刚刚创建的空提交上创建一个轻量级里程碑，名为\ ``mytag``\ 。

  省略了\ ``<commit>``\ 参数，相当于在\ ``HEAD``\ 上即最新的空提交上创建\
  里程碑。

  ::

    $ git tag mytag

* 查看里程碑，可以看到该里程碑已经创建。

  ::

    $ git tag -l my*
    mytag

**轻量级里程碑的奥秘**

当创建了里程碑\ ``mytag``\ 后，会在版本库的\ :file:`.git/refs/tags`\
目录下创建一个新文件。

* 查看一下这个引用文件的内容，会发现是一个40位的SHA1哈希值。

  ::

    $ cat .git/refs/tags/mytag
    60a2f4f31e5dddd777c6ad37388fe6e5520734cb

* 用\ :command:`git cat-file`\ 命令检查轻量级里程碑指向的对象。轻量级\
  里程碑实际上指向的是一个提交。

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

轻量级里程碑的创建过程没有记录，因此无法知道是谁创建的里程碑，是何时创建\
的里程碑。在团队协同开发时，尽量不要采用此种偷懒的方式创建里程碑，而是采\
用后两种方式。

还有\ :command:`git describe`\ 命令默认不使用轻量级里程碑生成版本描述字\
符串。

* 执行\ :command:`git describe`\ 命令，发现生成的版本描述字符串，使用的\
  是前一个版本上的里程碑名称。

  ::

    $ git describe
    jx/v1.0-1-g60a2f4f

* 使用\ ``--tags``\ 参数，也可以将轻量级里程碑用作版本描述符。

  ::

    $ git describe --tags
    mytag

带说明的里程碑
--------------

带说明的里程碑，就是使用参数\ ``-a``\ 或者\ ``-m <msg>``\ 调用\
:command:`git tag`\ 命令，在创建里程碑的时候提供一个关于该里程碑的说明。\
下面来看看如何创建带说明的里程碑：

* 还是先创建一个空提交。

  ::

    $ git commit --allow-empty -m "blank commit for annotated tag test."
    [master 8a9f3d1] blank commit for annotated tag test.

* 在刚刚创建的空提交上创建一个带说明的里程碑，名为\ ``mytag2``\ 。

  下面的命令使用了\ ``-m <msg>``\ 参数在命令行给出了新建里程碑的说明。

  ::

    $ git tag -m "My first annotated tag." mytag2

* 查看里程碑，可以看到该里程碑已经创建。

  ::

    $ git tag -l my* -n1
    mytag           blank commit.
    mytag2          My first annotated tag.

**带说明里程碑的奥秘**

当创建了带说明的里程碑\ ``mytag2``\ 后，会在版本库的\
:file:`.git/refs/tags`\ 目录下创建一个新的引用文件。

* 查看一下这个引用文件的内容：

  ::

    $ cat .git/refs/tags/mytag2
    149b6344e80fc190bda5621cd71df391d3dd465e

* 用\ :command:`git cat-file`\ 命令检查该里程碑（带说明的里程碑）指向的\
  对象，会发现指向的不再是一个提交，而是一个 tag 对象。

  ::

    $ git cat-file -t mytag2
    tag

* 查看该提交的内容，会发现mytag2对象的内容不是之前我们熟悉的提交对象的内\
  容，而是包含了创建里程碑时的说明，以及对应的提交ID等信息。

  ::

    $ git cat-file -p mytag2
    object 8a9f3d16ce2b4d39b5d694de10311207f289153f
    type commit
    tag mytag2
    tagger user1 <user1@sun.ossxp.com> Sun Jan 2 14:10:07 2011 +0800

    My first annotated tag.

由此可见使用带说明的里程碑，会在版本库中建立一个新的对象（tag对象），这\
个对象会记录创建里程碑的用户（tagger），创建里程碑的时间，以及为什么要创\
建里程碑。这就避免了轻量级里程碑因为匿名创建而无法追踪的缺点。

带说明的里程碑是一个tag对象，在版本库中以一个对象的方式存在，并用一个40\
位的SHA1哈希值来表示。这个哈希值的生成方法和前面介绍的commit对象、tree对象、\
blob对象一样。至此，Git对象库的四类对象我们就都已经研究到了。

::

  $ git cat-file tag mytag2 | wc -c
  148
  $ (printf "tag 148\000"; git cat-file tag mytag2) | sha1sum
  149b6344e80fc190bda5621cd71df391d3dd465e  -

虽然mytag2本身是一个tag对象，但在很多Git命令中，可以直接将其视为一个提交。\
下面的\ :command:`git log`\ 命令，显示mytag2指向的提交日志。

::

  $ git log -1 --pretty=oneline mytag2
  8a9f3d16ce2b4d39b5d694de10311207f289153f blank commit for annotated tag test.

有时，需要得到里程碑指向的提交对象的SHA1哈希值。

* 直接用\ :command:`git rev-parse`\ 命令查看mytag2得到的是tag对象的ID，\
  并非提交对象的ID。

  ::

    $ git rev-parse mytag2
    149b6344e80fc190bda5621cd71df391d3dd465e

* 使用下面几种不同的表示法，则可以获得mytag2对象所指向的提交对象的ID。

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

带签名的里程碑和上面介绍的带说明的里程碑本质上是一样的，都是在创建里程碑\
的时候在Git对象库中生成一个tag对象，只不过带签名的里程碑多做了一个工作：\
为里程碑对象添加GnuPG签名。

创建带签名的里程碑也非常简单，使用参数\ ``-s``\ 或\ ``-u <key-id>``\ 即\
可。还可以使用\ ``-m <msg>``\ 参数直接在命令行中提供里程碑的描述。创建带\
签名里程碑的一个前提是需要安装GnuPG，并且建立相应的公钥/私钥对。

GnuPG可以在各个平台上安装。

* 在Linux，如Debian/Ubuntu上安装，执行：

  ::

    $ sudo aptitude install gnupg

* 在Mac OS X上，可以通过Homebrew安装：

  ::

    $ brew install gnupg

* 在Windows上可以通过cygwin安装gnupg。

为了演示创建带签名的里程碑，还是事先创建一个空提交。

::

  $ git commit --allow-empty -m "blank commit for GnuPG-signed tag test."
  [master ebcf6d6] blank commit for GnuPG-signed tag test.

直接在刚刚创建的空提交上创建一个带签名的里程碑\ ``mytag2``\ 很可能会失败。

::

  $ git tag -s -m "My first GPG-signed tag." mytag3
  gpg: “user1 <user1@sun.ossxp.com>”已跳过：私钥不可用
  gpg: signing failed: 私钥不可用
  error: gpg failed to sign the tag
  error: unable to sign the tag

之所以签名失败，是因为找不到签名可用的公钥/私钥对。使用下面的命令可以查\
看当前可用的GnuPG公钥。

::

  $ gpg --list-keys
  /home/jiangxin/.gnupg/pubring.gpg
  ---------------------------------
  pub   1024D/FBC49D01 2006-12-21 [有效至：2016-12-18]
  uid                  Jiang Xin <worldhello.net@gmail.com>
  uid                  Jiang Xin <jiangxin@ossxp.com>
  sub   2048g/448713EB 2006-12-21 [有效至：2016-12-18]

可以看到GnuPG的公钥链（pubring）中只包含了\ ``Jiang Xin``\ 用户的公钥，\
尚没有\ ``uesr1``\ 用户的公钥。

实际上在创建带签名的里程碑时，并非一定要使用邮件名匹配的公钥/私钥对进行\
签名，使用\ ``-u <key-id>``\ 参数调用就可以用指定的公钥/私钥对进行签名，\
对于此例可以使用\ ``FBC49D01``\ 作为\ ``<key-id>``\ 。但如果没有可用的公\
钥/私钥对，或者希望使用提交者本人的公钥/私钥对进行签名，就需要为提交者:\
``user1 <user1@sun.ossxp.com>``\ 创建对应的公钥/私钥对。

使用命令\ :command:`gpg --gen-key`\ 来创建公钥/私钥对。

::

  $ gpg --gen-key

按照提示一步一步操作即可。需要注意的有：

* 在创建公钥/私钥对时，会提示输入用户名，输入\ ``User1``\ ，提示输入邮件\
  地址，输入\ ``user1@sun.ossxp.com``\ ，其他可以采用默认值。

* 在提示输入密码时，为了简单起见可以直接按下回车，即使用空口令。

* 在生成公钥私钥对过程中，会提示用户做一些随机操作以便产生更好的随机数，\
  这时不停的晃动鼠标就可以了。

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

很显然用户user1的公钥私钥对已经建立。现在就可以直接使用\ ``-s``\ 参数来\
创建带签名里程碑了。

::

  $ git tag -s -m "My first GPG-signed tag." mytag3

查看里程碑，可以看到该里程碑已经创建。

::

  $ git tag -l my* -n1
  mytag           blank commit.
  mytag2          My first annotated tag.
  mytag3          My first GPG-signed tag.

和带说明的里程碑一样，在Git对象库中也建立了一个tag对象。查看该tag对象\
可以看到其中包含了GnuPG签名。

::

  $ git cat-file tag mytag3
  object ebcf6d6b06545331df156687ca2940800a3c599d
  type commit
  tag mytag3
  tagger user1 <user1@sun.ossxp.com> 1293960936 +0800
  
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

要验证签名的有效性，如果直接使用gpg命令会比较麻烦，因为需要将这个文件拆\
分为两个，一个是不包含签名的里程碑内容，另外一个是签名本身。还好可以使用\
命令\ :command:`git tag -v`\ 来验证里程碑签名的有效性。

::

  $ git tag -v mytag3
  object ebcf6d6b06545331df156687ca2940800a3c599d
  type commit
  tag mytag3
  tagger user1 <user1@sun.ossxp.com> 1293960936 +0800

  My first GPG-signed tag.
  gpg: 于 2011年01月02日 星期日 17时35分36秒 CST 创建的签名，使用 RSA，钥匙号 37379C67

删除里程碑
===========

如果里程碑建立在了错误的提交上，或者对里程碑的命名不满意，可以删除里程碑。\
删除里程碑使用命令\ :command:`git tag -d`\ ，下面用命令删除里程碑\ ``mytag``\ 。

::

  $ git tag -d mytag
  Deleted tag 'mytag' (was 60a2f4f)

里程碑没有类似reflog的变更记录机制，一旦删除不易恢复，慎用。在删除里程碑\
``mytag``\ 的命令输出中，会显示该里程碑所对应的提交ID，一旦发现删除错误，\
赶紧补救还来得及。下面的命令实现对里程碑\ ``mytag``\ 的重建。

::

  $ git tag mytag 60a2f4f

**为什么没有重命名里程碑的命令？**

Git没有提供对里程碑直接重命名的命令，如果对里程碑名字不满意的话，可以删\
除旧的里程碑，然后重新用新的里程碑进行命名。

为什么没有提供重命名里程碑的命令呢？按理说只要将\ :file:`.git/refs/tags/`\
下的引用文件改名就可以了。这是因为里程碑的名字不但反映在\
:file:`.git/refs/tags`\ 引用目录下的文件名，而且对于带说明或签名的里程碑，\
里程碑的名字还反映在tag对象的内容中。尤其是带签名的里程碑，如果修改里程碑\
的名字，不但里程碑对象ID势必要变化，而且里程碑也要重新进行签名，这显然难以\
自动实现。

在第6篇第35章的“Git版本库整理”一节中会介绍使用\ :command:`git filter-branch`\
命令实现对里程碑自动重命名的方法，但是那个方法也不能毫发无损地实现对签名\
里程碑的重命名，被重命名的签名里程碑中的签名会被去除从而成为带说明的里程碑。

不要随意更改里程碑
==================

里程碑建立后，如果需要修改，可以使用同样的里程碑名称重新建立，不过需要加上\
``-f``\ 或\ ``--force``\ 参数强制覆盖已有的里程碑。

更改里程碑要慎重，一个原因是里程碑从概念上讲是对历史提交的一个标记，不应\
该随意变动。另外一个原因是里程碑一旦被他人同步，如果修改里程碑，已经同步\
该里程碑的用户不会自动更新，这就导致一个相同名称的里程碑在不同用户的版本\
库中的指向不同。下面就看看如何与他人共享里程碑。

共享里程碑
==========

现在看看用户user1的工作区状态。可以看出现在的工作区相比上游有三个新的提交。

::

  $ git status
  # On branch master
  # Your branch is ahead of 'origin/master' by 3 commits.
  #
  nothing to commit (working directory clean)

那么如果执行\ :command:`git push`\ 命令向上游推送，会将本地创建的三个\
里程碑推送到上游么？通过下面的操作来试一试。

* 向上游推送。

  ::
  
    $ git push
    Counting objects: 3, done.
    Delta compression using up to 2 threads.
    Compressing objects: 100% (3/3), done.
    Writing objects: 100% (3/3), 512 bytes, done.
    Total 3 (delta 0), reused 0 (delta 0)
    Unpacking objects: 100% (3/3), done.
    To file:///path/to/repos/hello-world.git
       3e6070e..ebcf6d6  master -> master

* 通过执行\ :command:`git ls-remote`\ 可以查看上游版本库的引用，会发现\
  本地建立的三个里程碑，并没有推送到上游。

  ::

    $ git ls-remote origin my*

创建的里程碑，默认只在本地版本库中可见，不会因为对分支执行推送而将里程碑\
也推送到远程版本库。这样的设计显然更为合理，否则的话，每个用户本地创建的\
里程碑都自动向上游推送，那么上游的里程碑将有多么杂乱，而且不同用户创建的\
相同名称的里程碑会互相覆盖。

**那么如何共享里程碑呢？**

如果用户确实需要将某些本地建立的里程碑推送到远程版本库，需要在\
:command:`git push`\ 命令中明确地表示出来。下面在用户user1的工作区执行命令，\
将\ ``mytag``\ 里程碑共享到上游版本库。

::

  $ git push origin mytag
  Total 0 (delta 0), reused 0 (delta 0)
  To file:///path/to/repos/hello-world.git
   * [new tag]         mytag -> mytag


如果需要将本地建立的所有里程碑全部推送到远程版本库，可以使用通配符。

::

  $ git push origin refs/tags/*
  Counting objects: 2, done.
  Delta compression using up to 2 threads.
  Compressing objects: 100% (2/2), done.
  Writing objects: 100% (2/2), 687 bytes, done.
  Total 2 (delta 0), reused 0 (delta 0)
  Unpacking objects: 100% (2/2), done.
  To file:///path/to/repos/hello-world.git
   * [new tag]         mytag2 -> mytag2
   * [new tag]         mytag3 -> mytag3

再用命令\ :command:`git ls-remote`\ 查看上游版本库的引用，会发现本地建立\
的三个里程碑，已经能够在上游中看到了。

::

  $ git ls-remote origin my*
  60a2f4f31e5dddd777c6ad37388fe6e5520734cb        refs/tags/mytag
  149b6344e80fc190bda5621cd71df391d3dd465e        refs/tags/mytag2
  8a9f3d16ce2b4d39b5d694de10311207f289153f        refs/tags/mytag2^{}
  5dc2fc52f2dcb84987f511481cc6b71ec1b381f7        refs/tags/mytag3
  ebcf6d6b06545331df156687ca2940800a3c599d        refs/tags/mytag3^{}

**用户从版本库执行拉回操作，会自动获取里程碑么？**

用户 user2 的工作区中如果执行\ :command:`git fetch`\ 或\ :command:`git pull`\
操作，能自动将用户 user1 推送到共享版本库中的里程碑获取到本地版本库么？\
下面实践一下。

* 进入user2的工作区。

  ::

    $ cd /path/to/user2/workspace/hello-world/

* 执行\ :command:`git pull`\ 命令，从上游版本库获取提交。

  ::

    $ git pull
    remote: Counting objects: 5, done.
    remote: Compressing objects: 100% (5/5), done.
    remote: Total 5 (delta 0), reused 0 (delta 0)
    Unpacking objects: 100% (5/5), done.
    From file:///path/to/repos/hello-world
       3e6070e..ebcf6d6  master     -> origin/master
     * [new tag]         mytag3     -> mytag3
    From file:///path/to/repos/hello-world
     * [new tag]         mytag      -> mytag
     * [new tag]         mytag2     -> mytag2
    Updating 3e6070e..ebcf6d6
    Fast-forward

* 可见执行\ :command:`git pull`\ 操作，能够在获取远程共享版本库的提交的\
  同时，获取新的里程碑。下面的命令可以看到本地版本库中的里程碑。

  ::
  
    $ git tag -n1 -l my*
    mytag           blank commit.
    mytag2          My first annotated tag.
    mytag3          My first GPG-signed tag.

**里程碑变更能够自动同步么？**

里程碑可以被强制更新。当里程碑被改变后，已经获取到里程碑的版本库再次使用\
获取或拉回操作，能够自动更新里程碑么？答案是不能。可以看看下面的操作。


* 用户user2强制更新里程碑\ ``mytag2``\ 。

  ::
    
    $ git tag -f -m "user2 update this annotated tag." mytag2 HEAD^
    Updated tag 'mytag2' (was 149b634)

* 里程碑\ ``mytag2``\ 已经是不同的对象了。
    
  ::

    $ git rev-parse mytag2
    0e6c780ff0fe06635394db9dac6fb494833df8df
    $ git cat-file -p mytag2
    object 8a9f3d16ce2b4d39b5d694de10311207f289153f
    type commit
    tag mytag2
    tagger user2 <user2@moon.ossxp.com> Mon Jan 3 01:14:18 2011 +0800
    
    user2 update this annotated tag.

* 为了更改远程共享服务器中的里程碑，同样需要显式推送。即在推送时写上要\
  推送的里程碑名称。

  ::

    $ git push origin mytag2
    Counting objects: 1, done.
    Writing objects: 100% (1/1), 171 bytes, done.
    Total 1 (delta 0), reused 0 (delta 0)
    Unpacking objects: 100% (1/1), done.
    To file:///path/to/repos/hello-world.git
       149b634..0e6c780  mytag2 -> mytag2

* 切换到另外一个用户user1的工作区。

  ::

    $ cd /path/to/user1/workspace/hello-world/

* 用户user1执行拉回操作，没有获取到新的里程碑。

  ::

    $ git pull
    Already up-to-date.

* 用户user1必须显式地执行拉回操作。即要在\ :command:`git pull`\
  的参数中使用引用表达式。

  所谓引用表达式就是用冒号分隔的引用名称或通配符。用在这里代表用远程共享\
  版本库的引用\ ``refs/tag/mytag2``\ 覆盖本地版本库的同名引用。

  ::

    $ git pull origin refs/tags/mytag2:refs/tags/mytag2
    remote: Counting objects: 1, done.
    remote: Total 1 (delta 0), reused 0 (delta 0)
    Unpacking objects: 100% (1/1), done.
    From file:///path/to/repos/hello-world
     - [tag update]      mytag2     -> mytag2
    Already up-to-date.

关于里程碑的共享和同步操作，看似很繁琐，但用心体会就会感觉到Git关于里程\
碑共享的设计是非常合理和人性化的：

* 里程碑共享，必须显式的推送。即在推送命令的参数中，标明要推送哪个里程碑。

  显式推送是防止用户随意推送里程碑导致共享版本库中里程碑泛滥的方法。当然\
  还可以参考第5篇“第30章Gitolite服务架设”的相关章节为共享版本库添加授权，\
  只允许部分用户向服务器推送里程碑。

* 执行获取或拉回操作，自动从远程版本库获取新里程碑，并在本地版本库中创建。

  获取或拉回操作，只会将获取的远程分支所包含的新里程碑同步到本地，而不会\
  将远程版本库的其他分支中的里程碑获取到本地。这既方便了里程碑的取得，又\
  防止本地里程碑因同步远程版本库而泛滥。

* 如果本地已有同名的里程碑，默认不会从上游同步里程碑，即使两者里程碑的指\
  向是不同的。

  理解这一点非常重要。这也就要求里程碑一旦共享，就不要再修改。

删除远程版本库的里程碑
=======================

假如向远程版本库推送里程碑后，忽然发现里程碑创建在了错误的提交上，为了防\
止其他人获取到错误的里程碑，应该尽快将里程碑删除。

删除本地里程碑非常简单，使用\ :command:`git tag -d <tagname>`\ 就可以了，\
但是如何撤销已经推送到远程版本库的里程碑呢？需要登录到服务器上么？或者\
需要麻烦管理员么？不必！可以直接在本地版本库执行命令删除远程版本库的里程碑。

使用\ :command:`git push`\ 命令可以删除远程版本库中的里程碑。用法如下：

::

  命令： git push <remote_url>  :<tagname>

该命令的最后一个参数实际上是一个引用表达式，引用表达式一般的格式为\
``<ref>:<ref>``\ 。该推送命令使用的引用表达式冒号前的引用被省略，其含义是\
将一个空值推送到远程版本库对应的引用中，亦即删除远程版本库中相关的引用。\
这个命令不但可以用于删除里程碑，在下一章还可以用它删除远程版本库中的分支。

下面演示在用户user1的工作区执行下面的命令删除远程共享版本库中的里程碑\
``mytag2``\ 。

* 切换到用户user1工作区。

  ::

    $ cd /path/to/user1/workspace/hello-world

* 执行推送操作删除远程共享版本库中的里程碑。

  ::

    $ git push origin :mytag2
    To file:///path/to/repos/hello-world.git
     - [deleted]         mytag2

* 查看远程共享库中的里程碑，发现\ ``mytag2``\ 的确已经被删除。

  ::

    $ git ls-remote origin my*
    60a2f4f31e5dddd777c6ad37388fe6e5520734cb        refs/tags/mytag
    5dc2fc52f2dcb84987f511481cc6b71ec1b381f7        refs/tags/mytag3
    ebcf6d6b06545331df156687ca2940800a3c599d        refs/tags/mytag3^{}

里程碑命名规范
===============

在正式项目的版本库管理中，要为里程碑创建订立一些规则，诸如：

* 对创建里程碑进行权限控制，参考后面Git服务器架设的相关章节。

* 不能使用轻量级里程碑（只用于本地临时性里程碑），必须使用带说明的里程碑，\
  甚至要求必须使用带签名的里程碑。

* 如果使用带签名的里程碑，可以考虑设置专用账户，使用专用的私钥创建签名。

* 里程碑的命名要使用统一的风格，并很容易和最终产品显示的版本号相对应。

Git的里程碑命名还有一些特殊的约定需要遵守。实际上，下面的这些约定对于下\
一章要介绍的分支及任何其他引用均适用：

* 不能以符号“-”开头。以免在命令行中被当成命令的选项。

* 可以包含路径分隔符“/”，但是路径分隔符不能位于最后。

  使用路径分隔符创建tag实际上会在引用目录下创建子目录。例如名为\
  ``demo/v1.2.1``\ 的里程碑，就会创建目录\ :file:`.git/refs/tags/demo`\
  并在该目录下创建引用文件\ ``v1.2.1``\ 。

* 不能出现两个连续的点“..”。因为两个连续的点被用于表示版本范围，当然更不\
  能使用三个连续的点。

* 如果在里程碑命名中使用了路径分隔符“/”，就不能在任何一个分隔路径中以点\
  “.”开头。

  这是因为里程碑在用简写格式表达时，可能造成以一个点“.”开头。这样的引用\
  名称在用作版本范围的最后一个版本时，本来两点操作符变成了三点操作符，\
  从而造成歧义。

* 不能在里程碑名称的最后出现点“.”。否则作为第一个参数出现在表示版本范围\
  的表达式中时，本来版本范围表达式可能用的是两点操作符，结果被误作三点操作符。

* 不能使用特殊字符，如：空格、波浪线“~”、脱字符“^”、冒号“:”、问号“?”、\
  星号“*”、方括号“[”，以及字符\ ``\\177``\ （删除字符）或小于\ ``\\040``\
  （32）的Ascii码都不能使用。

  这是因为波浪线“~”和脱字符“^”都用于表示一个提交的祖先提交。

  冒号被用作引用表达式来分隔两个不同的引用，或者用于分隔引用代表的树对象\
  和该目录树中的文件。

  问号、星号和方括号在引用表达式中都被用作通配符。

* 不能以“.lock”为结尾。因为以“.lock”结尾的文件是里程碑操作过程中的临时文件。

* 不能包含“@{”字串。因为reflog采用“@{<num>”作为语法的一部分。

* 不能包含反斜线“\\”。因为反斜线用于命令行或shell脚本会造成意外。

**Linux中的里程碑**

Linux项目无疑是使用Git版本库时间最久远，也是最重量级的项目。研究Linux\
项目本身的里程碑命名和管理，无疑会为自己的项目提供借鉴。

* 首先看看Linux中的里程碑命名。可以看到里程碑都是以字母\ ``v``\ 开头。

  ::

    $ git ls-remote --tags \
      git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6-stable.git \
      v2.6.36*
    25427f38d3b791d986812cb81c68df38e8249ef8        refs/tags/v2.6.36
    f6f94e2ab1b33f0082ac22d71f66385a60d8157f        refs/tags/v2.6.36^{}
    8ed88d401f908a594cd74a4f2513b0fabd32b699        refs/tags/v2.6.36-rc1
    da5cabf80e2433131bf0ed8993abc0f7ea618c73        refs/tags/v2.6.36-rc1^{}
    ...
    7619e63f48822b2c68d0e108677340573873fb93        refs/tags/v2.6.36-rc8
    cd07202cc8262e1669edff0d97715f3dd9260917        refs/tags/v2.6.36-rc8^{}
    9d389cb6dcae347cfcdadf2a1ec5e66fc7a667ea        refs/tags/v2.6.36.1
    bf6ef02e53e18dd14798537e530e00b80435ee86        refs/tags/v2.6.36.1^{}
    ee7b38c91f3d718ea4035a331c24a56553e90960        refs/tags/v2.6.36.2
    a1346c99fc89f2b3d35c7d7e2e4aef8ea4124342        refs/tags/v2.6.36.2^{}

* 以\ ``-rc<num>``\ 为后缀的是先于正式版发布的预发布版本。

  可以看出这个里程碑是一个带签名的里程碑。关于此里程碑的说明也是再简练不过了。

  ::

    $ git show v2.6.36-rc1
    tag v2.6.36-rc1
    Tagger: Linus Torvalds <torvalds@linux-foundation.org>
    Date:   Sun Aug 15 17:42:10 2010 -0700

    Linux 2.6.36-rc1
    -----BEGIN PGP SIGNATURE-----
    Version: GnuPG v1.4.10 (GNU/Linux)

    iEYEABECAAYFAkxoiWgACgkQF3YsRnbiHLtYKQCfQSIVcj2hvLj6IWgP9xK2FE7T
    bPoAniJ1CjbwLxQBudRi71FvubqPLuVC
    =iuls
    -----END PGP SIGNATURE-----

    commit da5cabf80e2433131bf0ed8993abc0f7ea618c73
    Author: Linus Torvalds <torvalds@linux-foundation.org>
    Date:   Sun Aug 15 17:41:37 2010 -0700

        Linux 2.6.36-rc1

    diff --git a/Makefile b/Makefile
    index 788111d..f3bdff8 100644
    --- a/Makefile
    +++ b/Makefile
    @@ -1,7 +1,7 @@
     VERSION = 2
     PATCHLEVEL = 6
    -SUBLEVEL = 35
    -EXTRAVERSION =
    +SUBLEVEL = 36
    +EXTRAVERSION = -rc1
     NAME = Sheep on Meth
     
     # *DOCUMENTATION*

* 正式发布版去掉了预发布版的后缀。

  ::

    $ git show v2.6.36
    tag v2.6.36
    Tagger: Linus Torvalds <torvalds@linux-foundation.org>
    Date:   Wed Oct 20 13:31:18 2010 -0700

    Linux 2.6.36

    The latest and greatest, and totally bug-free.  At least until 2.6.37
    comes along and shoves it under a speeding train like some kind of a
    bully.
    -----BEGIN PGP SIGNATURE-----
    Version: GnuPG v1.4.10 (GNU/Linux)

    iEYEABECAAYFAky/UcwACgkQF3YsRnbiHLvg/ACffKjAb1fD6fpqcHbSijHHpbP3
    4SkAnR4xOy7iKhmfS50ZrVsOkFFTuBHG
    =JD3z
    -----END PGP SIGNATURE-----

    commit f6f94e2ab1b33f0082ac22d71f66385a60d8157f
    Author: Linus Torvalds <torvalds@linux-foundation.org>
    Date:   Wed Oct 20 13:30:22 2010 -0700

        Linux 2.6.36

    diff --git a/Makefile b/Makefile
    index 7583116..860c26a 100644
    --- a/Makefile
    +++ b/Makefile
    @@ -1,7 +1,7 @@
     VERSION = 2
     PATCHLEVEL = 6
     SUBLEVEL = 36
    -EXTRAVERSION = -rc8
    +EXTRAVERSION =
     NAME = Flesh-Eating Bats with Fangs
     
     # *DOCUMENTATION*

* 正式发布后的升级/修正版本是通过最后一位数字的变动体现的。

  ::

    $ git show v2.6.36.1
    tag v2.6.36.1
    Tagger: Greg Kroah-Hartman <gregkh@suse.de>
    Date:   Mon Nov 22 11:04:17 2010 -0800

    This is the 2.6.36.1 stable release
    -----BEGIN PGP SIGNATURE-----
    Version: GnuPG v2.0.15 (GNU/Linux)

    iEYEABECAAYFAkzqvrIACgkQMUfUDdst+ym9VQCgmE1LK2eC/LE9HkscsxL1X62P
    8F0AnRI28EHENLXC+FBPt+AFWoT9f1N8
    =BX5O
    -----END PGP SIGNATURE-----

    commit bf6ef02e53e18dd14798537e530e00b80435ee86
    Author: Greg Kroah-Hartman <gregkh@suse.de>
    Date:   Mon Nov 22 11:03:49 2010 -0800

        Linux 2.6.36.1

    diff --git a/Makefile b/Makefile
    index 860c26a..dafd22a 100644
    --- a/Makefile
    +++ b/Makefile
    @@ -1,7 +1,7 @@
     VERSION = 2
     PATCHLEVEL = 6
     SUBLEVEL = 36
    -EXTRAVERSION =
    +EXTRAVERSION = .1
     NAME = Flesh-Eating Bats with Fangs
     
     # *DOCUMENTATION*

**Android项目**

看看其他项目的里程碑命名，会发现不同项目关于里程碑的命名各不相同。但是对\
于同一个项目要在里程碑命名上遵照同一标准，并能够和软件版本号正确地对应。

Android项目是一个非常有特色的使用Git版本库的项目，在后面会用两章介绍\
Android项目为Git带来的两个新工具。看看Android项目的里程碑编号对自己版本库\
的管理有无启发。

* 看看Android项目中的里程碑命名，会发现其里程碑的命名格式为\
  ``android-<大版本号>_r<小版本号>``\ 。

  ::

    $ git ls-remote --tags \
      git://android.git.kernel.org/platform/manifest.git \
      android-2.2*
    6a03ae8f564130cbb4a11acfc49bd705df7c8df6        refs/tags/android-2.2.1_r1
    599e242dea48f84e2f26054b0d1721e489043440        refs/tags/android-2.2.1_r1^{}
    656ba6fdbd243153af6ec31017de38641060bf1e        refs/tags/android-2.2_r1
    27cd0e346d1f3420c5747e01d2cb35e9ffd025ea        refs/tags/android-2.2_r1^{}
    f6b7c499be268f1613d8cd70f2a05c12e01bcb93        refs/tags/android-2.2_r1.1
    bd3e9923773006a0a5f782e1f21413034096c4b1        refs/tags/android-2.2_r1.1^{}
    03618e01ec9bdd06fd8fe9afdbdcbaf4b84092c5        refs/tags/android-2.2_r1.2
    ba7111e1d6fd26ab150bafa029fd5eab8196dad1        refs/tags/android-2.2_r1.2^{}
    e03485e978ce1662a1285837f37ed39eadaedb1d        refs/tags/android-2.2_r1.3
    7386d2d07956be6e4f49a7e83eafb12215e835d7        refs/tags/android-2.2_r1.3^{}

* 里程碑的创建过程中使用了专用帐号和GnuPG签名。

  ::

    $ git show android-2.2_r1
    tag android-2.2_r1
    Tagger: The Android Open Source Project <initial-contribution@android.com>
    Date:   Tue Jun 29 11:28:52 2010 -0700

    Android 2.2 release 1
    -----BEGIN PGP SIGNATURE-----
    Version: GnuPG v1.4.6 (GNU/Linux)

    iD8DBQBMKjtm6K0/gZqxDngRAlBUAJ9QwgFbUL592FgRZLTLLbzhKsSQ8ACffQu5
    Mjxg5X9oc+7N1DfdU+pmOcI=
    =0NG0
    -----END PGP SIGNATURE-----

    commit 27cd0e346d1f3420c5747e01d2cb35e9ffd025ea
    Author: The Android Open Source Project <initial-contribution@android.com>
    Date:   Tue Jun 29 11:27:23 2010 -0700

        Manifest for android-2.2_r1

    diff --git a/default.xml b/default.xml
    index 4f21453..aaa26e3 100644
    --- a/default.xml
    +++ b/default.xml
    @@ -3,7 +3,7 @@
       <remote  name="korg"
                fetch="git://android.git.kernel.org/"
                review="review.source.android.com" />
    -  <default revision="froyo"
    +  <default revision="refs/tags/android-2.2_r1"
                remote="korg" />
    ...
