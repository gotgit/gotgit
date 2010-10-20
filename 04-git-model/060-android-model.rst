Android 协同模型
================

Android 是谷歌(Google)开发的手持设备的操作系统，提供了当前最为吸引眼球的开源的手机操作平台，大有超越苹果(Apple.com)的专有的 IOS 的趋势。Android 的源代码就是使用 Git 进行维护的。

Android 的源代码的 Git 库有 160 多个（截止置2010年10月）：

* Android 的版本库管理工具 repo：

  git://android.git.kernel.org/tools/repo.git

* 保存GPS 配置文件的版本库

  git://android.git.kernel.org/device/common.git

* 160 个其它的版本库...

如果我要是吧 160 多个版本库都列在这里，恐怕各位的下巴会掉下来。那么为什么 Android 的版本库这么多呢？怎么管理这么复杂的版本库呢？

Android 版本库众多的原因，主要原因是版本库太大以及 Git 不能部分检出。Android 的版本库有接近 2 个GB之多。如果所有的东西都放在一个库中，而某个开发团队感兴趣的可能就是某个驱动，或者是某个应用，却要下载如此庞大的版本库，是有些说不过去。

好了，既然我们接受 Android 有多达 160 多个版本库这一事实，那么 Android 是不是用我们之前介绍的“子模组”方式组织起来的呢？如果真的用“子模组”方式来管理这160个代码库，可能就需要如此管理：

* 建立一个索引版本库，在该版本库中，通过子模组方式，将一个一个的目录对应到 160 多个版本库。
* 当对此索引版本库执行克隆操作后，再执行 `git submodule init` 命令。
* 当执行 `git submodule update` 命令时，开始分别克隆这 160 多个版本库。
* 如果想修改某个版本库中的内容，需要进入到相应的子模组目录，执行切换分支的操作。因为子模组是以某个固定提交的状态存在的，是不能更改的，必须先切换到某个工作分支后，才能进行修改和提交。
* 如果要将所有的子模组都切换到某个分支（如 master）进行修改，必须自己通过脚本对这 160 多个版本库一一切换。
* Android 有多个版本：android-1.0, android-1.5, ..., android-2.2_r1.3, ... 如何维护这么多的版本呢？也许索引库要通过分支和里程碑，和子模组的各个不同的提交状态进行对应。但是由于子模组的状态只是一个提交ID，如何管理分支，我真的给不出答案。

上面是在你拥有 Android 上游版本库提交权限的情况下。但是大部分基于 Android 定制的公司恐怕没有这个权限，就需要在本地建立版本库镜像，协同本地团队的开发，如果采用“子模组”方式，会有多么麻烦呢？

* 要对这 160 多个版本库分别镜像，保存在本地个 Git 服务器中。
* 本地创建一个 Git 索引版本库，并建立这 160 多个版本库的索引。因为URL不同，你不能指望直接把上游的索引库拿来用。
* 本地开发的分支管理，肯定是一团糟。因为子模组无法对应于某个分支或里程碑。

幸好，上面只是假设。聪明的 Google 程序设计师一早就考虑到了 Git 子模组的局限性以及版本库管理的问题，开发出了 repo 这一工具。

关于 repo
----------

Repo 是 Google 开发的用于管理 Android 版本库的一个工具。Repo 并不是用于取代 Git，是用 Python 对 Git 进行了一定的封装，简化了对多个 Git 版本库的管理。对于 repo 管理下的版本库的任何一个，都还是需要使用 Git 命令进行操作。

repo 的使用过程大致如下：

* 运行 `repo init` 命令，克隆 Android 的一个索引库。这个索引库和我们前面假设的“子模组”方式工作的索引库不同，是通过 XML 技术建立的版本库索引。
* 索引库中的 manifest.xml 文件，列出了 160 多个版本库的克隆方式。包括版本库的地址和工作区地址的对应关系，以及分支的对应关系。
* 运行 `repo sync` 命令，开始同步，即分别克隆这 160 多个版本库到本地的工作区中。
* 同时对 160 多个版本库执行切换分支操作，切换到某个分支。


安装 repo 以及索引库的初始化
-----------------------------

首先下载 repo 的引导脚本，你可以使用 wget, curl 甚至浏览器从地址 http://android.git.kernel.org/repo 下载。并把 repo 脚本设置为可执行，并复制到可执行的路径中。在 Linux 上可以用下面的指令将 repo 下载并复制到用户主目录的 bin 目录下。

