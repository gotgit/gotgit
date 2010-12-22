冲突解决
********

上一章介绍了 Git 协议，并且使用本地协议来模拟一个远程的版本库，两个不同的用户检出该版本库，和该远程版本库进行交互，交换数据、协同工作。在上一章的协同中只遇到了一个小小的麻烦 —— 非快进式推送，可以通过先执行 PULL（拉回）操作，成功完成合并后再推送。

但是在真实的运行环境中，用户间协同并不总是会一帆风顺，只要有合并就可能会有冲突。本章就重点介绍冲突解决机制。

拉回操作中的合并
================

为了降低难度，上一章实践中用户 user1 执行 `git pull` 操作解决非快进式推送问题非常简单，就好像直接把共享式版本库中更新的提交直接拉回本地，然后就可以推送了，其它事情好像什么都没有发生一样。真的是这样么？

* 用户 user1 向共享版本库推送时，因为 user2 强制推送已经改变了共享版本库中的提交状态，导致 user1 推送失败。

  .. figure:: images/gitbook/git-merge-pull-1.png
     :scale: 100

* 用户 user1 执行 PULL 操作的第一阶段，将共享版本库 master 分支的最新提交拉回到本地，并更新本地版本库特定的引用中 `refs/remotes/origin/master` （简称为 `origin/master` ）。

  .. figure:: images/gitbook/git-merge-pull-2.png
     :scale: 100

* 用户 user1 执行 PULL 操作的第二阶段，将本地分支 master 和共享版本库本地关联分支 `origin/master` 进行合并操作。

  .. figure:: images/gitbook/git-merge-pull-3.png
     :scale: 100

* 用户 user1 执行 PUSH 操作，将本地提交推送到共享版本库中。

  .. figure:: images/gitbook/git-merge-pull-4.png
     :scale: 100

实际上拉回（PULL）操作是由两个步骤组成的，一个是获取（FETCH）操作，一个是合并（MERGE）操作。即：

::

  git pull = git fetch + git merge

获取（FETCH）操作很简单，


远程版本库他人的提交拉过来
合并并非总会


冲突的类型

    未引发冲突
    冲突的自动解决（成功）
    冲突的自动解决（逻辑冲突）
    真正的冲突（手动解决）
    因为文件重命名引发的冲突。到底改名不改名？（SVN 中叫做树冲突）

冲突解决（手动）

冲突解决（mergetool）

    kdiff3

merge 操作的策略

    ours
    theirs
    recursive
    ocutpus

