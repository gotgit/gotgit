Git 模板
--------

当执行 `git init` 或 `git clone` 创建版本库时，会自动在版本库中创建钩子脚本（ `.git/hooks/\*` ）、忽略文件（ `.git/info/exclude` ）及其他文件，实际上这些文件均拷贝自模板目录。如果需要本地版本库使用定制的钩子脚本等文件，直接在模板目录内创建（文件或符号链接）会事半功倍。

Git 按照以下列顺序第一个确认的路径即为模板目录。

* 如果执行 `git init` 或 `git clone` 命令时，提供 `--template=<DIR>` 参数，则使用指定的目录作为模板目录。
* 由环境变量 `$GIT_TEMPLATE_DIR` 指定的模板目录。
* 由 Git 配置变量 `init.templatedir` 指定的模板目录。
* 缺省的模板目录，根据 Git 安装路径的不同可能位于不同的目录下。可以通过下面命令确认其实际位置：

  ::

    $ ( cd $(git --html-path)/../../git-core/templates; pwd )
    /usr/share/git-core/templates

如果在执行版本库初始化时传递了空的模板路径，则不会在版本库中创建钩子脚本等文件。

::

  $ git init --template= no-template
  Initialized empty Git repository in /path/to/my/workspace/no-template/.git/

执行下面的命令，查看新创建的版本库 `.git` 目录下的文件。

::

  $ ls -F no-template/.git/
  HEAD     config   objects/ refs/

可以看到不使用模板目录创建的版本库下面的文件少的可怜。而通过对模板目录下的文件的定制，可以实现在建立的版本库中包含预先设置好的钩子脚本、忽略文件、属性文件等。这对于服务器或者对版本库操作有特殊要求的项目带来方便。