::

  $ curl http://android.git.kernel.org/repo > ~/bin/repo 
  $ chmod a+x ~/bin/repo

为什么说下载的 repo 只是一个引导文件（bootstrap）而不是直接称为 repo 呢？因为 repo 的大部分功能代码不在其中，下载的只是一个帮助完成整个 repo 程序的继续下载和加载工具。如果你是一个程序员，对 repo 的执行比较好奇，我们可以一起分析一下 repo 引导脚本。否则可以跳到下一节。

看看 repo 引导脚本的前几行（为方便描述，把注释和版权信息过滤掉了），会发现一个神奇的魔法：

::

  1   #!/bin/sh
  2   
  3   REPO_URL='git://android.git.kernel.org/tools/repo.git'
  4   REPO_REV='stable'
  5   
  6   magic='--calling-python-from-/bin/sh--'
  7   """exec" python -E "$0" "$@" """#$magic"
  8   if __name__ == '__main__':
  9     import sys
  10    if sys.argv[-1] == '#%s' % magic:
  11      del sys.argv[-1]
  12  del magic

Repo 引导脚本是用什么语言开发的？这是一个问题。

* 第1行，有经验的 Linux 开发者会知道此脚本是用 Shell 脚本语言开发的。
* 第7行，是这个魔法的最神奇之处。即是一条合法的 shell 语句，又是一条合法的 python 语句。
* 第7行作为 shell 语句，执行 exec，用 python 调用本脚本，并替换本进程。三引号在这里相当于一个空字串和一个单独的引号。
* 第7行作为 python 语句，三引号定义的是一个字符串，字符串后面是一个注释。
* 实际上第1行到第7行，即是合法的 shell 语句又是合法的 python 语句。从第8行开始后面都是 python 脚本了。
* Repo 引导脚本无论是使用 shell 执行，或是用 python 执行，效果都相当于使用 python 执行此脚本。

**Repo 真正的位置在哪里？**

在引导脚本 repo 的 main 函数，首先调用 _FindRepo 函数，从当前目录开始依次向上递归查找 `.repo/repo/main.py` 文件。

::

  def main(orig_args):
    main, dir = _FindRepo()

函数 _FindRepo 返回找到的 `.repo/repo/main.py` 脚本文件，以及包含 repo/main.py 的 `.repo` 目录。如果找到 `.repo/repo/main.py` 脚本，则把程序的控制权交给 `.repo/repo/main.py` 脚本。（省略了在 repo 开发库中执行情况的判断）

在我们下载 repo 引导脚本后，没有初始化之前，当然不会存在 `.repo/repo/main.py` 脚本，这时必须进行初始化操作。

repo 和索引库的初始化
---------------------
下载并保存 repo 引导脚本后，建立一个工作目录，这个工作目录将作为 Android 的工作区目录。在工作目录中执行 `repo init -u <url>` 完成 repo 完整的下载以及项目索引版本库（manifest.git）的下载。

::

  $ mkdir working-directory-name
  $ cd working-directory-name
  $ repo init -u git://android.git.kernel.org/platform/manifest.git 

Repo init 要完成如下操作：

* 完成 repo 这一工具的完整下载，因为现在我们有的不过是 repo 的引导程序。

  初始化操作会从 android 的代码中克隆 repo.git 库，到当前目录下的 `.repo/repo` 目录下。在完成 repo.git 克隆之后，`repo init` 命令会将控制权交给工作区的 `.repo/repo/main.py` 这个刚刚从 repo.git 库克隆来的脚本文件，继续进行初始化。

* 克隆 android 的索引库 manifest.git（地址来自于 -u 参数）。

  克隆的索引库位于 `.repo/manifests.git` 中，并本地克隆到 `.repo/manifests` 。索引文件 `.repo/manifest.xml` 是符号链接指向 `.repo/manifests/default.xml` 。

* 提问用户的姓名和邮件地址，如果和 Git 缺省的用户名、邮件地址不同，则记录在 `.repo/manifests.git` 库的 config 文件中。

* 命令 `repo init` 还可以附带 `--mirror` 参数，以建立和上游 Android 的版本库一模一样的镜像。我们会在后面的章节介绍。

**从哪里下载 repo.git ？**

在 repo 引导脚本的前几行，定义了缺省的 repo.git 的版本库位置以及要检出的缺省分支。

::

  REPO_URL='git://android.git.kernel.org/tools/repo.git'
  REPO_REV='stable'

