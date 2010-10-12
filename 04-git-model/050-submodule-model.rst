子模组协同模型
==============

git submodule

::

      显性和隐性子模组
          使用 git submodule 命令建立的子模组为显性
          使用 git add 将本地的一个 git 库以 submodule 方式加入
      显示当前有那些子模组
          git submodule status
      分布式版本控制不支持部分检出，因此对于大项目需要为每个模块单独建库
      创建和克隆 submodule 示例
          先建立四个 git 库（作为子模块）
              $ mkdir ~/git
  $ cd ~/git
  $ for i in a b c d
  do
          mkdir $i
          cd $i
          git init
          echo "module $i" > $i.txt
          git add $i.txt
          git commit -m "Initial commit, submodule $i"
          cd ..
  done
          建立一个 super 库
              $ mkdir super
  $ cd super
  $ git init
  $ for i in a b c d
  do
          git submodule add ~/git/$i $i
  done
              $ ls -a
  .  ..  .git  .gitmodules  a  b  c  d
              $ git commit -m "Add submodules a, b, c and d."
          克隆 super 库 到 cloned
              $ cd ..
  $ git clone super cloned
  $ cd cloned
              $ ls -a a
  .  ..
  $ git submodule status
  -d266b9873ad50488163457f025db7cdd9683d88b a
  -e81d457da15309b4fef4249aba9b50187999670d b
  -c1536a972b9affea0f16e0680ba87332dc059146 c
  -d96249ff5d57de5de093e6baff9e0aafa5276a74 d
          在克隆 的库 cloned 中，检出子模块
              $ git submodule init
  $ git submodule update
  $ cd a
  $ ls -a
  .  ..  .git  a.txt
      更新 submodule 示例
          正确的操作
              $ cd ~/git/super/a
  $ echo "adding a line again" >> a.txt
  $ git commit -a -m "Updated the submodule from within the superproject."
  $ git push
  $ cd ..
  $ git diff
  diff --git a/a b/a
  index d266b98..261dfac 160000
  --- a/a
  +++ b/a
  @@ -1 +1 @@
  -Subproject commit d266b9873ad50488163457f025db7cdd9683d88b
  +Subproject commit 261dfac35cb99d380eb966e102c1197139f7fa24
  $ git add a
  $ git commit -m "Updated submodule a."
  $ git push
          错误的做法
              $ cd ~/git/super/a
  $ echo i added another line to this file >> a.txt
  $ git commit -a -m "doing it wrong this time"
  $ cd ..
  $ git add a
  $ git commit -m "Updated submodule a again."
  $ git push
  $ cd ~/git/cloned
  $ git pull
  $ git submodule update
  error: pathspec '261dfac35cb99d380eb966e102c1197139f7fa24' did not match any file(s) known to git.
  Did you forget to 'git add'?
  Unable to checkout '261dfac35cb99d380eb966e102c1197139f7fa24' in submodule path 'a'
          错误的原因是：只push 了 submodule 的库，没有push 字库，导致 submodule 克隆库更新找不到字库的相应版本
      Subtree Merge
          kernel.org > Pub > Software > Scm > Git > Docs > Howto > Using-merge-subtree <http://www.kernel.org/pub/software/scm/git/docs/howto/using-merge-subtree.html>
          命令
              $ git remote add -f Bproject /path/to/B (1)
              $ git merge -s ours --no-commit Bproject/master (2)
              $ git read-tree --prefix=dir-B/ -u Bproject/master (3)
              $ git commit -m "Merge B project as our subdirectory" (4)
              $ git pull -s subtree Bproject master (5)
  
