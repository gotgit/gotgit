Git 里程碑
**********

里程碑即 Tag，是人为对提交进行的命名。这和 Git 的提交ID是否太长无关，使用任何数字都没有使用一个直观的表意的字符串表示提交来得方便。例如：里程碑 v2.1 显然对应于软件的 2.1 发布版本。

里程碑实际上我们并不陌生，在第2部分的“Git基本操作”中，就介绍了使用里程碑来对工作进度“留影”纪念，并使用 `git describe` 命令显示里程碑和提交ID的组合来代表软件的版本号。本章介绍里程碑存在的三种不同形式：轻量级里程碑、带注释的里程碑和带签名的里程碑，还会介绍关于里程碑的各种操作。

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
    $ git describe 384f1e0d5106c9c6033311a608b91c69332fe0a8
    jx/v2.2

* 若提交没有对应的里程碑，但是在某个历史提交上建有里程碑，则使用类似 `<tag>-<num>-g<commit>` 的格式显示。

  其中 `<tag>` 是最接近的历史提交的里程碑名字， `<num>` 是该里程碑和提交之间的距离， `<commit>` 是该提交的精简提交ID。

  ::

    $ git describe 610e78fc95bf2324dc5595fa684e08e1089f5757
    jx/v2.2-1-g610e78f

* 如果工作区对文件有修改，还会加上 `-dirty` 后缀。

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

**轻量级里程碑**

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

  $ git cat-file -t 60a2f4f31e5dddd777c6ad37388fe6e5520734cb
  commit

* 查看该提交的内容，发现就是刚刚进行的空提交。

  ::

    $ git cat-file -p 60a2f4f31e5dddd777c6ad37388fe6e5520734cb
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

**带说明的里程碑**


**带签名的里程碑**

-s

-u

-v 校验里程碑

项目 repo 对 GPG 签名的使用。

删除里程碑
=============

不要随意更改里程碑
==================



里程碑管理规范
===============



