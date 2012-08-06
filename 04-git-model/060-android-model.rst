Android式多版本库协同
**********************

Android是谷歌（Google）开发的适合手持设备的操作系统，提供了当前最为吸引\
眼球的开源的手机操作平台，大有超越苹果（Apple.com）的专有的iOS的趋势。而\
Android的源代码就是使用Git进行维护的。Android项目在使用Git进行源代码管理\
上有两个伟大的创造，一个是用Python语言开发名为repo的命令行工具用于多版本\
库的管理，另外一个是用Java开发的名为Gerrit的代码审核服务器。本节重点介绍\
repo是如何管理多代码库的。

Android的源代码的Git库有160多个（截止至2010年10月）：

* Android的版本库管理工具repo：

  git://android.git.kernel.org/tools/repo.git

* 保存GPS配置文件的版本库

  git://android.git.kernel.org/device/common.git

* 160多个其他的版本库...

如果要是把160多个版本库都列在这里，恐怕各位的下巴会掉下来。那么为什么\
Android的版本库这么多呢？怎么管理这么复杂的版本库呢？

Android版本库众多的原因，主要原因是版本库太大以及Git不能部分检出。Android\
的版本库有接近2个GB之多。如果所有的东西都放在一个库中，而某个开发团队感\
兴趣的可能就是某个驱动，或者是某个应用，却要下载如此庞大的版本库，是有些\
说不过去。

好了，既然接受了Android有多达160多个版本库这一事实，那么Android是不是用\
之前介绍的“子模组”方式组织起来的呢？如果真的用“子模组”方式来管理这160个\
代码库，可能就需要如此管理：

* 建立一个索引版本库，在该版本库中，通过子模组方式，将一个一个的目录对应\
  到160多个版本库。

* 当对此索引版本库执行克隆操作后，再执行\ :command:`git submodule init`\
  命令。

* 当执行\ :command:`git submodule update`\ 命令时，开始分别克隆这160多个\
  版本库。

* 如果想修改某个版本库中的内容，需要进入到相应的子模组目录，执行切换分支\
  的操作。因为子模组是以某个固定提交的状态存在的，是不能更改的，必须先切换\
  到某个工作分支后，才能进行修改和提交。

* 如果要将所有的子模组都切换到某个分支（如master）进行修改，必须自己通过\
  脚本对这160多个版本库一一切换。

* Android有多个版本：android-1.0、android-1.5、...、android-2.2_r1.3、...\
  如何维护这么多的版本呢？也许索引库要通过分支和里程碑，和子模组的各个不\
  同的提交状态进行对应。但是由于子模组的状态只是一个提交ID，如何能够动态\
  指定到分支，真的给不出答案。

幸好，上面只是假设。聪明的Android程序设计师一早就考虑到了Git子模组的局限\
性以及多版本库管理的问题，开发出了repo这一工具。

关于repo有这么一则小故事：Android之父安迪·鲁宾在回应乔布斯关于Android太\
开放导致开发维护更麻烦的言论时，在Twitter（\ http://twitter.com/Arubin\ ）\
上留了下面这段简短的话：

::

  the definition of open: "mkdir android ; cd android ; repo init -u git://android.git.kernel.org/platform/manifest.git ; repo sync ; make"

是的，就是repo让Android的开发变得如此简单。

关于repo
==========

Repo是Google开发的用于管理Android版本库的一个工具。Repo并不是用于取代Git，\
是用Python对Git进行了一定的封装，简化了对多个Git版本库的管理。对于repo管理\
的任何一个版本库，都还是需要使用Git命令进行操作。

repo的使用过程大致如下：

* 运行\ :command:`repo init`\ 命令，克隆Android的一个清单库。这个清单库\
  和前面假设的“子模组”方式工作的索引库不同，是通过XML技术建立的版本库清单。

* 清单库中的\ :file:`manifest.xml`\ 文件，列出了160多个版本库的克隆方式。\
  包括版本库的地址和工作区地址的对应关系，以及分支的对应关系。

* 运行\ :command:`repo sync`\ 命令，开始同步，即分别克隆这160多个版本库\
  到本地的工作区中。

* 同时对160多个版本库执行切换分支操作，切换到某个分支。

安装repo
==========

首先下载repo的引导脚本，可以使用wget、curl甚至浏览器从地址\
http://android.git.kernel.org/repo\ 下载。把repo脚本设置为可执行，并复制\
到可执行的路径中。在Linux上可以用下面的指令将repo下载并复制到用户主目录的\
:file:`bin`\ 目录下。

::

  $ curl http://android.git.kernel.org/repo > ~/bin/repo 
  $ chmod a+x ~/bin/repo

为什么说下载的repo只是一个引导脚本（bootstrap）而不是直接称为repo呢？因\
为repo的大部分功能代码不在其中，下载的只是一个帮助完成整个repo程序的继续\
下载和加载工具。如果您是一个程序员，对repo的执行比较好奇，可以一起分析一\
下repo引导脚本。否则可以跳到下一节。

看看repo引导脚本的前几行（为方便描述，把注释和版权信息过滤掉了），会发现\
一个神奇的魔法：

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

Repo引导脚本是用什么语言开发的？这是一个问题。

* 第1行，有经验的Linux开发者会知道此脚本是用Shell脚本语言开发的。

* 第7行，是这个魔法的最神奇之处。既是一条合法的shell语句，又是一条合法的\
  python语句。

* 第7行作为shell语句，执行\ :command:`exec`\ ，用python调用本脚本，并替\
  换本进程。三引号在这里相当于一个空字串和一个单独的引号。

* 第7行作为python语句，三引号定义的是一个字符串，字符串后面是一个注释。

* 实际上第1行到第7行，即是合法的shell语句又是合法的python语句。从第8行开\
  始后面都是python脚本了。

* Repo引导脚本无论是使用shell执行，或是用python执行，效果都相当于使用\
  python执行此脚本。

**Repo真正的位置在哪里？**

在引导脚本repo的\ ``main``\ 函数，首先调用\ `` _FindRepo``\ 函数，从当前\
目录开始依次向上递归查找\ :file:`.repo/repo/main.py`\ 文件。

