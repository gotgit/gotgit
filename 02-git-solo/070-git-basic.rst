Git基本操作
**********************

之前的实践选取的示例都非常简单，基本上都是增加和修改文本文件，而现实情况\
要复杂的多，需要应对各种情况：文件删除，文件复制，文件移动，目录的组织，\
二进制文件，误删文件的恢复等等。

本章要用一个更为真实的例子：通过对\ ``Hello World``\ 程序源代码的版本控制，\
来介绍工作区中其他的一些常用操作。首先会删除之前历次实践在版本库中留下的\
“垃圾”数据，然后再在其中创建一些真实的代码，并对其进行版本控制。

先来合个影
==========

马上就要和之前实践遗留的数据告别了，告别之前是不是要留个影呢？在Git里，\
“留影”用的命令叫做\ :command:`tag`\ ，更加专业的术语叫做“里程碑”（打tag，\
或打标签）。

::

  $ cd /path/to/my/workspace/demo
  $ git tag -m "Say bye-bye to all previous practice." old_practice

在本章还不打算详细介绍里程碑的奥秘，只要知道里程碑无非也是一个引用，\
通过记录提交ID（或者创建Tag对象）来为当前版本库状态进行“留影”。

::

  $ ls .git/refs/tags/old_practice
  .git/refs/tags/old_practice

  $ git rev-parse refs/tags/old_practice
  41bd4e2cce0f8baa9bb4cdda62927b408c846cd6

留过影之后，可以执行\ :command:`git describe`\ 命令显示当前版本库的最新\
提交的版本号。显示的时候会选取离该提交最近的里程碑作为“基础版本号”，后面\
附加标识距离“基础版本”的数字以及该提交的SHA1哈希值缩写。因为最新的提交上\
恰好被打了一个“里程碑”，所以用“里程碑”的名字显示为版本号。这个技术在后面\
的示例代码中被使用。

::

  $ git describe
  old_practice

删除文件
========

看看版本库当前的状态，暂存区和工作区都包含修改。

::

  $ git status -s
  A  hack-1.txt
   M welcome.txt

在这个暂存区和工作区都包含文件修改的情况下，使用删除命令更具有挑战性。\
删除命令有多种使用方法，有的方法很巧妙，而有的方法需要更多的输入。为了\
分别介绍不同的删除方法，还要使用上一章介绍的进度保存\
（\ :command:`git-stash`\ ）命令。

* 保存进度。

  ::

    $ git stash
    Saved working directory and index state WIP on master: 2b31c19 Merge commit 'acc2f69'
    HEAD is now at 2b31c19 Merge commit 'acc2f69'

* 再恢复进度。注意不要使用\ :command:`git stash pop`\ ，而是使用\
  :command:`git stash apply`\ ，因为这个保存的进度要被多次用到。

  ::

    $ git stash apply
    # On branch master
    # Changes to be committed:
    #   (use "git reset HEAD <file>..." to unstage)
    #
    #       new file:   hack-1.txt
    #
    # Changed but not updated:
    #   (use "git add <file>..." to update what will be committed)
    #   (use "git checkout -- <file>..." to discard changes in working directory)
    #
    #       modified:   welcome.txt
    #

本地删除不是真的删除
--------------------

当前工作区的文件有：

::

  $ ls
  detached-commit.txt
  hack-1.txt
  new-commit.txt
  welcome.txt

直接在工作区删除这些文件，会如何呢？

::

  $ rm *.txt

通过下面的命令，可以看到在暂存区（版本库）中文件仍在，并未删除。

::

  $ git ls-files
  detached-commit.txt
  hack-1.txt
  new-commit.txt
  welcome.txt

通过文件的状态来看，文件只是在本地进行了删除，尚未加到暂存区（提交任务）\
中。也就是说：\ **直接在工作区删除，对暂存区和版本库没有任何影响**\ 。

