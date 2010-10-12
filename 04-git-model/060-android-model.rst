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

如前所述，repo 是 Google 开发的用于管理 Android 版本库的一个工具。Repo 在 Git 基础之上构建，简化了对多个 Git 版本库的管理。

repo 的使用过程大致如下：

* 运行 `repo init` 命令，克隆 Android 的一个索引库。这个索引库和我们前面假设的“子模组”方式工作的索引库不同，是通过 XML 技术建立的版本库索引。
* 索引库中的 manifest.xml 文件，列出了 160 多个版本库的克隆方式。包括版本库的地址和工作区地址的对应关系，以及分支的对应关系。
* 运行 `repo sync` 命令，开始同步，即分别克隆这 160 多个版本库到本地的工作区中。
* 同时对 160 多个版本库执行切换分支操作，切换到某个分支。


安装 repo 引导脚本
-------------------

首先下载 repo 的引导脚本，你可以使用 wget, curl 甚至浏览器从地址 http://android.git.kernel.org/repo 下载。并把 repo 脚本设置为可执行，并复制到可执行的路径中。在 Linux 上可以用下面的指令将 repo 下载并复制到用户主目录的 bin 目录下。

::

  $ curl http://android.git.kernel.org/repo > ~/bin/repo 
  $ chmod a+x ~/bin/repo

下载并保存 repo 引导脚本后，建立一个工作目录，在工作目录中执行 repo 脚本完成 repo 完整的下载以及项目索引版本库（manifest.git）的下载。

::

  $ mkdir working-directory-name
  $ cd working-directory-name
  $ repo init -u git://android.git.kernel.org/platform/manifest.git 

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

初始化操作会从 android 的代码中克隆 repo.git 库，到当前目录下的 `.repo/repo` 目录下。在完成 repo.git 克隆之后，再次运行 _FindRepo 并把控制权交给找到的 .repo/repo/main.py 脚本文件，重新对 repo 命令进行处理。

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

**索引库是什么？从哪里下载？**

索引库实际上只包含一个 `default.xml` 文件。这个 XML 文件定义了多个版本库和本地地址的映射关系，是 repo 工作的指引文件。所以在使用 repo 引导脚本进行初始化的时候，必须通过 -u 参数指定索引库的源地址。

索引库的下载，是通过 `repo init` 命令初始化时，用 -u 参数指定索引库的位置。例如 repo 针对 Android 代码库进行初始化时执行的命令：

::

  $ repo init -u git://android.git.kernel.org/platform/manifest.git 

Repo 引导脚本的 init 子命令可以使用下列和索引库相关的参数：

TODO 

* 参数 -u ( --manifest-url )
* 参数 -b ( --manifest-branch )
* 参数 --mirror
* 其它参数： 

  - -o ( --origin ) 使用指定的名称作为 remote 名称，否则为 origin。
  - -m ( --manifest-name ) 

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

同步项目
---------


建立 android 代码库本地镜像
----------------------------

从 android 的工作区到代码库镜像
--------------------------------

如果想镜像 Android Repo 代码库，却忘了在 `repo init` 的时候带上 `--mirror` 参数。可以运行下面的脚本 `work2repo.py` 。

脚本 `work2repo.py` 如下：

::

  #!/usr/bin/python

  import re, os, sys
  import shutil

  # 匹配 manifest.xml 中类似这样的行： <project path="device/common" name="device/common" />
  PATTERN = re.compile(ur'^\s*\<project path="(?P<path>[^"]+)" name="(?P<repo>[^"]+)"\s*/?\s*\>\s*$')

  def worktree_to_repo( manifest, work_tree, repo_root):
      work_tree = os.path.realpath( work_tree )
      repo_root = os.path.realpath( repo_root )

      if not os.access( manifest, os.R_OK ):
          print >> sys.stderr, "File %s is not readable." % manifest
          return 1
      f = open( manifest, 'r' )
      for line in f.readlines():
          m = PATTERN.match(line)
          if m:
              # path 是 Android 某模块的本地工作路径下的 .git 目录
              path = os.path.join( work_tree, m.group('path'), ".git" )
              # repo 是 Android 某模块的版本库实际路径
              repo = os.path.join( repo_root, m.group('repo') + ".git" )

              # 移动模块的工作区中的 .git 目录到实际的版本库路径
              if os.path.exists( path ):
                  if not os.path.exists( os.path.dirname(repo) ):
                      os.makedirs( os.path.dirname(repo) )
                  print "Rename %s to %s." % (path, repo)
                  os.rename( path, repo )

              if os.path.exists ( os.path.join( repo, 'config' ) ):
                  # 修改版本库的配置
                  os.chdir( repo )
                  os.system( "git config core.bare true" )
                  os.system( "git config remote.korg.fetch '+refs/heads/*:refs/heads/*'" )

                  # 删除 remotes 分支，因为作为版本库镜像不需要 remote 分支
                  if os.path.exists ( os.path.join( repo, 'refs', 'remotes' ) ):
                      print "Delete " + os.path.join( repo, 'refs', 'remotes' )
                      shutil.rmtree( os.path.join( repo, 'refs', 'remotes' ) )
      return 0

  if len(sys.argv) < 4:
      print >> sys.stderr, "Usage: python %s <manifest.xml> <work_tree> <new_repo_root>" % sys.argv[0]
  else:
      sys.exit( worktree_to_repo( sys.argv[1], sys.argv[2], sys.argv[3] ) )

使用方法如下：

* 首先进入 Android 代码下载的根目录下，创建一个空目录 `android_repos_root` 。

* 如下命令行执行 `work2repo.py` 脚本，将工作区的 .git 目录，重新按照 Android 版本库的命名空间进行组织。

  ::

    $ python work2repo.py .repo/manifest.xml ./ android_repos_root/

* 然后在另外的目录执行 `repo init --mirror` 命令。

* 将原来 android 代码同步的目录中的 android_repos_root/ 下的目录和文件全部移动到新的 Android 同步目录中。

* 执行 `repo sync` 和 Android 上游同步。


好东西不能 android 独享
-----------------------

作为示例，在 github 上放上 repo, manifests.git 库，克隆 topgit, gitolite, gitosis 库。