如果不想从缺省任务获取 repo，或者不想获取稳定版（stable分支）的 repo，可以在 `repo init` 子命令中通过下面的参数覆盖缺省的设置，从指定的源地址克隆 repo 代码库。

TODO 

* 参数 --repo-url
* 参数 --repo-branch
* 参数 --no-repo-verify

实际上，完成 repo.git 版本库的克隆，这个 repo 引导脚本就江郎才尽了，init 子命令的后续处理（以及其它子命令）都交给刚刚克隆出来的 `.repo/repo/main.py` 来继续执行。

**索引库是什么？从哪里下载？**

索引库实际上只包含一个 `default.xml` 文件。这个 XML 文件定义了多个版本库和本地地址的映射关系，是 repo 工作的指引文件。所以在使用 repo 引导脚本进行初始化的时候，必须通过 -u 参数指定索引库的源地址。

索引库的下载，是通过 `repo init` 命令初始化时，用 -u 参数指定索引库的位置。例如 repo 针对 Android 代码库进行初始化时执行的命令：

::

  $ repo init -u git://android.git.kernel.org/platform/manifest.git 

Repo 引导脚本的 init 子命令可以使用下列和索引库相关的参数：

* 参数 -u ( --manifest-url ) ： 设定索引库的 Git 服务器地址。

* 参数 -b ( --manifest-branch ) ： 检出索引库特定分支。

* 参数 --mirror ： 只在 repo 第一次初始化的时候使用，以和 Android 服务器同样的结构在本地建立镜像。

* 参数 -m ( --manifest-name ) ：当有多个索引文件，可以指定索引库的某个索引文件为有效的索引文件。缺省为 default.xml。

Repo 初始化命令（repo init）可以执行多次：

* 不带参数的执行 `repo init` ，从上游的索引库获取新的索引文件 `default.xml` 。
* 使用参数 -u ( --manifest-url ) 执行 `repo init` ，会重新设定上游的索引库地址，并重新同步。
* 使用参数 -b ( --manifest-branch ) 执行 `repo init` ，会使用索引库的不同分支，以便在使用 `repo sync` 时将项目同步到不同的里程碑。
* 但是不能使用 --mirror 命令，该命名只能在第一次初始化时执行。我们会在后面看到一个将工作区转换为版本库镜像的接近方案。

索引库和索引文件
----------------

当执行完毕 `repo init` 之后，工作目录内空空如也。实际上有一个 .repo 目录。在该目录下除了一个包含 repo 的实现的 repo 库克隆外，就是 manifest 库的克隆，以及一个符号链接链接到索引库中的 default.xml 文件。

::

  $ ls -lF .repo/
  drwxr-xr-x 3 jiangxin jiangxin 4096 2010-10-11 18:57 manifests/
  drwxr-xr-x 8 jiangxin jiangxin 4096 2010-10-11 10:08 manifests.git/
  lrwxrwxrwx 1 jiangxin jiangxin   21 2010-10-11 10:07 manifest.xml -> manifests/default.xml
  drwxr-xr-x 7 jiangxin jiangxin 4096 2010-10-11 10:07 repo/

在工作目录下的 `.repo/manifest.xml` 文件就是 Android 项目的众多版本库的索引文件。Repo 命令的操作，都要参考这个索引文件。

我们打开索引文件，会看到如下内容：

::

    1  <?xml version="1.0" encoding="UTF-8"?>
    2  <manifest>
    3    <remote  name="korg"
    4             fetch="git://android.git.kernel.org/"
    5             review="review.source.android.com" />
    6    <default revision="master"
    7             remote="korg" />
    8  
    9    <project path="build" name="platform/build">
   10      <copyfile src="core/root.mk" dest="Makefile" />
   11    </project>
   12  
   13    <project path="bionic" name="platform/bionic" />

         ...
       
  181  </manifest>

这个文件不太复杂，是么？