::

  $ git status
  # On branch master
  # Changes to be committed:
  #   (use "git reset HEAD <file>..." to unstage)
  #
  #       new file:   hack-1.txt
  #
  # Changed but not updated:
  #   (use "git add/rm <file>..." to update what will be committed)
  #   (use "git checkout -- <file>..." to discard changes in working directory)
  #
  #       deleted:    detached-commit.txt
  #       deleted:    hack-1.txt
  #       deleted:    new-commit.txt
  #       deleted:    welcome.txt
  #

从Git状态输出可以看出，本地删除如果要反映在暂存区中应该用\ :command:`git rm`\
命令，对于不想删除的文件执行\ :command:`git checkout -- <file>`\
可以让文件在工作区重现。

执行\ :command:`git rm`\ 命令删除文件
-------------------------------------------

好吧，按照上面状态输出的内容，将所有的文本文件删除。执行下面的命令。

::

  $ git rm detached-commit.txt hack-1.txt new-commit.txt welcome.txt
  rm 'detached-commit.txt'
  rm 'hack-1.txt'
  rm 'new-commit.txt'
  rm 'welcome.txt'

再看一看状态：

::

  $ git status
  # On branch master
  # Changes to be committed:
  #   (use "git reset HEAD <file>..." to unstage)
  #
  #       deleted:    detached-commit.txt
  #       deleted:    new-commit.txt
  #       deleted:    welcome.txt
  #

删除动作加入了暂存区。这时执行提交动作，就真正意义上执行了文件删除。

::

  $ git commit -m "delete trash files. (using: git rm)"
  [master 483493a] delete trash files. (using: git rm)
   1 files changed, 0 insertions(+), 2 deletions(-)
   delete mode 100644 detached-commit.txt
   delete mode 100644 new-commit.txt
   delete mode 100644 welcome.txt

不过不要担心，文件只是在版本库最新提交中删除了，在历史提交中尚在。可以\
通过下面命令查看历史版本的文件列表。

::

  $ git ls-files --with-tree=HEAD^
  detached-commit.txt
  new-commit.txt
  welcome.txt

也可以查看在历史版本中尚在的删除文件的内容。

::

  $ git cat-file -p HEAD^:welcome.txt
  Hello.
  Nice to meet you.

命令\ :command:`git add -u`\ 快速标记删除
--------------------------------------------

在前面执行\ :command:`git rm`\ 命令时，一一写下了所有要删除的文件名，\
好长的命令啊！能不能简化些？实际上\ :command:`git add`\ 可以，即使用\
``-u``\ 参数调用\ :command:`git add`\ 命令，含义是将本地有改动（包括添加\
和删除）的文件标记为删除。为了重现刚才的场景，先使用重置命令抛弃最新的提交，\
再使用进度恢复到之前的状态。

* 丢弃之前测试删除的试验性提交。

  ::

    $ git reset --hard HEAD^
    HEAD is now at 2b31c19 Merge commit 'acc2f69'

* 恢复保存的进度。（参数\ ``-q``\ 使得命令进入安静模式）

  ::

    $ git stash apply -q

然后删除本地文件，状态依然显示只在本地删除了文件，暂存区文件仍在。

::

  $ rm *.txt
  $ git status -s
   D detached-commit.txt
  AD hack-1.txt
   D new-commit.txt
   D welcome.txt

执行\ :command:`git add -u`\ 命令可以将（被版本库追踪的）本地文件的变更\
（修改、删除）全部记录到暂存区中。

::

  $ git add -u

查看状态，可以看到工作区删除的文件全部被标记为下次提交时删除。

::

  $ git status -s
  D  detached-commit.txt
  D  new-commit.txt
  D  welcome.txt

执行提交，删除文件。

::

  $ git commit -m "delete trash files. (using: git add -u)"
  [master 7161977] delete trash files. (using: git add -u)
   1 files changed, 0 insertions(+), 2 deletions(-)
   delete mode 100644 detached-commit.txt
   delete mode 100644 new-commit.txt
   delete mode 100644 welcome.txt

恢复删除的文件
==============

