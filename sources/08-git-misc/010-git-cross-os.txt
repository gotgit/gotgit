跨平台操作Git
****************

读者是在什么平台（操作系统）中使用Git呢？图40-1是网上一个Git调查结果的截\
图，从中可以看出排在前三位的是：Linux、Mac OS X和Windows。而Windows用户\
中又以使用msysGit的用户居多。

.. figure:: /images/git-misc/git-survs-os.png
   :scale: 80

   图40-1：Git用户操作系统使用分布图（摘自：http://www.survs.com/results/33Q0OZZE/MV653KSPI2）

在如今手持设备争夺激烈的年代，进行软件开发工作在什么操作系统上已经变得不\
那么重要了，很多手持设备都提供可以运行在各种主流操作系统的虚拟器，因此一\
个项目团队的成员根据各自习惯，可能使用不同的操作系统。当一个团队中不同成\
员在不同平台中使用Git进行交互时，可能会遇到平台兼容性问题。

即使团队成员都在同一种操作系统上工作（如Windows），但是Git服务器可能架设\
在另外的平台上（如Linux），也同样会遇到平台兼容性问题。

.. toctree::
   :maxdepth: 2

   020-git-charset
   030-case-insensitive
   040-eol