* 这个XML的顶级元素是 `manifest` ，见第2行和第181行。
* 第3行通过一个 remote 元素，定义了名为 korg（kernel.org缩写）的源，其 Git 库的基址为 `git://android.git.kernel.org/` ，还定义了代码审核服务器的地址 `review.source.android.com` 。还可以定义更多的 remote 元素，这里只定义了一个。
* 第6行用于设置各个项目缺省的远程源地址（remote）为 korg, 缺省的分支为 `master` 。当然各个项目（project元素）可以定义自己的 remote 和 revision 覆盖该缺省配置。
* 第9行定义一个项目，该项目的远程版本库相对路径为："platform/build"，在工作区克隆的位置为："build"。
* 第10行，即 project 元素的子元素 copyfile，定义了项目克隆后的一个附加动作：拷贝文件从 "core/root.mk" 至 "Makefile"。
* 第13行后后续的100多行定义了其它160个项目，都是采用类似的 project 元素语法。name 参数定义远程版本库的相对路径，path 参数定义克隆到本地工作区的路径。
* 还可以出现 manifest-server 元素，其 url 属性定义了通过 XMLRPC 提供实时更新索引的服务器URL。只有当执行 `repo sync --smart-sync` 的时候，才会检查该值，并用动态获取的 manifest 去掉缺省的索引。

同步项目
---------

在工作区，执行下面的命令，会参照 `.repo/manifest.xml` 索引文件，将项目所有相关的版本库全部克隆出来。不过请在读过本节内容之后再尝试执行这条命令。

::

  $ repo sync

对于 Android，这个操作需要通过网络传递接近 2 个GB的内容，如果带宽不是很高的化，可能会花掉几个小时甚至是一天的时间。

也可以仅克隆感兴趣的项目，在 `repo sync` 后面跟上项目的名称。项目的名称来自于 `.repo/manifest.xml` 这个 XML 文件中 project 元素的 name 属性值。例如克隆 platform/build 项目：

::

  $ repo sync platform/build

Repo 有一个功能，我们可以在这里展示。就是 repo 支持通过本地索引文件覆盖缺省的索引文件。即可以在 `.repo` 目录下创建 `local_manifest.xml` 文件覆盖 `.repo/manifest.xml` 文件的设置。

在工作目录下运行下面的命令，可以创建一个 local_manifest.xml。这个本地定制的索引文件来自缺省文件，但是删除了 remote 元素和 default 元素，并将所有的 project 元素都重命名为 remove-project 元素。

::

  $ sed -e '/<remote/,+4 d' -e 's/<project/<remove-project/g' \
    -e 's/project>/remove-project>/g' \
    < .repo/manifest.xml > .repo/local_manifest.xml

这样处理之后，你会发现当执行 `repo sync` 不会检出任何项目，甚至会删除已经下载的项目。

本地定制的索引文件 `local_manifest.xml` 支持前面介绍的索引文件的所有语法，需要注意的是：

* 不能出现重复定义的 remote 元素。这就是为什么上面的脚本要删除来自缺省 manifest.xml 的 remote 元素。
* 不能出现 default 元素，仅为全局仅能有一个。
* 不能出现重复的 project 定义（name 属性不能相同），但是可以通过 remove-project 元素将缺省索引中定义的 project 删除再重新定义。

试着编辑 .repo/local_manifest.xml ，在其中再添加几个 project 元素，然后试着用 `repo sync` 命令进行同步。