经过了上面的文件删除，工作区已经没有文件了。为了说明文件移动，现在恢复一\
个删除的文件。前面已经说过执行了文件删除并提交，只是在最新的提交中删除了\
文件，历史提交中文件仍然保留，可以从历史提交中提取文件。执行下面的命令可\
以从历史（前一次提交）中恢复\ :file:`welcome.txt`\ 文件。

::

  $ git cat-file -p HEAD~1:welcome.txt > welcome.txt

上面命令中出现的\ ``HEAD~1``\ 即相当于\ ``HEAD^``\ 都指的是HEAD的上一次\
提交。执行\ :command:`git add -A`\ 命令会对工作区中所有改动以及新增文件\
添加到暂存区，也是一个常用的技巧。执行下面的命令后，将恢复过来的\
:file:`welcome.txt`\ 文件添加回暂存区。

::

  $ git add -A
  $ git status -s
  A  welcome.txt

执行提交操作，文件\ :file:`welcome.txt`\ 又回来了。

::

  $ git commit -m "restore file: welcome.txt"
  [master 63992f0] restore file: welcome.txt
   1 files changed, 2 insertions(+), 0 deletions(-)
   create mode 100644 welcome.txt

通过再次添加的方式恢复被删除的文件是最自然的恢复的方法。其他版本控制系统\
如CVS也采用同样的方法恢复删除的文件，但是有的版本控制系统如Subversion如\
果这样操作会有严重的副作用——文件变更历史被人为的割裂而且还会造成服务器存\
储空间的浪费。Git通过添加方式反删除文件没有副作用，这是因为在Git的版本库\
中相同内容的文件保存在一个blob对象中，而且即便是内容不同的blob对象在对象\
库打包整理过程中也会通过差异比较优化存储。

移动文件
========

通过将\ :file:`welcome.txt`\ 改名为\ :file:`README`\ 文件来测试一下在Git\
中如何移动文件。Git提供了\ :command:`git mv`\ 命令完成改名操作。

::

  $ git mv welcome.txt README

可以从当前的状态中看到改名的操作。

::

  $ git status
  # On branch master
  # Changes to be committed:
  #   (use "git reset HEAD <file>..." to unstage)
  #
  #       renamed:    welcome.txt -> README
  #

提交改名操作，在提交输出可以看到改名前后两个文件的相似度（百分比）。

::

  $ git commit -m "改名测试"
  [master 7aa5ac1] 改名测试
   1 files changed, 0 insertions(+), 0 deletions(-)
   rename welcome.txt => README (100%)

**可以不用\ :command:`git mv`\ 命令实现改名**

从提交日志中出现的文件相似度可以看出Git的改名实际上源自于Git对文件追踪的\
强大支持（文件内容作为blob对象保存在对象库中）。改名操作实际上相当于对旧\
文件执行删除，对新文件执行添加，即完全可以不使用\ :command:`git mv`\
操作，而是代之以\ :command:`git rm`\ 和一个\ :command:`git add`\ 操作。\
为了试验不使用\ :command:`git mv`\ 命令是否可行，先撤销之前进行的提交。

* 撤销之前测试文件移动的提交。

  ::

    $ git reset --hard HEAD^
    HEAD is now at 63992f0 restore file: welcome.txt

* 撤销之后\ :file:`welcome.txt`\ 文件又回来了。

  ::

    $ git status -s
    $ git ls-files
    welcome.txt

新的改名操作不使用\ :command:`git mv`\ 命令，而是直接在本地改名（文件移\
动），将\ :file:`welcome.txt` 改名为\ :file:`README`\ 。

::

  $ mv welcome.txt README
  $ git status -s
   D welcome.txt
  ?? README

为了考验一下Git的内容追踪能力，再修改一下改名后的 README 文件，即在文件\
末尾追加一行。

::

  $ echo "Bye-Bye." >> README 

可以使用前面介绍的\ :command:`git add -A`\ 命令。相当于对修改文件执行\
:command:`git add`\ ，对删除文件执行\ :command:`git rm`\ ，而且对本地\
新增文件也执行\ :command:`git add`\ 。

::

  $ git add -A

查看状态，也可以看到文件重命名。

