Git版本库整理
===================

Git提供了太多武器进行版本库的整理，可以将一个Git版本库改动换面成为另外的\
一个Git版本库。

* 使用交互式变基操作，将多个提交合并为一个。
* 使用StGit，合并提交以及更改提交。
* 借助变基操作，抛弃部分历史提交。
* 使用子树合并，将多个版本库整合在一起。
* 使用\ ``git-subtree``\ 插件，将版本库的一个目录拆分出来成为独立版本库\
  的根目录。

但是有些版本库重整工作如果使用上面的工具会非常困难，而采用另外一个还没有\
用到的Git命令\ :command:`git filter-branch`\ 却可以做到事半功倍。看看使\
用这个新工具来实现下面的这几个任务是多么的简单和优美。

* 将版本库中某个文件彻底删除。即凡是有该文件的提交都一一作出修改，撤出该\
  文件。

  下面的命令并非最优实现，后面会介绍一个运行更快的命令。

  ::

    $ git filter-branch --tree-filter 'rm -f filename' -- --all

* 更改历史提交中某一提交者的姓名及邮件地址。

  ::

    $ git filter-branch --commit-filter '
          if [ "$GIT_AUTHOR_NAME" = "Xin Jiang" ]; then
              GIT_AUTHOR_NAME="Jiang Xin"
              GIT_AUTHOR_EMAIL="jiangxin@ossxp.com"
              GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
              GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
          fi
          git commit-tree "$@";
          ' HEAD


* 为没有包含签名的历史提交添加签名。

  ::

    $ git filter-branch -f --msg-filter '
          signed=false
          while read line; do
              if echo $line | grep -q Signed-off-by; then
                  signed=true
              fi
              echo $line
          done
          if ! $signed; then
              echo ""
              echo "Signed-off-by: YourName <your@email.address>"
          fi
          ' HEAD


通过上面的例子，可以看出命令\ :command:`git filter-branch`\ 通过针对不同\
的过滤器提供可执行脚本，从不同的角度对Git版本库进行重构。该命令的用法：

::

  git filter-branch [--env-filter <command>] [--tree-filter <command>]
          [--index-filter <command>] [--parent-filter <command>]
          [--msg-filter <command>] [--commit-filter <command>]
          [--tag-name-filter <command>] [--subdirectory-filter <directory>]
          [--prune-empty]
          [--original <namespace>] [-d <directory>] [-f | --force]
          [--] [<rev-list options>...]

这条命令异常复杂，但是大部分参数是用于提供不同的接口，因此还是比较好理解\
的。

* 该命令最后的\ ``<rev-list>``\ 参数提供要修改的版本范围，如果省略则相当\
  于\ ``HEAD``\ 指向的当前分支。也可以使用\ ``--all``\ 来指代所有引用，\
  但是要在\ ``--all``\ 和前面的参数间使用分隔符\ ``--``\ 。

* 运行\ :command:`git filter-branch`\ 命令改写分支之后，被改写的分支会在\
  ``refs/original``\ 中对原始引用做备份。对于在\ ``refs/original``\ 中已\
  有备份的情况下，该命令拒绝执行，除非使用\ ``-f``\ 或\ ``--force``\ 参数。

* 其他需要接以\ ``<command>``\ 的参数都为\ :command:`git filter-branch`\
  提供相应的接口进行过虑，在下面会针对各个过滤器进行介绍。

环境变量过滤器
--------------------------------

