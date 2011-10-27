Git的其它应用
#####################

Git 的伟大之处，还在于它不仅仅是作为版本库控制系统。Linus Torvalds 对自己最初设计的 Git 原型是这么评价的：Git 是一系列的底层工具用于内容的追踪，基于 Git 可以实现一个版本控制系统。现在 Git 已经是一个最成功的版本控制系统了，而基于 Git 的其他应用才刚刚开始。

维基是使用格式文本编辑网页，协同网页编辑的工具，又称为 “Web 的版本控制”。在 http://www.mzlinux.org/node/116 可以看到一份用 Git 作为后端实现的维基列表（大部分是技术上的试验）。

SpaghettiFS 项目尝试用 Git 作为数据存储后端提供了一个用户空间的文件系统（FUSE, Filesystem in Userspace）。而另外的一些项目 gitfs 可以直接把 Git 版本库挂载为文件系统。

下面的章节，通过几个典型应用介绍 Git 在版本控制领域之外的应用，可以领略到 Git 的神奇。


目录:

.. toctree::
   :maxdepth: 3

   010-etckeeper
   020-gistore
   030-binary-diff
   040-cloud-storage