If a repo sync shows sync conflicts:

   1. View the files that are unmerged (status code = U).
   2. Edit the conflict regions as necessary.
   3. Change into the relevant project directory, run git add and git commit for the files in question, and then "rebase" the changes. For example:
      $ cd bionic
      $ git add bionic/*
      $ git commit
      $ git rebase --continue

   4. When the rebase is complete start the entire sync again:
      $ repo syncbionic proj2 proj3 ... projN 


Repo 的命令集
--------------

Repo 子命令实际上是 Git 命令的简单或者复杂的封装。每一个 repo 子命令都对应于 repo 源码树中 `subcmds` 目录下的一个同名的 Python 文件。通过阅读代码，我们可以更加深入的了解 repo 子命令的封装。

init 命令
+++++++++
子命令  init，完成的主要是检出索引版本库（manifest.git），并配置 Git 用户的用户名和邮件地址。

实际上，你完全可以进入到 `.repo/manifests` 目录，用 git 命令操作索引库。对 manifests 的修改不会因为执行 `repo init` 而丢失，除非是处于未跟踪状态。

sync 命令
+++++++++
如果某个项目版本库尚不存在，则执行 `repo sync` 命令相当于执行 `git clone` 。

如果项目版本库已经存在，则相当于执行下面的两个命令：

* git remote update

  相当于对每一个 remote 源执行 fetch 操作。

* git rebase origin/branch

  针对当前分支的跟踪分支，执行 rebase 操作。不采用 merge 而是采用 rebase，目的是减少提交数量，方便评审(Gerrit)。

start 命令
+++++++++++

repo start newbranchname [project-list ]

Starts a new branch for development.

The newbranchname argument should provide a short description of the change you are trying to make to the projects.If you don't know, consider using the name default.

The project-list specifies which projects will participate in this topic branch. You can specify project-list as a list of names or a list of paths to local working directories for the projects:
repo start default [proj1 proj2 ... projN ]

"." is a useful shorthand for the project in the current working directory.

status 命令
+++++++++++

repo status [project-list ]

Shows the status of the current working directory. You can specify project-list as a list of names or a list of paths to local source directories for the projects:
repo status [proj1 proj2 ... projN ]

To see the status for only the current branch, run
repo status .

The status information will be listed by project. For each file in the project, a two-letter code is used:

    * In the left-most column, an uppercase letter indicates what is happening in the index (the staged files) when compared to the last committed state.

    * In the next column, a lowercase letter indicates what is happening in the working directory when compared to the index (what is staged).

Character   Meaning
A   The file is added (brand new). Can only appear in the first column.
M or m
  The file already exists but has been modified in some way.
D or d
  The file has been deleted.
R   The file has been renamed. Can only appear in the first column. The new name is also shown on the line.
C   The file has been copied from another file. Can only appear in the first column. The source is also shown.
T   Only the file's mode (executable or not) has been changed. Can only appear in the first column.
U   The file has merge conflicts and is still unmerged. Can only appear in the first column.
-   The file state is unmodified. A hyphen in bothcolumns means this is a new file, unknown to Git. After you run git add on this file, repo status will show A-, indicating the file has been added.

For example, if you edit the file main.py within the appeng project without staging the changes, then repo status might show

project appeng/
-mmain.py

If you go on to stage the changes to main.py by running git add, then repo status might show

project appeng/
M- main.py

If you then make further edits to the already-staged main.py and make edits to another file within the project, app.yaml, then repo status might show

project appeng/
-mapp.yaml
Mm main.py 

branches 命令
+++++++++++++

diff 命令
+++++++++++++

prune 命令
+++++++++++++
repo prune [project-list ]

Prunes (deletes) topics that are already merged.

You can specify project-list as a list of names or a list of paths to local source directories for the projects:
repo prune [proj1 proj2 ... projN ]

upload 命令
++++++++++++


download 命令
++++++++++++++

download
repo download target change

Downloads the specified change into the specified local directory. (Added to Repo as of version 1.0.4.)

For example, to download change 1241 into your platform/frameworks/base directory:
$ repo download platform/frameworks/base 1241

A"repo sync"should effectively remove any commits retrieved via "repo download".Or, you can check out the remote branch; e.g., "git checkout m/master".

Note: As of Jan. 26, 2009, there is a mirroring lag of approximately 5 minutes between when a change is visible on the web in Gerrit and when repo download will be able to find it, because changes are actually downloaded off the git://android.git.kernel.org/ mirror farm. There will always be a slight mirroring lag as Gerrit pushes newly uploaded changes out to the mirror farm.

forall 迭代器
++++++++++++++

forall
repo forall [project-list ] -c command [arg. ..]

Runs a shell command in each project.

You can specify project-list as a list of names or a list of paths to local source directories for the projects



Gerrit —— Repo 的评审服务器
---------------------------

https://review.source.android.com/Documentation/user-upload.html


建立 android 代码库本地镜像
----------------------------

Android 的代码库众多而且庞大，如果一个开发团队每个人都去执行 `repo init -u` ，再执行 `repo sync` 从 Android 服务器克隆版本库的话，多大的网络带宽恐怕都不够用。唯一的办法是本地建立一个 Android 版本库的镜像。

建立本地镜像非常简单，就是在执行 `repo init -u` 初始化的时候，附带上 `--mirror` 参数。

::

  $ mkdir android-mirror-dir
  $ cd android-mirror-dir
  $ repo init --mirror -u git://android.git.kernel.org/platform/manifest.git 

之后执行 `repo sync` 就可以安装 Android 的 Git 服务器方式来组织版本库，创建一个 Android 版本库镜像。

实际上附带了 `--mirror` 参数执行 `repo init -u` 命令，会在克隆的 `.repo/manifests.git` 下的 `config` 中记录配置信息：

::

  [repo]
      mirror = true

从 android 的工作区到代码库镜像
--------------------------------

当执行 `repo sync` 命令将 android 众多的版本库克隆到本地后，各个项目在工作区中的部署和实际在服务器端的部署是不同的。这个在之前介绍 repo 的索引库机制的时候，就已经介绍过了。

当 repo 工作区使用不带 `--mirror` 的 `repo init -u` 初始化并完成同步后，如果再次执行 `repo init` 并附带了 `--mirror` 参数，repo 会报错退出："fatal: --mirror not supported on existing client"。实际上 "--mirror" 参数只能对尚未初始化的 repo 工作区执行。

那么如果之前没有用镜像的方法同步 Android 版本库，难道要为创建代码库镜像在重新执行一次 repo 同步么？要知道重新同步一份 Android 版本库是非常慢的。我自己就遇到了这个问题。

不过既然有 manifest.xml 文件，我们完全可以对工作区进行反向操作，将工作区转换为镜像服务器的结构。下面就是一个示例脚本，这个脚本利用了已有的 repo 代码进行实现，所以看着很简洁。 8-)

脚本 `work2mirror.py` 如下：

::

  #!/usr/bin/python
  # -*- coding: utf-8 -*-

  import os, sys, shutil

  cwd = os.path.abspath( os.path.dirname( __file__ ) )
  repodir = os.path.join( cwd, '.repo' )
  S_repo = 'repo'
  TRASHDIR = 'old_work_tree'

  if not os.path.exists( os.path.join(repodir, S_repo) ):
      print >> sys.stderr, "Must run under repo work_dir root."
      sys.exit(1)

  sys.path.insert( 0, os.path.join(repodir, S_repo) )
  from manifest_xml import XmlManifest

  manifest = XmlManifest( repodir )

  if manifest.IsMirror:
      print >> sys.stderr, "Already mirror, exit."
      sys.exit(1)

  trash = os.path.join( cwd, TRASHDIR )

  for project in manifest.projects.itervalues():
      # 移动旧的版本库路径到镜像模式下新的版本库路径
      newgitdir = os.path.join( cwd, '%s.git' % project.name )
      if os.path.exists( project.gitdir ) and project.gitdir != newgitdir:
          if not os.path.exists( os.path.dirname(newgitdir) ):
              os.makedirs( os.path.dirname(newgitdir) )
          print "Rename %s to %s." % (project.gitdir, newgitdir)
          os.rename( project.gitdir, newgitdir )

      # 移动工作区到待删除目录
      if project.worktree and os.path.exists( project.worktree ):
          newworktree = os.path.join( trash, project.relpath )
          if not os.path.exists( os.path.dirname(newworktree) ):
              os.makedirs( os.path.dirname(newworktree) )
          print "Move old worktree %s to %s." % (project.worktree, newworktree )
          os.rename( project.worktree, newworktree )

      if os.path.exists ( os.path.join( newgitdir, 'config' ) ):
          # 修改版本库的配置
          os.chdir( newgitdir )
          os.system( "git config core.bare true" )
          os.system( "git config remote.korg.fetch '+refs/heads/*:refs/heads/*'" )

          # 删除 remotes 分支，因为作为版本库镜像不需要 remote 分支
          if os.path.exists ( os.path.join( newgitdir, 'refs', 'remotes' ) ):
              print "Delete " + os.path.join( newgitdir, 'refs', 'remotes' )
              shutil.rmtree( os.path.join( newgitdir, 'refs', 'remotes' ) )

  # 设置 menifest 为镜像
  mp = manifest.manifestProject
  mp.config.SetString('repo.mirror', 'true')


使用方法很简单，只要将脚本放在 Android 工作区下，执行就可以了。执行完毕会将原有工作区的目录移动到 `old_work_tree` 子目录下，在确认原有工作区没有未提交的数据后，直接删除 `old_work_tree` 即可。

::

  $ python work2mirror.py

Android 本地代码库镜像的管理
--------------------------------

镜像服务器定期和 Android 上游进行同步，因为保持了同样的分支命名空间，因此 Android 的 manifest.git 库仍然可以对镜像服务器的 Git 库使用，除了需要将 remote 中的内容进行调整。

不要在 Android 代码库中现有的任何分支中提交，以免和镜像服务器在同步的时候改动被覆盖。而是创立带有本团队标识的分支名维护自己的代码。

需要创建一个自己的 manifest 库。可以参考 Android 上游的 manifest 库创建。



好东西不能 android 独享
-----------------------

作为示例，在 github 上放上 repo, manifests.git 库，克隆 topgit, gitolite, gitosis 库。