参数\ ``--env-filter``\ 用于设置一个环境过滤器。该过滤器用于修改环境变量，\
对特定的环境变量的修改会改变提交。下面的示例\ [#]_\ 可以用于修改作者/提交者\
的邮件地址。

::

  $ git filter-branch --env-filter '
      an="$GIT_AUTHOR_NAME"
      am="$GIT_AUTHOR_EMAIL"
      cn="$GIT_COMMITTER_NAME"
      cm="$GIT_COMMITTER_EMAIL"
       
      if [ "$cn" = "Kanwei Li" ]; then
        cm="kanwei@gmail.com"
      fi
      if [ "$an" = "Kanwei Li" ]; then
        am="kanwei@gmail.com"
      fi

      export GIT_AUTHOR_EMAIL=$am
      export GIT_COMMITTER_EMAIL=$cm
      '

这个示例和本节一开始介绍的更改作者/提交者信息的示例功能相同，但是使用了\
不同的过滤器，读者可以根据喜好选择。

树过滤器
--------------------------------

参数\ ``--tree-filter``\ 用于设置树过滤器。树过滤器会将每个提交检出到特\
定目录中（\ :file:`.git-rewrite/`\ 目录或者用\ ``-d``\ 参数指定的目录），\
针对检出目录中文件的修改、添加、删除会改变提交。注意此过滤器忽略\
:file:`.gitignore`\ ，因此任何对检出目录的修改都会记录在新的提交中。\
之前介绍的文件删除就是一例。再比如对文件名的修改：

::

  $ git filter-branch --tree-filter '
        [ -f oldfile ] && mv oldfile newfile || true
        ' -- --all

暂存区过滤器
--------------------------------

树过滤器因为要将每个提交检出，因此非常费时，而参数\ ``--index-filter``\
给出的暂存区过滤器则没有这个缺点。之前使用树过滤器删除文件的的操作如果\
换做用暂存区过滤器实现运行的会更快。

::

  $ git filter-branch --index-filter '
        git rm --cached --ignore-unmatch filename
        ' -- --all

其中参数\ ``--ignore-unmatch``\ 让\ :command:`git rm`\ 命令不至于因为暂\
存区中不存在\ :file:`filename`\ 文件而失败。

父节点过滤器
--------------------------------

参数\ ``--parent-filter``\ 用于设置父节点过滤器。该过滤器用于修改提交的\
父节点。提交原始的父节点通过标准输入传入脚本，而脚本的输出将作为提交新的\
父节点。父节点参数的格式为：如果没有父节点（初始提交）则为空。如果有一个\
父节点，参数为\ ``-p parent``\ 。如果是合并提交则有多个父节点，参数为\
``-p parent1 -p parent2 -p parent3 ...``\ 。

下面的命令将当前分支的初始提交嫁接到\ ``<graft-id>``\ 所指向的提交上。

::

  $ git filter-branch --parent-filter 'sed "s/^\$/-p <graft-id>/"' HEAD

如果不是将初始提交（没有父提交）而是任意的一个提交嫁接到另外的提交上，\
可以通过\ ``GIT_COMMIT``\ 环境变量对提交进行判断，更改其父节点以实现嫁接。

::

  $ git filter-branch --parent-filter \
            'test $GIT_COMMIT = <commit-id> && \
             echo "-p <graft-id>" || cat
            ' HEAD

关于嫁接，Git可以通过配置文件\ :file:`.git/info/grafts`\ 实现，而\
:command:`git filter-branch`\ 命令可以基于该配置文件对版本库实现永久性的\
更改。

::

  $ echo "$commit-id $graft-id" >> .git/info/grafts
  $ git filter-branch $graft-id..HEAD

提交说明过滤器
--------------------------------

参数\ ``--msg-filter``\ 用于设置提交说明过滤器。该过滤器用于改写提交说明。\
原始的提交说明作为标准输入传入脚本，而脚本的输出作为新的提交说明。

例如将使用git-svn从Subversion迁移过来的Git版本库，缺省情况下在提交说明中\
饱含\ ``git-svn-id:``\ 字样的说明，如果需要将其清除可以不必重新迁移，而\
是使用下面的命令重写提交说明。

::

  $ git filter-branch --msg-filter 'sed -e "/^git-svn-id:/d"' -- --all

再如将最新的10个提交添加“\ ``Acked-by:``\ ”格式的签名。

::

  $ git filter-branch --msg-filter '
        cat &&
        echo "Acked-by: Bugs Bunny <bunny@bugzilla.org>"
        ' HEAD~10..HEAD


提交过滤器
--------------------------------

参数\ ``--commit-filter``\ 用于设置树过滤器。提交过滤器所给出的脚本，在\
版本库重整过程的每次提交时运行，取代缺省要执行的\ :command:`git commit-tree`\
命令。不过一般情况会在脚本中调用\ :command:`git commit-tree`\ 命令。\
传递给脚本的参数格式为\ ``<TREE_ID> [(-p <PARENT_COMMIT_ID>)...]``\ ，\
提交日志以标准输入的方式传递给脚本。脚本的输出是新提交的提交ID。作为扩展，\
如果脚本输出了多个提交ID，则这些提交ID作为子提交的多个父节点。


使用下面的命令，可以过滤掉空提交（合并提交除外）。

::

  $ git filter-branch --commit-filter 'git_commit_non_empty_tree "$@"' 

函数\ ``git_commit_non_empty_tree``\ 函数是在脚本\
:command:`git-filter-branch`\ 中已经定义过的函数。可以打开文件\
:file:`$(git --exec-path)/git-filter-branch`\ 查看。

::

  # if you run 'git_commit_non_empty_tree "$@"' in a commit filter,
  # it will skip commits that leave the tree untouched, commit the other.
  git_commit_non_empty_tree()
  {
    if test $# = 3 && test "$1" = $(git rev-parse "$3^{tree}"); then
      map "$3"
    else
      git commit-tree "$@"
    fi
  }

如果想某个用户的提价非空但是也想跳过，可以使用下面的命令：

::

  $ git filter-branch --commit-filter '
        if [ "$GIT_AUTHOR_NAME" = "badboy" ];
        then
                skip_commit "$@";
        else
                git commit-tree "$@";
        fi' HEAD

其中函数\ ``skip_commit``\ 也是在\ :file:`git-filter-branch`\ 脚本中已经\
定义好的。该函数的作用就是将传递给提交过滤器脚本的参数\
``<tree_id> -p parent1 -p parent2 ...``\ 进行处理，形成\ ``parent1 parent2``\
的输出。参见Git命令脚本\ :file:`$(git --exec-path)/git-filter-branch`\
中相关函数。

::

  # if you run 'skip_commit "$@"' in a commit filter, it will print
  # the (mapped) parents, effectively skipping the commit.
  skip_commit()
  {
    shift;
    while [ -n "$1" ];
    do
      shift;
      map "$1";
      shift;
    done;
  }
 
里程碑名字过滤器
--------------------------------

参数\ ``--tag-name-filter``\ 用于设置里程碑名字过滤器。该过滤器也是经常\
要用到的过滤器。上面介绍的各个过滤器都有可能改变提交ID，如果在原有的提交\
ID上建有里程碑，可能会随之更新但是会产生大量的警告日志，提示使用里程碑过\
滤器。里程碑过滤器脚本以原始里程碑名称作为标准输入，并把新里程碑名称作为\
标准输出。如果不打算变更里程碑名称，而只是希望里程碑随提交而更新，可以在\
脚本中使用\ :command:`cat`\ 命令。例如下面的命令中里程碑名字过滤器和目录\
树过滤器同时使用。

::

  $ git filter-branch --tree-filter '
        [ -f oldfile ] && mv oldfile newfile || true
        ' -- tag-name-filter 'cat' -- --all

在前面的里程碑一章曾经提到过\ :command:`git branch`\ 命令没有提供里程碑\
重名名的功能，而使用里程碑名字过滤器可以实现里程碑的重命名。下面的的示例\
会修改里程碑的名字，将前缀为\ ``old-prefix``\ 的里程碑改名为前缀为\
``new-prefix``\ 的里程碑。

::

  $ git filter-branch --tag-name-filter '
        oldtag=`cat`
        newtag=${oldtag#old-prefix}
        if [ "$oldtag" != "$newtag" ]; then
            newtag="new-prefix$newtag"
        fi
        echo $newtag
        '

注意因为签名里程碑重建后，因为签名不可能保持所以新里程碑会丢弃签名，成为\
一个普通的包含说明的里程碑。

子目录过滤器
--------------------------------

参数\ ``--subdirectory-filter``\ 用于设置子目录过滤器。子目录过滤器可以\
将版本库的一个子目录提取为一个新版本库，并将该子目录作为版本库的根目录。\
例如从Subversion转换到Git版本库因为参数使用不当，将原Subversion的主线转\
换为Git版本库的一个目录\ :file:`trunk`\ 。可以使用\
:command:`git filter-branch`\ 命令的子目录过滤器将\ :file:`trunk`\
提取为版本库的根。

::

  $ git filter-branch --subdirectory-filter trunk HEAD

----

.. [#] 摘自\ http://kanwei.com/code/2009/03/29/fixing-git-email.html\ 。