::

  $ git status
  # On branch master
  # Changes to be committed:
  #   (use "git reset HEAD <file>..." to unstage)
  #
  #       renamed:    welcome.txt -> README
  #

执行提交。

::

  $ git commit -m "README is from welcome.txt."
  [master c024f34] README is from welcome.txt.
   1 files changed, 1 insertions(+), 0 deletions(-)
   rename welcome.txt => README (73%)

这次提交中也看到了重命名操作，但是重命名相似度不是 100%，而是 73%。

一个显示版本号的\ ``Hello World``
==================================

在本章的一开始为纪念前面的实践留了一个影，叫做\ ``old_practice``\ 。\
现在再次执行\ :command:`git describe`\ 看一下现在的版本号。

::

  $ git describe
  old_practice-3-gc024f34

就是说：当前工作区的版本是“留影”后的第三个版本，提交ID是\ ``c024f34``\ 
。

下面的命令可以在提交日志中显示提交对应的里程碑（Tag）。其中参数\
``--decorate``\ 可以在提交ID的旁边显示该提交关联的引用（里程碑或分支）。

::

  $ git log --oneline --decorate -4
  c024f34 (HEAD, master) README is from welcome.txt.
  63992f0 restore file: welcome.txt
  7161977 delete trash files. (using: git add -u)
  2b31c19 (tag: old_practice) Merge commit 'acc2f69'

命令\ :command:`git describe`\ 的输出可以作为软件版本号，这个功能非常有\
用。因为这样可以很容易的实现将发布的软件包版本和版本库中的代码对应在一起，\
当发现软件包包含Bug时，可以最快、最准确的对应到代码上。

下面的\ ``Hello World``\ 程序就实现了这个功能。创建目录\ :file:`src`\ ，\
并在\ :file:`src`\ 目录下创建下面的三个文件：

* 文件：\ :file:`src/main.c`

  没错，下面的几行就是这个程序的主代码，和输出相关代码的就两行，一行显示\
  “Hello, world.”，另外一行显示软件版本。在显示软件版本时用到了宏\
  ``_VERSION``\ ，这个宏的来源参考下一个文件。

  源代码：

    ::

      #include "version.h"
      #include <stdio.h>

      int
      main()
      {
          printf( "Hello, world.\n" );
          printf( "version: %s.\n", _VERSION );
          return 0;
      }

* 文件：\ :file:`src/version.h.in`

  没错，这个文件名的后缀是\ :file:`.h.in`\ 。这个文件其实是用于生成文件\
  :file:`version.h`\ 的模板文件。在由此模板文件生成的\ :file:`version.h`\
  的过程中，宏\ ``_VERSION``\ 的值 “<version>” 会动态替换。

  源代码：

    ::

      #ifndef HELLO_WORLD_VERSION_H
      #define HELLO_WORLD_VERSION_H

      #define _VERSION "<version>"

      #endif

* 文件：\ :file:`src/Makefile`

  这个文件看起来很复杂，而且要注意所有缩进都是使用一个\ ``<Tab>``\
  键完成的缩进，千万不要错误的写成空格，因为这是\ :file:`Makefile`\ 。\
  这个文件除了定义如何由代码生成可执行文件\ :file:`hello`\ 之外，还定义\
  了如何将模板文件\ :file:`version.h.in`\ 转换为\ :file:`version.h`\ 。\
  在转换过程中用\ :command:`git describe`\ 命令的输出替换模板文件中的\
  ``<version>``\ 字符串。

  源代码：

    ::

      OBJECTS = main.o
      TARGET = hello

      all: $(TARGET)

      $(TARGET): $(OBJECTS)
              $(CC) -o $@ $^

      main.o: | new_header
      main.o: version.h

      new_header:
              @sed -e "s/<version>/$$(git describe)/g" \
                      < version.h.in > version.h.tmp
              @if diff -q version.h.tmp version.h >/dev/null 2>&1; \
              then \
                      rm version.h.tmp; \
              else \
                      echo "version.h.in => version.h" ; \
                      mv version.h.tmp version.h; \
              fi

      clean:
              rm -f $(TARGET) $(OBJECTS) version.h

      .PHONY: all clean


