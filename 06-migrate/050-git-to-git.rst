Git 版本库整理
===================

Git 提供了太多武器进行版本库的整理，可以将一个 Git 版本库改动换面成为另外的一个 Git 版本库。

* 使用交互式变基操作，将多个提交合并为一个。（参见TODO页。）
* 使用 StGit，合并提交以及更改提交。（参见TODO页。）
* 借助变基操作，抛弃部分历史提交。（参见TODO页。）
* 使用子树合并，将多个版本库整合在一起。（参见TODO页。）
* 使用 git-subtree 插件，将版本库的一个目录拆分出来成为独立版本库的根目录。（参见TODO页。）

本节还将介绍一个有用的 Git 命令 `git filter-branch` ，可以实现上面那些命令和工具很难完成的版本重整工作。

* 将版本库中某个文件彻底删除。即凡是有该文件的提交都一一作出修改，撤出该文件。
* 为没有包含签名的历史提交添加签名。

该命令的用法：

::

  git filter-branch [--env-filter <command>] [--tree-filter <command>]
          [--index-filter <command>] [--parent-filter <command>]
          [--msg-filter <command>] [--commit-filter <command>]
          [--tag-name-filter <command>] [--subdirectory-filter <directory>]
          [--prune-empty]
          [--original <namespace>] [-d <directory>] [-f | --force]
          [--] [<rev-list options>...]

