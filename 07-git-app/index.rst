Git的其它应用
#####################

Git的伟大之处，还在于它不仅仅是作为版本库控制系统。Linus Torvalds对自己\
最初设计的Git原型是这么评价的：Git是一系列的底层工具用于内容的追踪，基于\
Git可以实现一个版本控制系统。现在Git已经是一个最成功的版本控制系统了，而\
基于Git的其他应用才刚刚开始。

维基是使用格式文本编辑网页，协同网页编辑的工具，又称为“Web的版本控制”。\
在\ http://www.mzlinux.org/node/116\ 可以看到一份用Git作为后端实现的维基\
列表（大部分是技术上的试验）。

SpaghettiFS项目尝试用Git作为数据存储后端提供了一个用户空间的文件系统\
（FUSE、Filesystem in Userspace）。而另外的一些项目gitfs可以直接把Git\
版本库挂载为文件系统。

下面的章节，通过几个典型应用介绍Git在版本控制领域之外的应用，可以领略到\
Git的神奇。


目录:

.. toctree::
   :maxdepth: 3

   010-etckeeper
   020-gistore
   030-binary-diff
   040-cloud-storage