上述三个文件创建完毕之后，进入到\ :file:`src`\ 目录，试着运行一下。先执\
行\ :command:`make`\ 编译，再运行编译后的程序\ :command:`hello`\ 。

::

  $ cd src
  $ make
  version.h.in => version.h
  cc    -c -o main.o main.c
  cc -o hello main.o
  $ ./hello 
  Hello, world.
  version: old_practice-3-gc024f34.

使用\ :command:`git add -i`\ 选择性添加
========================================

刚刚创建的\ ``Hello World``\ 程序还没有添加到版本库中，在\ :file:`src`\
目录下有下列文件：

::

  $ cd /path/to/my/workspace/demo
  $ ls src
  hello  main.c  main.o  Makefile  version.h  version.h.in

这些文件中\ :file:`hello`\,\ :file:`main.o`\ 和\ :file:`version.h`\ 都是\
在编译时生成的程序，不应该加入到版本库中。那么选择性添加文件除了针对文件\
逐一使用\ :command:`git add`\ 命令外，还有什么办法么？通过使用\ ``-i``\
参数调用\ :command:`git add`\ 就是一个办法，提供了一个交互式的界面。

执行\ :command:`git add -i`\ 命令，进入一个交互式界面，首先显示的是工作\
区状态。显然因为版本库进行了清理，所以显得很“干净”。

::

  $ git add -i
             staged     unstaged path


  *** Commands ***
    1: status       2: update       3: revert       4: add untracked
    5: patch        6: diff         7: quit         8: help
  What now> 


在交互式界面显示了命令列表，可以使用数字或者加亮显示的命令首字母，选择相\
应的功能。对于此例需要将新文件加入到版本库，所以选择“4”。

::

  What now> 4
    1: src/Makefile
    2: src/hello
    3: src/main.c
    4: src/main.o
    5: src/version.h
    6: src/version.h.in
  Add untracked>>

当选择了“4”之后，就进入了“Add untracked”界面，显示了本地新增（尚不再版本\
库中）的文件列表，而且提示符也变了，由“What now>”变为“Add untracked>>”。\
依次输入1、3、6将源代码添加到版本库中。

* 输入“1”：

  ::

    Add untracked>> 1
    * 1: src/Makefile
      2: src/hello
      3: src/main.c
      4: src/main.o
      5: src/version.h
      6: src/version.h.in

* 输入“3”：

  ::

    Add untracked>> 3
    * 1: src/Makefile
      2: src/hello
    * 3: src/main.c
      4: src/main.o
      5: src/version.h
      6: src/version.h.in

* 输入“6”：

  ::

    Add untracked>> 6
    * 1: src/Makefile
      2: src/hello
    * 3: src/main.c
      4: src/main.o
      5: src/version.h
    * 6: src/version.h.in
    Add untracked>> 

每次输入文件序号，对应的文件前面都添加一个星号，代表将此文件添加到暂存区。\
在提示符“Add untracked>>”处按回车键，完成文件添加，返回主界面。

::

  Add untracked>>
  added 3 paths

  *** Commands ***
    1: status       2: update       3: revert       4: add untracked
    5: patch        6: diff         7: quit         8: help
  What now> 

此时输入“1”查看状态，可以看到三个文件添加到暂存区中。

::

  What now> 1
             staged     unstaged path
    1:       +20/-0      nothing src/Makefile
    2:       +10/-0      nothing src/main.c
    3:        +6/-0      nothing src/version.h.in

  *** Commands ***
    1: status       2: update       3: revert       4: add untracked
    5: patch        6: diff         7: quit         8: help

输入“7”退出交互界面。

查看文件状态，可以发现三个文件被添加到暂存区中。

::

  $ git status -s
  A  src/Makefile
  A  src/main.c
  A  src/version.h.in
  ?? src/hello
  ?? src/main.o
  ?? src/version.h

完成提交。

