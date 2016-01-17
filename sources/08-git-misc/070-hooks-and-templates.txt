钩子和模板
===========

Git钩子
---------

Git的钩子脚本位于版本库\ :file:`.git/hooks`\ 目录下，当Git执行特定操作时\
会调用特定的钩子脚本。当版本库通过\ :command:`git init`\ 或者\
:command:`git clone`\ 创建时，会在\ :file:`.git/hooks`\ 目录下创建示例脚本，\
用户可以参照示例脚本的写法开发适合的钩子脚本。

钩子脚本要设置为可运行，并使用特定的名称。Git提供的示例脚本都带有\
``.sample``\ 扩展名，是为了防止被意外运行。如果需要启用相应的钩子脚本，\
需要对其重命名（去掉\ ``.sample``\ 扩展名）。下面分别对可用的钩子脚本逐一\
介绍。

applypatch-msg
^^^^^^^^^^^^^^^

该钩子脚本由\ :command:`git am`\ 命令调用。在调用时向该脚本传递一个参数，\
即保存有提交说明的文件的文件名。如果该脚本运行失败（返回非零值），则\
:command:`git am`\ 命令在应用该补丁之前终止。

这个钩子脚本可以修改文件中保存的提交说明，以便对提交说明进行规范化以符合\
项目的标准（如果有的话）。如果提交说明不符合项目标准，脚本直接以非零值退\
出，拒绝提交。

Git提供的示例脚本\ :file:`applypatch-msg.sample`\ 只是简单的调用\
:file:`commit-msg`\ 钩子脚本（如果存在的话）。这样通过\ :command:`git am`\
命令应用补丁和执行\ :command:`git commit`\ 一样都会执行\ :file:`commit-msg`\
脚本，因此如须定制，请更改\ :file:`commit-msg`\ 脚本。

pre-applypatch
^^^^^^^^^^^^^^^^

该钩子脚本由\ :command:`git am`\ 命令调用。该脚本没有参数，在补丁应用后\
但尚未提交之前运行。如果该脚本运行失败（返回非零值），则已经应用补丁的工\
作区文件不会被提交。

这个脚本可以用于对应用补丁后的工作区进行测试，如果测试没有通过则拒绝提交。

Git提供的示例脚本\ :file:`pre-applypatch.sample`\ 只是简单的调用\
:file:`pre-commit`\ 钩子脚本（如果存在的话）。这样通过\ :command:`git am`\
命令应用补丁和执行\ :command:`git commit`\ 一样都会执行\
:file:`pre-commit`\ 脚本，因此如须定制，请更改\ :file:`pre-commit`\ 脚本。

post-applypatch
^^^^^^^^^^^^^^^^

该钩子脚本由\ :command:`git am`\ 命令调用。该脚本没有参数，在补丁应用并\
且提交之后运行，因此该钩子脚本不会影响\ :command:`git am`\ 的运行结果，\
可以用于发送通知。

pre-commit
^^^^^^^^^^^

该钩子脚本由\ :command:`git commit`\ 命令调用。可以向该脚本传递\
``--no-verify``\ 参数，此外别无参数。该脚本在获取提交说明之前运行。如果\
该脚本运行失败（返回非零值），Git提交被终止。

该脚本主要用于对提交数据的检查，例如对文件名进行检查（是否使用了中文文件\
名），或者对文件内容进行检查（是否使用了不规范的空白字符）。

Git提供的示例脚本\ :file:`pre-commit.sample`\ 禁止提交在路径中使用了非\
ASCII字符（如中文字符）的文件。如果确有使用的必要，可以在Git配置文件中\
设置配置变量\ ``hooks.allownonascii``\ 为\ ``true``\ 以允许在文件名中使用\
非ASCII字符。Git提供的该示例脚本也对不规范的空白字符进行检查，如果发现则\
终止提交。

Topgit为所管理的版本库设置了自己的\ :file:`pre-commit`\ 脚本，检查工作的\
Topgit特性分支是否正确设置了两个Topgit管理文件\ :file:`.topdeps`\ 和\
:file:`.topmsg`\ ，以及定义的分支依赖是否存在着重复依赖和循环依赖等。

prepare-commit-msg
^^^^^^^^^^^^^^^^^^^^

该钩子脚本由\ :command:`git commit`\ 命令调用，在默认的提交信息准备完成\
后但编辑器尚未启动之前运行。

