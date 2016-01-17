搭建Git服务器
##############

团队协作就涉及到搭建Git服务器。

搭建Git服务器可以非常简单，例如直接将Git裸版本库“扔到”Web服务器中作为一个共享目录，\
或者运行\ ``git daemon``\ 命令，甚至只需要轻点一下鼠标\ [#]_\ 就可以迅速将自己的版本库\
设置为只读共享。利用这个技术可以在团队中创建一个基于拉拽（pull）操作的Git工作流。

如果需要一个支持“写”操作的Git服务器，常用的方案包括使用Git本身提供的\ ``TODO CGI``\
实现的智能HTTP服务，或者使用\ ``Gitolite``\ 提供基于SSH协议的支持精细读写授权的Git服务器。

安卓（Android）项目以Git做版本控制，但其工作模式非常特殊，提交操作产生的“补丁”\
先要在一个Web平台上做代码审核，审核通过才合并到Git版本库中。谷歌开源了这个代码审核平台，\
称为Gerrit。在第 TODO 章将会介绍Gerrit服务器搭建和工作流程。

不过您可能不必去亲手搭建Git服务器，因为有GitHub\ [#]_\ 。GitHub是开源软件的大本营，\
为开源软件提供免费的版本库托管和社交编程服务，并且还提供Git版本库的商业托管服务。\
类似GitHub的Git版本库托管服务提供商还有很多（如Bitbucket\ [#]_\ 、国内的GitCafe\ [#]_\ 、\
GitShell\ [#]_\ 、CSDN-Code\ [#]_\ 、开源中国\ [#]_\ 等），您可以根据需要进行选择。

想在本地搭建一个GitHub克隆？至少有两个开源软件GitLab\ [#]_ \和Gitorious\ [#]_ \
可供选择，它们都提供了GitHub相仿的功能。在第 TODO 章介绍用GitLab在本地搭建专有的GitHub服务。

目录:

.. toctree::
   :maxdepth: 3

   010-http
   020-git
   030-ssh
   040-gitolite
   050-gitosis
   055-gerrit
   060-github-like


.. [#] 在TortoiseGit中只需要点击右键菜单中的“Git Daemon”。
.. [#] https://github.com
.. [#] https://bitbucket.org
.. [#] https://gitcafe.com
.. [#] https://gitshell.com
.. [#] https://code.csdn.net
.. [#] http://git.oschina.net
.. [#] http://gitlab.org
.. [#] https://gitorious.org