::

  $ git commit -m "Hello world initialized."
  [master d71ce92] Hello world initialized.
   3 files changed, 36 insertions(+), 0 deletions(-)
   create mode 100644 src/Makefile
   create mode 100644 src/main.c
   create mode 100644 src/version.h.in

``Hello world``\ 引发的新问题
=================================

进入\ :file:`src`\ 目录中，对\ ``Hello world``\ 执行编译。

::

  $ cd /path/to/my/workspace/demo/src
  $ make clean && make
  rm -f hello main.o version.h
  version.h.in => version.h
  cc    -c -o main.o main.c
  cc -o hello main.o

运行编译后的程序，是不是对版本输出不满意呢？

::

  $ ./hello
  Hello, world.
  version: old_practice-4-gd71ce92.

之所以显示长长的版本号，是因为使用了在本章最开始留的“影”。现在为\
``Hello world``\ 留下一个新的“影”（一个新的里程碑）吧。

::

  $ git tag -m "Set tag hello_1.0." hello_1.0

然后清除上次编译结果后，重新编译和运行，可以看到新的输出。

::

  $ make clean && make
  rm -f hello main.o version.h
  version.h.in => version.h
  cc    -c -o main.o main.c
  cc -o hello main.o
  $ ./hello 
  Hello, world.
  version: hello_1.0.

还不错，显示了新的版本号。此时在工作区查看状态，会发现工作区“不干净”。

::

  $ git status
  # On branch master
  # Untracked files:
  #   (use "git add <file>..." to include in what will be committed)
  #
  #       hello
  #       main.o
  #       version.h

编译的目标文件和以及从模板生成的头文件出现在了Git的状态输出中，这些文件\
会对以后的工作造成干扰。当写了新的源代码文件需要添加到版本库中时，因为这\
些干扰文件的存在，不得不一一将这些干扰文件排除在外。更为严重的是，如果不\
小心执行\ :command:`git add .`\ 或者\ :command:`git add -A`\ 命令会将编\
译的目标文件及其他临时文件加入版本库中，浪费存储空间不说甚至还会造成冲突。

Git提供了文件忽略功能，可以解决这个问题。

文件忽略
========

Git提供了文件忽略功能。当对工作区某个目录或者某些文件设置了忽略后，再执行\
:command:`git status`\ 查看状态时，被忽略的文件即使存在也不会显示为未跟踪\
状态，甚至根本感觉不到这些文件的存在。现在就针对\ ``Hello world``\ 程序\
目录试验一下。

::

  $ cd /path/to/my/workspace/demo/src
  $ git status -s
  ?? hello
  ?? main.o
  ?? version.h

可以看到\ :file:`src`\ 目录下编译的目标文件等显示为未跟踪，每一行开头的\
两个问号好像在向我们请求：“快把我们添加到版本库里吧”。

执行下面的命令可以在这个目下创建一个名为\ :file:`.gitignore`\ 的文件\
（注意文件的前面有个点），把这些要忽略的文件写在其中，文件名可以使用\
通配符。注意：第2行到第5行开头的右尖括号是\ :command:`cat`\ 命令的提示符，\
不是输入。

::

  $ cat > .gitignore << EOF
  > hello
  > *.o
  > *.h
  > EOF

看看写好的\ :file:`.gitignore`\ 文件。每个要忽略的文件显示在一行。

::

  $ cat .gitignore 
  hello
  *.o
  *.h

再来看看当前工作区的状态。

::

  $ git status -s
  ?? .gitignore

把\ :file:`.gitignore`\ 文件添加到版本库中吧。（如果不希望添加到库里，也\
不希望\ :file:`.gitignore`\ 文件带来干扰，可以在忽略文件中忽略自己。）

::

  $ git add .gitignore
  $ git commit -m "ignore object files."
  [master b3af728] ignore object files.
   1 files changed, 3 insertions(+), 0 deletions(-)
   create mode 100644 src/.gitignore

**\ :file:`.gitignore`\ 文件可以放在任何目录**

文件\ :file:`.gitignore`\ 的作用范围是其所处的目录及其子目录，因此如果把\
刚刚创建的\ :file:`.gitignore`\ 移动到上一层目录（仍位于工作区内）也应该\
有效。