::

  def main(orig_args):
    main, dir = _FindRepo()

函数\ ``_FindRepo``\ 返回找到的\ :file:`.repo/repo/main.py`\ 脚本文件，\
以及包含\ :file:`repo/main.py`\ 的\ :file:`.repo`\ 目录。如果找到\
:file:`.repo/repo/main.py`\ 脚本，则把程序的控制权交给\
:file:`.repo/repo/main.py`\ 脚本。（省略了在repo开发库中执行情况的判断）

在下载repo引导脚本后，没有初始化之前，当然不会存在\ :file:`.repo/repo/main.py`\
脚本，这时必须进行初始化操作。

repo和清单库的初始化
=====================
下载并保存repo引导脚本后，建立一个工作目录，这个工作目录将作为Android的\
工作区目录。在工作目录中执行\ :command:`repo init -u <url>`\ 完成repo完\
整的下载以及项目清单版本库（manifest.git）的下载。

::

  $ mkdir working-directory-name
  $ cd working-directory-name
  $ repo init -u git://android.git.kernel.org/platform/manifest.git 

命令\ :command:`repo init`\ 要完成如下操作：

* 完成repo这一工具的完整下载，因为现在有的不过是repo的引导程序。

  初始化操作会从Android的代码中克隆\ ``repo.git``\ 库，到当前目录下的\
  :file:`.repo/repo`\ 目录下。在完成repo.git克隆之后，\ `repo init`\ 命令\
  会将控制权交给工作区的\ :file:`.repo/repo/main.py`\ 这个刚刚从\
  ``repo.git``\ 库克隆来的脚本文件，继续进行初始化。

* 克隆 android 的清单库 manifest.git（地址来自于 -u 参数）。

  克隆的清单库位于\ :file:`.repo/manifests.git`\ 中，并本地克隆到\
  :file:`.repo/manifests`\ 。清单文件\ :file:`.repo/manifest.xml`\ 是符号\
  链接指向\ :file:`.repo/manifests/default.xml`\ 。

* 提问用户的姓名和邮件地址，如果和Git缺省的用户名、邮件地址不同，则记录在\
  :file:`.repo/manifests.git`\ 库的 config 文件中。

* 命令\ :command:`repo init`\ 还可以附带\ ``--mirror``\ 参数，以建立和\
  上游Android的版本库一模一样的镜像。会在后面的章节介绍。

**从哪里下载repo.git？**

在repo引导脚本的前几行，定义了缺省的repo.git的版本库位置以及要检出的缺省\
分支。

::

  REPO_URL='git://android.git.kernel.org/tools/repo.git'
  REPO_REV='stable'

如果不想从缺省任务获取repo，或者不想获取稳定版（stable分支）的repo，可以\
在\ :command:`repo init`\ 命令中通过下面的参数覆盖缺省的设置，从指定的源\
地址克隆repo代码库。

* 参数\ ``--repo-url``\ ，用于设定repo的版本库地址。

* 参数\ ``--repo-branch``\ ，用于设定要检出的分支。

* 参数\ ``--no-repo-verify``\ ，设定不要对repo的里程碑签名进行严格的验证。

实际上，完成\ ``repo.git``\ 版本库的克隆，这个repo引导脚本就江郎才尽了，\
\ ``init``\ 命令的后续处理（以及其他命令）都交给刚刚克隆出来的\
:file:`.repo/repo/main.py`\ 来继续执行。

**清单库是什么？从哪里下载？**

清单库实际上只包含一个\ :file:`default.xml`\ 文件。这个XML文件定义了多个\
版本库和本地地址的映射关系，是repo工作的指引文件。所以在使用repo引导脚本\
进行初始化的时候，必须通过\ ``-u``\ 参数指定清单库的源地址。

清单库的下载，是通过\ :command:`repo init`\ 命令初始化时，用\ ``-u``\
参数指定清单库的位置。例如repo针对Android代码库进行初始化时执行的命令：

::

  $ repo init -u git://android.git.kernel.org/platform/manifest.git 

Repo引导脚本的\ `` init``\ 命令可以使用下列和清单库相关的参数：

* 参数\ ``-u``\ （\ ``--manifest-url``\ ）：设定清单库的Git服务器地址。

* 参数\ ``-b``\ （\ ``--manifest-branch``\ ）：检出清单库特定分支。

* 参数\ ``--mirror``\ ：只在repo第一次初始化的时候使用，以和Android服务\
  器同样的结构在本地建立镜像。

* 参数\ ``-m``\ （\ ``--manifest-name``\ ）：当有多个清单文件，可以指定\
  清单库的某个清单文件为有效的清单文件。缺省为\ :file:`default.xml`\ 。

Repo初始化命令（repo init）可以执行多次：

* 不带参数的执行\ :command:`repo init`\ ，从上游的清单库获取新的清单文件\
  :file:`default.xml`\ 。

* 使用参数\ ``-u``\ （\ ``--manifest-url``\ ）执行\ :command:`repo init`\ ，\
  会重新设定上游的清单库地址，并重新同步。

* 使用参数\ ``-b``\ （\ ``--manifest-branch``\ ）执行\ :command:`repo init`\ ，\
  会使用清单库的不同分支，以便在使用\ :command:`repo sync`\ 时将项目同步\
  到不同的里程碑。

* 但是不能使用\ ``--mirror``\ 命令，该命名只能在第一次初始化时执行。那么\
  如何将已经按照工作区模式同步的版本库转换为镜像模式呢？会在后面看到一个\
  解决方案。

清单库和清单文件
================

当执行完毕\ :command:`repo init`\ 之后，工作目录内空空如也。实际上有一个\
:file:`.repo`\ 目录。在该目录下除了一个包含repo的实现的repo库克隆外，\
就是manifest库的克隆，以及一个符号链接链接到清单库中的\ :file:`default.xml`\ 文件。

::

  $ ls -lF .repo/
  drwxr-xr-x 3 jiangxin jiangxin 4096 2010-10-11 18:57 manifests/
  drwxr-xr-x 8 jiangxin jiangxin 4096 2010-10-11 10:08 manifests.git/
  lrwxrwxrwx 1 jiangxin jiangxin   21 2010-10-11 10:07 manifest.xml -> manifests/default.xml
  drwxr-xr-x 7 jiangxin jiangxin 4096 2010-10-11 10:07 repo/

