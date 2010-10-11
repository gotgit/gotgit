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

如前所述，repo 是 Google 开发的用于管理 Android 版本库的一个工具。当安装好 repo 这一工具后，就可以使用 repo 对 Android 数量众多的版本库进行管理了。

repo 的使用过程大致如下：

* 运行 `repo init` 命令，克隆 Android 的一个索引库。这个索引库和我们前面假设的“子模组”方式工作的索引库不同，是通过 XML 技术建立的版本库索引。
* 索引库中的 manifest.xml 文件，列出了 160 多个版本库的克隆方式。包括版本库的地址和工作区地址的对应关系，以及分支的对应关系。
* 运行 `repo sync` 命令，开始同步，即分别克隆这 160 多个版本库到本地的工作区中。
* 同时对 160 多个版本库执行切换分支操作，切换到某个分支。


安装 repo
----------


解剖 repo
----------

用 repo 获取 android 代码库
----------------------------

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


