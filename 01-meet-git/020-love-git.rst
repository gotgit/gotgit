爱上 Git 的理由
===============

* 原位（in-place）版本库创建

    需求： 要对部署的文件进行原位修改，版本控制可以记录变更并以 patch 形式导入正式版本库
    SVN 该怎么办呢？ 其它位置建库，检出，svn add， svn commit，而且引入 .svn 目录，可能会有风险
    Git 就简单多了，直接  git init

* 重写提交说明

    需求：提交说明忘了添加 bugid, 或者 bugid 写错了，需要重写 commit-log
    SVN ? 需要管理员允许，而且命令复杂 svn ps --revprop ...
    Git？ git ci --amend
    git rebase -i <commit-id>^

* 反悔了，要撤销提交，重新组织后再提交

    需求：提交的数据包含一个不应该检入的 .zip 大文件，浪费空间和检出时间
    SVN 该怎么办呢？ 1. 反向 merge 再提交； 2. 请管理员重整代码库，将最新提交过滤掉
    Git? git reset --soft HEAD^

* 更好用的 change list

    需求：同时针对多个 feature/bugfix 修改代码，需要只对部分更改提交
    SVN 有 change list 功能，但是不会有人用，因为麻烦
    Git 缺省只对加入 stage 的文件进行提交。效果是： 可以随意更改提交清单，甚至对一个文件的部分更改进行提交！
    只提交修改的文件，新增文件不管： git add -u
    所有修改包括添加和删除： git add -A

* 更好用的 differ

    需求： 更改一个文件，得到和版本库的差异容易，可以得到和我刚才更改（未提交）的差异么？
    SVN？ never
    Git？ git diff; git diff --cached;  git diff HEAD

* 当前修改尚不能提交，而需要暂时切换到其它分支，而又不破坏现有文件的更改？

    需求： 当前分支的修改只进行了一半，但是有需要切换到其它分支，查看或者修改。
    SVN 该怎么办呢？ 1. svn diff > somefile; svn revert -R; svn switch ; ...
    SVN 数据恢复的时候？ svn switch ...; patch -p1 < somefile; 而且要注意二进制文件会丢失！
    Git 呢？ git stash; git co BranchName; ...; git co master; git stash pop

* 出差办公，一样可以提交

    需求： 出差在客户现场，发现软件 bug，需要修改代码，重新生成版本？
    SVN： 所有的更改均保留在本地，不能提交，没有历史修改记录，也没有备份！
    Git？ 随时提交，多次提交；完整的历史；回到公司，一次性同步到公司的版本库

* 基于上游软件的定制

    需求，基于上游软件的二次开发，如何保持自有的功能分支能够迁移到新的上游版本？
    SVN？ vendor branch 和 一个 trunk
    SVN 的问题是： 所有定制混杂在一个分支，造成向新版本迁移困难重重
    Git？ topgit 和 quilt 补丁管理系统

* 快

    您有项目托管在 sourceforge.net 上么？ 或者你要通过互联网访问公司的代码服务器？
    SVN 的提交速度慢，而且提交进度不可见，查看历史更慢
    Git？ 太快了，而且可以看到提交的进度
    Git 查看历史？ 本地！

* Pager everywhere

* 没有 .svn 目录


对 Git 的误解和担忧

* 版本库和工作区混在一起，不是很容易误删除版本库？

  你可以将版本库克隆并经常保持同步，起到了数据备份的作用

  版本库被越多的人克隆，越安全，也越不需要备份，因为鸡蛋装在好多篮子里了。

* 提交可以随时撤销，不安全？

  撤销前如果他人和版本库同步，实际上撤销只是本地库的变更，不会造成对他人的影响

  而且撤销记录在 log 中，可以通过特定手段恢复

* 版本库检出到本地不叫检出，叫克隆？

  svn checkout == git clone
  
  git 的 checkout 实际上是将 .git 目录（版本库），检出到工作区。实际上相当于

* 没有部分检出

  不能像 svn 那样检出版本库的一部分

  只能克隆全部版本库，或者0

  submodule？ 或者 git-svn？

* 命令行和 SVN 不兼容？

  git config 进行兼容性设置

  Git 的配置，命令行不再古怪

* Git 的版本号不是从1开始顺序增长的？