该脚本有1到3个参数。第一个参数是包含提交说明的文件的文件名。第二个参数是\
提交说明的来源，可以是\ ``message``\ （由\ ``-m``\ 或者\ ``-F``\ 参数提\
供），可以是\ ``template``\ （如果使用了\ ``-t``\ 参数或由\
``commit.template``\ 配置变量提供），或者是\ ``merge``\ （如果提交是一个\
合并或存在\ :file:`.git/MERGE_MSG`\ 文件），或者是\ ``squash``\ （如果存在\
:file:`.git/SQUASH_MSG`\ 文件），或者是\ ``commit``\ 并跟着一个提交SHA1\
哈希值（如果使用\ ``-c``\ 、\ ``-C``\ 或者\ ``--amend``\ 参数）。

如果该脚本运行失败（返回非零值），Git提交被终止。

该脚本用于对提交说明进行编辑，并且该脚本不会因为\ ``--no-verify``\ 参数\
被禁用。

Git提供的示例脚本\ :file:`prepare-commit-msg.sample`\ 可以用于向提交说明\
中嵌入提交者签名，或者将来自\ ``merge``\ 的提交说明中的含有“Conflicts:”\
的行去掉。

commit-msg
^^^^^^^^^^^^

该钩子脚本由\ :command:`git commit`\ 命令调用，可以通过传递\ ``--no-verify``\
参数而禁用。该脚本有一个参数，即包含有提交说明的文件的文件名。如果该脚本\
运行失败（返回非零值），Git提交被终止。

该脚本可以直接修改提交说明，可以用于对提交说明规范化以符合项目的标准\
（如果有的话）。如果提交说明不符合标准，可以拒绝提交。

Git提供的示例脚本\ :file:`commit-msg.sample`\ 检查提交说明中出现的相同的\
``Signed-off-by``\ 行，如果发现重复签名即报错、终止提交。

Gerrit服务器需要每一个向其进行推送的Git版本库在本地使用Gerrit提供的\
:file:`commit-msg`\ 钩子脚本，以便在创建的提交中包含形如“Change-Id: I...”\
的变更集标签。

post-commit
^^^^^^^^^^^^

该钩子脚本由\ :command:`git commit`\ 命令调用，不带参数运行，在提交完成\
之后被触发执行。

该钩子脚本不会影响\ :command:`git commit`\ 的运行结果，可以用于发送通知。

pre-rebase
^^^^^^^^^^^^^^

该钩子脚本由\ :command:`git rebase`\ 命令调用，用于防止某个分支参与变基。

Git提供的示例脚本\ :file:`pre-rebase.sample`\ 是针对Git项目自身情况而开\
发的，当一个功能分支已经合并到\ ``next``\ 分支后，禁止该分基进行变基操作。

post-checkout
^^^^^^^^^^^^^^^^

该钩子脚本由\ :command:`git checkout`\ 命令调用，是在完成工作区更新之后\
触发执行。该钩子脚本有三个参数：前一个HEAD的引用，新HEAD的引用（可能和前\
一个一样也可能不一样），以及一个用于表示此次检出是否是分支检出的标识（分\
支检出为1，文件检出是0）。该钩子脚本不会影响\ :command:`git checkout`\
命令的结果。

除了由\ :command:`git checkout`\ 命令调用外，该钩子脚本也在\
:command:`git clone`\ 命令执行后被触发执行，除非在克隆时使用了禁止检出的\
``--no-checkout (-n)``\ 参数。在由\ :command:`git clone`\ 调用时，第一个\
参数给出的引用是空引用，则第二个和第三个参数都为1。

这个钩子一般用于版本库的有效性检查，自动显示和前一个HEAD的差异，或者设置\
工作区属性。

post-merge
^^^^^^^^^^^^^^

该钩子脚本由\ :command:`git merge`\ 命令调用，当在本地版本库完成\
:command:`git pull`\ 操作后触发执行。该钩子脚本有一个参数，标识合并是否是\
一个压缩合并。该钩子脚本不会影响\ :command:`git merge`\ 命令的结果。\
如果合并因为冲突而失败，该脚本不会执行。

该钩子脚本可以与\ :file:`pre-commit`\ 钩子脚本一起实现对工作区目录树属性\
（如权限/属主/ACL等）的保存和恢复。参见Git源码文件\
:file:`contrib/hooks/setgitperms.perl`\ 中的示例。

pre-receive
^^^^^^^^^^^^^^

该钩子脚本由远程版本库的\ :command:`git receive-pack`\ 命令调用。当从本\
地版本库完成一个推送之后，在远程服务器上开始批量更新引用之前，该钩子脚本\
被触发执行。该钩子脚本的退出状态决定了更新引用的成功与否。

