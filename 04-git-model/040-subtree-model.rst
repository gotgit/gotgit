子树合并协同模型
================
上游版本库作为子目录


kernel.org > Pub > Software > Scm > Git > Docs > Howto > Using-merge-subtree <http://www.kernel.org/pub/software/scm/git/docs/howto/using-merge-subtree.html>



命令

::

    $ git remote add -f Bproject /path/to/B (1)
    $ git merge -s ours --no-commit Bproject/master (2)
    $ git read-tree --prefix=dir-B/ -u Bproject/master (3)
    $ git commit -m "Merge B project as our subdirectory" (4)
    $ git pull -s subtree Bproject master (5)