::

  $ git mv .gitignore ..
  $ git status
  # On branch master
  # Changes to be committed:
  #   (use "git reset HEAD <file>..." to unstage)
  #
  #       renamed:    .gitignore -> ../.gitignore
  #

果然移动\ :file:`.gitignore`\ 文件到上层目录，\ ``Hello world``\ 程序目录\
下的目标文件依然被忽略着。

提交。

::

  $ git commit -m "move .gitignore outside also works."
  [master 3488f2c] move .gitignore outside also works.
   1 files changed, 0 insertions(+), 0 deletions(-)
   rename src/.gitignore => .gitignore (100%)

**忽略文件有错误，后果很严重**

实际上面写的忽略文件不是非常好，为了忽略\ :file:`version.h`\ ，结果使用\
了通配符\ ``*.h``\ 会把源码目录下的有用的头文件也给忽略掉，导致应该添加\
到版本库的文件忘记添加。

在当前目录下创建一个新的头文件\ :file:`hello.h`\ 。

::

  $ echo "/* test */" > hello.h

在工作区状态显示中看不到\ :file:`hello.h`\ 文件。

::

  $ git status
  # On branch master
  nothing to commit (working directory clean)

只有使用了\ ``--ignored``\ 参数，才会在状态显示中看到被忽略的文件。

::

  $ git status --ignored -s
  !! hello
  !! hello.h
  !! main.o
  !! version.h

要添加\ :file:`hello.h`\ 文件，使用\ :command:`git add -A`\ 和\
:command:`git add .`\ 都失效。无法用这两个命令将\ :file:`hello.h`\ 添加到\
暂存区中。

::

  $ git add -A
  $ git add .
  $ git st -s

只有在添加操作的命令行中明确的写入文件名，并且提供\ ``-f``\ 参数才能真正\
添加。

::

  $ git add -f hello.h
  $ git commit -m "add hello.h"
  [master 48456ab] add hello.h
   1 files changed, 1 insertions(+), 0 deletions(-)
   create mode 100644 src/hello.h

**忽略只对未跟踪文件有效，对于已加入版本库的文件无效**

文件\ :file:`hello.h`\ 添加到版本库后，就不再受到\ :file:`.gitignore`\ 
设置的文件忽略影响了，对\ :file:`hello.h`\ 的修改都会立刻被跟踪到。这是\
因为Git的文件忽略只是对未入库的文件起作用。

::

  $ echo "/* end */" >> hello.h
  $ git status
  # On branch master
  # Changed but not updated:
  #   (use "git add <file>..." to update what will be committed)
  #   (use "git checkout -- <file>..." to discard changes in working directory)
  #
  #       modified:   hello.h
  #
  no changes added to commit (use "git add" and/or "git commit -a")

偷懒式提交。（使用了\ ``-a``\ 参数提交，不用预先执行\ :command:`git add`\ 命令。）

::

  $ git commit -a -m "偷懒了，直接用 -a 参数直接提交。"
  [master 613486c] 偷懒了，直接用 -a 参数直接提交。
   1 files changed, 1 insertions(+), 0 deletions(-)

**本地独享式忽略文件**

文件\ :file:`.gitignore`\ 设置的文件忽略是共享式的。之所以称其为“共享式”，\
是因为\ :file:`.gitignore`\ 被添加到版本库后成为了版本库的一部分，当版本库\
共享给他人（克隆）或者把版本库推送（PUSH）到集中式的服务器（或他人的版本库），\
这个忽略文件就会出现在他人的工作区中，文件忽略在他人的工作区中同样生效。

与“共享式”忽略对应的是“独享式”忽略。独享式忽略就是不会因为版本库共享或者\
版本库之间的推送传递给他人的文件忽略。独享式忽略有两种方式：

* 一种是针对具体版本库的“独享式”忽略。即在版本库\ :file:`.git`\ 目录下的\
  一个文件\ :file:`.git/info/exclude`\ 来设置文件忽略。