该钩子脚本在接收（receive）操作中只执行一次。传递参数不通过命令行，而是\
通过标准输入进行传递。通过标准输入传递的每一行的语法格式为：

::

  <old-value> <new-value> <ref-name>

``<old-value>``\ 是引用更新前的老的对象ID，\ ``<new-value>``\ 是引用即将\
更新到的新的对象ID，\ ``<ref-name>``\ 是引用的全名。当创建一个新引用时，\
\ ``<old-value>``\ 是40个0。

如果该钩子脚本以非零值退出，一个引用也不会更新。如果该脚本正常退出，每一\
个单独的引用的更新仍有可能被\ ``update``\ 钩子所阻止。

标准输出和标准错误都重定向到在另外一端执行的\ :command:`git send-pack`\ ，\
所以可以直接通过\ :command:`echo`\ 命令向用户传递信息。

update
^^^^^^^^^^^^^^

该钩子脚本由远程版本库的\ :command:`git receive-pack`\ 命令调用。当从本地\
版本库完成一个推送之后，在远程服务器上更新引用时，该钩子脚本被触发执行。\
该钩子脚本的退出状态决定了更新引用的成功与否。

该钩子脚本在每一个引用更新的时候都会执行一次。该脚本有三个参数。

* 参数1：要更新的引用的名称。
* 参数2：引用中保存的旧对象名称。
* 参数3：将要保存到引用中的新对象名称。

正常退出（返回0）允许引用的更新，而以非零值退出禁止\
:command:`git-receive-pack`\ 更新该引用。

该钩子脚本可以用于防止对某些引用的强制更新，因为该脚本可以通过检查新旧引\
用对象是否存在继承关系，从而提供更为细致的“非快进式推送”的授权。

该钩子脚本也可以用于记录（如用邮件）引用变更历史\ ``old..new``\ 。然而因\
为该脚本不知道整个的分支，所以可能会导致每一个引用发送一封邮件。因此如果\
要发送通知邮件，可能\ ``post-receive``\ 钩子脚本更适合。

另外，该脚本可以实现基于路径的授权。

标准输出和标准错误都重定向到在另外一端执行的\ :command:`git send-pack`\ ，\
所以可以直接通过\ :command:`echo`\ 命令向用户传递信息。

Git提供的示例脚本\ :file:`update.sample`\ 展示了对多种危险的Git操作行为\
进行控制的可行性。

* 只有将配置变量\ ``hooks.allowunannotated``\ 设置为\ ``true``\ 才允许推\
  送轻量级里程碑（不带说明的里程碑）。

* 只有将配置变量\ ``hooks.allowdeletebranch``\ 设置为\ ``true``\ 才允许\
  删除分支。

* 如果将配置变量\ ``hooks.denycreatebranch``\ 设置为\ ``true``\ 则不允许\
  创建新分支。

* 只有将配置变量\ ``hooks.allowdeletetag``\ 设置为\ ``true``\ 才允许删除\
  里程碑。

* 只有将配置变量\ ``hooks.allowmodifytag``\ 设置为\ ``true``\ 才允许修改\
  里程碑。

相比Git的示例脚本，Gitolite服务器为其管理的版本库设置的\ ``update``\ 钩\
子脚本更实用也更强大。Gitolite实现了用户认证，并通过检查授权文件，实现基\
于分支和路径的写操作授权，等等。具体参见本书第5篇“第30章Gitolite服务架设”\
相关内容。

post-receive
^^^^^^^^^^^^^^

该钩子脚本由远程版本库的\ :command:`git receive-pack`\ 命令调用。当从本\
地版本库完成一个推送，并且在远程服务器上所有引用都更新完毕后，该钩子脚本\
被触发执行。

该钩子脚本在接收（receive）操作中只执行一次。该脚本不通过命令行传递参数，\
但是像\ ``pre-receive``\ 钩子脚本那样，通过标准输入以相同格式获取信息。

该钩子脚本不会影响\ ``git-receive-pack``\ 的结果，因为调用该脚本时工作已\
经完成。

该钩子脚本胜过\ ``post-update``\ 脚本之处在于可以获得所有引用的老的和新\
的值，以及引用的名称。

标准输出和标准错误都重定向到在另外一端执行的\ :command:`git send-pack`\ ，\
所以可以直接通过\ :command:`echo`\ 命令向用户传递信息。