在工作目录下的\ :file:`.repo/manifest.xml`\ 文件就是Android项目的众多版\
本库的清单文件。Repo命令的操作，都要参考这个清单文件。

打开清单文件，会看到如下内容：

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

* 这个XML的顶级元素是\ ``manifest``\ ，见第2行和第181行。

* 第3行通过一个remote元素，定义了名为korg（kernel.org缩写）的源，其Git库\
  的基址为\ ``git://android.git.kernel.org/``\ ，还定义了代码审核服务器\
  的地址\ ``review.source.android.com``\ 。还可以定义更多的remote元素，\
  这里只定义了一个。

* 第6行用于设置各个项目缺省的远程源地址（remote）为korg，缺省的分支为\
  ``master``\ 。当然各个项目（project元素）可以定义自己的remote和revision\
  覆盖该缺省配置。

* 第9行定义一个项目，该项目的远程版本库相对路径为："platform/build"，在\
  工作区克隆的位置为："build"。

* 第10行，即project元素的子元素copyfile，定义了项目克隆后的一个附加动作：\
  拷贝文件从\ :file:`core/root.mk`\ 至\ :file:`Makefile`\ 。

* 第13行后后续的100多行定义了其他160个项目，都是采用类似的project元素语法。\
  ``name``\ 参数定义远程版本库的相对路径，\ ``path``\ 参数定义克隆到本地\
  工作区的路径。

* 还可以出现\ ``manifest-server``\ 元素，其\ ``url``\ 属性定义了通过XMLRPC\
  提供实时更新清单的服务器URL。只有当执行\ :command:`repo sync --smart-sync`\
  的时候，才会检查该值，并用动态获取的manifest覆盖掉缺省的清单。

同步项目
=========

在工作区，执行下面的命令，会参照\ :file:`.repo/manifest.xml`\ 清单文件，\
将项目所有相关的版本库全部克隆出来。不过最好请在读完本节内容之后再尝试执\
行这条命令。

::

  $ repo sync

对于Android，这个操作需要通过网络传递接近2个GB的内容，如果带宽不是很高的\
话，可能会花掉几个小时甚至是一天的时间。

也可以仅克隆感兴趣的项目，在\ :command:`repo sync`\ 后面跟上项目的名称。\
项目的名称来自于\ :file:`.repo/manifest.xml`\ 这个XML文件中project元素的\
name属性值。例如克隆\ ``platform/build``\ 项目：

::

  $ repo sync platform/build

Repo有一个功能可以在这里展示。就是repo支持通过本地清单，对缺省的清单文件\
进行补充以及覆盖。即可以在\ :file:`.repo`\ 目录下创建\
:file:`local_manifest.xml`\ 文件，其内容会和\ :file:`.repo/manifest.xml`\
文件的内容进行合并。

在工作目录下运行下面的命令，可以创建一个本地清单文件。这个本地定制的清单\
文件来自缺省文件，但是删除了\ ``remote``\ 元素和\ ``default``\ 元素，并\
将所有的\ ``project``\ 元素都重命名为\ ``remove-project``\ 元素。这实际\
相当于对原有的清单文件“取反”。

::

  $ sed -e '/<remote/,+4 d' -e 's/<project/<remove-project/g' \
    -e 's/project>/remove-project>/g' \
    < .repo/manifest.xml > .repo/local_manifest.xml

用下面的这条命令可以看到repo运行时实际获取到的清单。这个清单来自于\
:file:`.repo/manifest.xml`\ 和\ :file:`.repo/local_manifest.xml`\ 两个文件\
的汇总。

::

  $ repo manifest -o -

当执行\ :command:`repo sync`\ 命令时，实际上就是依据合并后的清单文件进行\
同步。如果清单中的项目被自定义清单全部“取反”，执行同步就不会同步任何项目，\
甚至会删除已经完成同步的项目。

本地定制的清单文件\ :file:`local_manifest.xml`\ 支持前面介绍的清单文件的\
所有语法，需要注意的是：

* 不能出现重复定义的\ ``remote``\ 元素。这就是为什么上面的脚本要删除来自\
  缺省\ ``manifest.xml``\ 的\ ``remote``\ 元素。

* 不能出现\ ``default``\ 元素，仅为全局仅能有一个。

* 不能出现重复的\ ``project``\ 定义（\ ``name``\ 属性不能相同），但是可\
  以通过\ ``remove-project``\ 元素将缺省清单中定义的\ ``project``\ 删除\
  再重新定义。

试着编辑\ :file:`.repo/local_manifest.xml`\ ，在其中再添加几个\ ``project``\
元素，然后试着用\ :command:`repo sync`\ 命令进行同步。

建立Android代码库本地镜像
============================

Android为企业提供一个新的市场，无论大企业，小企业都是处于同一个起跑线上。\
研究Android尤其是Android系统核心或者是驱动的开发，首先需要做的就是本地\
克隆建立一套Android版本库管理机制。因为Android的代码库是那么庞杂，如果\
一个开发团队每个人都去执行\ :command:`repo init -u`\ ，再执行\
:command:`repo sync`\ 从Android服务器克隆版本库的话，多大的网络带宽恐怕都\
不够用。唯一的办法是本地建立一个Android版本库的镜像。

建立本地镜像非常简单，就是在执行\ :command:`repo init -u`\ 初始化的时候，\
附带上\ ``--mirror``\ 参数。

::

  $ mkdir android-mirror-dir
  $ cd android-mirror-dir
  $ repo init --mirror -u git://android.git.kernel.org/platform/manifest.git 

之后执行\ :command:`repo sync`\ 就可以安装Android的Git服务器方式来组织\
版本库，创建一个Android版本库镜像。

实际上附带了\ ``--mirror``\ 参数执行\ :command:`repo init -u`\ 命令，\
会在克隆的\ :file:`.repo/manifests.git`\ 下的\ :file:`config`\ 中记录\
配置信息：

::

  [repo]
      mirror = true

**从Android的工作区到代码库镜像**