* 另外一种是全局的“独享式”忽略。即通过Git的配置变量\ ``core.excludesfile``\
  指定的一个忽略文件，其设置的忽略对所有文件均有效。

至于哪些情况需要通过向版本库中提交\ :file:`.gitignore`\ 文件设置共享式的\
文件忽略，哪些情况通过\ :file:`.git/info/exclude`\ 设置只对本地有效的\
独享式文件忽略，这取决于要设置的文件忽略是否具有普遍意义。如果文件忽略对于\
所有使用此版本库工作的人都有益，就通过在版本库相应的目录下创建一个\
:file:`.gitignore`\ 文件建立忽略，否则如果是需要忽略工作区中创建的一个试验\
目录或者试验性的文件，则使用本地忽略。

例如我的本地就设置着一个全局的独享的文件忽略列表（这个文件名可以随意设置）：

::

  $ git config --global core.excludesfile /home/jiangxin/_gitignore
  $ git config core.excludesfile
  /home/jiangxin/_gitignore

  $ cat /home/jiangxin/_gitignore
  *~        # vim 临时文件
  *.pyc     # python 的编译文件
  .*.mmx    # 不是正则表达式哦，因为 FreeMind-MMX 的辅助文件以点开头    

**Git忽略语法**

Git的忽略文件的语法规则再多说几句。

* 忽略文件中的空行或者以井号（#）开始的行被忽略。

* 可以使用通配符，参见Linux手册：glob(7)。例如：星号（*）代表任意多字符，\
  问号（?）代表一个字符，方括号（[abc]）代表可选字符范围等。

* 如果名称的最前面是一个路径分隔符（/），表明要忽略的文件在此目录下，\
  而非子目录的文件。

* 如果名称的最后面是一个路径分隔符（/），表明要忽略的是整个目录，同名\
  文件不忽略，否则同名的文件和目录都忽略。

* 通过在名称的最前面添加一个感叹号（!），代表不忽略。

下面的文件忽略示例，包含了上述要点：

::

  # 这是注释行 —— 被忽略
  *.a       # 忽略所有以 .a 为扩展名的文件。
  !lib.a    # 但是 lib.a 文件或者目录不要忽略，即使前面设置了对 *.a 的忽略。
  /TODO     # 只忽略根目录下的 TODO 文件，子目录的 TODO 文件不忽略。
  build/    # 忽略所有 build/ 目录下的文件。
  doc/*.txt # 忽略文件如 doc/notes.txt，但是文件如 doc/server/arch.txt 不被忽略。


文件归档
==========

如果使用压缩工具（tar、7zip、winzip、rar等）将工作区文件归档，一不小心会\
把版本库（\ :file:`.git`\ 目录）包含其中，甚至将工作区中的忽略文件、临时\
文件也包含其中。Git提供了一个归档命令：\ :command:`git archive`\ ，可以\
对任意提交对应的目录树建立归档。示例如下：

* 基于最新提交建立归档文件\ :file:`latest.zip`\ 。

  ::

    $ git archive -o latest.zip HEAD

* 只将目录\ :file:`src`\ 和\ :file:`doc`\ 建立到归档\ :file:`partial.tar`\ 中。

  ::

    $ git archive -o partial.tar  HEAD src doc

* 基于里程碑v1.0建立归档，并且为归档中文件添加目录前缀1.0。

  ::

    $ git archive --format=tar --prefix=1.0/ v1.0 | gzip > foo-1.0.tar.gz

在建立归档时，如果使用树对象ID进行归档，则使用当前时间作为归档中文件的修\
改时间，而如果使用提交ID或里程碑等，则使用提交建立的时间作为归档中文件的\
修改时间。

如果使用tar格式建立归档，并且使用提交ID或里程碑ID，还会把提交ID记录在归\
档文件的文件头中。记录在文件头中的提交ID可以通过\
:command:`git tar-commit-id`\ 命令获取。

如果希望在建立归档时忽略某些文件或目录，可以通过为相应文件或目录建立\
``export-ignore``\ 属性加以实现。具体参见本书第8篇第41章“41.1 属性”一节。
