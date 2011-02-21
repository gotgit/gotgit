稀疏检出
================

从 1.7.0 版本开始 Git 提供稀疏检出的功能。所谓稀疏检出就是本地版本库检出时不检出全部，只将标记的文件从本地版本库检出到工作区，而其他未被标记的文件则不予检出（即使这些文件存在于工作区，其修改也会被忽略）。

要想实现稀疏检出的功能，必须同时设置 `core.sparseCheckout` 配置变量，并存在文件 `.git/info/sparse-checkout` 。即首先要配置 Git 变量 `core.sparseCheckout` 为 `true` ，然后编辑 `.git/info/sparse-checkout` 文件，将要检出的目录或文件的路径写入其中。其中文件 `.git/info/sparse-checkout` 的格式就和 `.gitignore` 文件格式一样，路径可以使用通配符。

稀疏检出是如何实现的呢？实际上 Git 在 index （即暂存区）中为每个文件提供一个名为 `skip-worktree` 标志位，缺省这个标识位处于关闭状态。如果该标识位开启，则无论工作区对应的文件存在与否，或者是否被修改，Git 都认为工作区该文件的版本是最新的、无变化。Git 通过配置文件 `.git/info/sparse-checkout` 定义一个要检出的目录和/或文件列表，当前 Git 的 `git read-tree` 命令及其他基于合并的命令（ `git merge` ， `git checkout` 等等）能够根据该配置文件更新 index 中文件的 `skip-worktree` 位，实现版本库文件的稀疏检出。

先来在工作区 `/path/to/my/workspace` 中创建一个示例版本库 `sparse1` ，创建后的 `sparse1` 版本库中包含如下内容：

::

  $ ls -F
  doc1/ doc2/ doc3/
  $ git ls-files -s -v
  H 100644 ce013625030ba8dba906f756967f9e9ca394464a 0     doc1/readme.txt
  H 100644 ce013625030ba8dba906f756967f9e9ca394464a 0     doc2/readme.txt
  H 100644 ce013625030ba8dba906f756967f9e9ca394464a 0     doc3/readme.txt

即版本库 `sparse1` 中包含三个目录 `doc1` 、 `doc2` 和 `doc3` 。命令 `git ls-files` 的 `-s` 参数用于显示对象的SHA1哈希值以及所处的暂存区编号。而 `-v` 参数则还会显示工作区文件的状态，每一行命令输出的第一个字符即是文件状态：字母 `H` 表示文件已被暂存，如果是字母 `S` 则表示该文件 `skip-worktree` 标志位已开启 。

下面我们就来尝试稀疏检出的功能。

* 修改版本库的 Git 配置变量 `core.sparseCheckout` ，将其设置为 `true` 。

  ::

    $ git config core.sparseCheckout true

* 设置 `.git/info/sparse-checkout` 的内容，如下：

  ::

    $ printf "doc1\ndoc3\n" > .git/info/sparse-checkout 
    $ cat .git/info/sparse-checkout 
    doc1
    doc3

* 执行 `git checkout` 命令后，会发现工作区中 `doc2` 目录不见了。

  ::

    $ git checkout
    $ ls -F
    doc1/ doc3/

* 这时如果用 `git ls-files` 命令查看，会发现 `doc2` 目录下的文件被设置了 `skip-worktree` 位。

  ::

    $ git ls-files -v
    H doc1/readme.txt
    S doc2/readme.txt
    H doc3/readme.txt

* 修改 `.git/info/sparse-checkout` 的内容，如下：

  ::

    $ printf "doc3\n" > .git/info/sparse-checkout 
    $ cat .git/info/sparse-checkout 
    doc3

* 执行 `git checkout` 命令后，会发现工作区中 `doc1` 目录也不见了。

  ::

    $ git checkout
    $ ls -F
    doc3/

* 这时如果用 `git ls-files` 命令查看，会发现 `doc1` 和 `doc2` 目录下的文件都被设置了 `skip-worktree` 位。

  ::

    $ git ls-files -v
    S doc1/readme.txt
    S doc2/readme.txt
    H doc3/readme.txt

* 修改 `.git/info/sparse-checkout` 的内容，使之包含一个星号，即在工作区检出所有的内容。

  ::

    $ printf "*\n" > .git/info/sparse-checkout 
    $ cat .git/info/sparse-checkout 
    *

* 执行 `git checkout` ，会发现所有目录又都回来了。

  ::

    $ git checkout
    $ ls -F
    doc1/ doc2/ doc3/

文件 `.git/info/sparse-checkout` 的文件格式类似于 `.gitignore` 的格式，也支持用感叹号实现反向操作。例如不检出目录 doc2 下的文件，而检出其他文件，可以使用下面的语法（注意顺序不能写反）：

::

  *
  !doc2/

注意如果使用命令 `git checkout -- <file>...` ，即不是切换分支而是用分支中的文件替换暂存区和工作区的话，则忽略 `skip-worktree` 标识符的设置。例如下面的操作中，虽然 doc2 被设置为不检出，但是执行 `git checkout .` 命令后，还是所有的目录都被检出了。

::

  $ git checkout .
  $ ls -F
  doc1/ doc2/ doc3/
  $ git ls-files -v
  H doc1/readme.txt
  S doc2/readme.txt
  H doc3/readme.txt
 
如果修改 `doc2` 目录下的文件，或者在 `doc2` 目录下添加新文件，Git 会视而不见。

::

  $ echo hello >> doc2/readme.txt 
  $ git status
  # On branch master
  nothing to commit (working directory clean)

若此时通过取消 `core.sparseCheckout` 配置变量的设置而关闭稀疏检出，也不会改变目录 `doc2` 下的文件的 `skip-worktree` 标识符。这种情况或者通过 `git update-index --no-skip-worktree -- <file>...` 来更改 index 中对应文件的 `skip-worktree` 标识符状态，或者重新启用稀疏检出更改相应文件的检出状态。

在克隆一个版本库时只希望检出部分文件或目录，可以在执行克隆操作的时候使用 `--no-checkout` 或 `-n` 参数，不进行工作区文件的检出。例如下面的操作从前面示例的 sparse1 版本库克隆到 `sparse2` 中，不进行工作区文件的检出。

::

  $ git clone -n sparse1 sparse2
  Cloning into sparse2...
  done.

检出完成后可以发现 `sparse2` 的工作区是空的，而且版本库中也不存在 `index` 文件。如果执行 `git status` 命令会看到所有文件都被标识为删除。

::

  $ cd sparse2
  $ git status -s
  D  doc1/readme.txt
  D  doc2/readme.txt
  D  doc3/readme.txt

如果希望通过稀疏检出的功能，只检出其中一个目录如 `doc2` ，可以用如下方法实现：

::

  $ git config core.sparseCheckout true
  $ printf "doc2\n" > .git/info/sparse-checkout 
  $ git checkout

之后看到工作区中检出了 `doc2` 目录，而其他文件被设置了 `skip-worktree` 标识。

::

  $ ls -F
  doc2/
  $ git ls-files -v
  S doc1/readme.txt
  H doc2/readme.txt
  S doc3/readme.txt
