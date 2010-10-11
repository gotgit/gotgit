Android 协同模型
================



如果想镜像 Android Repo 代码库，却忘了在 `repo init` 的时候带上 `--mirror` 参数。可以运行下面的脚本 `work2repo.py` 。

脚本 `work2repo.py` 如下：

::

  #!/usr/bin/python

  import re, os, sys
  import shutil

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
              path = os.path.join( work_tree, m.group('path'), ".git" )
              repo = os.path.join( repo_root, m.group('repo') + ".git" )

              if os.path.exists( path ):
                  if not os.path.exists( os.path.dirname(repo) ):
                      os.makedirs( os.path.dirname(repo) )
                  print "Rename %s to %s." % (path, repo)
                  os.rename( path, repo )

              if os.path.exists ( os.path.join( repo, 'config' ) ):
                  os.chdir( repo )
                  os.system( "git config core.bare true" )
                  os.system( "git config remote.korg.fetch '+refs/heads/*:refs/heads/*'" )

                  if os.path.exists ( os.path.join( repo, 'refs', 'remotes' ) ):
                      print "Delete " + os.path.join( repo, 'refs', 'remotes' )
                      shutil.rmtree( os.path.join( repo, 'refs', 'remotes' ) )
      return 0

  if len(sys.argv) < 4:
      print >> sys.stderr, "Usage: python %s <manifest.xml> <work_tree> <new_repo_root>" % sys.argv[0]
  else:
      sys.exit( worktree_to_repo( sys.argv[1], sys.argv[2], sys.argv[3] ) )

* 首先进入 Android 代码下载的根目录下，创建一个空目录 `android_repos_root` 。

* 如下命令行执行 `work2repo.py` 脚本:

  ::

    $ python work2repo.py .repo/manifest.xml ./ android_repos_root/

* 然后在另外的目录执行 `repo init --mirror` 命令。

* 将原来 android 代码同步的目录中的 android_repos_root/ 下的目录和文件全部移动到新的 Android 同步目录中。

* 执行 `repo sync` 和 Android 上游同步。