在初始化repo工作区时，如果使用不带\ ``--mirror``\ 参数的\
:command:`repo init -u`\ ，并完成代码同步后，如果再次执行\
:command:`repo init`\ 并附带了\ ``--mirror``\ 参数，repo 会报错退出：\
“fatal: --mirror not supported on existing client”。实际上\
``--mirror``\ 参数只能对尚未初始化的repo工作区执行。

那么如果之前没有用镜像的方法同步Android版本库，难道要为创建代码库镜像再\
重新执行一次repo同步么？要知道重新同步一份Android版本库是非常慢的。我就\
遇到了这个问题。

不过既然有\ :file:`manifest.xml``\ 文件，完全可以对工作区进行反向操作，\
将工作区转换为镜像服务器的结构。下面就是一个示例脚本，这个脚本利用了已有\
的repo代码进行实现，所以看着很简洁。8-)

脚本\ :file:`work2mirror.py`\ 如下：

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
          if os.path.exists ( os.path.join( newgitdir, 'refs', 'remotes' ):
              print "Delete " + os.path.join( newgitdir, 'refs', 'remotes' )
              shutil.rmtree( os.path.join( newgitdir, 'refs', 'remotes') )

  # 设置 menifest 为镜像
  mp = manifest.manifestProject
  mp.config.SetString('repo.mirror', 'true')


使用方法很简单，只要将脚本放在Android工作区下，执行就可以了。执行完毕会\
将原有工作区的目录移动到\ :file:`old_work_tree`\ 子目录下，在确认原有工\
作区没有未提交的数据后，直接删除\ :file:`old_work_tree`\ 即可。

::

  $ python work2mirror.py

**创建新的清单库，或修改原有清单库**

建立了Android代码库的本地镜像后，如果不对\ ``manifest``\ 清单版本库进行\
定制，在使用\ :command:`repo sync`\ 同步代码的时候，仍然使用Android官方\
的代码库同步代码，使得本地的镜像版本库形同虚设。解决办法是创建一个自己的\
``manifest``\ 库，或者在原有清单库中建立一个分支加以修改。如果创建新的\
清单库，参考Android上游的\ ``manifest``\ 清单库进行创建。

Repo的命令集
==============

Repo命令实际上是Git命令的简单或者复杂的封装。每一个repo命令都对应于repo\
源码树中\ :file:`subcmds`\ 目录下的一个同名的Python脚本。每一个repo命令\
都可以通过下面的命令获得帮助。

::

  $ repo help <command>

通过阅读代码，可以更加深入的了解repo命令的封装。

:command:`repo init`\ 命令
--------------------------------

:command:`repo init`\ 命令，主要完成检出清单版本库（\ ``manifest.git``\ ），\
以及配置Git用户的用户名和邮件地址的工作。

实际上，完全可以进入到\ :file:`.repo/manifests`\ 目录，用git命令操作清单\
库。对\ ``manifests``\ 的修改不会因为执行\ :command:`repo init`\ 而丢失，\
除非是处于未跟踪状态。

:command:`repo sync`\ 命令
--------------------------------

:command:`repo sync`\ 命令用于参照清单文件克隆或者同步版本库。如果某个项\
目版本库尚不存在，则执行\ :command:`repo sync`\ 命令相当于执行\
:command:`git clone`\ 。如果项目版本库已经存在，则相当于执行下面的两个命令：

* git remote update

  相当于对每一个remote源执行\ ``fetch``\ 操作。

* git rebase origin/branch

  针对当前分支的跟踪分支，执行\ ``rebase``\ 操作。不采用\ ``merge``\
  而是采用\ ``rebase``\ ，目的是减少提交数量，方便评审(Gerrit)。

:command:`repo start`\ 命令
--------------------------------

:command:`repo start`\ 命令实际上是对\ :command:`git checkout -b`\ 命令\
的封装。为指定的项目或者所有项目（若使用\ ``--all``\ 参数），以清单文件\
中为项目设定的分支或里程碑为基础，创建特性分支。特性分支的名称由命令的第\
一个参数指定。相当于执行\ :command:`git checkout -b`\ 。

用法:

::

  repo start <newbranchname> [--all | <project>...]

:command:`repo status`\ 命令
------------------------------------

:command:`repo status`\ 命令实际上是对\ :command:`git diff-index`\ 、\
:command:`git diff-files`\ 命令的封装，同时显示暂存区的状态和本地文件\
修改的状态。

用法：

::

  repo status [<project>...]


示例输出：

::

  project repo/                                   branch devwork
   -m     subcmds/status.py
   ...

上面示例输出显示了repo项目的\ ``devwork``\ 分支的修改状态。

* 每个小节的首行显示项目名称，以及所在分支名称。

* 之后显示该项目中文件变更状态。头两个字母显示变更状态，后面显示文件名\
  或者其他变更信息。

* 第一个字母表示暂存区的文件修改状态。

  其实是\ :command:`git-diff-index`\ 命令输出中的状态标识，并用大写显示。

  - ``-``\ ：没有改变
  - ``A``\ ：添加          （不在HEAD中，  在暂存区                ）
  - ``M``\ ：修改          （  在HEAD中，  在暂存区，内容不同      ）
  - ``D``\ ：删除          （  在HEAD中，不在暂存区                ）
  - ``R``\ ：重命名        （不在HEAD中，  在暂存区，路径修改      ）
  - ``C``\ ：拷贝          （不在HEAD中，  在暂存区，从其他文件拷贝）
  - ``T``\ ：文件状态改变  （  在HEAD中，  在暂存区，内容相同      ）
  - ``U``\ ：未合并，需要冲突解决

* 第二个字母表示工作区文件的更改状态。

  其实是\ :command:`git-diff-files`\ 命令输出中的状态标识，并用小写显示。

  - ``-``\ ：新/未知       （不在暂存区，  在工作区                ）
  - ``m``\ ：修改          （  在暂存区，  在工作区，被修改        ）
  - ``d``\ ：删除          （  在暂存区，不在工作区                ）

* 两个表示状态的字母后面，显示文件名信息。如果有文件重命名还会显示改变\
  前后的文件名以及文件的相似度。

:command:`repo checkout`\ 命令
-----------------------------------

:command:`repo checkout`\ 命令实际上是对\ :command:`git checkout`\ 命令\
的封装。检出之前由\ :command:`repo start`\ 创建的分支。

用法：

::

  repo checkout <branchname> [<project>...]

:command:`repo branches`\ 命令
-----------------------------------

:command:`repo branches`\ 命令读取各个项目的分支列表并汇总显示。该命令实\
际上是通过直接读取\ :file:`.git/refs`\ 目录下的引用来获取分支列表，以及\
分支的发布状态等。

用法：

::

  repo branches [<project>...]


输出示例：

::

  *P nocolor                   | in repo
     repo2                     |

* 第一个字段显示分支的状态：是否是当前分支，分支是否发布到代码审核服务器上？

* 第一个字母若显示星号(*)，含义是此分支为当前分支

* 第二个字母若为大写字母\ ``P``\ ，则含义是分支所有提交都发布到代码审核\
  服务器上了。

* 第二个字母若为小写字母\ ``p``\ ，则含义是只有部分提交被发布到代码审核\
  服务器上。

* 若不显示\ ``P``\ 或者\ ``p``\ ，则表明分支尚未发布。

* 第二个字段为分支名。

* 第三个字段为以竖线（|）开始的字符串，表示该分支存在于哪些项目中。

  - ``| in all projects``

    该分支处于所有项目中。

  - ``| in project1 project2``

    该分支只在特定项目中定义。如：\ ``project1``\ 、\ ``project2``\ 。

  - ``| not in project1``

   该分支不存在于这些项目中。即除了\ ``project1``\ 项目外，其他项目都包\
   含此分支。


:command:`repo diff`\ 命令
---------------------------------

:command:`repo diff`\ 命令实际上是对\ :command:`git diff`\ 命令的封装，\
用以分别显示各个项目工作区下的文件差异。

用法：

::

  repo diff [<project>...]

:command:`repo stage`\ 命令
--------------------------------

:command:`repo stage`\ 命令实际上是对\ :command:`git add --interactive`\
命令的封装，用以对各个项目工作区中的改动（修改、添加等）进行挑选以加入\
暂存区。

用法：

:: 

  repo stage -i [<project>...]


:command:`repo upload`\ 命令
-----------------------------------

:command:`repo upload`\ 命令相当于\ :command:`git push`\ ，但是又有很大\
的不同。执行\ :command:`repo upload`\ 不是将版本库改动推送到克隆时的远程\
服务器，而是推送到代码审查服务器（由Gerrit软件架设）的特殊引用上，使用的\
是SSH协议（特殊端口）。代码审核服务器会对推送的提交进行特殊处理，将新的\
提交显示为一个待审核的修改集，并进入代码审查流程。只有当审核通过，才会合\
并到官方正式的版本库中。

用法：

:: 

  repo upload [--re --cc] {[<project>]... | --replace <project>}

  参数：
    -h, --help            显示帮助信息。
    -t                    发送本地分支名称到 Gerrit 代码审核服务器。
    --replace             发送此分支的更新补丁集。注意使用该参数，只能指定一个项目。
    --re=REVIEWERS, --reviewers=REVIEWERS
                          要求由指定的人员进行审核。
    --cc=CC               同时发送通知到如下邮件地址。

**确定推送服务器的端口**

分支改动的推送是发给代码审核服务器，而不是下载代码的服务器。使用的协议是\
SSH协议，但是使用的并非标准端口。如何确认代码审核服务器上提供的特殊SSH端\
口呢？

在执行\ :command:`repo upload`\ 命令时，repo会通过访问代码审核Web服务器\
的\  ``/ssh_info``\ 的URL获取SSH服务端口，缺省29418。这个端口，就是\
:command:`repo upload`\ 发起推送的服务器的SSH服务端口。

**修订集修改后重新传送**

当已经通过\ :command:`repo upload`\ 命令在代码审查服务器上提交了一个修订\
集，会得到一个修订号。关于此次修订的相关讨论会发送到提交者的邮箱中。如果\
修订集有误没有通过审核，可以重新修改代码，再次向代码审核服务器上传修订集。

一个修订集修改后再次上传，如果修订集的ID不变是非常有用的，因为这样相关的\
修订集都在代码审核服务器的同一个界面中显示。

在执行\ :command:`repo upload`\ 时会弹出一个编辑界面，提示在方括号中输入\
修订集编号，否则会在代码审查服务器上创建新的ID。有一个办法可以不用手工输\
入修订集，如下：

::

  repo upload --replace project_name

当使用\ ``--replace``\ 参数后，repo会检查本地版本库名为\
``refs/published/branch_name``\ 的特殊引用（上一次提交的修订），获得其\
对应的提交SHA1哈希值。然后在代码审核服务器的\ ``refs/changes/``\ 命名空间\
下的特殊引用中寻找和提交SHA1哈希值匹配的引用，找到的匹配引用其名称中就所\
包含有变更集ID，直接用此变更集ID作为新的变更集ID提交到代码审核服务器。

**Gerrit服务器魔法**

:command:`repo upload`\ 命令执行推送，实际上会以类似如下的命令行格式进行\
调用：

::

  git push --receive-pack='gerrit receive-pack --reviewer charlie@example.com' \
           ssh://review.example.com:29418/project HEAD:refs/for/master

当Gerrit服务器接收到\ :command:`git push`\ 请求后，会自动将对分支的提交\
转换为修订集，显示于Gerrit的提交审核界面中。Gerrit的魔法破解的关键点就在\
于\ :command:`git push`\ 命令的\ ``--receive-pack``\ 参数。即提交交由\
:command:`gerrit-receive-pack`\ 命令执行，进入非标准的Git处理流程，将提交\
转换为在\ ``refs/changes``\ 命名空间下的引用，而不在\ ``refs/for``\ 命名\
空间下创建引用。


:command:`repo download`\ 命令
------------------------------------

:command:`repo download`\ 命令主要用于代码审核者下载和评估贡献者提交的\
修订。贡献者的修订在Git版本库中以\ ``refs/changes/<changeid>/<patchset>``\
引用方式命名（缺省的patchset为1），和其他Git引用一样，用\
:command:`git fetch`\ 获取，该引用所指向的最新的提交就是贡献者待审核的修订。\
使用\ :command:`repo download`\ 命令实际上就是用\ :command:`git fetch`\
获取到对应项目的\ ``refs/changes/<changeid>/patchset>``\ 引用，并自动切换\
到对应的引用上。

用法：

:: 

  repo download {project change[/patchset]}...

:command:`repo rebase`\ 命令
----------------------------------

:command:`repo rebase`\ 命令实际上是对\ :command:`git rebase`\ 命令的封\
装，该命令的参数也作为\ :command:`git rebase`\ 命令的参数。但 -i 参数仅\
当对一个项执行时有效。

用法：

:: 

  命令行: repo rebase {[<project>...] | -i <project>...}

  参数:
    -h, --help          显示帮助并退出
    -i, --interactive   交互式的变基（仅对一个项目时有效）
    -f, --force-rebase  向 git rebase 命令传递 --force-rebase 参数
    --no-ff             向 git rebase 命令传递 -no-ff 参数
    -q, --quiet         向 git rebase 命令传递 --quiet 参数
    --autosquash        向 git rebase 命令传递 --autosquash  参数
    --whitespace=WS     向 git rebase 命令传递 --whitespace  参数


:command:`repo prune`\ 命令
----------------------------------

:command:`repo prune`\ 命令实际上是对\ :command:`git branch -d`\ 命令的\
封装，该命令用于扫描项目的各个分支，并删除已经合并的分支。

用法：

:: 

  repo prune [<project>...]


:command:`repo abandon`\ 命令
-------------------------------

相比\ :command:`repo prune`\ 命令，\ :command:`repo abandon`\ 命令更具\
破坏性，因为\ :command:`repo abandon`\ 是对\ :command:`git branch -D`\
命令的封装。该命令非常危险，直接删除分支，请慎用。

用法：

::

  repo abandon <branchname> [<project>...]


其他命令
--------------

* :command:`repo grep`

  相当于对\ :command:`git grep`\ 的封装，用于在项目文件中进行内容查找。

* :command:`repo smartsync`

  相当于用\ ``-s``\ 参数执行\ :command:`repo sync`\ 。

* :command:`repo forall`

  迭代器，可以对repo管理的项目进行迭代。

* :command:`repo manifest`

  显示\ :file:`manifest`\ 文件内容。

* :command:`repo version`

  显示repo的版本号。

* :command:`repo selfupdate`

  用于repo自身的更新。如果提供\ ``--repo-upgraded``\ 参数，还会更新各个\
                  项目的钩子脚本。


Repo命令的工作流
==================

图25-1是repo的工作流，每一个代码贡献都起始于\ :command:`repo start`\ 创\
建本地工作分支，最终都以\ :command:`repo upload`\ 命令将代码补丁发布于代\
码审核服务器。

.. figure:: /images/git-model/repo-workflow.png
   :scale: 80

   图25-1：repo工作流

好东西不能Android独享
=======================

通过前面的介绍能够体会到repo的精巧——repo巧妙的实现了多Git版本库的管理。\
因为repo使用了清单版本库，所以repo这一工具并没有被局限于Android项目，可\
以在任何项目中使用。下面就介绍三种repo的使用模式，将repo引入自己的（非\
Android）项目中，其中第三种repo使用模式是用作者改造后的repo实现脱离\
Gerrit服务器进行推送。

Repo+Gerrit模式
------------------

Repo和Gerrit是Android代码管理的两大支柱。正如前面在repo工作流中介绍的，\
部分的repo命令从Git服务器读取，这个Git服务器可以是只读的版本库控制服务器\
，还有部分repo命令（\ :command:`repo upload`\ 、\ :command:`repo download`\ ）\
访问的则是代码审核服务器，其中\ :command:`repo upload`\ 命令还要向代码\
审核服务器进行\ :command:`git push`\ 操作。

在使用未经改动的repo来维护自己的项目（多个版本库组成）时，必须搭建Gerrit\
代码审核服务器。

搭建项目的版本控制系统环境的一般方法为：

* 用git-daemon或者http服务搭建Git服务器。具体搭建方法参见第5篇\
  “搭建Git服务器”相关章节。

* 导入\ ``repo.git``\ 工具库。非必须，只是为了减少不必要的互联网操作。

* 还可以在内部http服务器维护一个定制的repo引导脚本。非必须。

* 建立Gerrit代码审核服务器。会在第5篇第32章“Gerrit代码审核服务器”中介绍\
  Gerrit的安装和使用。

* 将相关的子项目代码库一一创建。

* 建立一个\ ``manifest.git``\ 清单库，其中\ ``remote``\ 元素的\ ``fetch``\
  属性指向只读Git服务器地址，\ ``review``\ 属性指向代码审核服务器地址。

示例如下：

  ::

    <?xml version="1.0" encoding="UTF-8"?>
    <manifest>
      <remote  name="example"
               fetch="git://git.example.net/"
               review="review.example.net" />
      <default revision="master"
               remote="example" />

      ...

Repo无审核模式
------------------

Gerrit代码审核服务器部署比较麻烦，更不要说因为Gerrit用户界面的学习和用户\
使用习惯的更改而带来的困难了。在一个固定的团队内部使用repo可能真的没有必\
要使用Gerrit，因为团队成员都应该熟悉Git的操作，团队成员的编程能力都可信\
，单元测试质量由提交者保证，集成测试由单独的测试团队进行，即团队拥有一套\
完整、成型的研发工作流，引入Gerrit并非必要。

脱离了Gerrit服务器，直接跟Git服务器打交道，repo可以工作么？是的，可以利\
用\ :command:`repo forall`\ 迭代器实现多项目代码的PUSH，其中有如下关键点\
需要重点关注。

* :command:`repo start`\ 命令创建本地分支时，需要使用和上游同样的分支名。

  如果使用不同的分支名，上传时需要提供复杂的引用描述。下面的示例先通过\
  :command:`repo manifest`\ 命令确认上游清单库缺省的分支名为\ ``master``\ ，\
  再使用该分支名（\ ``master``\ ）作为本地分支名执行\ :command:`repo start`\ 。\
  示例如下：

  ::

    $ repo manifest -o - | grep default
      <default remote="bj" revision="master"/>

    $ repo start master --all

* 推送不能使用\ :command:`repo upload`\ ，而需要使用\ :command:`git push`\ 命令。

  可以利用\ :command:`repo forall`\ 迭代器实现批命令方式执行。例如：

  ::

    $ repo forall -c git push

* 如果清单库中的上游Git库地址用的是只读地址，需要为本地版本库一一更改\
  上游版本库地址。

  可以使用\ ``forall``\ 迭代器，批量为版本库设置\ :command:`git push`\
  时的版本库地址。下面的命令使用了环境变量\ ``$REPO_PROJECT``\ 是实现\
  批量设置的关键。

  ::

    $ repo forall -c \
      'git remote set-url --push bj android@bj.ossxp.com:android/${REPO_PROJECT}.git'

改进的Repo无审核模式
-----------------------

前面介绍的使用\ :command:`repo forall`\ 迭代器实现在无审核服务器情况下向\
上游推送提交，只是权宜之计，尤其是用\ :command:`repo start`\ 建立工作分\
支要求和上游一致，实在是有点强人所难。

我改造了repo，增加了两个新的命令\ :command:`repo config`\ 和\
:command:`repo push`\ ，让repo可以脱离Gerrit服务器直接向上游推送。代码托管\
在Github上：\ http://github.com/ossxp-com/repo.git\ 。下面简单介绍一下如何\
使用改造之后的repo。

下载改造后的repo引导脚本
^^^^^^^^^^^^^^^^^^^^^^^^^^^

建议使用改造后的repo引导脚本替换原脚本，否则在执行\ :command:`repo init`\
命令需要提供额外的\ ``--no-repo-verify``\ 参数，以及\ ``--repo-url``\
和\ ``--repo-branch``\ 参数。

::

  $ curl http://github.com/ossxp-com/repo/raw/master/repo > ~/bin/repo
  $ chmod a+x ~/bin/repo

用repo从Github上检出测试项目
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

如果安装了改造后的repo引导脚本，使用下面的命令初始化repo及清单库。

::

  $ mkdir test
  $ cd test
  $ repo init -u git://github.com/ossxp-com/manifest.git
  $ repo sync

如果用的是标准的（未经改造的）repo引导脚本，用下面的命令。

::

  $ mkdir test
  $ cd test
  $ repo init --repo-url=git://github.com/ossxp-com/repo.git \
    --repo-branch=master --no-repo-verify \
    -u git://github.com/ossxp-com/manifest.git
  $ repo sync

当子项目代码全部同步完成后，执行make命令。可以看到各个子项目的版本以及\
清单库的版本。

::

  $ make
  Version of test1:    1:0.2-dev
  Version of test2:    2:0.2
  Version of manifest: current

用\ :command:`repo config`\ 命令设置pushurl
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

现在如果进入到各个子项目目录，是无法成功执行\ :command:`git push`\ 命令\
的，因为上游Git库的地址是一个只读访问的URL，无法提供写服务。可以用新增的\
:command:`repo config`\ 命令设置当执行\ :command:`git push`\ 时的URL地址。

::

  $ repo config repo.pushurl ssh://git@github.com/ossxp-com/

设置成功后，可以使用\ :command:`repo config repo.pushurl`\ 查看设置。

::

  $ repo config repo.pushurl
  ssh://git@github.com/ossxp-com/

创建本地工作分支
^^^^^^^^^^^^^^^^

使用下面的命令创建一个工作分支\ ``jiangxin``\ 。

::

  $ repo start jiangxin --all

使用\ :command:`repo branches`\ 命令可以查看当前所有的子项目都属于\
``jiangxin``\ 分支

::

  $ repo branches
  *  jiangxin                  | in all projects

参照下面的方法修改\ ``test/test1``\ 子项目。对\ ``test/test2``\ 项目也作\
类似修改。

::

  $ cd test/test1
  $ echo "1:0.2-jiangxin" > version
  $ git diff
  diff --git a/version b/version
  index 37c65f8..a58ac04 100644
  --- a/version
  +++ b/version
  @@ -1 +1 @@
  -1:0.2-dev
  +1:0.2-jiangxin
  $ repo status
  # on branch jiangxin
  project test/test1/                             branch jiangxin
   -m     version
  $ git add -u
  $ git commit -m "0.2-dev -> 0.2-jiangxin"

执行\ :command:`make`\ 命令，看看各个项目的改变。

::

  $ make
  Version of test1:    1:0.2-jiangxin
  Version of test2:    2:0.2-jiangxin
  Version of manifest: current

PUSH到远程服务器
^^^^^^^^^^^^^^^^^^^

直接执行\ :command:`repo push`\ 就可以将各个项目的改动进行推送。

::

  $ repo push

如果有多个项目同时进行了改动，为了避免出错，会弹出编辑器显示因为包含改动\
而需要推送的项目列表。

::

  # Uncomment the branches to upload:
  #
  # project test/test1/:
  #  branch jiangxin ( 1 commit, Mon Oct 25 18:04:51 2010 +0800):
  #         4f941239 0.2-dev -> 0.2-jiangxin
  #
  # project test/test2/:
  #  branch jiangxin ( 1 commit, Mon Oct 25 18:06:51 2010 +0800):
  #         86683ece 0.2-dev -> 0.2-jiangxin

每一行前面的井号是注释，会被忽略。将希望推送的分支前的注释去掉，就可以将\
该项目的分支执行推送动作。下面的操作中，把其中的两个分支的注释都去掉了，\
这两个项目当前分支的改动会推送到上游服务器。

::

  # Uncomment the branches to upload:                                   
                                                                        
              
  #
  # project test/test1/:
  branch jiangxin ( 1 commit, Mon Oct 25 18:04:51 2010 +0800):
  #         4f941239 0.2-dev -> 0.2-jiangxin
  #
  # project test/test2/:
  branch jiangxin ( 1 commit, Mon Oct 25 18:06:51 2010 +0800):
  #         86683ece 0.2-dev -> 0.2-jiangxin

保存退出（如果使用vi编辑器，输入\ ``<ESC>:wq``\ 执行保存退出）后，马上开\
始对选择的各个项目执行\ :command:`git push`\ 。

::

  Counting objects: 5, done.
  Delta compression using up to 2 threads.
  Compressing objects: 100% (2/2), done.
  Writing objects: 100% (3/3), 293 bytes, done.
  Total 3 (delta 0), reused 0 (delta 0)
  To ssh://git@github.com/ossxp-com/test1.git
     27aee23..4f94123  jiangxin -> master
  Counting objects: 5, done.
  Writing objects: 100% (3/3), 261 bytes, done.
  Total 3 (delta 0), reused 0 (delta 0)
  To ssh://git@github.com/ossxp-com/test2.git
     7f0841d..86683ec  jiangxin -> master

  --------------------------------------------
  [OK    ] test/test1/     jiangxin
  [OK    ] test/test2/     jiangxin

从推送的命令输出可以看出来本地的工作分支\ ``jiangxin``\ 的改动被推送的远\
程服务器的\ ``master``\ 分支（本地工作分支跟踪的上游分支）。

再次执行\ :command:`repo push`\ ，会显示没有项目需要推送。

::

  $ repo push
  no branches ready for upload


在远程服务器创建新分支
^^^^^^^^^^^^^^^^^^^^^^^

如果想在服务器上创建一个新的分支，该如何操作呢？如下使用\ ``--new_branch``\
参数调用\ :command:`repo push`\ 命令。

::

  $ repo start feature1 --all
  $ repo push --new_branch

经过同样的编辑操作之后，自动调用\ :command:`git push`\ ，在服务器上创建\
新分支\ ``feature1``\ 。

::

  Total 0 (delta 0), reused 0 (delta 0)
  To ssh://git@github.com/ossxp-com/test1.git
   * [new branch]      feature1 -> feature1
  Total 0 (delta 0), reused 0 (delta 0)
  To ssh://git@github.com/ossxp-com/test2.git
   * [new branch]      feature1 -> feature1

  --------------------------------------------
  [OK    ] test/test1/     feature1
  [OK    ] test/test2/     feature1

用\ :command:`git ls-remote`\ 命令查看远程版本库的分支，会发现远程版本库\
中已经建立了新的分支。

::

  $ git ls-remote git://github.com/ossxp-com/test1.git refs/heads/*
  4f9412399bf8093e880068477203351829a6b1fb        refs/heads/feature1
  4f9412399bf8093e880068477203351829a6b1fb        refs/heads/master
  b2b246b99ca504f141299ecdbadb23faf6918973        refs/heads/test-0.1

注意到\ ``feature1``\ 和\ ``master``\ 分支引用指向相同的SHA1哈希值，这是\
因为\ ``feature1``\ 分支是直接从\ ``master``\ 分支创建的。

通过不同的清单库版本，切换到不同分支
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

换用不同的清单库，需要建立新的工作区，并且在执行\ :command:`repo init`\
时，通过\ ``-b``\ 参数指定清单库的分支。

::

  $ mkdir test-0.1
  $ cd test-0.1
  $ repo init -u git://github.com/ossxp-com/manifest.git -b test-0.1
  $ repo sync

当子项目代码全部同步完成后，执行\ :command:`make`\ 命令。可以看到各个子\
项目的版本以及清单库的版本不同于之前的输出。

::

  $ make
  Version of test1:    1:0.1.4
  Version of test2:    2:0.1.3-dev
  Version of manifest: current-2-g12f9080


可以用\ :command:`repo manifest`\ 命令来查看清单库。

::

  $ repo manifest -o -
  <?xml version="1.0" encoding="UTF-8"?>
  <manifest>
    <remote fetch="git://github.com/ossxp-com/" name="github"/>
    
    <default remote="github" revision="refs/heads/test-0.1"/>
    
    <project name="test1" path="test/test1">
      <copyfile dest="Makefile" src="root.mk"/>
    </project>
    <project name="test2" path="test/test2"/>
  </manifest>

仔细看上面的清单文件，可以注意到缺省的版本指向到\ ``refs/heads/test-0.1``\
引用所指向的分支\ ``test-0.1``\ 。

如果在子项目中修改、提交，然后使用\ :command:`repo push`\ 会将改动推送的\
远程版本库的\ ``test-0.1``\ 分支中。


切换到清单库里程碑版本
^^^^^^^^^^^^^^^^^^^^^^

执行如下命令，可以查看清单库包含的里程碑版本：

::

  $ git ls-remote --tags git://github.com/ossxp-com/manifest.git
  43e5783a58b46e97270785aa967f09046734c6ab        refs/tags/current
  3a6a6da36840e716a14d52252e7b40e6ba6cbdea        refs/tags/current^{}
  4735d32613eb50a6c3472cc8087ebf79cc46e0c0        refs/tags/v0.1
  fb1a1b7302a893092ce8b356e83170eee5863f43        refs/tags/v0.1^{}
  b23884d9964660c8dd34b343151aaf968a744400        refs/tags/v0.1.1
  9c4c287069e29d21502472acac34f28896d7b5cc        refs/tags/v0.1.1^{}
  127d9789cd4312ed279a7fa683c43eec73d2b28b        refs/tags/v0.1.2
  47aaa83866f6d910a118a9a19c2ac3a2a5819b3e        refs/tags/v0.1.2^{}
  af3abb7ed0a9ef7063e9d814510c527287c92ef6        refs/tags/v0.1.3
  99c69bcfd7e2e7737cc62a7d95f39c6b9ffaf31a        refs/tags/v0.1.3^{}

可以从任意里程碑版本的清单库初始化整个项目。

::

  $ mkdir v0.1.2
  $ cd v0.1.2
  $ repo init -u git://github.com/ossxp-com/manifest.git -b refs/tags/v0.1.2
  $ repo sync

当子项目代码全部同步完成后，执行\ :command:`make`\ 命令。可以看到各个子\
项目的版本以及清单库的版本不同于之前的输出。

::

  $ make
  Version of test1:    1:0.1.2
  Version of test2:    2:0.1.2
  Version of manifest: v0.1.2