Git提供的示例脚本\ :file:`post-receive.sample`\ 引入了\
:file:`contrib/hooks`\ 目录下的名为\ :file:`post-receive-email`\
的示例脚本（默认被注释），以实现发送通知邮件的功能。

Gitolite服务器要对其管理的Git版本库设置\ :file:`post-receive`\ 钩子脚本，\
以实现当版本库有变更后进行到各个镜像版本库的数据传输。

post-update
^^^^^^^^^^^^^^

该钩子脚本由远程版本库的\ :command:`git receive-pack`\ 命令调用。当从本\
地版本库完成一个推送之后，即当所有引用都更新完毕后，在远程服务器上该钩子\
脚本被触发执行。

该脚本接收不定长的参数，每一个参数实际上就是已成功更新的引用名。

该钩子脚本不会影响\ :command:`git-receive-pack`\ 的结果，因此主要用于通知。

钩子脚本\ ``post-update``\ 虽然能够提供那些引用被更新了，但是该脚本不知\
道引用更新前后的对象SHA1哈希值，所以在这个脚本中不能记录形如\ ``old..new``\
的引用变更范围。而钩子脚本\ ``post-receive``\ 知道更新引用前后的对象ID，\
因此更适合此种场合。

标准输出和标准错误都重定向到在另外一端执行的\ :command:`git send-pack`\ ，\
所以可以直接通过\ :command:`echo`\ 命令向用户传递信息。

Git提供的示例脚本\ ``post-update.sample``\ 会运行\
:command:`git update-server-info`\ 命令，以更新哑协议需要的索引文件。\
如果通过哑协议共享版本库，应该启用该钩子脚本。

pre-auto-gc
^^^^^^^^^^^^^^

该钩子脚本由\ :command:`git gc --auto`\ 命令调用，不带参数运行，如果以非\
零值退出会导致\ :command:`git gc --auto`\ 被中断。

post-rewrite
^^^^^^^^^^^^^^

该钩子脚本由一些重写提交的命令调用，如\ :command:`git commit --amend`\ 、\
:command:`git rebase`\ ，而\ :command:`git-filter-branch`\ 当前尚未\
调用该钩子脚本。

该脚本的第一个参数用于判断调用来自哪个命令，当前有\ ``amend``\ 和\
``rebase``\ 两个取值，也可能将来会有其他更多命令相关参数传递。

该脚本通过标准输入接收一个重写提交列表，每一行输入的格式如下：

::

  <old-sha1> <new-sha1> [<extra-info>]

前两个是旧的和新的对象SHA1哈希值。而\ ``<extra-info>``\ 参数是和调用命令\
相关的，而当前该参数为空。


Git模板
--------

当执行\ :command:`git init`\ 或\ :command:`git clone`\ 创建版本库时，会\
自动在版本库中创建钩子脚本（\ :file:`.git/hooks/\*`\ ）、忽略文件\
（\ :file:`.git/info/exclude`\ ）及其他文件，实际上这些文件均拷贝自模板目录。\
如果需要本地版本库使用定制的钩子脚本等文件，直接在模板目录内创建（文件或\
符号链接）会事半功倍。

Git按照以下列顺序第一个确认的路径即为模板目录。

* 如果执行\ :command:`git init`\ 或\ :command:`git clone`\ 命令时，提供\
  ``--template=<DIR>``\ 参数，则使用指定的目录作为模板目录。

* 由环境变量\ ``$GIT_TEMPLATE_DIR``\ 指定的模板目录。

* 由Git配置变量\ ``init.templatedir``\ 指定的模板目录。

* 缺省的模板目录，根据Git安装路径的不同可能位于不同的目录下。可以通过下\
  面命令确认其实际位置：

  ::

    $ ( cd $(git --html-path)/../../git-core/templates; pwd )
    /usr/share/git-core/templates

如果在执行版本库初始化时传递了空的模板路径，则不会在版本库中创建钩子脚本
等文件。

::

  $ git init --template= no-template
  Initialized empty Git repository in /path/to/my/workspace/no-template/.git/

执行下面的命令，查看新创建的版本库\ :file:`.git`\ 目录下的文件。

::

  $ ls -F no-template/.git/
  HEAD     config   objects/ refs/

可以看到不使用模板目录创建的版本库下面的文件少的可怜。而通过对模板目录下\
的文件的定制，可以实现在建立的版本库中包含预先设置好的钩子脚本、忽略文件、\
属性文件等。这对于服务器或者对版本库操作有特殊要求的项目带来方便。
